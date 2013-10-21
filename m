Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3JUWni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:43:38 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47079 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab3JUWne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:34 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 10/23] ima: ima_calc_boot_agregate must use SHA1
Date: Mon, 21 Oct 2013 18:42:55 -0400
Message-Id: <1382395388-8108-11-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-5806-0000-0000-0000232916A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

With multiple hash algorithms, ima_hash_tfm is no longer guaranteed to be sha1.
Need to force to use sha1.

Changelog:
- pass ima_digest_data to ima_calc_boot_aggregate() instead of char *
  (Roberto Sassu);
- create an ima_digest_data structure in ima_add_boot_aggregate()
  (Roberto Sassu);
- pass hash->algo to ima_alloc_tfm() (Roberto Sassu, reported by Dmitry).
- "move hash definition in ima_add_boot_aggregate()" commit hunk to here.
- sparse warning fix - Fengguang Wu

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h        |  2 +-
 security/integrity/ima/ima_crypto.c | 24 +++++++++++++++++++++---
 security/integrity/ima/ima_init.c   | 10 +++++++++-
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 52393ed..e0e1cde 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -73,7 +73,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
 int ima_calc_buffer_hash(const void *data, int len,
 			 struct ima_digest_data *hash);
-int ima_calc_boot_aggregate(char *digest);
+int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
 void ima_add_violation(struct inode *inode, const unsigned char *filename,
 		       const char *op, const char *cause);
 int ima_init_crypto(void);
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index e2be252..22be23f 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -184,16 +184,17 @@ static void __init ima_pcrread(int idx, u8 *pcr)
 /*
  * Calculate the boot aggregate hash
  */
-int __init ima_calc_boot_aggregate(char *digest)
+static int __init ima_calc_boot_aggregate_tfm(char *digest,
+					      struct crypto_shash *tfm)
 {
 	u8 pcr_i[TPM_DIGEST_SIZE];
 	int rc, i;
 	struct {
 		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(ima_shash_tfm)];
+		char ctx[crypto_shash_descsize(tfm)];
 	} desc;
 
-	desc.shash.tfm = ima_shash_tfm;
+	desc.shash.tfm = tfm;
 	desc.shash.flags = 0;
 
 	rc = crypto_shash_init(&desc.shash);
@@ -210,3 +211,20 @@ int __init ima_calc_boot_aggregate(char *digest)
 		crypto_shash_final(&desc.shash, digest);
 	return rc;
 }
+
+int __init ima_calc_boot_aggregate(struct ima_digest_data *hash)
+{
+	struct crypto_shash *tfm;
+	int rc;
+
+	tfm = ima_alloc_tfm(hash->algo);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	hash->length = crypto_shash_digestsize(tfm);
+	rc = ima_calc_boot_aggregate_tfm(hash->digest, tfm);
+
+	ima_free_tfm(tfm);
+
+	return rc;
+}
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 9d0243c..77cd500 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -18,6 +18,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <crypto/hash_info.h>
 #include "ima.h"
 
 /* name for boot aggregate entry */
@@ -46,6 +47,10 @@ static void __init ima_add_boot_aggregate(void)
 	const char *audit_cause = "ENOMEM";
 	int result = -ENOMEM;
 	int violation = 1;
+	struct {
+		struct ima_digest_data hdr;
+		char digest[TPM_DIGEST_SIZE];
+	} hash;
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
@@ -56,12 +61,15 @@ static void __init ima_add_boot_aggregate(void)
 		IMA_EVENT_NAME_LEN_MAX);
 	if (ima_used_chip) {
 		violation = 0;
-		result = ima_calc_boot_aggregate(entry->template.digest);
+		hash.hdr.algo = HASH_ALGO_SHA1;
+		result = ima_calc_boot_aggregate(&hash.hdr);
 		if (result < 0) {
 			audit_cause = "hashing_error";
 			kfree(entry);
 			goto err_out;
 		}
+		memcpy(entry->template.digest, hash.hdr.digest,
+		       hash.hdr.length);
 	}
 	result = ima_store_template(entry, violation, NULL);
 	if (result < 0)
-- 
1.8.1.4

