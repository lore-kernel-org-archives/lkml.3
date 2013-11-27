Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3K0Nnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:43:52 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33096 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3K0Nnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:43:51 -0500
Message-ID: <5295F711.5010708@gmail.com>
Date: Wed, 27 Nov 2013 14:43:45 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
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
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>	<1383831828-15501-9-git-send-email-juri.lelli@gmail.com> <20131120163318.10253e43@gandalf.local.home>
In-Reply-To: <20131120163318.10253e43@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 10:33 PM, Steven Rostedt wrote:
> On Thu,  7 Nov 2013 14:43:42 +0100
> Juri Lelli <juri.lelli@gmail.com> wrote:
> 
> 
>> +	/*
>> +	 * Semantic is like this:
>> +	 *  - wakeup tracer handles all tasks in the system, independently
>> +	 *    from their scheduling class;
>> +	 *  - wakeup_rt tracer handles tasks belonging to sched_dl and
>> +	 *    sched_rt class;
>> +	 *  - wakeup_dl handles tasks belonging to sched_dl class only.
>> +	 */
>> +	if ((wakeup_dl && !dl_task(p)) ||
>> +	    (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
>> +	    (p->prio >= wakeup_prio || p->prio >= current->prio))
>>  		return;
>>  
>>  	pc = preempt_count();
>> @@ -486,7 +495,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>>  	arch_spin_lock(&wakeup_lock);
>>  
>>  	/* check for races. */
>> -	if (!tracer_enabled || p->prio >= wakeup_prio)
>> +	if (!tracer_enabled || (!dl_task(p) && p->prio >= wakeup_prio))
>>  		goto out_locked;
> 
> We probably want to add a "tracing_dl" variable, and do the test like
> this:
> 
> 	if (!tracer_enabled || tracing_dl ||
> 	    (!dl_task(p) && p->prio >= wakeup_prio))
> 
> and for the first if statement too. Otherwise if two dl tasks are
> running on two different CPUs, the second will override the first. Once
> you start tracing a dl_task, you shouldn't bother tracing another task
> until that one wakes up.
> 
> 	if (dl_task(p))
> 		tracing_dl = 1;
> 	else
> 		tracing_dl = 0;
> 

Ok, this fixes the build error:

--------------------------------------
 kernel/trace/trace_selftest.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index f76f8d6..ad94604 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1023,16 +1023,16 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
 static int trace_wakeup_test_thread(void *data)
 {
 	/* Make this a -deadline thread */
-	struct sched_param2 paramx = {
+	static const struct sched_param2 param = {
 		.sched_priority = 0,
+		.sched_flags = 0,
 		.sched_runtime = 100000ULL,
 		.sched_deadline = 10000000ULL,
 		.sched_period = 10000000ULL
-		.sched_flags = 0
 	};
 	struct completion *x = data;
 
-	sched_setscheduler2(current, SCHED_DEADLINE, &paramx);
+	sched_setscheduler2(current, SCHED_DEADLINE, &param);
 
 	/* Make it know we have a new prio */
 	complete(x);
@@ -1088,19 +1088,19 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 
 	while (p->on_rq) {
 		/*
-		 * Sleep to make sure the RT thread is asleep too.
+		 * Sleep to make sure the -deadline thread is asleep too.
 		 * On virtual machines we can't rely on timings,
 		 * but we want to make sure this test still works.
 		 */
 		msleep(100);
 	}
 
-	init_completion(&isrt);
+	init_completion(&is_ready);
 
 	wake_up_process(p);
 
 	/* Wait for the task to wake up */
-	wait_for_completion(&isrt);
+	wait_for_completion(&is_ready);
 
 	/* stop the tracing. */
 	tracing_stop();
--------------------------------

And this should implement what you were asking for:

--------------------------------
 kernel/trace/trace_sched_wakeup.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 1457fb1..090c4d9 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -28,6 +28,7 @@ static int			wakeup_current_cpu;
 static unsigned			wakeup_prio = -1;
 static int			wakeup_rt;
 static int			wakeup_dl;
+static int			tracing_dl = 0;
 
 static arch_spinlock_t wakeup_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
@@ -438,6 +439,7 @@ static void __wakeup_reset(struct trace_array *tr)
 {
 	wakeup_cpu = -1;
 	wakeup_prio = -1;
+	tracing_dl = 0;
 
 	if (wakeup_task)
 		put_task_struct(wakeup_task);
@@ -481,9 +483,9 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	 *    sched_rt class;
 	 *  - wakeup_dl handles tasks belonging to sched_dl class only.
 	 */
-	if ((wakeup_dl && !dl_task(p)) ||
+	if (tracing_dl || (wakeup_dl && !dl_task(p)) ||
 	    (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
-	    (p->prio >= wakeup_prio || p->prio >= current->prio))
+	    (!dl_task(p) && (p->prio >= wakeup_prio || p->prio >= current->prio)))
 		return;
 
 	pc = preempt_count();
@@ -495,7 +497,8 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	arch_spin_lock(&wakeup_lock);
 
 	/* check for races. */
-	if (!tracer_enabled || (!dl_task(p) && p->prio >= wakeup_prio))
+	if (!tracer_enabled || tracing_dl ||
+	    (!dl_task(p) && p->prio >= wakeup_prio))
 		goto out_locked;
 
 	/* reset the trace */
@@ -505,6 +508,15 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	wakeup_current_cpu = wakeup_cpu;
 	wakeup_prio = p->prio;
 
+	/*
+	 * Once you start tracing a -deadline task, don't bother tracing
+	 * another task until the first one wakes up.
+	 */
+	if (dl_task(p))
+		tracing_dl = 1;
+	else
+		tracing_dl = 0;
+
 	wakeup_task = p;
 	get_task_struct(wakeup_task);
 
@@ -700,10 +712,18 @@ static struct tracer wakeup_dl_tracer __read_mostly =
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
 	.wait_pipe	= poll_wait_pipe,
-	.print_max	= 1,
+	.print_max	= true,
+	.print_header	= wakeup_print_header,
+	.print_line	= wakeup_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= wakeup_set_flag,
+	.flag_changed	= wakeup_flag_changed,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
+	.open		= wakeup_trace_open,
+	.close		= wakeup_trace_close,
+	.use_max_tr	= true,
 };
 
 __init static int init_wakeup_tracer(void)
-----------------------------------

Makes sense? :)

Thanks,

- Juri
