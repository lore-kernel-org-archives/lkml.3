Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3FZOYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3FZOYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:24:06 -0400
Date: Wed, 26 Jun 2013 16:19:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: manual merge of the akpm tree with the powerpc tree
Message-ID: <20130626141916.GA30716@redhat.com>
References: <20130626165642.8740ecb6d5d5882b06f173c8@canb.auug.org.au> <1372234231.18612.6.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372234231.18612.6.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Benjamin Herrenschmidt wrote:
>
> On Wed, 2013-06-26 at 16:56 +1000, Stephen Rothwell wrote:
> > Today's linux-next merge of the akpm tree got a conflict in
> > arch/powerpc/kernel/ptrace.c between commit b0b0aa9c7faf
> > ("powerpc/hw_brk: Fix setting of length for exact mode breakpoints") from
> > the powerpc tree and commit "ptrace/powerpc: revert "hw_breakpoints: Fix
> > racy access to ptrace breakpoints"" from the akpm tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
>
> Where does the latter come from ?

ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
attached below.

You were cc'ed every time ;)

> Why didn't it go through the powerpc tree ?

Because this series needs to update any user of ptrace_get/put_breakpoints
in arch/ (simply remove these calls), then change the core kernel code, then
fix arch/86.

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace/powerpc: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"

This reverts commit 07fa7a0a8a586 ("hw_breakpoints: Fix racy access to
ptrace breakpoints") and removes ptrace_get/put_breakpoints() added by
other commits.

The patch was fine but we can no longer race with SIGKILL after 9899d11f
("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"),
the __TASK_TRACED tracee can't be woken up and ->ptrace_bps[] can't go
away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ptrace.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN arch/powerpc/kernel/ptrace.c~ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints
+++ a/arch/powerpc/kernel/ptrace.c
@@ -974,16 +974,12 @@ int ptrace_set_debugreg(struct task_stru
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
@@ -996,11 +992,9 @@ int ptrace_set_debugreg(struct task_stru
 
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
@@ -1015,12 +1009,9 @@ int ptrace_set_debugreg(struct task_stru
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
@@ -1439,9 +1430,6 @@ static long ppc_set_hwdebug(struct task_
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)
 		brk.type |= HW_BRK_TYPE_WRITE;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(child) < 0)
-		return -ESRCH;
-
 	/*
 	 * Check if the request is for 'range' breakpoints. We can
 	 * support it if range < 8 bytes.
@@ -1449,12 +1437,10 @@ static long ppc_set_hwdebug(struct task_
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
 
@@ -1468,11 +1454,9 @@ static long ppc_set_hwdebug(struct task_
 					       ptrace_triggered, NULL, child);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
-		ptrace_put_breakpoints(child);
 		return PTR_ERR(bp);
 	}
 
-	ptrace_put_breakpoints(child);
 	return 1;
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
@@ -1516,16 +1500,12 @@ static long ppc_del_hwdebug(struct task_
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
_

Patches currently in -mm which might be from oleg@redhat.com are

posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch
x86-kill-tif_debug.patch


