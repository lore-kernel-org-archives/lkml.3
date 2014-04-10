Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbaDJViS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 17:38:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52894 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753715AbaDJViR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 17:38:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/cPR5D82fHASCjm4KqMjpt
Date: Thu, 10 Apr 2014 14:38:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Rob Herring <robherring2@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] of/platform: Fix no irq domain found errors when populating
 interrupts
Message-ID: <20140410213808.GA5990@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This is because we're wrongly trying to populate resources that are not yet
available. It's perfectly valid to create irqchips dynamically, so let's
fix up the issue by populating the interrupt resources at the driver probe
time instead.

Note that at least currently we cannot dynamically allocate the resources as bus
specific code may add legacy resources with platform_device_add_resources()
before the driver probe. At least omap_device_alloc() currently relies on
num_resources to determine if legacy resources should be added. Some of these
will clear automatically when mach-omap2 boots with DT only, but there are
probably other places too where platform_device_add_resources() modifies
things before driver probe.

This patch was discussed quite a bit earlier, but so far it seems we don't
have any better options to fix the problem. For the earlier discussion,
please see:

https://lkml.org/lkml/2013/11/22/520

The addition of of_platform_probe() is based on patches posted earlier by
Thierry Reding <thierry.reding@gmail.com>.

Signed-off-by: Tony Lindgren <tony@atomide.com>

---

Greg, this is still broken, can you please pick this up?

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -483,6 +483,10 @@ static int platform_drv_probe(struct device *_dev)
 
 	acpi_dev_pm_attach(_dev, true);
 
+	ret = of_platform_probe(dev);
+	if (ret)
+		return ret;
+
 	ret = drv->probe(dev);
 	if (ret)
 		acpi_dev_pm_detach(_dev, true);
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -141,7 +141,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
 				  struct device *parent)
 {
 	struct platform_device *dev;
-	int rc, i, num_reg = 0, num_irq;
+	int num_reg = 0, num_irq;
 	struct resource *res, temp_res;
 
 	dev = platform_device_alloc("", -1);
@@ -154,7 +154,14 @@ struct platform_device *of_device_alloc(struct device_node *np,
 			num_reg++;
 	num_irq = of_irq_count(np);
 
-	/* Populate the resource table */
+	/*
+	 * Only allocate the resources for us to use later on. Note that bus
+	 * specific code may also add in additional legacy resources using
+	 * platform_device_add_resources(), and may even rely on us allocating
+	 * the basic resources here to do so. So we cannot allocate the
+	 * resources lazily until the legacy code has been fixed to not rely
+	 * on allocating resources here.
+	 */
 	if (num_irq || num_reg) {
 		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
 		if (!res) {
@@ -164,11 +171,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
 
 		dev->num_resources = num_reg + num_irq;
 		dev->resource = res;
-		for (i = 0; i < num_reg; i++, res++) {
-			rc = of_address_to_resource(np, i, res);
-			WARN_ON(rc);
-		}
-		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+		/* See of_device_resource_populate for populating the data */
 	}
 
 	dev->dev.of_node = of_node_get(np);
@@ -187,6 +190,50 @@ struct platform_device *of_device_alloc(struct device_node *np,
 EXPORT_SYMBOL(of_device_alloc);
 
 /**
+ * of_device_resource_populate - Populate device resources from device tree
+ * @dev: pointer to platform device
+ *
+ * The device interrupts are not necessarily available for all
+ * irqdomains initially so we need to populate them lazily at
+ * device probe time from of_platform_populate.
+ */
+static int of_device_resource_populate(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	int rc, i, num_reg = 0, num_irq;
+	struct resource *res, temp_res;
+
+	res = pdev->resource;
+
+	/*
+	 * Count the io and irq resources again. Currently we cannot rely on
+	 * pdev->num_resources as bus specific code may have changed that
+	 * with platform_device_add_resources(). But the resources we allocated
+	 * earlier are still there and available for us to populate.
+	 */
+	if (of_can_translate_address(np))
+		while (of_address_to_resource(np, num_reg, &temp_res) == 0)
+			num_reg++;
+	num_irq = of_irq_count(np);
+
+	if (pdev->num_resources < num_reg + num_irq) {
+		dev_WARN(&pdev->dev, "not enough resources %i < %i\n",
+			 pdev->num_resources, num_reg + num_irq);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_reg; i++, res++) {
+		rc = of_address_to_resource(np, i, res);
+		WARN_ON(rc);
+	}
+
+	if (num_irq)
+		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+
+	return 0;
+}
+
+/**
  * of_platform_device_create_pdata - Alloc, initialize and register an of_device
  * @np: pointer to node to create device for
  * @bus_id: name to assign device
@@ -485,4 +532,35 @@ int of_platform_populate(struct device_node *root,
 	return rc;
 }
 EXPORT_SYMBOL_GPL(of_platform_populate);
+
+/**
+ * of_platform_probe() - OF specific initialization at probe time
+ * @pdev: pointer to a platform device
+ *
+ * This function is called by the driver core to perform devicetree-specific
+ * setup for a given platform device at probe time. If a device's resources
+ * as specified in the device tree are not available yet, this function can
+ * return -EPROBE_DEFER and cause the device to be probed again later, when
+ * other drivers that potentially provide the missing resources have been
+ * probed in turn.
+ *
+ * Note that because of the above, all code executed by this function must
+ * be prepared to be run multiple times on the same device (i.e. it must be
+ * idempotent).
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int of_platform_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	if (!pdev->dev.of_node)
+		return 0;
+
+	ret = of_device_resource_populate(pdev);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
 #endif /* CONFIG_OF_ADDRESS */
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -72,6 +72,8 @@ extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
 				const struct of_dev_auxdata *lookup,
 				struct device *parent);
+
+extern int of_platform_probe(struct platform_device *pdev);
 #else
 static inline int of_platform_populate(struct device_node *root,
 					const struct of_device_id *matches,
@@ -80,6 +82,11 @@ static inline int of_platform_populate(struct device_node *root,
 {
 	return -ENODEV;
 }
+
+static inline int of_platform_probe(struct platform_device *pdev)
+{
+	return 0;
+}
 #endif
 
 #endif	/* _LINUX_OF_PLATFORM_H */
