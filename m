Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3DNQI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:08:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab3DNQIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:08:24 -0400
Date: Sun, 14 Apr 2013 18:05:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ptrace/x86: Revert "hw_breakpoints: Fix racy access to
	ptrace breakpoints"
Message-ID: <20130414160526.GA7635@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414160501.GA7612@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 87dc669ba25777b67796d7262c569429e58b1ed4.

The patch was fine but we can no longer race with SIGKILL after
9899d11f "ptrace: ensure arch_ptrace/ptrace_request can never race
with SIGKILL", the __TASK_TRACED tracee can't be woken up and
->ptrace_bps[] can't go away.

The patch only removes ptrace_get_breakpoints/ptrace_put_breakpoints
and does a couple of "while at it" cleanups, it doesn't remove other
changes from the reverted commit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/ptrace.c |   28 +++++-----------------------
 1 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 29a8120..7a98b21 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -641,9 +641,6 @@ static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
 	unsigned len, type;
 	struct perf_event *bp;
 
-	if (ptrace_get_breakpoints(tsk) < 0)
-		return -ESRCH;
-
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
 restore:
@@ -692,9 +689,7 @@ restore:
 		goto restore;
 	}
 
-	ptrace_put_breakpoints(tsk);
-
-	return ((orig_ret < 0) ? orig_ret : rc);
+	return orig_ret < 0 ? orig_ret : rc;
 }
 
 /*
@@ -706,18 +701,10 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 	unsigned long val = 0;
 
 	if (n < HBP_NUM) {
-		struct perf_event *bp;
+		struct perf_event *bp = thread->ptrace_bps[n];
 
-		if (ptrace_get_breakpoints(tsk) < 0)
-			return -ESRCH;
-
-		bp = thread->ptrace_bps[n];
-		if (!bp)
-			val = 0;
-		else
+		if (bp)
 			val = bp->hw.info.address;
-
-		ptrace_put_breakpoints(tsk);
 	} else if (n == 6) {
 		val = thread->debugreg6;
 	 } else if (n == 7) {
@@ -734,9 +721,6 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 	struct perf_event_attr attr;
 	int err = 0;
 
-	if (ptrace_get_breakpoints(tsk) < 0)
-		return -ESRCH;
-
 	if (!t->ptrace_bps[nr]) {
 		ptrace_breakpoint_init(&attr);
 		/*
@@ -762,7 +746,7 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		 */
 		if (IS_ERR(bp)) {
 			err = PTR_ERR(bp);
-			goto put;
+			goto out;
 		}
 
 		t->ptrace_bps[nr] = bp;
@@ -773,9 +757,7 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		attr.bp_addr = addr;
 		err = modify_user_hw_breakpoint(bp, &attr);
 	}
-
-put:
-	ptrace_put_breakpoints(tsk);
+out:
 	return err;
 }
 
-- 
1.5.5.1

