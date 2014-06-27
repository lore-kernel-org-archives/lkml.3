Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaF0TVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbaF0TVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:21:13 -0400
Date: Fri, 27 Jun 2014 15:19:42 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto/fips: only panic on bad/missing crypto mod
 signatures
Message-ID: <20140627191942.GE20825@redhat.com>
References: <1403896374-62781-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403896374-62781-1-git-send-email-jarod@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 03:12:54PM -0400, Jarod Wilson wrote:
> Per further discussion with NIST, the requirements for FIPS state that
> we only need to panic the system on failed kernel module signature checks
> for crypto subsystem modules. This moves the fips-mode-only module
> signature check out of the generic module loading code, into the crypto
> subsystem, at points where we can catch both algorithm module loads and
> mode module loads. At the same time, make CONFIG_CRYPTO_FIPS dependent on
> CONFIG_MODULE_SIG, as this is entirely necessary for FIPS mode.
...
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
...
> @@ -430,6 +436,12 @@ int crypto_register_template(struct crypto_template *tmpl)
>  
>  	down_write(&crypto_alg_sem);
>  
> +#ifdef CONFIG_CRYPTO_FIPS
> +	if (fips_enabled && tmpl->module && !tmpl->module->sig_ok)
> +		panic("Module %s signature verification failed in FIPS mode\n",
> +		      tmpl->module->name);
> +#endif
> +

Forgot to mention: the panic locations within the functions don't really
matter a whole lot right this moment, but Stephan pointed out the
possibility of a future FIPS standard that might not require a panic, thus
the crypto_register_template check being done after the down_write() so
that you could do a goto out; instead of a panic here and have things more
or less behave.

-- 
Jarod Wilson
jarod@redhat.com

