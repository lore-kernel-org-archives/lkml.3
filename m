Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3FXTbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:31:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:47244 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3FXTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, <linux390@de.ibm.com>,
        <linux-s390@vger.kernel.org>
Subject: [PATCH 12/32] s390: delete __cpuinit usage from all s390 files
Date: Mon, 24 Jun 2013 15:30:17 -0400
Message-ID: <1372102237-8757-13-git-send-email-paul.gortmaker@windriver.com>
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

Note that some harmless section mismatch warnings may result, since
notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
are flagged as __cpuinit  -- so if we remove the __cpuinit from
arch specific callers, we will also get section mismatch warnings.
As an intermediate step, we intend to turn the linux/init.h cpuinit
content into no-ops as early as possible, since that will get rid
of these warnings.  In any case, they are temporary and harmless.

This removes all the arch/s390 uses of the __cpuinit macros from
all C files.  Currently s390 does not have any __CPUINIT used in
assembly files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/s390/kernel/cache.c        | 15 +++++++--------
 arch/s390/kernel/perf_cpum_cf.c |  4 ++--
 arch/s390/kernel/processor.c    |  2 +-
 arch/s390/kernel/smp.c          | 17 ++++++++---------
 arch/s390/kernel/sysinfo.c      |  2 +-
 arch/s390/kernel/vtime.c        |  6 +++---
 arch/s390/mm/fault.c            |  4 ++--
 7 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/arch/s390/kernel/cache.c b/arch/s390/kernel/cache.c
index 64b2465..dd62071 100644
--- a/arch/s390/kernel/cache.c
+++ b/arch/s390/kernel/cache.c
@@ -173,7 +173,7 @@ error:
 	}
 }
 
-static struct cache_dir *__cpuinit cache_create_cache_dir(int cpu)
+static struct cache_dir *cache_create_cache_dir(int cpu)
 {
 	struct cache_dir *cache_dir;
 	struct kobject *kobj = NULL;
@@ -289,9 +289,8 @@ static struct kobj_type cache_index_type = {
 	.default_attrs = cache_index_default_attrs,
 };
 
-static int __cpuinit cache_create_index_dir(struct cache_dir *cache_dir,
-					    struct cache *cache, int index,
-					    int cpu)
+static int cache_create_index_dir(struct cache_dir *cache_dir,
+				  struct cache *cache, int index, int cpu)
 {
 	struct cache_index_dir *index_dir;
 	int rc;
@@ -313,7 +312,7 @@ out:
 	return rc;
 }
 
-static int __cpuinit cache_add_cpu(int cpu)
+static int cache_add_cpu(int cpu)
 {
 	struct cache_dir *cache_dir;
 	struct cache *cache;
@@ -335,7 +334,7 @@ static int __cpuinit cache_add_cpu(int cpu)
 	return 0;
 }
 
-static void __cpuinit cache_remove_cpu(int cpu)
+static void cache_remove_cpu(int cpu)
 {
 	struct cache_index_dir *index, *next;
 	struct cache_dir *cache_dir;
@@ -354,8 +353,8 @@ static void __cpuinit cache_remove_cpu(int cpu)
 	cache_dir_cpu[cpu] = NULL;
 }
 
-static int __cpuinit cache_hotplug(struct notifier_block *nfb,
-				   unsigned long action, void *hcpu)
+static int cache_hotplug(struct notifier_block *nfb, unsigned long action,
+			 void *hcpu)
 {
 	int cpu = (long)hcpu;
 	int rc = 0;
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 390d9ae..fb99c20 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -639,8 +639,8 @@ static struct pmu cpumf_pmu = {
 	.cancel_txn   = cpumf_pmu_cancel_txn,
 };
 
-static int __cpuinit cpumf_pmu_notifier(struct notifier_block *self,
-					unsigned long action, void *hcpu)
+static int cpumf_pmu_notifier(struct notifier_block *self, unsigned long action,
+			      void *hcpu)
 {
 	unsigned int cpu = (long) hcpu;
 	int flags;
diff --git a/arch/s390/kernel/processor.c b/arch/s390/kernel/processor.c
index 753c41d..2461202 100644
--- a/arch/s390/kernel/processor.c
+++ b/arch/s390/kernel/processor.c
@@ -21,7 +21,7 @@ static DEFINE_PER_CPU(struct cpuid, cpu_id);
 /*
  * cpu_init - initializes state that is per-CPU.
  */
-void __cpuinit cpu_init(void)
+void cpu_init(void)
 {
 	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
 	struct cpuid *id = &__get_cpu_var(cpu_id);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 15a016c..d386c4e 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -165,7 +165,7 @@ static void pcpu_ec_call(struct pcpu *pcpu, int ec_bit)
 	pcpu_sigp_retry(pcpu, order, 0);
 }
 
-static int __cpuinit pcpu_alloc_lowcore(struct pcpu *pcpu, int cpu)
+static int pcpu_alloc_lowcore(struct pcpu *pcpu, int cpu)
 {
 	struct _lowcore *lc;
 
@@ -616,10 +616,9 @@ static struct sclp_cpu_info *smp_get_cpu_info(void)
 	return info;
 }
 
-static int __cpuinit smp_add_present_cpu(int cpu);
+static int smp_add_present_cpu(int cpu);
 
-static int __cpuinit __smp_rescan_cpus(struct sclp_cpu_info *info,
-				       int sysfs_add)
+static int __smp_rescan_cpus(struct sclp_cpu_info *info, int sysfs_add)
 {
 	struct pcpu *pcpu;
 	cpumask_t avail;
@@ -685,7 +684,7 @@ static void __init smp_detect_cpus(void)
 /*
  *	Activate a secondary processor.
  */
-static void __cpuinit smp_start_secondary(void *cpuvoid)
+static void smp_start_secondary(void *cpuvoid)
 {
 	S390_lowcore.last_update_clock = get_tod_clock();
 	S390_lowcore.restart_stack = (unsigned long) restart_stack;
@@ -708,7 +707,7 @@ static void __cpuinit smp_start_secondary(void *cpuvoid)
 }
 
 /* Upping and downing of CPUs */
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct pcpu *pcpu;
 	int rc;
@@ -964,8 +963,8 @@ static struct attribute_group cpu_online_attr_group = {
 	.attrs = cpu_online_attrs,
 };
 
-static int __cpuinit smp_cpu_notify(struct notifier_block *self,
-				    unsigned long action, void *hcpu)
+static int smp_cpu_notify(struct notifier_block *self, unsigned long action,
+			  void *hcpu)
 {
 	unsigned int cpu = (unsigned int)(long)hcpu;
 	struct cpu *c = &pcpu_devices[cpu].cpu;
@@ -983,7 +982,7 @@ static int __cpuinit smp_cpu_notify(struct notifier_block *self,
 	return notifier_from_errno(err);
 }
 
-static int __cpuinit smp_add_present_cpu(int cpu)
+static int smp_add_present_cpu(int cpu)
 {
 	struct cpu *c = &pcpu_devices[cpu].cpu;
 	struct device *s = &c->dev;
diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index 62f89d9..811f542 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -418,7 +418,7 @@ void s390_adjust_jiffies(void)
 /*
  * calibrate the delay loop
  */
-void __cpuinit calibrate_delay(void)
+void calibrate_delay(void)
 {
 	s390_adjust_jiffies();
 	/* Print the good old Bogomips line .. */
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 3fb0935..9b9c1b7 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -371,14 +371,14 @@ EXPORT_SYMBOL(del_virt_timer);
 /*
  * Start the virtual CPU timer on the current CPU.
  */
-void __cpuinit init_cpu_vtimer(void)
+void init_cpu_vtimer(void)
 {
 	/* set initial cpu timer */
 	set_vtimer(VTIMER_MAX_SLICE);
 }
 
-static int __cpuinit s390_nohz_notify(struct notifier_block *self,
-				      unsigned long action, void *hcpu)
+static int s390_nohz_notify(struct notifier_block *self, unsigned long action,
+			    void *hcpu)
 {
 	struct s390_idle_data *idle;
 	long cpu = (long) hcpu;
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 047c3e4..f00aefb 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -639,8 +639,8 @@ out:
 	put_task_struct(tsk);
 }
 
-static int __cpuinit pfault_cpu_notify(struct notifier_block *self,
-				       unsigned long action, void *hcpu)
+static int pfault_cpu_notify(struct notifier_block *self, unsigned long action,
+			     void *hcpu)
 {
 	struct thread_struct *thread, *next;
 	struct task_struct *tsk;
-- 
1.8.1.2

