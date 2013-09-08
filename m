Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab3IHDeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:34:21 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:56553 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3IHDeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:34:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130908013210.GA30627@gondor.apana.org.au>
References: <CAGXu5jJvuAC3paV5k_bmoHHrHVgc0Hi6ShSDk3iQUt1Lf0cioQ@mail.gmail.com>
	<20130908013210.GA30627@gondor.apana.org.au>
Date: Sat, 7 Sep 2013 20:34:15 -0700
X-Google-Sender-Auth: S_5_x_GBBjltMfXZg3s0dkPs7Ds
Message-ID: <CAGXu5j+DoXK_9v430xhCzOO1bsuuhe84fjkf7+DZ0r35hUNBBg@mail.gmail.com>
Subject: Re: race condition in crypto larval handling
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 6:32 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Sep 06, 2013 at 04:20:50PM -0700, Kees Cook wrote:
>>
>> In the two-thread situation, the first thread gets a larval with
>> refcnt 2 via crypto_larval_add. (Why 2?) The next thread finds the
>> larval via crypto_larval_add's call to __crypto_alg_lookup() and sees
>> the ref bump to 3. While exiting crypto_alg_mod_lookup, each thread
>> decrements the ref count twice.
>>
>> It seems to me like either each call to crypto_larval_lookup() should
>> result in a refcount bumped by two, or crypto_alg_mod_lookup() should
>> decrement only once, and the initial refcount should be 1 not 2 from
>> crypto_larval_add. But it's not clear to me which is sensible here.
>>
>> What's the right solution here?
>
> First of all thanks a lot for tracking this problem down! It's
> been bothering me for months but I was unable to find a good
> reproducer.
>
> So now that you've identified the problem, the solution is easy.
> crypto_larval_lookup should only ever return a larval if it created
> one.  Any larval created earlier must be waited on first before we
> return.
>
> So does this patch fix the crash for you?
>
> diff --git a/crypto/api.c b/crypto/api.c
> index 320ea4d..a2b39c5 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -34,6 +34,8 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
>  BLOCKING_NOTIFIER_HEAD(crypto_chain);
>  EXPORT_SYMBOL_GPL(crypto_chain);
>
> +static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
> +
>  struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
>  {
>         return try_module_get(alg->cra_module) ? crypto_alg_get(alg) : NULL;
> @@ -144,8 +146,11 @@ static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
>         }
>         up_write(&crypto_alg_sem);
>
> -       if (alg != &larval->alg)
> +       if (alg != &larval->alg) {
>                 kfree(larval);
> +               if (crypto_is_larval(alg))
> +                       alg = crypto_larval_wait(alg);
> +       }
>
>         return alg;
>  }

Thanks! This does stop the crash I was seeing on the "race with no
valid alg" path, yay!

However, I noticed on the "good" path (even without the above patch),
I sometimes see a double-kfree triggered by the modprobe process. I
can't, however, see how that's happening, since larval_destroy should
only be called when refcnt == 0.

Here's the debugging output I added that noticed this. pid 15797 and
15798 are my "hash" tool that forks before doing identical AF_ALG
calls for "sha512", which has to be modprobed. The trailing "31" and
"32" was an atomic counter I added just to make sure I wasn't going
crazy:

[  112.495789] crypto_alg_mod_lookup 15797: looking up [sha512]
[  112.495815] crypto_larval_lookup 15797: looking up [sha512]
[  112.495839] crypto_larval_lookup 15797: requesting module [sha512]
[  112.495915] crypto_alg_mod_lookup 15798: looking up [sha512]
[  112.495937] crypto_larval_lookup 15798: looking up [sha512]
[  112.495960] crypto_larval_lookup 15798: requesting module [sha512]
[  112.498691] crypto_larval_destroy 15808(modprobe): larval
kfree(ffff880123e9da00) refcnt:0 (serial:31)
[  112.498771] crypto_larval_destroy 15808(modprobe): larval
kfree(ffff880123e9da00) refcnt:0 (serial:32)
[  112.500888] crypto_larval_lookup 15797: after requesting module
[sha512], got alg ffffffffc0299050
[  112.500904] crypto_larval_lookup 15797: for [sha512], have alg
ffffffffc0299050
[  112.500934] crypto_larval_lookup 15797: for [sha512], alg
ffffffffc0299050 is NOT larval
[  112.500953] crypto_alg_mod_lookup 15797: [sha512] is not larval
ffffffffc0299050
[  112.501384] crypto_larval_lookup 15798: after requesting module
[sha512], got alg ffffffffc0299050
[  112.501404] crypto_larval_lookup 15798: for [sha512], have alg
ffffffffc0299050
[  112.501417] crypto_larval_lookup 15798: for [sha512], alg
ffffffffc0299050 is NOT larval
[  112.501432] crypto_alg_mod_lookup 15798: [sha512] is not larval
ffffffffc0299050

Regardless, this seems to be a separate bug.

-Kees

-- 
Kees Cook
Chrome OS Security
