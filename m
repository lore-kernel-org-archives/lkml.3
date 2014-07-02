Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaGBNzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:55:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbaGBNzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:55:37 -0400
Date: Wed, 2 Jul 2014 09:53:59 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto/fips: only panic on bad/missing crypto mod
 signatures
Message-ID: <20140702135358.GA59958@redhat.com>
References: <1403896374-62781-1-git-send-email-jarod@redhat.com>
 <20140702123849.GA2206@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702123849.GA2206@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 08:38:50PM +0800, Herbert Xu wrote:
> On Fri, Jun 27, 2014 at 03:12:54PM -0400, Jarod Wilson wrote:
> > Per further discussion with NIST, the requirements for FIPS state that
> > we only need to panic the system on failed kernel module signature checks
> > for crypto subsystem modules. This moves the fips-mode-only module
> > signature check out of the generic module loading code, into the crypto
> > subsystem, at points where we can catch both algorithm module loads and
> > mode module loads. At the same time, make CONFIG_CRYPTO_FIPS dependent on
> > CONFIG_MODULE_SIG, as this is entirely necessary for FIPS mode.
> > 
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Rusty Russell <rusty@rustcorp.com.au>
> > CC: Stephan Mueller <stephan.mueller@atsec.com>
> > CC: linux-crypto@vger.kernel.org
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > ---
> >  crypto/Kconfig  |  1 +
> >  crypto/algapi.c | 13 +++++++++++++
> >  kernel/module.c |  3 ---
> >  3 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index ce4012a..36402e5 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -24,6 +24,7 @@ comment "Crypto core or helper"
> >  config CRYPTO_FIPS
> >  	bool "FIPS 200 compliance"
> >  	depends on CRYPTO_ANSI_CPRNG && !CRYPTO_MANAGER_DISABLE_TESTS
> > +	depends on MODULE_SIG
> >  	help
> >  	  This options enables the fips boot option which is
> >  	  required if you want to system to operate in a FIPS 200
> > diff --git a/crypto/algapi.c b/crypto/algapi.c
> > index 7a1ae87..7d228ff 100644
> > --- a/crypto/algapi.c
> > +++ b/crypto/algapi.c
> > @@ -43,6 +43,12 @@ static inline int crypto_set_driver_name(struct crypto_alg *alg)
> >  
> >  static int crypto_check_alg(struct crypto_alg *alg)
> >  {
> > +#ifdef CONFIG_CRYPTO_FIPS
> > +	if (fips_enabled && alg->cra_module && !alg->cra_module->sig_ok)
> > +		panic("Module %s signature verification failed in FIPS mode\n",
> > +		      alg->cra_module->name);
> > +#endif
> 
> Please hide the ugly ifdef in a helper inline function.

Will do.

> > @@ -437,6 +449,7 @@ int crypto_register_template(struct crypto_template *tmpl)
> >  
> >  	list_add(&tmpl->list, &crypto_template_list);
> >  	crypto_notify(CRYPTO_MSG_TMPL_REGISTER, tmpl);
> > +
> >  	err = 0;
> >  out:
> >  	up_write(&crypto_alg_sem);
> 
> While I have no problems with you adding a blank line please don't
> mix such additions with changes of substance.

Accidental, sorry, was sloppy when moving the check from one place in the
function to another. Will remedy that too. v2 coming after some quick
testing.

-- 
Jarod Wilson
jarod@redhat.com

