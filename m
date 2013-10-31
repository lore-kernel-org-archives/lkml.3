Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3JaKyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:54:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3JaKyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:54:16 -0400
Date: Thu, 31 Oct 2013 03:53:09 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-6a716c90a51338009c3bc1f460829afaed8f922d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dsulliva@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsulliva@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131019161828.GA7439@redhat.com>
References: <20131019161828.GA7439@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] hung_task debugging:
  Add tracepoint to report the hang
Git-Commit-ID: 6a716c90a51338009c3bc1f460829afaed8f922d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 31 Oct 2013 03:53:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a716c90a51338009c3bc1f460829afaed8f922d
Gitweb:     http://git.kernel.org/tip/6a716c90a51338009c3bc1f460829afaed8f922d
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sat, 19 Oct 2013 18:18:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 31 Oct 2013 11:16:18 +0100

hung_task debugging: Add tracepoint to report the hang

Currently check_hung_task() prints a warning if it detects the
problem, but it is not convenient to watch the system logs if
user-space wants to be notified about the hang.

Add the new trace_sched_process_hang() into check_hung_task(),
this way a user-space monitor can easily wait for the hang and
potentially resolve a problem.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Sullivan <dsulliva@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20131019161828.GA7439@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/trace/events/sched.h | 19 +++++++++++++++++++
 kernel/hung_task.c           |  4 ++++
 2 files changed, 23 insertions(+)

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
index 0422523..8807061 100644
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
