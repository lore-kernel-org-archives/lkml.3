Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3IQTb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:31:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43791 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab3IQTb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:31:26 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv2 2/9] hwspinlock/omap: add support for dt nodes
Date: Tue, 17 Sep 2013 14:30:56 -0500
Message-ID: <0fd6a11880894260d627a50b1e35f363625e9b1d.1379445653.git.s-anna@ti.com>
X-Mailer: git-send-email 1.8.3.3
In-Reply-To: <cover.1379445653.git.s-anna@ti.com>
References: <cover.1379445653.git.s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HwSpinlock IP is present only on OMAP4 and other newer SoCs,
which are all device-tree boot only. This patch adds the
base support for parsing the DT nodes, and removes the code
dealing with the traditional platform device instantiation.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 31 +++++++++++
 arch/arm/mach-omap2/Makefile                       |  3 --
 arch/arm/mach-omap2/hwspinlock.c                   | 60 ----------------------
 drivers/hwspinlock/omap_hwspinlock.c               | 23 +++++++--
 4 files changed, 50 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
 delete mode 100644 arch/arm/mach-omap2/hwspinlock.c

diff --git a/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
new file mode 100644
index 0000000..235b7c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
@@ -0,0 +1,31 @@
+OMAP4+ HwSpinlock Driver
+========================
+
+Required properties:
+- compatible:		Currently supports only "ti,omap4-hwspinlock" for
+				OMAP44xx, OMAP54xx, AM33xx, AM43xx, DRA7xx SoCs
+- reg:			Contains the hwspinlock register address range (base
+			address and length)
+- ti,hwmods:		Name of the hwmod associated with the hwspinlock device
+
+Common hwlock properties:
+The following describes the usage of the common hwlock properties (defined in
+Documentation/devicetree/bindings/hwlock/hwlock.txt) on OMAP.
+
+- hwlock-base-id:	There are currently no OMAP SoCs with multiple
+			hwspinlock devices. The OMAP driver uses a default
+			base id value of 0 for the locks present within the
+			single hwspinlock device on all SoCs.
+- hwlock-num-locks:	This property is not required on OMAP SoCs, since the
+			number of locks present within a device can be deduced
+			from the SPINLOCK_SYSSTATUS device register.
+
+
+Example:
+
+/* OMAP4 */
+hwspinlock: spinlock@4a0f6000 {
+	compatible = "ti,omap4-hwspinlock";
+	reg = <0x4a0f6000 0x1000>;
+	ti,hwmods = "spinlock";
+};
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index afb457c..960cf45 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -298,9 +298,6 @@ obj-y					+= $(smc91x-m) $(smc91x-y)
 
 smsc911x-$(CONFIG_SMSC911X)		:= gpmc-smsc911x.o
 obj-y					+= $(smsc911x-m) $(smsc911x-y)
-ifneq ($(CONFIG_HWSPINLOCK_OMAP),)
-obj-y					+= hwspinlock.o
-endif
 
 emac-$(CONFIG_TI_DAVINCI_EMAC)		:= am35xx-emac.o
 obj-y					+= $(emac-m) $(emac-y)
diff --git a/arch/arm/mach-omap2/hwspinlock.c b/arch/arm/mach-omap2/hwspinlock.c
deleted file mode 100644
index ef175ac..0000000
--- a/arch/arm/mach-omap2/hwspinlock.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * OMAP hardware spinlock device initialization
- *
- * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com
- *
- * Contact: Simon Que <sque@ti.com>
- *          Hari Kanigeri <h-kanigeri2@ti.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/err.h>
-#include <linux/hwspinlock.h>
-
-#include "soc.h"
-#include "omap_hwmod.h"
-#include "omap_device.h"
-
-static struct hwspinlock_pdata omap_hwspinlock_pdata __initdata = {
-	.base_id = 0,
-};
-
-static int __init hwspinlocks_init(void)
-{
-	int retval = 0;
-	struct omap_hwmod *oh;
-	struct platform_device *pdev;
-	const char *oh_name = "spinlock";
-	const char *dev_name = "omap_hwspinlock";
-
-	/*
-	 * Hwmod lookup will fail in case our platform doesn't support the
-	 * hardware spinlock module, so it is safe to run this initcall
-	 * on all omaps
-	 */
-	oh = omap_hwmod_lookup(oh_name);
-	if (oh == NULL)
-		return -EINVAL;
-
-	pdev = omap_device_build(dev_name, 0, oh, &omap_hwspinlock_pdata,
-				sizeof(struct hwspinlock_pdata));
-	if (IS_ERR(pdev)) {
-		pr_err("Can't build omap_device for %s:%s\n", dev_name,
-								oh_name);
-		retval = PTR_ERR(pdev);
-	}
-
-	return retval;
-}
-/* early board code might need to reserve specific hwspinlock instances */
-omap_postcore_initcall(hwspinlocks_init);
diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index 292869c..1c99391 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -1,7 +1,7 @@
 /*
  * OMAP hardware spinlock driver
  *
- * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com
+ * Copyright (C) 2010-2013 Texas Instruments Incorporated - http://www.ti.com
  *
  * Contact: Simon Que <sque@ti.com>
  *          Hari Kanigeri <h-kanigeri2@ti.com>
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/hwspinlock.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 #include "hwspinlock_internal.h"
@@ -80,16 +81,23 @@ static const struct hwspinlock_ops omap_hwspinlock_ops = {
 
 static int omap_hwspinlock_probe(struct platform_device *pdev)
 {
-	struct hwspinlock_pdata *pdata = pdev->dev.platform_data;
+	struct device_node *node = pdev->dev.of_node;
 	struct hwspinlock_device *bank;
 	struct hwspinlock *hwlock;
 	struct resource *res;
 	void __iomem *io_base;
 	int num_locks, i, ret;
+	int base_id = 0;
 
-	if (!pdata)
+	if (!node)
 		return -ENODEV;
 
+	ret = of_hwspin_lock_get_base_id(node);
+	if (ret < 0 && ret != -EINVAL)
+		return -ENODEV;
+	else if (!ret)
+		base_id = ret;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
@@ -128,7 +136,7 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	ret = hwspin_lock_register(bank, &pdev->dev, &omap_hwspinlock_ops,
-						pdata->base_id, num_locks);
+						base_id, num_locks);
 	if (ret)
 		goto reg_fail;
 
@@ -161,12 +169,19 @@ static int omap_hwspinlock_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id omap_hwspinlock_of_match[] = {
+	{ .compatible = "ti,omap4-hwspinlock", },
+	{ /* end */ },
+};
+MODULE_DEVICE_TABLE(of, omap_hwspinlock_of_match);
+
 static struct platform_driver omap_hwspinlock_driver = {
 	.probe		= omap_hwspinlock_probe,
 	.remove		= omap_hwspinlock_remove,
 	.driver		= {
 		.name	= "omap_hwspinlock",
 		.owner	= THIS_MODULE,
+		.of_match_table = omap_hwspinlock_of_match,
 	},
 };
 
-- 
1.8.3.3

