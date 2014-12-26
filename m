Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086AbaLZAxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:53:01 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:44587 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaLZAw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:52:59 -0500
Date: Fri, 26 Dec 2014 11:52:40 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Subject: Re: [PATCH 2/5] hwrng: core - Fix current_rng init/cleanup race yet
 again
Message-ID: <20141226005240.GA20702@gondor.apana.org.au>
References: <20141223053909.GA28001@gondor.apana.org.au>
 <E1Y3ICg-0007cq-Kj@gondolin.me.apana.org.au>
 <87ppbagd77.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppbagd77.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 09:56:36AM +1030, Rusty Russell wrote:
>
> I'll have to pull the tree to review it properly, but the theory was
> that the reference count was counting users of the rng.  Now I don't
> know what it's counting:

The reference count starts off at zero, meaning that the RNG
has not been initialised.  It becomes one when we do hwrng_init.
After that each user adds/subtracts from it.  When it hits zero
we will clean it up and await for either deregistration or the
next hwrng_init.

> >  static inline int hwrng_init(struct hwrng *rng)
> >  {
> > +	if (kref_get_unless_zero(&rng->ref))
> > +		goto skip_init;
> > +
> >  	if (rng->init) {
> >  		int ret;
> 
> OK, so this skip_init branch is triggered when the rng is being
> shut down as it's no longer current_rng?

Right, if it triggers it means that we have already been initialised
previously and we have not yet executed cleanup on the RNG even
though at some point another RNG came in and became current_rng.

Bottom line is that this RNG is still good and we don't need to
(can't) initialise it.

> > +
> > +	kref_init(&rng->ref);
> > +	reinit_completion(&rng->cleanup_done);
> > +
> > +skip_init:
> >  	add_early_randomness(rng);
> 
> Then we use it to add randomness?

Honestly I don't care about whether we add randomness or not
in this case but this is what the code did before.  If you dislike
that feel free to send in a patch to kill this too.

> > @@ -467,6 +474,9 @@ int hwrng_register(struct hwrng *rng)
> >  			goto out_unlock;
> >  	}
> >  
> > +	init_completion(&rng->cleanup_done);
> > +	complete(&rng->cleanup_done);
> > +
> 
> This code smells very bad.

Well, it would smell better if someone added a helper that lets
you initialise a completion that is already complete :)

Point is the RNG must only be in two states.  Either it's the
current RNG in which case cleanup_done must be false/incomplete,
or it's not and cleanup_done must be either already complete or
will be complete at some point in the future.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
