Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaFEOij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:38:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaFEOie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:38:34 -0400
Date: Thu, 5 Jun 2014 07:37:19 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-dfc68f29ae67f2a6e799b44e6a4eb3417dffbfcd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, fweisbec@gmail.com, rostedt@goodmis.org,
        mgorman@suse.de, dsahern@gmail.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, mgorman@suse.de, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <16205aee116772aa686814f9b13bccb562108047.1401902905.git.luto@amacapital.net>
References: <16205aee116772aa686814f9b13bccb562108047.1401902905.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, trace:
  Add a tracepoint for IPI-less remote wakeups
Git-Commit-ID: dfc68f29ae67f2a6e799b44e6a4eb3417dffbfcd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfc68f29ae67f2a6e799b44e6a4eb3417dffbfcd
Gitweb:     http://git.kernel.org/tip/dfc68f29ae67f2a6e799b44e6a4eb3417dffbfcd
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 4 Jun 2014 10:31:15 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:09:50 +0200

sched, trace: Add a tracepoint for IPI-less remote wakeups

Remote wakeups of polling CPUs are a valuable performance
improvement; add a tracepoint to make it much easier to verify that
they're working.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: nicolas.pitre@linaro.org
Cc: daniel.lezcano@linaro.org
Cc: umgwanakikbuti@gmail.com
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/16205aee116772aa686814f9b13bccb562108047.1401902905.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 5976ca5..e4c0ddd 100644
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
