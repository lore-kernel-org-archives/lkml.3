Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab3CTXXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:23:40 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:47535 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab3CTXXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:23:37 -0400
Message-ID: <514A44F6.8010203@deeprootsystems.com>
Date: Wed, 20 Mar 2013 16:23:34 -0700
From: Kevin Hilman <khilman@deeprootsystems.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 30/33] sched: Debug nohz rq clock
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com> <1357610913-1080-31-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1357610913-1080-31-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On 01/07/2013 06:08 PM, Frederic Weisbecker wrote:
> The runqueue clock is supposed to be periodically updated by the
> tick. On full dynticks CPU we call update_nohz_rq_clock() before
> reading it. Now the scheduler code is complicated enough that we
> may miss some update_nohz_rq_clock() calls before reading the
> runqueue clock.
> 
> This therefore introduce a new debugging feature that detects
> when the rq clock is stale due to missing updates on full
> dynticks CPUs.
> 
> This can be later expanded to debug stale clocks on dynticks-idle
> CPUs.

[...]

> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index e1bac76..0fef0b3 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -502,16 +502,39 @@ DECLARE_PER_CPU(struct rq, runqueues);
>  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
>  #define raw_rq()		(&__raw_get_cpu_var(runqueues))
>  
> +static inline void rq_clock_check(struct rq *rq)
> +{
> +#if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_NO_HZ_FULL)
> +	unsigned long long clock;
> +	unsigned long flags;
> +	int cpu;
> +
> +	cpu = cpu_of(rq);
> +	if (!tick_nohz_full_cpu(cpu) || rq->curr == rq->idle)
> +		return;
> +
> +	local_irq_save(flags);
> +	clock = sched_clock_cpu(cpu_of(rq));
> +	local_irq_restore(flags);
> +
> +	if (abs(clock - rq->clock) > (TICK_NSEC * 3))
> +		WARN_ON_ONCE(1);
> +#endif
> +}

In working on the ARM port for full nohz, I'm hitting this
warning early in the kernel boot, well before userspace starts
(dump below[2].)

I've seen a few different variations of this, but the common
thing for all of them is the use of wait_for_completion().

During boot, only swapper is running so it seems
any waiting of sufficient length during boot will always trigger
this warning.  The hack below[1] avoids checking for the init task,
but I'm not sure if it's the right fix.

Kevin

[1]
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f96329b..56e74df 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -512,7 +512,8 @@ static inline void rq_clock_check(struct rq *rq)
 	int cpu;

 	cpu = cpu_of(rq);
-	if (!tick_nohz_full_cpu(cpu) || rq->curr == rq->idle)
+	if (!tick_nohz_full_cpu(cpu) || rq->curr == rq->idle ||
+	    is_global_init(current))
 		return;


[2] Example warning dump
[    1.101013] ------------[ cut here ]------------
[    1.105865] WARNING: at
/work/kernel/linaro/dev/kernel/sched/sched.h:534 __schedule+0x510/0x790()
[    1.115051] Modules linked in:
[    1.118316] [<c00159d0>] (unwind_backtrace+0x0/0x104) from
[<c054dc98>] (dump_stack+0x20/0x24)
[    1.127227] [<c054dc98>] (dump_stack+0x20/0x24) from [<c0037f58>]
(warn_slowpath_common+0x5c/0x78)
[    1.136535] [<c0037f58>] (warn_slowpath_common+0x5c/0x78) from
[<c0037fa0>] (warn_slowpath_null+0x2c/0x34)
[    1.146545] [<c0037fa0>] (warn_slowpath_null+0x2c/0x34) from
[<c0560834>] (__schedule+0x510/0x790)
[    1.155822] [<c0560834>] (__schedule+0x510/0x790) from [<c0560ba8>]
(schedule+0x40/0x80)
[    1.164215] [<c0560ba8>] (schedule+0x40/0x80) from [<c055e288>]
(schedule_timeout+0x180/0x250)
[    1.173156] [<c055e288>] (schedule_timeout+0x180/0x250) from
[<c05601a4>] (wait_for_common+0xb8/0x15c)
[    1.182800] [<c05601a4>] (wait_for_common+0xb8/0x15c) from
[<c0560268>] (wait_for_completion+0x20/0x24)
[    1.192535] [<c0560268>] (wait_for_completion+0x20/0x24) from
[<c005ce4c>] (kthread_create_on_node+0x84/0xe8)
[    1.202819] [<c005ce4c>] (kthread_create_on_node+0x84/0xe8) from
[<c005732c>] (__alloc_workqueue_key+0x36c/0x440)
[    1.213470] [<c005732c>] (__alloc_workqueue_key+0x36c/0x440) from
[<c052d380>] (rpc_init_mempool+0x44/0x118)
[    1.223663] [<c052d380>] (rpc_init_mempool+0x44/0x118) from
[<c07f1714>] (init_sunrpc+0x10/0x6c)
[    1.232757] [<c07f1714>] (init_sunrpc+0x10/0x6c) from [<c00087f0>]
(do_one_initcall+0x48/0x190)
[    1.241790] [<c00087f0>] (do_one_initcall+0x48/0x190) from
[<c07c3988>] (do_basic_setup+0x9c/0xd0)
[    1.251068] [<c07c3988>] (do_basic_setup+0x9c/0xd0) from [<c07c3a88>]
(kernel_init_freeable+0xcc/0x16c)
[    1.260833] [<c07c3a88>] (kernel_init_freeable+0xcc/0x16c) from
[<c0548840>] (kernel_init+0x1c/0xf4)
[    1.270294] [<c0548840>] (kernel_init+0x1c/0xf4) from [<c000e390>]
(ret_from_fork+0x14/0x20)
[
> +
>  static inline u64 rq_clock(struct rq *rq)
>  {
> +	rq_clock_check(rq);
>  	return rq->clock;
>  }
>  
>  static inline u64 rq_clock_task(struct rq *rq)
>  {
> +	rq_clock_check(rq);
>  	return rq->clock_task;
>  }
>  
> +
>  #ifdef CONFIG_SMP
>  
>  #define rcu_dereference_check_sched_domain(p) \
> 
