Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab3FDO0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:26:46 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56098 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3FDO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:26:43 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, guodong.xu@linaro.org,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH 1/3] mfd: Add hi6421 PMIC core driver
Date: Tue,  4 Jun 2013 22:28:41 +0800
Message-Id: <1370356123-22357-2-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1370356123-22357-1-git-send-email-guodong.xu@linaro.org>
References: <1370356123-22357-1-git-send-email-guodong.xu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds driver to support HiSilicon Hi6421 PMIC. Hi6421 includes multi-
functions, such as regulators, codec, ADCs, Coulomb counter, etc.
This driver includes core APIs _only_.

Drivers for individul components, like voltage regulators, are
implemented in corresponding driver directories and files.

Memory-mapped I/O is the way to communicate with Hi6421.

Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
---
 drivers/mfd/Kconfig             |   11 +++
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/hi6421-pmic-core.c  |  171 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/hi6421-pmic.h |   55 +++++++++++++
 4 files changed, 238 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/hi6421-pmic-core.c
 create mode 100644 include/linux/mfd/hi6421-pmic.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d54e985..111c109 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1116,6 +1116,17 @@ config MFD_WM8994
 	  core support for the WM8994, in order to use the actual
 	  functionaltiy of the device other drivers must be enabled.
 
+config MFD_HI6421_PMIC
+	tristate "HiSilicon Hi6421 PMU/Codec IC"
+	depends on OF
+	help
+	  This driver supports HiSilicon Hi6421 PMIC. Hi6421 includes multi-
+	  functions, such as regulators, codec, ADCs, Coulomb counter, etc.
+	  This driver includes core APIs _only_. You have to select
+	  individul components like voltage regulators under corresponding
+	  menus in order to enable them.
+	  Memory-mapped I/O is the way to communicate with Hi6421.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 718e94a..58cda25 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -155,3 +155,4 @@ obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o vexpress-sysreg.o
 obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
+obj-$(CONFIG_MFD_HI6421_PMIC)	+= hi6421-pmic-core.o
diff --git a/drivers/mfd/hi6421-pmic-core.c b/drivers/mfd/hi6421-pmic-core.c
new file mode 100644
index 0000000..3bf8c43
--- /dev/null
+++ b/drivers/mfd/hi6421-pmic-core.c
@@ -0,0 +1,171 @@
+/*
+ * Device driver for Hi6421 IC
+ *
+ * Copyright (c) <2011-2013> HiSilicon Technologies Co., Ltd.
+ *              http://www.hisilicon.com
+ * Copyright (c) <2011-2013> Linaro Ltd.
+ *              http://www.linaro.org
+ *
+ * Author: Guodong Xu <guodong.xu@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/mfd/hi6421-pmic.h>
+
+static struct of_device_id of_hi6421_pmic_child_match_tbl[] = {
+	/* regulators */
+	{
+		.compatible = "hisilicon,hi6421-ldo",
+	},
+	{
+		.compatible = "hisilicon,hi6421-buck012",
+	},
+	{
+		.compatible = "hisilicon,hi6421-buck345",
+	},
+	{ /* end */ }
+};
+
+static struct of_device_id of_hi6421_pmic_match_tbl[] = {
+	{
+		.compatible = "hisilicon,hi6421-pmic",
+	},
+	{ /* end */ }
+};
+
+/*
+ * The PMIC register is only 8-bit.
+ * Hisilicon SoC use hardware to map PMIC register into SoC mapping.
+ * At here, we are accessing SoC register with 32-bit.
+ */
+u32 hi6421_pmic_read(struct hi6421_pmic *pmic, int reg)
+{
+	unsigned long flags;
+	u32 ret;
+	spin_lock_irqsave(&pmic->lock, flags);
+	ret = readl_relaxed(pmic->regs + (reg << 2));
+	spin_unlock_irqrestore(&pmic->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(hi6421_pmic_read);
+
+void hi6421_pmic_write(struct hi6421_pmic *pmic, int reg, u32 val)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&pmic->lock, flags);
+	writel_relaxed(val, pmic->regs + (reg << 2));
+	spin_unlock_irqrestore(&pmic->lock, flags);
+}
+EXPORT_SYMBOL(hi6421_pmic_write);
+
+void hi6421_pmic_rmw(struct hi6421_pmic *pmic, int reg,
+		     u32 mask, u32 bits)
+{
+	u32 data;
+
+	spin_lock(&pmic->lock);
+	data = readl_relaxed(pmic->regs + (reg << 2)) & ~mask;
+	data |= mask & bits;
+	writel_relaxed(data, pmic->regs + (reg << 2));
+	spin_unlock(&pmic->lock);
+}
+EXPORT_SYMBOL(hi6421_pmic_rmw);
+
+static int hi6421_pmic_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct hi6421_pmic *pmic = NULL;
+
+	pmic = devm_kzalloc(dev, sizeof(*pmic), GFP_KERNEL);
+	if (!pmic) {
+		dev_err(dev, "cannot allocate hi6421_pmic device info\n");
+		return -ENOMEM;
+	}
+
+	/* get resources */
+	pmic->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!pmic->res) {
+		dev_err(dev, "platform_get_resource err\n");
+		return -ENOENT;
+	}
+
+	if (!devm_request_mem_region(dev, pmic->res->start,
+				     resource_size(pmic->res),
+				     pdev->name)) {
+		dev_err(dev, "cannot claim register memory\n");
+		return -ENOMEM;
+	}
+
+	pmic->regs = devm_ioremap(dev, pmic->res->start,
+				  resource_size(pmic->res));
+	if (!pmic->regs) {
+		dev_err(dev, "cannot map register memory\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, pmic);
+
+	spin_lock_init(&pmic->lock);
+
+	/* set over-current protection debounce 8ms*/
+	hi6421_pmic_rmw(pmic, OCP_DEB_CTRL_REG,
+		OCP_DEB_SEL_MASK | OCP_EN_DEBOUNCE_MASK | OCP_AUTO_STOP_MASK,
+		OCP_DEB_SEL_8MS | OCP_EN_DEBOUNCE_ENABLE);
+
+	/* populate sub nodes */
+	of_platform_populate(np, of_hi6421_pmic_child_match_tbl, NULL, dev);
+
+	return 0;
+}
+
+static int hi6421_pmic_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct hi6421_pmic *pmic = platform_get_drvdata(pdev);
+
+	devm_iounmap(dev, pmic->regs);
+	devm_release_mem_region(dev, pmic->res->start,
+				resource_size(pmic->res));
+	devm_kfree(dev, pmic);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver hi6421_pmic_driver = {
+	.driver = {
+		.name	= "hi6421_pmic",
+		.owner  = THIS_MODULE,
+		.of_match_table = of_hi6421_pmic_match_tbl,
+	},
+	.probe	= hi6421_pmic_probe,
+	.remove	= hi6421_pmic_remove,
+};
+module_platform_driver(hi6421_pmic_driver);
+
+MODULE_AUTHOR("Guodong Xu <guodong.xu@linaro.org>");
+MODULE_DESCRIPTION("Hi6421 PMIC driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/hi6421-pmic.h b/include/linux/mfd/hi6421-pmic.h
new file mode 100644
index 0000000..2df16ba
--- /dev/null
+++ b/include/linux/mfd/hi6421-pmic.h
@@ -0,0 +1,55 @@
+/*
+ * Header file for device driver Hi6421 PMIC
+ *
+ * Copyright (c) <2011-2013> HiSilicon Technologies Co., Ltd.
+ *              http://www.hisilicon.com
+ * Copyright (c) <2011-2013> Linaro Ltd.
+ *              http://www.linaro.org
+ *
+ * Author: Guodong Xu <guodong.xu@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef	__HI6421_PMIC_H
+#define	__HI6421_PMIC_H
+
+#define	OCP_DEB_CTRL_REG		(0x51)
+#define	OCP_DEB_SEL_MASK		(0x0C)
+#define OCP_DEB_SEL_8MS			(0x00)
+#define OCP_DEB_SEL_16MS		(0x04)
+#define OCP_DEB_SEL_32MS		(0x08)
+#define OCP_DEB_SEL_64MS		(0x0C)
+#define OCP_EN_DEBOUNCE_MASK		(0x02)
+#define OCP_EN_DEBOUNCE_ENABLE		(0x02)
+#define OCP_AUTO_STOP_MASK		(0x01)
+#define OCP_AUTO_STOP_ENABLE		(0x01)
+#define HI6421_REGS_ENA_PROTECT_TIME	(100)	/* in microseconds */
+#define HI6421_ECO_MODE_ENABLE		(1)
+#define HI6421_ECO_MODE_DISABLE		(0)
+
+struct hi6421_pmic {
+	struct resource		*res;
+	struct device		*dev;
+	void __iomem		*regs;
+	spinlock_t		lock;
+};
+
+/* Register Access Helpers */
+u32 hi6421_pmic_read(struct hi6421_pmic *pmic, int reg);
+void hi6421_pmic_write(struct hi6421_pmic *pmic, int reg, u32 val);
+void hi6421_pmic_rmw(struct hi6421_pmic *pmic, int reg, u32 mask, u32 bits);
+
+#endif		/* __HI6421_PMIC_H */
-- 
1.7.4.1

