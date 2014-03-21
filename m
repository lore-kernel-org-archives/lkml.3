Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842AbaCUOuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:50:16 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58836 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128AbaCUOt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:49:59 -0400
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: grant.likely@secretlab.ca
Cc: devicetree@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v3 2/2] dt: platform driver: Fill the resources before probe and defer if needed
Date: Fri, 21 Mar 2014 15:46:25 +0100
Message-Id: <1395413185-29763-3-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
References: <20140320161118.B7075C4067A@trevor.secretlab.ca>
 <1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this patch is to allow drivers to be probed even if at the time of
the DT parsing some of their IRQ ressources are not available yet.

In the current situation, the IRQ resources of a platform device are filled from
the DT at the time the device is created (of_device_alloc()). The drawback of
this is that a device sitting close to the top of the DT (ahb for example) but
depending on ressources that are initialized later (IRQ domain dynamically
created for example) will fail to probe because the ressources don't exist
at this time.

This patch fills the resource structure only before the device is probed and
will defer the probe if the IRQ resource is not yet available.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/base/platform.c     |   5 ++
 drivers/of/platform.c       | 114 ++++++++++++++++++++++++++++++++++----------
 include/linux/device.h      |   1 +
 include/linux/of_platform.h |  10 ++++
 4 files changed, 105 insertions(+), 25 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index bc78848..cee9b8d 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -481,6 +481,10 @@ static int platform_drv_probe(struct device *_dev)
 	struct platform_device *dev = to_platform_device(_dev);
 	int ret;
 
+	ret = of_platform_device_prepare(dev);
+	if (ret)
+		goto error;
+
 	if (ACPI_HANDLE(_dev))
 		acpi_dev_pm_attach(_dev, true);
 
@@ -488,6 +492,7 @@ static int platform_drv_probe(struct device *_dev)
 	if (ret && ACPI_HANDLE(_dev))
 		acpi_dev_pm_detach(_dev, true);
 
+error:
 	if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
 		dev_warn(_dev, "probe deferral not supported\n");
 		ret = -ENXIO;
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..ba6be4a 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -141,41 +141,17 @@ struct platform_device *of_device_alloc(struct device_node *np,
 				  struct device *parent)
 {
 	struct platform_device *dev;
-	int rc, i, num_reg = 0, num_irq;
-	struct resource *res, temp_res;
 
 	dev = platform_device_alloc("", -1);
 	if (!dev)
 		return NULL;
 
-	/* count the io and irq resources */
-	if (of_can_translate_address(np))
-		while (of_address_to_resource(np, num_reg, &temp_res) == 0)
-			num_reg++;
-	num_irq = of_irq_count(np);
-
-	/* Populate the resource table */
-	if (num_irq || num_reg) {
-		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
-		if (!res) {
-			platform_device_put(dev);
-			return NULL;
-		}
-
-		dev->num_resources = num_reg + num_irq;
-		dev->resource = res;
-		for (i = 0; i < num_reg; i++, res++) {
-			rc = of_address_to_resource(np, i, res);
-			WARN_ON(rc);
-		}
-		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
-	}
-
 	dev->dev.of_node = of_node_get(np);
 #if defined(CONFIG_MICROBLAZE)
 	dev->dev.dma_mask = &dev->archdata.dma_mask;
 #endif
 	dev->dev.parent = parent;
+	dev->dev.of_device = 1;
 
 	if (bus_id)
 		dev_set_name(&dev->dev, "%s", bus_id);
@@ -233,6 +209,94 @@ static struct platform_device *of_platform_device_create_pdata(
 	return dev;
 }
 
+static int of_reg_count(struct device_node *np)
+{
+	int nreg = 0;
+	if (of_can_translate_address(np)) {
+		struct resource temp_res;
+		while (of_address_to_resource(np, nreg, &temp_res) == 0)
+			nreg++;
+	}
+	return nreg;
+}
+
+int of_platform_device_prepare(struct platform_device *dev)
+{
+	struct device_node *np;
+	int i, irq_index;
+	struct resource *res;
+
+	/*
+	 * This function applies only devices described in the DT and
+	 * created by of_device_alloc().
+	 * Other platform devices have their ressources already populated.
+	 */
+	np = dev->dev.of_node;
+	if (!np || !dev->dev.of_device)
+		return 0;
+
+	/* Populate the resource table */
+	if (!dev->resource) {
+		int rc, nreg = 0, nirq;
+		/* count the io and irq resources */
+		nreg = of_reg_count(np);
+		nirq = of_irq_count(np);
+
+		if (!nirq && !nreg)
+			return 0;
+
+		res = kzalloc(sizeof(*res) * (nirq + nreg), GFP_KERNEL);
+		if (!res)
+			return -ENOMEM;
+
+		dev->resource = res;
+		dev->num_resources = nreg + nirq;
+
+		for (i = 0; i < nreg; i++, res++) {
+			rc = of_address_to_resource(np, i, res);
+			if (WARN_ON(rc)) {
+				/* THIS IS BAD; don't try to defer probing */
+				dev->num_resources = 0;
+				dev->resource = NULL;
+				kfree(res);
+				return rc;
+			}
+		}
+
+		if (!rc && of_irq_to_resource_table(np, res, nirq) != nirq)
+			/*
+			 * Not all irqs can be translated. redo the irq
+			 * resources to check if the probe can be deferred
+			 */
+			goto redo_irq_resources;
+
+		return 0;
+	}
+
+redo_irq_resources:
+	/* See which IRQ resources need to be redone */
+	irq_index = 0;
+	for (i = 0, res = dev->resource; i < dev->num_resources; i++, res++) {
+		if (!res->flags) {
+			int rc;
+			/*
+			 * If the IRQ can't be translated to a resource, check
+			 * if its IRQ domain exists.
+			 */
+			rc = of_irq_to_resource(np, irq_index, res);
+			if (!rc) {
+				if (of_find_irq_domain(np, irq_index) == NULL)
+					return -EPROBE_DEFER;
+				return rc;
+			}
+			irq_index++;
+		} else if (res->flags & IORESOURCE_IRQ)
+			irq_index++;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(of_platform_device_prepare);
+
 /**
  * of_platform_device_create - Alloc, initialize and register an of_device
  * @np: pointer to node to create device for
diff --git a/include/linux/device.h b/include/linux/device.h
index 952b010..eb6ac66 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -785,6 +785,7 @@ struct device {
 
 	bool			offline_disabled:1;
 	bool			offline:1;
+	bool			of_device:1;
 };
 
 static inline struct device *kobj_to_dev(struct kobject *kobj)
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 05cb4a9..4e487ff 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -53,6 +53,16 @@ struct of_dev_auxdata {
 
 extern const struct of_device_id of_default_bus_match_table[];
 
+/* Populate the resource for a platform device */
+#ifdef CONFIG_OF
+int of_platform_device_prepare(struct platform_device *dev);
+#else
+static inline int of_platform_device_prepare(
+	struct platform_device *dev)
+{
+	return 0;
+}
+#endif
 /* Platform drivers register/unregister */
 extern struct platform_device *of_device_alloc(struct device_node *np,
 					 const char *bus_id,
-- 
1.9.0

