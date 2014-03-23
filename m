Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061AbaCWTIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:08:23 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37834 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCWTIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:08:22 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/trace: Use RCU_INIT_POINTER(x, NULL) in trace_syscalls.c
Date: Mon, 24 Mar 2014 00:37:21 +0530
Message-Id: <1395601641-12227-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 kernel/trace/trace_syscalls.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 759d5e0..4dc8b79 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -425,7 +425,7 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
-	rcu_assign_pointer(tr->enter_syscall_files[num], NULL);
+	RCU_INIT_POINTER(tr->enter_syscall_files[num], NULL);
 	if (!tr->sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
 	mutex_unlock(&syscall_trace_lock);
@@ -463,7 +463,7 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
-	rcu_assign_pointer(tr->exit_syscall_files[num], NULL);
+	RCU_INIT_POINTER(tr->exit_syscall_files[num], NULL);
 	if (!tr->sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
 	mutex_unlock(&syscall_trace_lock);
-- 
1.7.9.5

