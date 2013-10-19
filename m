Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3JSQZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:25:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab3JSQZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:25:33 -0400
Date: Sat, 19 Oct 2013 18:18:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Sullivan <dsulliva@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] hung_task debugging: Add tracepoint to report the hang
Message-ID: <20131019161828.GA7439@redhat.com>
References: <20131019161807.GA7431@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019161807.GA7431@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently check_hung_task() prints a warning if it detects the
problem, but it is not convenient to watch the system logs if
user-space wants to be notified about the hang.

Add the new trace_sched_process_hang() into check_hung_task(),
this way a user-space monitor can easily wait for the hang and
potentially resolve a problem.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/events/sched.h |   19 +++++++++++++++++++
 kernel/hung_task.c           |    4 ++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 2e7d994..2a652d1 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -424,6 +424,25 @@ TRACE_EVENT(sched_pi_setprio,
 			__entry->oldprio, __entry->newprio)
 );
 
+#ifdef CONFIG_DETECT_HUNG_TASK
+TRACE_EVENT(sched_process_hang,
+	TP_PROTO(struct task_struct *tsk),
+	TP_ARGS(tsk),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid = tsk->pid;
+	),
+
+	TP_printk("comm=%s pid=%d", __entry->comm, __entry->pid)
+);
+#endif /* CONFIG_DETECT_HUNG_TASK */
+
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 3e97fb1..3952ab1 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -16,6 +16,7 @@
 #include <linux/export.h>
 #include <linux/sysctl.h>
 #include <linux/utsname.h>
+#include <trace/events/sched.h>
 
 /*
  * The number of tasks checked:
@@ -92,6 +93,9 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 		t->last_switch_count = switch_count;
 		return;
 	}
+
+	trace_sched_process_hang(t);
+
 	if (!sysctl_hung_task_warnings)
 		return;
 	sysctl_hung_task_warnings--;
-- 
1.5.5.1


