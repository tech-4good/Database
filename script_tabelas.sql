create database tech4good;
use tech4good;


-- CRIAÇÃO DE TABELAS NA ORDEM CORRETA (BASTA RODAR SCRIPT COMPLETO)

CREATE TABLE endereco(
	id_endereco INT PRIMARY KEY,
    cep CHAR(8) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero INT NOT NULL,
    complemento VARCHAR(50),
    bairro VARCHAR(80),
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    moradia VARCHAR(50) NOT NULL,
    tipo_moradia VARCHAR(50) NOT NULL,
    data_entrada DATE NOT NULL,
    data_saida DATE,
    tipo_cesta VARCHAR(5) NOT NULL,
    status VARCHAR(30)
);

CREATE TABLE beneficiado(
	id_beneficiado INT,
	cpf CHAR(11) UNIQUE,
	nome VARCHAR(100) NOT NULL,
	rg VARCHAR(9) NOT NULL,
	data_nascimento DATE NOT NULL,
	naturalidade VARCHAR(50) NOT NULL,
	telefone VARCHAR(11) NOT NULL,
	estado_civil VARCHAR(30) NOT NULL,
	escolaridade VARCHAR(40) NOT NULL,
	profissao VARCHAR(50),
	renda_mensal DECIMAL(7,2),
	empresa VARCHAR(60),
	cargo VARCHAR(40),
	religiao VARCHAR(40),
	quantidade_dependentes INT NOT NULL,
	foto_beneficiado MEDIUMBLOB,
    fk_conjuge INT,
    fk_endereco INT,
    FOREIGN KEY (fk_conjuge) REFERENCES beneficiado(id_beneficiado),
    FOREIGN KEY (fk_endereco) REFERENCES endereco(id_endereco),
    PRIMARY KEY (id_beneficiado, cpf, fk_endereco)
);

CREATE TABLE auxilio_governamental(
	id_auxilio INT PRIMARY KEY,
	tipo VARCHAR(50)
);

CREATE TABLE beneficiado_has_auxilio(
	fk_auxilio INT,
	fk_id_beneficiado INT,
	fk_cpf CHAR(11),
    fk_endereco int,
	PRIMARY KEY (fk_auxilio, fk_id_beneficiado, fk_cpf, fk_endereco),
	FOREIGN KEY (fk_auxilio) REFERENCES auxilio_governamental(id_auxilio),
	FOREIGN KEY (fk_id_beneficiado, fk_cpf, fk_endereco) REFERENCES beneficiado(id_beneficiado, cpf, fk_endereco)
);

CREATE TABLE tipo_morador(
	id_tipo_morador INT PRIMARY KEY,
    quantidade_crianca INT,
    quantidade_adolescente INT,
    quantidade_jovem INT,
    quantidade_idoso INT,
    quantidade_gestante INT,
    quantidade_deficiente INT,
    quantidade_outros INT,
    fk_beneficiado INT,
    fk_cpf CHAR(11),
    fk_endereco INT,
    FOREIGN KEY (fk_beneficiado, fk_cpf) REFERENCES beneficiado(id_beneficiado, cpf),
    FOREIGN KEY (fk_endereco) REFERENCES endereco(id_endereco)
);

CREATE TABLE filho_beneficiado(
	id_filho_beneficiado INT,
    data_nascimento DATE NOT NULL,
    is_estudante BOOLEAN NOT NULL,
    has_creche BOOLEAN NOT NULL,
    fk_beneficiado INT,
    fk_cpf CHAR(11),
    fk_endereco INT,
    FOREIGN KEY (fk_beneficiado, fk_cpf, fk_endereco) REFERENCES beneficiado(id_beneficiado, cpf, fk_endereco),
    PRIMARY KEY (id_filho_beneficiado, fk_beneficiado, fk_cpf, fk_endereco)
);

CREATE TABLE fila_espera(
	id_fila INT PRIMARY KEY,
    data_entrada DATE NOT NULL,
    data_saida DATE,
    fk_endereco INT,
    FOREIGN KEY (fk_endereco) REFERENCES endereco(id_endereco)
);

CREATE TABLE voluntario(
	id_voluntario INT PRIMARY KEY,
    nome VARCHAR(100),
    cpf CHAR(11),
    telefone VARCHAR(11),
    senha VARCHAR(50),
    email VARCHAR(80),
    fk_administrador INT,
    FOREIGN KEY (fk_administrador) REFERENCES voluntario(id_voluntario)
);

CREATE TABLE cesta(
	id_cesta INT PRIMARY KEY,
    tipo VARCHAR(5) NOT NULL,
    peso_kg DECIMAL(3,2) NOT NULL,
    data_entrada DATE NOT NULL,
    quantidade_cesta INT
);

CREATE TABLE entrega(
	id_entrega INT,
    data_retirada DATE,
    proxima_retirada DATE,
    fk_voluntario INT,
	fk_endereco INT,
    fk_cesta INT,
    FOREIGN KEY (fk_voluntario) REFERENCES voluntario(id_voluntario),
    FOREIGN KEY (fk_endereco) REFERENCES endereco(id_endereco),
    FOREIGN KEY (fk_cesta) REFERENCES cesta(id_cesta)
);


-- CONSTRAINTS ADICIONAIS

ALTER TABLE beneficiado ADD CONSTRAINT CHK_estado_civil 
	CHECK (estado_civil IN ('SOLTEIRO', 'CASADO', 'VIÚVO', 'DIVORCIADO', 'SEPARADO JUDICIALMENTE'));