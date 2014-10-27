Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaJ0THI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:07:08 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:17226 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbaJ0THE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:07:04 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>, Suman Anna <s-anna@ti.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: [PATCH v5] hwspinlock: qcom: Add support for Qualcomm HW Mutex block
Date: Mon, 27 Oct 2014 12:07:22 -0700
Message-ID: <1414436842-3859-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@codeaurora.org>

Add driver for Qualcomm Hardware Mutex block that exists on newer
Qualcomm SoCs.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
[bjorn: added pm_runtime calls, from Courtney,
	added sfpb-mutex compatible,
	updated DT binding documentation formatting,
	replaced msm prefix with qcom,
	cleaned up includes]
Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

We need this driver to add support for the shared memory manager, so I'm
reviving Kumars patch from a year ago, with some additional sprinkles on top.

Changes since v4:
 - Aligned with devicetree support in hwlock framework and hence depends on [1]

Changes since v3:
 - Reverted back to getting stride from of_match, per Kumars request

Changes since v2:
 - MODULE_DEVICE_TABLE
 - Changed prefix to qcom
 - Cleaned up includes
 - Rely on reg and num-locks to figure out stride, instead of of_match data

Changes since v1:
 - Added the pm_runtime calls needed to be able to boot a kernel with
   pm_runtime and this driver, patch from Courtney.
 - Added sfpb-mutex compatible, for re-use of the driver in family A platforms.
 - Updated formatting of DT binding documentation, while adding the extra
   compatible.
 - Dropped Stephen Boyds Reviewed-by due to these changes.


 [1] https://lkml.org/lkml/2014/9/12/636

 .../devicetree/bindings/hwlock/qcom-hwspinlock.txt |   50 +++++++
 drivers/hwspinlock/Kconfig                         |   11 ++
 drivers/hwspinlock/Makefile                        |    1 +
 drivers/hwspinlock/qcom_hwspinlock.c               |  156 ++++++++++++++++++++
 4 files changed, 218 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
 create mode 100644 drivers/hwspinlock/qcom_hwspinlock.c

diff --git a/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
new file mode 100644
index 0000000..cd2b912
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
@@ -0,0 +1,50 @@
+Qualcomm Hardware Mutex Block:
+
+The hardware block provides mutexes utilized between different processors
+on the SoC as part of the communication protocol used by these processors.
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,sfpb-mutex",
+		    "qcom,tcsr-mutex"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: base address and size of the mutex registers
+
+- reg-names:
+	Usage: required
+	Value type: <string>
+	Definition: must be "mutex-base"
+
+- hwlock-base-id:
+	Usage: optional
+	Value type: <u32>
+	Definition: base id of the hwlock device
+		    (hwlock standard property, see hwlock.txt)
+
+- #hwlock-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: must be 1, the specified cell represent the lock id
+		    (hwlock standard property, see hwlock.txt)
+
+- hwlock-num-locks:
+	Usage: required
+	Value type: <u32>
+	Definition: the number of locks/mutex available in this block
+		    (hwlock standard property, see hwlock.txt)
+
+Example:
+
+	hwlock@fd484000 {
+		compatible = "qcom,tcsr-mutex";
+		reg = <0xfd484000 0x1000>;
+		reg-names = "mutex-base";
+
+		hwlock-num-locks = <8>;
+		#hwlock-cells = <1>;
+	};
diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
index 3612cb5..762216d 100644
--- a/drivers/hwspinlock/Kconfig
+++ b/drivers/hwspinlock/Kconfig
@@ -18,6 +18,17 @@ config HWSPINLOCK_OMAP
 
 	  If unsure, say N.
 
+config HWSPINLOCK_QCOM
+	tristate "Qualcomm Hardware Spinlock device"
+	depends on ARCH_QCOM
+	select HWSPINLOCK
+	help
+	  Say y here to support the Qualcomm Hardware Mutex functionality, which
+	  provides a synchronisation mechanism for the various processors on
+	  the SoC.
+
+	  If unsure, say N.
+
 config HSEM_U8500
 	tristate "STE Hardware Semaphore functionality"
 	depends on ARCH_U8500
diff --git a/drivers/hwspinlock/Makefile b/drivers/hwspinlock/Makefile
index 93eb64b..68f95d9 100644
--- a/drivers/hwspinlock/Makefile
+++ b/drivers/hwspinlock/Makefile
@@ -4,4 +4,5 @@
 
 obj-$(CONFIG_HWSPINLOCK)		+= hwspinlock_core.o
 obj-$(CONFIG_HWSPINLOCK_OMAP)		+= omap_hwspinlock.o
+obj-$(CONFIG_HWSPINLOCK_QCOM)		+= qcom_hwspinlock.o
 obj-$(CONFIG_HSEM_U8500)		+= u8500_hsem.o
diff --git a/drivers/hwspinlock/qcom_hwspinlock.c b/drivers/hwspinlock/qcom_hwspinlock.c
new file mode 100644
index 0000000..93a8a5d
--- /dev/null
+++ b/drivers/hwspinlock/qcom_hwspinlock.c
@@ -0,0 +1,156 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2014, Sony Mobile Communications AB
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
+#include <linux/hwspinlock.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include "hwspinlock_internal.h"
+
+#define SPINLOCK_ID_APPS_PROC	1
+
+static int qcom_hwspinlock_trylock(struct hwspinlock *lock)
+{
+	void __iomem *lock_addr = lock->priv;
+
+	writel_relaxed(SPINLOCK_ID_APPS_PROC, lock_addr);
+
+	return readl_relaxed(lock_addr) == SPINLOCK_ID_APPS_PROC;
+}
+
+static void qcom_hwspinlock_unlock(struct hwspinlock *lock)
+{
+	void __iomem *lock_addr = lock->priv;
+	u32 lock_owner;
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
+static const struct hwspinlock_ops qcom_hwspinlock_ops = {
+	.trylock	= qcom_hwspinlock_trylock,
+	.unlock		= qcom_hwspinlock_unlock,
+};
+
+static const struct of_device_id qcom_hwspinlock_of_match[] = {
+	{ .compatible = "qcom,sfpb-mutex", .data = (void *)0x4 },
+	{ .compatible = "qcom,tcsr-mutex" , .data = (void *)0x80 },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, qcom_hwspinlock_of_match);
+
+static int qcom_hwspinlock_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	const struct of_device_id *match;
+	struct hwspinlock_device *bank;
+	struct hwspinlock *hwlock;
+	struct resource *res;
+	void __iomem *iobase;
+	unsigned stride, i;
+	size_t array_size;
+	int num_locks;
+	int base_id;
+	int ret;
+
+	match = of_match_device(qcom_hwspinlock_of_match, &pdev->dev);
+
+	ret = of_hwspin_lock_get_base_id(node);
+	if (ret < 0 && ret != -EINVAL)
+		return ret;
+	base_id = ret > 0 ? ret : 0;
+
+	num_locks = of_hwspin_lock_get_num_locks(node);
+	if (num_locks < 0)
+		return num_locks;
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
+	stride = (unsigned)match->data;
+	for (i = 0, hwlock = &bank->lock[0]; i < num_locks; i++, hwlock++)
+		hwlock->priv = iobase + i * stride;
+
+	pm_runtime_enable(&pdev->dev);
+
+	ret = hwspin_lock_register(bank, &pdev->dev, &qcom_hwspinlock_ops,
+				   base_id, num_locks);
+	if (ret)
+		pm_runtime_disable(&pdev->dev);
+
+	return ret;
+}
+
+static int qcom_hwspinlock_remove(struct platform_device *pdev)
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
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
+static struct platform_driver qcom_hwspinlock_driver = {
+	.probe		= qcom_hwspinlock_probe,
+	.remove		= qcom_hwspinlock_remove,
+	.driver		= {
+		.name	= "qcom_hwspinlock",
+		.of_match_table = qcom_hwspinlock_of_match,
+	},
+};
+
+static int __init qcom_hwspinlock_init(void)
+{
+	return platform_driver_register(&qcom_hwspinlock_driver);
+}
+/* board init code might need to reserve hwspinlocks for predefined purposes */
+postcore_initcall(qcom_hwspinlock_init);
+
+static void __exit qcom_hwspinlock_exit(void)
+{
+	platform_driver_unregister(&qcom_hwspinlock_driver);
+}
+module_exit(qcom_hwspinlock_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Hardware spinlock driver for Qualcomm SoCs");
+MODULE_AUTHOR("Kumar Gala <galak@codeaurora.org>");
+MODULE_AUTHOR("Jeffrey Hugo <jhugo@codeaurora.org>");
+MODULE_AUTHOR("Eric Holmberg <eholmber@codeaurora.org>");
-- 
1.7.9.5

