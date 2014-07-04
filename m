Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbaGDMHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:07:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12801 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaGDMGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:06:48 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-60-53b698d403f3
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 1/3] ima: use ahash API for file hash calculation
Date: Fri, 04 Jul 2014 15:05:26 +0300
Message-id: <dc5977267c662c98f02cd637dd44c42be850916f.1404475462.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1404475462.git.d.kasatkin@samsung.com>
References: <cover.1404475462.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1404475462.git.d.kasatkin@samsung.com>
References: <cover.1404475462.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4Zd0rM7YFG/y5IWlx6+9eZosvS+ss
	7t/7yWTxcsY8dovLu+awWXzoecRm8WnFJGYHdo+ds+6yezw4tJnFY/eCz0wefVtWMXp83iQX
	wBrFZZOSmpNZllqkb5fAlXFs9R+Wgl82Fa/n3WRrYJxl2MXIySEhYCKxrG8tO4QtJnHh3nq2
	LkYuDiGBpYwSd9d+ZIZwOpkk9k9dxwhSxSagJ7Gh+QdYh4hAjsSkMxfAipgFWhklDjz6zgyS
	EBZwkbjxcDsbiM0ioCrR/OkqWAOvQJxE97wfbBDr5CROHpvMCmJzClhJLJj4FqiXA2ibpcTp
	xzE4hCcw8i9gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERKCX3cwLj1mdYhRgINRiYe3
	oWVbsBBrYllxZe4hRgkOZiUR3gN9QCHelMTKqtSi/Pii0pzU4kOMTBycUg2M0U0h4hwqzA02
	dtET3yfs1j/CNLf3+1E/AYuJhyofl/nu9/TeycmreeLUlwKXk/oK3KK6R41rJv/9un15Q1n0
	ihJlo+V1R2auSD/o1rFi/bG83Nfnnn2stORInBEnVtd+/uSN/yH28/1mV6xbfn3vTW2N+7Lq
	gauCd6jGHF6YMk+4oenjrSAOJZbijERDLeai4kQAKZ2DUx8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Async hash API allows to use HW acceleration for hash calculation.
It may give significant performance gain or/and reduce power consumption,
which might be very beneficial for battery powered devices.

This patch introduces hash calculation using ahash API.

ahash performance depends on data size and particular HW. Under certain
limit, depending on the system, shash performance may be better.

This patch defines 'ahash_minsize' module parameter which can be used to
define minimal file size to use with ahash. When file size is not set
or smaller than defined by the parameter, shash will be used.

Changes in v3:
- kernel parameter replaced with module parameter
- pr_crit replaced with pr_crit_ratelimited

Changes in v2:
- ima_ahash_size became as ima_ahash
- ahash pre-allocation moved out from __init code to be able to use
  ahash crypto modules. Ahash allocated once on the first use.
- hash calculation falls back to shash if ahash allocation/calculation fails
- complex initialization separated from variable declaration
- improved comments

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 Documentation/kernel-parameters.txt |   9 ++
 security/integrity/ima/ima_crypto.c | 185 +++++++++++++++++++++++++++++++++++-
 2 files changed, 190 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5a214a3..03c8452 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1318,6 +1318,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Formats: { "ima" | "ima-ng" }
 			Default: "ima-ng"
 
+	ima.ahash_minsize= [IMA] Minimum file size for asynchronous hash usage
+			Format: <min_file_size>
+			Set the minimal file size for using asynchronous hash.
+			If left unspecified, ahash usage is disabled.
+
+			ahash performance varies for different data sizes on
+			different crypto accelerators. This option can be used
+			to achieve best performance for particular HW.
+
 	init=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /sbin/init as init
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index f82d1d7..bc38160 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -16,6 +16,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/ratelimit.h>
 #include <linux/file.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
@@ -25,7 +27,18 @@
 #include <crypto/hash_info.h>
 #include "ima.h"
 
+struct ahash_completion {
+	struct completion completion;
+	int err;
+};
+
+/* minimum file size for ahash use */
+static unsigned long ima_ahash_minsize;
+module_param_named(ahash_minsize, ima_ahash_minsize, ulong, 0644);
+MODULE_PARM_DESC(ahash_minsize, "Minimum file size for ahash use");
+
 static struct crypto_shash *ima_shash_tfm;
+static struct crypto_ahash *ima_ahash_tfm;
 
 /**
  * ima_kernel_read - read file content
@@ -93,9 +106,146 @@ static void ima_free_tfm(struct crypto_shash *tfm)
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
+	if ((algo != ima_hash_algo && algo < HASH_ALGO__LAST) || !tfm) {
+		tfm = crypto_alloc_ahash(hash_algo_name[algo], 0, 0);
+		if (!IS_ERR(tfm)) {
+			if (algo == ima_hash_algo)
+				ima_ahash_tfm = tfm;
+		} else {
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
+		pr_crit_ratelimited("ahash calculation failed: err: %d\n", err);
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
+	req = ahash_request_alloc(tfm, GFP_KERNEL);
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
@@ -156,7 +306,7 @@ out:
 	return rc;
 }
 
-int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
+static int ima_calc_file_shash(struct file *file, struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
 	int rc;
@@ -172,6 +322,33 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	return rc;
 }
 
+/**
+ * ima_calc_file_hash - calculae file hash
+ *
+ * if ima_ahash_minsize parameter is non-zero, this function uses
+ * ahash for hash caclulation. ahash performance varies for different
+ * data sizes on different crypto accelerators. shash performance might
+ * be better for small file. 'ima.ahash_minsize' module parameter allows
+ * to specify the best value for the system.
+ *
+ * If ahash fails, it fallbacks to shash.
+ */
+int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
+{
+	loff_t i_size;
+	int rc;
+
+	i_size = i_size_read(file_inode(file));
+
+	if (ima_ahash_minsize && i_size >= ima_ahash_minsize) {
+		rc = ima_calc_file_ahash(file, hash);
+		if (!rc)
+			return 0;
+	}
+
+	return ima_calc_file_shash(file, hash);
+}
+
 /*
  * Calculate the hash of template data
  */
-- 
1.9.1

