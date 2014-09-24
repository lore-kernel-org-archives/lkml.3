Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaIXPEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:04:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaIXPDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:03:06 -0400
Date: Wed, 24 Sep 2014 08:02:06 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, dvlasenk@redhat.com, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, dvlasenk@redhat.com, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20140921184153.GA23727@redhat.com>
References: <20140921184153.GA23727@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Speed up ___preempt_schedule*()
  by using THUNK helpers
Git-Commit-ID: 0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
Gitweb:     http://git.kernel.org/tip/0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 21 Sep 2014 20:41:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 15:15:38 +0200

x86: Speed up ___preempt_schedule*() by using THUNK helpers

___preempt_schedule() does SAVE_ALL/RESTORE_ALL but this is
suboptimal, we do not need to save/restore the callee-saved
register. And we already have arch/x86/lib/thunk_*.S which
implements the similar asm wrappers, so it makes sense to
redefine ___preempt_schedule() as "THUNK ..." and remove
preempt.S altogether.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140921184153.GA23727@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/Makefile  |  2 --
 arch/x86/kernel/preempt.S | 25 -------------------------
 arch/x86/lib/thunk_32.S   | 20 ++++++++++++++++----
 arch/x86/lib/thunk_64.S   |  7 +++++++
 4 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index ada2e2d..8f1e774 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -39,8 +39,6 @@ obj-y			+= tsc.o tsc_msr.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
-obj-$(CONFIG_PREEMPT)	+= preempt.o
-
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
diff --git a/arch/x86/kernel/preempt.S b/arch/x86/kernel/preempt.S
deleted file mode 100644
index ca7f0d5..0000000
--- a/arch/x86/kernel/preempt.S
+++ /dev/null
@@ -1,25 +0,0 @@
-
-#include <linux/linkage.h>
-#include <asm/dwarf2.h>
-#include <asm/asm.h>
-#include <asm/calling.h>
-
-ENTRY(___preempt_schedule)
-	CFI_STARTPROC
-	SAVE_ALL
-	call preempt_schedule
-	RESTORE_ALL
-	ret
-	CFI_ENDPROC
-
-#ifdef CONFIG_CONTEXT_TRACKING
-
-ENTRY(___preempt_schedule_context)
-	CFI_STARTPROC
-	SAVE_ALL
-	call preempt_schedule_context
-	RESTORE_ALL
-	ret
-	CFI_ENDPROC
-
-#endif
diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
index 28f85c91..e9acf5f 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -7,16 +7,19 @@
 	#include <linux/linkage.h>
 	#include <asm/asm.h>
 
-#ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in eax (arg1) */
-	.macro thunk_ra name,func
+	.macro THUNK name, func, put_ret_addr_in_eax=0
 	.globl \name
 \name:
 	pushl %eax
 	pushl %ecx
 	pushl %edx
+
+	.if \put_ret_addr_in_eax
 	/* Place EIP in the arg1 */
 	movl 3*4(%esp), %eax
+	.endif
+
 	call \func
 	popl %edx
 	popl %ecx
@@ -25,6 +28,15 @@
 	_ASM_NOKPROBE(\name)
 	.endm
 
-	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
-	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
+#ifdef CONFIG_TRACE_IRQFLAGS
+	THUNK trace_hardirqs_on_thunk,trace_hardirqs_on_caller,1
+	THUNK trace_hardirqs_off_thunk,trace_hardirqs_off_caller,1
+#endif
+
+#ifdef CONFIG_PREEMPT
+	THUNK ___preempt_schedule, preempt_schedule
+#ifdef CONFIG_CONTEXT_TRACKING
+	THUNK ___preempt_schedule_context, preempt_schedule_context
 #endif
+#endif
+
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index 92d9fea..b30b5eb 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -38,6 +38,13 @@
 	THUNK lockdep_sys_exit_thunk,lockdep_sys_exit
 #endif
 
+#ifdef CONFIG_PREEMPT
+	THUNK ___preempt_schedule, preempt_schedule
+#ifdef CONFIG_CONTEXT_TRACKING
+	THUNK ___preempt_schedule_context, preempt_schedule_context
+#endif
+#endif
+
 	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
 	CFI_STARTPROC
 	SAVE_ARGS
