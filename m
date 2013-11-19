Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3KSTTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:19:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51778 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3KSTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:19:35 -0500
Date: Tue, 19 Nov 2013 11:18:46 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-d5b5f391d434c5cc8bcb1ab2d759738797b85f52@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, davej@redhat.com, vincent.weaver@maine.edu,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, davej@redhat.com, vincent.weaver@maine.edu,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20131114152304.GC5364@laptop.programming.kicks-ass.net>
References: <20131114152304.GC5364@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ftrace, perf:
  Avoid infinite event generation loop
Git-Commit-ID: d5b5f391d434c5cc8bcb1ab2d759738797b85f52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 11:18:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5b5f391d434c5cc8bcb1ab2d759738797b85f52
Gitweb:     http://git.kernel.org/tip/d5b5f391d434c5cc8bcb1ab2d759738797b85f52
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 14 Nov 2013 16:23:04 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Nov 2013 16:57:40 +0100

ftrace, perf: Avoid infinite event generation loop

Vince's perf-trinity fuzzer found yet another 'interesting' problem.

When we sample the irq_work_exit tracepoint with period==1 (or
PERF_SAMPLE_PERIOD) and we add an fasync SIGNAL handler we create an
infinite event generation loop:

  ,-> <IPI>
  |     irq_work_exit() ->
  |       trace_irq_work_exit() ->
  |         ...
  |           __perf_event_overflow() -> (due to fasync)
  |             irq_work_queue() -> (irq_work_list must be empty)
  '---------      arch_irq_work_raise()

Similar things can happen due to regular poll() wakeups if we exceed
the ring-buffer wakeup watermark, or have an event_limit.

To avoid this, dis-allow sampling this particular tracepoint.

In order to achieve this, create a special perf_perm function pointer
for each event and call this (when set) on trying to create a
tracepoint perf event.

[ roasted: use expr... to allow for ',' in your expression ]

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20131114152304.GC5364@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/trace/irq_vectors.h | 11 +++++++++++
 include/linux/ftrace_event.h             | 16 ++++++++++++++++
 include/linux/tracepoint.h               |  4 ++++
 include/trace/ftrace.h                   |  7 +++++++
 kernel/trace/trace_event_perf.c          |  6 ++++++
 5 files changed, 44 insertions(+)

diff --git a/arch/x86/include/asm/trace/irq_vectors.h b/arch/x86/include/asm/trace/irq_vectors.h
index 2874df2..4cab890 100644
--- a/arch/x86/include/asm/trace/irq_vectors.h
+++ b/arch/x86/include/asm/trace/irq_vectors.h
@@ -72,6 +72,17 @@ DEFINE_IRQ_VECTOR_EVENT(x86_platform_ipi);
 DEFINE_IRQ_VECTOR_EVENT(irq_work);
 
 /*
+ * We must dis-allow sampling irq_work_exit() because perf event sampling
+ * itself can cause irq_work, which would lead to an infinite loop;
+ *
+ *  1) irq_work_exit happens
+ *  2) generates perf sample
+ *  3) generates irq_work
+ *  4) goto 1
+ */
+TRACE_EVENT_PERF_PERM(irq_work_exit, is_sampling_event(p_event) ? -EPERM : 0);
+
+/*
  * call_function - called when entering/exiting a call function interrupt
  * vector handler
  */
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 9abbe63..8c9b7a1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -248,6 +248,9 @@ struct ftrace_event_call {
 #ifdef CONFIG_PERF_EVENTS
 	int				perf_refcount;
 	struct hlist_head __percpu	*perf_events;
+
+	int	(*perf_perm)(struct ftrace_event_call *,
+			     struct perf_event *);
 #endif
 };
 
@@ -317,6 +320,19 @@ struct ftrace_event_file {
 	}								\
 	early_initcall(trace_init_flags_##name);
 
+#define __TRACE_EVENT_PERF_PERM(name, expr...)				\
+	static int perf_perm_##name(struct ftrace_event_call *tp_event, \
+				    struct perf_event *p_event)		\
+	{								\
+		return ({ expr; });					\
+	}								\
+	static int __init trace_init_perf_perm_##name(void)		\
+	{								\
+		event_##name.perf_perm = &perf_perm_##name;		\
+		return 0;						\
+	}								\
+	early_initcall(trace_init_perf_perm_##name);
+
 #define PERF_MAX_TRACE_SIZE	2048
 
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index ebeab36..f16dc0a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -267,6 +267,8 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define TRACE_EVENT_FLAGS(event, flag)
 
+#define TRACE_EVENT_PERF_PERM(event, expr...)
+
 #endif /* DECLARE_TRACE */
 
 #ifndef TRACE_EVENT
@@ -399,4 +401,6 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define TRACE_EVENT_FLAGS(event, flag)
 
+#define TRACE_EVENT_PERF_PERM(event, expr...)
+
 #endif /* ifdef TRACE_EVENT (see note above) */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 52594b2..6b852f6 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -90,6 +90,10 @@
 #define TRACE_EVENT_FLAGS(name, value)					\
 	__TRACE_EVENT_FLAGS(name, value)
 
+#undef TRACE_EVENT_PERF_PERM
+#define TRACE_EVENT_PERF_PERM(name, expr...)				\
+	__TRACE_EVENT_PERF_PERM(name, expr)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 
@@ -140,6 +144,9 @@
 #undef TRACE_EVENT_FLAGS
 #define TRACE_EVENT_FLAGS(event, flag)
 
+#undef TRACE_EVENT_PERF_PERM
+#define TRACE_EVENT_PERF_PERM(event, expr...)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 78e27e3..630889f 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -24,6 +24,12 @@ static int	total_ref_count;
 static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
+	if (tp_event->perf_perm) {
+		int ret = tp_event->perf_perm(tp_event, p_event);
+		if (ret)
+			return ret;
+	}
+
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event) &&
 	    perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
