Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaFIMKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:10:18 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:32908 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932586AbaFIMKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:10:14 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 1/3] crypto: qce: Qualcomm crypto engine driver
Date: Mon,  9 Jun 2014 15:08:38 +0300
Message-Id: <1402315720-5042-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1402315720-5042-1-git-send-email-svarbanov@mm-sol.com>
References: <1402315720-5042-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is separated by functional parts. The core part
implements a platform driver probe and remove callbaks.
The probe enables clocks, checks crypto version, initialize
and request dma channels, create done tasklet and init
crypto queue and finally register the algorithms into crypto
core subsystem.

- DMA and SG helper functions
 implement dmaengine and sg-list helper functions used by
 other parts of the crypto driver.

- ablkcipher algorithms
 implementation of AES, DES and 3DES crypto API callbacks,
 the crypto register alg function, the async request handler
 and its dma done callback function.

- SHA and HMAC transforms
 implementation and registration of ahash crypto type.
 It includes sha1, sha256, hmac(sha1) and hmac(sha256).

- infrastructure to setup the crypto hw
 contains functions used to setup/prepare hardware registers for
 all algorithms supported by the crypto block. It also exports
 few helper functions needed by algorithms:
	- to check hardware status
	- to start crypto hardware
	- to translate data stream to big endian form

 Adds register addresses and bit/masks used by the driver
 as well.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/qce/ablkcipher.c |  431 ++++++++++++++++++++++++++++
 drivers/crypto/qce/cipher.h     |   68 +++++
 drivers/crypto/qce/common.c     |  435 +++++++++++++++++++++++++++++
 drivers/crypto/qce/common.h     |  102 +++++++
 drivers/crypto/qce/core.c       |  286 +++++++++++++++++++
 drivers/crypto/qce/core.h       |   68 +++++
 drivers/crypto/qce/dma.c        |  186 ++++++++++++
 drivers/crypto/qce/dma.h        |   58 ++++
 drivers/crypto/qce/regs-v5.h    |  334 ++++++++++++++++++++++
 drivers/crypto/qce/sha.c        |  588 +++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/sha.h        |   81 ++++++
 11 files changed, 2637 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/qce/ablkcipher.c
 create mode 100644 drivers/crypto/qce/cipher.h
 create mode 100644 drivers/crypto/qce/common.c
 create mode 100644 drivers/crypto/qce/common.h
 create mode 100644 drivers/crypto/qce/core.c
 create mode 100644 drivers/crypto/qce/core.h
 create mode 100644 drivers/crypto/qce/dma.c
 create mode 100644 drivers/crypto/qce/dma.h
 create mode 100644 drivers/crypto/qce/regs-v5.h
 create mode 100644 drivers/crypto/qce/sha.c
 create mode 100644 drivers/crypto/qce/sha.h

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
new file mode 100644
index 0000000..ad592de
--- /dev/null
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -0,0 +1,431 @@
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
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <crypto/des.h>
+
+#include "cipher.h"
+
+static LIST_HEAD(ablkcipher_algs);
+
+static void qce_ablkcipher_done(void *data)
+{
+	struct crypto_async_request *async_req = data;
+	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
+	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	enum dma_data_direction dir_src, dir_dst;
+	u32 status;
+	int error;
+	bool diff_dst;
+
+	diff_dst = (req->src != req->dst) ? true : false;
+	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
+	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;
+
+	error = qce_dma_terminate_all(&qce->dma);
+	if (error)
+		dev_dbg(qce->dev, "ablkcipher dma termination error (%d)\n",
+			error);
+
+	if (diff_dst)
+		qce_unmapsg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src,
+			    rctx->dst_chained);
+	qce_unmapsg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst,
+		    rctx->dst_chained);
+
+	sg_free_table(&rctx->dst_tbl);
+
+	error = qce_check_status(qce, &status);
+	if (error < 0)
+		dev_dbg(qce->dev, "ablkcipher operation error (%x)\n", status);
+
+	qce->async_req_done(tmpl->qce, error);
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
+	int ret;
+
+	rctx->iv = req->info;
+	rctx->ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	rctx->cryptlen = req->nbytes;
+
+	diff_dst = (req->src != req->dst) ? true : false;
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
+	ret = sg_alloc_table(&rctx->dst_tbl, rctx->dst_nents, gfp);
+	if (ret)
+		return ret;
+
+	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
+
+	sg = qce_sgtable_add(&rctx->dst_tbl, req->dst);
+	if (IS_ERR(sg)) {
+		ret = PTR_ERR(sg);
+		goto error_free;
+	}
+
+	sg = qce_sgtable_add(&rctx->dst_tbl, &rctx->result_sg);
+	if (IS_ERR(sg)) {
+		ret = PTR_ERR(sg);
+		goto error_free;
+	}
+
+	sg_mark_end(sg);
+	rctx->dst_sg = rctx->dst_tbl.sgl;
+
+	ret = qce_mapsg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst,
+			rctx->dst_chained);
+	if (ret < 0)
+		goto error_free;
+
+	if (diff_dst) {
+		ret = qce_mapsg(qce->dev, req->src, rctx->src_nents, dir_src,
+				rctx->src_chained);
+		if (ret < 0)
+			goto error_unmap_dst;
+		rctx->src_sg = req->src;
+	} else {
+		rctx->src_sg = rctx->dst_sg;
+	}
+
+	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, rctx->src_nents,
+			       rctx->dst_sg, rctx->dst_nents,
+			       qce_ablkcipher_done, async_req);
+	if (ret)
+		goto error_unmap_src;
+
+	qce_dma_issue_pending(&qce->dma);
+
+	ret = qce_start(async_req, tmpl->crypto_alg_type, req->nbytes, 0);
+	if (ret)
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
+	return ret;
+}
+
+static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
+				 unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk);
+	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	unsigned long flags = to_cipher_tmpl(tfm)->alg_flags;
+	int ret;
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
+			goto fallback;
+		}
+	} else if (IS_DES(flags)) {
+		u32 tmp[DES_EXPKEY_WORDS];
+
+		ret = des_ekey(tmp, key);
+		if (!ret && crypto_ablkcipher_get_flags(ablk) &
+		    CRYPTO_TFM_REQ_WEAK_KEY)
+			goto weakkey;
+	}
+
+	ctx->enc_keylen = keylen;
+	memcpy(ctx->enc_key, key, keylen);
+	return 0;
+fallback:
+	ret = crypto_ablkcipher_setkey(ctx->fallback, key, keylen);
+	if (!ret)
+		ctx->enc_keylen = keylen;
+	return ret;
+weakkey:
+	crypto_ablkcipher_set_flags(ablk, CRYPTO_TFM_RES_WEAK_KEY);
+	return -EINVAL;
+}
+
+static int qce_ablkcipher_crypt(struct ablkcipher_request *req, int encrypt)
+{
+	struct crypto_tfm *tfm =
+			crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
+	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(tfm);
+	int ret;
+
+	rctx->flags = tmpl->alg_flags;
+	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
+
+	if (IS_AES(rctx->flags) && ctx->enc_keylen != AES_KEYSIZE_128 &&
+	    ctx->enc_keylen != AES_KEYSIZE_256) {
+		ablkcipher_request_set_tfm(req, ctx->fallback);
+		ret = encrypt ? crypto_ablkcipher_encrypt(req) :
+				crypto_ablkcipher_decrypt(req);
+		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+		return ret;
+	}
+
+	return tmpl->qce->async_req_enqueue(tmpl->qce, &req->base);
+}
+
+static int qce_ablkcipher_encrypt(struct ablkcipher_request *req)
+{
+	return qce_ablkcipher_crypt(req, 1);
+}
+
+static int qce_ablkcipher_decrypt(struct ablkcipher_request *req)
+{
+	return qce_ablkcipher_crypt(req, 0);
+}
+
+static int qce_ablkcipher_init(struct crypto_tfm *tfm)
+{
+	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	tfm->crt_ablkcipher.reqsize = sizeof(struct qce_cipher_reqctx);
+
+	ctx->fallback = crypto_alloc_ablkcipher(crypto_tfm_alg_name(tfm),
+						CRYPTO_ALG_TYPE_ABLKCIPHER,
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->fallback))
+		return PTR_ERR(ctx->fallback);
+
+	return 0;
+}
+
+static void qce_ablkcipher_exit(struct crypto_tfm *tfm)
+{
+	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_ablkcipher(ctx->fallback);
+}
+
+struct qce_ablkcipher_def {
+	unsigned long flags;
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
+		.min_keysize	= DES_KEY_SIZE,
+		.max_keysize	= DES_KEY_SIZE,
+	},
+	{
+		.flags		= QCE_ALG_DES | QCE_MODE_CBC,
+		.name		= "cbc(des)",
+		.drv_name	= "cbc-des-qce",
+		.blocksize	= DES_BLOCK_SIZE,
+		.ivsize		= DES_BLOCK_SIZE,
+		.min_keysize	= DES_KEY_SIZE,
+		.max_keysize	= DES_KEY_SIZE,
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
+static int qce_ablkcipher_register_one(const struct qce_ablkcipher_def *def,
+				       struct qce_device *qce)
+{
+	struct qce_alg_template *tmpl;
+	struct crypto_alg *alg;
+	int ret;
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
+	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+			 CRYPTO_ALG_NEED_FALLBACK;
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
+
+	ret = crypto_register_alg(alg);
+	if (ret) {
+		kfree(tmpl);
+		dev_err(qce->dev, "%s registration failed\n", alg->cra_name);
+		return ret;
+	}
+
+	list_add_tail(&tmpl->entry, &ablkcipher_algs);
+	dev_dbg(qce->dev, "%s is registered\n", alg->cra_name);
+	return 0;
+}
+
+static void qce_ablkcipher_unregister(struct qce_device *qce)
+{
+	struct qce_alg_template *tmpl, *n;
+
+	list_for_each_entry_safe(tmpl, n, &ablkcipher_algs, entry) {
+		crypto_unregister_alg(&tmpl->alg.crypto);
+		list_del(&tmpl->entry);
+		kfree(tmpl);
+	}
+}
+
+static int qce_ablkcipher_register(struct qce_device *qce)
+{
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(ablkcipher_def); i++) {
+		ret = qce_ablkcipher_register_one(&ablkcipher_def[i], qce);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	qce_ablkcipher_unregister(qce);
+	return ret;
+}
+
+const struct qce_algo_ops ablkcipher_ops = {
+	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	.register_algs = qce_ablkcipher_register,
+	.unregister_algs = qce_ablkcipher_unregister,
+	.async_req_handle = qce_ablkcipher_async_req_handle,
+};
diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
new file mode 100644
index 0000000..d5757cf
--- /dev/null
+++ b/drivers/crypto/qce/cipher.h
@@ -0,0 +1,68 @@
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
+#include "common.h"
+#include "core.h"
+
+#define QCE_MAX_KEY_SIZE	64
+
+struct qce_cipher_ctx {
+	u8 enc_key[QCE_MAX_KEY_SIZE];
+	unsigned int enc_keylen;
+	struct crypto_ablkcipher *fallback;
+};
+
+/**
+ * struct qce_cipher_reqctx - holds private cipher objects per request
+ * @flags: operation flags
+ * @iv: pointer to the IV
+ * @ivsize: IV size
+ * @src_nents: source entries
+ * @dst_nents: destination entries
+ * @src_chained: is source chained
+ * @dst_chained: is destination chained
+ * @result_sg: scatterlist used for result buffer
+ * @dst_tbl: destination sg table
+ * @dst_sg: destination sg pointer table beginning
+ * @src_tbl: source sg table
+ * @src_sg: source sg pointer table beginning;
+ * @cryptlen: crypto length
+ */
+struct qce_cipher_reqctx {
+	unsigned long flags;
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
+extern const struct qce_algo_ops ablkcipher_ops;
+
+#endif /* _CIPHER_H_ */
diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
new file mode 100644
index 0000000..1cd4d5e
--- /dev/null
+++ b/drivers/crypto/qce/common.c
@@ -0,0 +1,435 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
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
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
+
+#include "cipher.h"
+#include "common.h"
+#include "core.h"
+#include "regs-v5.h"
+#include "sha.h"
+
+#define QCE_SECTOR_SIZE		512
+
+static inline u32 qce_read(struct qce_device *qce, u32 offset)
+{
+	return readl(qce->base + offset);
+}
+
+static inline void qce_write(struct qce_device *qce, u32 offset, u32 val)
+{
+	writel(val, qce->base + offset);
+}
+
+static inline void qce_write_array(struct qce_device *qce, u32 offset,
+				   const u32 *val, unsigned int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		qce_write(qce, offset + i * sizeof(u32), val[i]);
+}
+
+static inline void
+qce_clear_array(struct qce_device *qce, u32 offset, unsigned int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		qce_write(qce, offset + i * sizeof(u32), 0);
+}
+
+static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
+{
+	u32 cfg = 0;
+
+	if (IS_AES(flags)) {
+		if (aes_key_size == AES_KEYSIZE_128)
+			cfg |= ENCR_KEY_SZ_AES128 << ENCR_KEY_SZ_SHIFT;
+		else if (aes_key_size == AES_KEYSIZE_256)
+			cfg |= ENCR_KEY_SZ_AES256 << ENCR_KEY_SZ_SHIFT;
+	}
+
+	if (IS_AES(flags))
+		cfg |= ENCR_ALG_AES << ENCR_ALG_SHIFT;
+	else if (IS_DES(flags) || IS_3DES(flags))
+		cfg |= ENCR_ALG_DES << ENCR_ALG_SHIFT;
+
+	if (IS_DES(flags))
+		cfg |= ENCR_KEY_SZ_DES << ENCR_KEY_SZ_SHIFT;
+
+	if (IS_3DES(flags))
+		cfg |= ENCR_KEY_SZ_3DES << ENCR_KEY_SZ_SHIFT;
+
+	switch (flags & QCE_MODE_MASK) {
+	case QCE_MODE_ECB:
+		cfg |= ENCR_MODE_ECB << ENCR_MODE_SHIFT;
+		break;
+	case QCE_MODE_CBC:
+		cfg |= ENCR_MODE_CBC << ENCR_MODE_SHIFT;
+		break;
+	case QCE_MODE_CTR:
+		cfg |= ENCR_MODE_CTR << ENCR_MODE_SHIFT;
+		break;
+	case QCE_MODE_XTS:
+		cfg |= ENCR_MODE_XTS << ENCR_MODE_SHIFT;
+		break;
+	case QCE_MODE_CCM:
+		cfg |= ENCR_MODE_CCM << ENCR_MODE_SHIFT;
+		cfg |= LAST_CCM_XFR << LAST_CCM_SHIFT;
+		break;
+	default:
+		return ~0;
+	}
+
+	return cfg;
+}
+
+static u32 qce_auth_cfg(unsigned long flags, u32 key_size)
+{
+	u32 cfg = 0;
+
+	if (IS_AES(flags) && (IS_CCM(flags) || IS_CMAC(flags)))
+		cfg |= AUTH_ALG_AES << AUTH_ALG_SHIFT;
+	else
+		cfg |= AUTH_ALG_SHA << AUTH_ALG_SHIFT;
+
+	if (IS_CCM(flags) || IS_CMAC(flags)) {
+		if (key_size == AES_KEYSIZE_128)
+			cfg |= AUTH_KEY_SZ_AES128 << AUTH_KEY_SIZE_SHIFT;
+		else if (key_size == AES_KEYSIZE_256)
+			cfg |= AUTH_KEY_SZ_AES256 << AUTH_KEY_SIZE_SHIFT;
+	}
+
+	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags))
+		cfg |= AUTH_SIZE_SHA1 << AUTH_SIZE_SHIFT;
+	else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags))
+		cfg |= AUTH_SIZE_SHA256 << AUTH_SIZE_SHIFT;
+	else if (IS_CMAC(flags))
+		cfg |= AUTH_SIZE_ENUM_16_BYTES << AUTH_SIZE_SHIFT;
+
+	if (IS_SHA1(flags) || IS_SHA256(flags))
+		cfg |= AUTH_MODE_HASH << AUTH_MODE_SHIFT;
+	else if (IS_SHA1_HMAC(flags) || IS_SHA256_HMAC(flags) ||
+		 IS_CBC(flags) || IS_CTR(flags))
+		cfg |= AUTH_MODE_HMAC << AUTH_MODE_SHIFT;
+	else if (IS_AES(flags) && IS_CCM(flags))
+		cfg |= AUTH_MODE_CCM << AUTH_MODE_SHIFT;
+	else if (IS_AES(flags) && IS_CMAC(flags))
+		cfg |= AUTH_MODE_CMAC << AUTH_MODE_SHIFT;
+
+	if (IS_SHA(flags) || IS_SHA_HMAC(flags))
+		cfg |= AUTH_POS_BEFORE << AUTH_POS_SHIFT;
+
+	if (IS_CCM(flags))
+		cfg |= QCE_MAX_NONCE_WORDS << AUTH_NONCE_NUM_WORDS_SHIFT;
+
+	if (IS_CBC(flags) || IS_CTR(flags) || IS_CCM(flags) ||
+	    IS_CMAC(flags))
+		cfg |= BIT(AUTH_LAST_SHIFT) | BIT(AUTH_FIRST_SHIFT);
+
+	return cfg;
+}
+
+static u32 qce_config_reg(struct qce_device *qce, int little)
+{
+	u32 beats = (qce->burst_size >> 3) - 1;
+	u32 pipe_pair = qce->pipe_pair_id;
+	u32 config;
+
+	config = (beats << REQ_SIZE_SHIFT) & REQ_SIZE_MASK;
+	config |= BIT(MASK_DOUT_INTR_SHIFT) | BIT(MASK_DIN_INTR_SHIFT) |
+		  BIT(MASK_OP_DONE_INTR_SHIFT) | BIT(MASK_ERR_INTR_SHIFT);
+	config |= (pipe_pair << PIPE_SET_SELECT_SHIFT) & PIPE_SET_SELECT_MASK;
+	config &= ~HIGH_SPD_EN_N_SHIFT;
+
+	if (little)
+		config |= BIT(LITTLE_ENDIAN_MODE_SHIFT);
+
+	return config;
+}
+
+void qce_cpu_to_be32p_array(__be32 *dst, const u8 *src, unsigned int len)
+{
+	__be32 *d = dst;
+	const u8 *s = src;
+	unsigned int n;
+
+	n = len / sizeof(u32);
+	for (; n > 0; n--) {
+		*d = cpu_to_be32p((const __u32 *) s);
+		s += sizeof(__u32);
+		d++;
+	}
+}
+
+static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
+{
+	u8 swap[QCE_AES_IV_LENGTH];
+	u32 i, j;
+
+	if (ivsize > QCE_AES_IV_LENGTH)
+		return;
+
+	memset(swap, 0, QCE_AES_IV_LENGTH);
+
+	for (i = (QCE_AES_IV_LENGTH - ivsize), j = ivsize - 1;
+	     i < QCE_AES_IV_LENGTH; i++, j--)
+		swap[i] = src[j];
+
+	qce_cpu_to_be32p_array(dst, swap, QCE_AES_IV_LENGTH);
+}
+
+static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
+		       unsigned int enckeylen, unsigned int cryptlen)
+{
+	u32 xtskey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(u32)] = {0};
+	unsigned int xtsklen = enckeylen / (2 * sizeof(u32));
+	unsigned int xtsdusize;
+
+	qce_cpu_to_be32p_array(xtskey, enckey + enckeylen / 2, enckeylen / 2);
+	qce_write_array(qce, REG_ENCR_XTS_KEY0, xtskey, xtsklen);
+
+	/* xts du size 512B */
+	xtsdusize = min_t(u32, QCE_SECTOR_SIZE, cryptlen);
+	qce_write(qce, REG_ENCR_XTS_DU_SIZE, xtsdusize);
+}
+
+static void qce_setup_config(struct qce_device *qce)
+{
+	u32 config;
+
+	/* get big endianness */
+	config = qce_config_reg(qce, 0);
+
+	/* clear status */
+	qce_write(qce, REG_STATUS, 0);
+	qce_write(qce, REG_CONFIG, config);
+}
+
+static inline void qce_crypto_go(struct qce_device *qce)
+{
+	qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
+}
+
+static int qce_setup_regs_ahash(struct crypto_async_request *async_req,
+				u32 totallen, u32 offset)
+{
+	struct ahash_request *req = ahash_request_cast(async_req);
+	struct crypto_ahash *ahash = __crypto_ahash_cast(async_req->tfm);
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	unsigned int digestsize = crypto_ahash_digestsize(ahash);
+	unsigned int blocksize = crypto_tfm_alg_blocksize(async_req->tfm);
+	__be32 auth[SHA256_DIGEST_SIZE / sizeof(__be32)] = {0};
+	__be32 mackey[QCE_SHA_HMAC_KEY_SIZE / sizeof(__be32)] = {0};
+	u32 auth_cfg = 0, config;
+	unsigned int iv_words;
+
+	/* if not the last, the size has to be on the block boundary */
+	if (!rctx->last_blk && req->nbytes % blocksize)
+		return -EINVAL;
+
+	qce_setup_config(qce);
+
+	if (IS_CMAC(rctx->flags)) {
+		qce_write(qce, REG_AUTH_SEG_CFG, 0);
+		qce_write(qce, REG_ENCR_SEG_CFG, 0);
+		qce_write(qce, REG_ENCR_SEG_SIZE, 0);
+		qce_clear_array(qce, REG_AUTH_IV0, 16);
+		qce_clear_array(qce, REG_AUTH_KEY0, 16);
+		qce_clear_array(qce, REG_AUTH_BYTECNT0, 4);
+
+		auth_cfg = qce_auth_cfg(rctx->flags, rctx->authklen);
+	}
+
+	if (IS_SHA_HMAC(rctx->flags) || IS_CMAC(rctx->flags)) {
+		u32 authkey_words = rctx->authklen / sizeof(u32);
+
+		qce_cpu_to_be32p_array(mackey, rctx->authkey, rctx->authklen);
+		qce_write_array(qce, REG_AUTH_KEY0, mackey, authkey_words);
+	}
+
+	if (IS_CMAC(rctx->flags))
+		goto go_proc;
+
+	if (rctx->first_blk)
+		memcpy(auth, rctx->digest, digestsize);
+	else
+		qce_cpu_to_be32p_array(auth, rctx->digest, digestsize);
+
+	iv_words = (IS_SHA1(rctx->flags) || IS_SHA1_HMAC(rctx->flags)) ? 5 : 8;
+	qce_write_array(qce, REG_AUTH_IV0, auth, iv_words);
+
+	if (rctx->first_blk)
+		qce_clear_array(qce, REG_AUTH_BYTECNT0, 4);
+	else
+		qce_write_array(qce, REG_AUTH_BYTECNT0, rctx->byte_count, 2);
+
+	auth_cfg = qce_auth_cfg(rctx->flags, 0);
+
+	if (rctx->last_blk)
+		auth_cfg |= BIT(AUTH_LAST_SHIFT);
+	else
+		auth_cfg &= ~BIT(AUTH_LAST_SHIFT);
+
+	if (rctx->first_blk)
+		auth_cfg |= BIT(AUTH_FIRST_SHIFT);
+	else
+		auth_cfg &= ~BIT(AUTH_FIRST_SHIFT);
+
+go_proc:
+	qce_write(qce, REG_AUTH_SEG_CFG, auth_cfg);
+	qce_write(qce, REG_AUTH_SEG_SIZE, req->nbytes);
+	qce_write(qce, REG_AUTH_SEG_START, 0);
+	qce_write(qce, REG_ENCR_SEG_CFG, 0);
+	qce_write(qce, REG_SEG_SIZE, req->nbytes);
+
+	/* get little endianness */
+	config = qce_config_reg(qce, 1);
+	qce_write(qce, REG_CONFIG, config);
+
+	qce_crypto_go(qce);
+
+	return 0;
+}
+
+static int qce_setup_regs_ablkcipher(struct crypto_async_request *async_req,
+				     u32 totallen, u32 offset)
+{
+	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
+	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	__be32 enckey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(__be32)] = {0};
+	__be32 enciv[QCE_MAX_IV_SIZE / sizeof(__be32)] = {0};
+	unsigned int enckey_words, enciv_words;
+	unsigned int keylen;
+	u32 encr_cfg = 0, auth_cfg = 0, config;
+	unsigned int ivsize = rctx->ivsize;
+	unsigned long flags = rctx->flags;
+
+	qce_setup_config(qce);
+
+	if (IS_XTS(flags))
+		keylen = ctx->enc_keylen / 2;
+	else
+		keylen = ctx->enc_keylen;
+
+	qce_cpu_to_be32p_array(enckey, ctx->enc_key, keylen);
+	enckey_words = keylen / sizeof(u32);
+
+	qce_write(qce, REG_AUTH_SEG_CFG, auth_cfg);
+
+	encr_cfg = qce_encr_cfg(flags, keylen);
+
+	if (IS_DES(flags)) {
+		enciv_words = 2;
+		enckey_words = 2;
+	} else if (IS_3DES(flags)) {
+		enciv_words = 2;
+		enckey_words = 6;
+	} else if (IS_AES(flags)) {
+		if (IS_XTS(flags))
+			qce_xtskey(qce, ctx->enc_key, ctx->enc_keylen,
+				   rctx->cryptlen);
+		enciv_words = 4;
+	} else {
+		return -EINVAL;
+	}
+
+	qce_write_array(qce, REG_ENCR_KEY0, enckey, enckey_words);
+
+	if (!IS_ECB(flags)) {
+		if (IS_XTS(flags))
+			qce_xts_swapiv(enciv, rctx->iv, ivsize);
+		else
+			qce_cpu_to_be32p_array(enciv, rctx->iv, ivsize);
+
+		qce_write_array(qce, REG_CNTR0_IV0, enciv, enciv_words);
+	}
+
+	if (IS_ENCRYPT(flags))
+		encr_cfg |= BIT(ENCODE_SHIFT);
+
+	qce_write(qce, REG_ENCR_SEG_CFG, encr_cfg);
+	qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen);
+	qce_write(qce, REG_ENCR_SEG_START, offset & 0xffff);
+
+	if (IS_CTR(flags)) {
+		qce_write(qce, REG_CNTR_MASK, ~0);
+		qce_write(qce, REG_CNTR_MASK0, ~0);
+		qce_write(qce, REG_CNTR_MASK1, ~0);
+		qce_write(qce, REG_CNTR_MASK2, ~0);
+	}
+
+	qce_write(qce, REG_SEG_SIZE, totallen);
+
+	/* get little endianness */
+	config = qce_config_reg(qce, 1);
+	qce_write(qce, REG_CONFIG, config);
+
+	qce_crypto_go(qce);
+
+	return 0;
+}
+
+int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
+	      u32 offset)
+{
+	switch (type) {
+	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+		return qce_setup_regs_ablkcipher(async_req, totallen, offset);
+	case CRYPTO_ALG_TYPE_AHASH:
+		return qce_setup_regs_ahash(async_req, totallen, offset);
+	default:
+		return -EINVAL;
+	}
+}
+
+#define STATUS_ERRORS	\
+		(BIT(SW_ERR_SHIFT) | BIT(AXI_ERR_SHIFT) | BIT(HSD_ERR_SHIFT))
+
+int qce_check_status(struct qce_device *qce, u32 *status)
+{
+	int ret = 0;
+
+	*status = qce_read(qce, REG_STATUS);
+
+	/*
+	 * Don't use result dump status. The operation may not be complete.
+	 * Instead, use the status we just read from device. In case, we need to
+	 * use result_status from result dump the result_status needs to be byte
+	 * swapped, since we set the device to little endian.
+	 */
+	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT)))
+		ret = -ENXIO;
+
+	return ret;
+}
+
+void qce_get_version(struct qce_device *qce, u32 *major, u32 *minor, u32 *step)
+{
+	u32 val;
+
+	val = qce_read(qce, REG_VERSION);
+	*major = (val & CORE_MAJOR_REV_MASK) >> CORE_MAJOR_REV_SHIFT;
+	*minor = (val & CORE_MINOR_REV_MASK) >> CORE_MINOR_REV_SHIFT;
+	*step = (val & CORE_STEP_REV_MASK) >> CORE_STEP_REV_SHIFT;
+}
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
new file mode 100644
index 0000000..411b1fc
--- /dev/null
+++ b/drivers/crypto/qce/common.h
@@ -0,0 +1,102 @@
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
+#ifndef _COMMON_H_
+#define _COMMON_H_
+
+#include <linux/crypto.h>
+#include <linux/types.h>
+#include <crypto/aes.h>
+#include <crypto/hash.h>
+
+/* key size in bytes */
+#define QCE_SHA_HMAC_KEY_SIZE		64
+#define QCE_MAX_CIPHER_KEY_SIZE		AES_KEYSIZE_256
+
+/* IV length in bytes */
+#define QCE_AES_IV_LENGTH		AES_BLOCK_SIZE
+/* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
+#define QCE_MAX_IV_SIZE			AES_BLOCK_SIZE
+
+/* maximum nonce bytes  */
+#define QCE_MAX_NONCE			16
+#define QCE_MAX_NONCE_WORDS		(QCE_MAX_NONCE / sizeof(u32))
+
+/* burst size alignment requirement */
+#define QCE_MAX_ALIGN_SIZE		64
+
+/* cipher algorithms */
+#define QCE_ALG_DES			BIT(0)
+#define QCE_ALG_3DES			BIT(1)
+#define QCE_ALG_AES			BIT(2)
+
+/* hash and hmac algorithms */
+#define QCE_HASH_SHA1			BIT(3)
+#define QCE_HASH_SHA256			BIT(4)
+#define QCE_HASH_SHA1_HMAC		BIT(5)
+#define QCE_HASH_SHA256_HMAC		BIT(6)
+#define QCE_HASH_AES_CMAC		BIT(7)
+
+/* cipher modes */
+#define QCE_MODE_CBC			BIT(8)
+#define QCE_MODE_ECB			BIT(9)
+#define QCE_MODE_CTR			BIT(10)
+#define QCE_MODE_XTS			BIT(11)
+#define QCE_MODE_CCM			BIT(12)
+#define QCE_MODE_MASK			GENMASK(12, 8)
+
+/* cipher encryption/decryption operations */
+#define QCE_ENCRYPT			BIT(13)
+#define QCE_DECRYPT			BIT(14)
+
+#define IS_DES(flags)			(flags & QCE_ALG_DES)
+#define IS_3DES(flags)			(flags & QCE_ALG_3DES)
+#define IS_AES(flags)			(flags & QCE_ALG_AES)
+
+#define IS_SHA1(flags)			(flags & QCE_HASH_SHA1)
+#define IS_SHA256(flags)		(flags & QCE_HASH_SHA256)
+#define IS_SHA1_HMAC(flags)		(flags & QCE_HASH_SHA1_HMAC)
+#define IS_SHA256_HMAC(flags)		(flags & QCE_HASH_SHA256_HMAC)
+#define IS_CMAC(flags)			(flags & QCE_HASH_AES_CMAC)
+#define IS_SHA(flags)			(IS_SHA1(flags) || IS_SHA256(flags))
+#define IS_SHA_HMAC(flags)		\
+		(IS_SHA1_HMAC(flags) || IS_SHA256_HMAC(flags))
+
+#define IS_CBC(mode)			(mode & QCE_MODE_CBC)
+#define IS_ECB(mode)			(mode & QCE_MODE_ECB)
+#define IS_CTR(mode)			(mode & QCE_MODE_CTR)
+#define IS_XTS(mode)			(mode & QCE_MODE_XTS)
+#define IS_CCM(mode)			(mode & QCE_MODE_CCM)
+
+#define IS_ENCRYPT(dir)			(dir & QCE_ENCRYPT)
+#define IS_DECRYPT(dir)			(dir & QCE_DECRYPT)
+
+struct qce_alg_template {
+	struct list_head entry;
+	u32 crypto_alg_type;
+	unsigned long alg_flags;
+	const __be32 *std_iv;
+	union {
+		struct crypto_alg crypto;
+		struct ahash_alg ahash;
+	} alg;
+	struct qce_device *qce;
+};
+
+void qce_cpu_to_be32p_array(__be32 *dst, const u8 *src, unsigned int len);
+int qce_check_status(struct qce_device *qce, u32 *status);
+void qce_get_version(struct qce_device *qce, u32 *major, u32 *minor, u32 *step);
+int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
+	      u32 offset);
+
+#endif /* _COMMON_H_ */
diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
new file mode 100644
index 0000000..33ae354
--- /dev/null
+++ b/drivers/crypto/qce/core.c
@@ -0,0 +1,286 @@
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
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha.h>
+
+#include "core.h"
+#include "cipher.h"
+#include "sha.h"
+
+#define QCE_MAJOR_VERSION5	0x05
+#define QCE_QUEUE_LENGTH	1
+
+static const struct qce_algo_ops *qce_ops[] = {
+	&ablkcipher_ops,
+	&ahash_ops,
+};
+
+static void qce_unregister_algs(struct qce_device *qce)
+{
+	const struct qce_algo_ops *ops;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
+		ops = qce_ops[i];
+		ops->unregister_algs(qce);
+	}
+}
+
+static int qce_register_algs(struct qce_device *qce)
+{
+	const struct qce_algo_ops *ops;
+	int i, ret = -ENODEV;
+
+	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
+		ops = qce_ops[i];
+		ret = ops->register_algs(qce);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int qce_handle_request(struct crypto_async_request *async_req)
+{
+	int ret = -EINVAL, i;
+	const struct qce_algo_ops *ops;
+	u32 type = crypto_tfm_alg_type(async_req->tfm);
+
+	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
+		ops = qce_ops[i];
+		if (type != ops->type)
+			continue;
+		ret = ops->async_req_handle(async_req);
+		break;
+	}
+
+	return ret;
+}
+
+static int qce_handle_queue(struct qce_device *qce,
+			    struct crypto_async_request *req)
+{
+	struct crypto_async_request *async_req, *backlog;
+	unsigned long flags;
+	int ret = 0, err;
+
+	spin_lock_irqsave(&qce->lock, flags);
+
+	if (req)
+		ret = crypto_enqueue_request(&qce->queue, req);
+
+	/* busy, do not dequeue request */
+	if (qce->req) {
+		spin_unlock_irqrestore(&qce->lock, flags);
+		return ret;
+	}
+
+	backlog = crypto_get_backlog(&qce->queue);
+	async_req = crypto_dequeue_request(&qce->queue);
+	if (async_req)
+		qce->req = async_req;
+
+	spin_unlock_irqrestore(&qce->lock, flags);
+
+	if (!async_req)
+		return ret;
+
+	if (backlog) {
+		spin_lock_bh(&qce->lock);
+		backlog->complete(backlog, -EINPROGRESS);
+		spin_unlock_bh(&qce->lock);
+	}
+
+	err = qce_handle_request(async_req);
+	if (err) {
+		qce->result = err;
+		tasklet_schedule(&qce->done_tasklet);
+	}
+
+	return ret;
+}
+
+static void qce_tasklet_req_done(unsigned long data)
+{
+	struct qce_device *qce = (struct qce_device *)data;
+	struct crypto_async_request *req;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qce->lock, flags);
+	req = qce->req;
+	qce->req = NULL;
+	spin_unlock_irqrestore(&qce->lock, flags);
+
+	if (req)
+		req->complete(req, qce->result);
+
+	qce_handle_queue(qce, NULL);
+}
+
+static int qce_async_request_enqueue(struct qce_device *qce,
+				     struct crypto_async_request *req)
+{
+	return qce_handle_queue(qce, req);
+}
+
+static void qce_async_request_done(struct qce_device *qce, int ret)
+{
+	qce->result = ret;
+	tasklet_schedule(&qce->done_tasklet);
+}
+
+static int qce_check_version(struct qce_device *qce)
+{
+	u32 major, minor, step;
+
+	qce_get_version(qce, &major, &minor, &step);
+
+	/*
+	 * the driver does not support v5 with minor 0 because it has special
+	 * alignment requirements.
+	 */
+	if (major != QCE_MAJOR_VERSION5 || minor == 0)
+		return -ENODEV;
+
+	qce->burst_size = QCE_BAM_BURST_SIZE;
+	qce->pipe_pair_id = 1;
+
+	dev_dbg(qce->dev, "Crypto device found, version %d.%d.%d\n",
+		major, minor, step);
+
+	return 0;
+}
+
+static int qce_crypto_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct qce_device *qce;
+	struct resource *res;
+	int ret;
+
+	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
+	if (!qce)
+		return -ENOMEM;
+
+	qce->dev = dev;
+	platform_set_drvdata(pdev, qce);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	qce->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(qce->base))
+		return PTR_ERR(qce->base);
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	if (ret < 0)
+		return ret;
+
+	qce->core = devm_clk_get(qce->dev, "core");
+	if (IS_ERR(qce->core))
+		return PTR_ERR(qce->core);
+
+	qce->iface = devm_clk_get(qce->dev, "iface");
+	if (IS_ERR(qce->iface))
+		return PTR_ERR(qce->iface);
+
+	qce->bus = devm_clk_get(qce->dev, "bus");
+	if (IS_ERR(qce->bus))
+		return PTR_ERR(qce->bus);
+
+	ret = clk_prepare_enable(qce->core);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(qce->iface);
+	if (ret)
+		goto err_clks_core;
+
+	ret = clk_prepare_enable(qce->bus);
+	if (ret)
+		goto err_clks_iface;
+
+	ret = qce_dma_request(qce->dev, &qce->dma);
+	if (ret)
+		goto err_clks;
+
+	ret = qce_check_version(qce);
+	if (ret)
+		goto err_clks;
+
+	spin_lock_init(&qce->lock);
+	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,
+		     (unsigned long)qce);
+	crypto_init_queue(&qce->queue, QCE_QUEUE_LENGTH);
+
+	qce->async_req_enqueue = qce_async_request_enqueue;
+	qce->async_req_done = qce_async_request_done;
+
+	ret = qce_register_algs(qce);
+	if (ret)
+		goto err_dma;
+
+	return 0;
+
+err_dma:
+	qce_dma_release(&qce->dma);
+err_clks:
+	clk_disable_unprepare(qce->bus);
+err_clks_iface:
+	clk_disable_unprepare(qce->iface);
+err_clks_core:
+	clk_disable_unprepare(qce->core);
+	return ret;
+}
+
+static int qce_crypto_remove(struct platform_device *pdev)
+{
+	struct qce_device *qce = platform_get_drvdata(pdev);
+
+	tasklet_kill(&qce->done_tasklet);
+	qce_unregister_algs(qce);
+	qce_dma_release(&qce->dma);
+	clk_disable_unprepare(qce->bus);
+	clk_disable_unprepare(qce->iface);
+	clk_disable_unprepare(qce->core);
+	return 0;
+}
+
+static const struct of_device_id qce_crypto_of_match[] = {
+	{ .compatible = "qcom,crypto-v5.1", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
+
+static struct platform_driver qce_crypto_driver = {
+	.probe = qce_crypto_probe,
+	.remove = qce_crypto_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = KBUILD_MODNAME,
+		.of_match_table = qce_crypto_of_match,
+	},
+};
+module_platform_driver(qce_crypto_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Qualcomm crypto engine driver");
+MODULE_ALIAS("platform:" KBUILD_MODNAME);
+MODULE_AUTHOR("The Linux Foundation");
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
new file mode 100644
index 0000000..549965d
--- /dev/null
+++ b/drivers/crypto/qce/core.h
@@ -0,0 +1,68 @@
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
+#ifndef _CORE_H_
+#define _CORE_H_
+
+#include "dma.h"
+
+/**
+ * struct qce_device - crypto engine device structure
+ * @queue: crypto request queue
+ * @lock: the lock protects queue and req
+ * @done_tasklet: done tasklet object
+ * @req: current active request
+ * @result: result of current transform
+ * @base: virtual IO base
+ * @dev: pointer to device structure
+ * @core: core device clock
+ * @iface: interface clock
+ * @bus: bus clock
+ * @dma: pointer to dma data
+ * @burst_size: the crypto burst size
+ * @pipe_pair_id: which pipe pair id the device using
+ * @async_req_enqueue: invoked by every algorithm to enqueue a request
+ * @async_req_done: invoked by every algorithm to finish its request
+ */
+struct qce_device {
+	struct crypto_queue queue;
+	spinlock_t lock;
+	struct tasklet_struct done_tasklet;
+	struct crypto_async_request *req;
+	int result;
+	void __iomem *base;
+	struct device *dev;
+	struct clk *core, *iface, *bus;
+	struct qce_dma_data dma;
+	int burst_size;
+	unsigned int pipe_pair_id;
+	int (*async_req_enqueue)(struct qce_device *qce,
+				 struct crypto_async_request *req);
+	void (*async_req_done)(struct qce_device *qce, int ret);
+};
+
+/**
+ * struct qce_algo_ops - algorithm operations per crypto type
+ * @type: should be CRYPTO_ALG_TYPE_XXX
+ * @register_algs: invoked by core to register the algorithms
+ * @unregister_algs: invoked by core to unregister the algorithms
+ * @async_req_handle: invoked by core to handle enqueued request
+ */
+struct qce_algo_ops {
+	u32 type;
+	int (*register_algs)(struct qce_device *qce);
+	void (*unregister_algs)(struct qce_device *qce);
+	int (*async_req_handle)(struct crypto_async_request *async_req);
+};
+
+#endif /* _CORE_H_ */
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
new file mode 100644
index 0000000..0fb21e1
--- /dev/null
+++ b/drivers/crypto/qce/dma.c
@@ -0,0 +1,186 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
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
+#include <linux/dmaengine.h>
+#include <crypto/scatterwalk.h>
+
+#include "dma.h"
+
+int qce_dma_request(struct device *dev, struct qce_dma_data *dma)
+{
+	int ret;
+
+	dma->txchan = dma_request_slave_channel_reason(dev, "tx");
+	if (IS_ERR(dma->txchan))
+		return PTR_ERR(dma->txchan);
+
+	dma->rxchan = dma_request_slave_channel_reason(dev, "rx");
+	if (IS_ERR(dma->rxchan)) {
+		ret = PTR_ERR(dma->rxchan);
+		goto error_rx;
+	}
+
+	dma->result_buf = kmalloc(QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ,
+				  GFP_KERNEL);
+	if (!dma->result_buf) {
+		ret = -ENOMEM;
+		goto error_nomem;
+	}
+
+	dma->ignore_buf = dma->result_buf + QCE_RESULT_BUF_SZ;
+
+	return 0;
+error_nomem:
+	dma_release_channel(dma->rxchan);
+error_rx:
+	dma_release_channel(dma->txchan);
+	return ret;
+}
+
+void qce_dma_release(struct qce_dma_data *dma)
+{
+	dma_release_channel(dma->txchan);
+	dma_release_channel(dma->rxchan);
+	kfree(dma->result_buf);
+}
+
+int qce_mapsg(struct device *dev, struct scatterlist *sg, int nents,
+	      enum dma_data_direction dir, bool chained)
+{
+	int err;
+
+	if (chained) {
+		while (sg) {
+			err = dma_map_sg(dev, sg, 1, dir);
+			if (!err)
+				return -EFAULT;
+			sg = scatterwalk_sg_next(sg);
+		}
+	} else {
+		err = dma_map_sg(dev, sg, nents, dir);
+		if (!err)
+			return -EFAULT;
+	}
+
+	return nents;
+}
+
+void qce_unmapsg(struct device *dev, struct scatterlist *sg, int nents,
+		 enum dma_data_direction dir, bool chained)
+{
+	if (chained)
+		while (sg) {
+			dma_unmap_sg(dev, sg, 1, dir);
+			sg = scatterwalk_sg_next(sg);
+		}
+	else
+		dma_unmap_sg(dev, sg, nents, dir);
+}
+
+int qce_countsg(struct scatterlist *sglist, int nbytes, bool *chained)
+{
+	struct scatterlist *sg = sglist;
+	int nents = 0;
+
+	if (chained)
+		*chained = false;
+
+	while (nbytes > 0 && sg) {
+		nents++;
+		nbytes -= sg->length;
+		if (!sg_is_last(sg) && (sg + 1)->length == 0 && chained)
+			*chained = true;
+		sg = scatterwalk_sg_next(sg);
+	}
+
+	return nents;
+}
+
+struct scatterlist *
+qce_sgtable_add(struct sg_table *sgt, struct scatterlist *new_sgl)
+{
+	struct scatterlist *sg = sgt->sgl, *sg_last = NULL;
+
+	while (sg) {
+		if (!sg_page(sg))
+			break;
+		sg = sg_next(sg);
+	}
+
+	if (!sg)
+		return ERR_PTR(-EINVAL);
+
+	while (new_sgl && sg) {
+		sg_set_page(sg, sg_page(new_sgl), new_sgl->length,
+			    new_sgl->offset);
+		sg_last = sg;
+		sg = sg_next(sg);
+		new_sgl = sg_next(new_sgl);
+	}
+
+	return sg_last;
+}
+
+static int qce_dma_prep_sg(struct dma_chan *chan, struct scatterlist *sg,
+			   int nents, unsigned long flags,
+			   enum dma_transfer_direction dir,
+			   dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_async_tx_descriptor *desc;
+	dma_cookie_t cookie;
+
+	if (!sg || !nents)
+		return -EINVAL;
+
+	desc = dmaengine_prep_slave_sg(chan, sg, nents, dir, flags);
+	if (!desc)
+		return -EINVAL;
+
+	desc->callback = cb;
+	desc->callback_param = cb_param;
+	cookie = dmaengine_submit(desc);
+
+	return dma_submit_error(cookie);
+}
+
+int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *rx_sg,
+		     int rx_nents, struct scatterlist *tx_sg, int tx_nents,
+		     dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_chan *rxchan = dma->rxchan;
+	struct dma_chan *txchan = dma->txchan;
+	unsigned long flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
+	int ret;
+
+	ret = qce_dma_prep_sg(rxchan, rx_sg, rx_nents, flags, DMA_MEM_TO_DEV,
+			     NULL, NULL);
+	if (ret)
+		return ret;
+
+	return qce_dma_prep_sg(txchan, tx_sg, tx_nents, flags, DMA_DEV_TO_MEM,
+			       cb, cb_param);
+}
+
+void qce_dma_issue_pending(struct qce_dma_data *dma)
+{
+	dma_async_issue_pending(dma->rxchan);
+	dma_async_issue_pending(dma->txchan);
+}
+
+int qce_dma_terminate_all(struct qce_dma_data *dma)
+{
+	int ret;
+
+	ret = dmaengine_terminate_all(dma->rxchan);
+	return ret ?: dmaengine_terminate_all(dma->txchan);
+}
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
new file mode 100644
index 0000000..805e378
--- /dev/null
+++ b/drivers/crypto/qce/dma.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
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
+#ifndef _DMA_H_
+#define _DMA_H_
+
+/* maximum data transfer block size between BAM and CE */
+#define QCE_BAM_BURST_SIZE		64
+
+#define QCE_AUTHIV_REGS_CNT		16
+#define QCE_AUTH_BYTECOUNT_REGS_CNT	4
+#define QCE_CNTRIV_REGS_CNT		4
+
+struct qce_result_dump {
+	u32 auth_iv[QCE_AUTHIV_REGS_CNT];
+	u32 auth_byte_count[QCE_AUTH_BYTECOUNT_REGS_CNT];
+	u32 encr_cntr_iv[QCE_CNTRIV_REGS_CNT];
+	u32 status;
+	u32 status2;
+};
+
+#define QCE_IGNORE_BUF_SZ	(2 * QCE_BAM_BURST_SIZE)
+#define QCE_RESULT_BUF_SZ	\
+		ALIGN(sizeof(struct qce_result_dump), QCE_BAM_BURST_SIZE)
+
+struct qce_dma_data {
+	struct dma_chan *txchan;
+	struct dma_chan *rxchan;
+	struct qce_result_dump *result_buf;
+	void *ignore_buf;
+};
+
+int qce_dma_request(struct device *dev, struct qce_dma_data *dma);
+void qce_dma_release(struct qce_dma_data *dma);
+int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *sg_in,
+		     int in_ents, struct scatterlist *sg_out, int out_ents,
+		     dma_async_tx_callback cb, void *cb_param);
+void qce_dma_issue_pending(struct qce_dma_data *dma);
+int qce_dma_terminate_all(struct qce_dma_data *dma);
+int qce_countsg(struct scatterlist *sg_list, int nbytes, bool *chained);
+void qce_unmapsg(struct device *dev, struct scatterlist *sg, int nents,
+		 enum dma_data_direction dir, bool chained);
+int qce_mapsg(struct device *dev, struct scatterlist *sg, int nents,
+	      enum dma_data_direction dir, bool chained);
+struct scatterlist *
+qce_sgtable_add(struct sg_table *sgt, struct scatterlist *sg_add);
+
+#endif /* _DMA_H_ */
diff --git a/drivers/crypto/qce/regs-v5.h b/drivers/crypto/qce/regs-v5.h
new file mode 100644
index 0000000..116b433
--- /dev/null
+++ b/drivers/crypto/qce/regs-v5.h
@@ -0,0 +1,334 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
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
+#ifndef _REGS_V5_H_
+#define _REGS_V5_H_
+
+#include <linux/bitops.h>
+
+#define REG_VERSION			0x000
+#define REG_STATUS			0x100
+#define REG_STATUS2			0x104
+#define REG_ENGINES_AVAIL		0x108
+#define REG_FIFO_SIZES			0x10c
+#define REG_SEG_SIZE			0x110
+#define REG_GOPROC			0x120
+#define REG_ENCR_SEG_CFG		0x200
+#define REG_ENCR_SEG_SIZE		0x204
+#define REG_ENCR_SEG_START		0x208
+#define REG_CNTR0_IV0			0x20c
+#define REG_CNTR1_IV1			0x210
+#define REG_CNTR2_IV2			0x214
+#define REG_CNTR3_IV3			0x218
+#define REG_CNTR_MASK			0x21C
+#define REG_ENCR_CCM_INT_CNTR0		0x220
+#define REG_ENCR_CCM_INT_CNTR1		0x224
+#define REG_ENCR_CCM_INT_CNTR2		0x228
+#define REG_ENCR_CCM_INT_CNTR3		0x22c
+#define REG_ENCR_XTS_DU_SIZE		0x230
+#define REG_CNTR_MASK2			0x234
+#define REG_CNTR_MASK1			0x238
+#define REG_CNTR_MASK0			0x23c
+#define REG_AUTH_SEG_CFG		0x300
+#define REG_AUTH_SEG_SIZE		0x304
+#define REG_AUTH_SEG_START		0x308
+#define REG_AUTH_IV0			0x310
+#define REG_AUTH_IV1			0x314
+#define REG_AUTH_IV2			0x318
+#define REG_AUTH_IV3			0x31c
+#define REG_AUTH_IV4			0x320
+#define REG_AUTH_IV5			0x324
+#define REG_AUTH_IV6			0x328
+#define REG_AUTH_IV7			0x32c
+#define REG_AUTH_IV8			0x330
+#define REG_AUTH_IV9			0x334
+#define REG_AUTH_IV10			0x338
+#define REG_AUTH_IV11			0x33c
+#define REG_AUTH_IV12			0x340
+#define REG_AUTH_IV13			0x344
+#define REG_AUTH_IV14			0x348
+#define REG_AUTH_IV15			0x34c
+#define REG_AUTH_INFO_NONCE0		0x350
+#define REG_AUTH_INFO_NONCE1		0x354
+#define REG_AUTH_INFO_NONCE2		0x358
+#define REG_AUTH_INFO_NONCE3		0x35c
+#define REG_AUTH_BYTECNT0		0x390
+#define REG_AUTH_BYTECNT1		0x394
+#define REG_AUTH_BYTECNT2		0x398
+#define REG_AUTH_BYTECNT3		0x39c
+#define REG_AUTH_EXP_MAC0		0x3a0
+#define REG_AUTH_EXP_MAC1		0x3a4
+#define REG_AUTH_EXP_MAC2		0x3a8
+#define REG_AUTH_EXP_MAC3		0x3ac
+#define REG_AUTH_EXP_MAC4		0x3b0
+#define REG_AUTH_EXP_MAC5		0x3b4
+#define REG_AUTH_EXP_MAC6		0x3b8
+#define REG_AUTH_EXP_MAC7		0x3bc
+#define REG_CONFIG			0x400
+#define REG_GOPROC_QC_KEY		0x1000
+#define REG_GOPROC_OEM_KEY		0x2000
+#define REG_ENCR_KEY0			0x3000
+#define REG_ENCR_KEY1			0x3004
+#define REG_ENCR_KEY2			0x3008
+#define REG_ENCR_KEY3			0x300c
+#define REG_ENCR_KEY4			0x3010
+#define REG_ENCR_KEY5			0x3014
+#define REG_ENCR_KEY6			0x3018
+#define REG_ENCR_KEY7			0x301c
+#define REG_ENCR_XTS_KEY0		0x3020
+#define REG_ENCR_XTS_KEY1		0x3024
+#define REG_ENCR_XTS_KEY2		0x3028
+#define REG_ENCR_XTS_KEY3		0x302c
+#define REG_ENCR_XTS_KEY4		0x3030
+#define REG_ENCR_XTS_KEY5		0x3034
+#define REG_ENCR_XTS_KEY6		0x3038
+#define REG_ENCR_XTS_KEY7		0x303c
+#define REG_AUTH_KEY0			0x3040
+#define REG_AUTH_KEY1			0x3044
+#define REG_AUTH_KEY2			0x3048
+#define REG_AUTH_KEY3			0x304c
+#define REG_AUTH_KEY4			0x3050
+#define REG_AUTH_KEY5			0x3054
+#define REG_AUTH_KEY6			0x3058
+#define REG_AUTH_KEY7			0x305c
+#define REG_AUTH_KEY8			0x3060
+#define REG_AUTH_KEY9			0x3064
+#define REG_AUTH_KEY10			0x3068
+#define REG_AUTH_KEY11			0x306c
+#define REG_AUTH_KEY12			0x3070
+#define REG_AUTH_KEY13			0x3074
+#define REG_AUTH_KEY14			0x3078
+#define REG_AUTH_KEY15			0x307c
+
+/* Register bits - REG_VERSION */
+#define CORE_STEP_REV_SHIFT		0
+#define CORE_STEP_REV_MASK		GENMASK(15, 0)
+#define CORE_MINOR_REV_SHIFT		16
+#define CORE_MINOR_REV_MASK		GENMASK(23, 16)
+#define CORE_MAJOR_REV_SHIFT		24
+#define CORE_MAJOR_REV_MASK		GENMASK(31, 24)
+
+/* Register bits - REG_STATUS */
+#define MAC_FAILED_SHIFT		31
+#define DOUT_SIZE_AVAIL_SHIFT		26
+#define DOUT_SIZE_AVAIL_MASK		GENMASK(30, 26)
+#define DIN_SIZE_AVAIL_SHIFT		21
+#define DIN_SIZE_AVAIL_MASK		GENMASK(25, 21)
+#define HSD_ERR_SHIFT			20
+#define ACCESS_VIOL_SHIFT		19
+#define PIPE_ACTIVE_ERR_SHIFT		18
+#define CFG_CHNG_ERR_SHIFT		17
+#define DOUT_ERR_SHIFT			16
+#define DIN_ERR_SHIFT			15
+#define AXI_ERR_SHIFT			14
+#define CRYPTO_STATE_SHIFT		10
+#define CRYPTO_STATE_MASK		GENMASK(13, 10)
+#define ENCR_BUSY_SHIFT			9
+#define AUTH_BUSY_SHIFT			8
+#define DOUT_INTR_SHIFT			7
+#define DIN_INTR_SHIFT			6
+#define OP_DONE_INTR_SHIFT		5
+#define ERR_INTR_SHIFT			4
+#define DOUT_RDY_SHIFT			3
+#define DIN_RDY_SHIFT			2
+#define OPERATION_DONE_SHIFT		1
+#define SW_ERR_SHIFT			0
+
+/* Register bits - REG_STATUS2 */
+#define AXI_EXTRA_SHIFT			1
+#define LOCKED_SHIFT			2
+
+/* Register bits - REG_CONFIG */
+#define REQ_SIZE_SHIFT			17
+#define REQ_SIZE_MASK			GENMASK(20, 17)
+#define REQ_SIZE_ENUM_1_BEAT		0
+#define REQ_SIZE_ENUM_2_BEAT		1
+#define REQ_SIZE_ENUM_3_BEAT		2
+#define REQ_SIZE_ENUM_4_BEAT		3
+#define REQ_SIZE_ENUM_5_BEAT		4
+#define REQ_SIZE_ENUM_6_BEAT		5
+#define REQ_SIZE_ENUM_7_BEAT		6
+#define REQ_SIZE_ENUM_8_BEAT		7
+#define REQ_SIZE_ENUM_9_BEAT		8
+#define REQ_SIZE_ENUM_10_BEAT		9
+#define REQ_SIZE_ENUM_11_BEAT		10
+#define REQ_SIZE_ENUM_12_BEAT		11
+#define REQ_SIZE_ENUM_13_BEAT		12
+#define REQ_SIZE_ENUM_14_BEAT		13
+#define REQ_SIZE_ENUM_15_BEAT		14
+#define REQ_SIZE_ENUM_16_BEAT		15
+
+#define MAX_QUEUED_REQ_SHIFT		14
+#define MAX_QUEUED_REQ_MASK		GENMASK(24, 16)
+#define ENUM_1_QUEUED_REQS		0
+#define ENUM_2_QUEUED_REQS		1
+#define ENUM_3_QUEUED_REQS		2
+
+#define IRQ_ENABLES_SHIFT		10
+#define IRQ_ENABLES_MASK		GENMASK(13, 10)
+
+#define LITTLE_ENDIAN_MODE_SHIFT	9
+#define PIPE_SET_SELECT_SHIFT		5
+#define PIPE_SET_SELECT_MASK		GENMASK(8, 5)
+
+#define HIGH_SPD_EN_N_SHIFT		4
+#define MASK_DOUT_INTR_SHIFT		3
+#define MASK_DIN_INTR_SHIFT		2
+#define MASK_OP_DONE_INTR_SHIFT		1
+#define MASK_ERR_INTR_SHIFT		0
+
+/* Register bits - REG_AUTH_SEG_CFG */
+#define COMP_EXP_MAC_SHIFT		24
+#define COMP_EXP_MAC_DISABLED		0
+#define COMP_EXP_MAC_ENABLED		1
+
+#define F9_DIRECTION_SHIFT		23
+#define F9_DIRECTION_UPLINK		0
+#define F9_DIRECTION_DOWNLINK		1
+
+#define AUTH_NONCE_NUM_WORDS_SHIFT	20
+#define AUTH_NONCE_NUM_WORDS_MASK	GENMASK(22, 20);
+
+#define USE_PIPE_KEY_AUTH_SHIFT		19
+#define USE_HW_KEY_AUTH_SHIFT		18
+#define AUTH_FIRST_SHIFT		17
+#define AUTH_LAST_SHIFT			16
+
+#define AUTH_POS_SHIFT			14
+#define AUTH_POS_MASK			GENMASK(15, 14)
+#define AUTH_POS_BEFORE			0
+#define AUTH_POS_AFTER			1
+
+#define AUTH_SIZE_SHIFT			9
+#define AUTH_SIZE_MASK			GENMASK(13, 9)
+#define AUTH_SIZE_SHA1			0
+#define AUTH_SIZE_SHA256		1
+#define AUTH_SIZE_ENUM_1_BYTES		0
+#define AUTH_SIZE_ENUM_2_BYTES		1
+#define AUTH_SIZE_ENUM_3_BYTES		2
+#define AUTH_SIZE_ENUM_4_BYTES		3
+#define AUTH_SIZE_ENUM_5_BYTES		4
+#define AUTH_SIZE_ENUM_6_BYTES		5
+#define AUTH_SIZE_ENUM_7_BYTES		6
+#define AUTH_SIZE_ENUM_8_BYTES		7
+#define AUTH_SIZE_ENUM_9_BYTES		8
+#define AUTH_SIZE_ENUM_10_BYTES		9
+#define AUTH_SIZE_ENUM_11_BYTES		10
+#define AUTH_SIZE_ENUM_12_BYTES		11
+#define AUTH_SIZE_ENUM_13_BYTES		12
+#define AUTH_SIZE_ENUM_14_BYTES		13
+#define AUTH_SIZE_ENUM_15_BYTES		14
+#define AUTH_SIZE_ENUM_16_BYTES		15
+
+#define AUTH_MODE_SHIFT			6
+#define AUTH_MODE_MASK			GENMASK(8, 6)
+#define AUTH_MODE_HASH			0
+#define AUTH_MODE_HMAC			1
+#define AUTH_MODE_CCM			0
+#define AUTH_MODE_CMAC			1
+
+#define AUTH_KEY_SIZE_SHIFT		3
+#define AUTH_KEY_SIZE_MASK		GENMASK(5, 3)
+#define AUTH_KEY_SZ_AES128		0
+#define AUTH_KEY_SZ_AES256		2
+
+#define AUTH_ALG_SHIFT			0
+#define AUTH_ALG_MASK			GENMASK(2, 0)
+#define AUTH_ALG_NONE			0
+#define AUTH_ALG_SHA			1
+#define AUTH_ALG_AES			2
+#define AUTH_ALG_KASUMI			3
+#define AUTH_ALG_SNOW3G			4
+#define AUTH_ALG_ZUC			5
+
+/* Register bits - REG_ENCR_XTS_DU_SIZE */
+#define ENCR_XTS_DU_SIZE_SHIFT		0
+#define ENCR_XTS_DU_SIZE_MASK		GENMASK(19, 0)
+
+/* Register bits - REG_ENCR_SEG_CFG */
+#define F8_KEYSTREAM_ENABLE_SHIFT	17
+#define F8_KEYSTREAM_DISABLED		0
+#define F8_KEYSTREAM_ENABLED		1
+
+#define F8_DIRECTION_SHIFT		16
+#define F8_DIRECTION_UPLINK		0
+#define F8_DIRECTION_DOWNLINK		1
+
+#define USE_PIPE_KEY_ENCR_SHIFT		15
+#define USE_PIPE_KEY_ENCR_ENABLED	1
+#define USE_KEY_REGISTERS		0
+
+#define USE_HW_KEY_ENCR_SHIFT		14
+#define USE_KEY_REG			0
+#define USE_HW_KEY			1
+
+#define LAST_CCM_SHIFT			13
+#define LAST_CCM_XFR			1
+#define INTERM_CCM_XFR			0
+
+#define CNTR_ALG_SHIFT			11
+#define CNTR_ALG_MASK			GENMASK(12, 11)
+#define CNTR_ALG_NIST			0
+
+#define ENCODE_SHIFT			10
+
+#define ENCR_MODE_SHIFT			6
+#define ENCR_MODE_MASK			GENMASK(9, 6)
+#define ENCR_MODE_ECB			0
+#define ENCR_MODE_CBC			1
+#define ENCR_MODE_CTR			2
+#define ENCR_MODE_XTS			3
+#define ENCR_MODE_CCM			4
+
+#define ENCR_KEY_SZ_SHIFT		3
+#define ENCR_KEY_SZ_MASK		GENMASK(5, 3)
+#define ENCR_KEY_SZ_DES			0
+#define ENCR_KEY_SZ_3DES		1
+#define ENCR_KEY_SZ_AES128		0
+#define ENCR_KEY_SZ_AES256		2
+
+#define ENCR_ALG_SHIFT			0
+#define ENCR_ALG_MASK			GENMASK(2, 0)
+#define ENCR_ALG_NONE			0
+#define ENCR_ALG_DES			1
+#define ENCR_ALG_AES			2
+#define ENCR_ALG_KASUMI			4
+#define ENCR_ALG_SNOW_3G		5
+#define ENCR_ALG_ZUC			6
+
+/* Register bits - REG_GOPROC */
+#define GO_SHIFT			0
+#define CLR_CNTXT_SHIFT			1
+#define RESULTS_DUMP_SHIFT		2
+
+/* Register bits - REG_ENGINES_AVAIL */
+#define ENCR_AES_SEL_SHIFT		0
+#define DES_SEL_SHIFT			1
+#define ENCR_SNOW3G_SEL_SHIFT		2
+#define ENCR_KASUMI_SEL_SHIFT		3
+#define SHA_SEL_SHIFT			4
+#define SHA512_SEL_SHIFT		5
+#define AUTH_AES_SEL_SHIFT		6
+#define AUTH_SNOW3G_SEL_SHIFT		7
+#define AUTH_KASUMI_SEL_SHIFT		8
+#define BAM_PIPE_SETS_SHIFT		9
+#define BAM_PIPE_SETS_MASK		GENMASK(12, 9)
+#define AXI_WR_BEATS_SHIFT		13
+#define AXI_WR_BEATS_MASK		GENMASK(18, 13)
+#define AXI_RD_BEATS_SHIFT		19
+#define AXI_RD_BEATS_MASK		GENMASK(24, 19)
+#define ENCR_ZUC_SEL_SHIFT		26
+#define AUTH_ZUC_SEL_SHIFT		27
+#define ZUC_ENABLE_SHIFT		28
+
+#endif /* _REGS_V5_H_ */
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
new file mode 100644
index 0000000..3c33ac9
--- /dev/null
+++ b/drivers/crypto/qce/sha.c
@@ -0,0 +1,588 @@
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
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <crypto/internal/hash.h>
+
+#include "common.h"
+#include "core.h"
+#include "sha.h"
+
+/* crypto hw padding constant for first operation */
+#define SHA_PADDING		64
+#define SHA_PADDING_MASK	(SHA_PADDING - 1)
+
+static LIST_HEAD(ahash_algs);
+
+static const __be32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(__be32)] = {
+	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4, 0, 0, 0
+};
+
+static const __be32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(__be32)] = {
+	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
+	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
+};
+
+static void qce_ahash_done(void *data)
+{
+	struct crypto_async_request *async_req = data;
+	struct ahash_request *req = ahash_request_cast(async_req);
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	struct qce_result_dump *result = qce->dma.result_buf;
+	unsigned int digestsize = crypto_ahash_digestsize(ahash);
+	int error;
+	u32 status;
+
+	error = qce_dma_terminate_all(&qce->dma);
+	if (error)
+		dev_dbg(qce->dev, "ahash dma termination error (%d)\n", error);
+
+	qce_unmapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
+		    rctx->src_chained);
+	qce_unmapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
+
+	memcpy(rctx->digest, result->auth_iv, digestsize);
+	if (req->result)
+		memcpy(req->result, result->auth_iv, digestsize);
+
+	rctx->byte_count[0] = cpu_to_be32(result->auth_byte_count[0]);
+	rctx->byte_count[1] = cpu_to_be32(result->auth_byte_count[1]);
+
+	error = qce_check_status(qce, &status);
+	if (error < 0)
+		dev_dbg(qce->dev, "ahash operation error (%x)\n", status);
+
+	req->src = rctx->src_orig;
+	req->nbytes = rctx->nbytes_orig;
+	rctx->last_blk = false;
+	rctx->first_blk = false;
+
+	qce->async_req_done(tmpl->qce, error);
+}
+
+static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
+{
+	struct ahash_request *req = ahash_request_cast(async_req);
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	unsigned long flags = rctx->flags;
+	int ret;
+
+	if (IS_SHA_HMAC(flags)) {
+		rctx->authkey = ctx->authkey;
+		rctx->authklen = QCE_SHA_HMAC_KEY_SIZE;
+	} else if (IS_CMAC(flags)) {
+		rctx->authkey = ctx->authkey;
+		rctx->authklen = AES_KEYSIZE_128;
+	}
+
+	rctx->src_nents = qce_countsg(req->src, req->nbytes,
+				      &rctx->src_chained);
+	ret = qce_mapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
+			rctx->src_chained);
+	if (ret < 0)
+		return ret;
+
+	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
+
+	ret = qce_mapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
+	if (ret < 0)
+		goto error_unmap_src;
+
+	ret = qce_dma_prep_sgs(&qce->dma, req->src, rctx->src_nents,
+			       &rctx->result_sg, 1, qce_ahash_done, async_req);
+	if (ret)
+		goto error_unmap_dst;
+
+	qce_dma_issue_pending(&qce->dma);
+
+	ret = qce_start(async_req, tmpl->crypto_alg_type, 0, 0);
+	if (ret)
+		goto error_terminate;
+
+	return 0;
+
+error_terminate:
+	qce_dma_terminate_all(&qce->dma);
+error_unmap_dst:
+	qce_unmapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
+error_unmap_src:
+	qce_unmapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
+		    rctx->src_chained);
+	return ret;
+}
+
+static int qce_ahash_init(struct ahash_request *req)
+{
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
+	const __be32 *std_iv = tmpl->std_iv;
+
+	memset(rctx, 0, sizeof(*rctx));
+	rctx->first_blk = true;
+	rctx->last_blk = false;
+	rctx->flags = tmpl->alg_flags;
+	memcpy(rctx->digest, std_iv, sizeof(rctx->digest));
+
+	return 0;
+}
+
+static int qce_ahash_export(struct ahash_request *req, void *out)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	unsigned long flags = rctx->flags;
+	unsigned int digestsize = crypto_ahash_digestsize(ahash);
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+
+	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
+		struct sha1_state *out_state = out;
+
+		out_state->count = rctx->count;
+		qce_cpu_to_be32p_array(out_state->state, rctx->digest,
+				       digestsize);
+		memcpy(out_state->buffer, rctx->buf, blocksize);
+	} else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags)) {
+		struct sha256_state *out_state = out;
+
+		out_state->count = rctx->count;
+		qce_cpu_to_be32p_array(out_state->state, rctx->digest,
+				       digestsize);
+		memcpy(out_state->buf, rctx->buf, blocksize);
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int qce_import_common(struct ahash_request *req, u64 in_count,
+			     const u32 *state, const u8 *buffer, bool hmac)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	unsigned int digestsize = crypto_ahash_digestsize(ahash);
+	unsigned int blocksize;
+	u64 count = in_count;
+
+	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+	rctx->count = in_count;
+	memcpy(rctx->buf, buffer, blocksize);
+
+	if (in_count <= blocksize) {
+		rctx->first_blk = 1;
+	} else {
+		rctx->first_blk = 0;
+		/*
+		 * For HMAC, there is a hardware padding done when first block
+		 * is set. Therefore the byte_count must be incremened by 64
+		 * after the first block operation.
+		 */
+		if (hmac)
+			count += SHA_PADDING;
+	}
+
+	rctx->byte_count[0] = (__be32)(count & ~SHA_PADDING_MASK);
+	rctx->byte_count[1] = (__be32)(count >> 32);
+	qce_cpu_to_be32p_array((__be32 *)rctx->digest, (const u8 *)state,
+			       digestsize);
+	rctx->buflen = (unsigned int)(in_count & (blocksize - 1));
+
+	return 0;
+}
+
+static int qce_ahash_import(struct ahash_request *req, const void *in)
+{
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	unsigned long flags = rctx->flags;
+	bool hmac = IS_SHA_HMAC(flags);
+	int ret = -EINVAL;
+
+	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
+		const struct sha1_state *state = in;
+
+		ret = qce_import_common(req, state->count, state->state,
+					state->buffer, hmac);
+	} else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags)) {
+		const struct sha256_state *state = in;
+
+		ret = qce_import_common(req, state->count, state->state,
+					state->buf, hmac);
+	}
+
+	return ret;
+}
+
+static int qce_ahash_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
+	struct qce_device *qce = tmpl->qce;
+	struct scatterlist *sg_last, *sg;
+	unsigned int total, len;
+	unsigned int hash_later;
+	unsigned int nbytes;
+	unsigned int blocksize;
+
+	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	rctx->count += req->nbytes;
+
+	/* check for buffer from previous updates and append it */
+	total = req->nbytes + rctx->buflen;
+
+	if (total <= blocksize) {
+		scatterwalk_map_and_copy(rctx->buf + rctx->buflen, req->src,
+					 0, req->nbytes, 0);
+		rctx->buflen += req->nbytes;
+		return 0;
+	}
+
+	/* save the original req structure fields */
+	rctx->src_orig = req->src;
+	rctx->nbytes_orig = req->nbytes;
+
+	/*
+	 * if we have data from previous update copy them on buffer. The old
+	 * data will be combined with current request bytes.
+	 */
+	if (rctx->buflen)
+		memcpy(rctx->tmpbuf, rctx->buf, rctx->buflen);
+
+	/* calculate how many bytes will be hashed later */
+	hash_later = total % blocksize;
+	if (hash_later) {
+		unsigned int src_offset = req->nbytes - hash_later;
+		scatterwalk_map_and_copy(rctx->buf, req->src, src_offset,
+					 hash_later, 0);
+	}
+
+	/* here nbytes is multiple of blocksize */
+	nbytes = total - hash_later;
+
+	len = rctx->buflen;
+	sg = sg_last = req->src;
+
+	while (len < nbytes && sg) {
+		if (len + sg_dma_len(sg) > nbytes)
+			break;
+		len += sg_dma_len(sg);
+		sg_last = sg;
+		sg = scatterwalk_sg_next(sg);
+	}
+
+	if (!sg_last)
+		return -EINVAL;
+
+	sg_mark_end(sg_last);
+
+	if (rctx->buflen) {
+		sg_init_table(rctx->sg, 2);
+		sg_set_buf(rctx->sg, rctx->tmpbuf, rctx->buflen);
+		scatterwalk_sg_chain(rctx->sg, 2, req->src);
+		req->src = rctx->sg;
+	}
+
+	req->nbytes = nbytes;
+	rctx->buflen = hash_later;
+
+	return qce->async_req_enqueue(tmpl->qce, &req->base);
+}
+
+static int qce_ahash_final(struct ahash_request *req)
+{
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
+	struct qce_device *qce = tmpl->qce;
+
+	if (!rctx->buflen)
+		return 0;
+
+	rctx->last_blk = true;
+
+	rctx->src_orig = req->src;
+	rctx->nbytes_orig = req->nbytes;
+
+	memcpy(rctx->tmpbuf, rctx->buf, rctx->buflen);
+	sg_init_one(rctx->sg, rctx->tmpbuf, rctx->buflen);
+
+	req->src = rctx->sg;
+	req->nbytes = rctx->buflen;
+
+	return qce->async_req_enqueue(tmpl->qce, &req->base);
+}
+
+static int qce_ahash_digest(struct ahash_request *req)
+{
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
+	struct qce_device *qce = tmpl->qce;
+	int ret;
+
+	ret = qce_ahash_init(req);
+	if (ret)
+		return ret;
+
+	rctx->src_orig = req->src;
+	rctx->nbytes_orig = req->nbytes;
+	rctx->first_blk = true;
+	rctx->last_blk = true;
+
+	return qce->async_req_enqueue(tmpl->qce, &req->base);
+}
+
+struct qce_ahash_result {
+	struct completion completion;
+	int error;
+};
+
+static void qce_digest_complete(struct crypto_async_request *req, int error)
+{
+	struct qce_ahash_result *result = req->data;
+
+	if (error == -EINPROGRESS)
+		return;
+
+	result->error = error;
+	complete(&result->completion);
+}
+
+static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
+				 unsigned int keylen)
+{
+	unsigned int digestsize = crypto_ahash_digestsize(tfm);
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(&tfm->base);
+	struct qce_ahash_result result;
+	struct ahash_request *req;
+	struct scatterlist sg;
+	unsigned int blocksize;
+	struct crypto_ahash *ahash_tfm;
+	u8 *buf;
+	int ret;
+	const char *alg_name;
+
+	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	memset(ctx->authkey, 0, sizeof(ctx->authkey));
+
+	if (keylen <= blocksize) {
+		memcpy(ctx->authkey, key, keylen);
+		return 0;
+	}
+
+	if (digestsize == SHA1_DIGEST_SIZE)
+		alg_name = "sha1-qce";
+	else if (digestsize == SHA256_DIGEST_SIZE)
+		alg_name = "sha256-qce";
+	else
+		return -EINVAL;
+
+	ahash_tfm = crypto_alloc_ahash(alg_name, CRYPTO_ALG_TYPE_AHASH,
+				       CRYPTO_ALG_TYPE_AHASH_MASK);
+	if (IS_ERR(ahash_tfm))
+		return PTR_ERR(ahash_tfm);
+
+	req = ahash_request_alloc(ahash_tfm, GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto err_free_ahash;
+	}
+
+	init_completion(&result.completion);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   qce_digest_complete, &result);
+	crypto_ahash_clear_flags(ahash_tfm, ~0);
+
+	buf = kzalloc(keylen + QCE_MAX_ALIGN_SIZE, GFP_KERNEL);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto err_free_req;
+	}
+
+	memcpy(buf, key, keylen);
+	sg_init_one(&sg, buf, keylen);
+	ahash_request_set_crypt(req, &sg, ctx->authkey, keylen);
+
+	ret = crypto_ahash_digest(req);
+	if (ret == -EINPROGRESS || ret == -EBUSY) {
+		ret = wait_for_completion_interruptible(&result.completion);
+		if (!ret)
+			ret = result.error;
+	}
+
+	if (ret)
+		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	kfree(buf);
+err_free_req:
+	ahash_request_free(req);
+err_free_ahash:
+	crypto_free_ahash(ahash_tfm);
+	return ret;
+}
+
+static int qce_ahash_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_ahash_set_reqsize(ahash, sizeof(struct qce_sha_reqctx));
+	memset(ctx, 0, sizeof(*ctx));
+	return 0;
+}
+
+struct qce_ahash_def {
+	unsigned long flags;
+	const char *name;
+	const char *drv_name;
+	unsigned int digestsize;
+	unsigned int blocksize;
+	unsigned int statesize;
+	const __be32 *std_iv;
+};
+
+static const struct qce_ahash_def ahash_def[] = {
+	{
+		.flags		= QCE_HASH_SHA1,
+		.name		= "sha1",
+		.drv_name	= "sha1-qce",
+		.digestsize	= SHA1_DIGEST_SIZE,
+		.blocksize	= SHA1_BLOCK_SIZE,
+		.statesize	= sizeof(struct sha1_state),
+		.std_iv		= std_iv_sha1,
+	},
+	{
+		.flags		= QCE_HASH_SHA256,
+		.name		= "sha256",
+		.drv_name	= "sha256-qce",
+		.digestsize	= SHA256_DIGEST_SIZE,
+		.blocksize	= SHA256_BLOCK_SIZE,
+		.statesize	= sizeof(struct sha256_state),
+		.std_iv		= std_iv_sha256,
+	},
+	{
+		.flags		= QCE_HASH_SHA1_HMAC,
+		.name		= "hmac(sha1)",
+		.drv_name	= "hmac-sha1-qce",
+		.digestsize	= SHA1_DIGEST_SIZE,
+		.blocksize	= SHA1_BLOCK_SIZE,
+		.statesize	= sizeof(struct sha1_state),
+		.std_iv		= std_iv_sha1,
+	},
+	{
+		.flags		= QCE_HASH_SHA256_HMAC,
+		.name		= "hmac(sha256)",
+		.drv_name	= "hmac-sha256-qce",
+		.digestsize	= SHA256_DIGEST_SIZE,
+		.blocksize	= SHA256_BLOCK_SIZE,
+		.statesize	= sizeof(struct sha256_state),
+		.std_iv		= std_iv_sha256,
+	},
+};
+
+static int qce_ahash_register_one(const struct qce_ahash_def *def,
+				  struct qce_device *qce)
+{
+	struct qce_alg_template *tmpl;
+	struct ahash_alg *alg;
+	struct crypto_alg *base;
+	int ret;
+
+	tmpl = kzalloc(sizeof(*tmpl), GFP_KERNEL);
+	if (!tmpl)
+		return -ENOMEM;
+
+	tmpl->std_iv = def->std_iv;
+
+	alg = &tmpl->alg.ahash;
+	alg->init = qce_ahash_init;
+	alg->update = qce_ahash_update;
+	alg->final = qce_ahash_final;
+	alg->digest = qce_ahash_digest;
+	alg->export = qce_ahash_export;
+	alg->import = qce_ahash_import;
+	if (IS_SHA_HMAC(def->flags))
+		alg->setkey = qce_ahash_hmac_setkey;
+	alg->halg.digestsize = def->digestsize;
+	alg->halg.statesize = def->statesize;
+
+	base = &alg->halg.base;
+	base->cra_blocksize = def->blocksize;
+	base->cra_priority = 300;
+	base->cra_flags = CRYPTO_ALG_ASYNC;
+	base->cra_ctxsize = sizeof(struct qce_sha_ctx);
+	base->cra_alignmask = 0;
+	base->cra_module = THIS_MODULE;
+	base->cra_init = qce_ahash_cra_init;
+	INIT_LIST_HEAD(&base->cra_list);
+
+	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
+	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 def->drv_name);
+
+	INIT_LIST_HEAD(&tmpl->entry);
+	tmpl->crypto_alg_type = CRYPTO_ALG_TYPE_AHASH;
+	tmpl->alg_flags = def->flags;
+	tmpl->qce = qce;
+
+	ret = crypto_register_ahash(alg);
+	if (ret) {
+		kfree(tmpl);
+		dev_err(qce->dev, "%s registration failed\n", base->cra_name);
+		return ret;
+	}
+
+	list_add_tail(&tmpl->entry, &ahash_algs);
+	dev_dbg(qce->dev, "%s is registered\n", base->cra_name);
+	return 0;
+}
+
+static void qce_ahash_unregister(struct qce_device *qce)
+{
+	struct qce_alg_template *tmpl, *n;
+
+	list_for_each_entry_safe(tmpl, n, &ahash_algs, entry) {
+		crypto_unregister_ahash(&tmpl->alg.ahash);
+		list_del(&tmpl->entry);
+		kfree(tmpl);
+	}
+}
+
+static int qce_ahash_register(struct qce_device *qce)
+{
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(ahash_def); i++) {
+		ret = qce_ahash_register_one(&ahash_def[i], qce);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	qce_ahash_unregister(qce);
+	return ret;
+}
+
+const struct qce_algo_ops ahash_ops = {
+	.type = CRYPTO_ALG_TYPE_AHASH,
+	.register_algs = qce_ahash_register,
+	.unregister_algs = qce_ahash_unregister,
+	.async_req_handle = qce_ahash_async_req_handle,
+};
diff --git a/drivers/crypto/qce/sha.h b/drivers/crypto/qce/sha.h
new file mode 100644
index 0000000..286f0d5
--- /dev/null
+++ b/drivers/crypto/qce/sha.h
@@ -0,0 +1,81 @@
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
+#ifndef _SHA_H_
+#define _SHA_H_
+
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
+
+#include "common.h"
+#include "core.h"
+
+#define QCE_SHA_MAX_BLOCKSIZE		SHA256_BLOCK_SIZE
+#define QCE_SHA_MAX_DIGESTSIZE		SHA256_DIGEST_SIZE
+
+struct qce_sha_ctx {
+	u8 authkey[QCE_SHA_MAX_BLOCKSIZE];
+};
+
+/**
+ * struct qce_sha_reqctx - holds private ahash objects per request
+ * @buf: used during update, import and export
+ * @tmpbuf: buffer for internal use
+ * @digest: calculated digest buffer
+ * @buflen: length of the buffer
+ * @flags: operation flags
+ * @src_orig: original request sg list
+ * @nbytes_orig: original request number of bytes
+ * @src_chained: is source scatterlist chained
+ * @src_nents: source number of entries
+ * @byte_count: byte count
+ * @count: save count in states during update, import and export
+ * @first_blk: is it the first block
+ * @last_blk: is it the last block
+ * @sg: used to chain sg lists
+ * @authkey: pointer to auth key in sha ctx
+ * @authklen: auth key length
+ * @result_sg: scatterlist used for result buffer
+ */
+struct qce_sha_reqctx {
+	u8 buf[QCE_SHA_MAX_BLOCKSIZE];
+	u8 tmpbuf[QCE_SHA_MAX_BLOCKSIZE];
+	u8 digest[QCE_SHA_MAX_DIGESTSIZE];
+	unsigned int buflen;
+	unsigned long flags;
+	struct scatterlist *src_orig;
+	unsigned int nbytes_orig;
+	bool src_chained;
+	int src_nents;
+	__be32 byte_count[2];
+	u64 count;
+	bool first_blk;
+	bool last_blk;
+	struct scatterlist sg[2];
+	u8 *authkey;
+	unsigned int authklen;
+	struct scatterlist result_sg;
+};
+
+static inline struct qce_alg_template *to_ahash_tmpl(struct crypto_tfm *tfm)
+{
+	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
+	struct ahash_alg *alg = container_of(crypto_hash_alg_common(ahash),
+					     struct ahash_alg, halg);
+
+	return container_of(alg, struct qce_alg_template, alg.ahash);
+}
+
+extern const struct qce_algo_ops ahash_ops;
+
+#endif /* _SHA_H_ */
-- 
1.7.0.4

