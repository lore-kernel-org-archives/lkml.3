Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaDIAJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:09:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54403 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbaDIAJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:09:33 -0400
Date: Tue, 8 Apr 2014 17:09:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 5/9] crypto: qce: Adds sha and hmac transforms
Message-ID: <20140409000931.GN9985@codeaurora.org>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
 <1396541886-10966-6-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396541886-10966-6-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03, Stanimir Varbanov wrote:
> +static void qce_ahash_dma_done(void *data)
> +{
> +	struct crypto_async_request *async_req = data;
> +	struct ahash_request *req = ahash_request_cast(async_req);
> +	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
> +	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
> +	struct qce_alg_template *tmpl = to_ahash_tmpl(async_req->tfm);
> +	struct qce_device *qce = tmpl->qce;
> +	struct qce_result_dump *result = qce->dma.result_buf;
> +	unsigned int digestsize = crypto_ahash_digestsize(ahash);
> +	int error;
> +	u32 status;
> +
> +	qce_dma_terminate_all(&qce->dma);
> +
> +	qce_unmapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
> +		     rctx->src_chained);
> +	qce_unmapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
> +
> +	memcpy(rctx->digest, result->auth_iv, digestsize);
> +	if (req->result)
> +		memcpy(req->result, result->auth_iv, digestsize);
> +
> +	rctx->byte_count[0] = cpu_to_be32(result->auth_byte_count[0]);
> +	rctx->byte_count[1] = cpu_to_be32(result->auth_byte_count[1]);

Does rctx->byte_count need to be marked __be32?

> +
> +	error = qce_check_status(qce, &status);
> +	if (error < 0)
> +		dev_err(qce->dev, "ahash operation error (%x)\n", status);
> +
> +	req->src = rctx->src;
> +	req->nbytes = rctx->nbytes;
> +
> +	rctx->last_blk = false;
> +	rctx->first_blk = false;
> +
> +	tmpl->async_req_done(tmpl->qce, error);
> +}
> +
[...]
> +static int qce_import_common(struct ahash_request *req, u64 in_count,
> +				 u32 *state, u8 *buffer, bool hmac)
> +{
> +	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
> +	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
> +	u64 count = in_count;
> +	unsigned int digestsize = crypto_ahash_digestsize(ahash);
> +	unsigned int blocksize;
> +
> +	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
> +	rctx->count = in_count;
> +	memcpy(rctx->trailing_buf, buffer, blocksize);
> +
> +	if (in_count <= blocksize) {
> +		rctx->first_blk = 1;
> +	} else {
> +		rctx->first_blk = 0;
> +		/*
> +		 * For HMAC, there is a hardware padding done when first block
> +		 * is set. Therefore the byte_count must be incremened by 64
> +		 * after the first block operation.
> +		 */
> +		if (hmac)
> +			count += SHA_PADDING;
> +	}
> +
> +	rctx->byte_count[0] = (u32)(count & ~SHA_PADDING_MASK);
> +	rctx->byte_count[1] = (u32)(count >> 32);
> +	qce_cpu_to_be32p_array((__be32 *)rctx->digest, (const u8 *)state,
> +			       digestsize);
> +	rctx->trailing_buf_len = (unsigned int)(in_count & (blocksize - 1));

Is this a way to say

	(unsigned int)clamp_t(u64, in_count, blocksize - 1)

?

> +
> +	return 0;
> +}
> +
> +static int qce_ahash_import(struct ahash_request *req, const void *in)
> +{
> +	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
> +	u32 flags = rctx->flags;
> +	bool hmac = IS_SHA_HMAC(flags);
> +	int ret;
> +
> +	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
> +		struct sha1_state *state = (struct sha1_state *)in;

Unnecessary cast from void *.

> +
> +		ret = qce_import_common(req, state->count, state->state,
> +					state->buffer, hmac);
> +	} else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags)) {
> +		struct sha256_state *state = (struct sha256_state *)in;

Ditto.

> +
> +		ret = qce_import_common(req, state->count, state->state,
> +					state->buf, hmac);
> +	} else {
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int qce_ahash_update(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
> +	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
> +	unsigned int total, len;
> +	int nents;
> +	struct scatterlist *sg_last;
> +	u8 *buf;

> +	u32 pad_len;
> +	u32 trailing_buf_len;
> +	u32 nbytes;
> +	u32 offset;
> +	u32 bytes;

size_t for these?

> +	u8 *staging;
> +	bool chained;
> +	unsigned int blocksize;
> +
> +	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
> +	rctx->count += req->nbytes;
> +
> +	/* check for trailing buffer from previous updates and append it */
> +	total = req->nbytes + rctx->trailing_buf_len;
> +	len = req->nbytes;
[...]
> +
> +struct qce_ahash_def {
> +	u32 flags;

unsigned long?

> +	const char *name;
> +	const char *drv_name;
> +	unsigned int digestsize;
> +	unsigned int blocksize;
> +	unsigned int statesize;
> +	const __be32 *std_iv;
> +};
[..]
> +
> +/*

Nit: This isn't kernel doc notation

> + * @flags: operation flags
> + * @src: request sg
> + * @src_chained: is source scatterlist chained
> + * @src_nents: source number of entries
> + * @nbytes: request number of bytes
> + * @byte_count: byte count
> + * @count: save count in states during update, import and export
> + * @first_blk: is it the first block
> + * @last_blk: is it the last block
> + * @trailing_buf: used during update, import and export
> + * @trailing_buf_len: lenght of the trailing buffer
> + * @staging_buf: buffer for internal use
> + * @digest: calculated digest
> + * @sg: used to chain sg lists
> + * @authkey: pointer to auth key in sha ctx
> + * @authklen: auth key length
> + * @result_sg: scatterlist used for result buffer
> + */
> +struct qce_sha_reqctx {
> +	u32 flags;

unsigned long?

> +	struct scatterlist *src;
> +	bool src_chained;
> +	int src_nents;
> +	unsigned int nbytes;
> +	u32 byte_count[2];
> +	u64 count;
> +	bool first_blk;

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
