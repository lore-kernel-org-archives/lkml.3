Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3IHBcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 21:32:21 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:34139 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120Ab3IHBcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 21:32:20 -0400
Date: Sun, 8 Sep 2013 11:32:11 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>
Subject: Re: race condition in crypto larval handling
Message-ID: <20130908013210.GA30627@gondor.apana.org.au>
References: <CAGXu5jJvuAC3paV5k_bmoHHrHVgc0Hi6ShSDk3iQUt1Lf0cioQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJvuAC3paV5k_bmoHHrHVgc0Hi6ShSDk3iQUt1Lf0cioQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 04:20:50PM -0700, Kees Cook wrote:
>
> In the two-thread situation, the first thread gets a larval with
> refcnt 2 via crypto_larval_add. (Why 2?) The next thread finds the
> larval via crypto_larval_add's call to __crypto_alg_lookup() and sees
> the ref bump to 3. While exiting crypto_alg_mod_lookup, each thread
> decrements the ref count twice.
> 
> It seems to me like either each call to crypto_larval_lookup() should
> result in a refcount bumped by two, or crypto_alg_mod_lookup() should
> decrement only once, and the initial refcount should be 1 not 2 from
> crypto_larval_add. But it's not clear to me which is sensible here.
> 
> What's the right solution here?

First of all thanks a lot for tracking this problem down! It's
been bothering me for months but I was unable to find a good
reproducer.

So now that you've identified the problem, the solution is easy.
crypto_larval_lookup should only ever return a larval if it created
one.  Any larval created earlier must be waited on first before we
return.

So does this patch fix the crash for you?

diff --git a/crypto/api.c b/crypto/api.c
index 320ea4d..a2b39c5 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -34,6 +34,8 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
+
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
 {
 	return try_module_get(alg->cra_module) ? crypto_alg_get(alg) : NULL;
@@ -144,8 +146,11 @@ static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
 	}
 	up_write(&crypto_alg_sem);
 
-	if (alg != &larval->alg)
+	if (alg != &larval->alg) {
 		kfree(larval);
+		if (crypto_is_larval(alg))
+			alg = crypto_larval_wait(alg);
+	}
 
 	return alg;
 }

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
