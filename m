Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3C2KBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:01:05 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39069 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3C2KBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:01:01 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 1/6] powerpc: Syscall hooks for context tracking subsystem
Date: Fri, 29 Mar 2013 18:00:16 +0800
Message-Id: <1364551221-23177-2-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032909-5816-0000-0000-0000075597A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the syscall slow path hooks for context tracking subsystem,
corresponding to
[PATCH] x86: Syscall hooks for userspace RCU extended QS
  commit bf5a3c13b939813d28ce26c01425054c740d6731

TIF_MEMDIE is moved to the second 16-bits (with value 17), as it seems there
is no asm code using it. TIF_NOHZ is added to _TIF_SYCALL_T_OR_A, so it is
better for it to be in the same 16 bits with others in the group, so in the
asm code, andi. with this group could work.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/powerpc/include/asm/thread_info.h |    7 +++++--
 arch/powerpc/kernel/ptrace.c           |    5 +++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 406b7b9..414a261 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -97,7 +97,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_PERFMON_CTXSW	6	/* perfmon needs ctxsw calls */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SINGLESTEP		8	/* singlestepping active */
-#define TIF_MEMDIE		9	/* is terminating due to OOM killer */
+#define TIF_NOHZ		9	/* in adaptive nohz mode */
 #define TIF_SECCOMP		10	/* secure computing */
 #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		12	/* Force successful syscall return */
@@ -106,6 +106,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACEPOINT	15	/* syscall tracepoint instrumentation */
 #define TIF_EMULATE_STACK_STORE	16	/* Is an instruction emulation
 						for stack store? */
+#define TIF_MEMDIE		17	/* is terminating due to OOM killer */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -124,8 +125,10 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_UPROBE		(1<<TIF_UPROBE)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_EMULATE_STACK_STORE	(1<<TIF_EMULATE_STACK_STORE)
+#define _TIF_NOHZ		(1<<TIF_NOHZ)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
-				 _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT)
+				 _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT | \
+				 _TIF_NOHZ)
 
 #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 245c1b6..0b7aad0 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -32,6 +32,7 @@
 #include <trace/syscall.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
+#include <linux/context_tracking.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -1778,6 +1779,8 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
+	user_exit();
+
 	secure_computing_strict(regs->gpr[0]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
@@ -1822,4 +1825,6 @@ void do_syscall_trace_leave(struct pt_regs *regs)
 	step = test_thread_flag(TIF_SINGLESTEP);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
+
+	user_enter();
 }
-- 
1.7.9.5

