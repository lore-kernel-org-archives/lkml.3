Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3HVLEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:04:23 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33705 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3HVLER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:04:17 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 06/18] asymmetric keys: support parsing PKCS #8 private key information
Date: Thu, 22 Aug 2013 19:01:45 +0800
Message-Id: <1377169317-5959-7-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ASN.1 files and parser to support parsing PKCS #8 noncompressed private
key information. It's better than direct parsing pure private key because
PKCS #8 has a privateKeyAlgorithm to indicate the algorithm of private
key, e.g. RSA from PKCS #1

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/asymmetric_keys/Kconfig             |   11 ++
 crypto/asymmetric_keys/Makefile            |   16 +++
 crypto/asymmetric_keys/pkcs8.asn1          |   19 ++++
 crypto/asymmetric_keys/pkcs8_info_parser.c |  152 ++++++++++++++++++++++++++++
 crypto/asymmetric_keys/pkcs8_parser.h      |   23 ++++
 crypto/asymmetric_keys/pkcs8_private_key.c |  148 +++++++++++++++++++++++++++
 crypto/asymmetric_keys/pkcs8_rsakey.asn1   |   29 ++++++
 crypto/asymmetric_keys/public_key.c        |    1 +
 include/crypto/public_key.h                |    1 +
 9 files changed, 400 insertions(+), 0 deletions(-)
 create mode 100644 crypto/asymmetric_keys/pkcs8.asn1
 create mode 100644 crypto/asymmetric_keys/pkcs8_info_parser.c
 create mode 100644 crypto/asymmetric_keys/pkcs8_parser.h
 create mode 100644 crypto/asymmetric_keys/pkcs8_private_key.c
 create mode 100644 crypto/asymmetric_keys/pkcs8_rsakey.asn1

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 6d2c2ea..c0ebd57 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -35,4 +35,15 @@ config X509_CERTIFICATE_PARSER
 	  data and provides the ability to instantiate a crypto key from a
 	  public key packet found inside the certificate.
 
+config PKCS8_PRIVATE_KEY_INFO_PARSER
+	tristate "PKCS #8 private key info parser"
+	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+	select ASN1
+	select OID_REGISTRY
+	select CRYPTO_SHA256
+	help
+	  This option provides support for parsing PKCS #8 RSA private key info
+	  format blobs for key data and provides the ability to instantiate a
+	  crypto key from a private key packet.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 0727204..65fbc45 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -23,5 +23,21 @@ $(obj)/x509_cert_parser.o: $(obj)/x509-asn1.h $(obj)/x509_rsakey-asn1.h
 $(obj)/x509-asn1.o: $(obj)/x509-asn1.c $(obj)/x509-asn1.h
 $(obj)/x509_rsakey-asn1.o: $(obj)/x509_rsakey-asn1.c $(obj)/x509_rsakey-asn1.h
 
+#
+# PKCS8 Private Key handling
+#
+obj-$(CONFIG_PKCS8_PRIVATE_KEY_INFO_PARSER) += pkcs8_key_parser.o
+pkcs8_key_parser-y := \
+       pkcs8-asn1.o \
+       pkcs8_rsakey-asn1.o \
+       pkcs8_info_parser.o \
+       pkcs8_private_key.o
+
+$(obj)/pkcs8_info_parser.o: $(obj)/pkcs8-asn1.c $(obj)/pkcs8_rsakey-asn1.h
+$(obj)/pkcs8-asn1.o: $(obj)/pkcs8-asn1.c $(obj)/pkcs8-asn1.h
+$(obj)/pkcs8_rsakey-asn1.o: $(obj)/pkcs8_rsakey-asn1.c $(obj)/pkcs8_rsakey-asn1.h
+
 clean-files	+= x509-asn1.c x509-asn1.h
 clean-files	+= x509_rsakey-asn1.c x509_rsakey-asn1.h
+clean-files	+= pkcs8-asn1.c pkcs8-asn1.h
+clean-files	+= pkcs8_rsakey-asn1.c pkcs8_rsakey-asn1.h
diff --git a/crypto/asymmetric_keys/pkcs8.asn1 b/crypto/asymmetric_keys/pkcs8.asn1
new file mode 100644
index 0000000..89e845d
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs8.asn1
@@ -0,0 +1,19 @@
+--
+-- Representation of RSA PKCS#8 private key information.
+--
+
+PrivateKeyInfo ::= SEQUENCE {
+	version			Version,
+        privateKeyAlgorithm	AlgorithmIdentifier,
+	privateKey	        OCTET STRING ({ pkcs8_extract_key_data })
+	-- Does not support attributes
+	-- attributes		[ 0 ] Attributes OPTIONAL
+	}
+
+-- Version ::= INTEGER { two-prime(0), multi(1) }
+Version ::= INTEGER
+
+AlgorithmIdentifier ::= SEQUENCE {
+        algorithm               OBJECT IDENTIFIER ({ pkcs8_note_OID }),
+        parameters              ANY OPTIONAL
+	}
diff --git a/crypto/asymmetric_keys/pkcs8_info_parser.c b/crypto/asymmetric_keys/pkcs8_info_parser.c
new file mode 100644
index 0000000..2da19b9
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs8_info_parser.c
@@ -0,0 +1,152 @@
+/* X.509 certificate parser
+ *
+ * Copyright (C) 2013 SUSE Linux Products GmbH. All rights reserved.
+ * Written by Lee, Chun-Yi (jlee@suse.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "PKCS8: "fmt
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/oid_registry.h>
+#include "public_key.h"
+#include "pkcs8_parser.h"
+#include "pkcs8-asn1.h"
+#include "pkcs8_rsakey-asn1.h"
+
+struct pkcs8_parse_context {
+	struct pkcs8_info *info;		/* Certificate being constructed */
+	unsigned long   data;			/* Start of data */
+	const void      *key;                   /* Key data */
+	size_t          key_size;               /* Size of key data */
+	enum OID	algo_oid;		/* Algorithm OID */
+	unsigned char   nr_mpi;		/* Number of MPIs stored */
+};
+
+/*
+ * Free an PKCS #8 private key info
+ */
+void pkcs8_free_info(struct pkcs8_info *info)
+{
+	if (info) {
+		public_key_destroy(info->priv);
+		kfree(info);
+	}
+}
+
+/*
+ * Parse an PKCS #8 Private Key Info
+ */
+struct pkcs8_info *pkcs8_info_parse(const void *data, size_t datalen)
+{
+	struct pkcs8_info *info;
+	struct pkcs8_parse_context *ctx;
+	long ret;
+
+	ret = -ENOMEM;
+	info = kzalloc(sizeof(struct pkcs8_info), GFP_KERNEL);
+	if (!info)
+		goto error_no_info;
+	info->priv = kzalloc(sizeof(struct private_key), GFP_KERNEL);
+	if (!info->priv)
+		goto error_no_ctx;
+	ctx = kzalloc(sizeof(struct pkcs8_parse_context), GFP_KERNEL);
+	if (!ctx)
+		goto error_no_ctx;
+
+	ctx->info = info;
+	ctx->data = (unsigned long)data;
+
+	/* Attempt to decode the private key info */
+	ret = asn1_ber_decoder(&pkcs8_decoder, ctx, data, datalen);
+	if (ret < 0)
+		goto error_decode;
+
+	/* Decode the private key */
+	ret = asn1_ber_decoder(&pkcs8_rsakey_decoder, ctx,
+			       ctx->key, ctx->key_size);
+	if (ret < 0)
+		goto error_decode;
+
+	kfree(ctx);
+	return info;
+
+error_decode:
+	kfree(ctx);
+error_no_ctx:
+	pkcs8_free_info(info);
+error_no_info:
+	return ERR_PTR(ret);
+}
+
+/*
+ * Note an OID when we find one for later processing when we know how
+ * to interpret it.
+ */
+int pkcs8_note_OID(void *context, size_t hdrlen,
+	     unsigned char tag,
+	     const void *value, size_t vlen)
+{
+	struct pkcs8_parse_context *ctx = context;
+
+	ctx->algo_oid = look_up_OID(value, vlen);
+	if (ctx->algo_oid == OID__NR) {
+		char buffer[50];
+		sprint_oid(value, vlen, buffer, sizeof(buffer));
+		pr_debug("Unknown OID: [%lu] %s\n",
+			 (unsigned long)value - ctx->data, buffer);
+	}
+	return 0;
+}
+
+/*
+ * Extract the data for the private key algorithm
+ */
+int pkcs8_extract_key_data(void *context, size_t hdrlen,
+		unsigned char tag,
+		const void *value, size_t vlen)
+{
+	struct pkcs8_parse_context *ctx = context;
+
+	if (ctx->algo_oid != OID_rsaEncryption)
+		return -ENOPKG;
+
+	ctx->info->privkey_algo = PKEY_ALGO_RSA;
+	ctx->key = value;
+	ctx->key_size = vlen;
+	return 0;
+}
+
+/*
+ * Extract a RSA private key value
+ */
+int rsa_priv_extract_mpi(void *context, size_t hdrlen,
+		    unsigned char tag,
+		    const void *value, size_t vlen)
+{
+	struct pkcs8_parse_context *ctx = context;
+	MPI mpi;
+
+	if (ctx->nr_mpi >= ARRAY_SIZE(ctx->info->priv->mpi)) {
+		/* does not grab exponent1, exponent2 and coefficient */
+		if (ctx->nr_mpi > 8) {
+			pr_err("Too many public key MPIs in pkcs1 private key\n");
+			return -EBADMSG;
+		} else {
+			ctx->nr_mpi++;
+			return 0;
+		}
+	}
+
+	mpi = mpi_read_raw_data(value, vlen);
+	if (!mpi)
+		return -ENOMEM;
+
+	ctx->info->priv->mpi[ctx->nr_mpi++] = mpi;
+	return 0;
+}
diff --git a/crypto/asymmetric_keys/pkcs8_parser.h b/crypto/asymmetric_keys/pkcs8_parser.h
new file mode 100644
index 0000000..7f5d801
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs8_parser.h
@@ -0,0 +1,23 @@
+/* PKCS #8 parser internal definitions
+ *
+ * Copyright (C) 2013 SUSE Linux Products GmbH. All rights reserved.
+ * Written by Lee, Chun-Yi (jlee@suse.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <crypto/public_key.h>
+
+struct pkcs8_info {
+	enum pkey_algo privkey_algo:8;		/* Private key algorithm */
+	struct private_key *priv;		/* Private key */
+};
+
+/*
+ * pkcs8_parser.c
+ */
+extern void pkcs8_free_info(struct pkcs8_info *info);
+extern struct pkcs8_info *pkcs8_info_parse(const void *data, size_t datalen);
diff --git a/crypto/asymmetric_keys/pkcs8_private_key.c b/crypto/asymmetric_keys/pkcs8_private_key.c
new file mode 100644
index 0000000..cf2545b
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs8_private_key.c
@@ -0,0 +1,148 @@
+/* Instantiate a private key crypto key
+ *
+ * Copyright (C) 2013 SUSE Linux Products GmbH. All rights reserved.
+ * Written by Chun-Yi Lee (jlee@suse.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "PKCS8: "fmt
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <keys/asymmetric-subtype.h>
+#include <keys/asymmetric-parser.h>
+#include <crypto/hash.h>
+#include "private_key.h"
+#include "pkcs8-asn1.h"
+#include "pkcs8_parser.h"
+
+#define KEY_PREFIX "Private Key: "
+#define FINGERPRINT_HASH "sha256"
+
+static const
+struct private_key_algorithm *pkcs8_private_key_algorithms[PKEY_ALGO__LAST] = {
+	[PKEY_ALGO_DSA]         = NULL,
+#if defined(CONFIG_PUBLIC_KEY_ALGO_RSA) || \
+	defined(CONFIG_PUBLIC_KEY_ALGO_RSA_MODULE)
+	[PKEY_ALGO_RSA]         = &RSA_private_key_algorithm,
+#endif
+};
+
+/*
+ * Attempt to parse a data blob for a private key.
+ */
+static int pkcs8_key_preparse(struct key_preparsed_payload *prep)
+{
+	struct pkcs8_info *info;
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	u8 *digest;
+	size_t digest_size, desc_size;
+	char *fingerprint, *description;
+	int i, ret;
+
+	pr_info("pkcs8_key_preparse start\n");
+
+	info = pkcs8_info_parse(prep->data, prep->datalen);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->priv->algo = pkcs8_private_key_algorithms[info->privkey_algo];
+	info->priv->id_type = PKEY_ID_PKCS8;
+
+	/* Hash the pkcs #8 blob to generate fingerprint */
+	tfm = crypto_alloc_shash(FINGERPRINT_HASH, 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto error_shash;
+	}
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+
+	ret = -ENOMEM;
+
+	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
+	if (!digest)
+		goto error_digest;
+	desc = (void *) digest + digest_size;
+	desc->tfm = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error_shash_init;
+	ret = crypto_shash_finup(desc, prep->data, prep->datalen, digest);
+	if (ret < 0)
+		goto error_shash_finup;
+
+	fingerprint = kzalloc(digest_size * 2 + 1, GFP_KERNEL);
+	if (!fingerprint)
+		goto error_fingerprint;
+	for (i = 0; i < digest_size; i++)
+		sprintf(fingerprint + i * 2, "%02x", digest[i]);
+
+	/* Propose a description */
+	description = kzalloc(strlen(KEY_PREFIX) + strlen(fingerprint) + 1, GFP_KERNEL);
+	if (!description)
+		goto error_description;
+	sprintf(description, "%s", KEY_PREFIX);
+	memcpy(description + strlen(KEY_PREFIX), fingerprint, strlen(fingerprint));
+
+	/* We're pinning the module by being linked against it */
+	__module_get(private_key_subtype.owner);
+	prep->type_data[0] = &private_key_subtype;
+	prep->type_data[1] = fingerprint;
+	prep->payload = info->priv;
+	prep->description = description;
+
+	/* size of 4096 bits private key file is 2.3K */
+	prep->quotalen = 700;
+
+	pr_info("pkcs8_key_preparse done\n");
+
+	/* We've finished with the information */
+	kfree(digest);
+	crypto_free_shash(tfm);
+	info->priv = NULL;
+	pkcs8_free_info(info);
+
+	return 0;
+
+error_description:
+	kfree(fingerprint);
+error_fingerprint:
+error_shash_finup:
+error_shash_init:
+	kfree(digest);
+error_digest:
+	crypto_free_shash(tfm);
+error_shash:
+	info->priv = NULL;
+	pkcs8_free_info(info);
+	return ret;
+}
+
+static struct asymmetric_key_parser pkcs8_private_key_parser = {
+	.owner	= THIS_MODULE,
+	.name	= "pkcs8",
+	.parse	= pkcs8_key_preparse,
+};
+
+/*
+ * Module stuff
+ */
+static int __init pkcs8_private_key_init(void)
+{
+	return register_asymmetric_key_parser(&pkcs8_private_key_parser);
+}
+
+static void __exit pkcs8_private_key_exit(void)
+{
+	unregister_asymmetric_key_parser(&pkcs8_private_key_parser);
+}
+
+module_init(pkcs8_private_key_init);
+module_exit(pkcs8_private_key_exit);
diff --git a/crypto/asymmetric_keys/pkcs8_rsakey.asn1 b/crypto/asymmetric_keys/pkcs8_rsakey.asn1
new file mode 100644
index 0000000..d997c5e
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs8_rsakey.asn1
@@ -0,0 +1,29 @@
+--
+-- Representation of RSA private key with information.
+--
+
+RSAPrivateKey ::= SEQUENCE {
+	version			Version,
+	modulus                 INTEGER ({ rsa_priv_extract_mpi }),	-- n
+	publicExponent          INTEGER ({ rsa_priv_extract_mpi }),	-- e
+	privateExponent         INTEGER ({ rsa_priv_extract_mpi }),	-- d
+	prime1                  INTEGER ({ rsa_priv_extract_mpi }),	-- p
+	prime2                  INTEGER ({ rsa_priv_extract_mpi }),	-- q
+	exponent1               INTEGER ({ rsa_priv_extract_mpi }),	-- d mod (p-1)
+	exponent2               INTEGER ({ rsa_priv_extract_mpi }),	-- d mod (q-1)
+	coefficient             INTEGER ({ rsa_priv_extract_mpi })	-- (inverse of q) mod p
+	-- Doesn't support multi-prime
+	-- otherPrimeInfos         [ 0 ] OtherPrimeInfos OPTIONAL
+	}
+
+-- Version ::= INTEGER { two-prime(0), multi(1) }
+Version ::= INTEGER
+
+-- OtherPrimeInfos ::= SEQUENCE SIZE(1..MAX) OF OtherPrimeInfo
+OtherPrimeInfos ::= SEQUENCE OF OtherPrimeInfo
+
+OtherPrimeInfo ::= SEQUENCE {
+    prime             INTEGER,  -- ri
+    exponent          INTEGER,  -- di
+    coefficient       INTEGER   -- ti
+}
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 97ff932..1636c4c 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -44,6 +44,7 @@ EXPORT_SYMBOL_GPL(pkey_hash_algo);
 const char *const pkey_id_type[PKEY_ID_TYPE__LAST] = {
 	[PKEY_ID_PGP]		= "PGP",
 	[PKEY_ID_X509]		= "X509",
+	[PKEY_ID_PKCS8]         = "PKCS8",
 };
 EXPORT_SYMBOL_GPL(pkey_id_type);
 
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 1cdf457..e51f294 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -41,6 +41,7 @@ extern const char *const pkey_hash_algo[PKEY_HASH__LAST];
 enum pkey_id_type {
 	PKEY_ID_PGP,		/* OpenPGP generated key ID */
 	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
+	PKEY_ID_PKCS8,		/* PKCS #8 Private Key */
 	PKEY_ID_TYPE__LAST
 };
 
-- 
1.6.4.2

