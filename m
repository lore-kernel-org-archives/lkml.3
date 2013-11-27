Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3K0OQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:16:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32189 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750905Ab3K0OQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:16:52 -0500
Date: Wed, 27 Nov 2013 09:16:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 08/14] sched: add latency tracing for -deadline tasks.
Message-ID: <20131127091647.4e16ce53@gandalf.local.home>
In-Reply-To: <5295F711.5010708@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
	<20131120163318.10253e43@gandalf.local.home>
	<5295F711.5010708@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013 14:43:45 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index f76f8d6..ad94604 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -1023,16 +1023,16 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
>  static int trace_wakeup_test_thread(void *data)
>  {
>  	/* Make this a -deadline thread */
> -	struct sched_param2 paramx = {
> +	static const struct sched_param2 param = {
>  		.sched_priority = 0,
> +		.sched_flags = 0,
>  		.sched_runtime = 100000ULL,
>  		.sched_deadline = 10000000ULL,
>  		.sched_period = 10000000ULL
> -		.sched_flags = 0

Assigning structures like this, you don't need to set the zero fields.
all fields not explicitly stated, are set to zero.

>  	};
>  	struct completion *x = data;
>  
> 
> --------------------------------
>  kernel/trace/trace_sched_wakeup.c |   28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
> index 1457fb1..090c4d9 100644
> --- a/kernel/trace/trace_sched_wakeup.c
> +++ b/kernel/trace/trace_sched_wakeup.c
> @@ -28,6 +28,7 @@ static int			wakeup_current_cpu;
>  static unsigned			wakeup_prio = -1;
>  static int			wakeup_rt;
>  static int			wakeup_dl;
> +static int			tracing_dl = 0;

Get rid of the ' = 0', its implicit to all static and global variables
that are not given any value.

>  
>  static arch_spinlock_t wakeup_lock =
>  	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
> @@ -438,6 +439,7 @@ static void __wakeup_reset(struct trace_array *tr)
>  {
>  	wakeup_cpu = -1;
>  	wakeup_prio = -1;
> +	tracing_dl = 0;
>  
>  	if (wakeup_task)
>  		put_task_struct(wakeup_task);
> @@ -481,9 +483,9 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>  	 *    sched_rt class;
>  	 *  - wakeup_dl handles tasks belonging to sched_dl class only.
>  	 */
> -	if ((wakeup_dl && !dl_task(p)) ||
> +	if (tracing_dl || (wakeup_dl && !dl_task(p)) ||
>  	    (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
> -	    (p->prio >= wakeup_prio || p->prio >= current->prio))
> +	    (!dl_task(p) && (p->prio >= wakeup_prio || p->prio >= current->prio)))
>  		return;
>  
>  	pc = preempt_count();
> @@ -495,7 +497,8 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>  	arch_spin_lock(&wakeup_lock);
>  
>  	/* check for races. */
> -	if (!tracer_enabled || (!dl_task(p) && p->prio >= wakeup_prio))
> +	if (!tracer_enabled || tracing_dl ||
> +	    (!dl_task(p) && p->prio >= wakeup_prio))
>  		goto out_locked;
>  
>  	/* reset the trace */
> @@ -505,6 +508,15 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>  	wakeup_current_cpu = wakeup_cpu;
>  	wakeup_prio = p->prio;
>  
> +	/*
> +	 * Once you start tracing a -deadline task, don't bother tracing
> +	 * another task until the first one wakes up.
> +	 */
> +	if (dl_task(p))
> +		tracing_dl = 1;
> +	else
> +		tracing_dl = 0;

Do we need the else statement? I would think the only way to get here
is if tracing_dl is already set to zero.

-- Steve

> +
>  	wakeup_task = p;
>  	get_task_struct(wakeup_task);
>  
> @@ -700,10 +712,18 @@ static struct tracer wakeup_dl_tracer __read_mostly =
>  	.start		= wakeup_tracer_start,
>  	.stop		= wakeup_tracer_stop,
>  	.wait_pipe	= poll_wait_pipe,
> -	.print_max	= 1,
> +	.print_max	= true,
> +	.print_header	= wakeup_print_header,
> +	.print_line	= wakeup_print_line,
> +	.flags		= &tracer_flags,
> +	.set_flag	= wakeup_set_flag,
> +	.flag_changed	= wakeup_flag_changed,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest    = trace_selftest_startup_wakeup,
>  #endif
> +	.open		= wakeup_trace_open,
> +	.close		= wakeup_trace_close,
> +	.use_max_tr	= true,
>  };
>  
>  __init static int init_wakeup_tracer(void)
> -----------------------------------
> 
> Makes sense? :)
> 
> Thanks,
> 
> - Juri

