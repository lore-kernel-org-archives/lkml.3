Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3FNVKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:10:53 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36021 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3FNVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:08:18 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 03/11] irqdomain: Add a name field
Date: Fri, 14 Jun 2013 22:07:58 +0100
Message-Id: <1371244086-9189-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
References: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a name field to the irq_domain structure to help mere
mortals understand the mappings between irq domains and virqs. It also
converts a number of places that have open-coded some kind of fudging
an irqdomain name to use the new field. This means a more consistent
display of names in irq domain log messages and debugfs output.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 include/linux/irqdomain.h |  1 +
 kernel/irq/generic-chip.c |  1 +
 kernel/irq/irqdomain.c    | 19 ++++++-------------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 6f06241..e5e513c 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -89,6 +89,7 @@ struct irq_domain_chip_generic;
  */
 struct irq_domain {
 	struct list_head link;
+	const char *name;
 
 	/* type of reverse mapping_technique */
 	unsigned int revmap_type;
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 95575d8..ca98cc5 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -305,6 +305,7 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 		/* Calc pointer to the next generic chip */
 		tmp += sizeof(*gc) + num_ct * sizeof(struct irq_chip_type);
 	}
+	d->name = name;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_alloc_domain_generic_chips);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 1ac8cf4..b1b5e67 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -410,12 +410,15 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 				 */
 				if (ret != -EPERM) {
 					pr_info("%s didn't like hwirq-0x%lx to VIRQ%i mapping (rc=%d)\n",
-					       of_node_full_name(domain->of_node), hwirq, virq, ret);
+					       domain->name, hwirq, virq, ret);
 				}
 				irq_data->domain = NULL;
 				irq_data->hwirq = 0;
 				continue;
 			}
+			/* If not already assigned, give the domain the chip's name */
+			if (!domain->name && irq_data->chip)
+				domain->name = irq_data->chip->name;
 		}
 
 		switch (domain->revmap_type) {
@@ -708,8 +711,6 @@ static int virq_debug_show(struct seq_file *m, void *private)
 {
 	unsigned long flags;
 	struct irq_desc *desc;
-	const char *p;
-	static const char none[] = "none";
 	void *data;
 	int i;
 
@@ -731,20 +732,12 @@ static int virq_debug_show(struct seq_file *m, void *private)
 			seq_printf(m, "0x%05lx  ", desc->irq_data.hwirq);
 
 			chip = irq_desc_get_chip(desc);
-			if (chip && chip->name)
-				p = chip->name;
-			else
-				p = none;
-			seq_printf(m, "%-15s  ", p);
+			seq_printf(m, "%-15s  ", (chip && chip->name) ? chip->name : "none");
 
 			data = irq_desc_get_chip_data(desc);
 			seq_printf(m, data ? "0x%p  " : "  %p  ", data);
 
-			if (desc->irq_data.domain)
-				p = of_node_full_name(desc->irq_data.domain->of_node);
-			else
-				p = none;
-			seq_printf(m, "%s\n", p);
+			seq_printf(m, "%s\n", desc->irq_data.domain->name);
 		}
 
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
-- 
1.8.1.2

