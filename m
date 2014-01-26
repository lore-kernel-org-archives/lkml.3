Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaAZXEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 18:04:22 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48576 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaAZXEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 18:04:21 -0500
Date: Sun, 26 Jan 2014 15:04:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [RFC] wait*() induced tasklist_lock starvation
Message-ID: <alpine.DEB.2.02.1401261500250.5335@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

We've found that it's pretty easy to cause NMI watchdog timeouts due to 
tasklist_lock starvation by using repeated wait4(), waitid(), or waitpid() 
since it takes the readside of the lock and cascading calls to the 
syscalls from multiple processes will starve anything in the fork() or 
exit() path that is waiting on the writeside with irqs disabled.

The only way I've been able to remedy this problem is by serializing the 
taking of the readside of this lock with a spinlock specifically for these 
syscalls, otherwise my testcase will panic any machine if we panic on 
these NMI watchdog timeouts, which we do.

Is there any way we can do this in a less expensive way?  Or is it just 
another case of tasklist_lock problems that needs a major overhaul?
---
 kernel/exit.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/exit.c b/kernel/exit.c
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -59,6 +59,14 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
+/*
+ * Ensures the wait family of syscalls -- wait4(), waitid(), and waitpid() --
+ * don't cascade taking readside of tasklist_lock which will starve processes
+ * doing fork() or exit() and cause NMI watchdog timeouts with interrupts
+ * disabled.
+ */
+static DEFINE_SPINLOCK(wait_lock);
+
 static void exit_mm(struct task_struct * tsk);
 
 static void __unhash_process(struct task_struct *p, bool group_dead)
@@ -1028,6 +1036,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
+		spin_unlock(&wait_lock);
 		if ((exit_code & 0x7f) == 0) {
 			why = CLD_EXITED;
 			status = exit_code >> 8;
@@ -1112,6 +1121,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	 * thread can reap it because we set its state to EXIT_DEAD.
 	 */
 	read_unlock(&tasklist_lock);
+	spin_unlock(&wait_lock);
 
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
@@ -1246,6 +1256,7 @@ unlock_sig:
 	pid = task_pid_vnr(p);
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
+	spin_unlock(&wait_lock);
 
 	if (unlikely(wo->wo_flags & WNOWAIT))
 		return wait_noreap_copyout(wo, p, pid, uid, why, exit_code);
@@ -1308,6 +1319,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	pid = task_pid_vnr(p);
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
+	spin_unlock(&wait_lock);
 
 	if (!wo->wo_info) {
 		retval = wo->wo_rusage
@@ -1523,6 +1535,7 @@ repeat:
 		goto notask;
 
 	set_current_state(TASK_INTERRUPTIBLE);
+	spin_lock(&wait_lock);
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
@@ -1538,6 +1551,7 @@ repeat:
 			break;
 	} while_each_thread(current, tsk);
 	read_unlock(&tasklist_lock);
+	spin_unlock(&wait_lock);
 
 notask:
 	retval = wo->notask_error;
