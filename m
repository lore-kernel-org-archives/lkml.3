Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaATPWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:22:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59413 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaATPWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:22:01 -0500
Date: Mon, 20 Jan 2014 16:21:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v9 1/5] qrwlock: A queue read/write lock implementation
Message-ID: <20140120152129.GH31570@twins.programming.kicks-ass.net>
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
 <1389761047-47566-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389761047-47566-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:44:03PM -0500, Waiman Long wrote:
> +#ifndef arch_mutex_cpu_relax
> +# define arch_mutex_cpu_relax() cpu_relax()
> +#endif

Include <linux/mutex.h>


> +#ifndef smp_load_acquire
> +# ifdef CONFIG_X86
> +#   define smp_load_acquire(p)				\
> +	({						\
> +		typeof(*p) ___p1 = ACCESS_ONCE(*p);	\
> +		barrier();				\
> +		___p1;					\
> +	})
> +# else
> +#   define smp_load_acquire(p)				\
> +	({						\
> +		typeof(*p) ___p1 = ACCESS_ONCE(*p);	\
> +		smp_mb();				\
> +		___p1;					\
> +	})
> +# endif
> +#endif
> +
> +#ifndef smp_store_release
> +# ifdef CONFIG_X86
> +#   define smp_store_release(p, v)			\
> +	do {						\
> +		barrier();				\
> +		ACCESS_ONCE(*p) = v;			\
> +	} while (0)
> +# else
> +#   define smp_store_release(p, v)			\
> +	do {						\
> +		smp_mb();				\
> +		ACCESS_ONCE(*p) = v;			\
> +	} while (0)
> +# endif
> +#endif

Remove these.

> +/*
> + * If an xadd (exchange-add) macro isn't available, simulate one with
> + * the atomic_add_return() function.
> + */
> +#ifdef xadd
> +# define qrw_xadd(rw, inc)	xadd(&(rw).rwc, inc)
> +#else
> +# define qrw_xadd(rw, inc)	(u32)(atomic_add_return(inc, &(rw).rwa) - inc)
> +#endif

Is GCC really so stupid that you cannot always use the
atomic_add_return()? The x86 atomic_add_return is i + xadd(), so you'll
end up with:

 i + xadd() - i

Surely it can just remove the two i terms?

> +/**
> + * wait_in_queue - Add to queue and wait until it is at the head
> + * @lock: Pointer to queue rwlock structure
> + * @node: Node pointer to be added to the queue
> + */
> +static inline void wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
> +{
> +	struct qrwnode *prev;
> +
> +	node->next = NULL;
> +	node->wait = true;
> +	prev = xchg(&lock->waitq, node);
> +	if (prev) {
> +		prev->next = node;
> +		/*
> +		 * Wait until the waiting flag is off
> +		 */
> +		while (smp_load_acquire(&node->wait))
> +			arch_mutex_cpu_relax();
> +	}
> +}

Please rebase on top of the MCS lock patches such that this is gone.
