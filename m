Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaAPDJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:09:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaAPDJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:09:32 -0500
Message-ID: <1389841737.5418.14.camel@marge.simpson.net>
Subject: Re: [PATCH RT 4/8] rtmutex: use a trylock for waiter lock in trylock
From: Mike Galbraith <bitbucket@online.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 16 Jan 2014 04:08:57 +0100
In-Reply-To: <20140116020324.637491369@goodmis.org>
References: <20140116015824.201732155@goodmis.org>
	 <20140116020324.637491369@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:uiiUDs9wwMohQOz4MUxqJ3Q5JOhyesgMXvhrKG82G9L
 bH6g0xVAlEsJmdO0cEHoRljDfLwkwFhGn/VIqVJ+A8Ame5RWV3
 4uMVRN5C9jjg2L4Nq5EaULtMijggBnbCIKDN/DfhXwp+Y9JI1U
 KQXIyPoEtIKHInQMEQEeKC739yAvjh2ctEt1fbTz1vLIuTwl4Q
 XJ3hoUbfTNNLJO0Hd/eIZIhZ15342Tcxx6GYyGBwQm8gAqa1fa
 wVITbod85dnEqPPm8TVP14+81UWxGpyhVjBFE5UIQJGmSY6HOz
 iKyOgEB+HXRDPf/LvvqfaXUEGqXzehjs82XBN0UQaVVV/l1buj
 mpvfGsTvOAC6XeGLyh16QycN+RO8t+V5xXhmfJ2wmXaVcipqhR
 a9UI6syOk4/OQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 20:58 -0500, Steven Rostedt wrote:


> 3.2.53-rt76-rc1 stable review patch.
> If anyone has any objections, please let me know.

Not sure this is needed without the tglx don't unconditionally raise
timer softirq patch, and with that patch applied in the form it exists
in 3.12-rt9, as well as this one, you'll still eventually deadlock.

> ------------------
> 
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Mike Galbraith captered the following:
> | >#11 [ffff88017b243e90] _raw_spin_lock at ffffffff815d2596
> | >#12 [ffff88017b243e90] rt_mutex_trylock at ffffffff815d15be
> | >#13 [ffff88017b243eb0] get_next_timer_interrupt at ffffffff81063b42
> | >#14 [ffff88017b243f00] tick_nohz_stop_sched_tick at ffffffff810bd1fd
> | >#15 [ffff88017b243f70] tick_nohz_irq_exit at ffffffff810bd7d2
> | >#16 [ffff88017b243f90] irq_exit at ffffffff8105b02d
> | >#17 [ffff88017b243fb0] reschedule_interrupt at ffffffff815db3dd
> | >--- <IRQ stack> ---
> | >#18 [ffff88017a2a9bc8] reschedule_interrupt at ffffffff815db3dd
> | >    [exception RIP: task_blocks_on_rt_mutex+51]
> | >#19 [ffff88017a2a9ce0] rt_spin_lock_slowlock at ffffffff815d183c
> | >#20 [ffff88017a2a9da0] lock_timer_base.isra.35 at ffffffff81061cbf
> | >#21 [ffff88017a2a9dd0] schedule_timeout at ffffffff815cf1ce
> | >#22 [ffff88017a2a9e50] rcu_gp_kthread at ffffffff810f9bbb
> | >#23 [ffff88017a2a9ed0] kthread at ffffffff810796d5
> | >#24 [ffff88017a2a9f50] ret_from_fork at ffffffff815da04c
> 
> lock_timer_base() does a try_lock() which deadlocks on the waiter lock
> not the lock itself.
> This patch takes the waiter_lock with trylock so it should work from interrupt
> context as well. If the fastpath doesn't work and the waiter_lock itself is
> taken then it seems that the lock itself taken.
> This patch also adds a "rt_spin_try_unlock" to keep lockdep happy. If we
> managed to take the wait_lock in the first place we should also be able
> to take it in the unlock path.
> 
> Cc: stable-rt@vger.kernel.org
> Reported-by: Mike Galbraith <bitbucket@online.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  include/linux/spinlock_rt.h |  1 +
>  kernel/rtmutex.c            | 31 +++++++++++++++++++++++++++----
>  kernel/timer.c              |  2 +-
>  3 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
> index 3b555b4..28edba7 100644
> --- a/include/linux/spinlock_rt.h
> +++ b/include/linux/spinlock_rt.h
> @@ -20,6 +20,7 @@ extern void __lockfunc rt_spin_lock(spinlock_t *lock);
>  extern unsigned long __lockfunc rt_spin_lock_trace_flags(spinlock_t *lock);
>  extern void __lockfunc rt_spin_lock_nested(spinlock_t *lock, int subclass);
>  extern void __lockfunc rt_spin_unlock(spinlock_t *lock);
> +extern void __lockfunc rt_spin_unlock_after_trylock_in_irq(spinlock_t *lock);
>  extern void __lockfunc rt_spin_unlock_wait(spinlock_t *lock);
>  extern int __lockfunc rt_spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags);
>  extern int __lockfunc rt_spin_trylock_bh(spinlock_t *lock);
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index 6075f17..d759326 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -801,10 +801,8 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
>  /*
>   * Slow path to release a rt_mutex spin_lock style
>   */
> -static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
> +static void __sched __rt_spin_lock_slowunlock(struct rt_mutex *lock)
>  {
> -	raw_spin_lock(&lock->wait_lock);
> -
>  	debug_rt_mutex_unlock(lock);
>  
>  	rt_mutex_deadlock_account_unlock(current);
> @@ -823,6 +821,23 @@ static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
>  	rt_mutex_adjust_prio(current);
>  }
>  
> +static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
> +{
> +	raw_spin_lock(&lock->wait_lock);
> +	__rt_spin_lock_slowunlock(lock);
> +}
> +
> +static void  noinline __sched rt_spin_lock_slowunlock_hirq(struct rt_mutex *lock)
> +{
> +	int ret;
> +
> +	do {
> +		ret = raw_spin_trylock(&lock->wait_lock);
> +	} while (!ret);
> +
> +	__rt_spin_lock_slowunlock(lock);
> +}
> +
>  void __lockfunc rt_spin_lock(spinlock_t *lock)
>  {
>  	rt_spin_lock_fastlock(&lock->lock, rt_spin_lock_slowlock);
> @@ -853,6 +868,13 @@ void __lockfunc rt_spin_unlock(spinlock_t *lock)
>  }
>  EXPORT_SYMBOL(rt_spin_unlock);
>  
> +void __lockfunc rt_spin_unlock_after_trylock_in_irq(spinlock_t *lock)
> +{
> +	/* NOTE: we always pass in '1' for nested, for simplicity */
> +	spin_release(&lock->dep_map, 1, _RET_IP_);
> +	rt_spin_lock_fastunlock(&lock->lock, rt_spin_lock_slowunlock_hirq);
> +}
> +
>  void __lockfunc __rt_spin_unlock(struct rt_mutex *lock)
>  {
>  	rt_spin_lock_fastunlock(lock, rt_spin_lock_slowunlock);
> @@ -1064,7 +1086,8 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
>  {
>  	int ret = 0;
>  
> -	raw_spin_lock(&lock->wait_lock);
> +	if (!raw_spin_trylock(&lock->wait_lock))
> +		return ret;
>  	init_lists(lock);
>  
>  	if (likely(rt_mutex_owner(lock) != current)) {
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 7fa30e0..b7ef082 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1336,7 +1336,7 @@ unsigned long get_next_timer_interrupt(unsigned long now)
>  		if (time_before_eq(base->next_timer, base->timer_jiffies))
>  			base->next_timer = __next_timer_interrupt(base);
>  		expires = base->next_timer;
> -		rt_spin_unlock(&base->lock);
> +		rt_spin_unlock_after_trylock_in_irq(&base->lock);
>  	} else {
>  		expires = now + 1;
>  	}


