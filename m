Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbaHVO2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:28:32 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:53254 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbaHVO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:28:31 -0400
Date: Fri, 22 Aug 2014 17:28:22 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] kernel: trace_syscalls: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140822142822.GA32391@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uses of "rcu_assign_pointer()" are NULLing out the pointers.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 kernel/trace/trace_syscalls.c | 4 ++--
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
1.9.1

