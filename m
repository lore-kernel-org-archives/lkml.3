Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab3AOVjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:39:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab3AOVjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:39:31 -0500
Date: Tue, 15 Jan 2013 16:37:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, zohar@linux.vnet.ibm.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com
Subject: [PATCH 4/3] User space utility "signelf" to sign elf executable
Message-ID: <20130115213751.GA18802@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is basic implementation of signelf utility. It can be used to sign an
ELF executable file.

A new section ".signature" is added to elf executable and signature of
executable are put there.

This is currently modeled on module signing and in fact imitates
scripts/sign-file script in kernel sources.

ELF parsing code I have taken from vmcore-dmesg.c in kexec project.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Makefile  |   21 +
 signelf.c | 1130 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1151 insertions(+)

Index: signelf/signelf.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ signelf/signelf.c	2013-01-18 02:27:41.000000000 -0500
@@ -0,0 +1,1130 @@
+/*
+ * signelf: Sign ELF executable
+ *
+ * Copyright (C) 2013 Vivek Goyal (vgoyal@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#define _BSD_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <getopt.h>
+#include <limits.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <byteswap.h>
+#include <elf.h>
+#include <openssl/evp.h>
+#include <openssl/pkcs7.h>
+#include <openssl/bio.h>
+#include <openssl/pem.h>
+#include <openssl/x509.h>
+#include <openssl/x509v3.h>
+#include <openssl/err.h>
+#include <openssl/rsa.h>
+#include <openssl/asn1.h>
+#include <endian.h>
+
+struct signelf_info {
+	char *in_file, *out_file, *privkey_file, *certificate_file;
+	Elf64_Ehdr ehdr;
+	Elf64_Phdr *phdr;
+	unsigned char md_value[EVP_MAX_MD_SIZE];
+	unsigned int md_len;
+	char *signer_name;
+	uint8_t *key_identifier;
+	unsigned int key_identifier_len;
+	/* Signature prefixed with signature len */
+	uint8_t *signature;
+	unsigned int signature_len;
+	/* Signature info */
+	char sig_info[64];
+	unsigned int sig_info_len;
+};
+
+/* digest prefixed with algo identifier. Used as input file for signing */
+char *temp_algo_ident_digest_file = "/tmp/signelf.algo_digest";
+
+/* signature file. output file of rsautl */
+char *tempsig_file = "/tmp/signelf.sig";
+
+/*
+ * Contains the full signature (including info) which gets into a section.
+ * objcopy uses it
+ */
+char *tempsigsection_file = "/tmp/signelf.sigsection";
+
+#define MD_BUF_SIZE	16384
+
+/* sha256 prologue */
+static char algo_ident_sha256[] = {
+		0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
+		0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
+		0x05, 0x00, 0x04, 0x20
+	};
+static unsigned int algo_ident_sha256_len = 19;
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define ELFDATANATIVE ELFDATA2LSB
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#define ELFDATANATIVE ELFDATA2MSB
+#else
+#error "Unknown machine endian"
+#endif
+
+static uint16_t file16_to_cpu(struct signelf_info *sinfo, uint16_t val)
+{
+	if (sinfo->ehdr.e_ident[EI_DATA] != ELFDATANATIVE)
+		val = bswap_16(val);
+	return val;
+}
+
+static uint32_t file32_to_cpu(struct signelf_info *sinfo, uint32_t val)
+{
+	if (sinfo->ehdr.e_ident[EI_DATA] != ELFDATANATIVE)
+		val = bswap_32(val);
+	return val;
+}
+
+static uint64_t file64_to_cpu(struct signelf_info *sinfo, uint64_t val)
+{
+	if (sinfo->ehdr.e_ident[EI_DATA] != ELFDATANATIVE)
+		val = bswap_64(val);
+	return val;
+}
+
+static int read_elf32(struct signelf_info *sinfo, int fd)
+{
+	Elf32_Ehdr ehdr32;
+	Elf32_Phdr *phdr32;
+	size_t phdrs32_size;
+	ssize_t ret = 0, i;
+
+	ret = pread(fd, &ehdr32, sizeof(ehdr32), 0);
+	if (ret != sizeof(ehdr32)) {
+		fprintf(stderr, "Read of Elf header failed: %s\n",
+			strerror(errno));
+		return 1;
+	}
+
+	sinfo->ehdr.e_type	= file16_to_cpu(sinfo, ehdr32.e_type);
+	sinfo->ehdr.e_machine	= file16_to_cpu(sinfo, ehdr32.e_machine);
+	sinfo->ehdr.e_version	= file32_to_cpu(sinfo, ehdr32.e_version);
+	sinfo->ehdr.e_entry	= file32_to_cpu(sinfo, ehdr32.e_entry);
+	sinfo->ehdr.e_phoff	= file32_to_cpu(sinfo, ehdr32.e_phoff);
+	sinfo->ehdr.e_shoff	= file32_to_cpu(sinfo, ehdr32.e_shoff);
+	sinfo->ehdr.e_flags	= file32_to_cpu(sinfo, ehdr32.e_flags);
+	sinfo->ehdr.e_ehsize	= file16_to_cpu(sinfo, ehdr32.e_ehsize);
+	sinfo->ehdr.e_phentsize= file16_to_cpu(sinfo, ehdr32.e_phentsize);
+	sinfo->ehdr.e_phnum	= file16_to_cpu(sinfo, ehdr32.e_phnum);
+	sinfo->ehdr.e_shentsize= file16_to_cpu(sinfo, ehdr32.e_shentsize);
+	sinfo->ehdr.e_shnum	= file16_to_cpu(sinfo, ehdr32.e_shnum);
+	sinfo->ehdr.e_shstrndx	= file16_to_cpu(sinfo, ehdr32.e_shstrndx);
+
+	if (sinfo->ehdr.e_version != EV_CURRENT) {
+		fprintf(stderr, "Bad Elf header version %u\n",
+			sinfo->ehdr.e_version);
+		return 1;
+	}
+	if (sinfo->ehdr.e_phentsize != sizeof(Elf32_Phdr)) {
+		fprintf(stderr, "Bad Elf progra header size %u expected %zu\n",
+			sinfo->ehdr.e_phentsize, sizeof(Elf32_Phdr));
+		return 1;
+	}
+	phdrs32_size = sinfo->ehdr.e_phnum * sizeof(Elf32_Phdr);
+	phdr32 = calloc(sinfo->ehdr.e_phnum, sizeof(Elf32_Phdr));
+	if (!phdr32) {
+		fprintf(stderr, "Calloc of %u phdrs32 failed: %s\n",
+			sinfo->ehdr.e_phnum, strerror(errno));
+		return 1;
+	}
+
+	sinfo->phdr = calloc(sinfo->ehdr.e_phnum, sizeof(Elf64_Phdr));
+	if (!sinfo->phdr) {
+		fprintf(stderr, "Calloc of %u phdrs failed: %s\n",
+			sinfo->ehdr.e_phnum, strerror(errno));
+		ret = 1;
+		goto out_free_phdr32;
+	}
+	ret = pread(fd, phdr32, phdrs32_size, sinfo->ehdr.e_phoff);
+	if (ret < 0 || (size_t)ret != phdrs32_size) {
+		fprintf(stderr, "Read of program header @ 0x%llu for %zu bytes failed: %s\n",
+			(unsigned long long)sinfo->ehdr.e_phoff, phdrs32_size, strerror(errno));
+		ret = 1;
+		goto out_free_phdr;
+	}
+	for (i = 0; i < sinfo->ehdr.e_phnum; i++) {
+		sinfo->phdr[i].p_type = file32_to_cpu(sinfo, phdr32[i].p_type);
+		sinfo->phdr[i].p_offset = file32_to_cpu(sinfo,
+						phdr32[i].p_offset);
+		sinfo->phdr[i].p_vaddr = file32_to_cpu(sinfo,
+						phdr32[i].p_vaddr);
+		sinfo->phdr[i].p_paddr = file32_to_cpu(sinfo,
+						phdr32[i].p_paddr);
+		sinfo->phdr[i].p_filesz = file32_to_cpu(sinfo,
+						phdr32[i].p_filesz);
+		sinfo->phdr[i].p_memsz = file32_to_cpu(sinfo,
+						phdr32[i].p_memsz);
+		sinfo->phdr[i].p_flags = file32_to_cpu(sinfo,
+						phdr32[i].p_flags);
+		sinfo->phdr[i].p_align = file32_to_cpu(sinfo,
+						phdr32[i].p_align);
+	}
+	free(phdr32);
+	return ret;
+
+out_free_phdr:
+	free(sinfo->phdr);
+out_free_phdr32:
+	free(phdr32);
+	return ret;
+}
+
+static int read_elf64(struct signelf_info *sinfo, int fd)
+{
+	Elf64_Ehdr ehdr64;
+	Elf64_Phdr *phdr64;
+	size_t phdrs_size;
+	ssize_t ret, i;
+
+	ret = pread(fd, &ehdr64, sizeof(ehdr64), 0);
+	if (ret < 0 || (size_t)ret != sizeof(sinfo->ehdr)) {
+		fprintf(stderr, "Read of Elf header failed: %s\n",
+			strerror(errno));
+		return 1;
+	}
+
+	sinfo->ehdr.e_type	= file16_to_cpu(sinfo, ehdr64.e_type);
+	sinfo->ehdr.e_machine	= file16_to_cpu(sinfo, ehdr64.e_machine);
+	sinfo->ehdr.e_version	= file32_to_cpu(sinfo, ehdr64.e_version);
+	sinfo->ehdr.e_entry	= file64_to_cpu(sinfo, ehdr64.e_entry);
+	sinfo->ehdr.e_phoff	= file64_to_cpu(sinfo, ehdr64.e_phoff);
+	sinfo->ehdr.e_shoff	= file64_to_cpu(sinfo, ehdr64.e_shoff);
+	sinfo->ehdr.e_flags	= file32_to_cpu(sinfo, ehdr64.e_flags);
+	sinfo->ehdr.e_ehsize	= file16_to_cpu(sinfo, ehdr64.e_ehsize);
+	sinfo->ehdr.e_phentsize	= file16_to_cpu(sinfo, ehdr64.e_phentsize);
+	sinfo->ehdr.e_phnum	= file16_to_cpu(sinfo, ehdr64.e_phnum);
+	sinfo->ehdr.e_shentsize	= file16_to_cpu(sinfo, ehdr64.e_shentsize);
+	sinfo->ehdr.e_shnum	= file16_to_cpu(sinfo, ehdr64.e_shnum);
+	sinfo->ehdr.e_shstrndx	= file16_to_cpu(sinfo, ehdr64.e_shstrndx);
+
+	if (sinfo->ehdr.e_version != EV_CURRENT) {
+		fprintf(stderr, "Bad Elf header version %u\n",
+			sinfo->ehdr.e_version);
+		return 1;
+	}
+	if (sinfo->ehdr.e_phentsize != sizeof(Elf64_Phdr)) {
+		fprintf(stderr, "Bad Elf progra header size %u expected %zu\n",
+			sinfo->ehdr.e_phentsize, sizeof(Elf64_Phdr));
+		return 1;
+	}
+	phdrs_size = sinfo-> ehdr.e_phnum * sizeof(Elf64_Phdr);
+	phdr64 = calloc(sinfo->ehdr.e_phnum, sizeof(Elf64_Phdr));
+	if (!phdr64) {
+		fprintf(stderr, "Calloc of %u phdrs64 failed: %s\n",
+			sinfo->ehdr.e_phnum, strerror(errno));
+		return 1;
+	}
+	sinfo->phdr = calloc(sinfo->ehdr.e_phnum, sizeof(Elf64_Phdr));
+	if (!sinfo->phdr) {
+		fprintf(stderr, "Calloc of %u phdrs failed: %s\n",
+			sinfo->ehdr.e_phnum, strerror(errno));
+		ret = 1;
+		goto out_free_phdr64;
+	}
+	ret = pread(fd, phdr64, phdrs_size, sinfo->ehdr.e_phoff);
+	if (ret < 0 || (size_t)ret != phdrs_size) {
+		fprintf(stderr, "Read of program header @ %llu for %zu bytes failed: %s\n",
+			(unsigned long long)(sinfo->ehdr.e_phoff), phdrs_size, strerror(errno));
+		ret = 1;
+		goto out_free_phdr;
+	}
+	for (i = 0; i < sinfo->ehdr.e_phnum; i++) {
+		sinfo->phdr[i].p_type = file32_to_cpu(sinfo, phdr64[i].p_type);
+		sinfo->phdr[i].p_flags = file32_to_cpu(sinfo,
+						phdr64[i].p_flags);
+		sinfo->phdr[i].p_offset = file64_to_cpu(sinfo,
+						phdr64[i].p_offset);
+		sinfo->phdr[i].p_vaddr = file64_to_cpu(sinfo,
+						phdr64[i].p_vaddr);
+		sinfo->phdr[i].p_paddr = file64_to_cpu(sinfo,
+						phdr64[i].p_paddr);
+		sinfo->phdr[i].p_filesz = file64_to_cpu(sinfo,
+						phdr64[i].p_filesz);
+		sinfo->phdr[i].p_memsz = file64_to_cpu(sinfo,
+						phdr64[i].p_memsz);
+		sinfo->phdr[i].p_align = file64_to_cpu(sinfo,
+						phdr64[i].p_align);
+	}
+	free(phdr64);
+	return ret;
+
+out_free_phdr:
+	free(sinfo->phdr);
+out_free_phdr64:
+	free(phdr64);
+	return ret;
+}
+
+#ifdef DEBUG
+static void print_digest(struct signelf_info *sinfo)
+{
+	int i;
+
+	printf("Digest is: ");
+	for(i = 0; i < sinfo->md_len; i++)
+		printf("%02x", sinfo->md_value[i]);
+	printf("\n");
+}
+#endif
+
+/*
+ * First PT_LOAD segment might have ELF header mapped already. Handle it
+ * differently
+ */
+static int calculate_digest_first_seg(struct signelf_info *sinfo,
+			int fd, int phdr_idx, EVP_MD_CTX *mdctx)
+{
+	unsigned char buf[MD_BUF_SIZE];
+	loff_t offset;
+	size_t to_read;
+	unsigned int buf_len;
+	size_t sz = 0, sz_done = 0, sz_rem = 0;
+	unsigned int bytes;
+	unsigned int off_e_shoff, off_e_flags, off_e_shnum;
+
+	if (sinfo->ehdr.e_ident[EI_CLASS] == ELFCLASS32) {
+		off_e_shoff = offsetof(Elf32_Ehdr, e_shoff);
+		off_e_flags = offsetof(Elf32_Ehdr, e_flags);
+		off_e_shnum = offsetof(Elf32_Ehdr, e_shnum);
+	} else {
+		off_e_shoff = offsetof(Elf64_Ehdr, e_shoff);
+		off_e_flags = offsetof(Elf64_Ehdr, e_flags);
+		off_e_shnum = offsetof(Elf64_Ehdr, e_shnum);
+	}
+
+	/*
+	 * Make sure ELF header is mapped into first PT_LOAD segment
+	 * otherwise error out
+	 */
+	if (sinfo->phdr[phdr_idx].p_offset != 0) {
+		fprintf(stderr, "Error: ELF header is not mapped"
+			" in first PT_LOAD segment\n");
+		return 1;
+	}
+
+	/*
+	 * First digest of ELF header. Except following e_shoff, e_shnum,
+	 * and e_shstrndx.
+	 */
+
+	offset = 0;
+	to_read = off_e_shoff;
+
+	buf_len = pread(fd, (void*)buf, to_read, offset);
+	if (buf_len != to_read) {
+		fprintf(stderr, "Failed to read %lu bytes.\n", to_read);
+		return 1;
+	}
+
+	EVP_DigestUpdate(mdctx, buf, buf_len);
+	bytes = buf_len;
+
+	/* Calculate digest of rest of the elf header */
+	offset = off_e_flags;
+	to_read = off_e_shnum - off_e_flags;
+	buf_len = pread(fd, (void*)buf, to_read, offset);
+	if (buf_len != to_read) {
+		fprintf(stderr, "Failed to read %lu bytes.\n", to_read);
+		return 1;
+	}
+
+	EVP_DigestUpdate(mdctx, buf, buf_len);
+	bytes += buf_len;
+
+	/* Calculate digest of rest of the segment */
+	offset = sinfo->ehdr.e_ehsize;
+	sz = sinfo->phdr[phdr_idx].p_filesz - sinfo->ehdr.e_ehsize;
+
+	sz_rem = sz;
+	to_read = MD_BUF_SIZE;
+	sz_done = 0;
+
+	while (sz_rem) {
+		if (sz_rem < to_read)
+			to_read = sz_rem;
+
+		buf_len = pread(fd, (void*)buf, to_read, offset);
+		if (buf_len == -1) {
+			fprintf(stderr, "Failed to read file:%s\n",
+					strerror(errno));
+			return 1;
+		}
+
+		/* TODO: Use fread() instead of pread() */
+		if (buf_len != to_read) {
+			fprintf(stderr, "Failed to read %lu bytes from"
+				"  file :%s. Read %u bytes\n",
+				to_read, strerror(errno), buf_len);
+			return 1;
+		}
+
+		if (buf_len == 0)
+			break;
+
+		EVP_DigestUpdate(mdctx, buf, buf_len);
+
+		bytes += buf_len;
+		sz_rem -= buf_len;
+		sz_done += buf_len;
+		offset += buf_len;
+
+		to_read = sz_rem;
+		if (to_read > MD_BUF_SIZE)
+			to_read = MD_BUF_SIZE;
+	}
+
+	if (sz_done != sz) {
+		fprintf(stderr, "Could not digest %lu bytes. Digested"
+			" only %lu bytes\n", sz, sz_done);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int calculate_elf_hash(struct signelf_info *sinfo, int fd)
+{
+	EVP_MD_CTX *mdctx;
+	const EVP_MD *md;
+	unsigned int buf_len;
+	unsigned char buf[MD_BUF_SIZE];
+	int i;
+	size_t sz = 0, sz_done = 0, sz_rem = 0;
+	int ret;
+	int first_segment = 1;
+
+	OpenSSL_add_all_digests();
+
+	/* TODO: Make digest type variable */
+	md = EVP_get_digestbyname("sha256");
+	mdctx = EVP_MD_CTX_create();
+	if (!mdctx) {
+		fprintf(stderr, "mdctx creation failed\n");
+		return 1;
+	}
+
+	EVP_DigestInit_ex(mdctx, md, NULL);
+
+	/*
+	 * Now go through all PT_LOAD program header areas and calculate
+	 * their checksum too. During verification, kernel will lock the
+	 * process mapped areas (essentially these PT_LOAD segments) and
+	 * go over these areas to calculate digest.
+	 *
+	 * Also calculate checksum of ELF header except two last fields.
+	 * Number of section headers and section header string table
+	 * index. Once signature is added in a section these two fields
+	 * will change.
+	 */
+	/* TODO: calculate hash of all program headers first */
+	for (i = 0; i < sinfo->ehdr.e_phnum; i++) {
+		loff_t offset;
+		size_t to_read;
+
+		if (sinfo->phdr[i].p_type != PT_LOAD)
+			continue;
+
+		if (first_segment) {
+			ret = calculate_digest_first_seg(sinfo, fd,
+					i, mdctx);
+			if (ret) {
+				fprintf(stderr, "Error while calculating"
+					" digest\n");
+				return 1;
+			}
+			first_segment = 0;
+			continue;
+		}
+
+		/* Calcualte hash of PT_LOAD area contents */
+		/* Skip if segment size is 0 (bss) */
+		offset = sinfo->phdr[i].p_offset;
+		sz = sinfo->phdr[i].p_filesz;
+
+		sz_rem = sz;
+		to_read = MD_BUF_SIZE;
+		sz_done = 0;
+
+		while (sz_rem) {
+			if (sz_rem < to_read)
+				to_read = sz_rem;
+
+			buf_len = pread(fd, (void*)buf, to_read, offset);
+			if (buf_len == -1) {
+				fprintf(stderr, "Failed to read:%s\n",
+						strerror(errno));
+				return 1;
+			}
+
+			/* TODO: Use fread() instead of pread() */
+			if (buf_len != to_read) {
+				fprintf(stderr, "Failed to read %lu bytes."
+					" Read %u bytes:%s\n",
+					to_read, buf_len, strerror(errno));
+				return 1;
+			}
+
+			if (buf_len == 0)
+				break;
+
+			EVP_DigestUpdate(mdctx, buf, buf_len);
+
+			sz_rem -= buf_len;
+			sz_done += buf_len;
+			offset += buf_len;
+
+			to_read = sz_rem;
+			if (to_read > MD_BUF_SIZE)
+				to_read = MD_BUF_SIZE;
+		}
+
+		if (sz_done != sz) {
+			fprintf(stderr, "Could not digest %lu bytes. Digested"
+				" only %lu bytes\n", sz, sz_done);
+			return 1;
+		}
+	}
+
+	EVP_DigestFinal_ex(mdctx, sinfo->md_value, &sinfo->md_len);
+	EVP_MD_CTX_destroy(mdctx);
+	EVP_cleanup();
+
+#ifdef DEBUG
+	print_digest(sinfo);
+#endif
+	return 0;
+}
+
+static int prefix_algo_identifier_to_digest(struct signelf_info *sinfo)
+{
+	FILE *algo_digest_fp;
+	size_t nr_write;
+
+	algo_digest_fp = fopen(temp_algo_ident_digest_file, "w+");
+	if (!algo_digest_fp) {
+		fprintf(stderr, "Failed to open file %s\n",
+				temp_algo_ident_digest_file);
+		return 1;
+	}
+
+	/* Write prologue */
+	nr_write = fwrite(algo_ident_sha256, 1, algo_ident_sha256_len,
+				algo_digest_fp);
+	if (nr_write != algo_ident_sha256_len) {
+		fprintf(stderr, "Failed to write prologue to %s\n",
+				temp_algo_ident_digest_file);
+		fclose(algo_digest_fp);
+		return 1;
+	}
+
+	/* Write digest */
+	nr_write = fwrite(sinfo->md_value, 1, sinfo->md_len, algo_digest_fp);
+	if (nr_write != sinfo->md_len) {
+		fprintf(stderr, "Failed to write digest to %s\n",
+				temp_algo_ident_digest_file);
+		fclose(algo_digest_fp);
+		return 1;
+	}
+
+	fclose(algo_digest_fp);
+	return 0;
+}
+
+static int prefix_siglen_to_signature(struct signelf_info *sinfo)
+{
+	char buf[4096];
+	FILE *sig_fp;
+	unsigned int nr_read, total_siglen;
+	uint16_t siglen, siglen_be16;
+
+
+	sig_fp = fopen(tempsig_file, "r");
+	if (!sig_fp) {
+		fprintf(stderr, "Failed to open file %s\n", tempsig_file);
+		return 1;
+	}
+
+	/* Read signature from file */
+	nr_read = fread(buf, 1, 4096, sig_fp);
+	if (nr_read == 0 && ferror(sig_fp)) {
+		fprintf(stderr, "Failed to read file %s\n", tempsig_file);
+		fclose(sig_fp);
+		return 1;
+	}
+
+	siglen = (uint16_t)nr_read;
+	siglen_be16 = htobe16(siglen);
+
+	total_siglen = siglen + 2;		// 2 byte for signature len
+
+	/* allocate memory for signature */
+	sinfo->signature = malloc(total_siglen);
+	if (!sinfo->signature) {
+		fprintf(stderr, "Failed to allocated %d bytes\n", total_siglen);
+		fclose(sig_fp);
+		return 1;
+	}
+
+	*(uint16_t*)sinfo->signature = siglen_be16;
+	memcpy(sinfo->signature + 2, buf, siglen);
+	sinfo->signature_len = total_siglen;
+
+	fclose(sig_fp);
+	return 0;
+}
+
+static int sign_hash_rsautl(struct signelf_info *sinfo)
+{
+	int ret, exit_code;
+	char command[1024];
+
+	snprintf(command, 1024, "openssl rsautl -sign -in %s -inkey %s -out %s",
+			temp_algo_ident_digest_file, sinfo->privkey_file,
+			tempsig_file);
+	ret = system(command);
+
+	if (ret == -1) {
+		fprintf(stderr, "Failed to execute system(%s)\n", command);
+		return 1;
+	}
+
+	exit_code = WEXITSTATUS(ret);
+	return exit_code;
+}
+
+static int x509_get_subject_key_identifier(struct signelf_info *sinfo)
+{
+	BIO *cert_buf;
+	X509 *cert_x509;
+	int ret = 0;
+	ASN1_OCTET_STRING *skid;
+
+	cert_buf = BIO_new_file(sinfo->certificate_file, "r");
+	if (!cert_buf) {
+		fprintf(stderr, "BIO_new_file on %s failed\n",
+			sinfo->certificate_file);
+		ret = 1;
+		goto out;
+	}
+
+	cert_x509 = d2i_X509_bio(cert_buf, NULL);
+	if (!cert_x509) {
+		fprintf(stderr, "Failed to parse DER format certificate\n");
+		ret = 1;
+		goto out_free_cert_buf;
+	}
+
+	skid = X509_get_ext_d2i(cert_x509, NID_subject_key_identifier,
+					NULL, NULL);
+	if (!skid) {
+		fprintf(stderr, "Failed to find subject key identifier"
+			" extension in certificate\n");
+		ret = 1;
+		goto out_free_x509;
+	}
+
+	sinfo->key_identifier = malloc(skid->length);
+	if (!sinfo->key_identifier) {
+		fprintf(stderr, "Failed to allocated %d bytes:%s\n",
+				skid->length, strerror(errno));
+		ret = 1;
+		goto out_free_asn1_string;
+	}
+
+	memcpy(sinfo->key_identifier, skid->data, skid->length);
+	sinfo->key_identifier_len = skid->length;
+
+#ifdef DEBUG
+	{
+	int i;
+		printf("skid in hex format:\n");
+		for (i = 0; i < skid->length; i++) {
+			printf("%02X", skid->data[i]);
+			if (i < skid->length - 1)
+				printf(":");
+		}
+		printf("\n");
+	}
+#endif
+
+out_free_asn1_string:
+	ASN1_STRING_free(skid);
+out_free_x509:
+	X509_free(cert_x509);
+out_free_cert_buf:
+	BIO_free(cert_buf);
+out:
+	return ret;
+}
+
+static int x509_get_subject(struct signelf_info *sinfo)
+{
+	BIO *cert_buf;
+	X509 *cert_x509;
+	int ret = 0, len;
+	X509_NAME *subject_x509_name;
+	char *common_name = NULL, *org_name = NULL, *email_addr = NULL;
+	int common_name_len = 0, org_name_len = 0, email_addr_len = 0;
+
+	cert_buf = BIO_new_file(sinfo->certificate_file, "r");
+	if (!cert_buf) {
+		fprintf(stderr, "BIO_new_file on %s failed\n",
+			sinfo->certificate_file);
+		ret = 1;
+		goto out;
+	}
+
+	cert_x509 = d2i_X509_bio(cert_buf, NULL);
+	if (!cert_x509) {
+		fprintf(stderr, "Failed to parse DER format certificate\n");
+		ret = 1;
+		goto out_free_cert_buf;
+	}
+
+	subject_x509_name = X509_get_subject_name(cert_x509);
+	if (!subject_x509_name) {
+		fprintf(stderr, "Failed to get subject name from"
+			" certificate\n");
+		ret = 1;
+		goto out_free_cert_buf;
+	}
+
+	/* Get commonName */
+	len = X509_NAME_get_text_by_NID(subject_x509_name, NID_commonName,
+			NULL, 0);
+
+	if (len != -1) {
+		common_name_len = len;
+		common_name = malloc(len + 1);
+		if (!common_name) {
+			fprintf(stderr, "Failed to allocate %d bytes of"
+				" memory:%s\n", len + 1, strerror(errno));
+			ret = 1;
+			goto out_free_cert_buf;
+		}
+
+		len = X509_NAME_get_text_by_NID(subject_x509_name,
+				NID_commonName, common_name,
+				common_name_len + 1);
+
+		if (len == -1) {
+			fprintf(stderr, "Failed to get commonName\n");
+			ret = 1;
+			goto out_free_common_name;
+		}
+	}
+
+	/* Get orgName */
+	len = X509_NAME_get_text_by_NID(subject_x509_name, NID_organizationName,
+			NULL, 0);
+
+	if (len != -1) {
+		org_name_len = len;
+		org_name = malloc(len + 1);
+		if (!org_name) {
+			fprintf(stderr, "Failed to allocate %d bytes of"
+				" memory:%s\n", len + 1, strerror(errno));
+			ret = 1;
+			goto out_free_common_name;
+		}
+
+		len = X509_NAME_get_text_by_NID(subject_x509_name,
+				NID_organizationName, org_name,
+				org_name_len + 1);
+
+		if (len == -1) {
+			fprintf(stderr, "Failed to get organizationName\n");
+			ret = 1;
+			goto out_free_org_name;
+		}
+	}
+
+	/* Get email addr */
+
+	len = X509_NAME_get_text_by_NID(subject_x509_name,
+					NID_pkcs9_emailAddress, NULL, 0);
+
+	if (len != -1) {
+		email_addr_len = len;
+		email_addr = malloc(len + 1);
+		if (!email_addr) {
+			fprintf(stderr, "Failed to allocate %d bytes of"
+				" memory:%s\n", len + 1, strerror(errno));
+			ret = 1;
+			goto out_free_org_name;
+		}
+
+		len = X509_NAME_get_text_by_NID(subject_x509_name,
+				NID_pkcs9_emailAddress, email_addr,
+				email_addr_len + 1);
+
+		if (len == -1) {
+			fprintf(stderr, "Failed to get email addr\n");
+			ret = 1;
+			goto out_free_email_addr;
+		}
+	}
+
+	sinfo->signer_name = NULL;
+
+	if (common_name_len && org_name_len) {
+		/* If common name contains organization name, don't use it */
+		if (strstr(common_name, org_name)) {
+			sinfo->signer_name = strdup(common_name);
+		} else {
+			sinfo->signer_name = malloc(org_name_len + common_name_len + 3);
+			sprintf(sinfo->signer_name, "%s: %s", org_name,
+					common_name);
+		}
+	} else if (common_name_len) {
+		sinfo->signer_name = strdup(common_name);
+	} else if (org_name_len) {
+		sinfo->signer_name = strdup(org_name);
+	} else if(email_addr)
+		sinfo->signer_name = strdup(email_addr);
+
+	if (!sinfo->signer_name) {
+		fprintf(stderr, "Could not obtain signer name\n");
+		ret = 1;
+	}
+out_free_email_addr:
+	free(email_addr);
+out_free_org_name:
+	free(org_name);
+out_free_common_name:
+	free(common_name);
+out_free_cert_buf:
+	BIO_free(cert_buf);
+out:
+	return ret;
+}
+
+static int prepare_sig_info(struct signelf_info *sinfo)
+{
+	/* algo = 1 (RSA), hash = 4 (sha256), id_type=1 (X.509) */
+	unsigned int algo=1, hash = 4, id_type = 1, i=0;
+	uint8_t signer_name_len = strlen(sinfo->signer_name);
+	uint32_t signature_len_be = htobe32(sinfo->signature_len);
+
+	sinfo->sig_info[i++] = algo;
+	sinfo->sig_info[i++] = hash;
+	sinfo->sig_info[i++] = id_type;
+	sinfo->sig_info[i++] = signer_name_len;
+	sinfo->sig_info[i++] = sinfo->key_identifier_len;
+	sinfo->sig_info[i++] = 0;
+	sinfo->sig_info[i++] = 0;
+	sinfo->sig_info[i++] = 0;
+
+	sinfo->sig_info_len = i;
+	memcpy(&sinfo->sig_info[i], &signature_len_be, 4);
+	sinfo->sig_info_len += 4;
+
+	return 0;
+}
+
+static int add_signature_in_a_section(struct signelf_info *sinfo)
+{
+	FILE *outfp;
+	int ret = 0, exit_code;
+	unsigned int written;
+	unsigned int signer_name_len;
+	char command[1024];
+
+	outfp = fopen(tempsigsection_file, "w+");
+	if (!outfp) {
+		fprintf(stderr, "Failed to open %s:%s\n", tempsigsection_file,
+				strerror(errno));
+		return 1;
+	}
+
+	/* Write signer's name */
+	signer_name_len = strlen(sinfo->signer_name);
+	written = fwrite(sinfo->signer_name, 1, signer_name_len, outfp);
+	if (written != signer_name_len) {
+		fprintf(stderr, "Failed to write signer name to file %s\n",
+				tempsigsection_file);
+		ret = 1;
+		goto out_close_outfp;
+	}
+
+	/* Write skid */
+	written = fwrite(sinfo->key_identifier, 1, sinfo->key_identifier_len,
+				outfp);
+	if (written != sinfo->key_identifier_len) {
+		fprintf(stderr, "Failed to write key identifier to file %s\n",
+				tempsigsection_file);
+		ret = 1;
+		goto out_close_outfp;
+	}
+
+	/* Write signature */
+	written = fwrite(sinfo->signature, 1, sinfo->signature_len, outfp);
+	if (written != sinfo->signature_len) {
+		fprintf(stderr, "Failed to write signature to file %s\n",
+				tempsigsection_file);
+		ret = 1;
+		goto out_close_outfp;
+	}
+
+	/* Write info */
+	written = fwrite(sinfo->sig_info, 1, sinfo->sig_info_len, outfp);
+	if (written != sinfo->sig_info_len) {
+		fprintf(stderr, "Failed to write info to file %s\n",
+				 tempsigsection_file);
+		ret = 1;
+		goto out_close_outfp;
+	}
+
+	/* Add signature section */
+	fflush(outfp);
+	snprintf(command, 1024, "objcopy --add-section .signature=%s %s %s",
+			tempsigsection_file, sinfo->in_file, sinfo->out_file);
+	ret = system(command);
+	if (ret == -1) {
+		fprintf(stderr, "Failed to execute system(%s)\n", command);
+		goto out_close_outfp;
+	}
+
+	exit_code = WEXITSTATUS(ret);
+	ret = exit_code;
+	if (ret)
+		goto out_close_outfp;
+
+out_close_outfp:
+	fclose(outfp);
+	return ret;
+}
+
+static int sign_elf_executable(struct signelf_info *sinfo)
+{
+	int ret, fd;
+
+	fd = open(sinfo->in_file, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "Cannot open %s: %s\n",
+				sinfo->in_file, strerror(errno));
+		return 1;
+	}
+
+	ret = pread(fd, sinfo->ehdr.e_ident, EI_NIDENT, 0);
+	if (ret != EI_NIDENT) {
+		fprintf(stderr, "Read of e_ident from %s failed: %s\n",
+			sinfo->in_file, strerror(errno));
+		ret = 1;
+		goto out;
+        }
+
+	if (memcmp(sinfo->ehdr.e_ident, ELFMAG, SELFMAG) != 0) {
+		fprintf(stderr, "Missing elf signature\n");
+		ret = 1;
+		goto out;
+        }
+
+	if (sinfo->ehdr.e_ident[EI_VERSION] != EV_CURRENT) {
+		fprintf(stderr, "Bad elf version\n");
+		ret = 1;
+		goto out;
+	}
+
+	if ((sinfo->ehdr.e_ident[EI_CLASS] != ELFCLASS32) &&
+	    (sinfo->ehdr.e_ident[EI_CLASS] != ELFCLASS64))
+	{
+		fprintf(stderr, "Unknown elf class %u\n",
+			sinfo->ehdr.e_ident[EI_CLASS]);
+		ret = 1;
+		goto out;
+	}
+
+	if ((sinfo->ehdr.e_ident[EI_DATA] != ELFDATA2LSB) &&
+	    (sinfo->ehdr.e_ident[EI_DATA] != ELFDATA2MSB))
+	{
+		fprintf(stderr, "Unkown elf data order %u\n",
+			sinfo->ehdr.e_ident[EI_DATA]);
+		ret = 1;
+		goto out;
+	}
+
+	if (sinfo->ehdr.e_ident[EI_CLASS] == ELFCLASS32)
+		ret = read_elf32(sinfo, fd);
+	else
+		ret = read_elf64(sinfo, fd);
+
+	if (!ret)
+		goto out;
+
+	ret = x509_get_subject(sinfo);
+	if (ret)
+		goto out;
+
+	ret = x509_get_subject_key_identifier(sinfo);
+	if (ret)
+		goto out;
+
+	if (calculate_elf_hash(sinfo, fd)) {
+		ret = 1;
+		goto out;
+	}
+
+	ret = prefix_algo_identifier_to_digest(sinfo);
+	if (ret)
+		goto out;
+
+	ret = sign_hash_rsautl(sinfo);
+	if (ret)
+		goto out;
+
+	ret = prefix_siglen_to_signature(sinfo);
+	if (ret)
+		goto out;
+
+	ret = prepare_sig_info(sinfo);
+	if (ret)
+		goto out;
+
+	ret = add_signature_in_a_section(sinfo);
+	if (ret) {
+		fprintf(stderr, "Error while putting signature into an elf"
+			" section\n");
+		goto out;
+	}
+
+out:
+	close(fd);
+	return ret;
+}
+
+static void print_help()
+{
+	printf("Usage: signelf [OPTION...]\n");
+	printf(" -i, --in=<infile>\t\t\t\tspecify input file\n");
+	printf(" -p, --privkey=<privkey>\t\t\tspecify private key file\n");
+	printf(" -c, --certificate=<certificate>\t\tspecify certificate file\n");
+	printf(" -o, --out=<outfile>\t\t\t\tspecify output file\n");
+}
+
+static void free_sinfo_members(struct signelf_info *sinfo)
+{
+	free(sinfo->in_file);
+	free(sinfo->out_file);
+	free(sinfo->privkey_file);
+	free(sinfo->certificate_file);
+	free(sinfo->signer_name);
+	free(sinfo->key_identifier);
+	free(sinfo->signature);
+}
+
+int main(int argc, char *argv[])
+{
+	int ret = 0;
+	char *option_string = "hi:p:c:o:", c;
+	struct signelf_info *sinfo, signelf_info;
+
+	struct option long_options[] =
+		{
+			{"help", no_argument, 0, 'h'},
+			{"in", required_argument, 0, 'i'},
+			{"privkey", required_argument, 0, 'p'},
+			{"certificate", required_argument, 0, 'c'},
+			{"out", required_argument, 0, 'o'},
+			{ 0, 0, 0, 0}
+		};
+
+	if (argc < 2) {
+		print_help();
+		exit(1);
+	}
+
+	sinfo = &signelf_info;
+	memset(sinfo, 0, sizeof(struct signelf_info));
+
+	while((c = getopt_long(argc, argv, option_string, &long_options[0],
+	       NULL)) != -1) {
+		switch(c) {
+		case '?':
+			/* Unknown option or missing argument*/
+			print_help();
+			exit(1);
+		case 'h':
+			print_help();
+			exit(0);
+		case 'i':
+			sinfo->in_file = strdup(optarg);
+			if (!sinfo->in_file) {
+				fprintf(stderr, "Can't duplicate string:%s\n",
+						strerror(errno));
+				exit(1);
+			}
+			break;
+		case 'p':
+			sinfo->privkey_file = strdup(optarg);
+			if (!sinfo->privkey_file) {
+				fprintf(stderr, "Can't duplicate string:%s\n",
+					strerror(errno));
+				exit(1);
+			}
+			break;
+		case 'c':
+			sinfo->certificate_file = strdup(optarg);
+			if (!sinfo->certificate_file) {
+				fprintf(stderr, "Can't duplicate string:%s\n",
+					strerror(errno));
+				exit(1);
+			}
+			break;
+		case 'o':
+			sinfo->out_file = strdup(optarg);
+			if (!sinfo->out_file) {
+				fprintf(stderr, "Can't duplicate string:%s\n",
+					strerror(errno));
+				exit(1);
+			}
+			break;
+		default:
+			printf("Unexpected option\n");
+			exit(1);
+		}
+	}
+
+	if (!sinfo->in_file || !sinfo->out_file || !sinfo->privkey_file ||
+	    !sinfo->certificate_file) {
+		print_help();
+		exit(1);
+	}
+
+	ret = sign_elf_executable(sinfo);
+
+	free_sinfo_members(sinfo);
+	remove(temp_algo_ident_digest_file);
+	remove(tempsig_file);
+	remove(tempsigsection_file);
+
+	exit(ret);
+}
Index: signelf/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ signelf/Makefile	2013-01-18 02:27:41.000000000 -0500
@@ -0,0 +1,21 @@
+CC	= gcc
+OPTFLAGS= -g
+CFLAGS	= -Wall -D_GNU_SOURCE $(OPTFLAGS)
+PROGS	= signelf
+OBJS	= signelf.o
+
+INSTALL = install
+prefix = /usr/local
+bindir = $(prefix)/bin
+
+%.o: %.c
+	$(CC) -o $*.o -c $(CFLAGS) $<
+signelf: $(OBJS)
+	$(CC) $(CFLAGS) -o $@ $(filter %.o,$^) -lcrypto
+
+install:
+	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
+	$(INSTALL) $(PROGS) $(DESTDIR)$(bindir)
+
+clean:
+	rm -f $(OBJS) $(PROGS)
