Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaICVUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:20:20 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:54875 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566AbaICVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:29 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 10/24] ARM64: Introduce is_a32_task/is_a32_thread and TIF_AARCH32 and use them in the correct locations
Date: Wed,  3 Sep 2014 14:19:04 -0700
Message-Id: <1409779158-30963-11-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces is_a32_compat_task and is_a32_thread so it is easier to say this is a a32 specific thread or a generic compat thread/task.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/compat.h      |   21 +++++++++++++++++++++
 arch/arm64/include/asm/elf.h         |   12 ++++++++++--
 arch/arm64/include/asm/thread_info.h |    1 +
 arch/arm64/kernel/hw_breakpoint.c    |    7 ++++---
 arch/arm64/kernel/process.c          |    6 +++---
 arch/arm64/kernel/ptrace.c           |    8 ++++----
 arch/arm64/kernel/signal.c           |    5 +++--
 arch/arm64/kernel/traps.c            |    2 +-
 8 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 253e33b..8fcfb29 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -311,5 +311,26 @@ static inline int is_compat_thread(struct thread_info *thread)
 }
 
 #endif /* CONFIG_COMPAT */
+
+#ifdef CONFIG_AARCH32_EL0
+static inline int is_a32_compat_task(void)
+{
+	return test_thread_flag(TIF_AARCH32);
+}
+static inline int is_a32_compat_thread(struct thread_info *thread)
+{
+	return test_ti_thread_flag(thread, TIF_AARCH32);
+}
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
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_COMPAT_H */
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index b9217f0..ca27c02 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -135,7 +135,11 @@ extern unsigned long randomize_et_dyn(unsigned long base);
  */
 #define ELF_PLAT_INIT(_r, load_addr)	(_r)->regs[0] = 0
 
-#define SET_PERSONALITY(ex)		clear_thread_flag(TIF_32BIT);
+#define SET_PERSONALITY(ex)			\
+do {						\
+	clear_thread_flag(TIF_AARCH32);		\
+	clear_thread_flag(TIF_32BIT);		\
+} while (0)
 
 #define ARCH_DLINFO							\
 do {									\
@@ -184,7 +188,11 @@ typedef compat_elf_greg_t		compat_elf_gregset_t[COMPAT_A32_ELF_NGREG];
 					 ((x)->e_flags & EF_ARM_EABI_MASK))
 
 #define compat_start_thread		compat_start_thread
-#define COMPAT_SET_PERSONALITY(ex)	set_thread_flag(TIF_32BIT);
+#define COMPAT_SET_PERSONALITY(ex)		\
+do {						\
+	set_thread_flag(TIF_AARCH32);		\
+	set_thread_flag(TIF_32BIT);		\
+} while (0)
 #define COMPAT_ARCH_DLINFO
 extern int aarch32_setup_vectors_page(struct linux_binprm *bprm,
 				      int uses_interp);
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 45108d8..70aac31 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -114,6 +114,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SINGLESTEP		21
 #define TIF_32BIT		22	/* 32bit process */
 #define TIF_SWITCH_MM		23	/* deferred switch_mm */
+#define TIF_AARCH32		24	/* AARCH32 process */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index df1cf15..8e46a67 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -28,6 +28,7 @@
 #include <linux/ptrace.h>
 #include <linux/smp.h>
 
+#include <asm/compat.h>
 #include <asm/current.h>
 #include <asm/debug-monitors.h>
 #include <asm/hw_breakpoint.h>
@@ -433,7 +434,7 @@ static int arch_build_bp_info(struct perf_event *bp)
 	 * Watchpoints can be of length 1, 2, 4 or 8 bytes.
 	 */
 	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
-		if (is_compat_task()) {
+		if (is_a32_compat_task()) {
 			if (info->ctrl.len != ARM_BREAKPOINT_LEN_2 &&
 			    info->ctrl.len != ARM_BREAKPOINT_LEN_4)
 				return -EINVAL;
@@ -490,7 +491,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	 * AArch32 tasks expect some simple alignment fixups, so emulate
 	 * that here.
 	 */
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
 			alignment_mask = 0x7;
 		else
@@ -677,7 +678,7 @@ static int watchpoint_handler(unsigned long addr, unsigned int esr,
 
 		info = counter_arch_bp(wp);
 		/* AArch32 watchpoints are either 4 or 8 bytes aligned. */
-		if (is_compat_task()) {
+		if (is_a32_compat_task()) {
 			if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
 				alignment_mask = 0x7;
 			else
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 1309d64..8d775b4 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -260,7 +260,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	if (likely(!(p->flags & PF_KTHREAD))) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
-		if (is_compat_thread(task_thread_info(p))) {
+		if (is_a32_compat_thread(task_thread_info(p))) {
 			if (stack_start)
 				childregs->compat_sp = stack_start;
 		} else {
@@ -301,12 +301,12 @@ static void tls_thread_switch(struct task_struct *next)
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
index 033e07c..efabfc4 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -79,7 +79,7 @@ static void ptrace_hbptriggered(struct perf_event *bp,
 #ifdef CONFIG_AARCH32_EL0
 	int i;
 
-	if (!is_compat_task())
+	if (!is_a32_compat_task())
 		goto send_sig;
 
 	for (i = 0; i < ARM_MAX_BRP; ++i) {
@@ -1085,7 +1085,7 @@ long compat_a32_arch_ptrace(struct task_struct *child, compat_long_t request,
 long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			compat_ulong_t caddr, compat_ulong_t cdata)
 {
-	if (is_compat_task())
+	if (is_a32_compat_task())
 		return compat_a32_arch_ptrace(child, request, caddr, cdata);
 	return compat_ptrace_request(child, request, caddr, cdata);
 }
@@ -1095,7 +1095,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
 #ifdef CONFIG_AARCH32_EL0
-	if (is_compat_thread(task_thread_info(task)))
+	if (is_a32_compat_thread(task_thread_info(task)))
 		return &user_aarch32_view;
 #endif
 	return &user_aarch64_view;
@@ -1122,7 +1122,7 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 	 * A scratch register (ip(r12) on AArch32, x7 on AArch64) is
 	 * used to denote syscall entry/exit:
 	 */
-	regno = (is_compat_task() ? 12 : 7);
+	regno = (is_a32_compat_task() ? 12 : 7);
 	saved_reg = regs->regs[regno];
 	regs->regs[regno] = dir;
 
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 8527d99..f47c064 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -26,6 +26,7 @@
 #include <linux/tracehook.h>
 #include <linux/ratelimit.h>
 
+#include <asm/compat.h>
 #include <asm/debug-monitors.h>
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -276,7 +277,7 @@ static int setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
 
 static void setup_restart_syscall(struct pt_regs *regs)
 {
-	if (is_compat_task())
+	if (is_a32_compat_task())
 		compat_setup_restart_syscall(regs);
 	else
 		regs->regs[8] = __NR_restart_syscall;
@@ -302,7 +303,7 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	/*
 	 * Set up the stack frame
 	 */
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		if (ksig->ka.sa.sa_flags & SA_SIGINFO)
 			ret = compat_setup_rt_frame(usig, ksig, oldset, regs);
 		else
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 38a56d1..1d8bccc 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -290,7 +290,7 @@ asmlinkage long do_ni_syscall(struct pt_regs *regs)
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

