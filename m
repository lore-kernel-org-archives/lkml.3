Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbaGIPSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:18:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884AbaGIPRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:17:21 -0400
Subject: [PATCH14/17] pefile: Parse the "Microsoft individual code signing"
 data blob
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 16:16:55 +0100
Message-ID: <20140709151655.23074.99944.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PKCS#7 certificate should contain a "Microsoft individual code signing"
data blob as its signed content.  This blob contains a digest of the signed
content of the PE binary and the OID of the digest algorithm used (typically
SHA256).

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---

 crypto/asymmetric_keys/Makefile        |    9 ++
 crypto/asymmetric_keys/mscode.asn1     |   28 +++++++
 crypto/asymmetric_keys/mscode_parser.c |  120 ++++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/verify_pefile.c |    7 ++
 crypto/asymmetric_keys/verify_pefile.h |    5 +
 include/linux/oid_registry.h           |    7 ++
 6 files changed, 174 insertions(+), 2 deletions(-)
 create mode 100644 crypto/asymmetric_keys/mscode.asn1
 create mode 100644 crypto/asymmetric_keys/mscode_parser.c


diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 3e4de52..e47fcd9 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -54,4 +54,11 @@ pkcs7_test_key-y := \
 obj-$(CONFIG_SIGNED_PE_FILE_VERIFICATION) += verify_signed_pefile.o
 
 verify_signed_pefile-y := \
-	verify_pefile.o
+	verify_pefile.o \
+	mscode_parser.o \
+	mscode-asn1.o
+
+$(obj)/mscode_parser.o: $(obj)/mscode-asn1.h $(obj)/mscode-asn1.h
+$(obj)/mscode-asn1.o: $(obj)/mscode-asn1.c $(obj)/mscode-asn1.h
+
+clean-files	+= mscode-asn1.c mscode-asn1.h
diff --git a/crypto/asymmetric_keys/mscode.asn1 b/crypto/asymmetric_keys/mscode.asn1
new file mode 100644
index 0000000..6d09ba4
--- /dev/null
+++ b/crypto/asymmetric_keys/mscode.asn1
@@ -0,0 +1,28 @@
+--- Microsoft individual code signing data blob parser
+---
+--- Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+--- Written by David Howells (dhowells@redhat.com)
+---
+--- This program is free software; you can redistribute it and/or
+--- modify it under the terms of the GNU General Public Licence
+--- as published by the Free Software Foundation; either version
+--- 2 of the Licence, or (at your option) any later version.
+---
+
+MSCode ::= SEQUENCE {
+	type			SEQUENCE {
+		contentType	ContentType,
+		parameters	ANY
+	},
+	content			SEQUENCE {
+		digestAlgorithm	DigestAlgorithmIdentifier,
+		digest		OCTET STRING ({ mscode_note_digest })
+	}
+}
+
+ContentType ::= OBJECT IDENTIFIER ({ mscode_note_content_type })
+
+DigestAlgorithmIdentifier ::= SEQUENCE {
+	algorithm   OBJECT IDENTIFIER ({ mscode_note_digest_algo }),
+	parameters  ANY OPTIONAL
+}
diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
new file mode 100644
index 0000000..09336c3
--- /dev/null
+++ b/crypto/asymmetric_keys/mscode_parser.c
@@ -0,0 +1,120 @@
+/* Parse a Microsoft Individual Code Signing blob
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
+#define pr_fmt(fmt) "MSCODE: "fmt
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/oid_registry.h>
+#include <crypto/pkcs7.h>
+#include "verify_pefile.h"
+#include "mscode-asn1.h"
+
+/*
+ * Parse a Microsoft Individual Code Signing blob
+ */
+int mscode_parse(struct pefile_context *ctx)
+{
+	const void *content_data;
+	size_t data_len;
+	int ret;
+
+	ret = pkcs7_get_content_data(ctx->pkcs7, &content_data, &data_len, 1);
+
+	if (ret) {
+		pr_debug("PKCS#7 message does not contain data\n");
+		return ret;
+	}
+
+	pr_devel("Data: %zu [%*ph]\n", data_len, (unsigned)(data_len),
+		 content_data);
+
+	return asn1_ber_decoder(&mscode_decoder, ctx, content_data, data_len);
+}
+
+/*
+ * Check the content type OID
+ */
+int mscode_note_content_type(void *context, size_t hdrlen,
+			     unsigned char tag,
+			     const void *value, size_t vlen)
+{
+	enum OID oid;
+
+	oid = look_up_OID(value, vlen);
+	if (oid == OID__NR) {
+		char buffer[50];
+
+		sprint_oid(value, vlen, buffer, sizeof(buffer));
+		pr_err("Unknown OID: %s\n", buffer);
+		return -EBADMSG;
+	}
+
+	if (oid != OID_msIndividualSPKeyPurpose) {
+		pr_err("Unexpected content type OID %u\n", oid);
+		return -EBADMSG;
+	}
+
+	return 0;
+}
+
+/*
+ * Note the digest algorithm OID
+ */
+int mscode_note_digest_algo(void *context, size_t hdrlen,
+			    unsigned char tag,
+			    const void *value, size_t vlen)
+{
+	struct pefile_context *ctx = context;
+	char buffer[50];
+	enum OID oid;
+
+	oid = look_up_OID(value, vlen);
+	switch (oid) {
+	case OID_md4:
+		ctx->digest_algo = HASH_ALGO_MD4;
+		break;
+	case OID_md5:
+		ctx->digest_algo = HASH_ALGO_MD5;
+		break;
+	case OID_sha1:
+		ctx->digest_algo = HASH_ALGO_SHA1;
+		break;
+	case OID_sha256:
+		ctx->digest_algo = HASH_ALGO_SHA256;
+		break;
+
+	case OID__NR:
+		sprint_oid(value, vlen, buffer, sizeof(buffer));
+		pr_err("Unknown OID: %s\n", buffer);
+		return -EBADMSG;
+
+	default:
+		pr_err("Unsupported content type: %u\n", oid);
+		return -ENOPKG;
+	}
+
+	return 0;
+}
+
+/*
+ * Note the digest we're guaranteeing with this certificate
+ */
+int mscode_note_digest(void *context, size_t hdrlen,
+		       unsigned char tag,
+		       const void *value, size_t vlen)
+{
+	struct pefile_context *ctx = context;
+
+	ctx->digest = value;
+	ctx->digest_len = vlen;
+	return 0;
+}
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 13f3b44..b975918 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -245,6 +245,13 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 		goto error;
 	}
 
+	ret = mscode_parse(&ctx);
+	if (ret < 0)
+		goto error;
+
+	pr_debug("Digest: %u [%*ph]\n",
+		 ctx.digest_len, ctx.digest_len, ctx.digest);
+
 	ret = -ENOANO; // Not yet complete
 
 error:
diff --git a/crypto/asymmetric_keys/verify_pefile.h b/crypto/asymmetric_keys/verify_pefile.h
index e165d23..55d5f7e 100644
--- a/crypto/asymmetric_keys/verify_pefile.h
+++ b/crypto/asymmetric_keys/verify_pefile.h
@@ -35,3 +35,8 @@ struct pefile_context {
 	pr_devel("==> %s("FMT")\n", __func__, ##__VA_ARGS__)
 #define kleave(FMT, ...) \
 	pr_devel("<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
+
+/*
+ * mscode_parser.c
+ */
+extern int mscode_parse(struct pefile_context *ctx);
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index edeff85..c2bbf67 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -52,8 +52,13 @@ enum OID {
 	OID_md4,			/* 1.2.840.113549.2.4 */
 	OID_md5,			/* 1.2.840.113549.2.5 */
 
-	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
+	/* Microsoft Authenticode & Software Publishing */
+	OID_msIndirectData,		/* 1.3.6.1.4.1.311.2.1.4 */
+	OID_msPeImageDataObjId,		/* 1.3.6.1.4.1.311.2.1.15 */
+	OID_msIndividualSPKeyPurpose,	/* 1.3.6.1.4.1.311.2.1.21 */
 	OID_msOutlookExpress,		/* 1.3.6.1.4.1.311.16.4 */
+
+	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
 	OID_sha1,			/* 1.3.14.3.2.26 */
 	OID_sha256,			/* 2.16.840.1.101.3.4.2.1 */
 

