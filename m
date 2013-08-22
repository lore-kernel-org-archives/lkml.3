Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3HVLDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:03:23 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57940 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3HVLDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:03:19 -0400
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
Subject: [PATCH 01/18] asymmetric keys: add interface and skeleton for implement signature generation
Date: Thu, 22 Aug 2013 19:01:40 +0800
Message-Id: <1377169317-5959-2-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generate_signature interface on signature.c, asymmetric-subtype and
rsa.c for prepare to implement signature generation.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/asymmetric_keys/private_key.h |   29 +++++++++++++++++++++++++++++
 crypto/asymmetric_keys/public_key.c  |   31 +++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/rsa.c         |   22 ++++++++++++++++++++++
 crypto/asymmetric_keys/signature.c   |   28 ++++++++++++++++++++++++++++
 include/crypto/public_key.h          |   25 +++++++++++++++++++++++++
 include/keys/asymmetric-subtype.h    |    6 ++++++
 6 files changed, 141 insertions(+), 0 deletions(-)
 create mode 100644 crypto/asymmetric_keys/private_key.h

diff --git a/crypto/asymmetric_keys/private_key.h b/crypto/asymmetric_keys/private_key.h
new file mode 100644
index 0000000..c022eee
--- /dev/null
+++ b/crypto/asymmetric_keys/private_key.h
@@ -0,0 +1,29 @@
+/* Private key algorithm internals
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
+#include <crypto/public_key.h>
+
+extern struct asymmetric_key_subtype private_key_subtype;
+
+/*
+ * Private key algorithm definition.
+ */
+struct private_key_algorithm {
+	const char	*name;
+	u8		n_pub_mpi;	/* Number of MPIs in public key */
+	u8		n_sec_mpi;	/* Number of MPIs in secret key */
+	u8		n_sig_mpi;	/* Number of MPIs in a signature */
+	struct public_key_signature* (*generate_signature)(
+		const struct private_key *key, u8 *M,
+		enum pkey_hash_algo hash_algo, const bool hash);
+};
+
+extern const struct private_key_algorithm RSA_private_key_algorithm;
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index cb2e291..97ff932 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <keys/asymmetric-subtype.h>
 #include "public_key.h"
+#include "private_key.h"
 
 MODULE_LICENSE("GPL");
 
@@ -96,6 +97,24 @@ static int public_key_verify_signature(const struct key *key,
 }
 
 /*
+ * Generate a signature using a private key.
+ */
+static struct public_key_signature *private_key_generate_signature(
+		const struct key *key, u8 *M, enum pkey_hash_algo hash_algo,
+		const bool hash)
+{
+	const struct private_key *pk = key->payload.data;
+
+	pr_info("private_key_generate_signature start");
+
+	if (!pk->algo->generate_signature)
+		return ERR_PTR(-ENOTSUPP);
+
+	return pk->algo->generate_signature(pk, M, hash_algo, hash);
+
+}
+
+/*
  * Public key algorithm asymmetric key subtype
  */
 struct asymmetric_key_subtype public_key_subtype = {
@@ -106,3 +125,15 @@ struct asymmetric_key_subtype public_key_subtype = {
 	.verify_signature	= public_key_verify_signature,
 };
 EXPORT_SYMBOL_GPL(public_key_subtype);
+
+/*
+ * Private key algorithm asymmetric key subtype
+ */
+struct asymmetric_key_subtype private_key_subtype = {
+	.owner                  = THIS_MODULE,
+	.name                   = "private_key",
+	.describe               = public_key_describe,
+	.destroy                = public_key_destroy,
+	.generate_signature     = private_key_generate_signature,
+};
+EXPORT_SYMBOL_GPL(private_key_subtype);
diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 4a6a069..95aab83 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include "public_key.h"
+#include "private_key.h"
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RSA Public Key Algorithm");
@@ -267,6 +268,18 @@ error:
 	return ret;
 }
 
+/*
+ * Perform the generation step [RFC3447 sec 8.2.1].
+ */
+static struct public_key_signature *RSA_generate_signature(
+		const struct private_key *key, u8 *M,
+		enum pkey_hash_algo hash_algo, const bool hash)
+{
+	pr_info("RSA_generate_signature start");
+
+	return 0;
+}
+
 const struct public_key_algorithm RSA_public_key_algorithm = {
 	.name		= "RSA",
 	.n_pub_mpi	= 2,
@@ -275,3 +288,12 @@ const struct public_key_algorithm RSA_public_key_algorithm = {
 	.verify_signature = RSA_verify_signature,
 };
 EXPORT_SYMBOL_GPL(RSA_public_key_algorithm);
+
+const struct private_key_algorithm RSA_private_key_algorithm = {
+	.name           = "RSA",
+	.n_pub_mpi      = 2,
+	.n_sec_mpi      = 3,
+	.n_sig_mpi      = 1,
+	.generate_signature = RSA_generate_signature,
+};
+EXPORT_SYMBOL_GPL(RSA_private_key_algorithm);
diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
index 50b3f88..a1bf6be 100644
--- a/crypto/asymmetric_keys/signature.c
+++ b/crypto/asymmetric_keys/signature.c
@@ -47,3 +47,31 @@ int verify_signature(const struct key *key,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(verify_signature);
+
+/**
+ * generate_signature - Initiate the use of an asymmetric key to generate a signature
+ * @key: The asymmetric key to generate against
+ * @M: The message to be signed, or a hash result. Dependent on the hash parameter
+ * @hash_algo: The hash algorithm to generate digest
+ * @hash: true means M is a original mesagse, false means M is a hash result
+ *
+ * Returns public_key-signature if successful or else an error.
+ */
+struct public_key_signature *generate_signature(const struct key *key, u8 *M,
+		enum pkey_hash_algo hash_algo, const bool hash)
+{
+	const struct asymmetric_key_subtype *subtype;
+
+	pr_info("==>%s()\n", __func__);
+
+	if (key->type != &key_type_asymmetric)
+		return ERR_PTR(-EINVAL);
+	subtype = asymmetric_key_subtype(key);
+	if (!subtype || !key->payload.data)
+		return ERR_PTR(-EINVAL);
+	if (!subtype->generate_signature)
+		return ERR_PTR(-ENOTSUPP);
+
+	return subtype->generate_signature(key, M, hash_algo, hash);
+}
+EXPORT_SYMBOL_GPL(generate_signature);
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index f5b0224..d44b29f 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -79,6 +79,29 @@ struct public_key {
 	};
 };
 
+struct private_key {
+	const struct private_key_algorithm *algo;
+	u8      capabilities;
+	enum pkey_id_type id_type:8;
+	union {
+		MPI     mpi[5];
+		struct {
+			MPI     p;      /* DSA prime */
+			MPI     q;      /* DSA group order */
+			MPI     g;      /* DSA group generator */
+			MPI     y;      /* DSA public-key value = g^x mod p */
+			MPI     x;      /* DSA secret exponent (if present) */
+		} dsa;
+		struct {
+			MPI     n;      /* RSA public modulus */
+			MPI     e;      /* RSA public encryption exponent */
+			MPI     d;      /* RSA secret encryption exponent (if present) */
+			MPI     p;      /* RSA secret prime (if present) */
+			MPI     q;      /* RSA secret prime (if present) */
+		} rsa;
+	};
+};
+
 extern void public_key_destroy(void *payload);
 
 /*
@@ -104,5 +127,7 @@ struct public_key_signature {
 struct key;
 extern int verify_signature(const struct key *key,
 			    const struct public_key_signature *sig);
+extern struct public_key_signature *generate_signature(const struct key *key,
+			u8 *M, enum pkey_hash_algo hash_algo, const bool hash);
 
 #endif /* _LINUX_PUBLIC_KEY_H */
diff --git a/include/keys/asymmetric-subtype.h b/include/keys/asymmetric-subtype.h
index 4b840e8..af79939 100644
--- a/include/keys/asymmetric-subtype.h
+++ b/include/keys/asymmetric-subtype.h
@@ -18,6 +18,7 @@
 #include <keys/asymmetric-type.h>
 
 struct public_key_signature;
+enum pkey_hash_algo;
 
 /*
  * Keys of this type declare a subtype that indicates the handlers and
@@ -37,6 +38,11 @@ struct asymmetric_key_subtype {
 	/* Verify the signature on a key of this subtype (optional) */
 	int (*verify_signature)(const struct key *key,
 				const struct public_key_signature *sig);
+
+	/* Generate the signature by key of this subtype (optional) */
+	struct public_key_signature* (*generate_signature)
+		(const struct key *key, u8 *M, enum pkey_hash_algo hash_algo,
+		 const bool hash);
 };
 
 /**
-- 
1.6.4.2

