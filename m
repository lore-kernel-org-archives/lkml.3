Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbaFSPWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:22:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18490 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbaFSPVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:21:30 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c5-53a2fff6db5f
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 1/3] ima: use ahash API for file hash calculation
Date: Thu, 19 Jun 2014 18:20:38 +0300
Message-id: <7b884b2597badabadf50ebf9120fe76754e1516c.1403191191.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1403191191.git.d.kasatkin@samsung.com>
References: <cover.1403191191.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1403191191.git.d.kasatkin@samsung.com>
References: <cover.1403191191.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Nd1v/xcFG1w+YWNx6+9eZosvS+ss
	7t/7yWTxcsY8dovLu+awWXzoecRm8WnFJGYHdo+ds+6yezw4tJnFY/eCz0wefVtWMXp83iQX
	wBrFZZOSmpNZllqkb5fAlbF84hfGgitmFXNXzmBsYOzQ6WLk5JAQMJGYv2UNC4QtJnHh3nq2
	LkYuDiGBpYwSrd2XGSGcTiaJnoXNjCBVbAJ6Ehuaf7CD2CICXYwSF58pg9jMAukSnyb1gsWF
	BVwkPm7dCDaVRUBVYu+HT2wgNq9AnMSK/hdMENvkJE4em8wKYnMKWElcmnsDbL6QgKXE/kk7
	GXGJT2DkX8DIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJAi/7GBcfMzqEKMAB6MSD++H
	twuChVgTy4orcw8xSnAwK4nw7v66KFiINyWxsiq1KD++qDQntfgQIxMHp1QDo3+t6VIRlmqt
	P71ikSrMTr1WB4WCOzY7G55ddvs7b1MR06uAVy+X7aq9KLuyUCSJ4VrK9+Uclg/Xf4reVLVh
	e5I/40Pt8FKp9w+y3O5WlpdsXTapzLJZ1P65YPmqYMZovtjk7bvmGqWWbpCs0L2eFdUcuOaB
	8OtjH++tORph23Ci2MzolqmrEktxRqKhFnNRcSIA80HVRCACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Async hash API allows to use HW acceleration for hash calculation.
It may give significant performance gain or/and reduce power consumption,
which might be very beneficial for battery powered devices.

This patch introduces hash calculation using ahash API.

ahash peformance depends on data size and particular HW. Under certain
limit, depending on the system, shash performance may be better.

This patch also introduces 'ima_ahash_size' kernel parameter which can
be used to defines minimal data size to use with ahash. When this
parameter is not set or file size is smaller than defined by this
parameter, shash will be used. Thus, by defult, original shash
implementation is used.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 Documentation/kernel-parameters.txt |   3 +
 security/integrity/ima/ima_crypto.c | 182 +++++++++++++++++++++++++++++++++++-
 2 files changed, 181 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c155c..f8efb01 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1286,6 +1286,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
+	ima_ahash_size=size [IMA]
+			Set the minimal file size when use ahash API.
+
 	ima_appraise=	[IMA] appraise integrity measurements
 			Format: { "off" | "enforce" | "fix" }
 			default: "enforce"
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index ccd0ac8..b7a8650 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -25,7 +25,25 @@
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
+/* data size for ahash use */
+static loff_t ima_ahash_size;
+
+static int __init ima_ahash_setup(char *str)
+{
+	int rc = kstrtoll(str, 10, &ima_ahash_size);
+	pr_info("ima_ahash_size = %lld\n", ima_ahash_size);
+	return !rc;
+}
+__setup("ima_ahash_size=", ima_ahash_setup);
 
 /**
  * ima_kernel_read - read file content
@@ -68,6 +86,14 @@ int ima_init_crypto(void)
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
 
@@ -93,9 +119,143 @@ static void ima_free_tfm(struct crypto_shash *tfm)
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
+		rbuf_len = ima_kernel_read(file, offset, rbuf, PAGE_SIZE);
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
@@ -156,7 +316,7 @@ out:
 	return rc;
 }
 
-int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
+static int ima_calc_file_shash(struct file *file, struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
 	int rc;
@@ -172,6 +332,20 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	return rc;
 }
 
+int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
+{
+	loff_t i_size = i_size_read(file_inode(file));
+
+	/* shash is more efficient small data
+	 * ahash performance depends on data size and particular HW
+	 * ima_ahash_size allows to specify the best value for the system
+	 */
+	if (ima_ahash_size && i_size >= ima_ahash_size)
+		return ima_calc_file_ahash(file, hash);
+	else
+		return ima_calc_file_shash(file, hash);
+}
+
 /*
  * Calculate the hash of template data
  */
-- 
1.9.1

