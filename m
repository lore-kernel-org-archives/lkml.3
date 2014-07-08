Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaGHWUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:20:42 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37882 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaGHWUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:20:40 -0400
Date: Tue, 8 Jul 2014 15:20:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] rcu: uninline rcu_read_lock_held()
Message-ID: <20140708222035.GD4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140630161837.GA15873@redhat.com>
 <20140630202420.GG4603@linux.vnet.ibm.com>
 <20140701145523.GA12547@redhat.com>
 <20140702153901.GA9535@redhat.com>
 <20140702185915.GA18357@redhat.com>
 <20140702185935.GB18357@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702185935.GB18357@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070822-9332-0000-0000-000001512CCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 08:59:35PM +0200, Oleg Nesterov wrote:
> Uninline rcu_read_lock_held(). According to size vmlinux this saves
> 28549 in .text:
> 
> 	- 5541731 3014560 14757888 23314179
> 	+ 5513182 3026848 14757888 23297918
> 
> Note: it looks as if the data grows by 12288 bytes but this is not true,
> it does not actually grow. But .data starts with ALIGN(THREAD_SIZE) and
> since .text shrinks the padding grows, and thus .data grows too as it
> seen by /bin/size. diff System.map:
> 
> 	- ffffffff81510000 D _sdata
> 	- ffffffff81510000 D init_thread_union
> 	+ ffffffff81509000 D _sdata
> 	+ ffffffff8150c000 D init_thread_union
> 
> Perhaps we can change vmlinux.lds.S to .data itself, so that /bin/size
> can't "wrongly" report that .data grows if .text shinks.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Queued for 3.18, thank you, Oleg!

I removed the "extern" tags, apparently people don't like them on
function declarations anymore.

							Thanx, Paul

> ---
>  include/linux/rcupdate.h |   38 ++------------------------------------
>  kernel/rcu/update.c      |   32 ++++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 36 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index e8c55d8..8980817 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -378,42 +378,8 @@ extern void rcu_lock_release_bh(void);
>  extern void rcu_lock_acquire_sched(void);
>  extern void rcu_lock_release_sched(void);
> 
> -/**
> - * rcu_read_lock_held() - might we be in RCU read-side critical section?
> - *
> - * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
> - * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
> - * this assumes we are in an RCU read-side critical section unless it can
> - * prove otherwise.  This is useful for debug checks in functions that
> - * require that they be called within an RCU read-side critical section.
> - *
> - * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
> - * and while lockdep is disabled.
> - *
> - * Note that rcu_read_lock() and the matching rcu_read_unlock() must
> - * occur in the same context, for example, it is illegal to invoke
> - * rcu_read_unlock() in process context if the matching rcu_read_lock()
> - * was invoked from within an irq handler.
> - *
> - * Note that rcu_read_lock() is disallowed if the CPU is either idle or
> - * offline from an RCU perspective, so check for those as well.
> - */
> -static inline int rcu_read_lock_held(void)
> -{
> -	if (!debug_lockdep_rcu_enabled())
> -		return 1;
> -	if (!rcu_is_watching())
> -		return 0;
> -	if (!rcu_lockdep_current_cpu_online())
> -		return 0;
> -	return lock_is_held(&rcu_lock_map);
> -}
> -
> -/*
> - * rcu_read_lock_bh_held() is defined out of line to avoid #include-file
> - * hell.
> - */
> -int rcu_read_lock_bh_held(void);
> +extern int rcu_read_lock_held(void);
> +extern int rcu_read_lock_bh_held(void);
> 
>  /**
>   * rcu_read_lock_sched_held() - might we be in RCU-sched read-side critical section?
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index c2209eb..ea4af81 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -137,6 +137,38 @@ int notrace debug_lockdep_rcu_enabled(void)
>  EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
> 
>  /**
> + * rcu_read_lock_held() - might we be in RCU read-side critical section?
> + *
> + * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
> + * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
> + * this assumes we are in an RCU read-side critical section unless it can
> + * prove otherwise.  This is useful for debug checks in functions that
> + * require that they be called within an RCU read-side critical section.
> + *
> + * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
> + * and while lockdep is disabled.
> + *
> + * Note that rcu_read_lock() and the matching rcu_read_unlock() must
> + * occur in the same context, for example, it is illegal to invoke
> + * rcu_read_unlock() in process context if the matching rcu_read_lock()
> + * was invoked from within an irq handler.
> + *
> + * Note that rcu_read_lock() is disallowed if the CPU is either idle or
> + * offline from an RCU perspective, so check for those as well.
> + */
> +int rcu_read_lock_held(void)
> +{
> +	if (!debug_lockdep_rcu_enabled())
> +		return 1;
> +	if (!rcu_is_watching())
> +		return 0;
> +	if (!rcu_lockdep_current_cpu_online())
> +		return 0;
> +	return lock_is_held(&rcu_lock_map);
> +}
> +EXPORT_SYMBOL_GPL(rcu_read_lock_held);
> +
> +/**
>   * rcu_read_lock_bh_held() - might we be in RCU-bh read-side critical section?
>   *
>   * Check for bottom half being disabled, which covers both the
> -- 
> 1.5.5.1
> 
> 

