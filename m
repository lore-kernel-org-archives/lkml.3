Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaAaIPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:15:04 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34720 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaAaIPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:15:01 -0500
Date: Fri, 31 Jan 2014 09:14:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] debugging updates
Message-ID: <20140131081456.GA7544@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   # HEAD: 270750dbc18a71b23d660df110e433ff9616a2d4 hung_task: Display every hung task warning

It contains mostly kernel debugging related updates:

   - make hung_task detection more configurable to distros
   - add final bits for x86 UV NMI debugging, with related KGDB changes
   - update the mailing-list of MAINTAINERS entries I'm involved with

 Thanks,

	Ingo

------------------>
Aaron Tomlin (2):
      sysctl: Add neg_one as a standard constraint
      hung_task: Display every hung task warning

Ingo Molnar (1):
      MAINTAINERS: Restore "L: linux-kernel@vger.kernel.org" entries

Mike Travis (3):
      kgdb/kdb: Fix no KDB config problem
      x86/uv/nmi: Fix Sparse warnings
      x86/uv/nmi, kgdb/kdb: Fix UV NMI handler when KDB not configured


 Documentation/sysctl/kernel.txt    | 42 ++++++++++++++++++++++++
 MAINTAINERS                        | 13 ++++++++
 arch/x86/include/asm/uv/uv.h       |  2 --
 arch/x86/kernel/apic/x2apic_uv_x.c |  1 -
 arch/x86/platform/uv/uv_nmi.c      | 65 +++++++++++++++++++++++++++-----------
 include/linux/kgdb.h               |  3 +-
 include/linux/sched/sysctl.h       |  2 +-
 kernel/debug/debug_core.c          |  5 +--
 kernel/debug/debug_core.h          |  2 --
 kernel/hung_task.c                 |  6 ++--
 kernel/sysctl.c                    |  7 ++--
 11 files changed, 116 insertions(+), 32 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6d48640..4205f3c 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -33,6 +33,10 @@ show up in /proc/sys/kernel:
 - domainname
 - hostname
 - hotplug
+- hung_task_panic
+- hung_task_check_count
+- hung_task_timeout_secs
+- hung_task_warnings
 - kptr_restrict
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
@@ -287,6 +291,44 @@ Default value is "/sbin/hotplug".
 
 ==============================================================
 
+hung_task_panic:
+
+Controls the kernel's behavior when a hung task is detected.
+This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+
+0: continue operation. This is the default behavior.
+
+1: panic immediately.
+
+==============================================================
+
+hung_task_check_count:
+
+The upper bound on the number of tasks that are checked.
+This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+
+==============================================================
+
+hung_task_timeout_secs:
+
+Check interval. When a task in D state did not get scheduled
+for more than this value report a warning.
+This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+
+0: means infinite timeout - no checking done.
+
+==============================================================
+
+hung_task_warning:
+
+The maximum number of warnings to report. During a check interval
+When this value is reached, no more the warnings will be reported.
+This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+
+-1: report an infinite number of warnings.
+
+==============================================================
+
 kptr_restrict:
 
 This toggle indicates whether restrictions are placed on
diff --git a/MAINTAINERS b/MAINTAINERS
index ce1645e..e048de5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2191,6 +2191,7 @@ F:	include/linux/clk.h
 CLOCKSOURCE, CLOCKEVENT DRIVERS
 M:	Daniel Lezcano <daniel.lezcano@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	drivers/clocksource
@@ -3985,6 +3986,7 @@ F:	include/uapi/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Maintained
 F:	Documentation/timers/
@@ -4654,6 +4656,7 @@ F:	net/irda/
 
 IRQ SUBSYSTEM
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 F:	kernel/irq/
@@ -5285,6 +5288,7 @@ F:	drivers/media/usb/dvb-usb-v2/lmedm04*
 LOCKDEP AND LOCKSTAT
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Ingo Molnar <mingo@redhat.com>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/locking
 S:	Maintained
 F:	Documentation/lockdep*.txt
@@ -6581,6 +6585,7 @@ M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@redhat.com>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Supported
 F:	kernel/events/*
@@ -6704,6 +6709,7 @@ F:	drivers/scsi/pm8001/
 
 POSIX CLOCKS and TIMERS
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	fs/timerfd.c
@@ -7099,6 +7105,7 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/torture.txt
@@ -7106,6 +7113,7 @@ F:	kernel/rcu/torture.c
 
 RCUTORTURE TEST FRAMEWORK
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	tools/testing/selftests/rcutorture
@@ -7129,6 +7137,7 @@ F:	net/rds/
 READ-COPY UPDATE (RCU)
 M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
@@ -7432,6 +7441,7 @@ F:	drivers/mmc/host/dw_mmc*
 TIMEKEEPING, CLOCKSOURCE CORE, NTP
 M:	John Stultz <john.stultz@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	include/linux/clocksource.h
@@ -7457,6 +7467,7 @@ F:	drivers/watchdog/sc1200wdt.c
 SCHEDULER
 M:	Ingo Molnar <mingo@redhat.com>
 M:	Peter Zijlstra <peterz@infradead.org>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
 S:	Maintained
 F:	kernel/sched/
@@ -7823,6 +7834,7 @@ F:	mm/sl?b.c
 SLEEPABLE READ-COPY UPDATE (SRCU)
 M:	Lai Jiangshan <laijs@cn.fujitsu.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
@@ -9531,6 +9543,7 @@ M:	Thomas Gleixner <tglx@linutronix.de>
 M:	Ingo Molnar <mingo@redhat.com>
 M:	"H. Peter Anvin" <hpa@zytor.com>
 M:	x86@kernel.org
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/core
 S:	Maintained
 F:	Documentation/x86/
diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
index 6b964a0..062921e 100644
--- a/arch/x86/include/asm/uv/uv.h
+++ b/arch/x86/include/asm/uv/uv.h
@@ -12,7 +12,6 @@ extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
 extern void uv_nmi_init(void);
-extern void uv_register_nmi_notifier(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
@@ -26,7 +25,6 @@ static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
-static inline void uv_register_nmi_notifier(void) { }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
 		    unsigned long start, unsigned long end, unsigned int cpu)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index ad0dc04..d263b13 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -980,7 +980,6 @@ void __init uv_system_init(void)
 	uv_nmi_setup();
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
-	uv_register_nmi_notifier();
 	proc_mkdir("sgi_uv", NULL);
 
 	/* register Legacy VGA I/O redirection handler */
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 8eeccba..be27da6 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -74,7 +74,6 @@ static atomic_t	uv_in_nmi;
 static atomic_t uv_nmi_cpu = ATOMIC_INIT(-1);
 static atomic_t uv_nmi_cpus_in_nmi = ATOMIC_INIT(-1);
 static atomic_t uv_nmi_slave_continue;
-static atomic_t uv_nmi_kexec_failed;
 static cpumask_var_t uv_nmi_cpu_mask;
 
 /* Values for uv_nmi_slave_continue */
@@ -149,7 +148,8 @@ module_param_named(retry_count, uv_nmi_retry_count, int, 0644);
  *  "dump"	- dump process stack for each cpu
  *  "ips"	- dump IP info for each cpu
  *  "kdump"	- do crash dump
- *  "kdb"	- enter KDB/KGDB (default)
+ *  "kdb"	- enter KDB (default)
+ *  "kgdb"	- enter KGDB
  */
 static char uv_nmi_action[8] = "kdb";
 module_param_string(action, uv_nmi_action, sizeof(uv_nmi_action), 0644);
@@ -504,6 +504,7 @@ static void uv_nmi_touch_watchdogs(void)
 }
 
 #if defined(CONFIG_KEXEC)
+static atomic_t uv_nmi_kexec_failed;
 static void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
 {
 	/* Call crash to dump system state */
@@ -537,18 +538,45 @@ static inline void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
 }
 #endif /* !CONFIG_KEXEC */
 
+#ifdef CONFIG_KGDB
 #ifdef CONFIG_KGDB_KDB
-/* Call KDB from NMI handler */
-static void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
+static inline int uv_nmi_kdb_reason(void)
 {
-	int ret;
+	return KDB_REASON_SYSTEM_NMI;
+}
+#else /* !CONFIG_KGDB_KDB */
+static inline int uv_nmi_kdb_reason(void)
+{
+	/* Insure user is expecting to attach gdb remote */
+	if (uv_nmi_action_is("kgdb"))
+		return 0;
+
+	pr_err("UV: NMI error: KDB is not enabled in this kernel\n");
+	return -1;
+}
+#endif /* CONFIG_KGDB_KDB */
 
+/*
+ * Call KGDB/KDB from NMI handler
+ *
+ * Note that if both KGDB and KDB are configured, then the action of 'kgdb' or
+ * 'kdb' has no affect on which is used.  See the KGDB documention for further
+ * information.
+ */
+static void uv_call_kgdb_kdb(int cpu, struct pt_regs *regs, int master)
+{
 	if (master) {
+		int reason = uv_nmi_kdb_reason();
+		int ret;
+
+		if (reason < 0)
+			return;
+
 		/* call KGDB NMI handler as MASTER */
-		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs,
-					&uv_nmi_slave_continue);
+		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs, reason,
+				&uv_nmi_slave_continue);
 		if (ret) {
-			pr_alert("KDB returned error, is kgdboc set?\n");
+			pr_alert("KGDB returned error, is kgdboc set?\n");
 			atomic_set(&uv_nmi_slave_continue, SLAVE_EXIT);
 		}
 	} else {
@@ -567,12 +595,12 @@ static void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
 	uv_nmi_sync_exit(master);
 }
 
-#else /* !CONFIG_KGDB_KDB */
-static inline void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
+#else /* !CONFIG_KGDB */
+static inline void uv_call_kgdb_kdb(int cpu, struct pt_regs *regs, int master)
 {
-	pr_err("UV: NMI error: KGDB/KDB is not enabled in this kernel\n");
+	pr_err("UV: NMI error: KGDB is not enabled in this kernel\n");
 }
-#endif /* !CONFIG_KGDB_KDB */
+#endif /* !CONFIG_KGDB */
 
 /*
  * UV NMI handler
@@ -606,9 +634,9 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 	if (uv_nmi_action_is("ips") || uv_nmi_action_is("dump"))
 		uv_nmi_dump_state(cpu, regs, master);
 
-	/* Call KDB if enabled */
-	else if (uv_nmi_action_is("kdb"))
-		uv_call_kdb(cpu, regs, master);
+	/* Call KGDB/KDB if enabled */
+	else if (uv_nmi_action_is("kdb") || uv_nmi_action_is("kgdb"))
+		uv_call_kgdb_kdb(cpu, regs, master);
 
 	/* Clear per_cpu "in nmi" flag */
 	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);
@@ -634,7 +662,7 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 /*
  * NMI handler for pulling in CPUs when perf events are grabbing our NMI
  */
-int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
+static int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
 {
 	int ret;
 
@@ -651,7 +679,7 @@ int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
 	return ret;
 }
 
-void uv_register_nmi_notifier(void)
+static void uv_register_nmi_notifier(void)
 {
 	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
 		pr_warn("UV: NMI handler failed to register\n");
@@ -695,6 +723,5 @@ void uv_nmi_setup(void)
 		uv_hub_nmi_per(cpu) = uv_hub_nmi_list[nid];
 	}
 	BUG_ON(!alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL));
+	uv_register_nmi_notifier();
 }
-
-
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index dfb4f2f..6b06d37 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -310,7 +310,8 @@ extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
 		      struct pt_regs *regs);
 extern int kgdb_nmicallback(int cpu, void *regs);
-extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *snd_rdy);
+extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, int err_code,
+			  atomic_t *snd_rdy);
 extern void gdbstub_exit(int status);
 
 extern int			kgdb_single_step;
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 31e0193..3a93f84 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -5,7 +5,7 @@
 extern int	     sysctl_hung_task_check_count;
 extern unsigned int  sysctl_hung_task_panic;
 extern unsigned long sysctl_hung_task_timeout_secs;
-extern unsigned long sysctl_hung_task_warnings;
+extern int sysctl_hung_task_warnings;
 extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
 					 void __user *buffer,
 					 size_t *lenp, loff_t *ppos);
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 7d2f35e..334b398 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -736,7 +736,8 @@ int kgdb_nmicallback(int cpu, void *regs)
 	return 1;
 }
 
-int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
+int kgdb_nmicallin(int cpu, int trapnr, void *regs, int err_code,
+							atomic_t *send_ready)
 {
 #ifdef CONFIG_SMP
 	if (!kgdb_io_ready(0) || !send_ready)
@@ -750,7 +751,7 @@ int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
 		ks->cpu			= cpu;
 		ks->ex_vector		= trapnr;
 		ks->signo		= SIGTRAP;
-		ks->err_code		= KGDB_KDB_REASON_SYSTEM_NMI;
+		ks->err_code		= err_code;
 		ks->linux_regs		= regs;
 		ks->send_ready		= send_ready;
 		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index 572aa4f..127d9bc 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -75,13 +75,11 @@ extern int kdb_stub(struct kgdb_state *ks);
 extern int kdb_parse(const char *cmdstr);
 extern int kdb_common_init_state(struct kgdb_state *ks);
 extern int kdb_common_deinit_state(void);
-#define KGDB_KDB_REASON_SYSTEM_NMI KDB_REASON_SYSTEM_NMI
 #else /* ! CONFIG_KGDB_KDB */
 static inline int kdb_stub(struct kgdb_state *ks)
 {
 	return DBG_PASS_EVENT;
 }
-#define KGDB_KDB_REASON_SYSTEM_NMI 0
 #endif /* CONFIG_KGDB_KDB */
 
 #endif /* _DEBUG_CORE_H_ */
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 9328b80..0b9c169 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -37,7 +37,7 @@ int __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
  */
 unsigned long __read_mostly sysctl_hung_task_timeout_secs = CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
 
-unsigned long __read_mostly sysctl_hung_task_warnings = 10;
+int __read_mostly sysctl_hung_task_warnings = 10;
 
 static int __read_mostly did_panic;
 
@@ -98,7 +98,9 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 
 	if (!sysctl_hung_task_warnings)
 		return;
-	sysctl_hung_task_warnings--;
+
+	if (sysctl_hung_task_warnings > 0)
+		sysctl_hung_task_warnings--;
 
 	/*
 	 * Ok, the task did not get scheduled for more than 2 minutes,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c8da99f..dd5b449 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -122,6 +122,8 @@ extern int blk_iopoll_enabled;
 static int sixty = 60;
 #endif
 
+static int __maybe_unused neg_one = -1;
+
 static int zero;
 static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
@@ -977,9 +979,10 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "hung_task_warnings",
 		.data		= &sysctl_hung_task_warnings,
-		.maxlen		= sizeof(unsigned long),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &neg_one,
 	},
 #endif
 #ifdef CONFIG_COMPAT
