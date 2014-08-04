Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaHDKla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:41:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaHDKj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:39:56 -0400
Message-Id: <20140804103537.492992183@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 12:30:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 3/7] exit: Desl with nested sleeps
References: <20140804103025.478913141@infradead.org>
Content-Disposition: inline; filename=peterz-might_sleep-exit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_wait() is a big wait loop, but we set TASK_RUNNING too late; we end
up calling potential sleeps before we reset it.

Not strictly a bug in the current form, but clean it up to enable
debugging infrastructure and avoid it becoming a bug.

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


Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/exit.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -991,6 +991,8 @@ static int wait_task_zombie(struct wait_
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
+		__set_current_state(TASK_RUNNING);
+
 		if ((exit_code & 0x7f) == 0) {
 			why = CLD_EXITED;
 			status = exit_code >> 8;
@@ -1071,6 +1073,7 @@ static int wait_task_zombie(struct wait_
 	 * thread can reap it because we its state == DEAD/TRACE.
 	 */
 	read_unlock(&tasklist_lock);
+	__set_current_state(TASK_RUNNING);
 
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
@@ -1202,6 +1205,7 @@ static int wait_task_stopped(struct wait
 	pid = task_pid_vnr(p);
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
+	__set_current_state(TASK_RUNNING);
 
 	if (unlikely(wo->wo_flags & WNOWAIT))
 		return wait_noreap_copyout(wo, p, pid, uid, why, exit_code);
@@ -1264,6 +1268,7 @@ static int wait_task_continued(struct wa
 	pid = task_pid_vnr(p);
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
+	__set_current_state(TASK_RUNNING);
 
 	if (!wo->wo_info) {
 		retval = wo->wo_rusage


