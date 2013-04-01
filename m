Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab3DAPkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:40:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58407 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730Ab3DAPkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:40:11 -0400
Date: Mon, 1 Apr 2013 17:40:08 +0200
From: Pavel Machek <pavel@denx.de>
To: sr@denx.de, w.sang@pengutronix.de, magnus.damm@gmail.com,
        hjk@linutronix.de, Greg KH <greg@kroah.com>,
        kernel list <linux-kernel@vger.kernel.org>, dzu@denx.de
Subject: Re: UIO device tree bindings.
Message-ID: <20130401154008.GA20963@amd.pavel.ucw.cz>
References: <20130401142336.GA18034@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401142336.GA18034@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-04-01 16:23:36, Pavel Machek wrote:
> Hi!
> 
> I'd like to get uio device tree bindings to work -- with recent FPGA
> parts it will be important. Latest version I see is 
> 
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-June/073087.html
> 
> ... Is there anything newer?
> 
> I red the discussion, and main problem seems to be the "tell kernel to
> drive this device tree device", right?

So... here's the port to recent kernels. Not for mainline.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/Documentation/devicetree/bindings/uio-generic.txt b/Documentation/devicetree/bindings/uio-generic.txt
new file mode 100644
index 0000000..f3c53fc
--- /dev/null
+++ b/Documentation/devicetree/bindings/uio-generic.txt
@@ -0,0 +1,16 @@
+UIO for custom devices
+
+A device which will be mapped using the UIO subsystem.
+
+Properties:
+ - compatible : should contain the specific model used, followed by
+                "generic-uio".
+ - reg : address range(s) of the device (up to MAX_UIO_MAPS)
+ - interrupts : interrupt of the device
+
+Example:
+        c64fpga at 0 {
+                compatible = "ptx,c64fpga001", "generic-uio";
+                reg = <0x0 0x10000>;
+                interrupts = <0 0 3>;
+        };
diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index e92eeaf..65807a9 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -59,6 +59,12 @@ config UIO_DMEM_GENIRQ
 
 	  If you don't know what to do here, say N.
 
+config UIO_OF_GENIRQ
+	tristate "Userspace I/O device tree driver with generic IRQ handling"
+	depends on UIO_PDRV_GENIRQ && OF
+	help
+	  Device tree wrapper for the above platform driver.
+
 config UIO_AEC
 	tristate "AEC video timestamp device"
 	depends on PCI
diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index b354c53..e1f2c4b 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
 obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
 obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
 obj-$(CONFIG_UIO_DMEM_GENIRQ)	+= uio_dmem_genirq.o
+obj-$(CONFIG_UIO_OF_GENIRQ)	+= uio_of_genirq.o
 obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
 obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
 obj-$(CONFIG_UIO_PCI_GENERIC)	+= uio_pci_generic.o
diff --git a/drivers/uio/uio_of_genirq.c b/drivers/uio/uio_of_genirq.c
new file mode 100644
index 0000000..17e19e5
--- /dev/null
+++ b/drivers/uio/uio_of_genirq.c
@@ -0,0 +1,95 @@
+/*
+ * OF wrapper to make use of the uio_pdrv_genirq-driver.
+ *
+ * Copyright (C) 2009 Wolfram Sang, Pengutronix
+ * Copyright (C) 2013 Pavel Machek, Denx
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/uio_driver.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of.h>
+#include "uio_pdrv_genirq.h"
+
+#define OF_DRIVER_VERSION "1"
+
+static int uio_of_genirq_probe(struct platform_device *op,
+		const struct of_device_id *match)
+{
+	struct uio_info *uioinfo;
+	struct resource resources[MAX_UIO_MAPS];
+	int i, ret;
+
+	uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
+	if (!uioinfo)
+		return -ENOMEM;
+
+	uioinfo->name = op->dev.of_node->name;
+	uioinfo->version = OF_DRIVER_VERSION;
+	uioinfo->irq = irq_of_parse_and_map(op->dev.of_node, 0);
+	if (!uioinfo->irq)
+		uioinfo->irq = UIO_IRQ_NONE;
+
+	for (i = 0; i < MAX_UIO_MAPS; ++i)
+		if (of_address_to_resource(op->dev.of_node, i, &resources[i]))
+			break;
+
+	ret = __uio_pdrv_genirq_probe(&op->dev, uioinfo, &resources, i);
+	if (ret)
+		goto err_cleanup;
+
+	return 0;
+
+err_cleanup:
+	if (uioinfo->irq != UIO_IRQ_NONE)
+		irq_dispose_mapping(uioinfo->irq);
+
+	kfree(uioinfo);
+	return ret;
+}
+
+static int uio_of_genirq_remove(struct platform_device *op)
+{
+	struct uio_pdrv_genirq_platdata *priv = dev_get_drvdata(&op->dev);
+
+	uio_unregister_device(priv->uioinfo);
+
+	if (priv->uioinfo->irq != UIO_IRQ_NONE)
+		irq_dispose_mapping(priv->uioinfo->irq);
+
+	kfree(priv->uioinfo);
+	kfree(priv);
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static const struct of_device_id const uio_of_genirq_match[] = {
+	{ .compatible = "generic-uio", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
+
+static struct platform_driver uio_of_genirq_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "uio-of-genirq",
+		.of_match_table = uio_of_genirq_match,
+	},
+	.probe = uio_of_genirq_probe,
+	.remove = uio_of_genirq_remove,
+};
+
+module_platform_driver(uio_of_genirq_driver);
+
+MODULE_AUTHOR("Wolfram Sang");
+MODULE_DESCRIPTION("Userspace I/O OF driver with generic IRQ handling");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index c122bca..4a50ead 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -9,6 +9,9 @@
  * Copyright (C) 2008 by Digi International Inc.
  * All rights reserved.
  *
+ * Copyright (C) 2009 Wolfram Sang, Pengutronix
+ * Copyright (C) 2013 Pavel Machek, Denx
+ * 
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published by
  * the Free Software Foundation.
@@ -27,22 +30,16 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/of_address.h>
+#include "uio_pdrv_genirq.h"
 
 #define DRIVER_NAME "uio_pdrv_genirq"
 
-struct uio_pdrv_genirq_platdata {
-	struct uio_info *uioinfo;
-	spinlock_t lock;
-	unsigned long flags;
-	struct platform_device *pdev;
-};
-
 static int uio_pdrv_genirq_open(struct uio_info *info, struct inode *inode)
 {
 	struct uio_pdrv_genirq_platdata *priv = info->priv;
 
 	/* Wait until the Runtime PM code has woken up the device */
-	pm_runtime_get_sync(&priv->pdev->dev);
+	pm_runtime_get_sync(priv->dev);
 	return 0;
 }
 
@@ -51,7 +48,7 @@ static int uio_pdrv_genirq_release(struct uio_info *info, struct inode *inode)
 	struct uio_pdrv_genirq_platdata *priv = info->priv;
 
 	/* Tell the Runtime PM code that the device has become idle */
-	pm_runtime_put_sync(&priv->pdev->dev);
+	pm_runtime_put_sync(priv->dev);
 	return 0;
 }
 
@@ -94,76 +91,34 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 	return 0;
 }
 
-static int uio_pdrv_genirq_probe(struct platform_device *pdev)
+int __uio_pdrv_genirq_probe(struct device *dev, struct uio_info *uioinfo,
+			    struct resource *resources, unsigned int num_resources)
 {
-	struct uio_info *uioinfo = pdev->dev.platform_data;
 	struct uio_pdrv_genirq_platdata *priv;
 	struct uio_mem *uiomem;
-	int ret = -EINVAL;
+	int ret;
 	int i;
 
-	if (pdev->dev.of_node) {
-		int irq;
-
-		/* alloc uioinfo for one device */
-		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
-		if (!uioinfo) {
-			ret = -ENOMEM;
-			dev_err(&pdev->dev, "unable to kmalloc\n");
-			goto bad2;
-		}
-		uioinfo->name = pdev->dev.of_node->name;
-		uioinfo->version = "devicetree";
-
-		/* Multiple IRQs are not supported */
-		irq = platform_get_irq(pdev, 0);
-		if (irq == -ENXIO)
-			uioinfo->irq = UIO_IRQ_NONE;
-		else
-			uioinfo->irq = irq;
-	}
-
-	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
-		dev_err(&pdev->dev, "missing platform_data\n");
-		goto bad0;
-	}
-
-	if (uioinfo->handler || uioinfo->irqcontrol ||
-	    uioinfo->irq_flags & IRQF_SHARED) {
-		dev_err(&pdev->dev, "interrupt configuration error\n");
-		goto bad0;
-	}
-
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
-		ret = -ENOMEM;
-		dev_err(&pdev->dev, "unable to kmalloc\n");
-		goto bad0;
+		dev_err(dev, "unable to kmalloc\n");
+		return -ENOMEM;
 	}
 
 	priv->uioinfo = uioinfo;
 	spin_lock_init(&priv->lock);
 	priv->flags = 0; /* interrupt is enabled to begin with */
-	priv->pdev = pdev;
+	priv->dev = dev;
 
-	if (!uioinfo->irq) {
-		ret = platform_get_irq(pdev, 0);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "failed to get IRQ\n");
-			goto bad0;
-		}
-		uioinfo->irq = ret;
-	}
 	uiomem = &uioinfo->mem[0];
-
-	for (i = 0; i < pdev->num_resources; ++i) {
-		struct resource *r = &pdev->resource[i];
+	for (i = 0; i < num_resources; ++i) {
+		struct resource *r = resources + i;
 
 		if (r->flags != IORESOURCE_MEM)
 			continue;
 
 		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
-			dev_warn(&pdev->dev, "device has more than "
+			dev_warn(dev, "device has more than "
 					__stringify(MAX_UIO_MAPS)
 					" I/O memory resources.\n");
 			break;
@@ -201,19 +156,71 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	 * turned off by default. The Runtime PM bus code should power on the
 	 * hardware and enable clocks at open().
 	 */
-	pm_runtime_enable(&pdev->dev);
+	pm_runtime_enable(dev);
 
-	ret = uio_register_device(&pdev->dev, priv->uioinfo);
+	ret = uio_register_device(dev, priv->uioinfo);
 	if (ret) {
-		dev_err(&pdev->dev, "unable to register uio device\n");
-		goto bad1;
+		dev_err(dev, "unable to register uio device\n");
+		kfree(priv);
+		pm_runtime_disable(dev);
+		return ret;
 	}
 
-	platform_set_drvdata(pdev, priv);
+	dev_set_drvdata(dev, priv);
 	return 0;
- bad1:
-	kfree(priv);
-	pm_runtime_disable(&pdev->dev);
+}
+
+EXPORT_SYMBOL_GPL(__uio_pdrv_genirq_probe);
+
+static int uio_pdrv_genirq_probe(struct platform_device *pdev)
+{
+	struct uio_info *uioinfo = NULL;
+	int ret = 0;
+
+	if (pdev->dev.of_node) {
+		int irq;
+
+		/* alloc uioinfo for one device */
+		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
+		if (!uioinfo) {
+			ret = -ENOMEM;
+			dev_err(&pdev->dev, "unable to kmalloc\n");
+			goto bad2;
+		}
+		uioinfo->name = pdev->dev.of_node->name;
+		uioinfo->version = "devicetree";
+
+		/* Multiple IRQs are not supported */
+		irq = platform_get_irq(pdev, 0);
+		if (irq == -ENXIO)
+			uioinfo->irq = UIO_IRQ_NONE;
+		else
+			uioinfo->irq = irq;
+	}
+
+	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
+		dev_err(&pdev->dev, "missing platform_data\n");
+		goto bad0;
+	}
+
+	if (uioinfo->handler || uioinfo->irqcontrol ||
+	    uioinfo->irq_flags & IRQF_SHARED) {
+		dev_err(&pdev->dev, "interrupt configuration error\n");
+		goto bad0;
+	}
+
+	if (!uioinfo->irq) {
+		ret = platform_get_irq(pdev, 0);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to get IRQ\n");
+			goto bad0;
+		}
+		uioinfo->irq = ret;
+	}
+
+	return __uio_pdrv_genirq_probe(&pdev->dev, uioinfo, pdev->resource,
+				       pdev->num_resources);
+
  bad0:
 	/* kfree uioinfo for OF */
 	if (pdev->dev.of_node)
diff --git a/drivers/uio/uio_pdrv_genirq.h b/drivers/uio/uio_pdrv_genirq.h
new file mode 100644
index 0000000..d5a7c60
--- /dev/null
+++ b/drivers/uio/uio_pdrv_genirq.h
@@ -0,0 +1,14 @@
+#ifndef _LINUX_UIO_PDRV_GENIRQ_H
+#define _LINUX_UIO_PDRV_GENIRQ_H
+
+struct uio_pdrv_genirq_platdata {
+	struct uio_info *uioinfo;
+	spinlock_t lock;
+	unsigned long flags;
+	struct device *dev;
+};
+
+extern int __uio_pdrv_genirq_probe(struct device *dev, struct uio_info *uioinfo,
+	struct resource *resources, unsigned int num_resources);
+
+#endif
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 3863a4d..77a26e4 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -60,13 +60,13 @@ struct of_dev_auxdata {
  */
 struct of_platform_driver
 {
-	int	(*probe)(struct platform_device* dev,
+	int	(*probe)(struct platform_device *dev,
 			 const struct of_device_id *match);
-	int	(*remove)(struct platform_device* dev);
+	int	(*remove)(struct platform_device *dev);
 
-	int	(*suspend)(struct platform_device* dev, pm_message_t state);
-	int	(*resume)(struct platform_device* dev);
-	int	(*shutdown)(struct platform_device* dev);
+	int	(*suspend)(struct platform_device *dev, pm_message_t state);
+	int	(*resume)(struct platform_device *dev);
+	int	(*shutdown)(struct platform_device *dev);
 
 	struct device_driver	driver;
 };


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
