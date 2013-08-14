Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab3HNTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:09:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34987 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab3HNTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:09:25 -0400
From: Kumar Gala <galak@codeaurora.org>
To: ohad@wizery.com, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Subject: [PATCH v3] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex block
Date: Wed, 14 Aug 2013 14:09:21 -0500
Message-Id: <1376507361-26907-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for Qualcomm MSM Hardware Mutex block that exists on newer MSM
SoC (MSM8974, etc).

CC: Jeffrey Hugo <jhugo@codeaurora.org>
CC: Eric Holmberg <eholmber@codeaurora.org>
Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
v3:
* moved dt binding into hwlock/
* removed smp_mb() as they were not needed
* cleanup warning

v2:
* Fixed init of stride
* Dealt with a number of comments from Stephen Boyd:
 - use of <linux/io.h> instead of <asm/io.h>
 - declaring msm_hwspinlock_of_match once & as const
 - drop unneccessary () in an if statement
 - style cleanup to have devm_kzalloc on one line

 .../devicetree/bindings/hwlock/msm-tcsr-mutex.txt  |  20 +++
 drivers/hwspinlock/Kconfig                         |  11 ++
 drivers/hwspinlock/Makefile                        |   1 +
 drivers/hwspinlock/msm_hwspinlock.c                | 149 +++++++++++++++++++++
 4 files changed, 181 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwlock/msm-tcsr-mutex.txt
 create mode 100644 drivers/hwspinlock/msm_hwspinlock.c

diff --git a/Documentation/devicetree/bindings/hwlock/msm-tcsr-mutex.txt b/Documentation/devicetree/bindings/hwlock/msm-tcsr-mutex.txt
new file mode 100644
index 0000000..56740a3
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwlock/msm-tcsr-mutex.txt
@@ -0,0 +1,20 @@
+Qualcomm MSM Hardware Mutex Block:
+
+The hardware block provides mutexes utilized between different processors
+on the SoC as part of the communication protocol used by these processors.
+
+Required properties:
+- compatible: should be "qcom,tcsr-mutex"
+- reg: Should contain registers location and length of mutex registers
+- reg-names:
+	"mutex-base"  - string to identify mutex registers
+- qcom,num-locks: the number of locks/mutexes supported
+
+Example:
+
+	hwlock@fd484000 {
+		compatible = "qcom,tcsr-mutex";
+		reg = <0xfd484000 0x1000>;
+		reg-names = "mutex-base";
+		qcom,num-locks = <32>;
+	};
diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
index 70637d2..192e939 100644
--- a/drivers/hwspinlock/Kconfig
+++ b/drivers/hwspinlock/Kconfig
@@ -8,6 +8,17 @@ config HWSPINLOCK
 
 menu "Hardware Spinlock drivers"
 
+config HWSPINLOCK_MSM
+	tristate "MSM Hardware Spinlock device"
+	depends on ARCH_MSM
+	select HWSPINLOCK
+	help
+	  Say y here to support the MSM Hardware Mutex functionality, which
+	  provides a synchronisation mechanism for the various processors on
+	  the SoC.
+
+	  If unsure, say N.
+
 config HWSPINLOCK_OMAP
 	tristate "OMAP Hardware Spinlock device"
 	depends on ARCH_OMAP4 || SOC_OMAP5
diff --git a/drivers/hwspinlock/Makefile b/drivers/hwspinlock/Makefile
index 93eb64b..4074c56 100644
--- a/drivers/hwspinlock/Makefile
+++ b/drivers/hwspinlock/Makefile
@@ -3,5 +3,6 @@
 #
 
 obj-$(CONFIG_HWSPINLOCK)		+= hwspinlock_core.o
+obj-$(CONFIG_HWSPINLOCK_MSM)		+= msm_hwspinlock.o
 obj-$(CONFIG_HWSPINLOCK_OMAP)		+= omap_hwspinlock.o
 obj-$(CONFIG_HSEM_U8500)		+= u8500_hsem.o
diff --git a/drivers/hwspinlock/msm_hwspinlock.c b/drivers/hwspinlock/msm_hwspinlock.c
new file mode 100644
index 0000000..6fa018e
--- /dev/null
+++ b/drivers/hwspinlock/msm_hwspinlock.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/hwspinlock.h>
+#include <linux/io.h>
+
+#include "hwspinlock_internal.h"
+
+#define SPINLOCK_ID_APPS_PROC	1
+#define BASE_ID			0
+
+static int msm_hwspinlock_trylock(struct hwspinlock *lock)
+{
+	void __iomem *lock_addr = lock->priv;
+
+	writel_relaxed(SPINLOCK_ID_APPS_PROC, lock_addr);
+
+	return readl_relaxed(lock_addr) == SPINLOCK_ID_APPS_PROC;
+}
+
+static void msm_hwspinlock_unlock(struct hwspinlock *lock)
+{
+	u32 lock_owner;
+	void __iomem *lock_addr = lock->priv;
+
+	lock_owner = readl_relaxed(lock_addr);
+	if (lock_owner != SPINLOCK_ID_APPS_PROC) {
+		pr_err("%s: spinlock not owned by us (actual owner is %d)\n",
+				__func__, lock_owner);
+	}
+
+	writel_relaxed(0, lock_addr);
+}
+
+static const struct hwspinlock_ops msm_hwspinlock_ops = {
+	.trylock	= msm_hwspinlock_trylock,
+	.unlock		= msm_hwspinlock_unlock,
+};
+
+static const struct of_device_id msm_hwspinlock_of_match[] = {
+	{
+		.compatible = "qcom,tcsr-mutex",
+		.data = (void *)0x80, /* register stride */
+	},
+	{ },
+};
+
+static int msm_hwspinlock_probe(struct platform_device *pdev)
+{
+	int ret, i, stride;
+	size_t array_size;
+	u32 num_locks;
+	struct hwspinlock_device *bank;
+	struct hwspinlock *hwlock;
+	struct resource *res;
+	void __iomem *iobase;
+	struct device_node *node = pdev->dev.of_node;
+	const struct of_device_id *match;
+
+	match = of_match_device(msm_hwspinlock_of_match, &pdev->dev);
+	if (!match)
+		return -EINVAL;
+
+	ret = of_property_read_u32(node, "qcom,num-locks", &num_locks);
+	if (ret || num_locks == 0)
+		return -ENODEV;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mutex-base");
+	iobase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(iobase))
+		return PTR_ERR(iobase);
+
+	array_size = num_locks * sizeof(*hwlock);
+	bank = devm_kzalloc(&pdev->dev, sizeof(*bank) + array_size, GFP_KERNEL);
+	if (!bank)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, bank);
+
+	stride = (int)match->data;
+	for (i = 0, hwlock = &bank->lock[0]; i < num_locks; i++, hwlock++)
+		hwlock->priv = iobase + i * stride;
+
+	ret = hwspin_lock_register(bank, &pdev->dev, &msm_hwspinlock_ops,
+						BASE_ID, num_locks);
+	return ret;
+}
+
+static int msm_hwspinlock_remove(struct platform_device *pdev)
+{
+	struct hwspinlock_device *bank = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = hwspin_lock_unregister(bank);
+	if (ret) {
+		dev_err(&pdev->dev, "%s failed: %d\n", __func__, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct platform_driver msm_hwspinlock_driver = {
+	.probe		= msm_hwspinlock_probe,
+	.remove		= msm_hwspinlock_remove,
+	.driver		= {
+		.name	= "msm_hwspinlock",
+		.owner	= THIS_MODULE,
+		.of_match_table = msm_hwspinlock_of_match,
+	},
+};
+
+static int __init msm_hwspinlock_init(void)
+{
+	return platform_driver_register(&msm_hwspinlock_driver);
+}
+/* board init code might need to reserve hwspinlocks for predefined purposes */
+postcore_initcall(msm_hwspinlock_init);
+
+static void __exit msm_hwspinlock_exit(void)
+{
+	platform_driver_unregister(&msm_hwspinlock_driver);
+}
+module_exit(msm_hwspinlock_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Hardware spinlock driver for MSM");
+MODULE_AUTHOR("Kumar Gala <galak@codeaurora.org>");
+MODULE_AUTHOR("Jeffrey Hugo <jhugo@codeaurora.org>");
+MODULE_AUTHOR("Eric Holmberg <eholmber@codeaurora.org>");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

