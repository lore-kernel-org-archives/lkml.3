Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039AbaGRXfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:35:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59249 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932995AbaGRXfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:35:50 -0400
X-Sasl-enc: vG6bbAQXAypYXr2Z0V/Zp1sZI0xc4OJR6lthLzwNAOL8 1405726549
Message-ID: <1405726548.10838.34.camel@localhost>
Subject: Re: [PATCH] random: check for increase of entropy_count because of
 signed conversion
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, price@mit.edu
Date: Sat, 19 Jul 2014 01:35:48 +0200
In-Reply-To: <1405721239-2630-1-git-send-email-tytso@mit.edu>
References: <20140718215054.GD18775@thunk.org>
	 <1405721239-2630-1-git-send-email-tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fr, 2014-07-18 at 18:07 -0400, Theodore Ts'o wrote:
> From: Hannes Frederic Sowa <hannes@stressinduktion.org>
> 
> The expression entropy_count -= ibytes << (ENTROPY_SHIFT + 3) could
> actually increase entropy_count if during assignment of the unsigned
> expression on the RHS (mind the -=) we reduce the value modulo
> 2^width(int) and assign it to entropy_count. Trinity found this.
> 
> [ Commit modified by tytso to add an additional safety check for a
>   negative entropy_count -- which should never happen, and to also add
>   an additional paranoia check to prevent overly large count values to
>   be passed into urandom_read().  ]
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Cc: Greg Price <price@mit.edu>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  drivers/char/random.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 0a7ac0a..003f744 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -641,7 +641,7 @@ retry:
>  		} while (unlikely(entropy_count < pool_size-2 && pnfrac));
>  	}
>  
> -	if (entropy_count < 0) {
> +	if (unlikely(entropy_count < 0)) {
>  		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
>  			r->name, entropy_count);
>  		WARN_ON(1);
> @@ -981,7 +981,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
>  		      int reserved)
>  {
>  	int entropy_count, orig;
> -	size_t ibytes;
> +	size_t ibytes, nfrac;
>  
>  	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
>  
> @@ -999,7 +999,17 @@ retry:
>  	}
>  	if (ibytes < min)
>  		ibytes = 0;
> -	if ((entropy_count -= ibytes << (ENTROPY_SHIFT + 3)) < 0)
> +
> +	nfrac = ibytes << (ENTROPY_SHIFT + 3);
> +	if (entropy_count < 0) {

Minor nit: maybe also add an unlikely() here?

> +		pr_warn("random: negative entropy count: pool %s count %d\n",
> +			r->name, entropy_count);
> +		WARN_ON(1);
> +		entropy_count = 0;
> +	}
> +	if ((unsigned) entropy_count > nfrac)

(unsigned) -> (size_t)

size_t could also be (unsigned long) so the plain (unsigned) is
misleading.

(Maybe I wouldn't have done the cast at all, as we compile the kernel
with -Wno-sign-compare and we have the < 0 check right above, but I
don't have a strong opinion on that.)

> +		entropy_count -= nfrac;
> +	else
>  		entropy_count = 0;
>  
>  	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
> @@ -1376,6 +1386,7 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
>  			    "with %d bits of entropy available\n",
>  			    current->comm, nonblocking_pool.entropy_total);
>  
> +	nbytes = min_t(size_t, nbytes, INT_MAX >> ENTROPY_SHIFT);

Hmm, not sure, nfracs unit is 1/8 bits, so don't we have to limit nbytes
to INT_MAX >> (ENTROPY_SHIFT + 3) here?

And if we want to be even more correct here, we could switch from
INT_MAX to SIZE_MAX, as we do all nfrac calculations in the size_t
domain.

Maximum read/write size is SSIZE_MAX, so we don't need to care about
that, but if a user on a 64 bit machine requests INT_MAX bytes, we only
account/extract INT_MAX >> (ENTROPY_SHIFT + 3) bytes and cause a partial
read, though we actually could calulcate a correct nfrac for INT_MAX.
Because we don't have such large poolfragbits pools we would still
always end up with 0 while still allowing larger buffers to fill.

Hm, I just see that we should leave the INT_MAX limit just because of
the tracepoint.

Good catch,
Hannes

>  	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
>  
>  	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),



