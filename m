Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaFDRcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:32:36 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38396 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaFDRbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:31:25 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
Cc: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 2/5] sched,trace: Add a tracepoint for IPI-less remote wakeups
Date: Wed,  4 Jun 2014 10:31:15 -0700
Message-Id: <16205aee116772aa686814f9b13bccb562108047.1401902905.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401902905.git.luto@amacapital.net>
References: <cover.1401902905.git.luto@amacapital.net>
In-Reply-To: <cover.1401902905.git.luto@amacapital.net>
References: <cover.1401902905.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remote wakeups of polling CPUs are a valuable performance
improvement; add a tracepoint to make it much easier to verify that
they're working.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/trace/events/sched.h | 20 ++++++++++++++++++++
 kernel/sched/core.c          |  4 ++++
 2 files changed, 24 insertions(+)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 67e1bbf..0a68d5a 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -530,6 +530,26 @@ TRACE_EVENT(sched_swap_numa,
 			__entry->dst_pid, __entry->dst_tgid, __entry->dst_ngid,
 			__entry->dst_cpu, __entry->dst_nid)
 );
+
+/*
+ * Tracepoint for waking a polling cpu without an IPI.
+ */
+TRACE_EVENT(sched_wake_idle_without_ipi,
+
+	TP_PROTO(int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(	int,	cpu	)
+	),
+
+	TP_fast_assign(
+		__entry->cpu	= cpu;
+	),
+
+	TP_printk("cpu=%d", __entry->cpu)
+);
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 321d800..a002be7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -564,6 +564,8 @@ void resched_task(struct task_struct *p)
 
 	if (set_nr_and_not_polling(p))
 		smp_send_reschedule(cpu);
+	else
+		trace_sched_wake_idle_without_ipi(cpu);
 }
 
 void resched_cpu(int cpu)
@@ -647,6 +649,8 @@ static void wake_up_idle_cpu(int cpu)
 	smp_mb();
 	if (!tsk_is_polling(rq->idle))
 		smp_send_reschedule(cpu);
+	else
+		trace_sched_wake_idle_without_ipi(cpu);
 }
 
 static bool wake_up_full_nohz_cpu(int cpu)
-- 
1.9.3

