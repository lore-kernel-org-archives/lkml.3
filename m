Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaFDAcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 20:32:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57283 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaFDAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 20:30:00 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
Cc: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/6] sched,trace: Add a tracepoint for remote wakeups via polling
Date: Tue,  3 Jun 2014 17:29:48 -0700
Message-Id: <c932da32f908d0c0c9ea5b7f7d5fff540eb8fec6.1401841482.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401841482.git.luto@amacapital.net>
References: <cover.1401841482.git.luto@amacapital.net>
In-Reply-To: <cover.1401841482.git.luto@amacapital.net>
References: <cover.1401841482.git.luto@amacapital.net>
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
index 67e1bbf..08f8632 100644
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
+TRACE_EVENT(sched_wake_polling_cpu,
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
index 321d800..18bebfc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -564,6 +564,8 @@ void resched_task(struct task_struct *p)
 
 	if (set_nr_and_not_polling(p))
 		smp_send_reschedule(cpu);
+	else
+		trace_sched_wake_polling_cpu(cpu);
 }
 
 void resched_cpu(int cpu)
@@ -647,6 +649,8 @@ static void wake_up_idle_cpu(int cpu)
 	smp_mb();
 	if (!tsk_is_polling(rq->idle))
 		smp_send_reschedule(cpu);
+	else
+		trace_sched_wake_polling_cpu(cpu);
 }
 
 static bool wake_up_full_nohz_cpu(int cpu)
-- 
1.9.3

