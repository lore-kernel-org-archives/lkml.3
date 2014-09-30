Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaI3TGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:06:18 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55623 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaI3TGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:06:17 -0400
Date: Tue, 30 Sep 2014 21:06:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        umgwanakikbuti@gmail.com, akpm@linux-foundation.org, srao@redhat.com,
        lwoodman@redhat.com, atheurer@redhat.com, oleg@redhat.com,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched, time: fix build error with 64 bit cputime_t on 32
 bit systems
Message-ID: <20140930190611.GA5702@lerouge>
References: <2547036.UshV4pXvhf@wuerfel>
 <20140930134011.232bc7bf@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930134011.232bc7bf@annuminas.surriel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 01:40:11PM -0400, Rik van Riel wrote:
> On Tue, 30 Sep 2014 13:56:37 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > A recent change to update the stime/utime members of task_struct
> > using atomic cmpxchg broke configurations on 32-bit machines with
> > CONFIG_VIRT_CPU_ACCOUNTING_GEN set, because that uses 64-bit
> > nanoseconds, leading to a link-time error:
> > 
> > kernel/built-in.o: In function `cputime_adjust':
> > :(.text+0x25234): undefined reference to `__bad_cmpxchg'
> 
> Arnd, this should fix your problem, while still ensuring that
> the cpu time counters only ever go forward.
> 
> I do not have cross compiling toolchains set up here, but I assume
> this fixes your bug.
> 
> Ingo & Peter, if this patch fixes the bug for Arnd, could you please
> merge it into -tip?
> 
> Linus, the changeset causing the problem is only in -tip right now,
> and this patch will not apply to your tree.
> 
> ---8<---
> 
> Subject: sched,time: fix build error with 64 bit cputime_t on 32 bit systems
> 
> On 32 bit systems cmpxchg cannot handle 64 bit values, and
> cmpxchg64 needs to be used when full dynticks CPU accounting
> is enabled, since that turns cputime_t into a u64.
> 
> With jiffies based CPU accounting, cputime_t is an unsigned
> long. On 64 bit systems, cputime_t is always the size of a
> long.
> 
> Luckily the compiler can figure out whether we need to call
> cmpxchg or cmpxchg64.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  kernel/sched/cputime.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 64492df..db239c9 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -555,6 +555,29 @@ static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
>  }
>  
>  /*
> + * Atomically advance counter to the new value. Interrupts, vcpu
> + * scheduling, and scaling inaccuracies can cause cputime_advance
> + * to be occasionally called with a new value smaller than counter.
> + * Let's enforce atomicity.
> + *
> + * Normally a caller will only go through this loop once, or not
> + * at all in case a previous caller updated counter the same jiffy.
> + */
> +static void cputime_advance(cputime_t *counter, cputime_t new)
> +{
> +	cputime_t old;
> +
> +	while (new > (old = ACCESS_ONCE(*counter))) {
> +		/* The compiler will optimize away this branch.  */
> +		if (sizeof(cputime_t) == sizeof(long))
> +			cmpxchg(counter, old, new);
> +		else
> +			/* 64 bit cputime_t on a 32 bit system... */
> +			cmpxchg64(counter, old, new);

Maybe cmpxchg() should itself be a wrapper that does this build time choice
between cmpxchg32() and cmpxchg64().

And if it looks too dangerous to convert all users, this could be cmpxchg_t().

> +	}
> +}
> +
> +/*
>   * Adjust tick based cputime random precision against scheduler
>   * runtime accounting.
>   */
> @@ -599,16 +622,8 @@ static void cputime_adjust(struct task_cputime *curr,
>  		utime = rtime - stime;
>  	}
>  
> -	/*
> -	 * If the tick based count grows faster than the scheduler one,
> -	 * the result of the scaling may go backward.
> -	 * Let's enforce monotonicity.
> -	 * Atomic exchange protects against concurrent cputime_adjust().
> -	 */
> -	while (stime > (rtime = ACCESS_ONCE(prev->stime)))
> -		cmpxchg(&prev->stime, rtime, stime);
> -	while (utime > (rtime = ACCESS_ONCE(prev->utime)))
> -		cmpxchg(&prev->utime, rtime, utime);
> +	cputime_advance(&prev->stime, stime);
> +	cputime_advance(&prev->utime, utime);
>  
>  out:
>  	*ut = prev->utime;
