Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3KTPb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:31:57 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:42879 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3KTPby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:31:54 -0500
Date: Wed, 20 Nov 2013 07:31:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Will Deacon <will.deacon@arm.com>, "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v6 4/5] MCS Lock: Barrier corrections
Message-ID: <20131120153123.GF4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1384885312.git.tim.c.chen@linux.intel.com>
 <1384911463.11046.454.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384911463.11046.454.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112015-7164-0000-0000-0000037C8C62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 05:37:43PM -0800, Tim Chen wrote:
> This patch corrects the way memory barriers are used in the MCS lock
> with smp_load_acquire and smp_store_release fucnction.
> It removes ones that are not needed.
> 
> It uses architecture specific load-acquire and store-release
> primitives for synchronization, if available. Generic implementations
> are provided in case they are not defined even though they may not
> be optimal. These generic implementation could be removed later on
> once changes are made in all the relevant header files.
> 
> Suggested-by: Michel Lespinasse <walken@google.com>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Signed-off-by: Jason Low <jason.low2@hp.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  kernel/locking/mcs_spinlock.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
> index 44fb092..6f2ce8e 100644
> --- a/kernel/locking/mcs_spinlock.c
> +++ b/kernel/locking/mcs_spinlock.c
> @@ -37,15 +37,19 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>  	node->locked = 0;
>  	node->next   = NULL;
> 
> +	/* xchg() provides a memory barrier */
>  	prev = xchg(lock, node);
>  	if (likely(prev == NULL)) {
>  		/* Lock acquired */
>  		return;
>  	}
>  	ACCESS_ONCE(prev->next) = node;
> -	smp_wmb();
> -	/* Wait until the lock holder passes the lock down */
> -	while (!ACCESS_ONCE(node->locked))
> +	/*
> +	 * Wait until the lock holder passes the lock down.
> +	 * Using smp_load_acquire() provides a memory barrier that
> +	 * ensures subsequent operations happen after the lock is acquired.
> +	 */
> +	while (!(smp_load_acquire(&node->locked)))
>  		arch_mutex_cpu_relax();
>  }
>  EXPORT_SYMBOL_GPL(mcs_spin_lock);
> @@ -68,7 +72,12 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>  		while (!(next = ACCESS_ONCE(node->next)))
>  			arch_mutex_cpu_relax();
>  	}
> -	ACCESS_ONCE(next->locked) = 1;
> -	smp_wmb();
> +	/*
> +	 * Pass lock to next waiter.
> +	 * smp_store_release() provides a memory barrier to ensure
> +	 * all operations in the critical section has been completed
> +	 * before unlocking.
> +	 */
> +	smp_store_release(&next->locked, 1);

However, there is one problem with this that I missed yesterday.

Documentation/memory-barriers.txt requires that an unlock-lock pair
provide a full barrier, but this is not guaranteed if we use
smp_store_release() for unlock and smp_load_acquire() for lock.
At least one of these needs a full memory barrier.

							Thanx, Paul

>  }
>  EXPORT_SYMBOL_GPL(mcs_spin_unlock);
> -- 
> 1.7.11.7
> 
> 
> 

