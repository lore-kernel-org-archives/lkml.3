Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaGaUBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:01:32 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45219 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaGaUBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:01:30 -0400
Message-ID: <53DAA097.90005@amacapital.net>
Date: Thu, 31 Jul 2014 13:01:27 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Cristian Stoica <cristian.stoica@freescale.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
CC: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: add support for TLS 1.0 record encryption
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com> <1406626353-23309-2-git-send-email-cristian.stoica@freescale.com>
In-Reply-To: <1406626353-23309-2-git-send-email-cristian.stoica@freescale.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 02:32 AM, Cristian Stoica wrote:
> This patch adds kernel support for encryption/decryption of TLS 1.0
> records using block ciphers. Implementation is similar to authenc in
> the sense that the base algorithms (AES, SHA1) are combined in a
> template to produce TLS encapsulation frames. The composite algorithm
> will be called "tls10(hmac(<digest>),cbc(<cipher>))". The cipher and
> hmac keys are wrapped in the same format used by authenc.c
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  crypto/Kconfig           |  20 ++
>  crypto/Makefile          |   1 +
>  crypto/authenc.c         |   5 +-
>  crypto/tls.c             | 528 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/crypto/authenc.h |   3 +
>  5 files changed, 555 insertions(+), 2 deletions(-)
>  create mode 100644 crypto/tls.c
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 6345c47..54cc843 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -212,6 +212,26 @@ config CRYPTO_SEQIV
>  	  This IV generator generates an IV based on a sequence number by
>  	  xoring it with a salt.  This algorithm is mainly useful for CTR
>  
> +config CRYPTO_TLS
> +	tristate "TLS support"
> +	select CRYPTO_AUTHENC
> +	select CRYPTO_AEAD
> +	select CRYPTO_BLKCIPHER
> +	select CRYPTO_MANAGER
> +	select CRYPTO_HASH
> +	help
> +	  Support for TLS record encryption and decryption
> +
> +	  This module adds support for encryption/decryption of TLS frames
> +	  using blockcipher algorithms. The resulting algorithm is called
> +	  "tls10(hmac(<digest>),cbc(<cipher>))".
> +
> +	  By default, the generic base algorithms are used (e.g. aes-generic,
> +	  sha1-generic), but hardware accelerated versions will be used
> +	  automatically if available.
> +	  User-space applications (OpenSSL, GnuTLS) can offload TLS operations
> +	  through AF_ALG or cryptodev interfaces
> +
>  comment "Block modes"
>  
>  config CRYPTO_CBC
> diff --git a/crypto/Makefile b/crypto/Makefile
> index cfa57b3..16088d1 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -85,6 +85,7 @@ obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
>  obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
>  obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_common.o crct10dif_generic.o
>  obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
> +obj-$(CONFIG_CRYPTO_TLS) += tls.o
>  obj-$(CONFIG_CRYPTO_LZO) += lzo.o
>  obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
>  obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
> diff --git a/crypto/authenc.c b/crypto/authenc.c
> index e122355..7f6c65d 100644
> --- a/crypto/authenc.c
> +++ b/crypto/authenc.c
> @@ -82,8 +82,8 @@ int crypto_authenc_extractkeys(struct crypto_authenc_keys *keys, const u8 *key,
>  }
>  EXPORT_SYMBOL_GPL(crypto_authenc_extractkeys);
>  
> -static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
> -				 unsigned int keylen)
> +int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
> +			  unsigned int keylen)
>  {
>  	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
>  	struct crypto_ahash *auth = ctx->auth;
> @@ -118,6 +118,7 @@ badkey:
>  	crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
>  	goto out;
>  }
> +EXPORT_SYMBOL_GPL(crypto_authenc_setkey);
>  
>  static void authenc_geniv_ahash_update_done(struct crypto_async_request *areq,
>  					    int err)
> diff --git a/crypto/tls.c b/crypto/tls.c
> new file mode 100644
> index 0000000..b6aedcd
> --- /dev/null
> +++ b/crypto/tls.c
> @@ -0,0 +1,528 @@
> +/*
> + * Copyright 2014 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#include <crypto/aead.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/authenc.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +
> +struct tls_instance_ctx {
> +	struct crypto_ahash_spawn auth;
> +	struct crypto_skcipher_spawn enc;
> +};
> +
> +struct crypto_tls_ctx {
> +	unsigned int reqoff;
> +	struct crypto_ahash *auth;
> +	struct crypto_ablkcipher *enc;
> +};
> +
> +struct tls_request_ctx {
> +	/*
> +	 * cryptlen holds the payload length in the case of encryption or
> +	 * payload_len + icv_len + padding_len in case of decryption
> +	 */
> +	unsigned int cryptlen;
> +	/* working space for partial results */
> +	struct scatterlist icv[2];
> +	struct scatterlist cipher[2];
> +	char tail[];
> +};
> +
> +struct async_op {
> +	struct completion completion;
> +	int err;
> +};
> +
> +static void tls_async_op_done(struct crypto_async_request *req, int err)
> +{
> +	struct async_op *areq = req->data;
> +
> +	if (err == -EINPROGRESS)
> +		return;
> +
> +	areq->err = err;
> +	complete(&areq->completion);
> +}
> +
> +/**
> + * crypto_tls_genicv - Calculate hmac digest for a TLS record
> + * @hash:	(output) buffer to save the digest into
> + * @src:	(input) scatterlist with the payload data
> + * @srclen:	(input) size of the payload data
> + * @req:	(input) aead request (with pointers to associated data)
> + **/
> +static int crypto_tls_genicv(u8 *hash, struct scatterlist *src,
> +			     unsigned int srclen, struct aead_request *req)
> +{
> +	struct crypto_aead *tls = crypto_aead_reqtfm(req);
> +	struct crypto_tls_ctx *ctx = crypto_aead_ctx(tls);
> +	struct tls_request_ctx *treq_ctx = aead_request_ctx(req);
> +	struct scatterlist *assoc = req->assoc;
> +	struct scatterlist *icv = treq_ctx->icv;
> +	struct async_op ahash_op;
> +	struct ahash_request *ahreq = (void *)(treq_ctx->tail + ctx->reqoff);
> +	unsigned int flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +	int err = -EBADMSG;
> +
> +	/*
> +	 * Bail out as we have only two maneuvering scatterlists in icv. Check
> +	 * also if the request assoc len matches the scatterlist len
> +	 */
> +	if (!req->assoclen || !sg_is_last(assoc) ||
> +	    req->assoclen != assoc->length)
> +		return err;
> +
> +	/*
> +	 * Prepend associated data to the source scatterlist. If the source is
> +	 * empty, use directly the associated data scatterlist
> +	 */
> +	if (srclen) {
> +		sg_init_table(icv, 2);
> +		sg_set_page(icv, sg_page(assoc), assoc->length, assoc->offset);
> +		scatterwalk_sg_chain(icv, 2, src);
> +	} else {
> +		icv = assoc;
> +	}
> +	srclen += assoc->length;
> +
> +	init_completion(&ahash_op.completion);
> +
> +	/* the hash transform to be executed comes from the original request */
> +	ahash_request_set_tfm(ahreq, ctx->auth);
> +	/* prepare the hash request with input data and result pointer */
> +	ahash_request_set_crypt(ahreq, icv, hash, srclen);
> +	/* set the notifier for when the async hash function returns */
> +	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
> +				   tls_async_op_done, &ahash_op);
> +
> +	/* Calculate the digest on the given data. The result is put in hash */
> +	err = crypto_ahash_digest(ahreq);
> +	if (err == -EINPROGRESS) {
> +		err = wait_for_completion_interruptible(&ahash_op.completion);
> +		if (!err)
> +			err = ahash_op.err;
> +	}
> +
> +	return err;
> +}
> +
> +/**
> + * crypto_tls_gen_padicv - Calculate and pad hmac digest for a TLS record
> + * @hash:	(output) buffer to save the digest and padding into
> + * @phashlen:	(output) the size of digest + padding
> + * @req:	(input) aead request
> + **/
> +static int crypto_tls_gen_padicv(u8 *hash, unsigned int *phashlen,
> +				 struct aead_request *req)
> +{
> +	struct crypto_aead *tls = crypto_aead_reqtfm(req);
> +	unsigned int hash_size = crypto_aead_authsize(tls);
> +	unsigned int block_size = crypto_aead_blocksize(tls);
> +	unsigned int srclen = req->cryptlen + hash_size;
> +	unsigned int padlen;
> +	int err;
> +
> +	err = crypto_tls_genicv(hash, req->src, req->cryptlen, req);
> +	if (err)
> +		goto out;
> +
> +	/* add padding after digest */
> +	padlen = block_size - (srclen % block_size);
> +	memset(hash + hash_size, padlen - 1, padlen);
> +
> +	*phashlen = hash_size + padlen;
> +out:
> +	return err;
> +}
> +
> +static int crypto_tls_encrypt(struct aead_request *req)
> +{
> +	struct crypto_aead *tls = crypto_aead_reqtfm(req);
> +	struct crypto_tls_ctx *ctx = crypto_aead_ctx(tls);
> +	struct tls_request_ctx *treq_ctx = aead_request_ctx(req);
> +
> +	unsigned int cryptlen, phashlen;
> +	struct scatterlist *cipher = treq_ctx->cipher;
> +	struct scatterlist *sg, *src_last = NULL;
> +	int err;
> +	/*
> +	 * The hash and the cipher are applied at different times and their
> +	 * requests can use the same memory space without interference
> +	 */
> +	struct ablkcipher_request *abreq = (void *)(treq_ctx->tail +
> +						    ctx->reqoff);
> +	/*
> +	 * The hash result is saved at the beginning of the tls request and is
> +	 * aligned as required by the hash transform. Enough space was
> +	 * allocated in crypto_tls_init_tfm to accomodate the difference. The
> +	 * requests themselves start later at treq_ctx->tail + ctx->reqoff so
> +	 * the result is not overwritten by the second (cipher) request
> +	 */
> +	u8 *hash = treq_ctx->tail;
> +
> +	hash = (u8 *)ALIGN((unsigned long)hash +
> +			   crypto_ahash_alignmask(ctx->auth),
> +			   crypto_ahash_alignmask(ctx->auth) + 1);
> +
> +	/*
> +	 * STEP 1: create ICV together with necessary padding
> +	 */
> +	err = crypto_tls_gen_padicv(hash, &phashlen, req);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * STEP 2: Hash and padding are combined with the payload
> +	 * depending on the form it arrives. Scatter tables must have at least
> +	 * one page of data before chaining with another table and can't have
> +	 * an empty data page. The following code addresses these requirements.
> +	 *
> +	 * For same-destination, hash is copied directly after the
> +	 * payload since the buffers must have enough space for encryption.
> +	 * For different destination there are several casess to check.
> +	 * If the payload is empty, only the hash is encrypted, otherwise the
> +	 * payload scatterlist is merged with the hash. A special merging case
> +	 * is when the payload has only one page of data. In that case the
> +	 * payload page is moved to another scatterlist and prepared there for
> +	 * encryption.
> +	 */
> +
> +	if (req->src == req->dst) {
> +		scatterwalk_map_and_copy(hash, req->src, req->cryptlen,
> +					 phashlen, 1);
> +	} else {
> +		if (req->cryptlen) {
> +			sg_init_table(cipher, 2);
> +			sg_set_buf(cipher + 1, hash, phashlen);
> +			if (sg_is_last(req->src)) {
> +				sg_set_page(cipher, sg_page(req->src),
> +					req->src->length, req->src->offset);
> +				req->src = cipher;
> +			} else {
> +				for (sg = req->src; sg; sg = sg_next(sg))
> +					src_last = sg;
> +				sg_set_page(cipher, sg_page(src_last),
> +					src_last->length, src_last->offset);
> +				scatterwalk_sg_chain(src_last, 1, cipher);
> +			}
> +		} else {
> +			sg_init_one(req->src, hash, phashlen);
> +		}
> +	}
> +
> +	/*
> +	 * STEP 3: encrypt the frame and return the result
> +	 */
> +	cryptlen = req->cryptlen + phashlen;
> +	ablkcipher_request_set_tfm(abreq, ctx->enc);
> +	ablkcipher_request_set_crypt(abreq, req->src, req->dst, cryptlen,
> +				     req->iv);
> +	/* set the callback for encryption request termination */
> +	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
> +					req->base.complete, req->base.data);
> +	/*
> +	 * Apply the cipher transform. The result will be in req->dst when the
> +	 * asynchronuous call terminates
> +	 */
> +	err = crypto_ablkcipher_encrypt(abreq);
> +
> +	return err;
> +}
> +
> +static int crypto_tls_decrypt(struct aead_request *req)
> +{
> +	struct crypto_aead *tls = crypto_aead_reqtfm(req);
> +	struct crypto_tls_ctx *ctx = crypto_aead_ctx(tls);
> +	struct tls_request_ctx *treq_ctx = aead_request_ctx(req);
> +	struct scatterlist *assoc = req->assoc;
> +	unsigned int cryptlen = req->cryptlen;
> +	unsigned int hash_size = crypto_aead_authsize(tls);
> +	unsigned int block_size = crypto_aead_blocksize(tls);
> +	struct ablkcipher_request *abreq = (void *)(treq_ctx->tail +
> +						    ctx->reqoff);
> +	u8 padding[255]; /* padding can be 0-255 bytes */
> +	u8 pad_size;
> +	u16 *len_field;
> +	u8 *ihash, *hash = treq_ctx->tail;
> +
> +	int paderr = 0;
> +	int err = -EINVAL;
> +	int i;
> +	struct async_op ciph_op;
> +
> +	/*
> +	 * Rule out bad packets. The input packet length must be at least one
> +	 * byte more than the hash_size
> +	 */
> +	if (cryptlen <= hash_size || cryptlen % block_size)
> +		goto out;
> +
> +	/*
> +	 * Step 1 - Decrypt the source
> +	 */
> +	init_completion(&ciph_op.completion);
> +
> +	ablkcipher_request_set_tfm(abreq, ctx->enc);
> +	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
> +					tls_async_op_done, &ciph_op);
> +	ablkcipher_request_set_crypt(abreq, req->src, req->dst, cryptlen,
> +				     req->iv);
> +	err = crypto_ablkcipher_decrypt(abreq);
> +	if (err == -EINPROGRESS) {
> +		err = wait_for_completion_interruptible(&ciph_op.completion);
> +		if (!err)
> +			err = ciph_op.err;
> +	}
> +	if (err)
> +		goto out;
> +
> +	/*
> +	 * Step 2 - Verify padding
> +	 * Retrieve the last byte of the payload; this is the padding size
> +	 */
> +	cryptlen -= 1;
> +	scatterwalk_map_and_copy(&pad_size, req->dst, cryptlen, 1, 0);
> +
> +	/* RFC recommendation to defend against timing attacks is to continue
> +	 * with hash calculation even if the padding is incorrect */
> +	if (cryptlen < pad_size + hash_size) {
> +		pad_size = 0;
> +		paderr = -EBADMSG;
> +	}
> +	cryptlen -= pad_size;
> +	scatterwalk_map_and_copy(padding, req->dst, cryptlen, pad_size, 0);
> +
> +	/* Padding content must be equal with pad_size. We verify it all */
> +	for (i = 0; i < pad_size; i++)
> +		if (padding[i] != pad_size)
> +			paderr = -EBADMSG;
> +
> +	/*
> +	 * Step 3 - Verify hash
> +	 * Align the digest result as required by the hash transform. Enough
> +	 * space was allocated in crypto_tls_init_tfm
> +	 */
> +	hash = (u8 *)ALIGN((unsigned long)hash +
> +			   crypto_ahash_alignmask(ctx->auth),
> +			   crypto_ahash_alignmask(ctx->auth) + 1);
> +	/*
> +	 * Two bytes at the end of the associated data make the length field.
> +	 * It must be updated with the length of the cleartext message before
> +	 * the hash is calculated.
> +	 */
> +	len_field = sg_virt(assoc) + assoc->length - 2;
> +	cryptlen -= hash_size;
> +	*len_field = htons(cryptlen);
> +
> +	/* This is the hash from the decrypted packet. Save it for later */
> +	ihash = hash + hash_size;
> +	scatterwalk_map_and_copy(ihash, req->dst, cryptlen, hash_size, 0);
> +
> +	/* Now compute and compare our ICV with the one from the packet */
> +	err = crypto_tls_genicv(hash, req->dst, cryptlen, req);
> +	if (!err)
> +		err = crypto_memneq(hash, ihash, hash_size) ? -EBADMSG : 0;

This looks like it's vulnerable to the Lucky 13 attack.

--Andy
