Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaDCQVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:21:02 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56093 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbaDCQUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:20:55 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 4/9] crypto: qce: Add ablkcipher algorithms
Date: Thu,  3 Apr 2014 19:18:01 +0300
Message-Id: <1396541886-10966-5-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the implementation of AES, DES and 3DES crypto API
callbacks, the crypto register alg function, the async request
handler and its dma done callback function.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/qce/ablkcipher.c | 397 ++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/cipher.h     |  62 +++++++
 2 files changed, 459 insertions(+)
 create mode 100644 drivers/crypto/qce/ablkcipher.c
 create mode 100644 drivers/crypto/qce/cipher.h

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
new file mode 100644
index 000000000000..364162187c8c
--- /dev/null
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -0,0 +1,397 @@
+/*
+ * Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <crypto/des.h>
+
+#include "dma.h"
+#include "core.h"
+#include "common.h"
+#include "cipher.h"
+
+static void qce_ablkcipher_dma_done(void *data)
+{
+	struct crypto_async_request *async_req = data;
+	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
+	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	struct qce_result_dump *result = qce->dma.result_buf;
+	enum dma_data_direction dir_src, dir_dst;
+	u32 status;
+	int error;
+
+	dir_src = (req->src == req->dst) ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE;
+	dir_dst = (req->src == req->dst) ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
+
+	qce_dma_terminate_all(&qce->dma);
+
+	if (req->src != req->dst)
+		qce_unmapsg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src,
+			    rctx->dst_chained);
+	qce_unmapsg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst,
+		    rctx->dst_chained);
+
+	sg_free_table(&rctx->dst_tbl);
+
+	error = qce_check_status(qce, &status);
+	if (error < 0)
+		dev_err(qce->dev, "ablkcipher operation error (%x)\n", status);
+
+	if (IS_ECB(rctx->flags))
+		goto done;
+
+	memcpy(ctx->iv, result->encr_cntr_iv, rctx->ivsize);
+
+done:
+	tmpl->async_req_done(tmpl->qce, error);
+}
+
+static int
+qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
+{
+	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
+	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	enum dma_data_direction dir_src, dir_dst;
+	struct scatterlist *sg;
+	bool diff_dst;
+	gfp_t gfp;
+	int rc;
+
+	rctx->iv = req->info;
+	rctx->ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	rctx->cryptlen = req->nbytes;
+
+	diff_dst = (req->src != req->dst) ? true : false;
+
+	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
+	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;
+
+	rctx->src_nents = qce_countsg(req->src, req->nbytes,
+				      &rctx->src_chained);
+	if (diff_dst) {
+		rctx->dst_nents = qce_countsg(req->dst, req->nbytes,
+					      &rctx->dst_chained);
+	} else {
+		rctx->dst_nents = rctx->src_nents;
+		rctx->dst_chained = rctx->src_chained;
+	}
+
+	rctx->dst_nents += 1;
+
+	gfp = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+						GFP_KERNEL : GFP_ATOMIC;
+
+	rc = sg_alloc_table(&rctx->dst_tbl, rctx->dst_nents, gfp);
+	if (rc)
+		return rc;
+
+	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
+
+	sg = qce_sgtable_add(&rctx->dst_tbl, req->dst);
+	if (IS_ERR(sg)) {
+		rc = PTR_ERR(sg);
+		goto error_free;
+	}
+
+	sg = qce_sgtable_add(&rctx->dst_tbl, &rctx->result_sg);
+	if (IS_ERR(sg)) {
+		rc = PTR_ERR(sg);
+		goto error_free;
+	}
+
+	sg_mark_end(sg);
+	rctx->dst_sg = rctx->dst_tbl.sgl;
+
+	rc = qce_mapsg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst,
+		       rctx->dst_chained);
+	if (rc < 0)
+		goto error_free;
+
+	if (diff_dst) {
+		rc = qce_mapsg(qce->dev, req->src, rctx->src_nents, dir_src,
+			       rctx->src_chained);
+		if (rc < 0)
+			goto error_unmap_dst;
+		rctx->src_sg = req->src;
+	} else {
+		rctx->src_sg = rctx->dst_sg;
+	}
+
+	rc = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, rctx->src_nents,
+			      rctx->dst_sg, rctx->dst_nents,
+			      qce_ablkcipher_dma_done, async_req);
+	if (rc)
+		goto error_unmap_src;
+
+	qce_dma_issue_pending(&qce->dma);
+
+	rc = qce_start(async_req, tmpl->crypto_alg_type, req->nbytes, 0);
+	if (rc)
+		goto error_terminate;
+
+	return 0;
+
+error_terminate:
+	qce_dma_terminate_all(&qce->dma);
+error_unmap_src:
+	if (diff_dst)
+		qce_unmapsg(qce->dev, req->src, rctx->src_nents, dir_src,
+			    rctx->src_chained);
+error_unmap_dst:
+	qce_unmapsg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst,
+		    rctx->dst_chained);
+error_free:
+	sg_free_table(&rctx->dst_tbl);
+	return rc;
+}
+
+static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
+				 unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk);
+	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(&ablk->base);
+	u32 flags = tmpl->alg_flags;
+	int ret = 0;
+
+	if (!key || !keylen)
+		return -EINVAL;
+
+	if (IS_AES(flags)) {
+		switch (keylen) {
+		case AES_KEYSIZE_128:
+		case AES_KEYSIZE_256:
+			break;
+		default:
+			goto badkey;
+		}
+	} else if (IS_DES(flags)) {
+		u32 tmp[DES_EXPKEY_WORDS];
+
+		if (keylen != QCE_DES_KEY_SIZE)
+			goto badkey;
+
+		ret = des_ekey(tmp, key);
+		if (!ret && crypto_ablkcipher_get_flags(ablk) &
+		    CRYPTO_TFM_REQ_WEAK_KEY)
+			goto weakkey;
+	} else if (IS_3DES(flags)) {
+		if (keylen != DES3_EDE_KEY_SIZE)
+			goto badkey;
+	}
+
+	ctx->enc_keylen = keylen;
+	memcpy(ctx->enc_key, key, keylen);
+	return 0;
+badkey:
+	crypto_ablkcipher_set_flags(ablk, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+weakkey:
+	crypto_ablkcipher_set_flags(ablk, CRYPTO_TFM_RES_WEAK_KEY);
+	return -EINVAL;
+}
+
+static int qce_ablkcipher_encrypt(struct ablkcipher_request *req)
+{
+	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(req->base.tfm);
+
+	rctx->flags = QCE_ENCRYPT | tmpl->alg_flags;
+	return tmpl->async_req_queue(tmpl->qce, &req->base);
+}
+
+static int qce_ablkcipher_decrypt(struct ablkcipher_request *req)
+{
+	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(req->base.tfm);
+
+	rctx->flags = QCE_DECRYPT | tmpl->alg_flags;
+	return tmpl->async_req_queue(tmpl->qce, &req->base);
+}
+
+static int qce_ablkcipher_init(struct crypto_tfm *tfm)
+{
+	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	get_random_bytes(ctx->iv, QCE_MAX_IV_SIZE);
+	tfm->crt_ablkcipher.reqsize = sizeof(struct qce_cipher_reqctx);
+	return 0;
+}
+
+static void qce_ablkcipher_exit(struct crypto_tfm *tfm)
+{
+}
+
+struct qce_ablkcipher_def {
+	u32 flags;
+	const char *name;
+	const char *drv_name;
+	unsigned int blocksize;
+	unsigned int ivsize;
+	unsigned int min_keysize;
+	unsigned int max_keysize;
+};
+
+static const struct qce_ablkcipher_def ablkcipher_def[] = {
+	{
+		.flags		= QCE_ALG_AES | QCE_MODE_ECB,
+		.name		= "ecb(aes)",
+		.drv_name	= "ecb-aes-qce",
+		.blocksize	= AES_BLOCK_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+	},
+	{
+		.flags		= QCE_ALG_AES | QCE_MODE_CBC,
+		.name		= "cbc(aes)",
+		.drv_name	= "cbc-aes-qce",
+		.blocksize	= AES_BLOCK_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+	},
+	{
+		.flags		= QCE_ALG_AES | QCE_MODE_CTR,
+		.name		= "ctr(aes)",
+		.drv_name	= "ctr-aes-qce",
+		.blocksize	= AES_BLOCK_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+	},
+	{
+		.flags		= QCE_ALG_AES | QCE_MODE_XTS,
+		.name		= "xts(aes)",
+		.drv_name	= "xts-aes-qce",
+		.blocksize	= AES_BLOCK_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+	},
+	{
+		.flags		= QCE_ALG_DES | QCE_MODE_ECB,
+		.name		= "ecb(des)",
+		.drv_name	= "ecb-des-qce",
+		.blocksize	= DES_BLOCK_SIZE,
+		.ivsize		= 0,
+		.min_keysize	= QCE_DES_KEY_SIZE,
+		.max_keysize	= QCE_DES_KEY_SIZE,
+	},
+	{
+		.flags		= QCE_ALG_DES | QCE_MODE_CBC,
+		.name		= "cbc(des)",
+		.drv_name	= "cbc-des-qce",
+		.blocksize	= DES_BLOCK_SIZE,
+		.ivsize		= DES_BLOCK_SIZE,
+		.min_keysize	= QCE_DES_KEY_SIZE,
+		.max_keysize	= QCE_DES_KEY_SIZE,
+	},
+	{
+		.flags		= QCE_ALG_3DES | QCE_MODE_ECB,
+		.name		= "ecb(des3_ede)",
+		.drv_name	= "ecb-3des-qce",
+		.blocksize	= DES3_EDE_BLOCK_SIZE,
+		.ivsize		= 0,
+		.min_keysize	= DES3_EDE_KEY_SIZE,
+		.max_keysize	= DES3_EDE_KEY_SIZE,
+	},
+	{
+		.flags		= QCE_ALG_3DES | QCE_MODE_CBC,
+		.name		= "cbc(des3_ede)",
+		.drv_name	= "cbc-3des-qce",
+		.blocksize	= DES3_EDE_BLOCK_SIZE,
+		.ivsize		= DES3_EDE_BLOCK_SIZE,
+		.min_keysize	= DES3_EDE_KEY_SIZE,
+		.max_keysize	= DES3_EDE_KEY_SIZE,
+	},
+};
+
+static int qce_ablk_register_one(const struct qce_ablkcipher_def *def,
+				 struct qce_device *qce,
+				 struct qce_algo_ops *ops)
+{
+	struct qce_alg_template *tmpl;
+	struct crypto_alg *alg;
+	struct list_head *alg_list = &qce->alg_list;
+	int rc;
+
+	tmpl = kzalloc(sizeof(*tmpl), GFP_KERNEL);
+	if (!tmpl)
+		return -ENOMEM;
+
+	alg = &tmpl->alg.crypto;
+
+	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
+	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 def->drv_name);
+
+	alg->cra_blocksize = def->blocksize;
+	alg->cra_ablkcipher.ivsize = def->ivsize;
+	alg->cra_ablkcipher.min_keysize = def->min_keysize;
+	alg->cra_ablkcipher.max_keysize = def->max_keysize;
+	alg->cra_ablkcipher.setkey = qce_ablkcipher_setkey;
+	alg->cra_ablkcipher.encrypt = qce_ablkcipher_encrypt;
+	alg->cra_ablkcipher.decrypt = qce_ablkcipher_decrypt;
+
+	alg->cra_priority = 300;
+	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+	alg->cra_ctxsize = sizeof(struct qce_cipher_ctx);
+	alg->cra_alignmask = 0;
+	alg->cra_type = &crypto_ablkcipher_type;
+	alg->cra_module = THIS_MODULE;
+	alg->cra_init = qce_ablkcipher_init;
+	alg->cra_exit = qce_ablkcipher_exit;
+	INIT_LIST_HEAD(&alg->cra_list);
+
+	INIT_LIST_HEAD(&tmpl->entry);
+	tmpl->crypto_alg_type = CRYPTO_ALG_TYPE_ABLKCIPHER;
+	tmpl->alg_flags = def->flags;
+	tmpl->qce = qce;
+	tmpl->async_req_queue = ops->async_req_queue;
+	tmpl->async_req_done = ops->async_req_done;
+	ops->async_req_handle = qce_ablkcipher_async_req_handle;
+
+	rc = crypto_register_alg(alg);
+	if (rc) {
+		dev_err(qce->dev, "%s registration failed\n", alg->cra_name);
+		kfree(tmpl);
+		return rc;
+	}
+
+	list_add_tail(&tmpl->entry, alg_list);
+	dev_info(qce->dev, "%s is registered\n", alg->cra_name);
+	return 0;
+}
+
+int qce_ablkcipher_register(struct qce_device *qce, struct qce_algo_ops *ops)
+{
+	int rc, i;
+
+	for (i = 0; i < ARRAY_SIZE(ablkcipher_def); i++) {
+		rc = qce_ablk_register_one(&ablkcipher_def[i], qce, ops);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
new file mode 100644
index 000000000000..df6d31b4a241
--- /dev/null
+++ b/drivers/crypto/qce/cipher.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CIPHER_H_
+#define _CIPHER_H_
+
+struct qce_cipher_ctx {
+	u8 iv[QCE_MAX_IV_SIZE];
+	u8 enc_key[QCE_MAX_KEY_SIZE];
+	unsigned int enc_keylen;
+};
+
+/*
+ * @flags: operation flags
+ * @iv: pointer to the IV
+ * @ivsize: IV size
+ * @src_nents: source entries
+ * @dst_nents: destination entries
+ * @src_chained: is source chained
+ * @dst_chained: is destination chained
+ * @result_sg: scatterlist used for result buffer
+ * @dst_tbl: destination sg table
+ * @dst_sg: destination sg pointer table beginning;
+ * @src_tbl: source sg table
+ * @src_sg: source sg pointer table beginning;
+ * @cryptlen: crypto length
+ */
+struct qce_cipher_reqctx {
+	u32 flags;
+	u8 *iv;
+	unsigned int ivsize;
+	int src_nents;
+	int dst_nents;
+	bool src_chained;
+	bool dst_chained;
+	struct scatterlist result_sg;
+	struct sg_table dst_tbl;
+	struct scatterlist *dst_sg;
+	struct sg_table src_tbl;
+	struct scatterlist *src_sg;
+	unsigned int cryptlen;
+};
+
+static inline struct qce_alg_template *to_cipher_tmpl(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	return container_of(alg, struct qce_alg_template, alg.crypto);
+}
+
+int qce_ablkcipher_register(struct qce_device *qce, struct qce_algo_ops *ops);
+
+#endif /* _CIPHER_H_ */
-- 
1.8.4.4

