Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab3C1QRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:17:45 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:49369 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3C1QRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:17:43 -0400
Message-ID: <1364487442.3559.3.camel@thor.lan>
Subject: Re: [PATCH v2 11/13] rwsem: implement support for write lock
 stealing on the fastpath
From: Peter Hurley <peter@hurleysoftware.com>
To: Michel Lespinasse <walken@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 12:17:22 -0400
In-Reply-To: <1363344869-15732-12-git-send-email-walken@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
	 <1363344869-15732-12-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2013-03-15 at 03:54 -0700, Michel Lespinasse wrote:
> When we decide to wake up readers, we must first grant them as many
> read locks as necessary, and then actually wake up all these readers.
> But in order to know how many read shares to grant, we must first
> count the readers at the head of the queue. This might take a while
> if there are many readers, and we want to be protected against a
> writer stealing the lock while we're counting. To that end, we grant
> the first reader lock before counting how many more readers are queued.
> 
> We also require some adjustments to the wake_type semantics.
> 
> RWSEM_WAKE_NO_ACTIVE used to mean that we had found the count to
> be RWSEM_WAITING_BIAS, in which case the rwsem was known to be free
> as nobody could steal it while we hold the wait_lock. This doesn't
> make sense once we implement fastpath write lock stealing, so we now
> use RWSEM_WAKE_ANY in that case.
> 
> Similarly, when rwsem_down_write_failed found that a read lock was active,
> it would use RWSEM_WAKE_READ_OWNED which signalled that new readers could
> be woken without checking first that the rwsem was available. We can't do
> that anymore since the existing readers might release their read locks,
> and a writer could steal the lock before we wake up additional readers.
> So, we have to use a new RWSEM_WAKE_READERS value to indicate we only want
> to wake readers, but we don't currently hold any read lock.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> ---
>  lib/rwsem.c | 63 ++++++++++++++++++++++++++++++-------------------------------
>  1 file changed, 31 insertions(+), 32 deletions(-)
> 
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index 9a675fa9d78e..09bf03e7808c 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -41,13 +41,11 @@ struct rwsem_waiter {
>  	enum rwsem_waiter_type type;
>  };
>  
> -/* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
> - * RWSEM_WAKE_READ_OWNED imply that the spinlock must have been kept held
> - * since the rwsem value was observed.
> - */
> -#define RWSEM_WAKE_ANY        0 /* Wake whatever's at head of wait list */
> -#define RWSEM_WAKE_NO_ACTIVE  1 /* rwsem was observed with no active thread */
> -#define RWSEM_WAKE_READ_OWNED 2 /* rwsem was observed to be read owned */
> +enum rwsem_wake_type {
> +	RWSEM_WAKE_ANY,		/* Wake whatever's at head of wait list */
> +	RWSEM_WAKE_READERS,	/* Wake readers only */
> +	RWSEM_WAKE_READ_OWNED	/* Waker thread holds the read lock */
> +};
>  
>  /*
>   * handle the lock release when processes blocked on it that can now run
> @@ -60,16 +58,16 @@ struct rwsem_waiter {
>   * - writers are only woken if downgrading is false
>   */
>  static struct rw_semaphore *
> -__rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
> +__rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
>  {
>  	struct rwsem_waiter *waiter;
>  	struct task_struct *tsk;
>  	struct list_head *next;
> -	signed long woken, loop, adjustment;
> +	signed long oldcount, woken, loop, adjustment;
>  
>  	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
>  	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
> -		if (wake_type != RWSEM_WAKE_READ_OWNED)
> +		if (wake_type == RWSEM_WAKE_ANY)
>  			/* Wake writer at the front of the queue, but do not
>  			 * grant it the lock yet as we want other writers
>  			 * to be able to steal it.  Readers, on the other hand,
> @@ -79,24 +77,24 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
>  		goto out;
>  	}
>  
> -	/* If we come here from up_xxxx(), another thread might have reached
> -	 * rwsem_down_failed_common() before we acquired the spinlock and
> -	 * woken up a waiter, making it now active.  We prefer to check for
> -	 * this first in order to not spend too much time with the spinlock
> -	 * held if we're not going to be able to wake up readers in the end.
> -	 *
> -	 * Note that we do not need to update the rwsem count: any writer
> -	 * trying to acquire rwsem will run rwsem_down_write_failed() due
> -	 * to the waiting threads and block trying to acquire the spinlock.
> -	 *
> -	 * We use a dummy atomic update in order to acquire the cache line
> -	 * exclusively since we expect to succeed and run the final rwsem
> -	 * count adjustment pretty soon.
> +	/* Writers might steal the lock before we grant it to the next reader.
> +	 * We prefer to do the first reader grant before counting readers
> +	 * so we can bail out early if a writer stole the lock.
>  	 */
> -	if (wake_type == RWSEM_WAKE_ANY &&
> -	    rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS)
> -		/* Someone grabbed the sem for write already */
> -		goto out;
> +	adjustment = 0;
> +	if (wake_type != RWSEM_WAKE_READ_OWNED) {
> +		adjustment = RWSEM_ACTIVE_READ_BIAS;
> + try_reader_grant:
> +		oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
> +		if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
> +			/* A writer stole the lock. Undo our reader grant. */
> +			if (rwsem_atomic_update(-adjustment, sem) &
> +						RWSEM_ACTIVE_MASK)
> +				goto out;
> +			/* Last active locker left. Retry waking readers. */
> +			goto try_reader_grant;
> +		}

I'm not a big fan of goto loops (though I know they were in here
before). The equivalent solution by factoring:

		if (!__rwsem_try_reader_grant(sem, adjustment))
			goto out;


static inline int __rwsem_try_reader_grant(struct rw_semaphore *sem, long adj)
{
	while (1) {
		long count = rwsem_atomic_update(adj, sem) - adj;
		if (likely(count >= RWSEM_WAITING_BIAS))
			break;

		/* A writer stole the lock. Undo our reader grant. */
		if (rwsem_atomic_update(-adj, sem) & RWSEM_ACTIVE_MASK)
			return 0;
		/* Last active locker left. Retry waking readers. */
	}
	return 1;
}

Everything else here looks good.

> +	}
>  
>  	/* Grant an infinite number of read locks to the readers at the front
>  	 * of the queue.  Note we increment the 'active part' of the count by
> @@ -114,12 +112,13 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
>  
>  	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
>  
> -	adjustment = woken * RWSEM_ACTIVE_READ_BIAS;
> +	adjustment = woken * RWSEM_ACTIVE_READ_BIAS - adjustment;
>  	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
>  		/* hit end of list above */
>  		adjustment -= RWSEM_WAITING_BIAS;
>  
> -	rwsem_atomic_add(adjustment, sem);
> +	if (adjustment)
> +		rwsem_atomic_add(adjustment, sem);
>  
>  	next = sem->wait_list.next;
>  	loop = woken;
> @@ -164,8 +163,8 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
>  	count = rwsem_atomic_update(adjustment, sem);
>  
>  	/* If there are no active locks, wake the front queued process(es). */
> -	if (count == RWSEM_WAITING_BIAS)
> -		sem = __rwsem_do_wake(sem, RWSEM_WAKE_NO_ACTIVE);
> +	if (!(count & RWSEM_ACTIVE_MASK))
> +		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
>  
>  	raw_spin_unlock_irq(&sem->wait_lock);
>  
> @@ -209,7 +208,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
>  	 * any read locks that were queued ahead of us. */
>  	if (count > RWSEM_WAITING_BIAS &&
>  	    adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
> -		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
> +		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
>  
>  	/* wait until we successfully acquire the lock */
>  	set_task_state(tsk, TASK_UNINTERRUPTIBLE);



