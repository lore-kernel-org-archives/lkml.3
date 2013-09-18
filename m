Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3IRN2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:28:12 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:46071 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3IRN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:26:26 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/10] of/irq: Introduce __irq_of_parse_and_map()
Date: Wed, 18 Sep 2013 15:24:47 +0200
Message-Id: <1379510692-32435-6-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379510692-32435-1-git-send-email-treding@nvidia.com>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a version of irq_of_parse_and_map() that propagates the precise
error code instead of returning 0 for all errors. It will be used in
subsequent patches to allow further propagation of error codes.

To avoid code duplication, implement irq_of_parse_and_map() as a static
inline wrapper around the new __irq_of_parse_and_map(). Note that this
is somewhat complicated by the fact that SPARC implement its own version
of irq_of_parse_and_map(). Make SPARC implement __irq_of_parse_and_map()
so that the static inline wrapper can be used on all platforms.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- rename of_irq_get() to __irq_of_parse_and_map()

 arch/sparc/kernel/of_device_common.c | 12 ++++++++----
 drivers/of/irq.c                     | 18 ++++++++++++------
 include/linux/of_irq.h               | 19 ++++++++++++++-----
 3 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/arch/sparc/kernel/of_device_common.c b/arch/sparc/kernel/of_device_common.c
index de199bf..a69559f 100644
--- a/arch/sparc/kernel/of_device_common.c
+++ b/arch/sparc/kernel/of_device_common.c
@@ -11,16 +11,20 @@
 
 #include "of_device_common.h"
 
-unsigned int irq_of_parse_and_map(struct device_node *node, int index)
+int __irq_of_parse_and_map(struct device_node *node, unsigned int index,
+			   unsigned int *virqp)
 {
 	struct platform_device *op = of_find_device_by_node(node);
 
 	if (!op || index >= op->archdata.num_irqs)
-		return 0;
+		return !op ? -ENODEV : -EINVAL;
 
-	return op->archdata.irqs[index];
+	if (virqp)
+		*virqp = op->archdata.irqs[index];
+
+	return 0;
 }
-EXPORT_SYMBOL(irq_of_parse_and_map);
+EXPORT_SYMBOL(__irq_of_parse_and_map);
 
 int of_address_to_resource(struct device_node *node, int index,
 			   struct resource *r)
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 5f44388..6ad46fd 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -27,24 +27,30 @@
 #include <linux/slab.h>
 
 /**
- * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
+ * __irq_of_parse_and_map - Parse and map an interrupt into linux virq space
  * @dev: Device node of the device whose interrupt is to be mapped
  * @index: Index of the interrupt to map
+ * @virqp: Linux interrupt number filled by this function
  *
  * This function is a wrapper that chains of_irq_map_one() and
  * irq_create_of_mapping() to make things easier to callers
+ *
+ * Returns 0 on success or a negative error code on failure.
  */
-unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
+int __irq_of_parse_and_map(struct device_node *dev, unsigned int index,
+			   unsigned int *virqp)
 {
 	struct of_irq oirq;
+	int ret;
 
-	if (of_irq_map_one(dev, index, &oirq))
-		return 0;
+	ret = of_irq_map_one(dev, index, &oirq);
+	if (ret)
+		return ret;
 
 	return irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
+				     oirq.size, virqp);
 }
-EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
+EXPORT_SYMBOL_GPL(__irq_of_parse_and_map);
 
 /**
  * of_irq_find_parent - Given a device node, find its interrupt parent node
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 138266d..11da949 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -11,11 +11,12 @@ struct of_irq;
 #include <linux/of.h>
 
 /*
- * irq_of_parse_and_map() is used by all OF enabled platforms; but SPARC
+ * __irq_of_parse_and_map() is used by all OF enabled platforms; but SPARC
  * implements it differently.  However, the prototype is the same for all,
  * so declare it here regardless of the CONFIG_OF_IRQ setting.
  */
-extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
+extern int __irq_of_parse_and_map(struct device_node *node, unsigned int index,
+				  unsigned int *virqp);
 
 #if defined(CONFIG_OF_IRQ)
 /**
@@ -78,10 +79,11 @@ extern void of_irq_init(const struct of_device_id *matches);
 #endif /* CONFIG_OF_IRQ */
 
 #else /* !CONFIG_OF */
-static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
-						int index)
+static inline int __irq_of_parse_and_map(struct device_node *dev,
+					 unsigned int index,
+					 unsigned int *virqp)
 {
-	return 0;
+	return -ENOSYS;
 }
 
 static inline void *of_irq_find_parent(struct device_node *child)
@@ -90,4 +92,11 @@ static inline void *of_irq_find_parent(struct device_node *child)
 }
 #endif /* !CONFIG_OF */
 
+static inline unsigned int irq_of_parse_and_map(struct device_node *node,
+						unsigned int index)
+{
+	unsigned int irq;
+	return (__irq_of_parse_and_map(node, index, &irq) < 0) ? 0 : irq;
+}
+
 #endif /* __OF_IRQ_H */
-- 
1.8.4

