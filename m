Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaF2FId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 01:08:33 -0400
Received: from mail.eperm.de ([89.247.134.16]:53699 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaF2FIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 01:08:32 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] DRBG: cleanup of preprocessor macros
Date: Sun, 29 Jun 2014 07:07:19 +0200
Message-ID: <3104100.drOBnqUFp8@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140629122015.43f5178a@canb.auug.org.au>
References: <4927386.WYHrRe3NJm@myon.chronox.de> <1949550.LXKdkPOvgm@myon.chronox.de> <20140629122015.43f5178a@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 29. Juni 2014, 12:20:15 schrieb Stephen Rothwell:

Hi Stephen,

> Hi Stephan,
> 
> On Sat, 28 Jun 2014 22:00:07 +0200 Stephan Mueller <smueller@chronox.de> 
wrote:
> > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > index 6679a26..03a230e 100644
> > --- a/crypto/drbg.c
> > +++ b/crypto/drbg.c
> > @@ -102,8 +102,13 @@
> > 
> >  #if !defined(CONFIG_CRYPTO_DRBG_HASH) && \
> >  
> >  	!defined(CONFIG_CRYPTO_DRBG_HMAC) && \
> >  	!defined(CONFIG_CRYPTO_DRBG_CTR)
> > 
> > -#warning "The DRBG code is useless without compiling at least one DRBG
> > type" -#endif
> > +#define CRYPTO_DRBG_NONE_STRING "none "
> > +static int __init drbg_init(void)
> > +{
> > +	pr_warn("DRBG: no DRBG core was compiled!\n");
> > +	return -EFAULT;
> > +}
> > +#else
> 
> Wouldn't this be better handled by Kconfig so that we don't even try to
> build this unless one of the required core modules is chosen?

I tried that, but it seems that my Kconfig Foo is not too well: adding the 
DRBG cores to the depends line of CRYPTO_DRBG as indicated in the following, I 
have a circular dependency. With that circular dependency, the DRBG entries do 
not show up in make menuconfig.

menuconfig CRYTPO_DRBG
        tristate "NIST SP800-90A DRBG"
        depends on CRYPTO && (CRYPTO_DRBG_HMAC || CRYPTO_DRBG_CTR || 
CRYPTO_DRBG_HASH)
...

if CRYTPO_DRBG

config CRYPTO_DRBG_HMAC
        bool "Enable HMAC DRBG"
        default y
        depends on CRYTPO_DRBG

Do you have a working solution in mind? The goal is that once CRYPTO_DRBG is 
selected, at least one of the DRBG cores must be selected.

Thanks
Stephan
-- 
| Cui bono? |
