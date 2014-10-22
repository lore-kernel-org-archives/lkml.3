Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaJVPKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:10:39 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52444 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752183AbaJVPKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:10:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX199eqN9uvND2JIVxev3MjWgWLheqDl96IQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3811A60558C
Date: Wed, 22 Oct 2014 11:10:28 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: skein: Loadable Module Support
Message-ID: <20141022151028.GY17447@titan.lakedaemon.net>
References: <20141021144427.GA31929@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021144427.GA31929@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

Awesome!  You must have been reading my TODO list :)

On Tue, Oct 21, 2014 at 09:44:27AM -0500, Eric Rost wrote:
> Adds loadable module support for Skein256, Skein512, and Skein1024 Hash
> Algorithms.

This description is accurate, but incomplete.  You're also integrating
skein into the crypto API.  If you don't mind, could you split this
patch in two?  The first integrating into the crypto API (such that
userspace could call into it), and the second enabling loadable module
support?

More thoughts below.

> Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> ---
>  drivers/staging/skein/Kconfig             | 12 +++++
>  drivers/staging/skein/Makefile            |  6 +++
>  drivers/staging/skein/skein.c             | 11 +++-
>  drivers/staging/skein/skein.h             |  6 +++
>  drivers/staging/skein/skein1024_generic.c | 88 +++++++++++++++++++++++++++++++
>  drivers/staging/skein/skein256_generic.c  | 88 +++++++++++++++++++++++++++++++
>  drivers/staging/skein/skein512_generic.c  | 88 +++++++++++++++++++++++++++++++
>  7 files changed, 298 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/staging/skein/skein1024_generic.c
>  create mode 100644 drivers/staging/skein/skein256_generic.c
>  create mode 100644 drivers/staging/skein/skein512_generic.c
> 
> diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
> index b9172bf..e260111 100644
> --- a/drivers/staging/skein/Kconfig
> +++ b/drivers/staging/skein/Kconfig
> @@ -15,6 +15,18 @@ config CRYPTO_SKEIN
>  	  for more information.  This module depends on the threefish block
>  	  cipher module.
>  
> +config CRYPTO_SKEIN_256
> +	tristate "Skein256 driver"
> +	select CRYPTO_SKEIN
> +
> +config CRYPTO_SKEIN_512
> +	tristate "Skein512 driver"
> +	select CRYPTO_SKEIN
> +
> +config CRYPTO_SKEIN_1024
> +	tristate "Skein1024 driver"
> +	select CRYPTO_SKEIN
> +
>  config CRYPTO_THREEFISH
>  	bool "Threefish tweakable block cipher"
>  	depends on (X86 || UML_X86) && 64BIT && CRYPTO
> diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
> index a14aadd..1be01fe 100644
> --- a/drivers/staging/skein/Makefile
> +++ b/drivers/staging/skein/Makefile
> @@ -5,5 +5,11 @@ obj-$(CONFIG_CRYPTO_SKEIN) +=   skein.o \
>  				skein_api.o \
>  				skein_block.o
>  
> +obj-$(CONFIG_CRYPTO_SKEIN_256) += skein256_generic.o
> +
> +obj-$(CONFIG_CRYPTO_SKEIN_512) += skein512_generic.o
> +
> +obj-$(CONFIG_CRYPTO_SKEIN_1024) += skein1024_generic.o
> +

This isn't really doing what we want.  You'll have loadable modules, but
the actual code will still be built into the kernel.

>  obj-$(CONFIG_CRYPTO_THREEFISH) += threefish_block.o \
>  				  threefish_api.o
> diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
> index 8cc8358..2138e22 100644
> --- a/drivers/staging/skein/skein.c
> +++ b/drivers/staging/skein/skein.c
> @@ -11,6 +11,7 @@
>  #define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
>  
>  #include <linux/string.h>       /* get the memcpy/memset functions */
> +#include <linux/export.h>
>  #include "skein.h" /* get the Skein API definitions   */
>  #include "skein_iv.h"    /* get precomputed IVs */
>  #include "skein_block.h"
> @@ -73,6 +74,7 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
>  
>  	return SKEIN_SUCCESS;
>  }
> +EXPORT_SYMBOL(skein_256_init);

Once the above is corrected, these shouldn't be necessary.

>  
>  /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
>  /* init the context for a MAC and/or tree hash operation */
> @@ -191,7 +193,7 @@ int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
>  
>  	return SKEIN_SUCCESS;
>  }
> -
> +EXPORT_SYMBOL(skein_256_update);
>  /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
>  /* finalize the hash computation and output the result */
>  int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
> @@ -240,6 +242,7 @@ int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
>  	}
>  	return SKEIN_SUCCESS;
>  }
> +EXPORT_SYMBOL(skein_256_final);
>  
>  /*****************************************************************/
>  /*     512-bit Skein                                             */
> @@ -303,6 +306,7 @@ int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len)
>  
>  	return SKEIN_SUCCESS;
>  }
> +EXPORT_SYMBOL(skein_512_init);
>  
>  /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
>  /* init the context for a MAC and/or tree hash operation */
> @@ -420,6 +424,7 @@ int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
>  
>  	return SKEIN_SUCCESS;
>  }
> +EXPORT_SYMBOL(skein_512_update);
>  
>  /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
>  /* finalize the hash computation and output the result */
> @@ -469,6 +474,7 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
>  	}
>  	return SKEIN_SUCCESS;
>  }
> +EXPORT_SYMBOL(skein_512_final);
>  
>  /*****************************************************************/
>  /*    1024-bit Skein                                             */
> @@ -526,6 +532,7 @@ int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len)
>  
>  	return SKEIN_SUCCESS;
>  }
> +EXPORT_SYMBOL(skein_1024_init);
>  
>  /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
>  /* init the context for a MAC and/or tree hash operation */
> @@ -644,6 +651,7 @@ int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
>  
>  	return SKEIN_SUCCESS;
>  }
> +EXPORT_SYMBOL(skein_1024_update);
>  
>  /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
>  /* finalize the hash computation and output the result */
> @@ -693,6 +701,7 @@ int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
>  	}
>  	return SKEIN_SUCCESS;
>  }
> +EXPORT_SYMBOL(skein_1024_final);
>  
>  /**************** Functions to support MAC/tree hashing ***************/
>  /*   (this code is identical for Optimized and Reference versions)    */
> diff --git a/drivers/staging/skein/skein.h b/drivers/staging/skein/skein.h
> index e6669f1..d803458 100644
> --- a/drivers/staging/skein/skein.h
> +++ b/drivers/staging/skein/skein.h
> @@ -26,8 +26,14 @@
>  **                                0: use assert()      to flag errors
>  **                                1: return SKEIN_FAIL to flag errors
>  **
> +**
>  ***************************************************************************/

superfluous whitespace addition?

>  
> +/*Skein digest sizes for crypto api*/
> +#define SKEIN256_DIGEST_SIZE (256)
> +#define SKEIN512_DIGEST_SIZE (512)
> +#define SKEIN1024_DIGEST_SIZE (1024)
> +
>  #ifndef rotl_64
>  #define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
>  #endif
> diff --git a/drivers/staging/skein/skein1024_generic.c b/drivers/staging/skein/skein1024_generic.c
> new file mode 100644
> index 0000000..b82c4f5
> --- /dev/null
> +++ b/drivers/staging/skein/skein1024_generic.c
> @@ -0,0 +1,88 @@
> +/*
> + * Cryptographic API.
> + *
> + * Skein1024 Hash Algorithm.
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
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <linux/cryptohash.h>
> +#include <linux/types.h>
> +#include "skein.h"
> +#include <asm/byteorder.h>
> +
> +static int skein1024_init(struct shash_desc *desc)
> +{
> +	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
> +
> +	int ret = skein_1024_init(sctx, SKEIN1024_DIGEST_SIZE);
> +
> +	return ret;
> +}
> +
> +int crypto_skein1024_update(struct shash_desc *desc, const u8 *data,
> +			unsigned int len)
> +{
> +	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
> +	size_t hbl = (size_t) len;
> +	int ret = skein_1024_update(sctx, data, hbl);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(crypto_skein1024_update);
> +
> +
> +/* Add padding and return the message digest. */
> +static int skein1024_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct skein_1024_ctx *sctx = shash_desc_ctx(desc);
> +	int ret = skein_1024_final(sctx, out);
> +	return ret;
> +}
> +
> +
> +static struct shash_alg alg = {
> +	.digestsize	=	(SKEIN1024_DIGEST_SIZE / 8),
> +	.init		=	skein1024_init,
> +	.update		=	crypto_skein1024_update,

why is this function name different from the other two?

> +	.final		=	skein1024_final,
> +	.descsize	=	sizeof(struct skein_1024_ctx),
> +	.statesize	=	sizeof(struct skein_1024_ctx),
> +	.base		=	{
> +		.cra_name		=	"skein1024",
> +		.cra_driver_name	=	"skein1024-generic",
> +		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
> +		.cra_blocksize		=	SKEIN_1024_BLOCK_BYTES,
> +		.cra_module		=	THIS_MODULE,
> +	}
> +};
> +
> +static int __init skein1024_generic_mod_init(void)
> +{
> +	return crypto_register_shash(&alg);
> +}
> +
> +static void __exit skein1024_generic_mod_fini(void)
> +{
> +	crypto_unregister_shash(&alg);
> +}
> +
> +module_init(skein1024_generic_mod_init);
> +module_exit(skein1024_generic_mod_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Skein1024 Hash Algorithm");
> +
> +MODULE_ALIAS("skein1024");

I think it might be best to have two loadable modules.  One for
threefish, and one for skein.  Adding threefish to the crypto API is a
bit more difficult than adding skein, as the crypto API doesn't
currently support tweakable block ciphers.

To keep things moving, it'd probably be best to do one module for now,
skein.  Have all the object files for skein and threefish in it, and
register the three hash algos with the API.

After that, we can go back and split out threefish into a separate
module with it's own registration into the crypto API.

Does that sound sensible?

thx,

Jason.

> diff --git a/drivers/staging/skein/skein256_generic.c b/drivers/staging/skein/skein256_generic.c
> new file mode 100644
> index 0000000..27a7a21
> --- /dev/null
> +++ b/drivers/staging/skein/skein256_generic.c
> @@ -0,0 +1,88 @@
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
> +#include <linux/module.h>
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
> +	int ret = skein_256_init(sctx, SKEIN256_DIGEST_SIZE);
> +
> +	return ret;
> +}
> +
> +int crypto_skein256_update(struct shash_desc *desc, const u8 *data,
> +			unsigned int len)
> +{
> +	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
> +	size_t hbl = (size_t) len;
> +	int ret = skein_256_update(sctx, data, hbl);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(crypto_skein256_update);
> +
> +
> +/* Add padding and return the message digest. */
> +static int skein256_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct skein_256_ctx *sctx = shash_desc_ctx(desc);
> +	int ret = skein_256_final(sctx, out);
> +	return ret;
> +}
> +
> +
> +static struct shash_alg alg = {
> +	.digestsize	=	(SKEIN256_DIGEST_SIZE / 8),
> +	.init		=	skein256_init,
> +	.update		=	crypto_skein256_update,
> +	.final		=	skein256_final,
> +	.descsize	=	sizeof(struct skein_256_ctx),
> +	.statesize	=	sizeof(struct skein_256_ctx),
> +	.base		=	{
> +		.cra_name		=	"skein256",
> +		.cra_driver_name	=	"skein256-generic",
> +		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
> +		.cra_blocksize		=	SKEIN_256_BLOCK_BYTES,
> +		.cra_module		=	THIS_MODULE,
> +	}
> +};
> +
> +static int __init skein256_generic_mod_init(void)
> +{
> +	return crypto_register_shash(&alg);
> +}
> +
> +static void __exit skein256_generic_mod_fini(void)
> +{
> +	crypto_unregister_shash(&alg);
> +}
> +
> +module_init(skein256_generic_mod_init);
> +module_exit(skein256_generic_mod_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Skein256 Hash Algorithm");
> +
> +MODULE_ALIAS("skein256");
> diff --git a/drivers/staging/skein/skein512_generic.c b/drivers/staging/skein/skein512_generic.c
> new file mode 100644
> index 0000000..71d5a6c
> --- /dev/null
> +++ b/drivers/staging/skein/skein512_generic.c
> @@ -0,0 +1,88 @@
> +/*
> + * Cryptographic API.
> + *
> + * Skein512 Hash Algorithm.
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
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <linux/cryptohash.h>
> +#include <linux/types.h>
> +#include "skein.h"
> +#include <asm/byteorder.h>
> +
> +static int skein512_init(struct shash_desc *desc)
> +{
> +	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
> +
> +	int ret = skein_512_init(sctx, SKEIN512_DIGEST_SIZE);
> +
> +	return ret;
> +}
> +
> +int crypto_skein512_update(struct shash_desc *desc, const u8 *data,
> +			unsigned int len)
> +{
> +	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
> +	size_t hbl = (size_t) len;
> +	int ret = skein_512_update(sctx, data, hbl);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(crypto_skein512_update);
> +
> +
> +/* Add padding and return the message digest. */
> +static int skein512_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct skein_512_ctx *sctx = shash_desc_ctx(desc);
> +	int ret = skein_512_final(sctx, out);
> +	return ret;
> +}
> +
> +
> +static struct shash_alg alg = {
> +	.digestsize	=	(SKEIN512_DIGEST_SIZE / 8),
> +	.init		=	skein512_init,
> +	.update		=	crypto_skein512_update,
> +	.final		=	skein512_final,
> +	.descsize	=	sizeof(struct skein_512_ctx),
> +	.statesize	=	sizeof(struct skein_512_ctx),
> +	.base		=	{
> +		.cra_name		=	"skein512",
> +		.cra_driver_name	=	"skein512-generic",
> +		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
> +		.cra_blocksize		=	SKEIN_512_BLOCK_BYTES,
> +		.cra_module		=	THIS_MODULE,
> +	}
> +};
> +
> +static int __init skein512_generic_mod_init(void)
> +{
> +	return crypto_register_shash(&alg);
> +}
> +
> +static void __exit skein512_generic_mod_fini(void)
> +{
> +	crypto_unregister_shash(&alg);
> +}
> +
> +module_init(skein512_generic_mod_init);
> +module_exit(skein512_generic_mod_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Skein512 Hash Algorithm");
> +
> +MODULE_ALIAS("skein512");
> -- 
> 2.1.1
> 
