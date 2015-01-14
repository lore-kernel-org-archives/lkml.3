Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbbANU7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:59:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42366 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbbANU65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:58:57 -0500
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Bjorn Andersson <bjorn@kryo.se>, Josh Cartwright <joshc@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH v7 4/4] hwspinlock/omap: add support for dt nodes
Date: Wed, 14 Jan 2015 14:58:21 -0600
Message-ID: <1421269101-51105-5-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421269101-51105-1-git-send-email-s-anna@ti.com>
References: <1421269101-51105-1-git-send-email-s-anna@ti.com>
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
[tony@atomide.com: ack for legacy file removal]
Acked-by: Tony Lindgren <tony@atomide.com>
---
v7: hwlock-base-id is no longer optional, probe will fail now
    if property is absent.

 MAINTAINERS                          |  1 -
 arch/arm/mach-omap2/Makefile         |  3 --
 arch/arm/mach-omap2/hwspinlock.c     | 60 ------------------------------------
 drivers/hwspinlock/omap_hwspinlock.c | 22 ++++++++++---
 4 files changed, 17 insertions(+), 69 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/hwspinlock.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8d32b3..3de03037e90a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6861,7 +6861,6 @@ M:	Ohad Ben-Cohen <ohad@wizery.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/hwspinlock/omap_hwspinlock.c
-F:	arch/arm/mach-omap2/hwspinlock.c
 
 OMAP MMC SUPPORT
 M:	Jarkko Lavinen <jarkko.lavinen@nokia.com>
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 5d27dfdef66b..6fa36846d5b4 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -282,9 +282,6 @@ obj-y					+= $(nand-m) $(nand-y)
 
 smsc911x-$(CONFIG_SMSC911X)		:= gpmc-smsc911x.o
 obj-y					+= $(smsc911x-m) $(smsc911x-y)
-ifneq ($(CONFIG_HWSPINLOCK_OMAP),)
-obj-y					+= hwspinlock.o
-endif
 
 emac-$(CONFIG_TI_DAVINCI_EMAC)		:= am35xx-emac.o
 obj-y					+= $(emac-m) $(emac-y)
diff --git a/arch/arm/mach-omap2/hwspinlock.c b/arch/arm/mach-omap2/hwspinlock.c
deleted file mode 100644
index ef175acaeaa2..000000000000
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
index 47a275c6ece1..18edb3b4ab32 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -1,7 +1,7 @@
 /*
  * OMAP hardware spinlock driver
  *
- * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com
+ * Copyright (C) 2010-2015 Texas Instruments Incorporated - http://www.ti.com
  *
  * Contact: Simon Que <sque@ti.com>
  *          Hari Kanigeri <h-kanigeri2@ti.com>
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/hwspinlock.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 
 #include "hwspinlock_internal.h"
@@ -80,16 +81,20 @@ static const struct hwspinlock_ops omap_hwspinlock_ops = {
 
 static int omap_hwspinlock_probe(struct platform_device *pdev)
 {
-	struct hwspinlock_pdata *pdata = pdev->dev.platform_data;
+	struct device_node *node = pdev->dev.of_node;
 	struct hwspinlock_device *bank;
 	struct hwspinlock *hwlock;
 	struct resource *res;
 	void __iomem *io_base;
-	int num_locks, i, ret;
+	int num_locks, i, ret, base_id;
 
-	if (!pdata)
+	if (!node)
 		return -ENODEV;
 
+	base_id = of_hwspin_lock_get_base_id(node);
+	if (base_id < 0)
+		return base_id;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
@@ -141,7 +146,7 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 		hwlock->priv = io_base + LOCK_BASE_OFFSET + sizeof(u32) * i;
 
 	ret = hwspin_lock_register(bank, &pdev->dev, &omap_hwspinlock_ops,
-						pdata->base_id, num_locks);
+						base_id, num_locks);
 	if (ret)
 		goto reg_fail;
 
@@ -174,11 +179,18 @@ static int omap_hwspinlock_remove(struct platform_device *pdev)
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
+		.of_match_table = of_match_ptr(omap_hwspinlock_of_match),
 	},
 };
 
-- 
2.2.1

