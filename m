Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaBMKAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:00:25 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61958 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaBMKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:00:21 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: gregkh@linuxfoundation.org, grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] dt: platform driver: Fill the resources before probe and defer if needed
Date: Thu, 13 Feb 2014 10:57:09 +0100
Message-Id: <1392285429-9325-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this patch is to allow drivers to be probed even if at the time of
the DT parsing some of their ressources are not available yet.

In the current situation, the resource of a platform device are filled from the
DT at the time the device is created (of_device_alloc()). The drawbackof this
is that a device sitting close to the top of the DT (ahb for example) but
depending on ressources that are initialized later (IRQ domain dynamically
created for example)  will fail to probe because the ressources don't exist
at this time.

This patch fills the resource structure only before the device is probed and
will defer the probe if the resource are not available yet.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/base/platform.c     |  6 ++++
 drivers/of/platform.c       | 71 +++++++++++++++++++++++++++++----------------
 include/linux/of_platform.h | 10 +++++++
 3 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index bc78848..8e37d8b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -481,6 +481,12 @@ static int platform_drv_probe(struct device *_dev)
 	struct platform_device *dev = to_platform_device(_dev);
 	int ret;
 
+	if (_dev->of_node) {
+		ret = of_platform_device_populate_resources(dev);
+		if (ret < 0)
+			return drv->prevent_deferred_probe ? ret : -EPROBE_DEFER;
+	}
+
 	if (ACPI_HANDLE(_dev))
 		acpi_dev_pm_attach(_dev, true);
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..64a8eb8 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -141,36 +141,11 @@ struct platform_device *of_device_alloc(struct device_node *np,
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
@@ -233,6 +208,52 @@ static struct platform_device *of_platform_device_create_pdata(
 	return dev;
 }
 
+int of_platform_device_populate_resources(struct platform_device *dev)
+{
+	struct device_node *np;
+	int rc = 0, i, nreg = 0, nirq;
+
+	np = dev->dev.of_node;
+
+	/* count the io and irq resources */
+	if (of_can_translate_address(np)) {
+		struct resource temp_res;
+		while (of_address_to_resource(np, nreg, &temp_res) == 0)
+			nreg++;
+	}
+	nirq = of_irq_count(np);
+
+	/* Populate the resource table */
+	if (nirq || nreg) {
+		struct resource *res;
+
+		res = krealloc(dev->resource, sizeof(*res) * (nirq + nreg),
+			       GFP_KERNEL);
+		if (!res) {
+			kfree(dev->resource);
+			dev->resource = NULL;
+			return -ENOMEM;
+		}
+		memset(res, 0, sizeof(*res) * (nirq + nreg));
+		dev->resource = res;
+		dev->num_resources = nreg + nirq;
+
+		for (i = 0; i < nreg; i++, res++) {
+			rc = of_address_to_resource(np, i, res);
+			WARN_ON(rc);
+			if (rc)
+				break;
+		}
+
+		if (!rc && of_irq_to_resource_table(np, res, nirq) != nirq) {
+			rc = -ENOENT;
+			WARN_ON(rc);
+		}
+	}
+	return rc;
+}
+EXPORT_SYMBOL(of_platform_device_populate_resources);
+
 /**
  * of_platform_device_create - Alloc, initialize and register an of_device
  * @np: pointer to node to create device for
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 05cb4a9..315e1e3 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -53,6 +53,16 @@ struct of_dev_auxdata {
 
 extern const struct of_device_id of_default_bus_match_table[];
 
+/* Populate the resource for a platform device */
+#ifdef CONFIG_OF
+int of_platform_device_populate_resources(struct platform_device *dev);
+#else
+static inline int of_platform_device_populate_resources(
+	struct platform_device *)
+{
+	return -ENOSYS;
+}
+#endif
 /* Platform drivers register/unregister */
 extern struct platform_device *of_device_alloc(struct device_node *np,
 					 const char *bus_id,
-- 
1.8.5.3

