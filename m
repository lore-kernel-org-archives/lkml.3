Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaBYOEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:04:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaBYOEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:04:36 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Gong Chen <gong.chen@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] x86, make check_irq_vectors_for_cpu_disable() aware of numa node irqs
Date: Tue, 25 Feb 2014 09:04:21 -0500
Message-Id: <1393337061-1315-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch explicitly depends on Yinghai's patch, [PATCH v3] x86, irq: get
correct available vectors for cpu disable, which was last posted here:

http://marc.info/?l=linux-kernel&m=139094603622814&w=2

and is not yet in any tree AFAICT.

P.

-----8<-----

After some additional testing I had noticed some odd failures with storage
irqs that I originally had thought were likely due to incorrect
CPU_DOWN_FAILED calls in the kernel.  It turns out that this is not the case
and the check_irq_vectors_for_cpu_disable() is insufficient in the way it
checks for available vectors which leads to the possiblity of "orphaned"
irqs (that is, active irqs not assigned to a cpu) after a CPU down.

The current check in check_irq_vectors_for_cpu_disable() does not take into
account cases where irqs are restricted to specific numa nodes.  Currently,
the code assumes that an irq can be placed on any cpu, however, if the
PCI device that the irq is assigned to is on a specific node, the irq must
also be moved to another cpu on that node.

This patch uses the irq's node information and affinity mask to determine
where an node-specific irq can transition to.  This is done by first
creating a table of cpus and the number of empty vectors each cpu has.
Then the code traverses the list of irqs on the down'd CPU and "allocates"
an irq to an empty vector slot on the cpus.  If there are no available
vectors the code returns an error.  Note that the actual assignment of the
irqs is still done later in the cpu disable code path.

At the same time I've created a helper function, _evaluate_irq_for_cpu_disable()that is only called in from check_irq_vectors_for_cpu_disable().  This makes
the code alot easier to read.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Janet Morgan <janet.morgan@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ruiv Wang <ruiv.wang@gmail.com>
Cc: Gong Chen <gong.chen@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/irq.c |  138 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 98 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index b37b1bf..6dc27fc 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -268,67 +268,113 @@ EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-/* These two declarations are only used in check_irq_vectors_for_cpu_disable()
+/*
+ * These two declarations are only used in check_irq_vectors_for_cpu_disable()
  * below, which is protected by stop_machine().  Putting them on the stack
  * results in a stack frame overflow.  Dynamically allocating could result in a
  * failure so declare these two cpumasks as global.
  */
 static struct cpumask affinity_new, online_new;
 
+/* This array is used to keep track of how many empty vectors each cpu has. */
+static int empty_vectors[NR_CPUS];
+
 /*
- * This cpu is going to be removed and its vectors migrated to the remaining
- * online cpus.  Check to see if there are enough vectors in the remaining cpus.
- * This function is protected by stop_machine().
+ * Helper function for check_irqs_vectors_for_cpu_disable().  Returns 0 if the
+ * irq doesn't need to be reassigned to a new cpu, returns 1 if the irq does
+ * need to be reassigned to a new cpu, and an -error if there is no room for
+ * the irq.
  */
-int check_irq_vectors_for_cpu_disable(void)
+static int _evaluate_irq_for_cpu_disable(int irq)
 {
-	int irq, cpu;
-	unsigned int this_cpu, vector, this_count, count;
+	int empty_vectors_set;
+	unsigned int this_cpu;
+	unsigned int vector_cpu;
 	struct irq_desc *desc;
 	struct irq_data *data;
 
-	this_cpu = smp_processor_id();
-	cpumask_copy(&online_new, cpu_online_mask);
-	cpu_clear(this_cpu, online_new);
+	if (irq < 0)
+		return 0;
 
-	this_count = 0;
-	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-		irq = __this_cpu_read(vector_irq[vector]);
-		if (irq >= 0) {
-			desc = irq_to_desc(irq);
-			data = irq_desc_get_irq_data(desc);
-			cpumask_copy(&affinity_new, data->affinity);
-			cpu_clear(this_cpu, affinity_new);
+	this_cpu = smp_processor_id();
+	desc = irq_to_desc(irq);
+	data = irq_desc_get_irq_data(desc);
+	cpumask_copy(&affinity_new, data->affinity);
+	cpu_clear(this_cpu, affinity_new);
 
-			/* Do not count inactive or per-cpu irqs. */
-			if (!irq_has_action(irq) || irqd_is_per_cpu(data))
-				continue;
+	/* Do not count inactive or per-cpu irqs. */
+	if (!irq_has_action(irq) || irqd_is_per_cpu(data))
+		return 0;
 
-			/*
-			 * A single irq may be mapped to multiple
-			 * cpu's vector_irq[] (for example IOAPIC cluster
-			 * mode).  In this case we have two
-			 * possibilities:
-			 *
-			 * 1) the resulting affinity mask is empty; that is
-			 * this the down'd cpu is the last cpu in the irq's
-			 * affinity mask, or
-			 *
-			 * 2) the resulting affinity mask is no longer
-			 * a subset of the online cpus but the affinity
-			 * mask is not zero; that is the down'd cpu is the
-			 * last online cpu in a user set affinity mask.
-			 */
-			if (cpumask_empty(&affinity_new) ||
-			    !cpumask_subset(&affinity_new, &online_new))
-				this_count++;
+	if (desc->irq_data.node == NUMA_NO_NODE) {
+		/*
+		 * A single irq may be mapped to multiple cpu's vector_irq[]
+		 * (for example IOAPIC cluster mode).  In this case we have two
+		 * possibilities:
+		 *
+		 * 1) the resulting affinity mask is empty; that is this the
+		 * down'd cpu is the last cpu in the irq's affinity mask, or
+		 *
+		 * 2) the resulting affinity mask is no longer a subset of the
+		 * online cpus but the affinity mask is not zero; that is the
+		 * down'd cpu is the last online cpu in a user set affinity
+		 * mask.
+		 */
+		if (cpumask_empty(&affinity_new) ||
+		    !cpumask_subset(&affinity_new, &online_new))
+			return 1;
+	} else {
+		/*
+		 * In this case, the irq can be mapped to only the CPUs in
+		 * the affinity mask.  If the mask is empty, then there are
+		 * no other available cpus.
+		 */
+		if (cpumask_empty(&affinity_new)) {
+			pr_warn("CPU %d disable failed: IRQ %u has no availble CPUS to transition IRQ.\n",
+				this_cpu, irq);
+			return -ERANGE;
+		}
+		/* Check to see if there are any available vectors. */
+		for_each_cpu(vector_cpu, &affinity_new) {
+			empty_vectors_set = 0;
+			if (empty_vectors[vector_cpu] > 0) {
+				empty_vectors[vector_cpu]--;
+				empty_vectors_set = 1;
+				break;
+			}
 		}
+		if (!empty_vectors_set) {
+			pr_warn("CPU %d disable failed: IRQ %u has no available CPUS with available vectors.\n",
+				this_cpu, irq);
+			return -ERANGE;
+		}
+		return 1;
 	}
+	return 0;
+}
+
+
+/*
+ * This cpu is going to be removed and its vectors migrated to the remaining
+ * online cpus.  Check to see if there are enough vectors in the remaining cpus.
+ * This function is protected by stop_machine().
+ */
+int check_irq_vectors_for_cpu_disable(void)
+{
+	int irq, cpu, ret;
+	unsigned int this_cpu, vector, this_count, count, curr_count;
+
+	this_cpu = smp_processor_id();
+	cpumask_copy(&online_new, cpu_online_mask);
+	cpu_clear(this_cpu, online_new);
 
 	count = 0;
 	for_each_online_cpu(cpu) {
-		if (cpu == this_cpu)
+		if (cpu == this_cpu) {
+			/* we're never assigning irqs to the down'd cpu */
+			empty_vectors[cpu] = -1;
 			continue;
+		}
 
 		/*
 		 * assign_irq_vector() only scan per_cpu vectors from
@@ -339,6 +385,7 @@ int check_irq_vectors_for_cpu_disable(void)
 		 *	IRQ_MOVE_CLEANUP_VECTOR (0x20)
 		 * Don't count those as available vectors.
 		 */
+		curr_count = 0;
 		for (vector = FIRST_EXTERNAL_VECTOR;
 		     vector < first_system_vector; vector++) {
 			if (test_bit(vector, used_vectors))
@@ -346,8 +393,19 @@ int check_irq_vectors_for_cpu_disable(void)
 
 			if (per_cpu(vector_irq, cpu)[vector] < 0) {
 				count++;
+				curr_count++;
 			}
 		}
+		empty_vectors[cpu] = curr_count;
+	}
+
+	this_count = 0;
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		irq = __this_cpu_read(vector_irq[vector]);
+		ret = _evaluate_irq_for_cpu_disable(irq);
+		if (ret < 0)
+			return ret;
+		this_count += ret;
 	}
 
 	if (count < this_count) {
-- 
1.7.9.3

