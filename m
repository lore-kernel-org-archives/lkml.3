Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3DNQKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:10:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab3DNQKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:10:01 -0400
Date: Sun, 14 Apr 2013 18:05:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ptrace/powerpc: Revert "hw_breakpoints: Fix racy
	access to ptrace breakpoints"
Message-ID: <20130414160530.GA7643@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414160501.GA7612@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 07fa7a0a8a586c01a8b416358c7012dcb9dc688d and
removes ptrace_get/put_breakpoints() added by other commits.

The patch was fine but we can no longer race with SIGKILL after
9899d11f "ptrace: ensure arch_ptrace/ptrace_request can never race
with SIGKILL", the __TASK_TRACED tracee can't be woken up and
->ptrace_bps[] can't go away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/ptrace.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index f9b30c6..d278e43 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -969,16 +969,12 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 	hw_brk.type = (data & HW_BRK_TYPE_DABR) | HW_BRK_TYPE_PRIV_ALL;
 	hw_brk.len = 8;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(task) < 0)
-		return -ESRCH;
-
 	bp = thread->ptrace_bps[0];
 	if ((!data) || !(hw_brk.type & HW_BRK_TYPE_RDWR)) {
 		if (bp) {
 			unregister_hw_breakpoint(bp);
 			thread->ptrace_bps[0] = NULL;
 		}
-		ptrace_put_breakpoints(task);
 		return 0;
 	}
 	if (bp) {
@@ -991,11 +987,9 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 
 		ret =  modify_user_hw_breakpoint(bp, &attr);
 		if (ret) {
-			ptrace_put_breakpoints(task);
 			return ret;
 		}
 		thread->ptrace_bps[0] = bp;
-		ptrace_put_breakpoints(task);
 		thread->hw_brk = hw_brk;
 		return 0;
 	}
@@ -1010,12 +1004,9 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 					       ptrace_triggered, NULL, task);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
-		ptrace_put_breakpoints(task);
 		return PTR_ERR(bp);
 	}
 
-	ptrace_put_breakpoints(task);
-
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 	task->thread.hw_brk = hw_brk;
 #else /* CONFIG_PPC_ADV_DEBUG_REGS */
@@ -1434,9 +1425,6 @@ static long ppc_set_hwdebug(struct task_struct *child,
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)
 		brk.type |= HW_BRK_TYPE_WRITE;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(child) < 0)
-		return -ESRCH;
-
 	/*
 	 * Check if the request is for 'range' breakpoints. We can
 	 * support it if range < 8 bytes.
@@ -1444,12 +1432,10 @@ static long ppc_set_hwdebug(struct task_struct *child,
 	if (bp_info->addr_mode == PPC_BREAKPOINT_MODE_RANGE_INCLUSIVE) {
 		len = bp_info->addr2 - bp_info->addr;
 	} else if (bp_info->addr_mode != PPC_BREAKPOINT_MODE_EXACT) {
-		ptrace_put_breakpoints(child);
 		return -EINVAL;
 	}
 	bp = thread->ptrace_bps[0];
 	if (bp) {
-		ptrace_put_breakpoints(child);
 		return -ENOSPC;
 	}
 
@@ -1463,11 +1449,9 @@ static long ppc_set_hwdebug(struct task_struct *child,
 					       ptrace_triggered, NULL, child);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
-		ptrace_put_breakpoints(child);
 		return PTR_ERR(bp);
 	}
 
-	ptrace_put_breakpoints(child);
 	return 1;
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
@@ -1511,16 +1495,12 @@ static long ppc_del_hwdebug(struct task_struct *child, long data)
 		return -EINVAL;
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(child) < 0)
-		return -ESRCH;
-
 	bp = thread->ptrace_bps[0];
 	if (bp) {
 		unregister_hw_breakpoint(bp);
 		thread->ptrace_bps[0] = NULL;
 	} else
 		ret = -ENOENT;
-	ptrace_put_breakpoints(child);
 	return ret;
 #else /* CONFIG_HAVE_HW_BREAKPOINT */
 	if (child->thread.hw_brk.address == 0)
-- 
1.5.5.1

