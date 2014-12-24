Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbaLXAm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 19:42:29 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34659 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbaLXAm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 19:42:27 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux@arm.linux.org.uk, Jason Wessel <jason.wessel@windriver.com>
Cc: Kevin Hilman <khilman@linaro.org>, osandov@osandov.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Doug Anderson <dianders@chromium.org>, nico@linaro.org,
        will.deacon@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] arm: kgdb: Fix registers on sleeping tasks
Date: Tue, 23 Dec 2014 16:42:06 -0800
Message-Id: <1419381727-29046-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dumping registers from other sleeping tasks in KGDB was totally
failing for me.  All registers were reported as 0.

It looks as if the code was looking at at "task_pt_regs(task)" for the
sleeping task and they were all 0.  I'm not exactly sure why this
structure was used and why it wasn't filled in.

There is a more reliable place to look for all of the important
registers for a sleeping task: the task_thread_info.  This is the same
place that is referred to when doing a dump of all sleeping task
stacks (kdb_show_stack() -> show_stack() -> dump_backtrace() ->
unwind_backtrace() -> thread_saved_sp()).

Let's use the more reliable place for all registers that are saved
there.  We'll fall back to the task_pt_regs() for registers that we
don't have.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/kernel/kgdb.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index 07db2f8..bab69db 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -75,6 +75,7 @@ int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
 void
 sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *task)
 {
+	struct thread_info *ti;
 	struct pt_regs *thread_regs;
 	int regno;
 
@@ -86,24 +87,34 @@ sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *task)
 	for (regno = 0; regno < GDB_MAX_REGS; regno++)
 		gdb_regs[regno] = 0;
 
-	/* Otherwise, we have only some registers from switch_to() */
+	/*
+	 * Try to get as much as we can from the thread_info since the
+	 * pt_regs structure doesn't seem right in most cases.
+	 */
+	ti			= task_thread_info(task);
+	gdb_regs[_R4]		= ti->cpu_context.r4;
+	gdb_regs[_R5]		= ti->cpu_context.r5;
+	gdb_regs[_R6]		= ti->cpu_context.r6;
+	gdb_regs[_R7]		= ti->cpu_context.r7;
+	gdb_regs[_R8]		= ti->cpu_context.r8;
+	gdb_regs[_R9]		= ti->cpu_context.r9;
+	gdb_regs[_R10]		= ti->cpu_context.sl;
+	gdb_regs[_FP]		= ti->cpu_context.fp;
+	gdb_regs[_SPT]		= ti->cpu_context.sp;
+	gdb_regs[_PC]		= ti->cpu_context.pc;
+
+	/*
+	 * task_thread_info() doesn't store callee-saved registers so we'll
+	 * give task_pt_regs() a shot here.  I've never actually seen that be
+	 * valid, though
+	 */
 	thread_regs		= task_pt_regs(task);
 	gdb_regs[_R0]		= thread_regs->ARM_r0;
 	gdb_regs[_R1]		= thread_regs->ARM_r1;
 	gdb_regs[_R2]		= thread_regs->ARM_r2;
 	gdb_regs[_R3]		= thread_regs->ARM_r3;
-	gdb_regs[_R4]		= thread_regs->ARM_r4;
-	gdb_regs[_R5]		= thread_regs->ARM_r5;
-	gdb_regs[_R6]		= thread_regs->ARM_r6;
-	gdb_regs[_R7]		= thread_regs->ARM_r7;
-	gdb_regs[_R8]		= thread_regs->ARM_r8;
-	gdb_regs[_R9]		= thread_regs->ARM_r9;
-	gdb_regs[_R10]		= thread_regs->ARM_r10;
-	gdb_regs[_FP]		= thread_regs->ARM_fp;
 	gdb_regs[_IP]		= thread_regs->ARM_ip;
-	gdb_regs[_SPT]		= thread_regs->ARM_sp;
 	gdb_regs[_LR]		= thread_regs->ARM_lr;
-	gdb_regs[_PC]		= thread_regs->ARM_pc;
 	gdb_regs[_CPSR]		= thread_regs->ARM_cpsr;
 }
 
-- 
2.2.0.rc0.207.ga3a616c

