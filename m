Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaGIPRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:17:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720AbaGIPRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:17:00 -0400
Subject: [PATCH11/17] pefile: Parse a PE binary to find a key and a
 signature contained therein
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 16:16:37 +0100
Message-ID: <20140709151637.23074.91595.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse a PE binary to find a key and a signature contained therein.  Later
patches will check the signature and add the key if the signature checks out.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---

 crypto/asymmetric_keys/Kconfig         |    9 ++
 crypto/asymmetric_keys/Makefile        |    8 ++
 crypto/asymmetric_keys/verify_pefile.c |  163 ++++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/verify_pefile.h |   37 +++++++
 include/linux/verify_pefile.h          |   18 ++++
 5 files changed, 235 insertions(+)
 create mode 100644 crypto/asymmetric_keys/verify_pefile.c
 create mode 100644 crypto/asymmetric_keys/verify_pefile.h
 create mode 100644 include/linux/verify_pefile.h


diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 14cac28..ca41be5 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -59,4 +59,13 @@ config PKCS7_TEST_KEY
 
 	  This is intended for testing the PKCS#7 parser.
 
+config SIGNED_PE_FILE_VERIFICATION
+	bool "Support for PE file signature verification"
+	depends on PKCS7_MESSAGE_PARSER=y
+	select ASN1
+	select OID_REGISTRY
+	help
+	  This option provides support for verifying the signature(s) on a
+	  signed PE binary.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 92d0e9a..3e4de52 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -47,3 +47,11 @@ clean-files	+= pkcs7-asn1.c pkcs7-asn1.h
 obj-$(CONFIG_PKCS7_TEST_KEY) += pkcs7_test_key.o
 pkcs7_test_key-y := \
 	pkcs7_key_type.o
+
+#
+# Signed PE binary-wrapped key handling
+#
+obj-$(CONFIG_SIGNED_PE_FILE_VERIFICATION) += verify_signed_pefile.o
+
+verify_signed_pefile-y := \
+	verify_pefile.o
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
new file mode 100644
index 0000000..aec7c50
--- /dev/null
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -0,0 +1,163 @@
+/* Parse a signed PE binary
+ *
+ * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
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
+#include <crypto/pkcs7.h>
+#include <crypto/hash.h>
+#include "verify_pefile.h"
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
+/**
+ * verify_pefile_signature - Verify the signature on a PE binary image
+ * @pebuf: Buffer containing the PE binary image
+ * @pelen: Length of the binary image
+ * @trust_keyring: Signing certificates to use as starting points
+ * @_trusted: Set to true if trustworth, false otherwise
+ *
+ * Validate that the certificate chain inside the PKCS#7 message inside the PE
+ * binary image intersects keys we already know and trust.
+ *
+ * Returns, in order of descending priority:
+ *
+ *  (*) -ELIBBAD if the image cannot be parsed, or:
+ *
+ *  (*) -EKEYREJECTED if a signature failed to match for which we have a valid
+ *	key, or:
+ *
+ *  (*) 0 if at least one signature chain intersects with the keys in the trust
+ *	keyring, or:
+ *
+ *  (*) -ENOPKG if a suitable crypto module couldn't be found for a check on a
+ *	chain.
+ *
+ *  (*) -ENOKEY if we couldn't find a match for any of the signature chains in
+ *	the message.
+ *
+ * May also return -ENOMEM.
+ */
+int verify_pefile_signature(const void *pebuf, unsigned pelen,
+			    struct key *trusted_keyring, bool *_trusted)
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
+	return -ENOANO; // Not yet complete
+}
diff --git a/crypto/asymmetric_keys/verify_pefile.h b/crypto/asymmetric_keys/verify_pefile.h
new file mode 100644
index 0000000..e165d23
--- /dev/null
+++ b/crypto/asymmetric_keys/verify_pefile.h
@@ -0,0 +1,37 @@
+/* PE Binary parser bits
+ *
+ * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/verify_pefile.h>
+#include <crypto/pkcs7.h>
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
+	struct pkcs7_message *pkcs7;
+
+	/* PKCS#7 MS Individual Code Signing content */
+	const void	*digest;		/* Digest */
+	unsigned	digest_len;		/* Digest length */
+	enum hash_algo	digest_algo;		/* Digest algorithm */
+};
+
+#define kenter(FMT, ...)					\
+	pr_devel("==> %s("FMT")\n", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) \
+	pr_devel("<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
diff --git a/include/linux/verify_pefile.h b/include/linux/verify_pefile.h
new file mode 100644
index 0000000..ac34819
--- /dev/null
+++ b/include/linux/verify_pefile.h
@@ -0,0 +1,18 @@
+/* Signed PE file verification
+ *
+ * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_VERIFY_PEFILE_H
+#define _LINUX_VERIFY_PEFILE_H
+
+extern int verify_pefile_signature(const void *pebuf, unsigned pelen,
+				   struct key *trusted_keyring, bool *_trusted);
+
+#endif /* _LINUX_VERIFY_PEFILE_H */

