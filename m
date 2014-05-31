Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935084AbaEaBkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:40:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:54987 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932750AbaEaBj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:39:28 -0400
Message-Id: <20140531013926.518064866@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 30 May 2014 21:39:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 6/7] tracing: Try again for saved cmdline if failed due to locking
References: <20140531013857.160310242@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-tracing-Try-again-for-saved-cmdline-if-failed-due-to.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In order to prevent the saved cmdline cache from being filled when
tracing is not active, the comms are only recorded after a trace event
is recorded.

The problem is, a comm can fail to be recorded if the trace_cmdline_lock
is held. That lock is taken via a trylock to allow it to happen from
any context (including NMI). If the lock fails to be taken, the comm
is skipped. No big deal, as we will try again later.

But! Because of the code that was added to only record after an event,
we may not try again later as the recording is made as a oneshot per
event per CPU.

Only disable the recording of the comm if the comm is actually recorded.

Fixes: 7ffbd48d5cab "tracing: Cache comms only after an event occurred"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1855dae73f34..22a902e2ded9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1441,12 +1441,12 @@ static void tracing_stop_tr(struct trace_array *tr)
 
 void trace_stop_cmdline_recording(void);
 
-static void trace_save_cmdline(struct task_struct *tsk)
+static int trace_save_cmdline(struct task_struct *tsk)
 {
 	unsigned pid, idx;
 
 	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
-		return;
+		return 0;
 
 	/*
 	 * It's not the end of the world if we don't get
@@ -1455,7 +1455,7 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	 * so if we miss here, then better luck next time.
 	 */
 	if (!arch_spin_trylock(&trace_cmdline_lock))
-		return;
+		return 0;
 
 	idx = map_pid_to_cmdline[tsk->pid];
 	if (idx == NO_CMDLINE_MAP) {
@@ -1480,6 +1480,8 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
 
 	arch_spin_unlock(&trace_cmdline_lock);
+
+	return 1;
 }
 
 void trace_find_cmdline(int pid, char comm[])
@@ -1521,9 +1523,8 @@ void tracing_record_cmdline(struct task_struct *tsk)
 	if (!__this_cpu_read(trace_cmdline_save))
 		return;
 
-	__this_cpu_write(trace_cmdline_save, false);
-
-	trace_save_cmdline(tsk);
+	if (trace_save_cmdline(tsk))
+		__this_cpu_write(trace_cmdline_save, false);
 }
 
 void
-- 
2.0.0.rc2


