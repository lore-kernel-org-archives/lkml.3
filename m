Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaKLNqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:46:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:41654 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaKLNnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:02 -0500
Message-Id: <20141112134120.393705922@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 07/16] genirq: Introduce helper irq_domain_set_info() to
 reduce duplicated code
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=rfc-part4-v1-02-17-genirq-introduce-helper-irq_domain_set_info-to-reduce-duplicated-code.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdomain.h |    5 +++++
 kernel/irq/irqdomain.c    |   10 ++++++++++
 2 files changed, 15 insertions(+)

Index: tip/include/linux/irqdomain.h
===================================================================
--- tip.orig/include/linux/irqdomain.h
+++ tip/include/linux/irqdomain.h
@@ -33,6 +33,7 @@
 #define _LINUX_IRQDOMAIN_H
 
 #include <linux/types.h>
+#include <linux/irqhandler.h>
 #include <linux/radix-tree.h>
 
 struct device_node;
@@ -263,6 +264,10 @@ extern int irq_domain_set_hwirq_and_chip
 					 irq_hw_number_t hwirq,
 					 struct irq_chip *chip,
 					 void *chip_data);
+extern void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
+				irq_hw_number_t hwirq, struct irq_chip *chip,
+				void *chip_data, irq_flow_handler_t handler,
+				void *handler_data, const char *handler_name);
 extern void irq_domain_reset_irq_data(struct irq_data *irq_data);
 extern void irq_domain_free_irqs_common(struct irq_domain *domain,
 					int virq, int nr_irqs);
Index: tip/kernel/irq/irqdomain.c
===================================================================
--- tip.orig/kernel/irq/irqdomain.c
+++ tip/kernel/irq/irqdomain.c
@@ -882,6 +882,16 @@ int irq_domain_set_hwirq_and_chip(struct
 	return 0;
 }
 
+void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
+			 irq_hw_number_t hwirq, struct irq_chip *chip,
+			 void *chip_data, irq_flow_handler_t handler,
+			 void *handler_data, const char *handler_name)
+{
+	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
+	__irq_set_handler(virq, handler, 0, handler_name);
+	irq_set_handler_data(virq, handler_data);
+}
+
 void irq_domain_reset_irq_data(struct irq_data *irq_data)
 {
 	irq_data->hwirq = 0;


