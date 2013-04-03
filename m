Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743Ab3DCMhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:37:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:38246 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759408Ab3DCMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:37:05 -0400
Date: Wed, 3 Apr 2013 14:36:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] timer: Fix possible issues with non serialized timer_pending(
 )
In-Reply-To: <1364553218-31255-1-git-send-email-vgupta@synopsys.com>
Message-ID: <alpine.LFD.2.02.1304031433350.21884@ionos>
References: <1364553218-31255-1-git-send-email-vgupta@synopsys.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet,

On Fri, 29 Mar 2013, Vineet Gupta wrote:

> When stress testing ARC Linux from 3.9-rc3, we've hit a serialization
> issue when mod_timer() races with itself. This is on a FPGA board and
> kernel .config among others has !SMP and !PREEMPT_COUNT.
> 
> The issue happens in mod_timer( ) because timer_pending( ) based early
> exit check is NOT done inside the timer base spinlock - as a networking
> optimization.
> 
> The value used in there, timer->entry.next is also used further in call
> chain (all inlines though) for actual list manipulation. However if the
> register containing this pointer remains live across the spinlock (in a
> UP setup with !PREEMPT_COUNT there's nothing forcing gcc to reload) then
> a stale value of next pointer causes incorrect list manipulation,
> observed with following sequence in our tests.
> 
> (0). tv1[x] <----> t1 <---> t2
> (1). mod_timer(t1) interrupted after it calls timer_pending()
> (2). mod_timer(t2) completes
> (3). mod_timer(t1) resumes but messes up the list.
> (4). __runt_timers( ) uses bogus timer_list entry / crashes in
>      timer->function
> 
> The simplest fix is to NOT rely on spinlock based compiler barrier but
> add an explicit one in timer_pending()

That's simple, but dangerous. There is other code which relies on the
implicit barriers of spinlocks, so I think we need to add the barrier
to the !PREEMPT_COUNT implementation of preempt_*() macros.

Thanks,

	tglx

> FWIW, the relevant ARCompact disassembly of mod_timer which clearly
> shows the issue due to register reuse is:
> 
> mod_timer:
>     push_s blink
>     mov_s r13,r0	# timer, timer
> 
> ...
>     ###### timer_pending( )
>     ld_s r3,[r13]       # <------ <variable>.entry.next LOADED
>     brne r3, 0, @.L163
> 
> .L163:
> ....
>     ###### spin_lock_irq( )
>     lr  r5, [status32]  # flags
>     bic r4, r5, 6       # temp, flags,
>     and.f 0, r5, 6      # flags,
>     flag.nz r4
> 
>     ###### detach_if_pending( ) begins
> 
>     tst_s r3,r3  <--------------
> 			# timer_pending( ) checks timer->entry.next
>                         # r3 is NOT reloaded by gcc, using stale value
>     beq.d @.L169
>     mov.eq r0,0
> 
>     #  detach_timer( ): __list_del( )
> 
>     ld r4,[r13,4]    	# <variable>.entry.prev, D.31439
>     st r4,[r3,4]     	# <variable>.prev, D.31439
>     st r3,[r4]       	# <variable>.next, D.30246
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Reported-by: Christian Ruppert <christian.ruppert@abilis.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Christian Ruppert <christian.ruppert@abilis.com>
> Cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/timer.h |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/timer.h b/include/linux/timer.h
> index 8c5a197..1537104 100644
> --- a/include/linux/timer.h
> +++ b/include/linux/timer.h
> @@ -168,7 +168,16 @@ static inline void init_timer_on_stack_key(struct timer_list *timer,
>   */
>  static inline int timer_pending(const struct timer_list * timer)
>  {
> -	return timer->entry.next != NULL;
> +	int pending = timer->entry.next != NULL;
> +
> +	/*
> +	 * The check above enables timer fast path - early exit.
> +	 * However most of the call sites are not protected by timer->base
> +	 * spinlock. If the caller (say mod_timer) races with itself, it
> +	 * can use the stale "next" pointer. See commit log for details.
> +	 */
> +	barrier();
> +	return pending;
>  }
>  
>  extern void add_timer_on(struct timer_list *timer, int cpu);
> -- 
> 1.7.10.4
> 
> 
