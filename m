Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbaHGPFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:05:50 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:54305
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932327AbaHGPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:05:48 -0400
Date: Thu, 7 Aug 2014 10:05:45 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: percpu: Define this_cpu_cpumask_var_t_ptr
Message-ID: <alpine.DEB.2.11.1408070959250.28468@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I finally found the source of the nasty failures of the
__get_cpu_var patchset:



Subject: __get_cpu_var/cpumask_var_t: Resolve ambiguities

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
 include/linux/kernel_stat.h   |  4 ++--
 kernel/events/callchain.c     |  4 ++--
 kernel/events/core.c          | 24 ++++++++++++------------
 kernel/sched/deadline.c       |  2 +-
 kernel/sched/fair.c           |  2 +-
 kernel/sched/rt.c             |  2 +-
 kernel/sched/sched.h          |  4 ++--
 kernel/taskstats.c            |  2 +-
 kernel/time/tick-sched.c      |  4 ++--
 kernel/user-return-notifier.c |  4 ++--
 10 files changed, 26 insertions(+), 26 deletions(-)

Index: linux/include/linux/cpumask.h
===================================================================
--- linux.orig/include/linux/cpumask.h	2014-08-07 09:36:05.954916998 -0500
+++ linux/include/linux/cpumask.h	2014-08-07 09:55:38.732748680 -0500
@@ -666,10 +666,19 @@
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

+#define this_cpu_cpumask_var_t_ptr(x) this_cpu_read(x)
+
 bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
 bool zalloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
@@ -681,6 +690,8 @@
 #else
 typedef struct cpumask cpumask_var_t[1];

+#define this_cpu_cpumask_var_t_ptr(x) this_cpu_ptr(&x)
+
 static inline bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
 {
 	return true;
Index: linux/kernel/sched/deadline.c
===================================================================
--- linux.orig/kernel/sched/deadline.c	2014-08-07 09:36:05.954916998 -0500
+++ linux/kernel/sched/deadline.c	2014-08-07 09:36:05.902917978 -0500
@@ -1158,7 +1158,7 @@
 static int find_later_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *later_mask = __get_cpu_var(local_cpu_mask_dl);
+	struct cpumask *later_mask = this_cpu_cpumask_var_t_ptr(local_cpu_mask_dl);
 	int this_cpu = smp_processor_id();
 	int best_cpu, cpu = task_cpu(task);

Index: linux/kernel/sched/fair.c
===================================================================
--- linux.orig/kernel/sched/fair.c	2014-08-07 09:36:05.954916998 -0500
+++ linux/kernel/sched/fair.c	2014-08-07 09:36:05.906917903 -0500
@@ -6490,7 +6490,7 @@
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
+	struct cpumask *cpus = this_cpu_cpumask_var_t_ptr(load_balance_mask);

 	struct lb_env env = {
 		.sd		= sd,
Index: linux/kernel/sched/rt.c
===================================================================
--- linux.orig/kernel/sched/rt.c	2014-08-07 09:36:05.954916998 -0500
+++ linux/kernel/sched/rt.c	2014-08-07 09:36:05.906917903 -0500
@@ -1522,7 +1522,7 @@
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
+	struct cpumask *lowest_mask = this_cpu_cpumask_var_t_ptr(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);

Index: linux/arch/x86/include/asm/perf_event_p4.h
===================================================================
--- linux.orig/arch/x86/include/asm/perf_event_p4.h	2014-08-07 09:36:05.954916998 -0500
+++ linux/arch/x86/include/asm/perf_event_p4.h	2014-08-07 09:36:05.910917828 -0500
@@ -189,7 +189,7 @@
 {
 #ifdef CONFIG_SMP
 	if (smp_num_siblings == 2)
-		return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
+		return cpu != cpumask_first(this_cpu_cpumask_var_t_ptr(cpu_sibling_map));
 #endif
 	return 0;
 }
Index: linux/arch/x86/oprofile/op_model_p4.c
===================================================================
--- linux.orig/arch/x86/oprofile/op_model_p4.c	2014-08-07 09:36:05.954916998 -0500
+++ linux/arch/x86/oprofile/op_model_p4.c	2014-08-07 09:36:05.910917828 -0500
@@ -372,7 +372,7 @@
 {
 #ifdef CONFIG_SMP
 	int cpu = smp_processor_id();
-	return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
+	return cpu != cpumask_first(this_cpu_cpumask_var_t_ptr(cpu_sibling_map));
 #endif
 	return 0;
 }
