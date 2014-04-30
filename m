Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbaD3Jwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:52:54 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:56987 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaD3Jww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:52:52 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: will.deacon@arm.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v6 1/4] arm64: make a single hook to syscall_trace() for all syscall features
Date: Wed, 30 Apr 2014 18:51:29 +0900
Message-Id: <1398851492-16345-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398851492-16345-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851492-16345-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently syscall_trace() is called only for ptrace.
With additional TIF_xx flags defined, it is now called in all the cases
of audit, ftrace and seccomp in addition to ptrace.

Acked-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/thread_info.h |   13 +++++++++++++
 arch/arm64/kernel/entry.S            |    5 +++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 720e70b..0a8b2a9 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -91,6 +91,9 @@ static inline struct thread_info *current_thread_info(void)
 /*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
+ *  TIF_SYSCALL_TRACEPOINT - syscall tracepoint for ftrace
+ *  TIF_SYSCALL_AUDIT	- syscall auditing
+ *  TIF_SECOMP		- syscall secure computing
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_NOTIFY_RESUME	- callback before returning to user
@@ -101,6 +104,9 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_SYSCALL_TRACE	8
+#define TIF_SYSCALL_AUDIT	9
+#define TIF_SYSCALL_TRACEPOINT	10
+#define TIF_SECCOMP		11
 #define TIF_POLLING_NRFLAG	16
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
@@ -112,10 +118,17 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
 				 _TIF_NOTIFY_RESUME)
 
+#define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
+				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP)
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_THREAD_INFO_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 39ac630..f9f2cae 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -631,8 +631,9 @@ el0_svc_naked:					// compat entry point
 	enable_irq
 
 	get_thread_info tsk
-	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
-	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
+	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall hooks
+	tst	x16, #_TIF_SYSCALL_WORK
+	b.ne	__sys_trace
 	adr	lr, ret_fast_syscall		// return address
 	cmp     scno, sc_nr                     // check upper syscall limit
 	b.hs	ni_sys
-- 
1.7.9.5

