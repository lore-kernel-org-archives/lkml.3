Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaB1PJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:09:17 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28073 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaB1PJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:09:14 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-f4-5310a698e6e4
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [RFC 1/2] ima: use ahash API for file hash calculation
Date: Fri, 28 Feb 2014 17:07:09 +0200
Message-id: <43db8e587691c0487aa2f860e93da09ca668ef55.1393599653.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1393599653.git.d.kasatkin@samsung.com>
References: <cover.1393599653.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1393599653.git.d.kasatkin@samsung.com>
References: <cover.1393599653.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xy7ozlgkEG5zZLGdxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugSuj6/NRpoLNuhWtJ0+xNzCuVuli5OSQEDCRuDF9JyOELSZx
	4d56ti5GLg4hgaWMEsf6u5ghnE4miTXdH1hBqtgE9CQ2NP9gB7FFBJwlFt1qZwUpYhaYyijx
	6tY0FpCEsIC9xJ0L08EaWARUJRrPLgJawcHBKxAn8e5wGMQ2BYllX9Yyg9icAlYSa9bfBrtC
	SMBS4k7jCyZc4hMY+RcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAnGLzsYFx+zOsQo
	wMGoxMMrsUggWIg1say4MvcQowQHs5II76XFQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MK4sn
	rJaqVX4mekwrLYpNNP6COZfv/U1bma81Okoudj1d3X28a1k0f/lC/QiZ36a8ud+yr36tOf//
	CMMkP2al34r3JobemlSze60yR+WXWnv+K6aZfCdC052e33oq/oY31/xK0ou9b+OPyzge493s
	YmK03VxPnNOY9+Cc29dlXk6on1t5sK5MiaU4I9FQi7moOBEAjatXYyQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Async hash API allows to use HW acceleration for hash calculation.
It may give significant performance gain or/and reduce power consumption,
which might be very beneficial for battery powered devices.

This patch introduces use of ahash API if 'ima_use_ahash' parameter is
specified on the command line.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_crypto.c | 180 +++++++++++++++++++++++++++++++++++-
 1 file changed, 176 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 1bde8e6..baf7a4d 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -25,7 +25,24 @@
 #include <crypto/hash_info.h>
 #include "ima.h"
 
+
+struct ahash_completion {
+	struct completion completion;
+	int err;
+};
+
 static struct crypto_shash *ima_shash_tfm;
+static struct crypto_ahash *ima_ahash_tfm;
+
+/* to compare performance, may be removed in the future */
+static int ima_use_ahash;
+
+static int __init ima_use_ahash_setup(char *str)
+{
+	ima_use_ahash = 1;
+	return 1;
+}
+__setup("ima_use_ahash", ima_use_ahash_setup);
 
 int ima_init_crypto(void)
 {
@@ -38,6 +55,14 @@ int ima_init_crypto(void)
 		       hash_algo_name[ima_hash_algo], rc);
 		return rc;
 	}
+	ima_ahash_tfm = crypto_alloc_ahash(hash_algo_name[ima_hash_algo], 0, 0);
+	if (IS_ERR(ima_ahash_tfm)) {
+		rc = PTR_ERR(ima_ahash_tfm);
+		crypto_free_shash(ima_shash_tfm);
+		pr_err("Can not allocate %s (reason: %ld)\n",
+		       hash_algo_name[ima_hash_algo], rc);
+		return rc;
+	}
 	return 0;
 }
 
@@ -63,9 +88,143 @@ static void ima_free_tfm(struct crypto_shash *tfm)
 		crypto_free_shash(tfm);
 }
 
-/*
- * Calculate the MD5/SHA1 file digest
- */
+static struct crypto_ahash *ima_alloc_atfm(enum hash_algo algo)
+{
+	struct crypto_ahash *tfm = ima_ahash_tfm;
+	int rc;
+
+	if (algo != ima_hash_algo && algo < HASH_ALGO__LAST) {
+		tfm = crypto_alloc_ahash(hash_algo_name[algo], 0, 0);
+		if (IS_ERR(tfm)) {
+			rc = PTR_ERR(tfm);
+			pr_err("Can not allocate %s (reason: %d)\n",
+			       hash_algo_name[algo], rc);
+		}
+	}
+	return tfm;
+}
+
+static void ima_free_atfm(struct crypto_ahash *tfm)
+{
+	if (tfm != ima_ahash_tfm)
+		crypto_free_ahash(tfm);
+}
+
+static void ahash_complete(struct crypto_async_request *req, int err)
+{
+	struct ahash_completion *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+	res->err = err;
+	complete(&res->completion);
+}
+
+static int ahash_wait(int err, struct ahash_completion *res)
+{
+	switch (err) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		wait_for_completion(&res->completion);
+		reinit_completion(&res->completion);
+		err = res->err;
+		/* fall through */
+	default:
+		pr_crit("ahash calculation failed: err: %d\n", err);
+	}
+
+	return err;
+}
+
+static int ima_calc_file_hash_atfm(struct file *file,
+				   struct ima_digest_data *hash,
+				   struct crypto_ahash *tfm)
+{
+	loff_t i_size, offset;
+	char *rbuf;
+	int rc, read = 0, rbuf_len;
+	struct ahash_request *req;
+	struct scatterlist sg[1];
+	struct ahash_completion res;
+
+	hash->length = crypto_ahash_digestsize(tfm);
+
+	req = ahash_request_alloc(ima_ahash_tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	init_completion(&res.completion);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				   CRYPTO_TFM_REQ_MAY_SLEEP,
+				   ahash_complete, &res);
+
+	rc = ahash_wait(crypto_ahash_init(req), &res);
+	if (rc)
+		goto out1;
+
+	i_size = i_size_read(file_inode(file));
+
+	if (i_size == 0)
+		goto out2;
+
+	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!rbuf) {
+		rc = -ENOMEM;
+		goto out1;
+	}
+
+	if (!(file->f_mode & FMODE_READ)) {
+		file->f_mode |= FMODE_READ;
+		read = 1;
+	}
+
+	for (offset = 0; offset < i_size; offset += rbuf_len) {
+		rbuf_len = kernel_read(file, offset, rbuf, PAGE_SIZE);
+		if (rbuf_len < 0) {
+			rc = rbuf_len;
+			break;
+		}
+		if (rbuf_len == 0)
+			break;
+
+		sg_init_one(&sg[0], rbuf, rbuf_len);
+		ahash_request_set_crypt(req, sg, NULL, rbuf_len);
+
+		rc = ahash_wait(crypto_ahash_update(req), &res);
+		if (rc)
+			break;
+	}
+	if (read)
+		file->f_mode &= ~FMODE_READ;
+	kfree(rbuf);
+out2:
+	if (!rc) {
+		ahash_request_set_crypt(req, NULL, hash->digest, 0);
+		rc = ahash_wait(crypto_ahash_final(req), &res);
+	}
+out1:
+	ahash_request_free(req);
+	return rc;
+}
+
+static int ima_calc_file_ahash(struct file *file, struct ima_digest_data *hash)
+{
+	struct crypto_ahash *tfm;
+	int rc;
+
+	tfm = ima_alloc_atfm(hash->algo);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	rc = ima_calc_file_hash_atfm(file, hash, tfm);
+
+	ima_free_atfm(tfm);
+
+	return rc;
+}
+
 static int ima_calc_file_hash_tfm(struct file *file,
 				  struct ima_digest_data *hash,
 				  struct crypto_shash *tfm)
@@ -126,7 +285,7 @@ out:
 	return rc;
 }
 
-int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
+static int ima_calc_file_shash(struct file *file, struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
 	int rc;
@@ -142,6 +301,19 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	return rc;
 }
 
+int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
+{
+	/*
+	 * use 'ima_use_hash' parameter for now
+	 * file size can be used to determine if async API makes sence
+	 * For small files shash may be faster
+	 */
+	if (ima_use_ahash)
+		return ima_calc_file_ahash(file, hash);
+	else
+		return ima_calc_file_shash(file, hash);
+}
+
 /*
  * Calculate the hash of template data
  */
-- 
1.8.3.2

