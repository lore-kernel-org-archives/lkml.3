Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3FXTgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:36:17 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54054 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3FXTbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 30/32] kernel: delete __cpuinit usage from all core kernel files
Date: Mon, 24 Jun 2013 15:30:35 -0400
Message-ID: <1372102237-8757-31-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

This removes all the uses of the __cpuinit macros from C files in
the core kernel directories (kernel, init, lib, mm, and include)
that don't really have a specific maintainer.

[1] https://lkml.org/lkml/2013/5/20/589

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 Documentation/cpu-hotplug.txt |  6 +++---
 include/linux/cpu.h           |  2 +-
 include/linux/perf_event.h    |  2 +-
 init/calibrate.c              | 13 ++++++++-----
 kernel/cpu.c                  |  6 +++---
 kernel/events/core.c          |  4 ++--
 kernel/fork.c                 |  2 +-
 kernel/hrtimer.c              |  6 +++---
 kernel/printk.c               |  2 +-
 kernel/profile.c              |  2 +-
 kernel/relay.c                |  2 +-
 kernel/sched/core.c           | 12 ++++++------
 kernel/sched/fair.c           |  2 +-
 kernel/smp.c                  |  2 +-
 kernel/smpboot.c              |  2 +-
 kernel/softirq.c              |  8 ++++----
 kernel/time/tick-sched.c      |  2 +-
 kernel/timer.c                | 10 +++++-----
 kernel/workqueue.c            |  4 ++--
 lib/Kconfig.debug             |  2 +-
 lib/earlycpio.c               |  2 +-
 lib/percpu_counter.c          |  2 +-
 mm/memcontrol.c               |  2 +-
 mm/page-writeback.c           |  4 ++--
 mm/slab.c                     | 10 +++++-----
 mm/slub.c                     |  4 ++--
 mm/vmstat.c                   |  6 +++---
 27 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index edd4b4d..786dc82 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -267,8 +267,8 @@ Q: If i have some kernel code that needs to be aware of CPU arrival and
 A: This is what you would need in your kernel code to receive notifications.
 
 	#include <linux/cpu.h>
-	static int __cpuinit foobar_cpu_callback(struct notifier_block *nfb,
-					    unsigned long action, void *hcpu)
+	static int foobar_cpu_callback(struct notifier_block *nfb,
+				       unsigned long action, void *hcpu)
 	{
 		unsigned int cpu = (unsigned long)hcpu;
 
@@ -285,7 +285,7 @@ A: This is what you would need in your kernel code to receive notifications.
 		return NOTIFY_OK;
 	}
 
-	static struct notifier_block __cpuinitdata foobar_cpu_notifer =
+	static struct notifier_block foobar_cpu_notifer =
 	{
 	   .notifier_call = foobar_cpu_callback,
 	};
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 944f283..ab0eade 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -114,7 +114,7 @@ enum {
 /* Need to know about CPUs going up/down? */
 #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
 #define cpu_notifier(fn, pri) {					\
-	static struct notifier_block fn##_nb __cpuinitdata =	\
+	static struct notifier_block fn##_nb =			\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4ccf846..e36ece2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -819,7 +819,7 @@ static inline void perf_restore_debug_store(void)			{ }
  */
 #define perf_cpu_notifier(fn)						\
 do {									\
-	static struct notifier_block fn##_nb __cpuinitdata =		\
+	static struct notifier_block fn##_nb =				\
 		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
 	unsigned long cpu = smp_processor_id();				\
 	unsigned long flags;						\
diff --git a/init/calibrate.c b/init/calibrate.c
index fda0a7b..520702d 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -31,7 +31,7 @@ __setup("lpj=", lpj_setup);
 #define DELAY_CALIBRATION_TICKS			((HZ < 100) ? 1 : (HZ/100))
 #define MAX_DIRECT_CALIBRATION_RETRIES		5
 
-static unsigned long __cpuinit calibrate_delay_direct(void)
+static unsigned long calibrate_delay_direct(void)
 {
 	unsigned long pre_start, start, post_start;
 	unsigned long pre_end, end, post_end;
@@ -166,7 +166,10 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 	return 0;
 }
 #else
-static unsigned long __cpuinit calibrate_delay_direct(void) {return 0;}
+static unsigned long calibrate_delay_direct(void)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -180,7 +183,7 @@ static unsigned long __cpuinit calibrate_delay_direct(void) {return 0;}
  */
 #define LPS_PREC 8
 
-static unsigned long __cpuinit calibrate_delay_converge(void)
+static unsigned long calibrate_delay_converge(void)
 {
 	/* First stage - slowly accelerate to find initial bounds */
 	unsigned long lpj, lpj_base, ticks, loopadd, loopadd_base, chop_limit;
@@ -254,12 +257,12 @@ static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
  * Architectures should override this function if a faster calibration
  * method is available.
  */
-unsigned long __attribute__((weak)) __cpuinit calibrate_delay_is_known(void)
+unsigned long __attribute__((weak)) calibrate_delay_is_known(void)
 {
 	return 0;
 }
 
-void __cpuinit calibrate_delay(void)
+void calibrate_delay(void)
 {
 	unsigned long lpj;
 	static bool printed;
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 198a388..b2b227b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -366,7 +366,7 @@ EXPORT_SYMBOL(cpu_down);
 #endif /*CONFIG_HOTPLUG_CPU*/
 
 /* Requires cpu_add_remove_lock to be held */
-static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
+static int _cpu_up(unsigned int cpu, int tasks_frozen)
 {
 	int ret, nr_calls = 0;
 	void *hcpu = (void *)(long)cpu;
@@ -419,7 +419,7 @@ out:
 	return ret;
 }
 
-int __cpuinit cpu_up(unsigned int cpu)
+int cpu_up(unsigned int cpu)
 {
 	int err = 0;
 
@@ -618,7 +618,7 @@ core_initcall(cpu_hotplug_pm_sync_init);
  * It must be called by the arch code on the new cpu, before the new cpu
  * enables interrupts and before the "boot" cpu returns from __cpu_up().
  */
-void __cpuinit notify_cpu_starting(unsigned int cpu)
+void notify_cpu_starting(unsigned int cpu)
 {
 	unsigned long val = CPU_STARTING;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9c89207..3e0cb71 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7524,7 +7524,7 @@ static void __init perf_event_init_all_cpus(void)
 	}
 }
 
-static void __cpuinit perf_event_init_cpu(int cpu)
+static void perf_event_init_cpu(int cpu)
 {
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
@@ -7613,7 +7613,7 @@ static struct notifier_block perf_reboot_notifier = {
 	.priority = INT_MIN,
 };
 
-static int __cpuinit
+static int
 perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
diff --git a/kernel/fork.c b/kernel/fork.c
index 66635c8..403d2bb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1546,7 +1546,7 @@ static inline void init_idle_pids(struct pid_link *links)
 	}
 }
 
-struct task_struct * __cpuinit fork_idle(int cpu)
+struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
 	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ef0dd04..95207d8 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1661,7 +1661,7 @@ SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 /*
  * Functions related to boot-time initialization:
  */
-static void __cpuinit init_hrtimers_cpu(int cpu)
+static void init_hrtimers_cpu(int cpu)
 {
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
@@ -1742,7 +1742,7 @@ static void migrate_hrtimers(int scpu)
 
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
+static int hrtimer_cpu_notify(struct notifier_block *self,
 					unsigned long action, void *hcpu)
 {
 	int scpu = (long)hcpu;
@@ -1775,7 +1775,7 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata hrtimers_nb = {
+static struct notifier_block hrtimers_nb = {
 	.notifier_call = hrtimer_cpu_notify,
 };
 
diff --git a/kernel/printk.c b/kernel/printk.c
index b8c348a..a9cb897 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1922,7 +1922,7 @@ void resume_console(void)
  * called when a new CPU comes online (or fails to come up), and ensures
  * that any such output gets printed.
  */
-static int __cpuinit console_cpu_notify(struct notifier_block *self,
+static int console_cpu_notify(struct notifier_block *self,
 	unsigned long action, void *hcpu)
 {
 	switch (action) {
diff --git a/kernel/profile.c b/kernel/profile.c
index 0bf4007..6631e1e 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -331,7 +331,7 @@ out:
 	put_cpu();
 }
 
-static int __cpuinit profile_cpu_callback(struct notifier_block *info,
+static int profile_cpu_callback(struct notifier_block *info,
 					unsigned long action, void *__cpu)
 {
 	int node, cpu = (unsigned long)__cpu;
diff --git a/kernel/relay.c b/kernel/relay.c
index e03440b..b915513 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -521,7 +521,7 @@ static void setup_callbacks(struct rchan *chan,
  *
  * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
  */
-static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
+static int relay_hotcpu_callback(struct notifier_block *nb,
 				unsigned long action,
 				void *hcpu)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 195658b..4f5679b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4138,7 +4138,7 @@ void show_state_filter(unsigned long state_filter)
 		debug_show_all_locks();
 }
 
-void __cpuinit init_idle_bootup_task(struct task_struct *idle)
+void init_idle_bootup_task(struct task_struct *idle)
 {
 	idle->sched_class = &idle_sched_class;
 }
@@ -4151,7 +4151,7 @@ void __cpuinit init_idle_bootup_task(struct task_struct *idle)
  * NOTE: this function does not set the idle thread's NEED_RESCHED
  * flag, to make booting more robust.
  */
-void __cpuinit init_idle(struct task_struct *idle, int cpu)
+void init_idle(struct task_struct *idle, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
@@ -4635,7 +4635,7 @@ static void set_rq_offline(struct rq *rq)
  * migration_call - callback that gets triggered when a CPU is added.
  * Here we can start up the necessary migration thread for the new CPU.
  */
-static int __cpuinit
+static int
 migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int cpu = (long)hcpu;
@@ -4689,12 +4689,12 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
  * happens before everything else.  This has to be lower priority than
  * the notifier in the perf_event subsystem, though.
  */
-static struct notifier_block __cpuinitdata migration_notifier = {
+static struct notifier_block migration_notifier = {
 	.notifier_call = migration_call,
 	.priority = CPU_PRI_MIGRATION,
 };
 
-static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
+static int sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
@@ -4707,7 +4707,7 @@ static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
 	}
 }
 
-static int __cpuinit sched_cpu_inactive(struct notifier_block *nfb,
+static int sched_cpu_inactive(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c0ac2c3..714915a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5484,7 +5484,7 @@ void nohz_balance_enter_idle(int cpu)
 	set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 }
 
-static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
+static int sched_ilb_notifier(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
diff --git a/kernel/smp.c b/kernel/smp.c
index 97084cf..02a885d 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -74,7 +74,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
+static struct notifier_block hotplug_cfd_notifier = {
 	.notifier_call		= hotplug_cfd,
 };
 
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 02fc5c9..eb89e18 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -24,7 +24,7 @@
  */
 static DEFINE_PER_CPU(struct task_struct *, idle_threads);
 
-struct task_struct * __cpuinit idle_thread_get(unsigned int cpu)
+struct task_struct *idle_thread_get(unsigned int cpu)
 {
 	struct task_struct *tsk = per_cpu(idle_threads, cpu);
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index ca25e6e..be3d351 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -699,7 +699,7 @@ void send_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
 }
 EXPORT_SYMBOL(send_remote_softirq);
 
-static int __cpuinit remote_softirq_cpu_notify(struct notifier_block *self,
+static int remote_softirq_cpu_notify(struct notifier_block *self,
 					       unsigned long action, void *hcpu)
 {
 	/*
@@ -728,7 +728,7 @@ static int __cpuinit remote_softirq_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata remote_softirq_cpu_notifier = {
+static struct notifier_block remote_softirq_cpu_notifier = {
 	.notifier_call	= remote_softirq_cpu_notify,
 };
 
@@ -830,7 +830,7 @@ static void takeover_tasklets(unsigned int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int __cpuinit cpu_callback(struct notifier_block *nfb,
+static int cpu_callback(struct notifier_block *nfb,
 				  unsigned long action,
 				  void *hcpu)
 {
@@ -845,7 +845,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpu_nfb = {
+static struct notifier_block cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0cf1c14..4936910 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -293,7 +293,7 @@ static int __init tick_nohz_full_setup(char *str)
 }
 __setup("nohz_full=", tick_nohz_full_setup);
 
-static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
+static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 						 unsigned long action,
 						 void *hcpu)
 {
diff --git a/kernel/timer.c b/kernel/timer.c
index aa8b964..dd65f41 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1501,11 +1501,11 @@ signed long __sched schedule_timeout_uninterruptible(signed long timeout)
 }
 EXPORT_SYMBOL(schedule_timeout_uninterruptible);
 
-static int __cpuinit init_timers_cpu(int cpu)
+static int init_timers_cpu(int cpu)
 {
 	int j;
 	struct tvec_base *base;
-	static char __cpuinitdata tvec_base_done[NR_CPUS];
+	static char tvec_base_done[NR_CPUS];
 
 	if (!tvec_base_done[cpu]) {
 		static char boot_done;
@@ -1573,7 +1573,7 @@ static void migrate_timer_list(struct tvec_base *new_base, struct list_head *hea
 	}
 }
 
-static void __cpuinit migrate_timers(int cpu)
+static void migrate_timers(int cpu)
 {
 	struct tvec_base *old_base;
 	struct tvec_base *new_base;
@@ -1606,7 +1606,7 @@ static void __cpuinit migrate_timers(int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int __cpuinit timer_cpu_notify(struct notifier_block *self,
+static int timer_cpu_notify(struct notifier_block *self,
 				unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -1631,7 +1631,7 @@ static int __cpuinit timer_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata timers_nb = {
+static struct notifier_block timers_nb = {
 	.notifier_call	= timer_cpu_notify,
 };
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f02c4a4..0b72e81 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4644,7 +4644,7 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
  * Workqueues should be brought up before normal priority CPU notifiers.
  * This will be registered high priority CPU notifier.
  */
-static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
+static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 					       unsigned long action,
 					       void *hcpu)
 {
@@ -4697,7 +4697,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
  * Workqueues should be brought down after normal priority CPU notifiers.
  * This will be registered as low priority CPU notifier.
  */
-static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
+static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 						 unsigned long action,
 						 void *hcpu)
 {
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 74fdc5c..3a1e279 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -134,7 +134,7 @@ config DEBUG_SECTION_MISMATCH
 	  any use of code/data previously in these sections would
 	  most likely result in an oops.
 	  In the code, functions and variables are annotated with
-	  __init, __cpuinit, etc. (see the full list in include/linux/init.h),
+	  __init,, etc. (see the full list in include/linux/init.h),
 	  which results in the code/data being placed in specific sections.
 	  The section mismatch analysis is always performed after a full
 	  kernel build, and enabling this option causes the following
diff --git a/lib/earlycpio.c b/lib/earlycpio.c
index 8078ef4..7aa7ce2 100644
--- a/lib/earlycpio.c
+++ b/lib/earlycpio.c
@@ -63,7 +63,7 @@ enum cpio_fields {
  *          the match returned an empty filename string.
  */
 
-struct cpio_data __cpuinit find_cpio_data(const char *path, void *data,
+struct cpio_data find_cpio_data(const char *path, void *data,
 					  size_t len,  long *offset)
 {
 	const size_t cpio_header_len = 8*C_NFIELDS - 2;
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index ba6085d..867f2da 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -158,7 +158,7 @@ static void compute_batch_value(void)
 	percpu_counter_batch = max(32, nr*2);
 }
 
-static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
+static int percpu_counter_hotcpu_callback(struct notifier_block *nb,
 					unsigned long action, void *hcpu)
 {
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 64f7265..57dff89 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2540,7 +2540,7 @@ static void mem_cgroup_drain_pcp_counter(struct mem_cgroup *memcg, int cpu)
 	spin_unlock(&memcg->pcp_counter_lock);
 }
 
-static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
+static int memcg_cpu_hotplug_callback(struct notifier_block *nb,
 					unsigned long action,
 					void *hcpu)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 4514ad7..3f0c895 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1619,7 +1619,7 @@ void writeback_set_ratelimit(void)
 		ratelimit_pages = 16;
 }
 
-static int __cpuinit
+static int
 ratelimit_handler(struct notifier_block *self, unsigned long action,
 		  void *hcpu)
 {
@@ -1634,7 +1634,7 @@ ratelimit_handler(struct notifier_block *self, unsigned long action,
 	}
 }
 
-static struct notifier_block __cpuinitdata ratelimit_nb = {
+static struct notifier_block ratelimit_nb = {
 	.notifier_call	= ratelimit_handler,
 	.next		= NULL,
 };
diff --git a/mm/slab.c b/mm/slab.c
index be12f68..17298c1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -787,7 +787,7 @@ static void next_reap_node(void)
  * the CPUs getting into lockstep and contending for the global cache chain
  * lock.
  */
-static void __cpuinit start_cpu_timer(int cpu)
+static void start_cpu_timer(int cpu)
 {
 	struct delayed_work *reap_work = &per_cpu(slab_reap_work, cpu);
 
@@ -1180,7 +1180,7 @@ static int init_cache_node_node(int node)
 	return 0;
 }
 
-static void __cpuinit cpuup_canceled(long cpu)
+static void cpuup_canceled(long cpu)
 {
 	struct kmem_cache *cachep;
 	struct kmem_cache_node *n = NULL;
@@ -1245,7 +1245,7 @@ free_array_cache:
 	}
 }
 
-static int __cpuinit cpuup_prepare(long cpu)
+static int cpuup_prepare(long cpu)
 {
 	struct kmem_cache *cachep;
 	struct kmem_cache_node *n = NULL;
@@ -1328,7 +1328,7 @@ bad:
 	return -ENOMEM;
 }
 
-static int __cpuinit cpuup_callback(struct notifier_block *nfb,
+static int cpuup_callback(struct notifier_block *nfb,
 				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -1384,7 +1384,7 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
 	return notifier_from_errno(err);
 }
 
-static struct notifier_block __cpuinitdata cpucache_notifier = {
+static struct notifier_block cpucache_notifier = {
 	&cpuup_callback, NULL, 0
 };
 
diff --git a/mm/slub.c b/mm/slub.c
index 57707f0..4649ff0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3755,7 +3755,7 @@ int __kmem_cache_create(struct kmem_cache *s, unsigned long flags)
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
  */
-static int __cpuinit slab_cpuup_callback(struct notifier_block *nfb,
+static int slab_cpuup_callback(struct notifier_block *nfb,
 		unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -3781,7 +3781,7 @@ static int __cpuinit slab_cpuup_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata slab_notifier = {
+static struct notifier_block slab_notifier = {
 	.notifier_call = slab_cpuup_callback
 };
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 7a35116..58e5b3c 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1189,7 +1189,7 @@ static void vmstat_update(struct work_struct *w)
 		round_jiffies_relative(sysctl_stat_interval));
 }
 
-static void __cpuinit start_cpu_timer(int cpu)
+static void start_cpu_timer(int cpu)
 {
 	struct delayed_work *work = &per_cpu(vmstat_work, cpu);
 
@@ -1201,7 +1201,7 @@ static void __cpuinit start_cpu_timer(int cpu)
  * Use the cpu notifier to insure that the thresholds are recalculated
  * when necessary.
  */
-static int __cpuinit vmstat_cpuup_callback(struct notifier_block *nfb,
+static int vmstat_cpuup_callback(struct notifier_block *nfb,
 		unsigned long action,
 		void *hcpu)
 {
@@ -1233,7 +1233,7 @@ static int __cpuinit vmstat_cpuup_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata vmstat_notifier =
+static struct notifier_block vmstat_notifier =
 	{ &vmstat_cpuup_callback, NULL, 0 };
 #endif
 
-- 
1.8.1.2

