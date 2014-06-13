Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaFMPl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:41:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:36228 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751283AbaFMPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:41:58 -0400
Date: Fri, 13 Jun 2014 11:41:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch V4 01/10] rtmutex: Plug slow unlock race
Message-ID: <20140613114155.41cf9ffa@gandalf.local.home>
In-Reply-To: <20140611183852.937945560@linutronix.de>
References: <20140611182944.108526809@linutronix.de>
	<20140611183852.937945560@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 18:44:04 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> @@ -671,10 +724,26 @@ static void wakeup_next_waiter(struct rt
>  	 */
>  	rt_mutex_dequeue_pi(current, waiter);
>  
> -	rt_mutex_set_owner(lock, NULL);
> +	/*
> +	 * This is safe versus the fastpath acquire:
> +	 *
> +	 * We do not remove the waiter from the lock waiter list
> +	 * here. It stays the top waiter.
> +	 *
> +	 * We set the owner to NULL, but keep the RT_MUTEX_HAS_WAITERS
> +	 * bit set, which forces all potential new waiters into the
> +	 * slow path. So they are serialized along with all enqueued
> +	 * waiters on lock->wait_lock.
> +	 */

The above comment is a little more complex than it needs to be. We can
probably just consider this an optimization. If we are waking up the
next waiter, this lock obviously has waiters, and the deleted
rt_mutex_set_owner(lock, NULL) would do the below anyway.

	/*
	 * As we are waking up the top waiter, and the waiter stays
	 * queued on the lock until it gets the lock, this lock
	 * obviously has waiters. Just set the bit here and this has
	 * the added benefit of forcing all new tasks into the
	 * slow path making sure no task of lower priority than
	 * the top waiter can steal this lock.
	 */

The rest looks good.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


> +	lock->owner = (void *) RT_MUTEX_HAS_WAITERS;
>  
>  	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
>  
> +	/*
> +	 * It's safe to dereference waiter as it cannot go away as
> +	 * long as we hold lock->wait_lock. The waiter task needs to
> +	 * acquire it in order to dequeue the waiter.
> +	 */
>  	wake_up_process(waiter->task);
>  }
>  
> @@ -928,12 +997,49 @@ rt_mutex_slowunlock(struct rt_mutex *loc
>  
>  	rt_mutex_deadlock_account_unlock(current);
>  
> -	if (!rt_mutex_has_waiters(lock)) {
> -		lock->owner = NULL;
> -		raw_spin_unlock(&lock->wait_lock);
> -		return;
> +	/*
> +	 * We must be careful here if the fast path is enabled. If we
> +	 * have no waiters queued we cannot set owner to NULL here
> +	 * because of:
> +	 *
> +	 * foo->lock->owner = NULL;
> +	 *			rtmutex_lock(foo->lock);   <- fast path
> +	 *			free = atomic_dec_and_test(foo->refcnt);
> +	 *			rtmutex_unlock(foo->lock); <- fast path
> +	 *			if (free)
> +	 *				kfree(foo);
> +	 * raw_spin_unlock(foo->lock->wait_lock);
> +	 *
> +	 * So for the fastpath enabled kernel:
> +	 *
> +	 * Nothing can set the waiters bit as long as we hold
> +	 * lock->wait_lock. So we do the following sequence:
> +	 *
> +	 *	owner = rt_mutex_owner(lock);
> +	 *	clear_rt_mutex_waiters(lock);
> +	 *	raw_spin_unlock(&lock->wait_lock);
> +	 *	if (cmpxchg(&lock->owner, owner, 0) == owner)
> +	 *		return;
> +	 *	goto retry;
> +	 *
> +	 * The fastpath disabled variant is simple as all access to
> +	 * lock->owner is serialized by lock->wait_lock:
> +	 *
> +	 *	lock->owner = NULL;
> +	 *	raw_spin_unlock(&lock->wait_lock);
> +	 */
> +	while (!rt_mutex_has_waiters(lock)) {
> +		/* Drops lock->wait_lock ! */
> +		if (unlock_rt_mutex_safe(lock) == true)
> +			return;
> +		/* Relock the rtmutex and try again */
> +		raw_spin_lock(&lock->wait_lock);
>  	}
>  
> +	/*
> +	 * The wakeup next waiter path does not suffer from the above
> +	 * race. See the comments there.
> +	 */
>  	wakeup_next_waiter(lock);
>  
>  	raw_spin_unlock(&lock->wait_lock);
> 

