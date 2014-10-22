Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaJVPym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:54:42 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:61411 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbaJVPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:54:34 -0400
Message-ID: <1413993266.11638.1.camel@mybabylon.net>
Subject: Re: [PATCH v2] staging: skein: Loadable Module Support
From: Eric Rost <eric.rost@mybabylon.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 22 Oct 2014 10:54:26 -0500
In-Reply-To: <20141022151028.GY17447@titan.lakedaemon.net>
References: <20141021144427.GA31929@localhost>
	 <20141022151028.GY17447@titan.lakedaemon.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 11:10 -0400, Jason Cooper wrote:

> 
> If you don't mind, could you split this
> patch in two?  The first integrating into the crypto API (such that
> userspace could call into it), and the second enabling loadable module
> support?
> 

Will do!

> > Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> > ---
> >  drivers/staging/skein/Kconfig             | 12 +++++
> >  drivers/staging/skein/Makefile            |  6 +++
> >  drivers/staging/skein/skein.c             | 11 +++-
> >  drivers/staging/skein/skein.h             |  6 +++
> >  drivers/staging/skein/skein1024_generic.c | 88 +++++++++++++++++++++++++++++++
> >  drivers/staging/skein/skein256_generic.c  | 88 +++++++++++++++++++++++++++++++
> >  drivers/staging/skein/skein512_generic.c  | 88 +++++++++++++++++++++++++++++++
> >  7 files changed, 298 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/staging/skein/skein1024_generic.c
> >  create mode 100644 drivers/staging/skein/skein256_generic.c
> >  create mode 100644 drivers/staging/skein/skein512_generic.c
> > 
> > diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
> > index b9172bf..e260111 100644
> > --- a/drivers/staging/skein/Kconfig
> > +++ b/drivers/staging/skein/Kconfig
> > @@ -15,6 +15,18 @@ config CRYPTO_SKEIN
> >  	  for more information.  This module depends on the threefish block
> >  	  cipher module.
> >  
> > +config CRYPTO_SKEIN_256
> > +	tristate "Skein256 driver"
> > +	select CRYPTO_SKEIN
> > +
> > +config CRYPTO_SKEIN_512
> > +	tristate "Skein512 driver"
> > +	select CRYPTO_SKEIN
> > +
> > +config CRYPTO_SKEIN_1024
> > +	tristate "Skein1024 driver"
> > +	select CRYPTO_SKEIN
> > +
> >  config CRYPTO_THREEFISH
> >  	bool "Threefish tweakable block cipher"
> >  	depends on (X86 || UML_X86) && 64BIT && CRYPTO
> > diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
> > index a14aadd..1be01fe 100644
> > --- a/drivers/staging/skein/Makefile
> > +++ b/drivers/staging/skein/Makefile
> > @@ -5,5 +5,11 @@ obj-$(CONFIG_CRYPTO_SKEIN) +=   skein.o \
> >  				skein_api.o \
> >  				skein_block.o
> >  
> > +obj-$(CONFIG_CRYPTO_SKEIN_256) += skein256_generic.o
> > +
> > +obj-$(CONFIG_CRYPTO_SKEIN_512) += skein512_generic.o
> > +
> > +obj-$(CONFIG_CRYPTO_SKEIN_1024) += skein1024_generic.o
> > +
> 
> This isn't really doing what we want.  You'll have loadable modules, but
> the actual code will still be built into the kernel.
> 
> >  obj-$(CONFIG_CRYPTO_THREEFISH) += threefish_block.o \
> >  				  threefish_api.o
> > diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
> > index 8cc8358..2138e22 100644
> > --- a/drivers/staging/skein/skein.c
> > +++ b/drivers/staging/skein/skein.c
> > @@ -11,6 +11,7 @@
> >  #define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
> >  
> >  #include <linux/string.h>       /* get the memcpy/memset functions */
> > +#include <linux/export.h>
> >  #include "skein.h" /* get the Skein API definitions   */
> >  #include "skein_iv.h"    /* get precomputed IVs */
> >  #include "skein_block.h"
> > @@ -73,6 +74,7 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
> >  
> >  	return SKEIN_SUCCESS;
> >  }
> > +EXPORT_SYMBOL(skein_256_init);
> 
> Once the above is corrected, these shouldn't be necessary.
> 
Will give it a whirl, I was having problems with undefined symbols at
linking even when I was building it as one module, but it may have been
something else
> > --- a/drivers/staging/skein/skein.h
> > +++ b/drivers/staging/skein/skein.h
> > @@ -26,8 +26,14 @@
> >  **                                0: use assert()      to flag errors
> >  **                                1: return SKEIN_FAIL to flag errors
> >  **
> > +**
> >  ***************************************************************************/
> 
> superfluous whitespace addition?
> 
Remnants of a backed out change... will fix.

> > +
> > +static struct shash_alg alg = {
> > +	.digestsize	=	(SKEIN1024_DIGEST_SIZE / 8),
> > +	.init		=	skein1024_init,
> > +	.update		=	crypto_skein1024_update,
> 
> why is this function name different from the other two?

It was inherited from the sha1 file I based this off of, I can make them
the same.

> I think it might be best to have two loadable modules.  One for
> threefish, and one for skein.  Adding threefish to the crypto API is a
> bit more difficult than adding skein, as the crypto API doesn't
> currently support tweakable block ciphers.
> 
> To keep things moving, it'd probably be best to do one module for now,
> skein.  Have all the object files for skein and threefish in it, and
> register the three hash algos with the API.
> 
> After that, we can go back and split out threefish into a separate
> module with it's own registration into the crypto API.
> 
> Does that sound sensible?
> 
> thx,
> 
> Jason.

Sounds fine to me, I will build it that way and resubmit.


