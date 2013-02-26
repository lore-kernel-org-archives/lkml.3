Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575Ab3BZHDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:03:00 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:33821 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab3BZHCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:02:52 -0500
Date: Tue, 26 Feb 2013 08:02:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130226070247.GA14094@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: ff1fb5f6b4925a536ffb8171e5f2dbd01ccfeb97 Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent

 Thanks,

	Ingo

------------------>
Stephane Eranian (1):
      perf/x86: Add Intel IvyBridge event scheduling constraints

Steven Rostedt (1):
      tracing/syscalls: Allow archs to ignore tracing compat syscalls

Steven Rostedt (Red Hat) (1):
      ftrace: Call ftrace cleanup module notifier after all other notifiers


 arch/x86/include/asm/ftrace.h          | 24 ++++++++++++++++++
 arch/x86/include/asm/thread_info.h     |  1 -
 arch/x86/kernel/cpu/perf_event_intel.c | 23 ++++++++++++++++-
 kernel/trace/ftrace.c                  | 46 +++++++++++++++++++++++-----------
 kernel/trace/trace_syscalls.c          | 43 +++++++++++++++++++++++++++----
 5 files changed, 116 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 86cb51e..0525a8b 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -72,4 +72,28 @@ int ftrace_int3_handler(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 
+
+#if !defined(__ASSEMBLY__) && !defined(COMPILE_OFFSETS)
+
+#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_IA32_EMULATION)
+#include <asm/compat.h>
+
+/*
+ * Because ia32 syscalls do not map to x86_64 syscall numbers
+ * this screws up the trace output when tracing a ia32 task.
+ * Instead of reporting bogus syscalls, just do not trace them.
+ *
+ * If the user realy wants these, then they should use the
+ * raw syscall tracepoints with filtering.
+ */
+#define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS 1
+static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
+{
+	if (is_compat_task())
+		return true;
+	return false;
+}
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_IA32_EMULATION */
+#endif /* !__ASSEMBLY__  && !COMPILE_OFFSETS */
+
 #endif /* _ASM_X86_FTRACE_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 2d946e6..2cd056e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -20,7 +20,6 @@
 struct task_struct;
 struct exec_domain;
 #include <asm/processor.h>
-#include <asm/ftrace.h>
 #include <linux/atomic.h>
 
 struct thread_info {
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4914e94..529c893 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -107,6 +107,27 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	EVENT_CONSTRAINT_END
 };
 
+static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
+{
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
+	INTEL_UEVENT_CONSTRAINT(0x0148, 0x4), /* L1D_PEND_MISS.PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x0279, 0xf), /* IDQ.EMTPY */
+	INTEL_UEVENT_CONSTRAINT(0x019c, 0xf), /* IDQ_UOPS_NOT_DELIVERED.CORE */
+	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_EXECUTE */
+	INTEL_UEVENT_CONSTRAINT(0x05a3, 0xf), /* CYCLE_ACTIVITY.STALLS_L2_PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x06a3, 0xf), /* CYCLE_ACTIVITY.STALLS_LDM_PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x08a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x0ca3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
+	INTEL_EVENT_CONSTRAINT(0xd0, 0xf), /* MEM_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd1, 0xf), /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0xf), /*  MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+	EVENT_CONSTRAINT_END
+};
+
 static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
@@ -2095,7 +2116,7 @@ __init int intel_pmu_init(void)
 
 		intel_pmu_lbr_init_snb();
 
-		x86_pmu.event_constraints = intel_snb_event_constraints;
+		x86_pmu.event_constraints = intel_ivb_event_constraints;
 		x86_pmu.pebs_constraints = intel_ivb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ce8c3d6..98ca94a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3996,37 +3996,51 @@ static void ftrace_init_module(struct module *mod,
 	ftrace_process_locs(mod, start, end);
 }
 
-static int ftrace_module_notify(struct notifier_block *self,
-				unsigned long val, void *data)
+static int ftrace_module_notify_enter(struct notifier_block *self,
+				      unsigned long val, void *data)
 {
 	struct module *mod = data;
 
-	switch (val) {
-	case MODULE_STATE_COMING:
+	if (val == MODULE_STATE_COMING)
 		ftrace_init_module(mod, mod->ftrace_callsites,
 				   mod->ftrace_callsites +
 				   mod->num_ftrace_callsites);
-		break;
-	case MODULE_STATE_GOING:
+	return 0;
+}
+
+static int ftrace_module_notify_exit(struct notifier_block *self,
+				     unsigned long val, void *data)
+{
+	struct module *mod = data;
+
+	if (val == MODULE_STATE_GOING)
 		ftrace_release_mod(mod);
-		break;
-	}
 
 	return 0;
 }
 #else
-static int ftrace_module_notify(struct notifier_block *self,
-				unsigned long val, void *data)
+static int ftrace_module_notify_enter(struct notifier_block *self,
+				      unsigned long val, void *data)
+{
+	return 0;
+}
+static int ftrace_module_notify_exit(struct notifier_block *self,
+				     unsigned long val, void *data)
 {
 	return 0;
 }
 #endif /* CONFIG_MODULES */
 
-struct notifier_block ftrace_module_nb = {
-	.notifier_call = ftrace_module_notify,
+struct notifier_block ftrace_module_enter_nb = {
+	.notifier_call = ftrace_module_notify_enter,
 	.priority = INT_MAX,	/* Run before anything that can use kprobes */
 };
 
+struct notifier_block ftrace_module_exit_nb = {
+	.notifier_call = ftrace_module_notify_exit,
+	.priority = INT_MIN,	/* Run after anything that can remove kprobes */
+};
+
 extern unsigned long __start_mcount_loc[];
 extern unsigned long __stop_mcount_loc[];
 
@@ -4058,9 +4072,13 @@ void __init ftrace_init(void)
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
-	ret = register_module_notifier(&ftrace_module_nb);
+	ret = register_module_notifier(&ftrace_module_enter_nb);
+	if (ret)
+		pr_warning("Failed to register trace ftrace module enter notifier\n");
+
+	ret = register_module_notifier(&ftrace_module_exit_nb);
 	if (ret)
-		pr_warning("Failed to register trace ftrace module notifier\n");
+		pr_warning("Failed to register trace ftrace module exit notifier\n");
 
 	set_ftrace_early_filters();
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5329e13e..7a809e3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,5 +1,6 @@
 #include <trace/syscall.h>
 #include <trace/events/syscalls.h>
+#include <linux/syscalls.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>	/* for MODULE_NAME_LEN via KSYM_SYMBOL_LEN */
@@ -47,6 +48,38 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 }
 #endif
 
+#ifdef ARCH_TRACE_IGNORE_COMPAT_SYSCALLS
+/*
+ * Some architectures that allow for 32bit applications
+ * to run on a 64bit kernel, do not map the syscalls for
+ * the 32bit tasks the same as they do for 64bit tasks.
+ *
+ *     *cough*x86*cough*
+ *
+ * In such a case, instead of reporting the wrong syscalls,
+ * simply ignore them.
+ *
+ * For an arch to ignore the compat syscalls it needs to
+ * define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS as well as
+ * define the function arch_trace_is_compat_syscall() to let
+ * the tracing system know that it should ignore it.
+ */
+static int
+trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	if (unlikely(arch_trace_is_compat_syscall(regs)))
+		return -1;
+
+	return syscall_get_nr(task, regs);
+}
+#else
+static inline int
+trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	return syscall_get_nr(task, regs);
+}
+#endif /* ARCH_TRACE_IGNORE_COMPAT_SYSCALLS */
+
 static __init struct syscall_metadata *
 find_syscall_meta(unsigned long syscall)
 {
@@ -276,10 +309,10 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	int size;
 	int syscall_nr;
+	int size;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_enter_syscalls))
@@ -313,7 +346,7 @@ static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	struct ring_buffer *buffer;
 	int syscall_nr;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_exit_syscalls))
@@ -502,7 +535,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int rctx;
 	int size;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
@@ -578,7 +611,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int rctx;
 	int size;
 
-	syscall_nr = syscall_get_nr(current, regs);
+	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
