Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaIXI1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:27:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:38720 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaIXI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:11 -0400
Message-Id: <20140924082242.186408915@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Sep 2014 10:18:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 04/11] exit: Deal with nested sleeps
References: <20140924081845.572814794@infradead.org>
Content-Disposition: inline; filename=peterz-might_sleep-exit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_wait() is a big wait loop, but we set TASK_RUNNING too late; we end
up calling potential sleeps before we reset it.

Not strictly a bug since we're guaranteed to exit the loop and not
call schedule(); put in annotations to quiet might_sleep().

 WARNING: CPU: 0 PID: 1 at ../kernel/sched/core.c:7123 __might_sleep+0x7e/0x90()
 do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff8109a788>] do_wait+0x88/0x270

 Call Trace:
  [<ffffffff81694991>] dump_stack+0x4e/0x7a
  [<ffffffff8109877c>] warn_slowpath_common+0x8c/0xc0
  [<ffffffff8109886c>] warn_slowpath_fmt+0x4c/0x50
  [<ffffffff810bca6e>] __might_sleep+0x7e/0x90
  [<ffffffff811a1c15>] might_fault+0x55/0xb0
  [<ffffffff8109a3fb>] wait_consider_task+0x90b/0xc10
  [<ffffffff8109a804>] do_wait+0x104/0x270
  [<ffffffff8109b837>] SyS_wait4+0x77/0x100
  [<ffffffff8169d692>] system_call_fastpath+0x16/0x1b

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/kernel.h |    2 ++
 kernel/exit.c          |    5 +++++
 2 files changed, 7 insertions(+)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -175,10 +175,12 @@ extern int _cond_resched(void);
  */
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
+# define fixup_sleep()	__set_current_state(TASK_RUNNING)
 #else
   static inline void __might_sleep(const char *file, int line,
 				   int preempt_offset) { }
 # define might_sleep() do { might_resched(); } while (0)
+# define fixup_sleep() do { } while (0)
 #endif
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -997,6 +997,8 @@ static int wait_task_zombie(struct wait_
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
+		fixup_sleep();
+
 		if ((exit_code & 0x7f) == 0) {
 			why = CLD_EXITED;
 			status = exit_code >> 8;
@@ -1079,6 +1081,7 @@ static int wait_task_zombie(struct wait_
 	 * thread can reap it because we its state == DEAD/TRACE.
 	 */
 	read_unlock(&tasklist_lock);
+	fixup_sleep();
 
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
@@ -1210,6 +1213,7 @@ static int wait_task_stopped(struct wait
 	pid = task_pid_vnr(p);
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
+	fixup_sleep();
 
 	if (unlikely(wo->wo_flags & WNOWAIT))
 		return wait_noreap_copyout(wo, p, pid, uid, why, exit_code);
@@ -1272,6 +1276,7 @@ static int wait_task_continued(struct wa
 	pid = task_pid_vnr(p);
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
+	fixup_sleep();
 
 	if (!wo->wo_info) {
 		retval = wo->wo_rusage


