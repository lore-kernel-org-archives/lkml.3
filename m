Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbaCZXSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 19:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaCZXSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 19:18:44 -0400
Message-ID: <53336049.4060901@redhat.com>
Date: Thu, 27 Mar 2014 00:18:33 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: davem@davemloft.net, hannes@stressinduktion.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] random32: avoid attempt to late reseed if in the middle
 of seeding
References: <1395853958-5083-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1395853958-5083-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 06:12 PM, Sasha Levin wrote:
> Commit 4af712e8df ("random32: add prandom_reseed_late() and call when
> nonblocking pool becomes initialized") has added a late reseed stage
> that happens as soon as the nonblocking pool is marked as initialized.
>
> This fails in the case that the nonblocking pool gets initialized
> during __prandom_reseed()'s call to get_random_bytes(). In that case
> we'd double back into __prandom_reseed() in an attempt to do a late
> reseed - deadlocking on 'lock' early on in the boot process.
>
> Instead, just avoid even waiting to do a reseed if a reseed is already
> occuring.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks for catching! (If you want Dave to pick it up, please also
Cc netdev.)

Why not via spin_trylock_irqsave() ? Thus, if we already hold the
lock, we do not bother any longer with doing the same work twice
and just return.

I.e. like:

static void __prandom_reseed(bool late)
{
     int i;
     unsigned long flags;
     static bool latch = false;
     static DEFINE_SPINLOCK(lock);

     /* Asking for random bytes might result in bytes getting
      * moved into the nonblocking pool and thus marking it
      * as initialized. In this case we would double back into
      * this function and attempt to do a late reseed.
      * Ignore the pointless attempt to reseed again if we're
      * already waiting for bytes when the nonblocking pool
      * got initialized.
      */

     /* only allow initial seeding (late == false) once */
     if (!spin_trylock_irqsave(&lock, flags))
         return;

     if (latch && !late)
         goto out;

     latch = true;

     for_each_possible_cpu(i) {
         struct rnd_state *state = &per_cpu(net_rand_state,i);
         u32 seeds[4];

         get_random_bytes(&seeds, sizeof(seeds));
         state->s1 = __seed(seeds[0],   2U);
         state->s2 = __seed(seeds[1],   8U);
         state->s3 = __seed(seeds[2],  16U);
         state->s4 = __seed(seeds[3], 128U);

         prandom_warmup(state);
     }
out:
     spin_unlock_irqrestore(&lock, flags);
}

> ---
>   lib/random32.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/lib/random32.c b/lib/random32.c
> index 1e5b2df..b59da12 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -241,14 +241,27 @@ static void __prandom_reseed(bool late)
>   {
>   	int i;
>   	unsigned long flags;
> -	static bool latch = false;
> +	static bool latch = false, reseeding = false;
>   	static DEFINE_SPINLOCK(lock);
>
> +	/*
> +	 * Asking for random bytes might result in bytes getting
> +	 * moved into the nonblocking pool and thus marking it
> +	 * as initialized. In this case we would double back into
> +	 * this function and attempt to do a late reseed.
> +	 * Ignore the pointless attempt to reseed again if we're
> +	 * already waiting for bytes when the nonblocking pool
> +	 * got initialized
> +	 */
> +	if (reseeding)
> +		return;
> +
>   	/* only allow initial seeding (late == false) once */
>   	spin_lock_irqsave(&lock, flags);
>   	if (latch && !late)
>   		goto out;
>   	latch = true;
> +	reseeding = true;
>
>   	for_each_possible_cpu(i) {
>   		struct rnd_state *state = &per_cpu(net_rand_state,i);
> @@ -263,6 +276,7 @@ static void __prandom_reseed(bool late)
>   		prandom_warmup(state);
>   	}
>   out:
> +	reseeding = false;
>   	spin_unlock_irqrestore(&lock, flags);
>   }
>
>
