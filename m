Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289AbaE3WIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:08:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:51267 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754614AbaE3WIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:08:51 -0400
Date: Fri, 30 May 2014 18:08:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 3/6] rtmutex: Cleanup deadlock detector debug logic
Message-ID: <20140530180848.44937ea8@gandalf.local.home>
In-Reply-To: <20140522031949.947264874@linutronix.de>
References: <20140522031841.797415507@linutronix.de>
	<20140522031949.947264874@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014 03:25:47 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:


> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -256,6 +256,25 @@ static void rt_mutex_adjust_prio(struct
>  }
>  
>  /*
> + * Deadlock detection is conditional:
> + *
> + * If CONFIG_DEBUG_RT_MUTEXES=n, deadlock detection is only conducted
> + * if the detect argument is != 0.

"if the detect argument is not RT_MUTEX_MIN_CHAINWALK."

We want to get rid of magic numbers right?

> + *
> + * If CONFIG_DEBUG_RT_MUTEXES=y, deadlock detection is always
> + * conducted independent of the detect argument.
> + *
> + * If the waiter argument is NULL this indicates the deboost path and
> + * deadlock detection is disabled independent of the detect argument
> + * and the config settings.
> + */
> +static int
> +rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter, int detect)
> +{
> +	return debug_rt_mutex_detect_deadlock(waiter, detect);
> +}
> +
> +/*


>  /*
> + * Constants for rt mutex functions which have a selectable deadlock
> + * detection.
> + *
> + * RT_MUTEX_MIN_CHAINWALK:	Stops the lock chain walk when there are
> + *				no further PI adjustments to be made.
> + *
> + * RT_MUTEX_FULL_CHAINWALK:	Invoke deadlock detection with a full
> + *				walk of the lock chain.
> + */
> +enum {
> +	RT_MUTEX_MIN_CHAINWALK,
> +	RT_MUTEX_FULL_CHAINWALK,
> +};

Why not name this enum and instead of passing in int into the
functions, pass the enum in. That way, in the future, people looking at
this code can see what parameters are permitted.

-- Steve


> +
> +/*
>   * PI-futex support (proxy locking functions, etc.):
>   */
>  extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
> 

