Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3AZMD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:03:28 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:47709 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab3AZMDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:03:25 -0500
Date: Sat, 26 Jan 2013 13:03:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH -v4 3/5] x86,smp: auto tune spinlock backoff delay factor
Message-ID: <20130126120320.GC13445@gmail.com>
References: <20130125140553.060b8ced@annuminas.surriel.com>
 <20130125141751.1cf3ca0b@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125141751.1cf3ca0b@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> Many spinlocks are embedded in data structures; having many CPUs
> pounce on the cache line the lock is in will slow down the lock
> holder, and can cause system performance to fall off a cliff.
> 
> The paper "Non-scalable locks are dangerous" is a good reference:
> 
> 	http://pdos.csail.mit.edu/papers/linux:lock.pdf
> 
> In the Linux kernel, spinlocks are optimized for the case of
> there not being contention. After all, if there is contention,
> the data structure can be improved to reduce or eliminate
> lock contention.
> 
> Likewise, the spinlock API should remain simple, and the
> common case of the lock not being contended should remain
> as fast as ever.
> 
> However, since spinlock contention should be fairly uncommon,
> we can add functionality into the spinlock slow path that keeps
> system performance from falling off a cliff when there is lock
> contention.
> 
> Proportional delay in ticket locks is delaying the time between
> checking the ticket based on a delay factor, and the number of
> CPUs ahead of us in the queue for this lock. Checking the lock
> less often allows the lock holder to continue running, resulting
> in better throughput and preventing performance from dropping
> off a cliff.
> 
> Proportional spinlock delay with a high delay factor works well
> when there is lots contention on a lock. Likewise, a smaller
> delay factor works well when a lock is lightly contended.
> 
> Making the code auto-tune the delay factor results in a system
> that performs well with both light and heavy lock contention.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Acked-by: Rafael Aquini <aquini@redhat.com>
> Reviewed-by: Michel Lespinasse <walken@google.com>
> ---
>  arch/x86/kernel/smp.c |   43 +++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index aa743e9..05f828b 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -113,13 +113,34 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
>  static bool smp_no_nmi_ipi = false;
>  
>  /*
> - * Wait on a congested ticket spinlock.
> + * Wait on a congested ticket spinlock. Many spinlocks are embedded in
> + * data structures; having many CPUs pounce on the cache line with the
> + * spinlock simultaneously can slow down the lock holder, and the system
> + * as a whole.
> + *
> + * To prevent total performance collapse in case of bad spinlock contention,
> + * perform proportional backoff. The per-cpu value of delay is automatically
> + * tuned to limit the number of times spinning CPUs poll the lock before
> + * obtaining it. This limits the amount of cross-CPU traffic required to obtain
> + * a spinlock, and keeps system performance from dropping off a cliff.
> + *
> + * There is a tradeoff. If we poll too often, the whole system is slowed
> + * down. If we sleep too long, the lock will go unused for a period of
> + * time. The solution is to go for a fast spin if we are at the head of
> + * the queue, to slowly increase the delay if we sleep for too short a
> + * time, and to decrease the delay if we slept for too long.
>   */
> +#define DELAY_SHIFT 8
> +#define DELAY_FIXED_1 (1<<DELAY_SHIFT)
> +#define MIN_SPINLOCK_DELAY (1 * DELAY_FIXED_1)
> +#define MAX_SPINLOCK_DELAY (16000 * DELAY_FIXED_1)
> +DEFINE_PER_CPU(unsigned, spinlock_delay) = { MIN_SPINLOCK_DELAY };

This one's ugly too, in several ways, please improve it.

> +		if (head == ticket) {
> +			/*
> +			 * We overslept, and do not know by how.

s/by how./by how much.

Thanks,

	Ingo
