Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaAXUKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:10:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27192 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaAXUKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:10:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] x86: allocate cpumask during check irq vectors
Date: Fri, 24 Jan 2014 12:11:07 -0800
Message-Id: <1390594267-16739-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning:
arch/x86/kernel/irq.c: In function check_irq_vectors_for_cpu_disable:
arch/x86/kernel/irq.c:337:1: warning: the frame size of 2052 bytes is larger than 2048 bytes

when NR_CPUS=8192

We should use zalloc_cpumask_var() instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index dbb6087..b114ee4 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -277,11 +277,14 @@ int check_irq_vectors_for_cpu_disable(void)
 	unsigned int this_cpu, vector, this_count, count;
 	struct irq_desc *desc;
 	struct irq_data *data;
-	struct cpumask affinity_new, online_new;
+	cpumask_var_t affinity_new, online_new;
+
+	zalloc_cpumask_var(&affinity_new, GFP_KERNEL);
+	zalloc_cpumask_var(&online_new, GFP_KERNEL);
 
 	this_cpu = smp_processor_id();
-	cpumask_copy(&online_new, cpu_online_mask);
-	cpu_clear(this_cpu, online_new);
+	cpumask_copy(online_new, cpu_online_mask);
+	cpumask_clear_cpu(this_cpu, online_new);
 
 	this_count = 0;
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
@@ -289,8 +292,8 @@ int check_irq_vectors_for_cpu_disable(void)
 		if (irq >= 0) {
 			desc = irq_to_desc(irq);
 			data = irq_desc_get_irq_data(desc);
-			cpumask_copy(&affinity_new, data->affinity);
-			cpu_clear(this_cpu, affinity_new);
+			cpumask_copy(affinity_new, data->affinity);
+			cpumask_clear_cpu(this_cpu, affinity_new);
 
 			/* Do not count inactive or per-cpu irqs. */
 			if (!irq_has_action(irq) || irqd_is_per_cpu(data))
@@ -311,8 +314,8 @@ int check_irq_vectors_for_cpu_disable(void)
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
