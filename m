Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbaGYLkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:40:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55290 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751701AbaGYLkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:40:08 -0400
Date: Fri, 25 Jul 2014 13:36:37 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 3/3] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20140725113637.GB20328@lukather>
References: <1405169953-13695-1-git-send-email-clabbe.montjoie@gmail.com>
 <1405169953-13695-4-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d2IMS6fuC0p5eWIP"
Content-Disposition: inline
In-Reply-To: <1405169953-13695-4-git-send-email-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d2IMS6fuC0p5eWIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 12, 2014 at 02:59:13PM +0200, LABBE Corentin wrote:
> Add support for the Security System included in Allwinner SoC A20.
> The Security System is a hardware cryptographic accelerator that support =
AES/MD5/SHA1/DES/3DES/PRNG algorithms.
>=20
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/Kconfig                    |  17 ++
>  drivers/crypto/Makefile                   |   1 +
>  drivers/crypto/sunxi-ss/Makefile          |   2 +
>  drivers/crypto/sunxi-ss/sunxi-ss-cipher.c | 461 ++++++++++++++++++++++++=
++++++
>  drivers/crypto/sunxi-ss/sunxi-ss-core.c   | 308 ++++++++++++++++++++
>  drivers/crypto/sunxi-ss/sunxi-ss-hash.c   | 241 ++++++++++++++++
>  drivers/crypto/sunxi-ss/sunxi-ss.h        | 183 ++++++++++++
>  7 files changed, 1213 insertions(+)
>  create mode 100644 drivers/crypto/sunxi-ss/Makefile
>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-core.c
>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash.c
>  create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss.h
>=20
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 03ccdb0..a2acda4 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -418,4 +418,21 @@ config CRYPTO_DEV_MXS_DCP
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called mxs-dcp.
> =20
> +config CRYPTO_DEV_SUNXI_SS
> +	tristate "Support for Allwinner Security System cryptographic accelerat=
or"
> +	depends on ARCH_SUNXI
> +	select CRYPTO_MD5
> +	select CRYPTO_SHA1
> +	select CRYPTO_AES
> +	select CRYPTO_DES
> +	select CRYPTO_BLKCIPHER
> +	help
> +	  Some Allwinner SoC have a crypto accelerator named
> +	  Security System. Select this if you want to use it.
> +	  The Security System handle AES/DES/3DES ciphers in CBC mode
> +	  and SHA1 and MD5 hash algorithms.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called sunxi-ss.
> +
>  endif # CRYPTO_HW
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 482f090..855292a 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -23,3 +23,4 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) +=3D s5p-sss.o
>  obj-$(CONFIG_CRYPTO_DEV_SAHARA) +=3D sahara.o
>  obj-$(CONFIG_CRYPTO_DEV_TALITOS) +=3D talitos.o
>  obj-$(CONFIG_CRYPTO_DEV_UX500) +=3D ux500/
> +obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS) +=3D sunxi-ss/
> diff --git a/drivers/crypto/sunxi-ss/Makefile b/drivers/crypto/sunxi-ss/M=
akefile
> new file mode 100644
> index 0000000..8bb287d
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS) +=3D sunxi-ss.o
> +sunxi-ss-y +=3D sunxi-ss-core.o sunxi-ss-hash.o sunxi-ss-cipher.o
> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c b/drivers/crypto/s=
unxi-ss/sunxi-ss-cipher.c
> new file mode 100644
> index 0000000..c2422f7
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
> @@ -0,0 +1,461 @@
> +/*
> + * sunxi-ss-cipher.c - hardware cryptographic accelerator for Allwinner =
A20 SoC
> + *
> + * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
> + *
> + * This file add support for AES cipher with 128,192,256 bits
> + * keysize in CBC mode.
> + *
> + * You could find the datasheet at
> + * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf

It's already documented in Documentation/arm/sunxi/README, you don't
need this.

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include "sunxi-ss.h"
> +
> +extern struct sunxi_ss_ctx *ss;
> +
> +static int sunxi_ss_cipher(struct ablkcipher_request *areq, u32 mode)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
> +	const char *cipher_type;
> +
> +	cipher_type =3D crypto_tfm_alg_name(crypto_ablkcipher_tfm(tfm));
> +
> +	if (areq->nbytes =3D=3D 0) {
> +		mutex_unlock(&ss->lock);
> +		return 0;
> +	}
> +
> +	if (areq->info =3D=3D NULL) {
> +		dev_err(ss->dev, "ERROR: Empty IV\n");
> +		mutex_unlock(&ss->lock);
> +		return -EINVAL;
> +	}
> +
> +	if (areq->src =3D=3D NULL || areq->dst =3D=3D NULL) {
> +		dev_err(ss->dev, "ERROR: Some SGs are NULL\n");
> +		mutex_unlock(&ss->lock);
> +		return -EINVAL;
> +	}
> +
> +	if (strcmp("cbc(aes)", cipher_type) =3D=3D 0) {
> +		op->mode |=3D SS_OP_AES | SS_CBC | SS_ENABLED | mode;
> +		return sunxi_ss_aes_poll(areq);
> +	}

Newline

> +	if (strcmp("cbc(des)", cipher_type) =3D=3D 0) {
> +		op->mode =3D SS_OP_DES | SS_CBC | SS_ENABLED | mode;
> +		return sunxi_ss_des_poll(areq);
> +	}

Ditto.

> +	if (strcmp("cbc(des3_ede)", cipher_type) =3D=3D 0) {
> +		op->mode =3D SS_OP_3DES | SS_CBC | SS_ENABLED | mode;
> +		return sunxi_ss_des_poll(areq);
> +	}

Ditto.

> +	dev_err(ss->dev, "ERROR: Cipher %s not handled\n", cipher_type);
> +	mutex_unlock(&ss->lock);
> +	return -EINVAL;

You could avoid much of this code duplication with gotos.

> +}
> +
> +int sunxi_ss_cipher_encrypt(struct ablkcipher_request *areq)
> +{
> +	return sunxi_ss_cipher(areq, SS_ENCRYPTION);
> +}
> +
> +int sunxi_ss_cipher_decrypt(struct ablkcipher_request *areq)
> +{
> +	return sunxi_ss_cipher(areq, SS_DECRYPTION);
> +}
> +
> +int sunxi_ss_cipher_init(struct crypto_tfm *tfm)
> +{
> +	struct sunxi_req_ctx *op =3D crypto_tfm_ctx(tfm);
> +
> +	mutex_lock(&ss->lock);
> +
> +	memset(op, 0, sizeof(struct sunxi_req_ctx));

And you never unlock the mutex? And where is this ss coming from?

> +	return 0;
> +}
> +
> +int sunxi_ss_aes_poll(struct ablkcipher_request *areq)
> +{
> +	u32 spaces;
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
> +	unsigned int ivsize =3D crypto_ablkcipher_ivsize(tfm);
> +	/* when activating SS, the default FIFO space is 32 */
> +	u32 rx_cnt =3D 32;
> +	u32 tx_cnt =3D 0;
> +	u32 v;
> +	int i;
> +	struct scatterlist *in_sg;
> +	struct scatterlist *out_sg;
> +	void *src_addr;
> +	void *dst_addr;
> +	unsigned int ileft =3D areq->nbytes;
> +	unsigned int oleft =3D areq->nbytes;
> +	unsigned int sgileft =3D areq->src->length;
> +	unsigned int sgoleft =3D areq->dst->length;
> +	unsigned int todo;
> +	u32 *src32;
> +	u32 *dst32;
> +
> +	in_sg =3D areq->src;
> +	out_sg =3D areq->dst;
> +	for (i =3D 0; i < op->keylen; i +=3D 4)
> +		writel(*(op->key + i/4), ss->base + SS_KEY0 + i);

Newline

> +	if (areq->info !=3D NULL) {
> +		for (i =3D 0; i < 4 && i < ivsize / 4; i++) {
> +			v =3D *(u32 *)(areq->info + i * 4);
> +			writel(v, ss->base + SS_IV0 + i * 4);
> +		}
> +	}
> +	writel(op->mode, ss->base + SS_CTL);
> +
> +	/* If we have only one SG, we can use kmap_atomic */
> +	if (sg_next(in_sg) =3D=3D NULL && sg_next(out_sg) =3D=3D NULL) {
> +		src_addr =3D kmap_atomic(sg_page(in_sg)) + in_sg->offset;
> +		if (src_addr =3D=3D NULL) {
> +			dev_err(ss->dev, "kmap_atomic error for src SG\n");
> +			writel(0, ss->base + SS_CTL);
> +			mutex_unlock(&ss->lock);
> +			return -EINVAL;
> +		}

Newline...

You get the idea, please go over your driver to catch all of them.

> +		dst_addr =3D kmap_atomic(sg_page(out_sg)) + out_sg->offset;
> +		if (dst_addr =3D=3D NULL) {
> +			dev_err(ss->dev, "kmap_atomic error for dst SG\n");
> +			writel(0, ss->base + SS_CTL);
> +			kunmap_atomic(src_addr);
> +			mutex_unlock(&ss->lock);
> +			return -EINVAL;
> +		}
> +		src32 =3D (u32 *)src_addr;
> +		dst32 =3D (u32 *)dst_addr;
> +		ileft =3D areq->nbytes / 4;
> +		oleft =3D areq->nbytes / 4;
> +		i =3D 0;
> +		do {
> +			if (ileft > 0 && rx_cnt > 0) {
> +				todo =3D min(rx_cnt, ileft);
> +				ileft -=3D todo;
> +				do {
> +					writel_relaxed(*src32++,
> +						       ss->base +
> +						       SS_RXFIFO);
> +					todo--;
> +				} while (todo > 0);
> +			}
> +			if (tx_cnt > 0) {
> +				todo =3D min(tx_cnt, oleft);
> +				oleft -=3D todo;
> +				do {
> +					*dst32++ =3D readl_relaxed(ss->base +
> +								SS_TXFIFO);
> +					todo--;
> +				} while (todo > 0);
> +			}
> +			spaces =3D readl_relaxed(ss->base + SS_FCSR);
> +			rx_cnt =3D SS_RXFIFO_SPACES(spaces);
> +			tx_cnt =3D SS_TXFIFO_SPACES(spaces);
> +		} while (oleft > 0);
> +		writel(0, ss->base + SS_CTL);
> +		kunmap_atomic(src_addr);
> +		kunmap_atomic(dst_addr);
> +		mutex_unlock(&ss->lock);

Again, gotos here would be nice=20

> +		return 0;
> +	}

So you just have to huge
if (sg_num =3D=3D 1)
    do_something
else
    do_something_else

right?

Can't you turn those two in separate functions, the number of
imbricated test cases is quite huge and not really readable.

> +	/* If we have more than one SG, we cannot use kmap_atomic since
> +	 * we hold the mapping too long
> +	 */

This is not the proper way of definining multi-lines comments. Please
read CodingStyle, and fix all of them in your driver.

> +	src_addr =3D kmap(sg_page(in_sg)) + in_sg->offset;
> +	if (src_addr =3D=3D NULL) {
> +		dev_err(ss->dev, "KMAP error for src SG\n");
> +		mutex_unlock(&ss->lock);
> +		return -EINVAL;
> +	}
> +	dst_addr =3D kmap(sg_page(out_sg)) + out_sg->offset;
> +	if (dst_addr =3D=3D NULL) {
> +		kunmap(sg_page(in_sg));
> +		dev_err(ss->dev, "KMAP error for dst SG\n");
> +		mutex_unlock(&ss->lock);
> +		return -EINVAL;
> +	}
> +	src32 =3D (u32 *)src_addr;
> +	dst32 =3D (u32 *)dst_addr;
> +	ileft =3D areq->nbytes / 4;
> +	oleft =3D areq->nbytes / 4;
> +	sgileft =3D in_sg->length / 4;
> +	sgoleft =3D out_sg->length / 4;
> +	do {
> +		spaces =3D readl_relaxed(ss->base + SS_FCSR);
> +		rx_cnt =3D SS_RXFIFO_SPACES(spaces);
> +		tx_cnt =3D SS_TXFIFO_SPACES(spaces);
> +		todo =3D min3(rx_cnt, ileft, sgileft);
> +		if (todo > 0) {
> +			ileft -=3D todo;
> +			sgileft -=3D todo;
> +		}
> +		while (todo > 0) {
> +			writel_relaxed(*src32++, ss->base + SS_RXFIFO);
> +			todo--;
> +		}
> +		if (in_sg !=3D NULL && sgileft =3D=3D 0 && ileft > 0) {
> +			kunmap(sg_page(in_sg));
> +			in_sg =3D sg_next(in_sg);
> +			while (in_sg !=3D NULL && in_sg->length =3D=3D 0)
> +				in_sg =3D sg_next(in_sg);
> +			if (in_sg !=3D NULL && ileft > 0) {
> +				src_addr =3D kmap(sg_page(in_sg)) + in_sg->offset;
> +				if (src_addr =3D=3D NULL) {
> +					dev_err(ss->dev, "ERROR: KMAP for src SG\n");
> +					mutex_unlock(&ss->lock);
> +					return -EINVAL;
> +				}
> +				src32 =3D src_addr;
> +				sgileft =3D in_sg->length / 4;
> +			}
> +		}
> +		/* do not test oleft since when oleft =3D=3D 0 we have finished */
> +		todo =3D min3(tx_cnt, oleft, sgoleft);
> +		if (todo > 0) {
> +			oleft -=3D todo;
> +			sgoleft -=3D todo;
> +		}
> +		while (todo > 0) {
> +			*dst32++ =3D readl_relaxed(ss->base + SS_TXFIFO);
> +			todo--;
> +		}
> +		if (out_sg !=3D NULL && sgoleft =3D=3D 0 && oleft >=3D 0) {
> +			kunmap(sg_page(out_sg));
> +			out_sg =3D sg_next(out_sg);
> +			while (out_sg !=3D NULL && out_sg->length =3D=3D 0)
> +				out_sg =3D sg_next(out_sg);
> +			if (out_sg !=3D NULL && oleft > 0) {
> +				dst_addr =3D kmap(sg_page(out_sg)) +
> +					out_sg->offset;
> +				if (dst_addr =3D=3D NULL) {
> +					dev_err(ss->dev, "KMAP error\n");
> +					mutex_unlock(&ss->lock);
> +					return -EINVAL;
> +				}
> +				dst32 =3D dst_addr;
> +				sgoleft =3D out_sg->length / 4;
> +			}
> +		}
> +	} while (oleft > 0);
> +
> +	writel(0, ss->base + SS_CTL);
> +	mutex_unlock(&ss->lock);
> +	return 0;

Yep, splitting this into a few functions, and adding some comments
would definitely help.

> +}
> +
> +/* Pure CPU way of doing DES/3DES with SS
> + * Since DES and 3DES SGs could be smaller than 4 bytes, I use sg_copy_t=
o_buffer
> + * for "linearize" them.
> + * The problem with that is that I alloc (2 x areq->nbytes) for buf_in/b=
uf_out
> + * TODO: change this system

Change this system for what?

> + * SGsrc -> buf_in -> SS -> buf_out -> SGdst */
> +int sunxi_ss_des_poll(struct ablkcipher_request *areq)
> +{
> +	u32 value, spaces;
> +	size_t nb_in_sg_tx, nb_in_sg_rx;
> +	size_t ir, it;
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
> +	unsigned int ivsize =3D crypto_ablkcipher_ivsize(tfm);
> +	u32 tx_cnt =3D 0;
> +	u32 rx_cnt =3D 0;
> +	u32 v;
> +	int i;
> +	int no_chunk =3D 1;
> +
> +	/* if we have only SGs with size multiple of 4,
> +	 * we can use the SS AES function */
> +	struct scatterlist *in_sg;
> +	struct scatterlist *out_sg;
> +
> +	in_sg =3D areq->src;
> +	out_sg =3D areq->dst;
> +
> +	while (in_sg !=3D NULL && no_chunk =3D=3D 1) {
> +		if ((in_sg->length % 4) !=3D 0)
> +			no_chunk =3D 0;
> +		in_sg =3D sg_next(in_sg);
> +	}
> +	while (out_sg !=3D NULL && no_chunk =3D=3D 1) {
> +		if ((out_sg->length % 4) !=3D 0)
> +			no_chunk =3D 0;
> +		out_sg =3D sg_next(out_sg);
> +	}
> +
> +	if (no_chunk =3D=3D 1)
> +		return sunxi_ss_aes_poll(areq);
> +	in_sg =3D areq->src;
> +	out_sg =3D areq->dst;
> +
> +	nb_in_sg_rx =3D sg_nents(in_sg);
> +	nb_in_sg_tx =3D sg_nents(out_sg);
> +
> +	mutex_lock(&ss->bufin_lock);
> +	if (ss->buf_in =3D=3D NULL) {
> +		ss->buf_in =3D kmalloc(areq->nbytes, GFP_KERNEL);
> +		ss->buf_in_size =3D areq->nbytes;
> +	} else {
> +		if (areq->nbytes > ss->buf_in_size) {
> +			kfree(ss->buf_in);
> +			ss->buf_in =3D kmalloc(areq->nbytes, GFP_KERNEL);
> +			ss->buf_in_size =3D areq->nbytes;
> +		}
> +	}
> +	if (ss->buf_in =3D=3D NULL) {
> +		ss->buf_in_size =3D 0;
> +		mutex_unlock(&ss->bufin_lock);
> +		dev_err(ss->dev, "Unable to allocate pages.\n");
> +		return -ENOMEM;
> +	}
> +	if (ss->buf_out =3D=3D NULL) {
> +		mutex_lock(&ss->bufout_lock);
> +		ss->buf_out =3D kmalloc(areq->nbytes, GFP_KERNEL);
> +		if (ss->buf_out =3D=3D NULL) {
> +			ss->buf_out_size =3D 0;
> +			mutex_unlock(&ss->bufout_lock);
> +			dev_err(ss->dev, "Unable to allocate pages.\n");
> +			return -ENOMEM;
> +		}
> +		ss->buf_out_size =3D areq->nbytes;
> +		mutex_unlock(&ss->bufout_lock);
> +	} else {
> +		if (areq->nbytes > ss->buf_out_size) {
> +			mutex_lock(&ss->bufout_lock);
> +			kfree(ss->buf_out);
> +			ss->buf_out =3D kmalloc(areq->nbytes, GFP_KERNEL);

Why do you free it to reallocate it right away? I only see two cases
for this and none of them are great:
   - This buffer has been preallocated by this function, but never
     free'd before, which would mean that we leak resources.
   - This buffer has been allocated by another function, which makes
     the tracking of the allocation/deallocation quite hard to do,
     which means that we will end up leaking memory.

> +			if (ss->buf_out =3D=3D NULL) {
> +				ss->buf_out_size =3D 0;
> +				mutex_unlock(&ss->bufout_lock);
> +				dev_err(ss->dev, "Unable to allocate pages.\n");
> +				return -ENOMEM;
> +			}
> +			ss->buf_out_size =3D areq->nbytes;
> +			mutex_unlock(&ss->bufout_lock);
> +		}
> +	}
> +
> +	sg_copy_to_buffer(areq->src, nb_in_sg_rx, ss->buf_in, areq->nbytes);
> +
> +	ir =3D 0;
> +	it =3D 0;
> +
> +	for (i =3D 0; i < op->keylen; i +=3D 4)
> +		writel(*(op->key + i/4), ss->base + SS_KEY0 + i);
> +	if (areq->info !=3D NULL) {
> +		for (i =3D 0; i < 4 && i < ivsize / 4; i++) {
> +			v =3D *(u32 *)(areq->info + i * 4);
> +			writel(v, ss->base + SS_IV0 + i * 4);
> +		}
> +	}
> +	writel(op->mode, ss->base + SS_CTL);
> +
> +	do {
> +		if (rx_cnt =3D=3D 0 || tx_cnt =3D=3D 0) {
> +			spaces =3D readl(ss->base + SS_FCSR);
> +			rx_cnt =3D SS_RXFIFO_SPACES(spaces);
> +			tx_cnt =3D SS_TXFIFO_SPACES(spaces);
> +		}
> +		if (rx_cnt > 0 && ir < areq->nbytes) {
> +			do {
> +				value =3D *(u32 *)(ss->buf_in + ir);
> +				writel(value, ss->base + SS_RXFIFO);
> +				ir +=3D 4;
> +				rx_cnt--;
> +			} while (rx_cnt > 0 && ir < areq->nbytes);
> +		}
> +		if (tx_cnt > 0 && it < areq->nbytes) {
> +			do {
> +				value =3D readl(ss->base + SS_TXFIFO);
> +				*(u32 *)(ss->buf_out + it) =3D value;
> +				it +=3D 4;
> +				tx_cnt--;
> +			} while (tx_cnt > 0 && it < areq->nbytes);
> +		}
> +		if (ir =3D=3D areq->nbytes) {
> +			mutex_unlock(&ss->bufin_lock);
> +			ir++;
> +		}
> +	} while (it < areq->nbytes);
> +
> +	writel(0, ss->base + SS_CTL);
> +	mutex_unlock(&ss->lock);
> +
> +	/* a simple optimization, since we dont need the hardware for this copy
> +	 * we release the lock and do the copy. With that we gain 5/10% perf */
> +	mutex_lock(&ss->bufout_lock);
> +	sg_copy_from_buffer(areq->dst, nb_in_sg_tx, ss->buf_out, areq->nbytes);
> +
> +	mutex_unlock(&ss->bufout_lock);
> +	return 0;
> +}
> +
> +/* check and set the AES key, prepare the mode to be used */
> +int sunxi_ss_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
> +		unsigned int keylen)
> +{
> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
> +
> +	switch (keylen) {
> +	case 128 / 8:
> +		op->mode =3D SS_AES_128BITS;
> +		break;
> +	case 192 / 8:
> +		op->mode =3D SS_AES_192BITS;
> +		break;
> +	case 256 / 8:
> +		op->mode =3D SS_AES_256BITS;
> +		break;
> +	default:
> +		dev_err(ss->dev, "ERROR: Invalid keylen %u\n", keylen);
> +		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		mutex_unlock(&ss->lock);

Who takes this lock?

> +		return -EINVAL;
> +	}
> +	op->keylen =3D keylen;
> +	memcpy(op->key, key, keylen);
> +	return 0;
> +}
> +
> +/* check and set the DES key, prepare the mode to be used */
> +int sunxi_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
> +		unsigned int keylen)
> +{
> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
> +
> +	if (keylen !=3D DES_KEY_SIZE) {
> +		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
> +		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		mutex_unlock(&ss->lock);

Ditto

> +		return -EINVAL;
> +	}
> +	op->keylen =3D keylen;
> +	memcpy(op->key, key, keylen);
> +	return 0;
> +}
> +
> +/* check and set the 3DES key, prepare the mode to be used */
> +int sunxi_ss_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
> +		unsigned int keylen)
> +{
> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
> +
> +	if (keylen !=3D 3 * DES_KEY_SIZE) {
> +		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
> +		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		mutex_unlock(&ss->lock);
> +		return -EINVAL;
> +	}
> +	op->keylen =3D keylen;
> +	memcpy(op->key, key, keylen);
> +	return 0;
> +}
> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-core.c b/drivers/crypto/sun=
xi-ss/sunxi-ss-core.c
> new file mode 100644
> index 0000000..c76016e
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-core.c
> @@ -0,0 +1,308 @@
> +/*
> + * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
> + *
> + * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
> + *
> + * Core file which registers crypto algorithms supported by the SS.
> + *
> + * You could find the datasheet at
> + * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/clk.h>
> +#include <linux/crypto.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/scatterlist.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +
> +#include "sunxi-ss.h"
> +
> +struct sunxi_ss_ctx *ss;
> +
> +/* General notes:
> + * I cannot use a key/IV cache because each time one of these change ALL=
 stuff
> + * need to be re-writed (rewrite SS_KEYX ans SS_IVX).
> + * And for example, with dm-crypt IV changes on each request.
> + *
> + * After each request the device must be disabled with a write of 0 in S=
S_CTL
> + *
> + * For performance reason, we use writel_relaxed/read_relaxed for all
> + * operations on RX and TX FIFO and also SS_FCSR.
> + * For all other registers, we use writel/readl.
> + * See http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117644
> + * and http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117640
> + * */
> +
> +static struct ahash_alg sunxi_md5_alg =3D {
> +	.init =3D sunxi_hash_init,
> +	.update =3D sunxi_hash_update,
> +	.final =3D sunxi_hash_final,
> +	.finup =3D sunxi_hash_finup,
> +	.digest =3D sunxi_hash_digest,
> +	.halg =3D {
> +		.digestsize =3D MD5_DIGEST_SIZE,
> +		.base =3D {
> +			.cra_name =3D "md5",
> +			.cra_driver_name =3D "md5-sunxi-ss",
> +			.cra_priority =3D 300,
> +			.cra_alignmask =3D 3,
> +			.cra_flags =3D CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
> +			.cra_blocksize =3D MD5_HMAC_BLOCK_SIZE,
> +			.cra_ctxsize =3D sizeof(struct sunxi_req_ctx),
> +			.cra_module =3D THIS_MODULE,
> +			.cra_type =3D &crypto_ahash_type
> +		}
> +	}
> +};
> +static struct ahash_alg sunxi_sha1_alg =3D {
> +	.init =3D sunxi_hash_init,
> +	.update =3D sunxi_hash_update,
> +	.final =3D sunxi_hash_final,
> +	.finup =3D sunxi_hash_finup,
> +	.digest =3D sunxi_hash_digest,
> +	.halg =3D {
> +		.digestsize =3D SHA1_DIGEST_SIZE,
> +		.base =3D {
> +			.cra_name =3D "sha1",
> +			.cra_driver_name =3D "sha1-sunxi-ss",
> +			.cra_priority =3D 300,
> +			.cra_alignmask =3D 3,
> +			.cra_flags =3D CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
> +			.cra_blocksize =3D SHA1_BLOCK_SIZE,
> +			.cra_ctxsize =3D sizeof(struct sunxi_req_ctx),
> +			.cra_module =3D THIS_MODULE,
> +			.cra_type =3D &crypto_ahash_type
> +		}
> +	}
> +};
> +
> +static struct crypto_alg sunxi_cipher_algs[] =3D {
> +{
> +	.cra_name =3D "cbc(aes)",
> +	.cra_driver_name =3D "cbc-aes-sunxi-ss",
> +	.cra_priority =3D 300,
> +	.cra_blocksize =3D AES_BLOCK_SIZE,
> +	.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> +	.cra_ctxsize =3D sizeof(struct sunxi_req_ctx),
> +	.cra_module =3D THIS_MODULE,
> +	.cra_alignmask =3D 3,
> +	.cra_type =3D &crypto_ablkcipher_type,
> +	.cra_init =3D sunxi_ss_cipher_init,
> +	.cra_u =3D {
> +		.ablkcipher =3D {
> +			.min_keysize    =3D AES_MIN_KEY_SIZE,
> +			.max_keysize    =3D AES_MAX_KEY_SIZE,
> +			.ivsize         =3D AES_BLOCK_SIZE,
> +			.setkey         =3D sunxi_ss_aes_setkey,
> +			.encrypt        =3D sunxi_ss_cipher_encrypt,
> +			.decrypt        =3D sunxi_ss_cipher_decrypt,
> +		}
> +	}
> +}, {
> +	.cra_name =3D "cbc(des)",
> +	.cra_driver_name =3D "cbc-des-sunxi-ss",
> +	.cra_priority =3D 300,
> +	.cra_blocksize =3D DES_BLOCK_SIZE,
> +	.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> +	.cra_ctxsize =3D sizeof(struct sunxi_req_ctx),
> +	.cra_module =3D THIS_MODULE,
> +	.cra_alignmask =3D 3,
> +	.cra_type =3D &crypto_ablkcipher_type,
> +	.cra_init =3D sunxi_ss_cipher_init,
> +	.cra_u.ablkcipher =3D {
> +		.min_keysize    =3D DES_KEY_SIZE,
> +		.max_keysize    =3D DES_KEY_SIZE,
> +		.ivsize         =3D DES_BLOCK_SIZE,
> +		.setkey         =3D sunxi_ss_des_setkey,
> +		.encrypt        =3D sunxi_ss_cipher_encrypt,
> +		.decrypt        =3D sunxi_ss_cipher_decrypt,
> +	}
> +}, {
> +	.cra_name =3D "cbc(des3_ede)",
> +	.cra_driver_name =3D "cbc-des3-sunxi-ss",
> +	.cra_priority =3D 300,
> +	.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
> +	.cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> +	.cra_ctxsize =3D sizeof(struct sunxi_req_ctx),
> +	.cra_module =3D THIS_MODULE,
> +	.cra_alignmask =3D 3,
> +	.cra_type =3D &crypto_ablkcipher_type,
> +	.cra_init =3D sunxi_ss_cipher_init,
> +	.cra_u.ablkcipher =3D {
> +		.min_keysize    =3D DES3_EDE_KEY_SIZE,
> +		.max_keysize    =3D DES3_EDE_KEY_SIZE,
> +		.ivsize         =3D DES3_EDE_BLOCK_SIZE,
> +		.setkey         =3D sunxi_ss_des3_setkey,
> +		.encrypt        =3D sunxi_ss_cipher_encrypt,
> +		.decrypt        =3D sunxi_ss_cipher_decrypt,
> +	}
> +}
> +};
> +
> +static int sunxi_ss_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	u32 v;
> +	int err;
> +	unsigned long cr;
> +	const unsigned long cr_ahb =3D 24 * 1000 * 1000;
> +	const unsigned long cr_mod =3D 150 * 1000 * 1000;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;
> +
> +	ss =3D devm_kzalloc(&pdev->dev, sizeof(*ss), GFP_KERNEL);
> +	if (ss =3D=3D NULL)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ss->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(ss->base)) {
> +		dev_err(&pdev->dev, "Cannot request MMIO\n");
> +		return PTR_ERR(ss->base);
> +	}
> +
> +	ss->ssclk =3D devm_clk_get(&pdev->dev, "mod");
> +	if (IS_ERR(ss->ssclk)) {
> +		err =3D PTR_ERR(ss->ssclk);
> +		dev_err(&pdev->dev, "Cannot get SS clock err=3D%d\n", err);
> +		return err;
> +	}
> +	dev_dbg(&pdev->dev, "clock ss acquired\n");
> +
> +	ss->busclk =3D devm_clk_get(&pdev->dev, "ahb");
> +	if (IS_ERR(ss->busclk)) {
> +		err =3D PTR_ERR(ss->busclk);
> +		dev_err(&pdev->dev, "Cannot get AHB SS clock err=3D%d\n", err);
> +		return err;
> +	}
> +	dev_dbg(&pdev->dev, "clock ahb_ss acquired\n");
> +
> +	/* Enable the clocks */
> +	err =3D clk_prepare_enable(ss->busclk);
> +	if (err !=3D 0) {
> +		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
> +		return err;
> +	}
> +	err =3D clk_prepare_enable(ss->ssclk);
> +	if (err !=3D 0) {
> +		dev_err(&pdev->dev, "Cannot prepare_enable ssclk\n");
> +		clk_disable_unprepare(ss->busclk);
> +		return err;
> +	}
> +
> +	/* Check that clock have the correct rates gived in the datasheet */
> +	/* Try to set the clock to the maximum allowed */
> +	err =3D clk_set_rate(ss->ssclk, cr_mod);
> +	if (err !=3D 0) {
> +		dev_err(&pdev->dev, "Cannot set clock rate to ssclk\n");
> +		clk_disable_unprepare(ss->ssclk);
> +		clk_disable_unprepare(ss->busclk);
> +		return err;
> +	}
> +	cr =3D clk_get_rate(ss->busclk);
> +	if (cr >=3D cr_ahb)
> +		dev_dbg(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >=3D %lu)\n",
> +				cr, cr / 1000000, cr_ahb);
> +	else
> +		dev_warn(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >=3D %lu)\n",
> +				cr, cr / 1000000, cr_ahb);

Why do you need such a check?

> +	cr =3D clk_get_rate(ss->ssclk);
> +	if (cr =3D=3D cr_mod)
> +		dev_dbg(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <=3D %lu)\n",
> +				cr, cr / 1000000, cr_mod);
> +	else {
> +		dev_warn(&pdev->dev, "Clock ss is at %lu (%lu MHz) (must be <=3D %lu)\=
n",
> +				cr, cr / 1000000, cr_mod);
> +	}

Ditto, you just changed the rate here. Why are you double-checking?

> +	/* TODO Does this information could be usefull ? */

I don't know, what is it? :)

> +	writel(SS_ENABLED, ss->base + SS_CTL);
> +	v =3D readl(ss->base + SS_CTL);
> +	v >>=3D 16;
> +	v &=3D 0x07;
> +	dev_info(&pdev->dev, "Die ID %d\n", v);
> +	writel(0, ss->base + SS_CTL);
> +
> +	ss->dev =3D &pdev->dev;
> +
> +	mutex_init(&ss->lock);
> +	mutex_init(&ss->bufin_lock);
> +	mutex_init(&ss->bufout_lock);
> +
> +	err =3D crypto_register_ahash(&sunxi_md5_alg);
> +	if (err)
> +		goto error_md5;
> +	err =3D crypto_register_ahash(&sunxi_sha1_alg);
> +	if (err)
> +		goto error_sha1;
> +	err =3D crypto_register_algs(sunxi_cipher_algs,
> +			ARRAY_SIZE(sunxi_cipher_algs));
> +	if (err)
> +		goto error_ciphers;
> +
> +	return 0;
> +error_ciphers:
> +	crypto_unregister_ahash(&sunxi_sha1_alg);
> +error_sha1:
> +	crypto_unregister_ahash(&sunxi_md5_alg);
> +error_md5:
> +	clk_disable_unprepare(ss->ssclk);
> +	clk_disable_unprepare(ss->busclk);
> +	return err;
> +}
> +
> +static int __exit sunxi_ss_remove(struct platform_device *pdev)
> +{
> +	if (!pdev->dev.of_node)
> +		return 0;
> +
> +	crypto_unregister_ahash(&sunxi_md5_alg);
> +	crypto_unregister_ahash(&sunxi_sha1_alg);
> +	crypto_unregister_algs(sunxi_cipher_algs,
> +			ARRAY_SIZE(sunxi_cipher_algs));
> +
> +	if (ss->buf_in !=3D NULL)
> +		kfree(ss->buf_in);
> +	if (ss->buf_out !=3D NULL)
> +		kfree(ss->buf_out);
> +
> +	writel(0, ss->base + SS_CTL);
> +	clk_disable_unprepare(ss->busclk);
> +	clk_disable_unprepare(ss->ssclk);
> +	return 0;
> +}
> +
> +/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D*/
> +/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D*/

Drope these two lines

> +static const struct of_device_id a20ss_crypto_of_match_table[] =3D {
> +	{ .compatible =3D "allwinner,sun7i-a20-crypto" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
> +
> +static struct platform_driver sunxi_ss_driver =3D {
> +	.probe          =3D sunxi_ss_probe,
> +	.remove         =3D __exit_p(sunxi_ss_remove),
> +	.driver         =3D {
> +		.owner          =3D THIS_MODULE,
> +		.name           =3D "sunxi-ss",
> +		.of_match_table	=3D a20ss_crypto_of_match_table,
> +	},
> +};
> +
> +module_platform_driver(sunxi_ss_driver);
> +
> +MODULE_DESCRIPTION("Allwinner Security System cryptographic accelerator"=
);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-hash.c b/drivers/crypto/sun=
xi-ss/sunxi-ss-hash.c
> new file mode 100644
> index 0000000..6412bfb
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-hash.c
> @@ -0,0 +1,241 @@
> +/*
> + * sunxi-ss-hash.c - hardware cryptographic accelerator for Allwinner A2=
0 SoC
> + *
> + * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
> + *
> + * This file add support for MD5 and SHA1.
> + *
> + * You could find the datasheet at
> + * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include "sunxi-ss.h"
> +
> +extern struct sunxi_ss_ctx *ss;
> +
> +/* sunxi_hash_init: initialize request context
> + * Activate the SS, and configure it for MD5 or SHA1
> + */
> +int sunxi_hash_init(struct ahash_request *areq)
> +{
> +	const char *hash_type;
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
> +	struct sunxi_req_ctx *op =3D crypto_ahash_ctx(tfm);
> +
> +	mutex_lock(&ss->lock);
> +
> +	hash_type =3D crypto_tfm_alg_name(areq->base.tfm);
> +
> +	op->byte_count =3D 0;
> +	op->nbwait =3D 0;
> +	op->waitbuf =3D 0;
> +
> +	/* Enable and configure SS for MD5 or SHA1 */
> +	if (strcmp(hash_type, "sha1") =3D=3D 0)
> +		op->mode =3D SS_OP_SHA1;
> +	else
> +		op->mode =3D SS_OP_MD5;
> +
> +	writel(op->mode | SS_ENABLED, ss->base + SS_CTL);
> +	return 0;
> +}
> +
> +/*
> + * sunxi_hash_update: update hash engine
> + *
> + * Could be used for both SHA1 and MD5
> + * Write data by step of 32bits and put then in the SS.
> + * The remaining data is stored (nbwait bytes) in op->waitbuf
> + * As an optimisation, we do not check RXFIFO_SPACES, since SS handle
> + * the FIFO faster than our writes
> + */
> +int sunxi_hash_update(struct ahash_request *areq)
> +{
> +	u32 v;
> +	unsigned int i =3D 0;/* bytes read, to be compared to areq->nbytes */
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
> +	struct sunxi_req_ctx *op =3D crypto_ahash_ctx(tfm);
> +	struct scatterlist *in_sg;
> +	unsigned int in_i =3D 0;/* advancement in the current SG */
> +	void *src_addr;
> +
> +	u8 *waitbuf =3D (u8 *)(&op->waitbuf);
> +
> +	if (areq->nbytes =3D=3D 0)
> +		return 0;
> +
> +	in_sg =3D areq->src;
> +	do {
> +		src_addr =3D kmap(sg_page(in_sg)) + in_sg->offset;
> +		/* step 1, if some bytes remains from last SG,
> +		 * try to complete them to 4 and sent its */
> +		if (op->nbwait > 0) {
> +			while (op->nbwait < 4 && i < areq->nbytes &&
> +					in_i < in_sg->length) {
> +				waitbuf[op->nbwait] =3D *(u8 *)(src_addr + in_i);
> +				i++;
> +				in_i++;
> +				op->nbwait++;
> +			}
> +			if (op->nbwait =3D=3D 4) {
> +				writel(op->waitbuf, ss->base + SS_RXFIFO);
> +				op->byte_count +=3D 4;
> +				op->nbwait =3D 0;
> +				op->waitbuf =3D 0;
> +			}
> +		}
> +		/* step 2, main loop, read data 4bytes at a time */
> +		while (i < areq->nbytes && areq->nbytes - i >=3D 4 &&
> +				in_i < in_sg->length &&
> +				in_sg->length - in_i >=3D 4) {
> +			v =3D *(u32 *)(src_addr + in_i);
> +			writel_relaxed(v, ss->base + SS_RXFIFO);
> +			i +=3D 4;
> +			op->byte_count +=3D 4;
> +			in_i +=3D 4;
> +		}
> +		/* step 3, if we have less than 4 bytes, copy them in waitbuf
> +		 * no need to check for op->nbwait < 4 since we cannot have
> +		 * more than 4 bytes remaining */
> +		if (in_i < in_sg->length && in_sg->length - in_i < 4 &&
> +				i < areq->nbytes) {
> +			do {
> +				waitbuf[op->nbwait] =3D *(u8 *)(src_addr + in_i);
> +				op->nbwait++;
> +				in_i++;
> +				i++;
> +			} while (in_i < in_sg->length && i < areq->nbytes);
> +		}
> +		/* we have finished the current SG, try next one */
> +		kunmap(sg_page(in_sg));
> +		in_sg =3D sg_next(in_sg);
> +		in_i =3D 0;
> +	} while (in_sg !=3D NULL && i < areq->nbytes);
> +	return 0;
> +}
> +
> +/*
> + * sunxi_hash_final: finalize hashing operation
> + *
> + * If we have some remaining bytes, send it.
> + * Then ask the SS for finalizing the hash
> + */
> +int sunxi_hash_final(struct ahash_request *areq)
> +{
> +	u32 v;
> +	unsigned int i;
> +	int zeros;
> +	unsigned int index, padlen;
> +	__be64 bits;
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
> +	struct sunxi_req_ctx *op =3D crypto_ahash_ctx(tfm);
> +
> +	if (op->nbwait > 0) {
> +		op->waitbuf |=3D ((1 << 7) << (op->nbwait * 8));
> +		writel(op->waitbuf, ss->base + SS_RXFIFO);
> +	} else {
> +		writel((1 << 7), ss->base + SS_RXFIFO);
> +	}
> +
> +	/* number of space to pad to obtain 64o minus 8(size) minus 4 (final 1)
> +	 * example len=3D0
> +	 * example len=3D56
> +	 * */
> +
> +	/* we have already send 4 more byte of which nbwait data */
> +	if (op->mode =3D=3D SS_OP_MD5) {
> +		index =3D (op->byte_count + 4) & 0x3f;
> +		op->byte_count +=3D op->nbwait;
> +		if (index > 56)
> +			zeros =3D (120 - index) / 4;
> +		else
> +			zeros =3D (56 - index) / 4;
> +	} else {
> +		op->byte_count +=3D op->nbwait;
> +		index =3D op->byte_count & 0x3f;
> +		padlen =3D (index < 56) ? (56 - index) : ((64+56) - index);
> +		zeros =3D (padlen - 1) / 4;
> +	}
> +	for (i =3D 0; i < zeros; i++)
> +		writel(0, ss->base + SS_RXFIFO);
> +
> +	/* write the lenght */
> +	if (op->mode =3D=3D SS_OP_SHA1) {
> +		bits =3D cpu_to_be64(op->byte_count << 3);
> +		writel(bits & 0xffffffff, ss->base + SS_RXFIFO);
> +		writel((bits >> 32) & 0xffffffff, ss->base + SS_RXFIFO);
> +	} else {
> +		writel((op->byte_count << 3) & 0xffffffff,
> +				ss->base + SS_RXFIFO);
> +		writel((op->byte_count >> 29) & 0xffffffff,
> +				ss->base + SS_RXFIFO);
> +	}
> +
> +	/* stop the hashing */
> +	v =3D readl(ss->base + SS_CTL);
> +	v |=3D SS_DATA_END;
> +	writel(v, ss->base + SS_CTL);
> +
> +	/* check the end */
> +	/* The timeout could happend only in case of bad overcloking */
> +#define SS_TIMEOUT 100
> +	i =3D 0;
> +	do {
> +		v =3D readl(ss->base + SS_CTL);
> +		i++;
> +	} while (i < SS_TIMEOUT && (v & SS_DATA_END) > 0);
> +	if (i >=3D SS_TIMEOUT) {
> +		dev_err(ss->dev, "ERROR: hash end timeout %d>%d\n",
> +				i, SS_TIMEOUT);
> +		writel(0, ss->base + SS_CTL);
> +		mutex_unlock(&ss->lock);
> +		return -1;
> +	}
> +
> +	if (op->mode =3D=3D SS_OP_SHA1) {
> +		for (i =3D 0; i < 5; i++) {
> +			v =3D cpu_to_be32(readl(ss->base + SS_MD0 + i * 4));
> +			memcpy(areq->result + i * 4, &v, 4);
> +		}
> +	} else {
> +		for (i =3D 0; i < 4; i++) {
> +			v =3D readl(ss->base + SS_MD0 + i * 4);
> +			memcpy(areq->result + i * 4, &v, 4);
> +		}
> +	}
> +	writel(0, ss->base + SS_CTL);
> +	mutex_unlock(&ss->lock);
> +	return 0;
> +}
> +
> +/* sunxi_hash_finup: finalize hashing operation after an update */
> +int sunxi_hash_finup(struct ahash_request *areq)
> +{
> +	int err;
> +
> +	err =3D sunxi_hash_update(areq);
> +	if (err !=3D 0)
> +		return err;
> +
> +	return sunxi_hash_final(areq);
> +}
> +
> +/* combo of init/update/final functions */
> +int sunxi_hash_digest(struct ahash_request *areq)
> +{
> +	int err;
> +
> +	err =3D sunxi_hash_init(areq);
> +	if (err !=3D 0)
> +		return err;
> +
> +	err =3D sunxi_hash_update(areq);
> +	if (err !=3D 0)
> +		return err;
> +
> +	return sunxi_hash_final(areq);
> +}
> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss.h b/drivers/crypto/sunxi-ss=
/sunxi-ss.h
> new file mode 100644
> index 0000000..94aca20
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/sunxi-ss.h
> @@ -0,0 +1,183 @@
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
> + * Licensed under the GPL-2.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/crypto.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/scatterlist.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <crypto/md5.h>
> +#include <crypto/sha.h>
> +#include <crypto/hash.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/aes.h>
> +#include <crypto/des.h>
> +#include <crypto/internal/rng.h>
> +
> +#define SS_CTL            0x00
> +#define SS_KEY0           0x04
> +#define SS_KEY1           0x08
> +#define SS_KEY2           0x0C
> +#define SS_KEY3           0x10
> +#define SS_KEY4           0x14
> +#define SS_KEY5           0x18
> +#define SS_KEY6           0x1C
> +#define SS_KEY7           0x20
> +
> +#define SS_IV0            0x24
> +#define SS_IV1            0x28
> +#define SS_IV2            0x2C
> +#define SS_IV3            0x30
> +
> +#define SS_CNT0           0x34
> +#define SS_CNT1           0x38
> +#define SS_CNT2           0x3C
> +#define SS_CNT3           0x40
> +
> +#define SS_FCSR           0x44
> +#define SS_ICSR           0x48
> +
> +#define SS_MD0            0x4C
> +#define SS_MD1            0x50
> +#define SS_MD2            0x54
> +#define SS_MD3            0x58
> +#define SS_MD4            0x5C
> +
> +#define SS_RXFIFO         0x200
> +#define SS_TXFIFO         0x204
> +
> +/* SS_CTL configuration values */
> +
> +/* PRNG generator mode - bit 15 */
> +#define SS_PRNG_ONESHOT		(0 << 15)
> +#define SS_PRNG_CONTINUE	(1 << 15)
> +
> +/* SS operation mode - bits 12-13 */
> +#define SS_ECB			(0 << 12)
> +#define SS_CBC			(1 << 12)
> +#define SS_CNT			(2 << 12)
> +
> +/* Counter width for CNT mode - bits 10-11 */
> +#define SS_CNT_16BITS		(0 << 10)
> +#define SS_CNT_32BITS		(1 << 10)
> +#define SS_CNT_64BITS		(2 << 10)
> +
> +/* Key size for AES - bits 8-9 */
> +#define SS_AES_128BITS		(0 << 8)
> +#define SS_AES_192BITS		(1 << 8)
> +#define SS_AES_256BITS		(2 << 8)
> +
> +/* Operation direction - bit 7 */
> +#define SS_ENCRYPTION		(0 << 7)
> +#define SS_DECRYPTION		(1 << 7)
> +
> +/* SS Method - bits 4-6 */
> +#define SS_OP_AES		(0 << 4)
> +#define SS_OP_DES		(1 << 4)
> +#define SS_OP_3DES		(2 << 4)
> +#define SS_OP_SHA1		(3 << 4)
> +#define SS_OP_MD5		(4 << 4)
> +#define SS_OP_PRNG		(5 << 4)
> +
> +/* Data end bit - bit 2 */
> +#define SS_DATA_END		(1 << 2)
> +
> +/* PRNG start bit - bit 1 */
> +#define SS_PRNG_START		(1 << 1)
> +
> +/* SS Enable bit - bit 0 */
> +#define SS_DISABLED		(0 << 0)
> +#define SS_ENABLED		(1 << 0)
> +
> +/* SS_FCSR configuration values */
> +/* RX FIFO status - bit 30 */
> +#define SS_RXFIFO_FREE		(1 << 30)
> +
> +/* RX FIFO empty spaces - bits 24-29 */
> +#define SS_RXFIFO_SPACES(val)	(((val) >> 24) & 0x3f)
> +
> +/* TX FIFO status - bit 22 */
> +#define SS_TXFIFO_AVAILABLE	(1 << 22)
> +
> +/* TX FIFO available spaces - bits 16-21 */
> +#define SS_TXFIFO_SPACES(val)	(((val) >> 16) & 0x3f)
> +
> +#define SS_RXFIFO_EMP_INT_PENDING	(1 << 10)
> +#define SS_TXFIFO_AVA_INT_PENDING	(1 << 8)
> +#define SS_RXFIFO_EMP_INT_ENABLE	(1 << 2)
> +#define SS_TXFIFO_AVA_INT_ENABLE	(1 << 0)
> +
> +/* SS_ICSR configuration values */
> +#define SS_ICS_DRQ_ENABLE		(1 << 4)
> +
> +struct sunxi_ss_ctx {
> +	void __iomem *base;
> +	int irq;
> +	struct clk *busclk;
> +	struct clk *ssclk;
> +	struct device *dev;
> +	struct resource *res;
> +	void *buf_in; /* pointer to data to be uploaded to the device */
> +	size_t buf_in_size; /* size of buf_in */
> +	void *buf_out;
> +	size_t buf_out_size;
> +	struct mutex lock; /* control the use of the device */
> +	struct mutex bufout_lock; /* control the use of buf_out*/
> +	struct mutex bufin_lock; /* control the sue of buf_in*/
> +};
> +
> +struct sunxi_req_ctx {
> +	u32 key[AES_MAX_KEY_SIZE / 4];/* divided by sizeof(u32) */
> +	u32 keylen;
> +	u32 mode;
> +	u64 byte_count; /* number of bytes "uploaded" to the device */
> +	u32 waitbuf; /* a partial word waiting to be completed and
> +			uploaded to the device */
> +	/* number of bytes to be uploaded in the waitbuf word */
> +	unsigned int nbwait;
> +};
> +
> +#define SS_SEED_LEN (192/8)
> +#define SS_DATA_LEN (160/8)
> +
> +struct prng_context {
> +	u32 seed[SS_SEED_LEN/4];
> +	unsigned int slen;
> +};
> +
> +int sunxi_hash_init(struct ahash_request *areq);
> +int sunxi_hash_update(struct ahash_request *areq);
> +int sunxi_hash_final(struct ahash_request *areq);
> +int sunxi_hash_finup(struct ahash_request *areq);
> +int sunxi_hash_digest(struct ahash_request *areq);
> +
> +int sunxi_ss_aes_poll(struct ablkcipher_request *areq);
> +int sunxi_ss_des_poll(struct ablkcipher_request *areq);
> +int sunxi_ss_cipher_init(struct crypto_tfm *tfm);
> +int sunxi_ss_cipher_encrypt(struct ablkcipher_request *areq);
> +int sunxi_ss_cipher_decrypt(struct ablkcipher_request *areq);
> +int sunxi_ss_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
> +		unsigned int keylen);
> +int sunxi_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
> +		unsigned int keylen);
> +int sunxi_ss_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
> +		unsigned int keylen);
> --=20
> 1.8.5.5
>=20

Thanks for your work.

Overall, I guess it needs more work, especially on the memory
allocation/locking.

In your driver, your lock management and you memory management seems a
bit messy.

Try to stick with a symetrical pattern in your functions if possible,
like

kmalloc
mutex_lock
do_something
mutex_unlock
free

or at least create symetrical function to allocate/free the resources
you need.

So far, there's a lot of places where you just allocate, or free, or
lock or unlock, which makes it kind of hard to follow, and a very good
recipe for deadlocks/memory leaks.

Also, try to use gotos as much as possible, it will cleanup your exit
path, making your whole function much eaiser to read.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--d2IMS6fuC0p5eWIP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT0kFFAAoJEBx+YmzsjxAgOeIQAI/7uO8GxQ/1JFfg0i/2vzyy
57i+H4gv47dKUdbC2+lD+MmF4ONSvoFDXVkQyrIhMp08b8Qw+lEmPippHieNtMNV
uQWNgqt0hsAVUlgVB7CUVmlQdUNQEFj9Zs//defRRUHyoZ+nM/xqeLVagyb4saYY
wyBhBfEWWf39wkcpMeYCswWANm0TWykMO9ZRTcSQKxkelrOxIoUIcZgoP2PT4SWb
DRz6wnIBr5llNfQ+JOejbK+nLL0+0lMbkTE5cyiqlQdsM1RdyMl0M+2CO8Sll9Cn
JMgTAhQBush9RQg6h9yMQMVzSc7BoLKl3O+a9/h2Dbf+6Zx+doH2HtQlSGnpmuuY
brzSo7/TTDSjewNEaIkJSd2WvoN3sgiVXScLq/rRjm4jRsqgoiX9jxSVzfhSwOuX
BrwWwk9wSrC1StQuHScf9nDiUucJ9/aDSdsrvtkB9Uq9kWkHoWs+/Y7Kl7U3fNpL
Rpgu6YIq7vv8FhXG1Eh9B9r7TQiD8tiB4AK4hxop2UbXrTWD8k2YY9cBpwgrl8mL
M37VrUcbYJzJa15xLd30LxpqKrD5YJzzHsGnSD6vv56c8Jo039lmtlIQjbliglqR
OsDi4j+XE8sGu7phrTdIsyC4lXDnCJtX9oIKibh5zS8fFb4WjaSW+7TvYOXAmr0H
7pMgyxwukTe2Hd4KAuBB
=Pu65
-----END PGP SIGNATURE-----

--d2IMS6fuC0p5eWIP--
