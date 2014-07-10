Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaGJRQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:16:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbaGJRO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:14:28 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 1/7] genirq: generic chip: export irq_map_generic_chip function
Date: Thu, 10 Jul 2014 19:14:16 +0200
Message-Id: <1405012462-766-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the generic irq map function in order to provide irq_domain ops with
generic mapping and specific of xlate function (needed by the new atmel
AIC driver).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       | 2 ++
 kernel/irq/generic-chip.c | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 0d998d8..62af592 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -771,6 +771,8 @@ void irq_gc_eoi(struct irq_data *d);
 int irq_gc_set_wake(struct irq_data *d, unsigned int on);
 
 /* Setup functions for irq_chip_generic */
+int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw_irq);
 struct irq_chip_generic *
 irq_alloc_generic_chip(const char *name, int nr_ct, unsigned int irq_base,
 		       void __iomem *reg_base, irq_flow_handler_t handler);
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 452d6f2..cf80e7b 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -341,8 +341,8 @@ static struct lock_class_key irq_nested_lock_class;
 /*
  * irq_map_generic_chip - Map a generic chip for an irq domain
  */
-static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
-				irq_hw_number_t hw_irq)
+int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw_irq)
 {
 	struct irq_data *data = irq_get_irq_data(virq);
 	struct irq_domain_chip_generic *dgc = d->gc;
@@ -394,6 +394,7 @@ static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
 	irq_modify_status(virq, dgc->irq_flags_to_clear, dgc->irq_flags_to_set);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(irq_map_generic_chip);
 
 struct irq_domain_ops irq_generic_chip_ops = {
 	.map	= irq_map_generic_chip,
-- 
1.8.3.2

