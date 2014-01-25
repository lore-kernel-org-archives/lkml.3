Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaAYA7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 19:59:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50071 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaAYA7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 19:59:02 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH -v2] x86: allocate cpumask during check irq vectors
Date: Fri, 24 Jan 2014 16:59:25 -0800
Message-Id: <1390611565-18709-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning:
arch/x86/kernel/irq.c: In function check_irq_vectors_for_cpu_disable:
arch/x86/kernel/irq.c:337:1: warning: the frame size of 2052 bytes is larger than 2048 bytes

when NR_CPUS=8192

We should use zalloc_cpumask_var() instead.

-v2: update to GFP_ATOMIC instead and free the allocated cpumask at last.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>

---
 arch/x86/kernel/irq.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -277,11 +277,18 @@ int check_irq_vectors_for_cpu_disable(vo
 	unsigned int this_cpu, vector, this_count, count;
 	struct irq_desc *desc;
 	struct irq_data *data;
-	struct cpumask affinity_new, online_new;
+	cpumask_var_t affinity_new, online_new;
+
+	if (!alloc_cpumask_var(&affinity_new, GFP_ATOMIC))
+		return -ENOMEM;
+	if (!alloc_cpumask_var(&online_new, GFP_ATOMIC)) {
+		free_cpumask_var(affinity_new);
+		return -ENOMEM;
+	}
 
 	this_cpu = smp_processor_id();
-	cpumask_copy(&online_new, cpu_online_mask);
-	cpu_clear(this_cpu, online_new);
+	cpumask_copy(online_new, cpu_online_mask);
+	cpumask_clear_cpu(this_cpu, online_new);
 
 	this_count = 0;
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
@@ -289,8 +296,8 @@ int check_irq_vectors_for_cpu_disable(vo
 		if (irq >= 0) {
 			desc = irq_to_desc(irq);
 			data = irq_desc_get_irq_data(desc);
-			cpumask_copy(&affinity_new, data->affinity);
-			cpu_clear(this_cpu, affinity_new);
+			cpumask_copy(affinity_new, data->affinity);
+			cpumask_clear_cpu(this_cpu, affinity_new);
 
 			/* Do not count inactive or per-cpu irqs. */
 			if (!irq_has_action(irq) || irqd_is_per_cpu(data))
@@ -311,12 +318,15 @@ int check_irq_vectors_for_cpu_disable(vo
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
 
+	free_cpumask_var(affinity_new);
+	free_cpumask_var(online_new);
+
 	count = 0;
 	for_each_online_cpu(cpu) {
 		if (cpu == this_cpu)
