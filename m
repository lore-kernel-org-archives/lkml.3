Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbaGCVIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:08:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaGCVIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:08:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, dhowells@redhat.com, pjones@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 6/9] pefile: Parse the "Microsoft individual code signing" data blob
Date: Thu,  3 Jul 2014 17:07:18 -0400
Message-Id: <1404421641-12691-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PKCS#7 certificate should contain a "Microsoft individual code signing"
data blob as its signed content.  This blob contains a digest of the signed
content of the PE binary and the OID of the digest algorithm used (typically
SHA256).

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kernel/Makefile        |   8 ++-
 arch/x86/kernel/mscode.asn1     |  28 +++++++++
 arch/x86/kernel/mscode_parser.c | 126 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pefile_parser.c |   6 ++
 arch/x86/kernel/pefile_parser.h |   5 ++
 include/linux/oid_registry.h    |   7 ++-
 6 files changed, 178 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/mscode.asn1
 create mode 100644 arch/x86/kernel/mscode_parser.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index da7c6b3..72f553e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -106,7 +106,13 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
 obj-$(CONFIG_IOSF_MBI)			+= iosf_mbi.o
-obj-$(CONFIG_SIGNED_PE_FILE_PARSER)	+= pefile_parser.o
+
+obj-$(CONFIG_SIGNED_PE_FILE_PARSER)	+= pefile_parser.o mscode_parser.o mscode-asn1.o
+
+$(obj)/mscode_parser.o: $(obj)/mscode-asn1.h
+$(obj)/mscode-asn1.o: $(obj)/mscode-asn1.c $(obj)/mscode-asn1.h
+
+clean-files				+= mscode-asn1.c mscode-asn1.h
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/mscode.asn1 b/arch/x86/kernel/mscode.asn1
new file mode 100644
index 0000000..6d09ba4
--- /dev/null
+++ b/arch/x86/kernel/mscode.asn1
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
diff --git a/arch/x86/kernel/mscode_parser.c b/arch/x86/kernel/mscode_parser.c
new file mode 100644
index 0000000..793bc05
--- /dev/null
+++ b/arch/x86/kernel/mscode_parser.c
@@ -0,0 +1,126 @@
+/* Parse a Microsoft Individual Code Signing blob
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
+#define pr_fmt(fmt) "MSCODE: "fmt
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/oid_registry.h>
+#include <crypto/pkcs7.h>
+#include "pefile_parser.h"
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
+	/*
+	 * pesign utility had a bug where it was putting
+	 * OID_msIndividualSPKeyPurpose instead of OID_msPeImageDataObjId
+	 * So allow both OIDs.
+	 */
+	if (oid != OID_msPeImageDataObjId &&
+	    oid != OID_msIndividualSPKeyPurpose) {
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
diff --git a/arch/x86/kernel/pefile_parser.c b/arch/x86/kernel/pefile_parser.c
index e4d3410..7281217 100644
--- a/arch/x86/kernel/pefile_parser.c
+++ b/arch/x86/kernel/pefile_parser.c
@@ -219,6 +219,12 @@ int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen)
 		return PTR_ERR(pkcs7);
 	ctx.pkcs7 = pkcs7;
 
+	ret = mscode_parse(&ctx);
+	if (ret < 0)
+		goto error;
+	pr_debug("Digest: %u [%*ph]\n", ctx.digest_len, ctx.digest_len,
+		 ctx.digest);
+
 	/* Not yet complete */
 	ret = -ENOANO;
 
diff --git a/arch/x86/kernel/pefile_parser.h b/arch/x86/kernel/pefile_parser.h
index e28a7e1..19c7ddc 100644
--- a/arch/x86/kernel/pefile_parser.h
+++ b/arch/x86/kernel/pefile_parser.h
@@ -29,3 +29,8 @@ struct pefile_context {
 };
 
 extern int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen);
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
 
-- 
1.9.0

