Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaFDLOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:14:04 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58652 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaFDLNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:13:38 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 01/21] irq: add devres version of OF IRQ mapping routines
Date: Wed,  4 Jun 2014 15:13:01 +0400
Message-Id: <1401880402-30091-2-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

Many drivers use devres to manage their resources, and at the same time
use irq_of_parse_and_map() / irq_dispose_mapping(). This creates problem
on driver unload paths and on error paths:
- it is invalid to call irq_dispose_mapping() while IRQ handler is still
  installed,
- devres moves removal of IRQ handler out of driver,
- without explicit devres support for IRQ mapping, irq_dispose_mapping()
  stays in driver and thus gets called while IRQ handler is still
  installed.

This patch adds devm_irq_create_of_mapping() and devm_irq_of_parse_and_map()
routines to be used by drivers for correct release of resources.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/of/irq.c          |   24 +++++++++++++++++++++++
 include/linux/irqdomain.h |    3 +++
 include/linux/of_irq.h    |   12 ++++++++++++
 kernel/irq/irqdomain.c    |   47 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 5aeb894..30b5010 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -46,6 +46,30 @@ unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 
 /**
+ * devm_irq_of_parse_and_map - Parse and map an interrupt into linux virq space
+ * @dev: Device interrupt will be used for
+ * @dn: Device node of the device whose interrupt is to be mapped
+ * @index: Index of the interrupt to map
+ *
+ * This function does the same as irq_of_parse_and_map(), but ensures that
+ * irq_dispose_mapping() will be called automatically at driver detatch.
+ *
+ * If IRQ mapping created by this function needs to be removed manually,
+ * devm_irq_dispose_mapping() must be called instead of irq_dispose_mapping().
+ */
+int devm_irq_of_parse_and_map(struct device *dev, struct device_node *dn,
+		int index)
+{
+	struct of_phandle_args oirq;
+
+	if (of_irq_parse_one(dn, index, &oirq))
+		return 0;
+
+	return devm_irq_create_of_mapping(dev, &oirq);
+}
+EXPORT_SYMBOL_GPL(devm_irq_of_parse_and_map);
+
+/**
  * of_irq_find_parent - Given a device node, find its interrupt parent node
  * @child: pointer to device node
  *
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index c983ed1..44e6261 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -176,6 +176,7 @@ extern void irq_domain_associate_many(struct irq_domain *domain,
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
 extern void irq_dispose_mapping(unsigned int virq);
+extern void devm_irq_dispose_mapping(struct device *dev, unsigned int virq);
 
 /**
  * irq_linear_revmap() - Find a linux irq from a hw irq number.
@@ -220,6 +221,8 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
 
 #else /* CONFIG_IRQ_DOMAIN */
 static inline void irq_dispose_mapping(unsigned int virq) { }
+static inline void devm_irq_dispose_mapping(struct device *dev,
+		unsigned int virq) { }
 #endif /* !CONFIG_IRQ_DOMAIN */
 
 #endif /* _LINUX_IRQDOMAIN_H */
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 6404253..4ac7138 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -35,6 +35,8 @@ extern int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 extern int of_irq_parse_one(struct device_node *device, int index,
 			  struct of_phandle_args *out_irq);
 extern unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data);
+extern int devm_irq_create_of_mapping(struct device *dev,
+		struct of_phandle_args *irq_data);
 extern int of_irq_to_resource(struct device_node *dev, int index,
 			      struct resource *r);
 extern int of_irq_to_resource_table(struct device_node *dev,
@@ -63,6 +65,9 @@ static inline int of_irq_get(struct device_node *dev, int index)
  * so declare it here regardless of the CONFIG_OF_IRQ setting.
  */
 extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
+extern int devm_irq_of_parse_and_map(struct device *dev,
+				     struct device_node *node,
+				     int index);
 extern struct device_node *of_irq_find_parent(struct device_node *child);
 
 #else /* !CONFIG_OF */
@@ -72,6 +77,13 @@ static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
 	return 0;
 }
 
+static inline int devm_irq_of_parse_and_map(struct device *dev,
+					    struct device_node *node,
+					    int index)
+{
+	return 0;
+}
+
 static inline void *of_irq_find_parent(struct device_node *child)
 {
 	return NULL;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index f140337..c8705de 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/fs.h>
+#include <linux/device.h>
 
 static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
@@ -502,6 +503,34 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
 
+static void devm_release_irq_mapping(void *p)
+{
+	unsigned int virq = (unsigned int)((unsigned long)p);
+
+	if (virq)
+		irq_dispose_mapping(virq);
+}
+
+int devm_irq_create_of_mapping(struct device *dev,
+		struct of_phandle_args *irq_data)
+{
+	unsigned int virq;
+	int ret;
+
+	virq = irq_create_of_mapping(irq_data);
+	if (virq) {
+		ret = devm_add_action(dev, devm_release_irq_mapping,
+				(void *)((unsigned long)virq));
+		if (ret) {
+			irq_dispose_mapping(virq);
+			return ret;
+		}
+	}
+
+	return virq;
+}
+EXPORT_SYMBOL_GPL(devm_irq_create_of_mapping);
+
 /**
  * irq_dispose_mapping() - Unmap an interrupt
  * @virq: linux irq number of the interrupt to unmap
@@ -524,6 +553,24 @@ void irq_dispose_mapping(unsigned int virq)
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 
 /**
+ * devm_irq_dispose_mapping() - Unmap an interrupt
+ * @dev: device irq was used for
+ * @virq: linux irq number of the interrupt to unmap
+ *
+ * This should be used instead of irq_dispose_mapping() if mapping was created
+ * with devm_irq_create_of_mapping()
+ */
+void devm_irq_dispose_mapping(struct device *dev, unsigned int virq)
+{
+	if (virq) {
+		devm_remove_action(dev, devm_release_irq_mapping,
+				(void *)((unsigned long)virq));
+		irq_dispose_mapping(virq);
+	}
+}
+EXPORT_SYMBOL_GPL(devm_irq_dispose_mapping);
+
+/**
  * irq_find_mapping() - Find a linux irq from an hw irq number.
  * @domain: domain owning this hardware interrupt
  * @hwirq: hardware irq number in that domain space
-- 
1.7.10.4

