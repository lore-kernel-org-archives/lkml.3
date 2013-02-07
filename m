Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945918Ab3BGWnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:43:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45545 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422729Ab3BGWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:43:46 -0500
Date: Thu, 7 Feb 2013 14:34:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
Message-ID: <20130207223434.GG2545@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1358896415-28569-1-git-send-email-walken@google.com>
 <1358896415-28569-2-git-send-email-walken@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358896415-28569-2-git-send-email-walken@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020722-2398-0000-0000-000010D6099C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 03:13:30PM -0800, Michel Lespinasse wrote:
> Introduce queue spinlocks, to be used in situations where it is desired
> to have good throughput even under the occasional high-contention situation.
> 
> This initial implementation is based on the classic MCS spinlock,
> because I think this represents the nicest API we can hope for in a
> fast queue spinlock algorithm. The MCS spinlock has known limitations
> in that it performs very well under high contention, but is not as
> good as the ticket spinlock under low contention. I will address these
> limitations in a later patch, which will propose an alternative,
> higher performance implementation using (mostly) the same API.
> 
> Sample use case acquiring mystruct->lock:
> 
>   struct q_spinlock_node node;
> 
>   q_spin_lock(&mystruct->lock, &node);
>   ...
>   q_spin_unlock(&mystruct->lock, &node);

It is possible to keep the normal API for MCS locks by having the lock
holder remember the parameter in the lock word itself.  While spinning,
the node is on the stack, is not needed once the lock is acquired.
The pointer to the next node in the queue -is- needed, but this can be
stored in the lock word.

I believe that John Stultz worked on something like this some years back,
so added him to CC.

							Thanx, Paul

> The q_spinlock_node must be used by a single lock holder / waiter and it must
> stay allocated for the entire duration when the lock is held (or waited on).
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> ---
>  arch/x86/include/asm/queue_spinlock.h |   20 ++++++++
>  include/asm-generic/queue_spinlock.h  |    7 +++
>  include/linux/queue_spinlock.h        |   61 ++++++++++++++++++++++++
>  kernel/Makefile                       |    2 +-
>  kernel/queue_spinlock.c               |   82 +++++++++++++++++++++++++++++++++
>  5 files changed, 171 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/queue_spinlock.h
>  create mode 100644 include/asm-generic/queue_spinlock.h
>  create mode 100644 include/linux/queue_spinlock.h
>  create mode 100644 kernel/queue_spinlock.c
> 
> diff --git a/arch/x86/include/asm/queue_spinlock.h b/arch/x86/include/asm/queue_spinlock.h
> new file mode 100644
> index 000000000000..655e01c1c2e8
> --- /dev/null
> +++ b/arch/x86/include/asm/queue_spinlock.h
> @@ -0,0 +1,20 @@
> +#ifndef _ASM_QUEUE_SPINLOCK_H
> +#define _ASM_QUEUE_SPINLOCK_H
> +
> +#if defined(CONFIG_X86_PPRO_FENCE) || defined(CONFIG_X86_OOSTORE)
> +
> +#define q_spin_lock_mb() mb()
> +#define q_spin_unlock_mb() mb()
> +
> +#else
> +
> +/*
> + * x86 memory ordering only needs compiler barriers to implement
> + * acquire load / release store semantics
> + */
> +#define q_spin_lock_mb() barrier()
> +#define q_spin_unlock_mb() barrier()
> +
> +#endif
> +
> +#endif /* _ASM_QUEUE_SPINLOCK_H */
> diff --git a/include/asm-generic/queue_spinlock.h b/include/asm-generic/queue_spinlock.h
> new file mode 100644
> index 000000000000..01fb9fbfb8dc
> --- /dev/null
> +++ b/include/asm-generic/queue_spinlock.h
> @@ -0,0 +1,7 @@
> +#ifndef _ASM_GENERIC_QUEUE_SPINLOCK_H
> +#define _ASM_GENERIC_QUEUE_SPINLOCK_H
> +
> +#define q_spin_lock_mb() mb()
> +#define q_spin_unlock_mb() mb()
> +
> +#endif /* _ASM_GENERIC_QUEUE_SPINLOCK_H */
> diff --git a/include/linux/queue_spinlock.h b/include/linux/queue_spinlock.h
> new file mode 100644
> index 000000000000..84b2470d232b
> --- /dev/null
> +++ b/include/linux/queue_spinlock.h
> @@ -0,0 +1,61 @@
> +#ifndef __LINUX_QUEUE_SPINLOCK_H
> +#define __LINUX_QUEUE_SPINLOCK_H
> +
> +#include <linux/bug.h>
> +
> +struct q_spinlock_node {
> +	struct q_spinlock_node *next;
> +	bool wait;
> +};
> +
> +struct q_spinlock {
> +	struct q_spinlock_node *node;
> +};
> +
> +#define __Q_SPIN_LOCK_UNLOCKED(name) { NULL }
> +
> +#ifdef CONFIG_SMP
> +
> +void q_spin_lock(struct q_spinlock *lock, struct q_spinlock_node *node);
> +void q_spin_lock_bh(struct q_spinlock *lock, struct q_spinlock_node *node);
> +void q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node);
> +void q_spin_unlock_bh(struct q_spinlock *lock, struct q_spinlock_node *node);
> +
> +static inline void q_spin_lock_init(struct q_spinlock *lock)
> +{
> +	lock->node = NULL;
> +}
> +
> +static inline void assert_q_spin_locked(struct q_spinlock *lock)
> +{
> +	BUG_ON(!lock->node);
> +}
> +
> +static inline void assert_q_spin_unlocked(struct q_spinlock *lock)
> +{
> +	BUG_ON(lock->node);
> +}
> +
> +#else /* !CONFIG_SMP */
> +
> +static inline void
> +q_spin_lock(struct q_spinlock *lock, struct q_spinlock_node *node) {}
> +
> +static inline void
> +q_spin_lock_bh(struct q_spinlock *lock, struct q_spinlock_node *node) {}
> +
> +static inline void
> +q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node) {}
> +
> +static inline void
> +q_spin_unlock_bh(struct q_spinlock *lock, struct q_spinlock_node *node) {}
> +
> +static inline void q_spin_lock_init(struct q_spinlock *lock) {}
> +
> +static inline void assert_q_spin_locked(struct q_spinlock *lock) {}
> +
> +static inline void assert_q_spin_unlocked(struct q_spinlock *lock) {}
> +
> +#endif /* CONFIG_SMP */
> +
> +#endif /* __LINUX_QUEUE_SPINLOCK_H */
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 86e3285ae7e5..ec91cfef4d4e 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -49,7 +49,7 @@ obj-$(CONFIG_SMP) += smp.o
>  ifneq ($(CONFIG_SMP),y)
>  obj-y += up.o
>  endif
> -obj-$(CONFIG_SMP) += spinlock.o
> +obj-$(CONFIG_SMP) += spinlock.o queue_spinlock.o
>  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
>  obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
>  obj-$(CONFIG_UID16) += uid16.o
> diff --git a/kernel/queue_spinlock.c b/kernel/queue_spinlock.c
> new file mode 100644
> index 000000000000..20304f0bc852
> --- /dev/null
> +++ b/kernel/queue_spinlock.c
> @@ -0,0 +1,82 @@
> +#include <linux/queue_spinlock.h>
> +#include <linux/export.h>
> +#include <linux/preempt.h>
> +#include <linux/bottom_half.h>
> +#include <asm/barrier.h>
> +#include <asm/processor.h>	/* for cpu_relax() */
> +#include <asm/queue_spinlock.h>
> +
> +static inline void
> +__q_spin_lock(struct q_spinlock *lock, struct q_spinlock_node *node)
> +{
> +	struct q_spinlock_node *prev;
> +
> +	node->next = NULL;
> +	prev = xchg(&lock->node, node);
> +	if (likely(!prev))
> +		/*
> +		 * Acquired the lock.
> +		 * xchg() already includes a full memory barrier.
> +		 */
> +		return;
> +
> +	node->wait = true;
> +	smp_wmb();
> +	ACCESS_ONCE(prev->next) = node;
> +	while (ACCESS_ONCE(node->wait))
> +		cpu_relax();
> +	q_spin_lock_mb();	/* guarantee acquire load semantics */
> +}
> +
> +static inline void
> +__q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node)
> +{
> +	struct q_spinlock_node *next;
> +	if (likely(!(next = ACCESS_ONCE(node->next)))) {
> +		/*
> +		 * Try to release lock.
> +		 * cmpxchg() already includes a full memory barrier.
> +		 */
> +		if (likely(cmpxchg(&lock->node, node, NULL) == node))
> +			return;
> +
> +		/*
> +		 * We raced with __q_spin_lock().
> +		 * Wait for next thread to be known.
> +		 */
> +		while (!(next = ACCESS_ONCE(node->next)))
> +			cpu_relax();
> +	}
> +	q_spin_unlock_mb();	/* guarantee release store semantics */
> +	ACCESS_ONCE(next->wait) = false;
> +}
> +
> +void q_spin_lock(struct q_spinlock *lock, struct q_spinlock_node *node)
> +{
> +	preempt_disable();
> +	__q_spin_lock(lock, node);
> +}
> +EXPORT_SYMBOL(q_spin_lock);
> +
> +void q_spin_lock_bh(struct q_spinlock *lock, struct q_spinlock_node *node)
> +{
> +	local_bh_disable();
> +	preempt_disable();
> +	__q_spin_lock(lock, node);
> +}
> +EXPORT_SYMBOL(q_spin_lock_bh);
> +
> +void q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node)
> +{
> +	__q_spin_unlock(lock, node);
> +	preempt_enable();
> +}
> +EXPORT_SYMBOL(q_spin_unlock);
> +
> +void q_spin_unlock_bh(struct q_spinlock *lock, struct q_spinlock_node *node)
> +{
> +	__q_spin_unlock(lock, node);
> +	preempt_enable_no_resched();
> +	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(q_spin_unlock_bh);
> -- 
> 1.7.7.3
> 

