Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3ARMbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:31:07 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:58787 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3ARMbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:31:02 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v2 38/76] ARC: Switch to saner kernel_execve() semantics #1
Date: Fri, 18 Jan 2013 17:54:52 +0530
Message-ID: <1358511930-7424-39-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prev kernel_execve() ensured return to userland using asm glue
ret_from_kernel_execve(). However given that
 -kernel_execve() is always called from inside a kernel_thread
 -and that a real kernel thread never directly "falls-off" into
  ret_from_kernel_thread() - either never return such as kthreadd or
  use kthread() wrapper which ensures tailing to do_exit.
 -core kernel enables returning from kernel_execve( ) path - by removing
  __init  annotation from kernel_init()

Thus we can utilize the thread-falling-off for returning to userland.

In summary:
A thread starts from ret_from_kernel_thread trampoline - leading to
kernel_execve. By making sure kernel_execve returns we end back into
ret_from_kernel_thread - which now returns as if from syscall - enabling
return to usermode.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 arch/arc/Kconfig              |    1 +
 arch/arc/include/asm/unistd.h |    1 -
 arch/arc/kernel/entry.S       |   12 +-----------
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 5588cee..3d5f940 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -17,6 +17,7 @@ config ARC
 	select GENERIC_FIND_FIRST_BIT
 	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_SHOW
+	select GENERIC_KERNEL_EXECVE
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/arc/include/asm/unistd.h b/arch/arc/include/asm/unistd.h
index 003b2cf..7841827 100644
--- a/arch/arc/include/asm/unistd.h
+++ b/arch/arc/include/asm/unistd.h
@@ -8,7 +8,6 @@
 
 /******** no-legacy-syscalls-ABI *******/
 
-#define __ARCH_WANT_KERNEL_EXECVE
 #define __ARCH_WANT_SYS_EXECVE
 
 #define sys_mmap2 sys_mmap_pgoff
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index d2cad3c..b2291fc 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -583,19 +583,9 @@ ARC_ENTRY ret_from_kernel_thread
 	bl  @schedule_tail
 	jl.d [r14]		; kernel_thread "payload"
 	mov  r0, r13		; arg to payload
-	j   @sys_exit
+	b    ret_from_exception
 ARC_EXIT ret_from_kernel_thread
 
-; When we land here, pt_regs have already been updated in-place correctly
-; for return to user mode.
-; However the call stack leading to kernel_execve() from say
-; ____call_usermodehelper() would make SP != pt_regs.
-; Thus we need to set SP to pt_regs as passed by kernel_execve() to us.
-ARC_ENTRY ret_from_kernel_execve
-	b.d   ret_from_exception
-	mov   sp, r0
-ARC_EXIT ret_from_kernel_execve
-
 ;################### Special Sys Call Wrappers ##########################
 
 ; TBD: call do_fork directly from here
-- 
1.7.4.1

