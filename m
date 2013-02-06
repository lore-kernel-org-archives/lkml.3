Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3BFTEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:04:33 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41971 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab3BFTEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:04:31 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ima: use new crypto_shash API instead of old crypto_hash
Date: Wed,  6 Feb 2013 14:04:13 -0500
Message-Id: <1360177454-5233-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020619-7182-0000-0000-0000050862B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

Old crypto hash API internally uses shash API.
Using shash API directly is more efficient.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h        |  1 +
 security/integrity/ima/ima_crypto.c | 75 ++++++++++++++++++-------------------
 security/integrity/ima/ima_init.c   |  3 ++
 3 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index ab68bed..5a94f9c 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -89,6 +89,7 @@ int ima_calc_template_hash(int template_len, void *template, char *digest);
 int ima_calc_boot_aggregate(char *digest);
 void ima_add_violation(struct inode *inode, const unsigned char *filename,
 		       const char *op, const char *cause);
+int ima_init_crypto(void);
 
 /*
  * used to protect h_table and sha_table
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index b21ee5b..920f49c 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -19,24 +19,22 @@
 #include <linux/scatterlist.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <crypto/hash.h>
 #include "ima.h"
 
-static int init_desc(struct hash_desc *desc)
+static struct crypto_shash *ima_shash_tfm;
+
+int ima_init_crypto(void)
 {
-	int rc;
+	long rc;
 
-	desc->tfm = crypto_alloc_hash(ima_hash, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(desc->tfm)) {
-		pr_info("IMA: failed to load %s transform: %ld\n",
-			ima_hash, PTR_ERR(desc->tfm));
-		rc = PTR_ERR(desc->tfm);
+	ima_shash_tfm = crypto_alloc_shash(ima_hash, 0, 0);
+	if (IS_ERR(ima_shash_tfm)) {
+		rc = PTR_ERR(ima_shash_tfm);
+		pr_err("Can not allocate %s (reason: %ld)\n", ima_hash, rc);
 		return rc;
 	}
-	desc->flags = 0;
-	rc = crypto_hash_init(desc);
-	if (rc)
-		crypto_free_hash(desc->tfm);
-	return rc;
+	return 0;
 }
 
 /*
@@ -44,13 +42,18 @@ static int init_desc(struct hash_desc *desc)
  */
 int ima_calc_hash(struct file *file, char *digest)
 {
-	struct hash_desc desc;
-	struct scatterlist sg[1];
 	loff_t i_size, offset = 0;
 	char *rbuf;
 	int rc, read = 0;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(ima_shash_tfm)];
+	} desc;
 
-	rc = init_desc(&desc);
+	desc.shash.tfm = ima_shash_tfm;
+	desc.shash.flags = 0;
+
+	rc = crypto_shash_init(&desc.shash);
 	if (rc != 0)
 		return rc;
 
@@ -75,19 +78,17 @@ int ima_calc_hash(struct file *file, char *digest)
 		if (rbuf_len == 0)
 			break;
 		offset += rbuf_len;
-		sg_init_one(sg, rbuf, rbuf_len);
 
-		rc = crypto_hash_update(&desc, sg, rbuf_len);
+		rc = crypto_shash_update(&desc.shash, rbuf, rbuf_len);
 		if (rc)
 			break;
 	}
 	kfree(rbuf);
 	if (!rc)
-		rc = crypto_hash_final(&desc, digest);
+		rc = crypto_shash_final(&desc.shash, digest);
 	if (read)
 		file->f_mode &= ~FMODE_READ;
 out:
-	crypto_free_hash(desc.tfm);
 	return rc;
 }
 
@@ -96,20 +97,15 @@ out:
  */
 int ima_calc_template_hash(int template_len, void *template, char *digest)
 {
-	struct hash_desc desc;
-	struct scatterlist sg[1];
-	int rc;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(ima_shash_tfm)];
+	} desc;
 
-	rc = init_desc(&desc);
-	if (rc != 0)
-		return rc;
+	desc.shash.tfm = ima_shash_tfm;
+	desc.shash.flags = 0;
 
-	sg_init_one(sg, template, template_len);
-	rc = crypto_hash_update(&desc, sg, template_len);
-	if (!rc)
-		rc = crypto_hash_final(&desc, digest);
-	crypto_free_hash(desc.tfm);
-	return rc;
+	return crypto_shash_digest(&desc.shash, template, template_len, digest);
 }
 
 static void __init ima_pcrread(int idx, u8 *pcr)
@@ -126,12 +122,17 @@ static void __init ima_pcrread(int idx, u8 *pcr)
  */
 int __init ima_calc_boot_aggregate(char *digest)
 {
-	struct hash_desc desc;
-	struct scatterlist sg;
 	u8 pcr_i[IMA_DIGEST_SIZE];
 	int rc, i;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(ima_shash_tfm)];
+	} desc;
+
+	desc.shash.tfm = ima_shash_tfm;
+	desc.shash.flags = 0;
 
-	rc = init_desc(&desc);
+	rc = crypto_shash_init(&desc.shash);
 	if (rc != 0)
 		return rc;
 
@@ -139,11 +140,9 @@ int __init ima_calc_boot_aggregate(char *digest)
 	for (i = TPM_PCR0; i < TPM_PCR8; i++) {
 		ima_pcrread(i, pcr_i);
 		/* now accumulate with current aggregate */
-		sg_init_one(&sg, pcr_i, IMA_DIGEST_SIZE);
-		rc = crypto_hash_update(&desc, &sg, IMA_DIGEST_SIZE);
+		rc = crypto_shash_update(&desc.shash, pcr_i, IMA_DIGEST_SIZE);
 	}
 	if (!rc)
-		crypto_hash_final(&desc, digest);
-	crypto_free_hash(desc.tfm);
+		crypto_shash_final(&desc.shash, digest);
 	return rc;
 }
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index b5dfd53..162ea72 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -85,6 +85,9 @@ int __init ima_init(void)
 	if (!ima_used_chip)
 		pr_info("IMA: No TPM chip found, activating TPM-bypass!\n");
 
+	rc = ima_init_crypto();
+	if (rc)
+		return rc;
 	ima_add_boot_aggregate();	/* boot aggregate must be first entry */
 	ima_init_policy();
 
-- 
1.8.1.rc3

