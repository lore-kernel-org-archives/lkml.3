Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaJWM3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:29:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34759 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbaJWM3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:29:04 -0400
Date: Thu, 23 Oct 2014 15:28:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] staging: skein: Add Crypto API support
Message-ID: <20141023122845.GP23154@mwanda>
References: <cover.1414030776.git.eric.rost@mybabylon.net>
 <e9cb9bb24d2c34a6f6d9459a22c79609ff5cb60e.1414030776.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9cb9bb24d2c34a6f6d9459a22c79609ff5cb60e.1414030776.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:23:51PM -0500, Eric Rost wrote:
> Adds crypto API support for the skein module. Also collapses the
> threefish module into the skein module.
> 

Why is this in staging anyway?  It seems very small and not terrible
code.  It could easily be sent to the main kernel.

> diff --git a/drivers/staging/skein/skein.h b/drivers/staging/skein/skein.h
> index e6669f1..79fac00 100644
> --- a/drivers/staging/skein/skein.h
> +++ b/drivers/staging/skein/skein.h
> @@ -28,6 +28,11 @@
>  **
>  ***************************************************************************/
>  
> +/*Skein digest sizes for crypto api*/
> +#define SKEIN256_DIGEST_BIT_SIZE (256)
> +#define SKEIN512_DIGEST_BIT_SIZE (512)
> +#define SKEIN1024_DIGEST_BIT_SIZE (1024)

Superfulous parens.

> +
>  #ifndef rotl_64
>  #define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))

Missing spaces.

#define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64 - (N))))

Also this should be a function.  N and x are evaulated twice so it could
be a bug depending on how it's called.


>  #endif
> diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
> new file mode 100644
> index 0000000..14cc5bd
> --- /dev/null
> +++ b/drivers/staging/skein/skein_generic.c
> @@ -0,0 +1,109 @@
> +/*
> + * Cryptographic API.
> + *
> + * Skein256 Hash Algorithm.
> + *
> + * Derived from cryptoapi implementation, adapted for in-place
> + * scatterlist interface.
> + *
> + * Copyright (c) Eric Rost <eric.rost@mybabylon.net>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +#include <crypto/internal/hash.h>
> +#include <linux/init.h>
> +#include <linux/mm.h>
> +#include <linux/cryptohash.h>
> +#include <linux/types.h>
> +#include "skein.h"
> +#include <asm/byteorder.h>
> +
> +static int skein256_init(struct shash_desc *desc)
> +{
> +	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
> +

Don't put a blank line in the middle of the declaration block.

> +	int ret = skein_256_init(sctx, SKEIN256_DIGEST_BIT_SIZE);
> +
> +	return ret;
> +}

This should be:

static int skein256_init(struct shash_desc *desc)
{
	struct skein_256_ctx *sctx = shash_desc_ctx(desc);

	return skein_256_init(sctx, SKEIN256_DIGEST_BIT_SIZE);
}

> +
> +int skein256_update(struct shash_desc *desc, const u8 *data,
> +			unsigned int len)
> +{
> +	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
> +	size_t hbl = (size_t) len;

Pointless case.  Pointless assignment.

> +	int ret = skein_256_update(sctx, data, hbl);
> +
> +	return ret;
> +}

This should be:

int skein256_update(struct shash_desc *desc, const u8 *data,
			unsigned int len)
{
	struct skein_256_ctx *sctx = shash_desc_ctx(desc);

	return skein_256_update(sctx, data, len);
}

> +EXPORT_SYMBOL(skein256_update);
> +
> +/* Add padding and return the message digest. */
> +static int skein256_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
> +	int ret = skein_256_final(sctx, out);
> +	return ret;
> +}

Same.

> +
> +static int skein512_init(struct shash_desc *desc)
> +{
> +	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
> +
> +	int ret = skein_512_init(sctx, SKEIN512_DIGEST_BIT_SIZE);
> +
> +	return ret;
> +}

Same.

> +
> +int skein512_update(struct shash_desc *desc, const u8 *data,
> +			unsigned int len)
> +{
> +	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
> +	size_t hbl = (size_t) len;
> +	int ret = skein_512_update(sctx, data, hbl);
> +
> +	return ret;
> +}

Same.

> +EXPORT_SYMBOL(skein512_update);
> +
> +/* Add padding and return the message digest. */
> +static int skein512_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
> +	int ret = skein_512_final(sctx, out);
> +	return ret;
> +}

Same.

> +
> +static int skein1024_init(struct shash_desc *desc)
> +{
> +	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
> +
> +	int ret = skein_1024_init(sctx, SKEIN1024_DIGEST_BIT_SIZE);
> +
> +	return ret;
> +}

Same.

> +
> +int skein1024_update(struct shash_desc *desc, const u8 *data,
> +			unsigned int len)
> +{
> +	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
> +	size_t hbl = (size_t) len;
> +	int ret = skein_1024_update(sctx, data, hbl);
> +
> +	return ret;
> +}

Same.

> +EXPORT_SYMBOL(skein1024_update);
> +
> +/* Add padding and return the message digest. */
> +static int skein1024_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
> +	int ret = skein_1024_final(sctx, out);
> +	return ret;
> +}

Same.

regarsd,
dan carpenter


