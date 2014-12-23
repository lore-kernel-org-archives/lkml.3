Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaLZAbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:31:32 -0500
Received: from ozlabs.org ([103.22.144.67]:36576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaLZAbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:31:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Subject: Re: [PATCH 2/5] hwrng: core - Fix current_rng init/cleanup race yet again
In-Reply-To: <E1Y3ICg-0007cq-Kj@gondolin.me.apana.org.au>
References: <20141223053909.GA28001@gondor.apana.org.au> <E1Y3ICg-0007cq-Kj@gondolin.me.apana.org.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 24 Dec 2014 09:56:36 +1030
Message-ID: <87ppbagd77.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> The kref solution is still buggy because we were only focusing
> on the register/unregister race.  The same race affects the
> setting of current_rng through sysfs.
>
> This patch fixes it by using kref_get_unless_zero.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

This patch scares me a little!

I'll have to pull the tree to review it properly, but the theory was
that the reference count was counting users of the rng.  Now I don't
know what it's counting:

>  static inline int hwrng_init(struct hwrng *rng)
>  {
> +	if (kref_get_unless_zero(&rng->ref))
> +		goto skip_init;
> +
>  	if (rng->init) {
>  		int ret;

OK, so this skip_init branch is triggered when the rng is being
shut down as it's no longer current_rng?

> +
> +	kref_init(&rng->ref);
> +	reinit_completion(&rng->cleanup_done);
> +
> +skip_init:
>  	add_early_randomness(rng);

Then we use it to add randomness?

>  
>  	current_quality = rng->quality ? : default_quality;
> @@ -467,6 +474,9 @@ int hwrng_register(struct hwrng *rng)
>  			goto out_unlock;
>  	}
>  
> +	init_completion(&rng->cleanup_done);
> +	complete(&rng->cleanup_done);
> +

This code smells very bad.

Cheers,
Rusty.
