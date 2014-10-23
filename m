Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaJWMmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:42:13 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39292 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755505AbaJWMmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:42:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/vShi14OiCMqSRuup5ohlkhv/QjSweaFA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 734B0606421
Date: Thu, 23 Oct 2014 08:42:07 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] staging: skein: Add Crypto API support
Message-ID: <20141023124207.GK17447@titan.lakedaemon.net>
References: <cover.1414030776.git.eric.rost@mybabylon.net>
 <e9cb9bb24d2c34a6f6d9459a22c79609ff5cb60e.1414030776.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9cb9bb24d2c34a6f6d9459a22c79609ff5cb60e.1414030776.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:23:51PM -0500, Eric Rost wrote:
> Adds crypto API support for the skein module. Also collapses the
> threefish module into the skein module.
> 
> Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> ---
>  drivers/staging/skein/Kconfig         |  22 +------
>  drivers/staging/skein/Makefile        |  13 ++--
>  drivers/staging/skein/skein.c         |   1 +
>  drivers/staging/skein/skein.h         |   5 ++
>  drivers/staging/skein/skein_generic.c | 109 ++++++++++++++++++++++++++++++++++
>  5 files changed, 125 insertions(+), 25 deletions(-)
>  create mode 100644 drivers/staging/skein/skein_generic.c
> 
> diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
> index b9172bf..de8bdd7 100644
> --- a/drivers/staging/skein/Kconfig
> +++ b/drivers/staging/skein/Kconfig
> @@ -1,8 +1,8 @@
>  config CRYPTO_SKEIN
>  	bool "Skein digest algorithm"
>  	depends on (X86 || UML_X86) && 64BIT && CRYPTO
> -	select CRYPTO_THREEFISH
>  	select CRYPTO_HASH
> +	select CRYPTO_ALGAPI
>  	help
>  	  Skein secure hash algorithm is one of 5 finalists from the NIST SHA3
>  	  competition.
> @@ -12,21 +12,5 @@ config CRYPTO_SKEIN
>  
>  	  http://www.skein-hash.info/sites/default/files/skein1.3.pdf
>  
> -	  for more information.  This module depends on the threefish block
> -	  cipher module.
> -
> -config CRYPTO_THREEFISH
> -	bool "Threefish tweakable block cipher"
> -	depends on (X86 || UML_X86) && 64BIT && CRYPTO
> -	select CRYPTO_ALGAPI
> -	help
> -	  Threefish cipher algorithm is the tweakable block cipher underneath
> -	  the Skein family of secure hash algorithms.  Skein is one of 5
> -	  finalists from the NIST SHA3 competition.
> -
> -	  Skein is optimized for modern, 64bit processors and is highly
> -	  customizable.  See:
> -
> -	  http://www.skein-hash.info/sites/default/files/skein1.3.pdf
> -
> -	  for more information.
> +	  for more information. This module also contains the threefish block
> +	  cipher algorithm.
> diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
> index a14aadd..382b041 100644
> --- a/drivers/staging/skein/Makefile
> +++ b/drivers/staging/skein/Makefile
> @@ -1,9 +1,10 @@
>  #
>  # Makefile for the skein secure hash algorithm
>  #
> -obj-$(CONFIG_CRYPTO_SKEIN) +=   skein.o \
> -				skein_api.o \
> -				skein_block.o
> -
> -obj-$(CONFIG_CRYPTO_THREEFISH) += threefish_block.o \
> -				  threefish_api.o
> +obj-$(CONFIG_CRYPTO_SKEIN) += skein_mod.o
> +skein_mod-y := skein.o \
> +	skein_api.o \
> +	skein_block.o \
> +	threefish_block.o \
> +	threefish_api.o \
> +	skein_generic.o

I'd prefer to rename skein.c so that we can do skein.ko.

> diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
> index 8cc8358..1c3933d 100644
> --- a/drivers/staging/skein/skein.c
> +++ b/drivers/staging/skein/skein.c
> @@ -11,6 +11,7 @@
>  #define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
>  
>  #include <linux/string.h>       /* get the memcpy/memset functions */
> +#include <linux/export.h>

This shouldn't be needed anymore.

>  #include "skein.h" /* get the Skein API definitions   */
>  #include "skein_iv.h"    /* get precomputed IVs */
>  #include "skein_block.h"
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
> +
>  #ifndef rotl_64
>  #define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
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

I forgot to mention this last time.  Please put local includes last.
Also, please double check that all of these are need in this file.

> +
> +static int skein256_init(struct shash_desc *desc)
> +{
> +	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
> +
> +	int ret = skein_256_init(sctx, SKEIN256_DIGEST_BIT_SIZE);
> +
> +	return ret;
> +}
> +
> +int skein256_update(struct shash_desc *desc, const u8 *data,
> +			unsigned int len)
> +{
> +	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
> +	size_t hbl = (size_t) len;
> +	int ret = skein_256_update(sctx, data, hbl);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(skein256_update);

Why export this symbol if it's registered with the crypto API?

Same the others after this one.

thx,

Jason.
