Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3HUOzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:55:51 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44952 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3HUOzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:55:49 -0400
From: Jiejing Zhang <kzjeef@gmail.com>
To: teven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc: Eric Miao <emiao@nvidia.com>, Jiejing Zhang <jiejzhang@nvidia.com>
Subject: [PATCH] ftrace: add tgid information in task switch event.
Date: Wed, 21 Aug 2013 15:05:20 +0000
Message-Id: <1377097520-24898-1-git-send-email-jasozhang@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiejing Zhang <jiejzhang@nvidia.com>

ftrace only report pid in task switch event, which is
actually thread ID in user space view, the comm of
the thread will be like "Thread-1", "Compiler", etc
in android system, it's useful if we can add tgid
information in ftrace event to find out the process
id, and the process id's comm will help us to figure
out the application, which was useful on data analysis
tools.

Change-Id: Ia99f58a56d691d770b3beb2f76de0351e6194a4a
Signed-off-by: Jiejing Zhang <jiejzhang@nvidia.com>
---
 include/trace/events/sched.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index e5586ca..3fbcddb 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -124,32 +124,37 @@ TRACE_EVENT(sched_switch,
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	prev_pid			)
+		__field(	pid_t,	prev_tgid			)
 		__field(	int,	prev_prio			)
 		__field(	long,	prev_state			)
 		__array(	char,	next_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	next_pid			)
+		__field(	pid_t,	next_tgid			)
 		__field(	int,	next_prio			)
 	),
 
 	TP_fast_assign(
 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
+		__entry->prev_tgid	= prev->tgid;
 		__entry->prev_prio	= prev->prio;
 		__entry->prev_state	= __trace_sched_switch_state(prev);
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
+		__entry->next_tgid	= next->tgid;
 		__entry->next_prio	= next->prio;
 	),
 
-	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d",
-		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
+	TP_printk("prev_comm=%s prev_pid=%d prev_tgid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_tgid=%d next_prio=%d",
+		__entry->prev_comm, __entry->prev_pid,
+		__entry->prev_tgid,  __entry->prev_prio,
 		__entry->prev_state & (TASK_STATE_MAX-1) ?
-		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
+		__print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
 				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
 				{ 128, "K" }, { 256, "W" }, { 512, "P" }) : "R",
 		__entry->prev_state & TASK_STATE_MAX ? "+" : "",
-		__entry->next_comm, __entry->next_pid, __entry->next_prio)
+		__entry->next_comm, __entry->next_pid, __entry->next_tgid, __entry->next_prio)
 );
 
 /*
-- 
1.8.1.5

