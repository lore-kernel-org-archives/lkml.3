Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935292AbaGXKRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:17:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbaGXJra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 045/128] tracing: Try again for saved cmdline if failed due to locking
Date: Thu, 24 Jul 2014 10:44:54 +0100
Message-Id: <1406195177-8656-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 379cfdac37923653c9d4242d10052378b7563005 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f788ecfee618..56ecc310b818 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1417,12 +1417,12 @@ static void tracing_stop_tr(struct trace_array *tr)
 
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
@@ -1431,7 +1431,7 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	 * so if we miss here, then better luck next time.
 	 */
 	if (!arch_spin_trylock(&trace_cmdline_lock))
-		return;
+		return 0;
 
 	idx = map_pid_to_cmdline[tsk->pid];
 	if (idx == NO_CMDLINE_MAP) {
@@ -1456,6 +1456,8 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
 
 	arch_spin_unlock(&trace_cmdline_lock);
+
+	return 1;
 }
 
 void trace_find_cmdline(int pid, char comm[])
@@ -1497,9 +1499,8 @@ void tracing_record_cmdline(struct task_struct *tsk)
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
1.9.1

