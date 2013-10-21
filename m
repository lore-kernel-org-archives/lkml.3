Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3JUWnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:43:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58963 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3JUWnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:32 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 08/23] ima: provide dedicated hash algo allocation function
Date: Mon, 21 Oct 2013 18:42:53 -0400
Message-Id: <1382395388-8108-9-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-8236-0000-0000-000002F7D1A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

This patch provides dedicated hash algo allocation and
deallocation function which can be used by different clients.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_crypto.c | 43 +++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 872c669..e5d3ebf 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -39,6 +39,28 @@ int ima_init_crypto(void)
 	return 0;
 }
 
+static struct crypto_shash *ima_alloc_tfm(enum hash_algo algo)
+{
+	struct crypto_shash *tfm = ima_shash_tfm;
+	int rc;
+
+	if (algo != ima_hash_algo && algo < HASH_ALGO__LAST) {
+		tfm = crypto_alloc_shash(hash_algo_name[algo], 0, 0);
+		if (IS_ERR(tfm)) {
+			rc = PTR_ERR(tfm);
+			pr_err("Can not allocate %s (reason: %d)\n",
+			       hash_algo_name[algo], rc);
+		}
+	}
+	return tfm;
+}
+
+static void ima_free_tfm(struct crypto_shash *tfm)
+{
+	if (tfm != ima_shash_tfm)
+		crypto_free_shash(tfm);
+}
+
 /*
  * Calculate the MD5/SHA1 file digest
  */
@@ -57,6 +79,8 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	desc.shash.tfm = tfm;
 	desc.shash.flags = 0;
 
+	hash->length = crypto_shash_digestsize(tfm);
+
 	rc = crypto_shash_init(&desc.shash);
 	if (rc != 0)
 		return rc;
@@ -98,25 +122,16 @@ out:
 
 int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 {
-	struct crypto_shash *tfm = ima_shash_tfm;
+	struct crypto_shash *tfm;
 	int rc;
 
-	if (hash->algo != ima_hash_algo && hash->algo < HASH_ALGO__LAST) {
-		tfm = crypto_alloc_shash(hash_algo_name[hash->algo], 0, 0);
-		if (IS_ERR(tfm)) {
-			rc = PTR_ERR(tfm);
-			pr_err("Can not allocate %s (reason: %d)\n",
-			       hash_algo_name[hash->algo], rc);
-			return rc;
-		}
-	}
-
-	hash->length = crypto_shash_digestsize(tfm);
+	tfm = ima_alloc_tfm(hash->algo);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
 
 	rc = ima_calc_file_hash_tfm(file, hash, tfm);
 
-	if (tfm != ima_shash_tfm)
-		crypto_free_shash(tfm);
+	ima_free_tfm(tfm);
 
 	return rc;
 }
-- 
1.8.1.4

