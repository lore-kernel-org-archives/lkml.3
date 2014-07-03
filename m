Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096AbaGCVIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbaGCVIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:08:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, dhowells@redhat.com, pjones@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 3/9] pefile: Parse a PE binary and verify signature
Date: Thu,  3 Jul 2014 17:07:15 -0400
Message-Id: <1404421641-12691-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse a PE binary, find pkcs7 signature and verify signature.

v2:

 Moved PE file parsing and signature verification in arch/x86/

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/Kconfig                |   9 +++
 arch/x86/kernel/Makefile        |   1 +
 arch/x86/kernel/pefile_parser.c | 145 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pefile_parser.h |  31 +++++++++
 4 files changed, 186 insertions(+)
 create mode 100644 arch/x86/kernel/pefile_parser.c
 create mode 100644 arch/x86/kernel/pefile_parser.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2cee2a6..29b9967 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1574,6 +1574,15 @@ config SECCOMP
 
 source kernel/Kconfig.hz
 
+config SIGNED_PE_FILE_PARSER
+	bool "Signed PE binary parser"
+	depends on PKCS7_MESSAGE_PARSER=y
+	select ASN1
+	select OID_REGISTRY
+	---help---
+	  This option provides support for parsing signed PE
+	  (Protable Executable) binaries.
+
 config KEXEC
 	bool "kexec system call"
 	select BUILD_BIN2C
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index ece67cb..da7c6b3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
 obj-$(CONFIG_IOSF_MBI)			+= iosf_mbi.o
+obj-$(CONFIG_SIGNED_PE_FILE_PARSER)	+= pefile_parser.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/pefile_parser.c b/arch/x86/kernel/pefile_parser.c
new file mode 100644
index 0000000..72bc2bb
--- /dev/null
+++ b/arch/x86/kernel/pefile_parser.c
@@ -0,0 +1,145 @@
+/* Parse a signed PE binary
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "PEFILE: "fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/pe.h>
+#include <keys/asymmetric-subtype.h>
+#include <keys/asymmetric-parser.h>
+#include <crypto/hash.h>
+#include <crypto/pkcs7.h>
+#include "pefile_parser.h"
+
+#define kenter(FMT, ...) \
+	pr_devel("==> %s("FMT")\n", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) \
+	pr_devel("<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
+
+/*
+ * Parse a PE binary.
+ */
+static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
+			       struct pefile_context *ctx)
+{
+	const struct mz_hdr *mz = pebuf;
+	const struct pe_hdr *pe;
+	const struct pe32_opt_hdr *pe32;
+	const struct pe32plus_opt_hdr *pe64;
+	const struct data_directory *ddir;
+	const struct data_dirent *dde;
+	const struct section_header *secs, *sec;
+	size_t cursor, datalen = pelen;
+
+	kenter("");
+
+#define chkaddr(base, x, s)						\
+	do {								\
+		if ((x) < base || (s) >= datalen || (x) > datalen - (s)) \
+			return -ELIBBAD;				\
+	} while (0)
+
+	chkaddr(0, 0, sizeof(*mz));
+	if (mz->magic != MZ_MAGIC)
+		return -ELIBBAD;
+	cursor = sizeof(*mz);
+
+	chkaddr(cursor, mz->peaddr, sizeof(*pe));
+	pe = pebuf + mz->peaddr;
+	if (pe->magic != PE_MAGIC)
+		return -ELIBBAD;
+	cursor = mz->peaddr + sizeof(*pe);
+
+	chkaddr(0, cursor, sizeof(pe32->magic));
+	pe32 = pebuf + cursor;
+	pe64 = pebuf + cursor;
+
+	switch (pe32->magic) {
+	case PE_OPT_MAGIC_PE32:
+		chkaddr(0, cursor, sizeof(*pe32));
+		ctx->image_checksum_offset =
+			(unsigned long)&pe32->csum - (unsigned long)pebuf;
+		ctx->header_size = pe32->header_size;
+		cursor += sizeof(*pe32);
+		ctx->n_data_dirents = pe32->data_dirs;
+		break;
+
+	case PE_OPT_MAGIC_PE32PLUS:
+		chkaddr(0, cursor, sizeof(*pe64));
+		ctx->image_checksum_offset =
+			(unsigned long)&pe64->csum - (unsigned long)pebuf;
+		ctx->header_size = pe64->header_size;
+		cursor += sizeof(*pe64);
+		ctx->n_data_dirents = pe64->data_dirs;
+		break;
+
+	default:
+		pr_debug("Unknown PEOPT magic = %04hx\n", pe32->magic);
+		return -ELIBBAD;
+	}
+
+	pr_debug("checksum @ %x\n", ctx->image_checksum_offset);
+	pr_debug("header size = %x\n", ctx->header_size);
+
+	if (cursor >= ctx->header_size || ctx->header_size >= datalen)
+		return -ELIBBAD;
+
+	if (ctx->n_data_dirents > (ctx->header_size - cursor) / sizeof(*dde))
+		return -ELIBBAD;
+
+	ddir = pebuf + cursor;
+	cursor += sizeof(*dde) * ctx->n_data_dirents;
+
+	ctx->cert_dirent_offset =
+		(unsigned long)&ddir->certs - (unsigned long)pebuf;
+	ctx->certs_size = ddir->certs.size;
+
+	if (!ddir->certs.virtual_address || !ddir->certs.size) {
+		pr_debug("Unsigned PE binary\n");
+		return -EKEYREJECTED;
+	}
+
+	chkaddr(ctx->header_size, ddir->certs.virtual_address,
+		ddir->certs.size);
+	ctx->sig_offset = ddir->certs.virtual_address;
+	ctx->sig_len = ddir->certs.size;
+	pr_debug("cert = %x @%x [%*ph]\n",
+		 ctx->sig_len, ctx->sig_offset,
+		 ctx->sig_len, pebuf + ctx->sig_offset);
+
+	ctx->n_sections = pe->sections;
+	if (ctx->n_sections > (ctx->header_size - cursor) / sizeof(*sec))
+		return -ELIBBAD;
+	ctx->secs = secs = pebuf + cursor;
+
+	return 0;
+}
+
+/*
+ * Parse a PE binary and verify PKCS7 signature.
+ */
+int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen)
+{
+	struct pefile_context ctx;
+	int ret;
+
+	kenter("");
+
+	memset(&ctx, 0, sizeof(ctx));
+	ret = pefile_parse_binary(pebuf, pelen, &ctx);
+	if (ret < 0)
+		return ret;
+
+	/* Not yet complete */
+	return -ENOANO;
+}
diff --git a/arch/x86/kernel/pefile_parser.h b/arch/x86/kernel/pefile_parser.h
new file mode 100644
index 0000000..e28a7e1
--- /dev/null
+++ b/arch/x86/kernel/pefile_parser.h
@@ -0,0 +1,31 @@
+/* PE Binary parser bits
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <crypto/hash_info.h>
+
+struct pefile_context {
+	unsigned	header_size;
+	unsigned	image_checksum_offset;
+	unsigned	cert_dirent_offset;
+	unsigned	n_data_dirents;
+	unsigned	n_sections;
+	unsigned	certs_size;
+	unsigned	sig_offset;
+	unsigned	sig_len;
+	const struct section_header *secs;
+	void		*pkcs7;
+
+	/* PKCS#7 MS Individual Code Signing content */
+	const void	*digest;		/* Digest */
+	unsigned	digest_len;		/* Digest length */
+	enum hash_algo	digest_algo;		/* Digest algorithm */
+};
+
+extern int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen);
-- 
1.9.0

