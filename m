Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3ARMbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:31:13 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:59289 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3ARMbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:31:10 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v2 39/76] ARC: Switch to saner kernel_execve() semantics #2
Date: Fri, 18 Jan 2013 17:54:53 +0530
Message-ID: <1358511930-7424-40-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fold ret_from_kernel_thread into ret_from_fork

The only difference is former needs to call thread entry point which can
be detected inside ret_from_fork too.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 arch/arc/kernel/entry.S   |   18 +++++++++++-------
 arch/arc/kernel/process.c |    8 ++++----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index b2291fc..69a0c9f 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -575,16 +575,20 @@ ARC_ENTRY ret_from_fork
 	; when the forked child comes here from the __switch_to function
 	; r0 has the last task pointer.
 	; put last task in scheduler queue
-	bl  @schedule_tail
-	b @ret_from_exception
-ARC_EXIT ret_from_fork
+	bl   @schedule_tail
+
+	; If kernel thread, jump to it's entry-point
+	ld   r9, [sp, PT_status32]
+	brne r9, 0, 1f
 
-ARC_ENTRY ret_from_kernel_thread
-	bl  @schedule_tail
-	jl.d [r14]		; kernel_thread "payload"
+	jl.d [r14]
 	mov  r0, r13		; arg to payload
+
+1:
+	; special case of kernel_thread entry point returning back due to
+	; kernel_execve() - pretend return from syscall to ret to userland
 	b    ret_from_exception
-ARC_EXIT ret_from_kernel_thread
+ARC_EXIT ret_from_fork
 
 ;################### Special Sys Call Wrappers ##########################
 
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index 20d8b4d..403de7e 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -99,7 +99,6 @@ void cpu_idle(void)
 }
 
 asmlinkage void ret_from_fork(void);
-asmlinkage void ret_from_kernel_thread(void) __attribute__((noreturn));
 
 /* Layout of Child kernel mode stack as setup at the end of this function is
  *
@@ -155,15 +154,16 @@ int copy_thread(unsigned long clone_flags,
 	 */
 	p->thread.ksp = (unsigned long)c_callee;	/* THREAD_KSP */
 
+	/* __switch_to expects FP(0), BLINK(return addr) at top */
+	childksp[0] = 0;			/* fp */
+	childksp[1] = (unsigned long)ret_from_fork; /* blink */
+
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		memset(c_regs, 0, sizeof(struct pt_regs));
 
 		c_callee->r13 = arg; /* argument to kernel thread */
 		c_callee->r14 = usp;  /* function */
 
-		/* __switch_to expects FP(0), BLINK(return addr) at top */
-		childksp[0] = 0;			/* fp */
-		childksp[1] = (unsigned long)ret_from_kernel_thread; /* blink */
 		return 0;
 	}
 
-- 
1.7.4.1

