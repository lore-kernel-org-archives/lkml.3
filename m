Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaFNTeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:34:13 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:36205 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaFNTeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:34:10 -0400
X-Auth-Info: 4ecIPGH8jKAuMgdVzbc+mnNg65RSaeN3JGK2QGS7NLQ=
From: Marek Vasut <marex@denx.de>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v3 1/4] crypto: Add Allwinner Security System crypto accelerator
Date: Sat, 14 Jun 2014 21:01:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <1402404197-4236-2-git-send-email-clabbe.montjoie@gmail.com>
In-Reply-To: <1402404197-4236-2-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201406142101.02747.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 at 02:43:14 PM, LABBE Corentin wrote:
> Add support for the Security System included in Allwinner SoC A20.
> The Security System is a hardware cryptographic accelerator that support
> AES/MD5/SHA1/DES/3DES/PRNG algorithms.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

[...]

> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c
> b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c new file mode 100644
> index 0000000..fcdc8a4
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c
> @@ -0,0 +1,118 @@
> +/*
> + * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
> + *
> + * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
> + *
> + * Support AES cipher with 128,192,256 bits keysize.
> + * Support MD5 and SHA1 hash algorithms.
> + * Support DES and 3DES
> + * Support PRNG
> + *
> + * You could find the datasheet at
> + * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation version 2 of the License

The license text seems incomplete.
[...]

> +static int sunxi_des3_cbc_encrypt(struct ablkcipher_request *areq)
> +{
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
> +
> +	if (areq->info == NULL) {
> +		dev_info(ss->dev, "Empty IV\n");

dev_err() here.

> +		return -EINVAL;
> +	}
> +
> +	op->mode |= SS_ENCRYPTION;
> +	op->mode |= SS_OP_3DES;
> +	op->mode |= SS_CBC;

You can just op |= (foo | bar | baz) here .

> +	return sunxi_des_poll(areq);
> +}
> +
> +static int sunxi_des3_cbc_decrypt(struct ablkcipher_request *areq)
> +{
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
> +
> +	if (areq->info == NULL) {
> +		dev_info(ss->dev, "Empty IV\n");

DTTO.

> +		return -EINVAL;
> +	}
> +
> +	op->mode |= SS_DECRYPTION;
> +	op->mode |= SS_OP_3DES;
> +	op->mode |= SS_CBC;

DTTO.

[...]
> +static int sunxi_ss_3des_init(void)
> +{
> +	int err = 0;
> +	if (ss == NULL) {
> +		pr_err("Cannot get Security System structure\n");
> +		return -ENODEV;
> +	}
> +	err = crypto_register_alg(&sunxi_des3_alg);
> +	if (err)
> +		dev_err(ss->dev, "crypto_register_alg error for DES3\n");
> +	else
> +		dev_dbg(ss->dev, "Registred DES3\n");
> +	return err;
> +}
> +
> +static void __exit sunxi_ss_3des_exit(void)
> +{
> +	crypto_unregister_alg(&sunxi_des3_alg);
> +}
> +
> +module_init(sunxi_ss_3des_init);
> +module_exit(sunxi_ss_3des_exit);

I really dislike how you have multiple modules accessing the same hardware. That 
just seems broken.

[...]

> +static int sunxi_aes_cbc_encrypt(struct ablkcipher_request *areq)
> +{
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
> +
> +	if (areq->info == NULL) {
> +		dev_err(ss->dev, "Empty IV\n");
> +		return -EINVAL;
> +	}
> +
> +	op->mode |= SS_ENCRYPTION;
> +	op->mode |= SS_OP_AES;
> +	op->mode |= SS_CBC;

This looks just like the 3DES implementation. Please make this into a common 
code if possible. I think you'd just need to have some switch statement based on 
the type of cipher to fill op->mode, that's all.

> +	return sunxi_aes_poll(areq);
> +}

[...]

> +static int sunxi_des_cbc_encrypt(struct ablkcipher_request *areq)
> +{
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
> +
> +	if (areq->info == NULL) {
> +		dev_info(ss->dev, "Empty IV\n");
> +		return -EINVAL;
> +	}
> +
> +	op->mode |= SS_ENCRYPTION;
> +	op->mode |= SS_OP_DES;
> +	op->mode |= SS_CBC;

Looks similar to 3DES and AES again.

> +	return sunxi_des_poll(areq);
> +}

[...]

> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
> b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c new file mode 100644
> index 0000000..a27de49
[...]
> +int sunxi_cipher_init(struct crypto_tfm *tfm)
> +{
> +	struct sunxi_req_ctx *op = crypto_tfm_ctx(tfm);
> +	memset(op, 0, sizeof(struct sunxi_req_ctx));
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(sunxi_cipher_init);

This is wrong, you don't want to export this symbol.

> +void sunxi_cipher_exit(struct crypto_tfm *tfm)
> +{
> +}
> +EXPORT_SYMBOL_GPL(sunxi_cipher_exit);

Why do you even need an empty function ?

> +int sunxi_aes_poll(struct ablkcipher_request *areq)
> +{
> +	u32 tmp;
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
> +	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
> +	/* when activating SS, the default FIFO space is 32 */
> +	u32 rx_cnt = 32;
> +	u32 tx_cnt = 0;
> +	u32 v;
> +	int i;
> +	struct scatterlist *in_sg;
> +	struct scatterlist *out_sg;
> +	void *src_addr;
> +	void *dst_addr;
> +	unsigned int ileft = areq->nbytes;
> +	unsigned int oleft = areq->nbytes;
> +	unsigned int sgileft = areq->src->length;
> +	unsigned int sgoleft = areq->dst->length;
> +	unsigned int todo;
> +	u32 *src32;
> +	u32 *dst32;
> +
> +	tmp = op->mode;
> +	tmp |= SS_ENABLED;

tmp is not a good name for a variable .

> +	in_sg = areq->src;
> +	out_sg = areq->dst;
> +	if (areq->src == NULL || areq->dst == NULL) {

You do a NULL pointer test here, yet you access areq->src->length in sgileft 
above . DTTO for areq->dst->length . That would crash much earlier than here.

> +		dev_err(ss->dev, "ERROR: Some SGs are NULL %u\n", areq->nbytes);
> +		return -1;
> +	}
> +	mutex_lock(&ss->lock);
> +	if (areq->info != NULL) {
> +		for (i = 0; i < op->keylen; i += 4) {
> +			v = *(u32 *)(op->key + i);

Consider that op->key would be magically unaligned ... then you'd trigger 
alignment fault here. Make the "op->key" an u32[] and drop those crap casts 
here.

> +			writel(v, ss->base + SS_KEY0 + i);
> +		}
> +		for (i = 0; i < 4 && i < ivsize / 4; i++) {
> +			v = *(u32 *)(areq->info + i * 4);
> +			writel(v, ss->base + SS_IV0 + i * 4);
> +		}
> +	}
> +	writel(tmp, ss->base + SS_CTL);
> +
> +	/* If we have only one SG, we can use kmap_atomic */
> +	if (sg_next(in_sg) == NULL && sg_next(out_sg) == NULL) {
> +		src_addr = kmap_atomic(sg_page(in_sg)) + in_sg->offset;
> +		if (src_addr == NULL) {
> +			dev_err(ss->dev, "kmap_atomic error for src SG\n");
> +			writel(0, ss->base + SS_CTL);
> +			mutex_unlock(&ss->lock);
> +			return -1;

-EINVAL ?

> +		}
> +		dst_addr = kmap_atomic(sg_page(out_sg)) + out_sg->offset;
> +		if (dst_addr == NULL) {
> +			dev_err(ss->dev, "kmap_atomic error for dst SG\n");
> +			writel(0, ss->base + SS_CTL);
> +			mutex_unlock(&ss->lock);
> +			kunmap_atomic(src_addr);
> +			return -1;

-EINVAL ?

> +		}
> +		src32 = (u32 *)src_addr;
> +		dst32 = (u32 *)dst_addr;
> +		ileft = areq->nbytes / 4;
> +		oleft = areq->nbytes / 4;
> +		do {
> +			if (ileft > 0 && rx_cnt > 0) {
> +				todo = min(rx_cnt, ileft);
> +				ileft -= todo;
> +				do {
> +					writel_relaxed(*src32++,
> +						       ss->base +
> +						       SS_RXFIFO);
> +					todo--;
> +				} while (todo > 0);
> +			}
> +			if (tx_cnt > 0) {
> +				todo = min(tx_cnt, oleft);
> +				oleft -= todo;
> +				do {
> +					*dst32++ = readl_relaxed(ss->base +
> +								SS_TXFIFO);
> +					todo--;
> +				} while (todo > 0);
> +			}
> +			tmp = readl_relaxed(ss->base + SS_FCSR);
> +			rx_cnt = SS_RXFIFO_SPACES(tmp);
> +			tx_cnt = SS_TXFIFO_SPACES(tmp);
> +		} while (oleft > 0);
> +		writel(0, ss->base + SS_CTL);
> +		mutex_unlock(&ss->lock);
> +		kunmap_atomic(src_addr);
> +		kunmap_atomic(dst_addr);
> +		return 0;
> +	}
> +
> +	/* If we have more than one SG, we cannot use kmap_atomic since
> +	 * we hold the mapping too long*/

Wrong comment style.

btw. can't you use generic scatterwalk here ?

> +	src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
> +	if (src_addr == NULL) {
> +		dev_err(ss->dev, "KMAP error for src SG\n");
> +		return -1;
> +	}

Why can't you just use dma_map_sg() or somesuch ?

[...]
> +EXPORT_SYMBOL_GPL(sunxi_aes_poll);

Again, don't export the symbol please.

[...]
> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher.h
> b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.h new file mode 100644
> index 0000000..ecfbf9c
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.h
> @@ -0,0 +1,8 @@
> +#include "sunxi-ss.h"
> +
> +extern struct sunxi_ss_ctx *ss;

Right. Please make it into one module and you won't need all this horror.
[...]
