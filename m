Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066AbaEaBkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:40:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:29851 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933793AbaEaBj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:39:29 -0400
Message-Id: <20140531013926.661660394@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 30 May 2014 21:39:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 7/7] tracing: Move locking of trace_cmdline_lock into start/stop seq calls
References: <20140531013857.160310242@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0006-tracing-Move-locking-of-trace_cmdline_lock-into-star.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

With the conversion of the saved_cmdlines output to use seq_read, there
is now a race between accessing the values of the saved_cmdlines and
the writing to them. The trace_cmdline_lock needs to be taken at
the start and stop of the seq calls.

A new __trace_find_cmdline() call is created to allow for the look up
to happen without taking the lock.

Fixes: 42584c81c5ad tracing: Have saved_cmdlines use the seq_read infrastructure
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 22a902e2ded9..626dbfde5d56 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1484,7 +1484,7 @@ static int trace_save_cmdline(struct task_struct *tsk)
 	return 1;
 }
 
-void trace_find_cmdline(int pid, char comm[])
+static void __trace_find_cmdline(int pid, char comm[])
 {
 	unsigned map;
 
@@ -1503,13 +1503,19 @@ void trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
-	preempt_disable();
-	arch_spin_lock(&trace_cmdline_lock);
 	map = map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
 		strcpy(comm, saved_cmdlines[map]);
 	else
 		strcpy(comm, "<...>");
+}
+
+void trace_find_cmdline(int pid, char comm[])
+{
+	preempt_disable();
+	arch_spin_lock(&trace_cmdline_lock);
+
+	__trace_find_cmdline(pid, comm);
 
 	arch_spin_unlock(&trace_cmdline_lock);
 	preempt_enable();
@@ -3724,6 +3730,9 @@ static void *saved_cmdlines_start(struct seq_file *m, loff_t *pos)
 	void *v;
 	loff_t l = 0;
 
+	preempt_disable();
+	arch_spin_lock(&trace_cmdline_lock);
+
 	v = &map_cmdline_to_pid[0];
 	while (l <= *pos) {
 		v = saved_cmdlines_next(m, v, &l);
@@ -3736,6 +3745,8 @@ static void *saved_cmdlines_start(struct seq_file *m, loff_t *pos)
 
 static void saved_cmdlines_stop(struct seq_file *m, void *v)
 {
+	arch_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
 }
 
 static int saved_cmdlines_show(struct seq_file *m, void *v)
@@ -3743,7 +3754,7 @@ static int saved_cmdlines_show(struct seq_file *m, void *v)
 	char buf[TASK_COMM_LEN];
 	unsigned int *pid = v;
 
-	trace_find_cmdline(*pid, buf);
+	__trace_find_cmdline(*pid, buf);
 	seq_printf(m, "%d %s\n", *pid, buf);
 	return 0;
 }
-- 
2.0.0.rc2


