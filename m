Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3FNVIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:08:23 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39204 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3FNVIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:08:20 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 07/11] irqdomain: Beef up debugfs output
Date: Fri, 14 Jun 2013 22:08:02 +0100
Message-Id: <1371244086-9189-8-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
References: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch increases the amount of output produced by the
irq_domain_mapping debugfs file by first listing all of the registered
irq domains at the beginning of the output, and then by including all
mapped IRQs in the output, not just the active ones. It is very useful
when debugging irqdomain issues to be able to see the entire list of
mapped irqs, not just the ones that happen to be connected to devices.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 kernel/irq/irqdomain.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index e0db59e..280b804 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -596,12 +596,29 @@ static int virq_debug_show(struct seq_file *m, void *private)
 {
 	unsigned long flags;
 	struct irq_desc *desc;
-	void *data;
+	struct irq_domain *domain;
+	struct radix_tree_iter iter;
+	void *data, **slot;
 	int i;
 
-	seq_printf(m, "%-5s  %-7s  %-15s  %-*s  %s\n", "irq", "hwirq",
+	seq_printf(m, " %-16s  %-6s  %-10s  %-10s  %s\n",
+		   "name", "mapped", "linear-max", "direct-max", "devtree-node");
+	mutex_lock(&irq_domain_mutex);
+	list_for_each_entry(domain, &irq_domain_list, link) {
+		int count = 0;
+		radix_tree_for_each_slot(slot, &domain->revmap_tree, &iter, 0)
+			count++;
+		seq_printf(m, "%c%-16s  %6u  %10u  %10u  %s\n",
+			   domain == irq_default_domain ? '*' : ' ', domain->name,
+			   domain->revmap_size + count, domain->revmap_size,
+			   domain->revmap_direct_max_irq,
+			   domain->of_node ? of_node_full_name(domain->of_node) : "");
+	}
+	mutex_unlock(&irq_domain_mutex);
+
+	seq_printf(m, "%-5s  %-7s  %-15s  %-*s  %6s  %-14s  %s\n", "irq", "hwirq",
 		      "chip name", (int)(2 * sizeof(void *) + 2), "chip data",
-		      "domain name");
+		      "active", "type", "domain");
 
 	for (i = 1; i < nr_irqs; i++) {
 		desc = irq_to_desc(i);
@@ -609,12 +626,15 @@ static int virq_debug_show(struct seq_file *m, void *private)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
+		domain = desc->irq_data.domain;
 
-		if (desc->action && desc->action->handler) {
+		if (domain) {
 			struct irq_chip *chip;
+			int hwirq = desc->irq_data.hwirq;
+			bool direct;
 
 			seq_printf(m, "%5d  ", i);
-			seq_printf(m, "0x%05lx  ", desc->irq_data.hwirq);
+			seq_printf(m, "0x%05x  ", hwirq);
 
 			chip = irq_desc_get_chip(desc);
 			seq_printf(m, "%-15s  ", (chip && chip->name) ? chip->name : "none");
@@ -622,6 +642,11 @@ static int virq_debug_show(struct seq_file *m, void *private)
 			data = irq_desc_get_chip_data(desc);
 			seq_printf(m, data ? "0x%p  " : "  %p  ", data);
 
+			seq_printf(m, "   %c    ", (desc->action && desc->action->handler) ? '*' : ' ');
+			direct = (i == hwirq) && (i < domain->revmap_direct_max_irq);
+			seq_printf(m, "%6s%-8s  ",
+				   (hwirq < domain->revmap_size) ? "LINEAR" : "RADIX",
+				   direct ? "(DIRECT)" : "");
 			seq_printf(m, "%s\n", desc->irq_data.domain->name);
 		}
 
-- 
1.8.1.2

