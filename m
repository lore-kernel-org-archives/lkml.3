Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbaH0AM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 20:12:26 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:45216 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756228AbaH0AMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 20:12:23 -0400
Date: Tue, 26 Aug 2014 19:12:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
In-Reply-To: <alpine.DEB.2.11.1408261803500.15698@gentwo.org>
Message-ID: <alpine.DEB.2.11.1408261911290.22692@gentwo.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org> <20140821222212.GA7996@mtj.dyndns.org> <alpine.DEB.2.11.1408212001100.19762@gentwo.org> <20140822164051.GB15713@mtj.dyndns.org> <alpine.DEB.2.11.1408221241340.23099@gentwo.org>
 <20140823171416.GG13540@mtj.dyndns.org> <alpine.DEB.2.11.1408231500430.31459@gentwo.org> <alpine.DEB.2.11.1408261631350.8819@gentwo.org> <20140826213735.GS31659@mtj.dyndns.org> <alpine.DEB.2.11.1408261803500.15698@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


New patch:

From: Christoph Lameter <cl@linux.com>
Subject: __get_cpu_var/cpumask_var_t: Resolve ambiguities v2

__get_cpu_var can paper over differences in the definitions
of cpumask_var_t and either use the address of the cpumask
variable directly or perform a fetch of the address of the
struct cpumask allocated elsewhere. This is important
particularly when using per cpu cpumask_var_t declarations
because in one case we have an offset into a per cpu area
to handle and in the other case we need to fetch a pointer
from the offset.

This patch introduces a new macro

this_cpu_cpumask_var_t_ptr()

that is defined where cpumask_var_t is defined and performs
the proper actions. All use cases where __get_cpu_var
is used with cpumask_var_t are converted to the use
of this_cpu_cpumask_var_t_ptr().

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 arch/x86/include/asm/perf_event_p4.h |  2 +-
 arch/x86/oprofile/op_model_p4.c      |  2 +-
 include/linux/cpumask.h              | 11 +++++++++++
 kernel/sched/deadline.c              |  2 +-
 kernel/sched/fair.c                  |  2 +-
 kernel/sched/rt.c                    |  2 +-
 6 files changed, 16 insertions(+), 5 deletions(-)

Index: linux/arch/x86/include/asm/perf_event_p4.h
===================================================================
--- linux.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux/arch/x86/include/asm/perf_event_p4.h
@@ -189,7 +189,7 @@ static inline int p4_ht_thread(int cpu)
 {
 #ifdef CONFIG_SMP
 	if (smp_num_siblings == 2)
-		return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
+		return cpu != cpumask_first(this_cpu_cpumask_var_ptr(cpu_sibling_map));
 #endif
 	return 0;
 }
Index: linux/arch/x86/oprofile/op_model_p4.c
===================================================================
--- linux.orig/arch/x86/oprofile/op_model_p4.c
+++ linux/arch/x86/oprofile/op_model_p4.c
@@ -372,7 +372,7 @@ static unsigned int get_stagger(void)
 {
 #ifdef CONFIG_SMP
 	int cpu = smp_processor_id();
-	return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
+	return cpu != cpumask_first(this_cpu_cpumask_var_ptr(cpu_sibling_map));
 #endif
 	return 0;
 }
Index: linux/include/linux/cpumask.h
===================================================================
--- linux.orig/include/linux/cpumask.h
+++ linux/include/linux/cpumask.h
@@ -666,10 +666,19 @@ static inline size_t cpumask_size(void)
  *
  * This code makes NR_CPUS length memcopy and brings to a memory corruption.
  * cpumask_copy() provide safe copy functionality.
+ *
+ * Note that there is another evil here: If you define a cpumask_var_t
+ * as a percpu variable then the way to obtain the address of the cpumask
+ * structure differently influences what this_cpu_* operation needs to be
+ * used. Please use this_cpu_cpumask_var_t in those cases. The direct use
+ * of this_cpu_ptr() or this_cpu_read() will lead to failures when the
+ * other type of cpumask_var_t implementation is configured.
  */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 typedef struct cpumask *cpumask_var_t;

+#define this_cpu_cpumask_var_ptr(x) this_cpu_read(x)
+
 bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
 bool zalloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
@@ -681,6 +690,8 @@ void free_bootmem_cpumask_var(cpumask_va
 #else
 typedef struct cpumask cpumask_var_t[1];

+#define this_cpu_cpumask_var_ptr(x) this_cpu_ptr(x)
+
 static inline bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
 {
 	return true;
Index: linux/kernel/sched/deadline.c
===================================================================
--- linux.orig/kernel/sched/deadline.c
+++ linux/kernel/sched/deadline.c
@@ -1158,7 +1158,7 @@ static DEFINE_PER_CPU(cpumask_var_t, loc
 static int find_later_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *later_mask = __get_cpu_var(local_cpu_mask_dl);
+	struct cpumask *later_mask = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
 	int this_cpu = smp_processor_id();
 	int best_cpu, cpu = task_cpu(task);

Index: linux/kernel/sched/fair.c
===================================================================
--- linux.orig/kernel/sched/fair.c
+++ linux/kernel/sched/fair.c
@@ -6539,7 +6539,7 @@ static int load_balance(int this_cpu, st
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
+	struct cpumask *cpus = this_cpu_cpumask_var_ptr(load_balance_mask);

 	struct lb_env env = {
 		.sd		= sd,
Index: linux/kernel/sched/rt.c
===================================================================
--- linux.orig/kernel/sched/rt.c
+++ linux/kernel/sched/rt.c
@@ -1526,7 +1526,7 @@ static DEFINE_PER_CPU(cpumask_var_t, loc
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
+	struct cpumask *lowest_mask = this_cpu_cpumask_var_ptr(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);

Index: linux/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux/arch/x86/kernel/apic/x2apic_cluster.c
@@ -42,8 +42,7 @@ __x2apic_send_IPI_mask(const struct cpum
 	 * We are to modify mask, so we need an own copy
 	 * and be sure it's manipulated with irq off.
 	 */
-	ipi_mask_ptr = __raw_get_cpu_var(ipi_mask);
-	cpumask_copy(ipi_mask_ptr, mask);
+	ipi_mask_ptr = this_cpu_cpumask_var_ptr(ipi_mask);

 	/*
 	 * The idea is to send one IPI per cluster.
