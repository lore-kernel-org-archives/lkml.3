Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026Ab3IFXUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 19:20:53 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:38453 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IFXUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 19:20:51 -0400
MIME-Version: 1.0
Date: Fri, 6 Sep 2013 16:20:50 -0700
X-Google-Sender-Auth: yGT-WPh0GQ6daELUpi-1AnJQyyI
Message-ID: <CAGXu5jJvuAC3paV5k_bmoHHrHVgc0Hi6ShSDk3iQUt1Lf0cioQ@mail.gmail.com>
Subject: race condition in crypto larval handling
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've tracked down a race condition and ref counting problem in the
crypto API internals. We've been seeing it under Chrome OS, but it
seems it's not isolated to just us:

https://code.google.com/p/chromium/issues/detail?id=244581
http://marc.info/?l=linux-crypto-vger&m=135429403609373&w=2
https://bugzilla.redhat.com/show_bug.cgi?id=983682
http://www.mail-archive.com/linux-cifs@vger.kernel.org/msg07933.html

I think I've found the basic origin of the problem.
crypto_larval_add() has synchronization to make sure only a single
larval can ever be created. That logic seems totally fine. However,
this means that crypto_larval_lookup() from two threads can return the
same larval, which means that crypto_alg_mod_lookup() runs the risk of
calling crypto_larval_kill() on the same larval twice, which does not
appear to be handled sanely.

I can easily crash the kernel by forcing a synchronization point just
before the "return crypt_larval_add(...)" call in
crypto_larval_lookup(). Basically, I added this sloppy sync code (I
feel like there must be a better way to do this):

+static atomic_t global_sync = ATOMIC_INIT(0);
...
struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
...
+       if (strncmp(name, "asdf", 4) == 0) {
+               int value;
+
+               value = atomic_add_return(1, &global_sync);
+               if (value == 1) {
+                       /* I was first to stall here, wait for inc. */
+                       while (atomic_read(&global_sync) != 2)
+                               cpu_relax();
+               } else if (value == 2) {
+                       /* I was second to stall here, wait for dec. */
+                       while (atomic_read(&global_sync) != 1)
+                               cpu_relax();
+               } else {
+                       BUG();
+               }
+               atomic_dec(&global_sync);
+       }

        return crypto_larval_add(name, type, mask);
 }

And then ran code from userspace that did, effectively:

    struct sockaddr_alg sa = {
        .salg_family = AF_ALG,
        .salg_type   = "hash",
    };
    strcpy(sa.salg_name, argv[1]);

    fork();
    ...
    sds[0] = socket(AF_ALG, SOCK_SEQPACKET, 0);
    bind(sds[0], (struct sockaddr *) &sa, sizeof(sa));

And ran this as "./tickle asdf1" to generate the two threads trying to
find an invalid alg. The race looks possible even with valid algs, but
this was the fastest path I could see to tickle the issue.

With added printks to the kernel, it was clear that crypto_larval_kill
was being called twice on the same larval, and the list_del() call was
doing bad things. When I fixed that, the refcnt bug became very
obvious. Here's the change I made for crypto_larval_kill:

@@ -161,7 +166,8 @@ void crypto_larval_kill(struct crypto_alg *alg)
        struct crypto_larval *larval = (void *)alg;

        down_write(&crypto_alg_sem);
-       list_del(&alg->cra_list);
+       if (!list_empty(&alg->cra_list))
+               list_del_init(&alg->cra_list);
        up_write(&crypto_alg_sem);
        complete_all(&larval->completion);
        crypto_alg_put(alg);

It seems that there are too many "put" calls (mixed between
crypto_alg_put() and crypto_mod_put(), which also calls
crypto_alg_put()). See this annotated portion of
crypto_alg_mod_lookup:

        /* This can (correctly) return the same larval for two threads. */
        larval = crypto_larval_lookup(name, type, mask);
        if (IS_ERR(larval) || !crypto_is_larval(larval))
                return larval;

        ok = crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST, larval);

        if (ok == NOTIFY_STOP)
                /* This calls crypto_mod_put(), but sometimes also get?? */
                alg = crypto_larval_wait(larval);
        else {
                /* This directly calls crypto_mod_put */
                crypto_mod_put(larval);
                alg = ERR_PTR(-ENOENT);
        }
        /* This calls crypto_alg_put */
        crypto_larval_kill(larval);
        return alg;

In the two-thread situation, the first thread gets a larval with
refcnt 2 via crypto_larval_add. (Why 2?) The next thread finds the
larval via crypto_larval_add's call to __crypto_alg_lookup() and sees
the ref bump to 3. While exiting crypto_alg_mod_lookup, each thread
decrements the ref count twice.

It seems to me like either each call to crypto_larval_lookup() should
result in a refcount bumped by two, or crypto_alg_mod_lookup() should
decrement only once, and the initial refcount should be 1 not 2 from
crypto_larval_add. But it's not clear to me which is sensible here.

What's the right solution here?

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
