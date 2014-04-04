Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaDDILg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:11:36 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:55563 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaDDILV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140401124824.GA13642@gondor.apana.org.au>
References: <533aa1ae.qq4Hi3RBnPzgncue%fengguang.wu@intel.com>
	<CAKv+Gu_unwqLWWn-VDegy=vF=rprC5qFhazo_sJFNm738MVgaQ@mail.gmail.com>
	<20140401124824.GA13642@gondor.apana.org.au>
Date: Fri, 4 Apr 2014 10:11:19 +0200
Message-ID: <CAKv+Gu9bg1AgDSb3H-tMGBq53_ySaTZAeYsQeDYKS6cTnaBGUA@mail.gmail.com>
Subject: Fwd: [crypto:master 60/60] arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25:
 sparse: cast to restricted __be64
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

This pertains to commit 8ceee72808d1 (crypto: ghash-clmulni-intel -
use C implementation for setkey()) that has been pulled by Linus
during the current merge window.

It is missing two things:
- a cc to stable annotation
- a fix for the sparse warning below (change cast from __be64 to __force __be64)

The reason for cc'ing stable on this patch is that it fixes a
potential data corruption issue where the ghash setkey() method uses
SSE registers without calling kernel_fpu_begin() first. This issue was
introduced by 0e1227d356e9b (crypto: ghash - Add PCLMULQDQ accelerated
implementation).

So how would you like to proceed with this? Should I propose a new
patch somewhere?

Regards,
Ard.


---------- Forwarded message ----------
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: 1 April 2014 14:48
Subject: Re: [crypto:master 60/60]
arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25: sparse: cast to
restricted __be64
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
kbuild test robot <fengguang.wu@intel.com>


On Tue, Apr 01, 2014 at 02:37:20PM +0200, Ard Biesheuvel wrote:
> On 1 April 2014 13:23, kbuild test robot <fengguang.wu@intel.com> wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
> > head:   8ceee72808d1ae3fb191284afc2257a2be964725
> > commit: 8ceee72808d1ae3fb191284afc2257a2be964725 [60/60] crypto: ghash-clmulni-intel - use C implementation for setkey()
> > reproduce: make C=1 CF=-D__CHECK_ENDIAN__
> >
> >
> > sparse warnings: (new ones prefixed by >>)
> >
> >>> arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25: sparse: cast to restricted __be64
> >>> arch/x86/crypto/ghash-clmulni-intel_glue.c:72:25: sparse: cast to restricted __be64
> >
>
> Sigh.
>
> The sparse warnings /without/ the be64 casts are even worse.
>
> The obvious fix is not to use a be128 for the key, as it is obviously
> an opaque type that just represents a byte array.
> So, Herbert, if you prefer, I can rework this patch to use be128
> instead of u128 inside struct ghash_ctx, but it will have some fallout
> throughout the file. Or instead, we cast to '__force __be64',
> basically just telling sparse to shut up ...

I'll add the __force to shut it up.  Thanks!
--
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
