Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaDWW64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:58:56 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51668 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaDWW6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:58:03 -0400
From: Rob Herring <robherring2@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        thierry.reding@gmail.com, Rob Herring <robh@kernel.org>
Subject: [PATCH 2/2] of/irq: do irq resolution in platform_get_irq
Date: Wed, 23 Apr 2014 17:57:41 -0500
Message-Id: <1398293861-7682-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398293861-7682-1-git-send-email-robherring2@gmail.com>
References: <1398293861-7682-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Currently we get the following kind of errors if we try to use interrupt
phandles to irqchips that have not yet initialized:

irq: no irq domain found for /ocp/pinmux@48002030 !
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x144/0x184()
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
(show_stack+0x14/0x1c)
(dump_stack+0x6c/0xa0)
(warn_slowpath_common+0x64/0x84)
(warn_slowpath_null+0x1c/0x24)
(of_device_alloc+0x144/0x184)
(of_platform_device_create_pdata+0x44/0x9c)
(of_platform_bus_create+0xd0/0x170)
(of_platform_bus_create+0x12c/0x170)
(of_platform_populate+0x60/0x98)

This is because we're wrongly trying to populate resources that are not
yet available. It's perfectly valid to create irqchips dynamically, so
let's fix up the issue by resolving the interrupt resources when
platform_get_irq is called.

And then we also need to accept the fact that some irqdomains do not
exist that early on, and only get initialized later on. So we can
make the current WARN_ON into just into a pr_debug().

We still attempt to populate irq resources when we create the devices.
This allows current drivers which don't use platform_get_irq to continue
to function. Once all drivers are fixed, this code can be removed.

Suggested-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/base/platform.c |  7 ++++++-
 drivers/of/irq.c        | 26 ++++++++++++++++++++++++++
 drivers/of/platform.c   |  4 +++-
 include/linux/of_irq.h  |  7 ++++++-
 4 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index e714709..5b47210 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -13,6 +13,7 @@
 #include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
@@ -87,7 +88,11 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
 		return -ENXIO;
 	return dev->archdata.irqs[num];
 #else
-	struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);
+	struct resource *r;
+	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
+		return of_irq_get(dev->dev.of_node, num);
+
+	r = platform_get_resource(dev, IORESOURCE_IRQ, num);
 
 	return r ? r->start : -ENXIO;
 #endif
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 9bcf2cf..ca01893 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -380,6 +380,32 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
 EXPORT_SYMBOL_GPL(of_irq_to_resource);
 
 /**
+ * of_irq_get - Decode a node's IRQ and return it as a Linux irq number
+ * @dev: pointer to device tree node
+ * @index: zero-based index of the irq
+ *
+ * Returns Linux irq number on success, or -EPROBE_DEFER if the irq domain
+ * is not yet created.
+ *
+ */
+int of_irq_get(struct device_node *dev, int index)
+{
+	int rc;
+	struct of_phandle_args oirq;
+	struct irq_domain *domain;
+
+	rc = of_irq_parse_one(dev, index, &oirq);
+	if (rc)
+		return rc;
+
+	domain = irq_find_host(oirq.np);
+	if (!domain)
+		return -EPROBE_DEFER;
+
+	return irq_create_of_mapping(&oirq);
+}
+
+/**
  * of_irq_count - Count the number of IRQs a node uses
  * @dev: pointer to device tree node
  */
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..bd47fbc 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -168,7 +168,9 @@ struct platform_device *of_device_alloc(struct device_node *np,
 			rc = of_address_to_resource(np, i, res);
 			WARN_ON(rc);
 		}
-		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+		if (of_irq_to_resource_table(np, res, num_irq) != num_irq)
+			pr_debug("not all legacy IRQ resources mapped for %s\n",
+				 np->name);
 	}
 
 	dev->dev.of_node = of_node_get(np);
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 3f23b44..bc9e51a 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -34,21 +34,26 @@ static inline int of_irq_parse_oldworld(struct device_node *device, int index,
 extern int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq);
 extern int of_irq_parse_one(struct device_node *device, int index,
 			  struct of_phandle_args *out_irq);
-extern unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data);
 extern int of_irq_to_resource(struct device_node *dev, int index,
 			      struct resource *r);
 extern int of_irq_to_resource_table(struct device_node *dev,
 		struct resource *res, int nr_irqs);
+extern unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data);
 
 extern void of_irq_init(const struct of_device_id *matches);
 
 #ifdef CONFIG_OF_IRQ
 extern int of_irq_count(struct device_node *dev);
+extern int of_irq_get(struct device_node *dev, int index);
 #else
 static inline int of_irq_count(struct device_node *dev)
 {
 	return 0;
 }
+static inline int of_irq_get(struct device_node *dev, int index)
+{
+	return 0;
+}
 #endif
 
 #if defined(CONFIG_OF)
-- 
1.9.1

