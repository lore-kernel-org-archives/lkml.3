Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926AbaDIQQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:16:46 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56716 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869AbaDIQLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:11:33 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/5] tracepoint: Convert process iteration to use for_each_process_thread()
Date: Wed,  9 Apr 2014 18:11:19 +0200
Message-Id: <1397059882-23063-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_each_thread/while_each_thread iterators are deprecated by
for_each_thread/for_each_process_thread() APIs.

Lets convert the callers in the tracepoint code. The ultimate
goal is to remove the struct task_struct::thread_group field and
the corresponding do_each_thread/while_each_thread iterators that are
RCU unsafe.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/tracepoint.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index fb0a38a..00a7e8b 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -561,15 +561,15 @@ static int sys_tracepoint_refcount;
 void syscall_regfunc(void)
 {
 	unsigned long flags;
-	struct task_struct *g, *t;
+	struct task_struct *p, *t;
 
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
+		for_each_process_thread(p, t) {
 			/* Skip kernel threads. */
 			if (t->mm)
 				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
+		}
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
 	sys_tracepoint_refcount++;
@@ -578,14 +578,14 @@ void syscall_regfunc(void)
 void syscall_unregfunc(void)
 {
 	unsigned long flags;
-	struct task_struct *g, *t;
+	struct task_struct *p, *t;
 
 	sys_tracepoint_refcount--;
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
+		for_each_process_thread(p, t) {
 			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
+		}
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
 }
-- 
1.8.3.1

