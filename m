Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaILLxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:53:12 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:32863 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaILLxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:53:08 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 07:53:08 EDT
Message-ID: <1410522334.16936.42.camel@hornet>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
From: Pawel Moll <pawel.moll@arm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2014 12:45:34 +0100
In-Reply-To: <20140722193939.GA15507@localhost.localdomain>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
	 <20140719050233.GA4408@netboy> <1406045849.25343.72.camel@hornet>
	 <20140722193939.GA15507@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 20:39 +0100, Richard Cochran wrote:
> So the only reasonable way, IMHO, is to simply provide the needed
> information in the traces, and then add some user space code to find
> the relationship between the perf clock and the system clock. The
> great advantage of this approach is that you don't have to create a
> perfect servo from day one. The time stamps can be re-analyzed at any
> time after the fact.

Ok, so I had yet another (already lost count ;-) look into this...

I came up with a conclusion that the simplest way it can be done is to
have a periodically repeated events marked with both "kernel timestamp"
and "user timestamp". And a scheduler switch is such a periodic event.
Moreover, it seems quite natural: a user process is scheduled in (take a
snapshot of sched clock and monotonic raw at this moment, let's call
them t_s_in and t_m_in), the process "generates" the "user timestamp" by
clock_gettime(CLOCK_MONOTONIC_RAW, t_m_x), the process is scheduled out
(again, take sched and monotonic timestamps then, t_s_out and t_m_out).

The, after extracting all the t_?_? from the trace stream, a translation
(we've know the monotonic raw value t_m_x, we're looking for its sched
clock equivalent t_s_x) should simply get down to:

t_s_x = t_s_in + ((t_m_x - t_m_1) * (t_s_out - t_s_in)) / (t_m_out - t_m_in)

I quickly made an experiment, by adding a customised variant of
sched_switch trace event (note: I'm *not* proposing it to be merged)

8<-------------
>From ad772fca06da4774e6dd3a116ee2424a0dd3d80f Mon Sep 17 00:00:00 2001
From: Pawel Moll <pawel.moll@arm.com>
Date: Fri, 22 Aug 2014 15:23:13 +0100
Subject: [PATCH] trace: ched_switch event variant with raw monotonic timestamp

This patch adds a variant of sched_switch trace event,
adding a field for a monotonic raw timestamp.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 include/trace/events/sched.h | 48 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c          |  1 +
 2 files changed, 49 insertions(+)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 0a68d5a..1429958 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 #include <linux/binfmts.h>
+#include <linux/time.h>
 
 /*
  * Tracepoint for calling kthread_stop, performed to end a kthread:
@@ -150,6 +151,53 @@ TRACE_EVENT(sched_switch,
 );
 
 /*
+ * Tracepoint for task switches, including raw monotonic raw clock
+ * timestamp, to perform user- to kernelspace time correlation
+ */
+TRACE_EVENT(sched_switch_raw_monotonic,
+
+	TP_PROTO(struct task_struct *prev,
+		 struct task_struct *next),
+
+	TP_ARGS(prev, next),
+
+	TP_STRUCT__entry(
+		__field(	u64,	raw_monotonic			)
+		__array(	char,	prev_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	prev_pid			)
+		__field(	int,	prev_prio			)
+		__field(	long,	prev_state			)
+		__array(	char,	next_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	next_pid			)
+		__field(	int,	next_prio			)
+	),
+
+	TP_fast_assign(
+		struct timespec now;
+		getrawmonotonic(&now);
+		__entry->raw_monotonic = timespec_to_ns(&now);
+		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+		__entry->prev_pid	= prev->pid;
+		__entry->prev_prio	= prev->prio;
+		__entry->prev_state	= __trace_sched_switch_state(prev);
+		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+		__entry->next_pid	= next->pid;
+		__entry->next_prio	= next->prio;
+	),
+
+	TP_printk("raw_monotonic=%Lu prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d",
+		__entry->raw_monotonic, __entry->prev_comm,
+		__entry->prev_pid, __entry->prev_prio,
+		__entry->prev_state & (TASK_STATE_MAX-1) ?
+		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
+				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
+				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
+				{ 128, "K" }, { 256, "W" }, { 512, "P" }) : "R",
+		__entry->prev_state & TASK_STATE_MAX ? "+" : "",
+		__entry->next_comm, __entry->next_pid, __entry->next_prio)
+);
+
+/*
  * Tracepoint for a task being migrated:
  */
 TRACE_EVENT(sched_migrate_task,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec1a286..0cc7a92 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2179,6 +2179,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	trace_sched_switch(prev, next);
+	trace_sched_switch_raw_monotonic(prev, next);
 	sched_info_switch(rq, prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
-- 
1.9.1
8<-------------

And than did some experiment, opening a perf session with this event and
executing the following test:

        clock_gettime(CLOCK_MONOTONIC_RAW, &t_m_1);
        write(marker, "test", 4);
        clock_gettime(CLOCK_MONOTONIC_RAW, &t_m_2);

where "marker" is a descriptor for
"/sys/kernel/debug/tracing/trace_marker". In other words, I generated a
unique event which will be timestamped by sched_clock. Then I averaged
t_m_1 and t_m_2 to get t_m_x, translated it into t_s_x with the formula
above and compared it with a timestamp for the marked, grepped from the
"/sys/kernel/debug/tracing/trace" (as it is directly injected into the
ftrace buffer, there is no way of getting it into perf data stream). On
average I was getting results accurate to or below 1 microsecond (that's
the resolution of a timestamp generated by standard ftrace output).

So, the approach works in general, however:

1. I guess adding monotonic raw field to the "vanilla" sched_switch
won't be praised... A clone like the above one doesn't make much sense
either, I think.

2. Even if this was possible (or we had a clone like the above), only
root can request trace events. This is acceptable for system-wide
profiling tools (which will run as root by definition), but can be a
problem for JIT engines, which usually run as unprivileged processes.

3. The accuracy, although not bad and sufficient in a lot of use cases
(eg. latencies when accessing hwmon sensors are big and unpredictable by
their nature, so a microsecond here and there don't matter at all), may
not be good enough for JIT engines - there must be a way of precisely
marking a moment between a new code (and debug information) being
generated and its first instruction executed. "trace_marker" could be
used for this, but as mentioned above, it's "invisible" to perf, and
even if it was, it would be root-only, see p.2.

With all this in mind, I though it would be possible to generalise the
"monotonic timestamping" at the perf interface level and duplicating the
marker idea there... A short RFC series to follow.

Pawel

