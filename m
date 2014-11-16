Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaKPWBD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:03 -0500
Received: from 1wt.eu ([62.212.114.60]:47936 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaKPWA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:56 -0500
Message-Id: <20141116215328.816577534@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:32 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, Willy Tarreau <w@1wt.eu>
Subject: [ 04/48] MIPS: Cleanup flags in syscall flags handlers.
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

This will simplify further modifications.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
(cherry picked from commit e7f3b48af7be9f8007a224663a5b91340626fed5)
[wt: this patch is only there to ease integration of next one]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/mips/include/asm/thread_info.h | 2 ++
 arch/mips/kernel/scall32-o32.S      | 2 +-
 arch/mips/kernel/scall64-64.S       | 2 +-
 arch/mips/kernel/scall64-n32.S      | 2 +-
 arch/mips/kernel/scall64-o32.S      | 2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 0e50757..2ef1662 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -145,6 +145,8 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define _TIF_FPUBOUND		(1<<TIF_FPUBOUND)
 #define _TIF_LOAD_WATCH		(1<<TIF_LOAD_WATCH)
 
+#define _TIF_WORK_SYSCALL_ENTRY	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT)
+
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
 /* work to do on any return to u-space */
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index fd2a9bb..b72c554 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -52,7 +52,7 @@ NESTED(handle_sys, PT_SIZE, sp)
 
 stack_done:
 	lw	t0, TI_FLAGS($28)	# syscall tracing enabled?
-	li	t1, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	and	t0, t1
 	bnez	t0, syscall_trace_entry	# -> yes
 
diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
index 18bf7f3..eaa345b 100644
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -54,7 +54,7 @@ NESTED(handle_sys64, PT_SIZE, sp)
 
 	sd	a3, PT_R26(sp)		# save a3 for syscall restarting
 
-	li	t1, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	LONG_L	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	and	t0, t1, t0
 	bnez	t0, syscall_trace_entry
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index 6ebc079..0a51c3d 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -53,7 +53,7 @@ NESTED(handle_sysn32, PT_SIZE, sp)
 
 	sd	a3, PT_R26(sp)		# save a3 for syscall restarting
 
-	li	t1, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	LONG_L	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	and	t0, t1, t0
 	bnez	t0, n32_syscall_trace_entry
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index 14dde4c..33ed571 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -81,7 +81,7 @@ NESTED(handle_sys, PT_SIZE, sp)
 	PTR	4b, bad_stack
 	.previous
 
-	li	t1, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	LONG_L	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	and	t0, t1, t0
 	bnez	t0, trace_a_syscall
-- 
1.7.12.2.21.g234cd45.dirty



