Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaAQNjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:39:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaAQNjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:39:37 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Gong Chen <gong.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Fengguang Wu <fengguang.wu@Intel.com>
Subject: [PATCH] x86, cpu hotplug, use cpumask stack safe variant cpumask_var_t in check_irq_vectors_for_cpu_disable()
Date: Fri, 17 Jan 2014 08:39:21 -0500
Message-Id: <1389965961-14975-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild, 0day kernel build service, outputs the warning:

arch/x86/kernel/irq.c:333:1: warning: the frame size of 2056 bytes
is larger than 2048 bytes [-Wframe-larger-than=]

because check_irq_vectors_for_cpu_disable() allocates two cpumasks on the
stack.  Fix this by using cpumask_var_t, the cpumask stack safe variant.

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
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Gong Chen <gong.chen@linux.intel.com>
Cc: x86@kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/x86/kernel/irq.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 4207e8d..b760c8d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -269,15 +269,25 @@ EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
  */
 int check_irq_vectors_for_cpu_disable(void)
 {
-	int irq, cpu;
+	int irq, cpu, ret = 0;
 	unsigned int this_cpu, vector, this_count, count;
 	struct irq_desc *desc;
 	struct irq_data *data;
-	struct cpumask affinity_new, online_new;
+	cpumask_var_t affinity_new, online_new;
+
+	if (!alloc_cpumask_var(&online_new, GFP_KERNEL)){
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (!alloc_cpumask_var(&affinity_new, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto free_online_new;
+	}
 
 	this_cpu = smp_processor_id();
-	cpumask_copy(&online_new, cpu_online_mask);
-	cpu_clear(this_cpu, online_new);
+	cpumask_copy(online_new, cpu_online_mask);
+	__cpu_clear(this_cpu, online_new);
 
 	this_count = 0;
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
@@ -285,8 +295,8 @@ int check_irq_vectors_for_cpu_disable(void)
 		if (irq >= 0) {
 			desc = irq_to_desc(irq);
 			data = irq_desc_get_irq_data(desc);
-			cpumask_copy(&affinity_new, data->affinity);
-			cpu_clear(this_cpu, affinity_new);
+			cpumask_copy(affinity_new, data->affinity);
+			__cpu_clear(this_cpu, affinity_new);
 
 			/* Do not count inactive or per-cpu irqs. */
 			if (!irq_has_action(irq) || irqd_is_per_cpu(data))
@@ -307,8 +317,8 @@ int check_irq_vectors_for_cpu_disable(void)
 			 * mask is not zero; that is the down'd cpu is the
 			 * last online cpu in a user set affinity mask.
 			 */
-			if (cpumask_empty(&affinity_new) ||
-			    !cpumask_subset(&affinity_new, &online_new))
+			if (cpumask_empty(affinity_new) ||
+			    !cpumask_subset(affinity_new, online_new))
 				this_count++;
 		}
 	}
@@ -327,9 +337,14 @@ int check_irq_vectors_for_cpu_disable(void)
 	if (count < this_count) {
 		pr_warn("CPU %d disable failed: CPU has %u vectors assigned and there are only %u available.\n",
 			this_cpu, this_count, count);
-		return -ERANGE;
+		ret = -ERANGE;
 	}
-	return 0;
+
+	free_cpumask_var(affinity_new);
+free_online_new:
+	free_cpumask_var(online_new);
+out:
+	return ret;
 }
 
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-- 
1.7.9.3

