Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3FXTim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:38:42 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54017 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3FXTb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 15/32] metag: delete __cpuinit usage from all metag files
Date: Mon, 24 Jun 2013 15:30:20 -0400
Message-ID: <1372102237-8757-16-git-send-email-paul.gortmaker@windriver.com>
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

This removes all the arch/metag uses of the __cpuinit macros from
all C files.  Currently metag does not have any __CPUINIT used in
assembly files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/metag/kernel/perf/perf_event.c |  6 +++---
 arch/metag/kernel/smp.c             | 16 +++++++---------
 arch/metag/kernel/traps.c           |  2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index 5b18888..1f4d48f 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -813,8 +813,8 @@ static struct metag_pmu _metag_pmu = {
 };
 
 /* PMU CPU hotplug notifier */
-static int __cpuinit metag_pmu_cpu_notify(struct notifier_block *b,
-		unsigned long action, void *hcpu)
+static int metag_pmu_cpu_notify(struct notifier_block *b, unsigned long action,
+				void *hcpu)
 {
 	unsigned int cpu = (unsigned int)hcpu;
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
@@ -828,7 +828,7 @@ static int __cpuinit metag_pmu_cpu_notify(struct notifier_block *b,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata metag_pmu_notifier = {
+static struct notifier_block metag_pmu_notifier = {
 	.notifier_call = metag_pmu_cpu_notify,
 };
 
diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index f443ec9..f202833 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -65,7 +65,7 @@ static DEFINE_SPINLOCK(boot_lock);
 /*
  * "thread" is assumed to be a valid Meta hardware thread ID.
  */
-int __cpuinit boot_secondary(unsigned int thread, struct task_struct *idle)
+int boot_secondary(unsigned int thread, struct task_struct *idle)
 {
 	u32 val;
 
@@ -115,11 +115,9 @@ int __cpuinit boot_secondary(unsigned int thread, struct task_struct *idle)
  * If the cache partition has changed, prints a message to the log describing
  * those changes.
  */
-static __cpuinit void describe_cachepart_change(unsigned int thread,
-						const char *label,
-						unsigned int sz,
-						unsigned int old,
-						unsigned int new)
+static void describe_cachepart_change(unsigned int thread, const char *label,
+				      unsigned int sz, unsigned int old,
+				      unsigned int new)
 {
 	unsigned int lor1, land1, gor1, gand1;
 	unsigned int lor2, land2, gor2, gand2;
@@ -167,7 +165,7 @@ static __cpuinit void describe_cachepart_change(unsigned int thread,
  * Ensures that coherency is enabled and that the threads share the same cache
  * partitions.
  */
-static __cpuinit void setup_smp_cache(unsigned int thread)
+static void setup_smp_cache(unsigned int thread)
 {
 	unsigned int this_thread, lflags;
 	unsigned int dcsz, dcpart_this, dcpart_old, dcpart_new;
@@ -212,7 +210,7 @@ static __cpuinit void setup_smp_cache(unsigned int thread)
 				  icpart_old, icpart_new);
 }
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
+int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned int thread = cpu_2_hwthread_id[cpu];
 	int ret;
@@ -337,7 +335,7 @@ void __cpuexit cpu_die(void)
  * Called by both boot and secondaries to move global data into
  * per-processor storage.
  */
-void __cpuinit smp_store_cpu_info(unsigned int cpuid)
+void smp_store_cpu_info(unsigned int cpuid)
 {
 	struct cpuinfo_metag *cpu_info = &per_cpu(cpu_data, cpuid);
 
diff --git a/arch/metag/kernel/traps.c b/arch/metag/kernel/traps.c
index c00ade0..25f9d1c 100644
--- a/arch/metag/kernel/traps.c
+++ b/arch/metag/kernel/traps.c
@@ -812,7 +812,7 @@ static void set_trigger_mask(unsigned int mask)
 }
 #endif
 
-void __cpuinit per_cpu_trap_init(unsigned long cpu)
+void per_cpu_trap_init(unsigned long cpu)
 {
 	TBIRES int_context;
 	unsigned int thread = cpu_2_hwthread_id[cpu];
-- 
1.8.1.2

