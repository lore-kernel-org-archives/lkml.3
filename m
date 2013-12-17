Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3LQTYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:24:09 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56044 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3LQTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:24:06 -0500
Date: Tue, 17 Dec 2013 11:23:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v7 3/4] qrwlock: Use the mcs_spinlock helper functions
 for MCS queuing
Message-ID: <20131217192359.GC15969@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
 <1385147087-26588-4-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385147087-26588-4-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121719-1542-0000-0000-00000459988E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 02:04:46PM -0500, Waiman Long wrote:
> There is a pending MCS lock patch series that adds generic MCS lock
> helper functions to do MCS-style locking. This patch will enable
> the queue rwlock to use that generic MCS lock/unlock primitives for
> internal queuing. This patch should only be merged after the merging
> of that generic MCS locking patch.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/asm-generic/qrwlock.h |    7 +--
>  kernel/locking/qrwlock.c      |   83 +++-------------------------------------
>  2 files changed, 9 insertions(+), 81 deletions(-)
> 
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> index 9d085cb..335473a 100644
> --- a/include/asm-generic/qrwlock.h
> +++ b/include/asm-generic/qrwlock.h
> @@ -37,10 +37,7 @@
>   * the writer field. The least significant 8 bits is the writer field
>   * whereas the remaining 24 bits is the reader count.
>   */
> -struct qrwnode {
> -	struct qrwnode *next;
> -	bool		wait;	/* Waiting flag */
> -};
> +struct mcs_spinlock;
> 
>  typedef struct qrwlock {
>  	union qrwcnts {
> @@ -55,7 +52,7 @@ typedef struct qrwlock {
>  		};
>  		u32	rw;		/* Reader/writer number pair */
>  	} cnts;
> -	struct qrwnode *waitq;		/* Tail of waiting queue */
> +	struct mcs_spinlock *waitq;	/* Tail of waiting queue */
>  } arch_rwlock_t;
> 
>  /*
> diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> index ea5553d..b3e5c2b 100644
> --- a/kernel/locking/qrwlock.c
> +++ b/kernel/locking/qrwlock.c
> @@ -20,6 +20,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/percpu.h>
>  #include <linux/hardirq.h>
> +#include <linux/mcs_spinlock.h>
>  #include <asm-generic/qrwlock.h>
> 
>  /*
> @@ -55,76 +56,6 @@
>  # endif
>  #endif
> 
> -#ifndef smp_mb__store_release
> -# ifdef CONFIG_X86
> -#   define smp_mb__store_release()	barrier()
> -# else
> -#   define smp_mb__store_release()	smp_mb()
> -# endif
> -#endif
> -
> -/**
> - * wait_in_queue - Add to queue and wait until it is at the head
> - * @lock: Pointer to queue rwlock structure
> - * @node: Node pointer to be added to the queue
> - */
> -static __always_inline void
> -wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
> -{
> -	struct qrwnode *prev;
> -
> -	node->next = NULL;
> -	node->wait = true;
> -	prev = xchg(&lock->waitq, node);
> -	if (prev) {
> -		prev->next = node;
> -		/*
> -		 * Wait until the waiting flag is off
> -		 */
> -		while (ACCESS_ONCE(node->wait))
> -			arch_mutex_cpu_relax();
> -		smp_mb__load_acquire();
> -	}
> -}
> -
> -/**
> - * signal_next - Signal the next one in queue to be at the head
> - * @lock: Pointer to queue rwlock structure
> - * @node: Node pointer to the current head of queue
> - */
> -static __always_inline void
> -signal_next(struct qrwlock *lock, struct qrwnode *node)
> -{
> -	struct qrwnode *next;
> -
> -	/*
> -	 * Try to notify the next node first without disturbing the cacheline
> -	 * of the lock. If that fails, check to see if it is the last node
> -	 * and so should clear the wait queue.
> -	 */
> -	next = ACCESS_ONCE(node->next);
> -	if (likely(next))
> -		goto notify_next;
> -
> -	/*
> -	 * Clear the wait queue if it is the last node
> -	 */
> -	if ((ACCESS_ONCE(lock->waitq) == node) &&
> -	    (cmpxchg(&lock->waitq, node, NULL) == node))
> -			return;
> -	/*
> -	 * Wait until the next one in queue set up the next field
> -	 */
> -	while (likely(!(next = ACCESS_ONCE(node->next))))
> -		arch_mutex_cpu_relax();
> -	/*
> -	 * The next one in queue is now at the head
> -	 */
> -notify_next:
> -	smp_mb__store_release();
> -	ACCESS_ONCE(next->wait) = false;
> -}
> -
>  /**
>   * rspin_until_writer_unlock - inc reader count & spin until writer is gone
>   * @lock: Pointer to queue rwlock structure
> @@ -148,7 +79,7 @@ rspin_until_writer_unlock(struct qrwlock *lock, union qrwcnts cnts)
>   */
>  void queue_read_lock_slowpath(struct qrwlock *lock)
>  {
> -	struct qrwnode node;
> +	struct mcs_spinlock node;
>  	union qrwcnts cnts;
> 
>  	/*
> @@ -168,7 +99,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
>  	/*
>  	 * Put the reader into the wait queue
>  	 */
> -	wait_in_queue(lock, &node);
> +	mcs_spin_lock(&lock->waitq, &node);
> 
>  	/*
>  	 * At the head of the wait queue now, wait until the writer state
> @@ -183,7 +114,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
>  	 * Need to have a barrier with read-acquire semantics
>  	 */
>  	smp_mb__load_acquire();
> -	signal_next(lock, &node);
> +	mcs_spin_unlock(&lock->waitq, &node);
>  }
>  EXPORT_SYMBOL(queue_read_lock_slowpath);
> 
> @@ -247,12 +178,12 @@ static noinline int queue_write_3step_lock(struct qrwlock *lock)
>   */
>  void queue_write_lock_slowpath(struct qrwlock *lock)
>  {
> -	struct qrwnode node;
> +	struct mcs_spinlock node;
> 
>  	/*
>  	 * Put the writer into the wait queue
>  	 */
> -	wait_in_queue(lock, &node);
> +	mcs_spin_lock(&lock->waitq, &node);
> 
>  	/*
>  	 * At the head of the wait queue now, call queue_write_3step_lock()
> @@ -260,6 +191,6 @@ void queue_write_lock_slowpath(struct qrwlock *lock)
>  	 */
>  	while (!queue_write_3step_lock(lock))
>  		arch_mutex_cpu_relax();
> -	signal_next(lock, &node);
> +	mcs_spin_unlock(&lock->waitq, &node);
>  }
>  EXPORT_SYMBOL(queue_write_lock_slowpath);
> -- 
> 1.7.1
> 

