Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaDCQVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:21:40 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56129 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbaDCQVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:21:37 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 5/9] crypto: qce: Adds sha and hmac transforms
Date: Thu,  3 Apr 2014 19:18:02 +0300
Message-Id: <1396541886-10966-6-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the implementation and registration of ahash crypto type.
It includes sha1, sha256, hmac(sha1) and hmac(sha256).

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/qce/sha.c | 595 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/sha.h |  74 ++++++
 2 files changed, 669 insertions(+)
 create mode 100644 drivers/crypto/qce/sha.c
 create mode 100644 drivers/crypto/qce/sha.h

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
new file mode 100644
index 000000000000..d63818360c92
--- /dev/null
+++ b/drivers/crypto/qce/sha.c
@@ -0,0 +1,595 @@
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
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
+
+#include "dma.h"
+#include "core.h"
+#include "common.h"
+#include "sha.h"
+
+/* crypto hw padding constant for first operation */
+#define SHA_PADDING		64
+#define SHA_PADDING_MASK	(SHA_PADDING - 1)
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
+static void qce_ahash_dma_done(void *data)
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
+	qce_dma_terminate_all(&qce->dma);
+
+	qce_unmapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
+		     rctx->src_chained);
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
+		dev_err(qce->dev, "ahash operation error (%x)\n", status);
+
+	req->src = rctx->src;
+	req->nbytes = rctx->nbytes;
+
+	rctx->last_blk = false;
+	rctx->first_blk = false;
+
+	tmpl->async_req_done(tmpl->qce, error);
+}
+
+static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
+{
+	struct ahash_request *req = ahash_request_cast(async_req);
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	u32 flags = rctx->flags;
+	int rc;
+
+	if (IS_SHA(flags)) {
+		rctx->authkey = NULL;
+		rctx->authklen = 0;
+	} else if (IS_SHA_HMAC(flags)) {
+		rctx->authkey = ctx->authkey;
+		rctx->authklen = QCE_SHA_HMAC_KEY_SIZE;
+	} else if (IS_CMAC(flags)) {
+		rctx->authkey = ctx->authkey;
+		rctx->authklen = AES_KEYSIZE_128;
+	} else {
+		dev_err(qce->dev, "unsupported ahash algorithm\n");
+		return -EINVAL;
+	}
+
+	rctx->src_nents = qce_countsg(req->src, req->nbytes,
+				      &rctx->src_chained);
+	rc = qce_mapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
+		       rctx->src_chained);
+	if (rc < 0)
+		return rc;
+
+	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
+
+	rc = qce_mapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
+	if (rc < 0)
+		goto error_unmap_src;
+
+	rc = qce_dma_prep_sgs(&qce->dma, req->src, rctx->src_nents,
+			      &rctx->result_sg, 1,
+			      qce_ahash_dma_done, async_req);
+	if (rc)
+		goto error_unmap_src;
+
+	qce_dma_issue_pending(&qce->dma);
+
+	rc = qce_start(async_req, tmpl->crypto_alg_type, 0, 0);
+	if (rc)
+		goto error_terminate;
+
+	return 0;
+
+error_terminate:
+	qce_dma_terminate_all(&qce->dma);
+	qce_unmapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
+error_unmap_src:
+	qce_unmapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
+		     rctx->src_chained);
+	return rc;
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
+	u32 flags = rctx->flags;
+	unsigned int digestsize = crypto_ahash_digestsize(ahash);
+	unsigned int blocksize;
+	int ret = 0;
+
+	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+
+	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
+		struct sha1_state *out_state = out;
+
+		out_state->count = rctx->count;
+		qce_cpu_to_be32p_array(out_state->state, rctx->digest,
+				       digestsize);
+		memcpy(out_state->buffer, rctx->trailing_buf, blocksize);
+
+	} else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags)) {
+		struct sha256_state *out_state = out;
+
+		out_state->count = rctx->count;
+		qce_cpu_to_be32p_array(out_state->state, rctx->digest,
+				       digestsize);
+		memcpy(out_state->buf, rctx->trailing_buf, blocksize);
+	} else {
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int qce_import_common(struct ahash_request *req, u64 in_count,
+				 u32 *state, u8 *buffer, bool hmac)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	u64 count = in_count;
+	unsigned int digestsize = crypto_ahash_digestsize(ahash);
+	unsigned int blocksize;
+
+	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+	rctx->count = in_count;
+	memcpy(rctx->trailing_buf, buffer, blocksize);
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
+	rctx->byte_count[0] = (u32)(count & ~SHA_PADDING_MASK);
+	rctx->byte_count[1] = (u32)(count >> 32);
+	qce_cpu_to_be32p_array((__be32 *)rctx->digest, (const u8 *)state,
+			       digestsize);
+	rctx->trailing_buf_len = (unsigned int)(in_count & (blocksize - 1));
+
+	return 0;
+}
+
+static int qce_ahash_import(struct ahash_request *req, const void *in)
+{
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	u32 flags = rctx->flags;
+	bool hmac = IS_SHA_HMAC(flags);
+	int ret;
+
+	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
+		struct sha1_state *state = (struct sha1_state *)in;
+
+		ret = qce_import_common(req, state->count, state->state,
+					state->buffer, hmac);
+	} else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags)) {
+		struct sha256_state *state = (struct sha256_state *)in;
+
+		ret = qce_import_common(req, state->count, state->state,
+					state->buf, hmac);
+	} else {
+		ret = -EINVAL;
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
+	unsigned int total, len;
+	int nents;
+	struct scatterlist *sg_last;
+	u8 *buf;
+	u32 pad_len;
+	u32 trailing_buf_len;
+	u32 nbytes;
+	u32 offset;
+	u32 bytes;
+	u8 *staging;
+	bool chained;
+	unsigned int blocksize;
+
+	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	rctx->count += req->nbytes;
+
+	/* check for trailing buffer from previous updates and append it */
+	total = req->nbytes + rctx->trailing_buf_len;
+	len = req->nbytes;
+
+	if (total <= blocksize) {
+		buf = &rctx->trailing_buf[rctx->trailing_buf_len];
+		nents = qce_countsg(req->src, len, &chained);
+		bytes = sg_copy_to_buffer(req->src, nents, buf, len);
+		if (bytes != len) {
+			rctx->count -= req->nbytes;
+			return -EINVAL;
+		}
+
+		rctx->trailing_buf_len = total;
+		return 0;
+	}
+
+	/* save the original req structure fields */
+	rctx->src = req->src;
+	rctx->nbytes = req->nbytes;
+
+	staging = rctx->staging_buf;
+	staging = PTR_ALIGN(staging, dma_get_cache_alignment());
+	memcpy(staging, rctx->trailing_buf, rctx->trailing_buf_len);
+	buf = rctx->trailing_buf;
+
+	/* get new trailing buffer */
+	pad_len = ALIGN(total, blocksize) - total;
+	trailing_buf_len = blocksize - pad_len;
+	offset = req->nbytes - trailing_buf_len;
+
+	if (offset != req->nbytes)
+		scatterwalk_map_and_copy(buf, req->src, offset,
+					 trailing_buf_len, 0);
+
+	nbytes = total - trailing_buf_len;
+
+	len = rctx->trailing_buf_len;
+	sg_last = req->src;
+
+	while (len < nbytes) {
+		if ((len + sg_last->length) > nbytes)
+			break;
+		len += sg_last->length;
+		sg_last = scatterwalk_sg_next(sg_last);
+	}
+
+	sg_mark_end(sg_last);
+
+	if (rctx->trailing_buf_len) {
+		sg_init_table(rctx->sg, 2);
+		sg_set_buf(&rctx->sg[0], staging, rctx->trailing_buf_len);
+		scatterwalk_sg_chain(rctx->sg, 2, req->src);
+		req->src = rctx->sg;
+	}
+
+	req->nbytes = nbytes;
+	rctx->trailing_buf_len = trailing_buf_len;
+
+	return tmpl->async_req_queue(tmpl->qce, &req->base);
+}
+
+static int qce_ahash_final(struct ahash_request *req)
+{
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
+	u8 *staging;
+
+	rctx->last_blk = true;
+
+	/* save the original req structure fields */
+	rctx->src = req->src;
+	rctx->nbytes = req->nbytes;
+
+	staging = rctx->staging_buf;
+	staging = PTR_ALIGN(staging, dma_get_cache_alignment());
+	memcpy(staging, rctx->trailing_buf, rctx->trailing_buf_len);
+	sg_init_one(rctx->sg, staging, rctx->trailing_buf_len);
+
+	req->src = rctx->sg;
+	req->nbytes = rctx->trailing_buf_len;
+
+	return tmpl->async_req_queue(tmpl->qce, &req->base);
+}
+
+static int qce_ahash_digest(struct ahash_request *req)
+{
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
+	int ret;
+
+	ret = qce_ahash_init(req);
+	if (ret)
+		return ret;
+
+	/* save the original req structure fields */
+	rctx->src = req->src;
+	rctx->nbytes = req->nbytes;
+	rctx->first_blk = true;
+	rctx->last_blk = true;
+
+	return tmpl->async_req_queue(tmpl->qce, &req->base);
+}
+
+struct qce_ahash_result {
+	struct completion completion;
+	int error;
+};
+
+static void qce_setkey_complete(struct crypto_async_request *req, int error)
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
+	memset(ctx->authkey, 0, blocksize);
+
+	if (keylen <= blocksize) {
+		memcpy(ctx->authkey, key, keylen);
+		ret = 0;
+		goto done;
+	}
+
+	if (digestsize == SHA1_DIGEST_SIZE)
+		alg_name = "sha1";
+	else
+		alg_name = "sha256";
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
+				   qce_setkey_complete, &result);
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
+done:
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
+static void qce_ahash_cra_exit(struct crypto_tfm *tfm)
+{
+}
+
+struct qce_ahash_def {
+	u32 flags;
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
+				  struct qce_device *qce,
+				  struct qce_algo_ops *ops)
+{
+	struct qce_alg_template *tmpl;
+	struct ahash_alg *alg;
+	struct crypto_alg *base;
+	struct list_head *alg_list = &qce->alg_list;
+	int rc;
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
+	base->cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC;
+	base->cra_ctxsize = sizeof(struct qce_sha_ctx);
+	base->cra_alignmask = 0;
+	base->cra_type = &crypto_ahash_type;
+	base->cra_module = THIS_MODULE;
+	base->cra_init = qce_ahash_cra_init;
+	base->cra_exit = qce_ahash_cra_exit;
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
+	tmpl->async_req_queue = ops->async_req_queue;
+	tmpl->async_req_done = ops->async_req_done;
+	ops->async_req_handle = qce_ahash_async_req_handle;
+
+	rc = crypto_register_ahash(alg);
+	if (rc) {
+		dev_err(qce->dev, "%s registration failed\n", base->cra_name);
+		kfree(tmpl);
+		return rc;
+	}
+
+	list_add_tail(&tmpl->entry, alg_list);
+	dev_info(qce->dev, "%s is registered\n", base->cra_name);
+	return 0;
+}
+
+int qce_ahash_register(struct qce_device *qce, struct qce_algo_ops *ops)
+{
+	int rc, i;
+
+	for (i = 0; i < ARRAY_SIZE(ahash_def); i++) {
+		rc = qce_ahash_register_one(&ahash_def[i], qce, ops);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/qce/sha.h b/drivers/crypto/qce/sha.h
new file mode 100644
index 000000000000..4a99a8f0de82
--- /dev/null
+++ b/drivers/crypto/qce/sha.h
@@ -0,0 +1,74 @@
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
+struct qce_sha_ctx {
+	u8 authkey[SHA256_BLOCK_SIZE];
+};
+
+#define STAGING_BUF_SZ	\
+	(SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE + QCE_MAX_ALIGN_SIZE)
+
+/*
+ * @flags: operation flags
+ * @src: request sg
+ * @src_chained: is source scatterlist chained
+ * @src_nents: source number of entries
+ * @nbytes: request number of bytes
+ * @byte_count: byte count
+ * @count: save count in states during update, import and export
+ * @first_blk: is it the first block
+ * @last_blk: is it the last block
+ * @trailing_buf: used during update, import and export
+ * @trailing_buf_len: lenght of the trailing buffer
+ * @staging_buf: buffer for internal use
+ * @digest: calculated digest
+ * @sg: used to chain sg lists
+ * @authkey: pointer to auth key in sha ctx
+ * @authklen: auth key length
+ * @result_sg: scatterlist used for result buffer
+ */
+struct qce_sha_reqctx {
+	u32 flags;
+	struct scatterlist *src;
+	bool src_chained;
+	int src_nents;
+	unsigned int nbytes;
+	u32 byte_count[2];
+	u64 count;
+	bool first_blk;
+	bool last_blk;
+	u8 trailing_buf[SHA256_BLOCK_SIZE];
+	unsigned int trailing_buf_len;
+	u8 staging_buf[STAGING_BUF_SZ];
+	u8 digest[SHA256_DIGEST_SIZE];
+	struct scatterlist sg[2];
+	u8 *authkey;
+	unsigned int authklen;
+	struct scatterlist result_sg;
+};
+
+int qce_ahash_register(struct qce_device *qce, struct qce_algo_ops *ops);
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
+#endif /* _SHA_H_ */
-- 
1.8.4.4

