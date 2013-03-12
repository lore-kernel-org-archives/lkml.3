Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab3CLSpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:45:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52590 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab3CLSmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:42:07 -0400
X-IronPort-AV: E=Sophos;i="4.84,832,1355126400"; 
   d="scan'208";a="29083614"
From: David Brown <davidb@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 09/11] SSBI: Remove MSM_ prefix from SSBI drivers
Date: Tue, 12 Mar 2013 11:41:54 -0700
Message-Id: <1363113716-25897-10-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363113716-25897-1-git-send-email-davidb@codeaurora.org>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
 <1363113716-25897-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the SSBI sub is currently only used on MSM SoCs, it is still
a bus in its own right.  Remove this msm_ prefix from the driver and
it's symbols.  Clients can now refer directly to ssbi_write() and
ssbi_read().

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/Makefile                     |  2 +-
 drivers/mfd/Kconfig                  |  2 +-
 drivers/mfd/pm8921-core.c            | 14 +++---
 drivers/ssbi/Kconfig                 |  4 +-
 drivers/ssbi/Makefile                |  2 +-
 drivers/ssbi/ssbi.c                  | 86 ++++++++++++++++++------------------
 include/linux/{msm_ssbi.h => ssbi.h} | 18 ++++----
 7 files changed, 64 insertions(+), 64 deletions(-)
 rename include/linux/{msm_ssbi.h => ssbi.h} (67%)

diff --git a/drivers/Makefile b/drivers/Makefile
index 778821b..4865ed2 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -114,7 +114,7 @@ obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
-obj-$(CONFIG_MSM_SSBI)		+= ssbi/
+obj-$(CONFIG_SSBI)		+= ssbi/
 ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 obj-y				+= clocksource/
 endif
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 671f5b1..5bfa7bb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -990,7 +990,7 @@ config MFD_PM8XXX
 
 config MFD_PM8921_CORE
 	tristate "Qualcomm PM8921 PMIC chip"
-	depends on MSM_SSBI
+	depends on SSBI
 	select MFD_CORE
 	select MFD_PM8XXX
 	help
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index d4b297c..ecc137f 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -17,7 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <linux/msm_ssbi.h>
+#include <linux/ssbi.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/pm8xxx/pm8921.h>
 #include <linux/mfd/pm8xxx/core.h>
@@ -35,7 +35,7 @@ static int pm8921_readb(const struct device *dev, u16 addr, u8 *val)
 	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
 	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
 
-	return msm_ssbi_read(pmic->dev->parent, addr, val, 1);
+	return ssbi_read(pmic->dev->parent, addr, val, 1);
 }
 
 static int pm8921_writeb(const struct device *dev, u16 addr, u8 val)
@@ -43,7 +43,7 @@ static int pm8921_writeb(const struct device *dev, u16 addr, u8 val)
 	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
 	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
 
-	return msm_ssbi_write(pmic->dev->parent, addr, &val, 1);
+	return ssbi_write(pmic->dev->parent, addr, &val, 1);
 }
 
 static int pm8921_read_buf(const struct device *dev, u16 addr, u8 *buf,
@@ -52,7 +52,7 @@ static int pm8921_read_buf(const struct device *dev, u16 addr, u8 *buf,
 	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
 	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
 
-	return msm_ssbi_read(pmic->dev->parent, addr, buf, cnt);
+	return ssbi_read(pmic->dev->parent, addr, buf, cnt);
 }
 
 static int pm8921_write_buf(const struct device *dev, u16 addr, u8 *buf,
@@ -61,7 +61,7 @@ static int pm8921_write_buf(const struct device *dev, u16 addr, u8 *buf,
 	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
 	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
 
-	return msm_ssbi_write(pmic->dev->parent, addr, buf, cnt);
+	return ssbi_write(pmic->dev->parent, addr, buf, cnt);
 }
 
 static int pm8921_read_irq_stat(const struct device *dev, int irq)
@@ -124,7 +124,7 @@ static int pm8921_probe(struct platform_device *pdev)
 	}
 
 	/* Read PMIC chip revision */
-	rc = msm_ssbi_read(pdev->dev.parent, REG_HWREV, &val, sizeof(val));
+	rc = ssbi_read(pdev->dev.parent, REG_HWREV, &val, sizeof(val));
 	if (rc) {
 		pr_err("Failed to read hw rev reg %d:rc=%d\n", REG_HWREV, rc);
 		goto err_read_rev;
@@ -133,7 +133,7 @@ static int pm8921_probe(struct platform_device *pdev)
 	rev = val;
 
 	/* Read PMIC chip revision 2 */
-	rc = msm_ssbi_read(pdev->dev.parent, REG_HWREV_2, &val, sizeof(val));
+	rc = ssbi_read(pdev->dev.parent, REG_HWREV_2, &val, sizeof(val));
 	if (rc) {
 		pr_err("Failed to read hw rev 2 reg %d:rc=%d\n",
 			REG_HWREV_2, rc);
diff --git a/drivers/ssbi/Kconfig b/drivers/ssbi/Kconfig
index c7bc534..1ae4040 100644
--- a/drivers/ssbi/Kconfig
+++ b/drivers/ssbi/Kconfig
@@ -1,10 +1,10 @@
 #
-# MSM SSBI bus support
+# SSBI bus support
 #
 
 menu "Qualcomm MSM SSBI bus support"
 
-config MSM_SSBI
+config SSBI
 	tristate "Qualcomm Single-wire Serial Bus Interface (SSBI)"
 	help
 	  If you say yes to this option, support will be included for the
diff --git a/drivers/ssbi/Makefile b/drivers/ssbi/Makefile
index 22e408f..38fb70c 100644
--- a/drivers/ssbi/Makefile
+++ b/drivers/ssbi/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_MSM_SSBI) += ssbi.o
+obj-$(CONFIG_SSBI) += ssbi.o
diff --git a/drivers/ssbi/ssbi.c b/drivers/ssbi/ssbi.c
index b056a07..f32da02 100644
--- a/drivers/ssbi/ssbi.c
+++ b/drivers/ssbi/ssbi.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2009-2013, The Linux Foundation. All rights reserved.
  * Copyright (c) 2010, Google Inc.
  *
  * Original authors: Code Aurora Forum
@@ -24,7 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/msm_ssbi.h>
+#include <linux/ssbi.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -65,23 +65,23 @@
 
 #define SSBI_TIMEOUT_US			100
 
-struct msm_ssbi {
+struct ssbi {
 	struct device		*slave;
 	void __iomem		*base;
 	spinlock_t		lock;
-	enum msm_ssbi_controller_type controller_type;
-	int (*read)(struct msm_ssbi *, u16 addr, u8 *buf, int len);
-	int (*write)(struct msm_ssbi *, u16 addr, u8 *buf, int len);
+	enum ssbi_controller_type controller_type;
+	int (*read)(struct ssbi *, u16 addr, u8 *buf, int len);
+	int (*write)(struct ssbi *, u16 addr, u8 *buf, int len);
 };
 
-#define to_msm_ssbi(dev)	platform_get_drvdata(to_platform_device(dev))
+#define to_ssbi(dev)	platform_get_drvdata(to_platform_device(dev))
 
-static inline u32 ssbi_readl(struct msm_ssbi *ssbi, u32 reg)
+static inline u32 ssbi_readl(struct ssbi *ssbi, u32 reg)
 {
 	return readl(ssbi->base + reg);
 }
 
-static inline void ssbi_writel(struct msm_ssbi *ssbi, u32 val, u32 reg)
+static inline void ssbi_writel(struct ssbi *ssbi, u32 val, u32 reg)
 {
 	writel(val, ssbi->base + reg);
 }
@@ -95,7 +95,7 @@ static inline void ssbi_writel(struct msm_ssbi *ssbi, u32 val, u32 reg)
  *
  * As such, this wait merely spins, with a udelay.
  */
-static int ssbi_wait_mask(struct msm_ssbi *ssbi, u32 set_mask, u32 clr_mask)
+static int ssbi_wait_mask(struct ssbi *ssbi, u32 set_mask, u32 clr_mask)
 {
 	u32 timeout = SSBI_TIMEOUT_US;
 	u32 val;
@@ -111,7 +111,7 @@ static int ssbi_wait_mask(struct msm_ssbi *ssbi, u32 set_mask, u32 clr_mask)
 }
 
 static int
-msm_ssbi_read_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
+ssbi_read_bytes(struct ssbi *ssbi, u16 addr, u8 *buf, int len)
 {
 	u32 cmd = SSBI_CMD_RDWRN | ((addr & 0xff) << 16);
 	int ret = 0;
@@ -140,7 +140,7 @@ err:
 }
 
 static int
-msm_ssbi_write_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
+ssbi_write_bytes(struct ssbi *ssbi, u16 addr, u8 *buf, int len)
 {
 	int ret = 0;
 
@@ -172,7 +172,7 @@ err:
  * busywait.
  */
 static inline int
-msm_ssbi_pa_transfer(struct msm_ssbi *ssbi, u32 cmd, u8 *data)
+ssbi_pa_transfer(struct ssbi *ssbi, u32 cmd, u8 *data)
 {
 	u32 timeout = SSBI_TIMEOUT_US;
 	u32 rd_status = 0;
@@ -197,7 +197,7 @@ msm_ssbi_pa_transfer(struct msm_ssbi *ssbi, u32 cmd, u8 *data)
 }
 
 static int
-msm_ssbi_pa_read_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
+ssbi_pa_read_bytes(struct ssbi *ssbi, u16 addr, u8 *buf, int len)
 {
 	u32 cmd;
 	int ret = 0;
@@ -205,7 +205,7 @@ msm_ssbi_pa_read_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
 	cmd = SSBI_PA_CMD_RDWRN | (addr & SSBI_PA_CMD_ADDR_MASK) << 8;
 
 	while (len) {
-		ret = msm_ssbi_pa_transfer(ssbi, cmd, buf);
+		ret = ssbi_pa_transfer(ssbi, cmd, buf);
 		if (ret)
 			goto err;
 		buf++;
@@ -217,14 +217,14 @@ err:
 }
 
 static int
-msm_ssbi_pa_write_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
+ssbi_pa_write_bytes(struct ssbi *ssbi, u16 addr, u8 *buf, int len)
 {
 	u32 cmd;
 	int ret = 0;
 
 	while (len) {
 		cmd = (addr & SSBI_PA_CMD_ADDR_MASK) << 8 | *buf;
-		ret = msm_ssbi_pa_transfer(ssbi, cmd, NULL);
+		ret = ssbi_pa_transfer(ssbi, cmd, NULL);
 		if (ret)
 			goto err;
 		buf++;
@@ -235,9 +235,9 @@ err:
 	return ret;
 }
 
-int msm_ssbi_read(struct device *dev, u16 addr, u8 *buf, int len)
+int ssbi_read(struct device *dev, u16 addr, u8 *buf, int len)
 {
-	struct msm_ssbi *ssbi = to_msm_ssbi(dev);
+	struct ssbi *ssbi = to_ssbi(dev);
 	unsigned long flags;
 	int ret;
 
@@ -247,11 +247,11 @@ int msm_ssbi_read(struct device *dev, u16 addr, u8 *buf, int len)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(msm_ssbi_read);
+EXPORT_SYMBOL_GPL(ssbi_read);
 
-int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len)
+int ssbi_write(struct device *dev, u16 addr, u8 *buf, int len)
 {
-	struct msm_ssbi *ssbi = to_msm_ssbi(dev);
+	struct ssbi *ssbi = to_ssbi(dev);
 	unsigned long flags;
 	int ret;
 
@@ -261,17 +261,17 @@ int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(msm_ssbi_write);
+EXPORT_SYMBOL_GPL(ssbi_write);
 
-static int msm_ssbi_probe(struct platform_device *pdev)
+static int ssbi_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct resource *mem_res;
-	struct msm_ssbi *ssbi;
+	struct ssbi *ssbi;
 	int ret = 0;
 	const char *type;
 
-	ssbi = kzalloc(sizeof(struct msm_ssbi), GFP_KERNEL);
+	ssbi = kzalloc(sizeof(struct ssbi), GFP_KERNEL);
 	if (!ssbi) {
 		pr_err("can not allocate ssbi_data\n");
 		return -ENOMEM;
@@ -312,11 +312,11 @@ static int msm_ssbi_probe(struct platform_device *pdev)
 	}
 
 	if (ssbi->controller_type == MSM_SBI_CTRL_PMIC_ARBITER) {
-		ssbi->read = msm_ssbi_pa_read_bytes;
-		ssbi->write = msm_ssbi_pa_write_bytes;
+		ssbi->read = ssbi_pa_read_bytes;
+		ssbi->write = ssbi_pa_write_bytes;
 	} else {
-		ssbi->read = msm_ssbi_read_bytes;
-		ssbi->write = msm_ssbi_write_bytes;
+		ssbi->read = ssbi_read_bytes;
+		ssbi->write = ssbi_write_bytes;
 	}
 
 	spin_lock_init(&ssbi->lock);
@@ -336,9 +336,9 @@ err_get_mem_res:
 	return ret;
 }
 
-static int msm_ssbi_remove(struct platform_device *pdev)
+static int ssbi_remove(struct platform_device *pdev)
 {
-	struct msm_ssbi *ssbi = platform_get_drvdata(pdev);
+	struct ssbi *ssbi = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
 	iounmap(ssbi->base);
@@ -351,29 +351,29 @@ static struct of_device_id ssbi_match_table[] = {
 	{}
 };
 
-static struct platform_driver msm_ssbi_driver = {
-	.probe		= msm_ssbi_probe,
-	.remove		= msm_ssbi_remove,
+static struct platform_driver ssbi_driver = {
+	.probe		= ssbi_probe,
+	.remove		= ssbi_remove,
 	.driver		= {
-		.name	= "msm_ssbi",
+		.name	= "ssbi",
 		.owner	= THIS_MODULE,
 		.of_match_table = ssbi_match_table,
 	},
 };
 
-static int __init msm_ssbi_init(void)
+static int __init ssbi_init(void)
 {
-	return platform_driver_register(&msm_ssbi_driver);
+	return platform_driver_register(&ssbi_driver);
 }
-module_init(msm_ssbi_init);
+module_init(ssbi_init);
 
-static void __exit msm_ssbi_exit(void)
+static void __exit ssbi_exit(void)
 {
-	platform_driver_unregister(&msm_ssbi_driver);
+	platform_driver_unregister(&ssbi_driver);
 }
-module_exit(msm_ssbi_exit)
+module_exit(ssbi_exit)
 
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION("1.0");
-MODULE_ALIAS("platform:msm_ssbi");
+MODULE_ALIAS("platform:ssbi");
 MODULE_AUTHOR("Dima Zavin <dima@android.com>");
diff --git a/include/linux/msm_ssbi.h b/include/linux/ssbi.h
similarity index 67%
rename from include/linux/msm_ssbi.h
rename to include/linux/ssbi.h
index 0fe245b..44ef5da 100644
--- a/include/linux/msm_ssbi.h
+++ b/include/linux/ssbi.h
@@ -12,27 +12,27 @@
  * GNU General Public License for more details.
  */
 
-#ifndef _LINUX_MSM_SSBI_H
-#define _LINUX_MSM_SSBI_H
+#ifndef _LINUX_SSBI_H
+#define _LINUX_SSBI_H
 
 #include <linux/types.h>
 
-struct msm_ssbi_slave_info {
+struct ssbi_slave_info {
 	const char	*name;
 	void		*platform_data;
 };
 
-enum msm_ssbi_controller_type {
+enum ssbi_controller_type {
 	MSM_SBI_CTRL_SSBI = 0,
 	MSM_SBI_CTRL_SSBI2,
 	MSM_SBI_CTRL_PMIC_ARBITER,
 };
 
-struct msm_ssbi_platform_data {
-	struct msm_ssbi_slave_info	slave;
-	enum msm_ssbi_controller_type controller_type;
+struct ssbi_platform_data {
+	struct ssbi_slave_info	slave;
+	enum ssbi_controller_type controller_type;
 };
 
-int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len);
-int msm_ssbi_read(struct device *dev, u16 addr, u8 *buf, int len);
+int ssbi_write(struct device *dev, u16 addr, u8 *buf, int len);
+int ssbi_read(struct device *dev, u16 addr, u8 *buf, int len);
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

