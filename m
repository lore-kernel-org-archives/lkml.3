Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaFMP6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:58:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:62800 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbaFMP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:58:11 -0400
Date: Fri, 13 Jun 2014 11:58:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch V4 02/10] rtmutex: Simplify rtmutex_slowtrylock()
Message-ID: <20140613115809.2b032402@gandalf.local.home>
In-Reply-To: <20140611183853.029651737@linutronix.de>
References: <20140611182944.108526809@linutronix.de>
	<20140611183853.029651737@linutronix.de>
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

> Oleg noticed that rtmutex_slowtrylock() has a pointless check for
> rt_mutex_owner(lock) != current.
> 
> To avoid calling try_to_take_rtmutex() we really want to check whether
> the lock has an owner at all or whether the trylock failed because the
> owner is NULL, but the RT_MUTEX_HAS_WAITERS bit is set. This covers
> the lock is owned by caller situation as well.
> 
> We can actually do this check lockless. trylock is taking a chance
> whether we take lock->wait_lock to do the check or not.
> 
> Add comments to the function while at it.
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/rtmutex.c |   32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -963,22 +963,32 @@ rt_mutex_slowlock(struct rt_mutex *lock,
>  /*
>   * Slow path try-lock function:
>   */
> -static inline int
> -rt_mutex_slowtrylock(struct rt_mutex *lock)
> +static inline int rt_mutex_slowtrylock(struct rt_mutex *lock)
>  {
> -	int ret = 0;
> +	int ret;
>  
> +	/*
> +	 * trylock is taking a chance. So we dont have to take
> +	 * @lock->wait_lock to figure out whether @lock has a real or

"whether @lock has a real"

 real what?

> +	 * if @lock owner is NULL and the RT_MUTEX_HAS_WAITERS bit is
> +	 * set.

I don't understand the above. As rt_mutex_owner() will ignore the
RT_MUTEX_HAS_WAITERS bit.


I think a simple comment is good enough:

	/*
	 * If the lock already has an owner we fail to get the lock.
	 * This can be done without taking the @lock->wait_lock as
	 * it is only being read, and this is a trylock anyway.
> +	 */
> +	if (rt_mutex_owner(lock))
> +		return 0;
> +
> +	/*
> +	 * The mutex has currently no owner. Lock the wait lock and
> +	 * try to acquire the lock.
> +	 */
>  	raw_spin_lock(&lock->wait_lock);
>  
> -	if (likely(rt_mutex_owner(lock) != current)) {
> +	ret = try_to_take_rt_mutex(lock, current, NULL);
>  
> -		ret = try_to_take_rt_mutex(lock, current, NULL);
> -		/*
> -		 * try_to_take_rt_mutex() sets the lock waiters
> -		 * bit unconditionally. Clean this up.
> -		 */
> -		fixup_rt_mutex_waiters(lock);
> -	}
> +	/*
> +	 * try_to_take_rt_mutex() sets the lock waiters bit
> +	 * unconditionally. Clean this up.
> +	 */
> +	fixup_rt_mutex_waiters(lock);

Rest looks good.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  
>  	raw_spin_unlock(&lock->wait_lock);
>  
> 

