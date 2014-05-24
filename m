Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaEXHJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:09:38 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:48791 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaEXHJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:09:31 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 10/24] ARM64: Introduce is_a32_task and is_a32_thread. Use them in the correct locations.
Date: Sat, 24 May 2014 00:02:05 -0700
Message-Id: <1400914939-9708-11-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces is_a32_compat_task and is_a32_thread so it is easier to say this is a a32 specific thread or a generic compat thread/task.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/compat.h      |   31 +++++++++++++++++++++++++------
 arch/arm64/include/asm/elf.h         |    2 +-
 arch/arm64/include/asm/memory.h      |    2 +-
 arch/arm64/include/asm/processor.h   |    2 +-
 arch/arm64/include/asm/thread_info.h |    2 +-
 arch/arm64/kernel/hw_breakpoint.c    |    6 +++---
 arch/arm64/kernel/process.c          |    6 +++---
 arch/arm64/kernel/ptrace.c           |   10 +++++-----
 arch/arm64/kernel/signal.c           |    4 ++--
 arch/arm64/kernel/traps.c            |    2 +-
 10 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index e71f81f..fad7612 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -293,28 +293,47 @@ struct compat_shmid64_ds {
 	compat_ulong_t __unused5;
 };
 
-static inline int is_compat_task(void)
+#ifdef CONFIG_AARCH32_EL0
+static inline int is_a32_compat_task(void)
 {
 	return test_thread_flag(TIF_32BIT);
 }
-
-static inline int is_compat_thread(struct thread_info *thread)
+static inline int is_a32_compat_thread(struct thread_info *thread)
 {
 	return test_ti_thread_flag(thread, TIF_32BIT);
 }
+#else
+static inline int is_a32_compat_task(void)
+{
+	return 0;
+}
+static inline int is_a32_compat_thread(struct thread_info *thread)
+{
+	return 0;
+}
+#endif
 
 #else /* !CONFIG_COMPAT */
 
-static inline int is_compat_task(void)
+static inline int is_a32_compat_task(void)
 {
 	return 0;
 }
-
-static inline int is_compat_thread(struct thread_info *thread)
+static inline int is_a32_compat_thread(struct thread_info *thread)
 {
 	return 0;
 }
 
 #endif /* CONFIG_COMPAT */
+
+static inline int is_compat_task(void)
+{
+	return is_a32_compat_task();
+}
+
+static inline int is_compat_thread(struct thread_info *thread)
+{
+	return is_a32_compat_thread(thread);
+}
 #endif /* __KERNEL__ */
 #endif /* __ASM_COMPAT_H */
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 36c3603..8180511 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -150,7 +150,7 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 /* 1GB of VA */
 #ifdef CONFIG_COMPAT
-#define STACK_RND_MASK			(test_thread_flag(TIF_32BIT) ? \
+#define STACK_RND_MASK			(is_compat_task() ? \
 						0x7ff >> (PAGE_SHIFT - 12) : \
 						0x3ffff >> (PAGE_SHIFT - 12))
 #else
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 993bce5..2ab203e 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -54,7 +54,7 @@
 
 #ifdef CONFIG_COMPAT
 #define TASK_SIZE_32		UL(0x100000000)
-#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
+#define TASK_SIZE		(is_compat_task() ?		\
 				TASK_SIZE_32 : TASK_SIZE_64)
 #else
 #define TASK_SIZE		TASK_SIZE_64
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 45b20cd..ee487f3 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -38,7 +38,7 @@
 #define STACK_TOP_MAX		TASK_SIZE_64
 #ifdef CONFIG_COMPAT
 #define AARCH32_VECTORS_BASE	0xffff0000
-#define STACK_TOP		(test_thread_flag(TIF_32BIT) ? \
+#define STACK_TOP		(is_compat_task() ? \
 				AARCH32_VECTORS_BASE : STACK_TOP_MAX)
 #else
 #define STACK_TOP		STACK_TOP_MAX
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 720e70b..b2bf728 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -106,7 +106,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
 #define TIF_SINGLESTEP		21
-#define TIF_32BIT		22	/* 32bit process */
+#define TIF_32BIT		22	/* AARCH32 process */
 #define TIF_SWITCH_MM		23	/* deferred switch_mm */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index bee7897..87aa8c1 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -433,7 +433,7 @@ static int arch_build_bp_info(struct perf_event *bp)
 	 * Watchpoints can be of length 1, 2, 4 or 8 bytes.
 	 */
 	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
-		if (is_compat_task()) {
+		if (is_a32_compat_task()) {
 			if (info->ctrl.len != ARM_BREAKPOINT_LEN_2 &&
 			    info->ctrl.len != ARM_BREAKPOINT_LEN_4)
 				return -EINVAL;
@@ -490,7 +490,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	 * AArch32 tasks expect some simple alignment fixups, so emulate
 	 * that here.
 	 */
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
 			alignment_mask = 0x7;
 		else
@@ -677,7 +677,7 @@ static int watchpoint_handler(unsigned long addr, unsigned int esr,
 
 		info = counter_arch_bp(wp);
 		/* AArch32 watchpoints are either 4 or 8 bytes aligned. */
-		if (is_compat_task()) {
+		if (is_a32_compat_task()) {
 			if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
 				alignment_mask = 0x7;
 			else
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6391485..fa0117f 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -223,7 +223,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	if (likely(!(p->flags & PF_KTHREAD))) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
-		if (is_compat_thread(task_thread_info(p))) {
+		if (is_a32_compat_thread(task_thread_info(p))) {
 			if (stack_start)
 				childregs->compat_sp = stack_start;
 		} else {
@@ -264,12 +264,12 @@ static void tls_thread_switch(struct task_struct *next)
 {
 	unsigned long tpidr, tpidrro;
 
-	if (!is_compat_task()) {
+	if (!is_a32_compat_task()) {
 		asm("mrs %0, tpidr_el0" : "=r" (tpidr));
 		current->thread.tp_value = tpidr;
 	}
 
-	if (is_compat_thread(task_thread_info(next))) {
+	if (is_a32_compat_thread(task_thread_info(next))) {
 		tpidr = 0;
 		tpidrro = next->thread.tp_value;
 	} else {
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 67a0f4d..7fb1377 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -72,7 +72,7 @@ static void ptrace_hbptriggered(struct perf_event *bp,
 #ifdef CONFIG_AARCH32_EL0
 	int i;
 
-	if (!is_compat_task())
+	if (!is_a32_compat_task())
 		goto send_sig;
 
 	for (i = 0; i < ARM_MAX_BRP; ++i) {
@@ -1053,7 +1053,7 @@ long compat_a32_arch_ptrace(struct task_struct *child, compat_long_t request,
 long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			compat_ulong_t caddr, compat_ulong_t cdata)
 {
-	if (is_compat_task())
+	if (is_a32_compat_task())
 		return compat_a32_arch_ptrace(child, request, caddr, cdata);
 	return compat_ptrace_request(child, request, caddr, cdata);
 }
@@ -1063,7 +1063,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
 #ifdef CONFIG_AARCH32_EL0
-	if (is_compat_thread(task_thread_info(task)))
+	if (is_a32_compat_thread(task_thread_info(task)))
 		return &user_aarch32_view;
 #endif
 	return &user_aarch64_view;
@@ -1082,7 +1082,7 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return regs->syscallno;
 
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		/* AArch32 uses ip (r12) for scratch */
 		saved_reg = regs->regs[12];
 		regs->regs[12] = dir;
@@ -1100,7 +1100,7 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 	else if (tracehook_report_syscall_entry(regs))
 		regs->syscallno = ~0UL;
 
-	if (is_compat_task())
+	if (is_a32_compat_task())
 		regs->regs[12] = saved_reg;
 	else
 		regs->regs[7] = saved_reg;
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 12b232a..8168613 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -268,7 +268,7 @@ static int setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
 
 static void setup_restart_syscall(struct pt_regs *regs)
 {
-	if (is_compat_task())
+	if (is_a32_compat_task())
 		compat_setup_restart_syscall(regs);
 	else
 		regs->regs[8] = __NR_restart_syscall;
@@ -295,7 +295,7 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
 	/*
 	 * Set up the stack frame
 	 */
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
 			ret = compat_setup_rt_frame(usig, ka, info, oldset,
 						    regs);
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 25dae1a..5b1e40a 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -287,7 +287,7 @@ asmlinkage long do_ni_syscall(struct pt_regs *regs)
 {
 #ifdef CONFIG_AARCH32_EL0
 	long ret;
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		ret = compat_arm_syscall(regs);
 		if (ret != -ENOSYS)
 			return ret;
-- 
1.7.2.5

