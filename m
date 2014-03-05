Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbaCEO04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41181 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbaCEO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 095/131] xtensa: introduce spill_registers_kernel macro
Date: Wed,  5 Mar 2014 14:23:39 +0000
Message-Id: <1394029455-23128-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit e2fd1374c705abe4661df3fb6fadb3879c7c1846 upstream.

Most in-kernel users want registers spilled on the kernel stack and
don't require PS.EXCM to be set. That means that they don't need fixup
routine and could reuse regular window overflow mechanism for that,
which makes spill routine very simple.

Suggested-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/xtensa/include/asm/traps.h | 44 +++++++++++++++++++-----------
 arch/xtensa/kernel/entry.S      | 60 ++++++++++++++++++++++++++++++++---------
 2 files changed, 76 insertions(+), 28 deletions(-)

diff --git a/arch/xtensa/include/asm/traps.h b/arch/xtensa/include/asm/traps.h
index 917488a..f2faa58 100644
--- a/arch/xtensa/include/asm/traps.h
+++ b/arch/xtensa/include/asm/traps.h
@@ -22,25 +22,37 @@ extern void do_unhandled(struct pt_regs *regs, unsigned long exccause);
 
 static inline void spill_registers(void)
 {
-
+#if XCHAL_NUM_AREGS > 16
 	__asm__ __volatile__ (
-		"movi	a14, "__stringify((1 << PS_EXCM_BIT) | LOCKLEVEL)"\n\t"
-		"mov	a12, a0\n\t"
-		"rsr	a13, sar\n\t"
-		"xsr	a14, ps\n\t"
-		"movi	a0, _spill_registers\n\t"
-		"rsync\n\t"
-		"callx0 a0\n\t"
-		"mov	a0, a12\n\t"
-		"wsr	a13, sar\n\t"
-		"wsr	a14, ps\n\t"
-		: :
-#if defined(CONFIG_FRAME_POINTER)
-		: "a2", "a3", "a4",       "a11", "a12", "a13", "a14", "a15",
+		"	call12	1f\n"
+		"	_j	2f\n"
+		"	retw\n"
+		"	.align	4\n"
+		"1:\n"
+		"	_entry	a1, 48\n"
+		"	addi	a12, a0, 3\n"
+#if XCHAL_NUM_AREGS > 32
+		"	.rept	(" __stringify(XCHAL_NUM_AREGS) " - 32) / 12\n"
+		"	_entry	a1, 48\n"
+		"	mov	a12, a0\n"
+		"	.endr\n"
+#endif
+		"	_entry	a1, 48\n"
+#if XCHAL_NUM_AREGS % 12 == 0
+		"	mov	a8, a8\n"
+#elif XCHAL_NUM_AREGS % 12 == 4
+		"	mov	a12, a12\n"
+#elif XCHAL_NUM_AREGS % 12 == 8
+		"	mov	a4, a4\n"
+#endif
+		"	retw\n"
+		"2:\n"
+		: : : "a12", "a13", "memory");
 #else
-		: "a2", "a3", "a4", "a7", "a11", "a12", "a13", "a14", "a15",
+	__asm__ __volatile__ (
+		"	mov	a12, a12\n"
+		: : : "memory");
 #endif
-		  "memory");
 }
 
 #endif /* _XTENSA_TRAPS_H */
diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index 9298742..10c94e6f 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1924,6 +1924,43 @@ ENTRY(system_call)
 
 ENDPROC(system_call)
 
+/*
+ * Spill live registers on the kernel stack macro.
+ *
+ * Entry condition: ps.woe is set, ps.excm is cleared
+ * Exit condition: windowstart has single bit set
+ * May clobber: a12, a13
+ */
+	.macro	spill_registers_kernel
+
+#if XCHAL_NUM_AREGS > 16
+	call12	1f
+	_j	2f
+	retw
+	.align	4
+1:
+	_entry	a1, 48
+	addi	a12, a0, 3
+#if XCHAL_NUM_AREGS > 32
+	.rept	(XCHAL_NUM_AREGS - 32) / 12
+	_entry	a1, 48
+	mov	a12, a0
+	.endr
+#endif
+	_entry	a1, 48
+#if XCHAL_NUM_AREGS % 12 == 0
+	mov	a8, a8
+#elif XCHAL_NUM_AREGS % 12 == 4
+	mov	a12, a12
+#elif XCHAL_NUM_AREGS % 12 == 8
+	mov	a4, a4
+#endif
+	retw
+2:
+#else
+	mov	a12, a12
+#endif
+	.endm
 
 /*
  * Task switch.
@@ -1936,21 +1973,20 @@ ENTRY(_switch_to)
 
 	entry	a1, 16
 
-	mov	a12, a2			# preserve 'prev' (a2)
-	mov	a13, a3			# and 'next' (a3)
+	mov	a10, a2			# preserve 'prev' (a2)
+	mov	a11, a3			# and 'next' (a3)
 
 	l32i	a4, a2, TASK_THREAD_INFO
 	l32i	a5, a3, TASK_THREAD_INFO
 
-	save_xtregs_user a4 a6 a8 a9 a10 a11 THREAD_XTREGS_USER
+	save_xtregs_user a4 a6 a8 a9 a12 a13 THREAD_XTREGS_USER
 
-	s32i	a0, a12, THREAD_RA	# save return address
-	s32i	a1, a12, THREAD_SP	# save stack pointer
+	s32i	a0, a10, THREAD_RA	# save return address
+	s32i	a1, a10, THREAD_SP	# save stack pointer
 
 	/* Disable ints while we manipulate the stack pointer. */
 
-	movi	a14, (1 << PS_EXCM_BIT) | LOCKLEVEL
-	xsr	a14, ps
+	rsil	a14, LOCKLEVEL
 	rsr	a3, excsave1
 	rsync
 	s32i	a3, a3, EXC_TABLE_FIXUP	/* enter critical section */
@@ -1965,7 +2001,7 @@ ENTRY(_switch_to)
 
 	/* Flush register file. */
 
-	call0	_spill_registers	# destroys a3, a4, and SAR
+	spill_registers_kernel
 
 	/* Set kernel stack (and leave critical section)
 	 * Note: It's save to set it here. The stack will not be overwritten
@@ -1981,13 +2017,13 @@ ENTRY(_switch_to)
 
 	/* restore context of the task 'next' */
 
-	l32i	a0, a13, THREAD_RA	# restore return address
-	l32i	a1, a13, THREAD_SP	# restore stack pointer
+	l32i	a0, a11, THREAD_RA	# restore return address
+	l32i	a1, a11, THREAD_SP	# restore stack pointer
 
-	load_xtregs_user a5 a6 a8 a9 a10 a11 THREAD_XTREGS_USER
+	load_xtregs_user a5 a6 a8 a9 a12 a13 THREAD_XTREGS_USER
 
 	wsr	a14, ps
-	mov	a2, a12			# return 'prev'
+	mov	a2, a10			# return 'prev'
 	rsync
 
 	retw
-- 
1.9.0

