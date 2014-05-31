Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaEaTym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 15:54:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:64350 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751577AbaEaTyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 15:54:41 -0400
Date: Sat, 31 May 2014 15:54:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch v2 3/5] rtmutex: Confine deadlock logic to futex
Message-ID: <20140531155437.7cb833bf@gandalf.local.home>
In-Reply-To: <20140531155739.340193331@linutronix.de>
References: <20140531155229.493650009@linutronix.de>
	<20140531155739.340193331@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014 15:57:50 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -904,16 +904,15 @@ rt_mutex_slowunlock(struct rt_mutex *loc
>   */
>  static inline int
>  rt_mutex_fastlock(struct rt_mutex *lock, int state,
> -		  enum rtmutex_chainwalk detect_deadlock,
>  		  int (*slowfn)(struct rt_mutex *lock, int state,
>  				struct hrtimer_sleeper *timeout,
>  				enum rtmutex_chainwalk detect_deadlock))
>  {
> -	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
> +	if (likely(rt_mutex_cmpxchg(lock, NULL, current))) {
>  		rt_mutex_deadlock_account_lock(lock, current);
>  		return 0;
>  	} else
> -		return slowfn(lock, state, NULL, detect_deadlock);
> +		return slowfn(lock, state, NULL, RT_MUTEX_MIN_CHAINWALK);
>  }
>  
>  static inline int
> @@ -924,7 +923,7 @@ rt_mutex_timed_fastlock(struct rt_mutex
>  				      struct hrtimer_sleeper *timeout,
>  				      enum rtmutex_chainwalk detect_deadlock))
>  {
> -	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
> +	if (detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {

Did you mean to remove that "!"? Don't we want to call the slowfn all
the time if detect_deadlock is FULL?

-- Steve


>  		rt_mutex_deadlock_account_lock(lock, current);
>  		return 0;
>  	} else
> @@ -961,55 +960,59 @@ void __sched rt_mutex_lock(struct rt_mut
>  {
>  	might_sleep();
>  
> -	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, RT_MUTEX_MIN_CHAINWALK,
> -			  rt_mutex_slowlock);
> +	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, rt_mutex_slowlock);
>  }
>  EXPORT_SYMBOL_GPL(rt_mutex_lock);
