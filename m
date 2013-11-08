Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab3KHUpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:45:13 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4515 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845Ab3KHUpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:45:07 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Markus Mayer" <markus.mayer@linaro.org>
To: "Wim Van Sebroeck" <wim@iguana.be>, "Christian Daudt" <bcm@fixthebug.org>
cc: "Linaro Patches" <patches@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Linux Watchdog List" <linux-watchdog@vger.kernel.org>,
        "ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Markus Mayer" <markus.mayer@linaro.org>
Subject: [PATCH 1/2] watchdog: bcm281xx: Watchdog Driver
Date: Fri, 8 Nov 2013 12:44:47 -0800
Message-ID: <1383943488-6537-2-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383943488-6537-1-git-send-email-markus.mayer@linaro.org>
References: <1383943488-6537-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E6392BB4RS6359063-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for the watchdog timer used on the BCM281xx
family of SoCs.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 drivers/watchdog/Kconfig        |   21 +++
 drivers/watchdog/Makefile       |    1 +
 drivers/watchdog/bcm_kona_wdt.c |  399 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 421 insertions(+)
 create mode 100644 drivers/watchdog/bcm_kona_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index d1d53f3..59013f6 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1121,6 +1121,27 @@ config BCM2835_WDT
 	  To compile this driver as a loadable module, choose M here.
 	  The module will be called bcm2835_wdt.
 
+config BCM_KONA_WDT
+	tristate "BCM Kona Watchdog"
+	depends on ARCH_BCM
+	select WATCHDOG_CORE
+	help
+	  Support for the watchdog timer on the following Broadcom BCM281xx 
+	  family, which includes BCM11130, BCM11140, BCM11351, BCM28145 and
+	  BCM28155 variants.
+
+	  Say 'Y' or 'M' here to enable the driver.
+
+config BCM_KONA_WDT_DEBUG
+	bool "DEBUGFS support for BCM Kona Watchdog"
+	depends on BCM_KONA_WDT
+	help
+	  If enabled, adds /sys/kernel/debug/bcm-kona-wdt/info which provides
+	  access to the driver's internal data structures as well as watchdog
+	  timer hardware registres.
+
+	  If in doubt, say 'N'.
+
 config LANTIQ_WDT
 	tristate "Lantiq SoC watchdog"
 	depends on LANTIQ
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 6c5bb27..7c860ca 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
 obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
 obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
 obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
+obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/bcm_kona_wdt.c b/drivers/watchdog/bcm_kona_wdt.c
new file mode 100644
index 0000000..c47ac77
--- /dev/null
+++ b/drivers/watchdog/bcm_kona_wdt.c
@@ -0,0 +1,399 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+#define SECWDOG_CTRL_REG		0x00000000
+#define SECWDOG_COUNT_REG		0x00000004
+
+#define SECWDOG_RESERVED_MASK		0x1dffffff
+#define SECWDOG_WD_LOAD_FLAG_MASK	0x10000000
+#define SECWDOG_EN_MASK			0x08000000
+#define SECWDOG_SRSTEN_MASK		0x04000000
+#define SECWDOG_RES_MASK		0x00f00000
+#define SECWDOG_COUNT_MASK		0x000fffff
+
+#define SECWDOG_MAX_COUNT		SECWDOG_COUNT_MASK
+#define SECWDOG_CLKS_SHIFT		20
+#define SECWDOG_MAX_RES			15
+#define SECWDOG_DEFAULT_RESOLUTION	4
+#define SECWDOG_MAX_TRY			10000
+
+#define SECS_TO_TICKS(x, w)		((x) << (w)->resolution)
+#define TICKS_TO_SECS(x, w)		((x) >> (w)->resolution)
+
+#define BCM_KONA_WDT_NAME		"bcm-kona-wdt"
+
+struct bcm_kona_wdt {
+	void __iomem *base;
+	int resolution;
+	spinlock_t lock;
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	struct dentry *debugfs;
+#endif
+};
+
+static uint32_t secure_register_read(void __iomem *addr, int *timeout)
+{
+	uint32_t val;
+	unsigned count = 0;
+
+	do {
+		val = readl_relaxed(addr);
+		count++;
+	} while ((val & SECWDOG_WD_LOAD_FLAG_MASK) != 0 &&
+		count < SECWDOG_MAX_TRY);
+	if (timeout)
+		*timeout = ((val & SECWDOG_WD_LOAD_FLAG_MASK) != 0);
+
+	/* We always mask out reserved bits before returning the value. */
+	val &= SECWDOG_RESERVED_MASK;
+
+	return val;
+}
+
+
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+
+static int bcm_kona_wdt_dbg_show(struct seq_file *s, void *data)
+{
+	uint32_t ctl_val, cur_val;
+	int ret, ctl_timeout, cur_timeout;
+	unsigned long flags;
+	struct bcm_kona_wdt *wdt = s->private;
+
+	if (!wdt)
+		return seq_printf(s, "No device pointer\n");
+
+	spin_lock_irqsave(&wdt->lock, flags);
+	ctl_val = secure_register_read(wdt->base + SECWDOG_CTRL_REG,
+				&ctl_timeout);
+	cur_val = secure_register_read(wdt->base + SECWDOG_COUNT_REG,
+				&cur_timeout);
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	if (ctl_timeout || cur_timeout) {
+		ret = seq_printf(s, "Error accessing hardware\n");
+	} else {
+		int ctl, cur, ctl_sec, cur_sec, res;
+
+		ctl = ctl_val & SECWDOG_COUNT_MASK;
+		res = (ctl_val & SECWDOG_RES_MASK) >> SECWDOG_CLKS_SHIFT;
+		cur = cur_val & SECWDOG_COUNT_MASK;
+		ctl_sec = TICKS_TO_SECS(ctl, wdt);
+		cur_sec = TICKS_TO_SECS(cur, wdt);
+		ret = seq_printf(s, "Resolution: %d / %d\n"
+				"Control: %d s / %d (%#x) ticks\n"
+				"Current: %d s / %d (%#x) ticks\n", res,
+				wdt->resolution, ctl_sec, ctl, ctl, cur_sec,
+				cur, cur);
+	}
+
+	return ret;
+}
+
+static int bcm_kona_dbg_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, bcm_kona_wdt_dbg_show, inode->i_private);
+}
+
+static const struct file_operations bcm_kona_dbg_operations = {
+	.open		= bcm_kona_dbg_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static struct dentry *bcm_kona_wdt_debugfs_init(struct bcm_kona_wdt *wdt,
+	struct watchdog_device *wdd)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir(BCM_KONA_WDT_NAME, NULL);
+	if (!dir)
+		return NULL;
+
+	if (!debugfs_create_file("info", S_IFREG | S_IRUGO, dir, wdt,
+				&bcm_kona_dbg_operations))
+		goto out_err;
+
+	return dir;
+
+out_err:
+	debugfs_remove_recursive(dir);
+	return NULL;
+}
+
+static void bcm_kona_debugfs_exit(struct dentry *debugfs)
+{
+	debugfs_remove_recursive(debugfs);
+}
+
+#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
+
+
+static int bcm_kona_wdt_set_resolution_reg(struct bcm_kona_wdt *wdt)
+{
+	uint32_t val;
+	int timeout;
+	unsigned long flags;
+	int ret = 0;
+
+	if (wdt->resolution > SECWDOG_MAX_RES)
+		return -EINVAL;
+
+	spin_lock_irqsave(&wdt->lock, flags);
+
+	val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
+	if (!timeout) {
+		val &= ~SECWDOG_RES_MASK;
+		val |= wdt->resolution << SECWDOG_CLKS_SHIFT;
+		writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
+	} else {
+		ret = -EAGAIN;
+	}
+
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	return ret;
+}
+
+static int bcm_kona_wdt_set_timeout_reg(struct watchdog_device *wdog)
+{
+	struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
+	uint32_t val;
+	int timeout;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&wdt->lock, flags);
+
+	val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
+	if (!timeout) {
+		val &= ~SECWDOG_COUNT_MASK;
+		val |= SECS_TO_TICKS(wdog->timeout, wdt);
+		writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
+	} else {
+		ret = -EAGAIN;
+	}
+
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	return ret;
+}
+
+static int bcm_kona_wdt_set_timeout(struct watchdog_device *wdog,
+	unsigned int t)
+{
+	wdog->timeout = t;
+	return 0;
+}
+
+static unsigned int bcm_kona_wdt_get_timeleft(struct watchdog_device *wdog)
+{
+	struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
+	uint32_t val;
+	int timeout;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt->lock, flags);
+	val = secure_register_read(wdt->base + SECWDOG_COUNT_REG, &timeout);
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	if (timeout)
+		return -EAGAIN;
+
+	return TICKS_TO_SECS(val & SECWDOG_COUNT_MASK, wdt);
+}
+
+static int bcm_kona_wdt_start(struct watchdog_device *wdog)
+{
+	struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
+	uint32_t val;
+	int timeout;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&wdt->lock, flags);
+
+	val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
+	if (!timeout) {
+		val &= ~SECWDOG_COUNT_MASK;
+		val |= SECWDOG_EN_MASK | SECWDOG_SRSTEN_MASK |
+			SECS_TO_TICKS(wdog->timeout, wdt);
+		writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
+	} else {
+		ret = -EAGAIN;
+	}
+
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	if (!timeout)
+		dev_info(wdog->dev, "Watchdog timer started");
+
+	return ret;
+}
+
+static int bcm_kona_wdt_stop(struct watchdog_device *wdog)
+{
+	struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
+	uint32_t val;
+	int timeout, timeleft;
+	unsigned long flags;
+	int ret = 0;
+
+	timeleft = bcm_kona_wdt_get_timeleft(wdog);
+	if (timeleft < 0)
+		return ret;
+
+	spin_lock_irqsave(&wdt->lock, flags);
+
+	val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
+	if (!timeout) {
+		val &= ~(SECWDOG_EN_MASK | SECWDOG_SRSTEN_MASK |
+			SECWDOG_COUNT_MASK);
+		val |= SECS_TO_TICKS(timeleft, wdt);
+		writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
+	} else {
+		ret = -EAGAIN;
+	}
+
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	if (!timeout)
+		dev_info(wdog->dev, "Watchdog timer stopped");
+
+	return ret;
+}
+
+static struct watchdog_ops bcm_kona_wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	bcm_kona_wdt_start,
+	.stop =		bcm_kona_wdt_stop,
+	.set_timeout =	bcm_kona_wdt_set_timeout,
+	.get_timeleft =	bcm_kona_wdt_get_timeleft,
+};
+
+static struct watchdog_info bcm_kona_wdt_info = {
+	.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+			WDIOF_KEEPALIVEPING,
+	.identity =	"Broadcom Kona Watchdog Timer",
+};
+
+static struct watchdog_device bcm_kona_wdt_wdd = {
+	.info =		&bcm_kona_wdt_info,
+	.ops =		&bcm_kona_wdt_ops,
+	.min_timeout =	1,
+	.max_timeout =	SECWDOG_MAX_COUNT >> SECWDOG_DEFAULT_RESOLUTION,
+	.timeout =	SECWDOG_MAX_COUNT >> SECWDOG_DEFAULT_RESOLUTION,
+};
+
+static void bcm_kona_wdt_shutdown(struct platform_device *pdev)
+{
+	bcm_kona_wdt_stop(&bcm_kona_wdt_wdd);
+}
+
+static int bcm_kona_wdt_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct bcm_kona_wdt *wdt;
+	struct resource *res;
+	int ret;
+
+	wdt = devm_kzalloc(dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt) {
+		dev_err(dev, "Failed to allocate memory for watchdog device");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	wdt->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(wdt->base))
+		return -ENODEV;
+
+	wdt->resolution = SECWDOG_DEFAULT_RESOLUTION;
+	ret = bcm_kona_wdt_set_resolution_reg(wdt);
+	if (ret) {
+		dev_err(dev, "Failed to set resolution (error: %d)", ret);
+		return ret;
+	}
+
+	spin_lock_init(&wdt->lock);
+	platform_set_drvdata(pdev, wdt);
+	watchdog_set_drvdata(&bcm_kona_wdt_wdd, wdt);
+
+	ret = bcm_kona_wdt_set_timeout_reg(&bcm_kona_wdt_wdd);
+	if (ret) {
+		dev_err(dev, "Failed set watchdog timeout");
+		return ret;
+	}
+
+	ret = watchdog_register_device(&bcm_kona_wdt_wdd);
+	if (ret) {
+		dev_err(dev, "Failed to register watchdog device");
+		return ret;
+	}
+
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	wdt->debugfs = bcm_kona_wdt_debugfs_init(wdt, &bcm_kona_wdt_wdd);
+#endif
+	dev_info(dev, "Broadcom Kona Watchdog Timer");
+
+	return 0;
+}
+
+static int bcm_kona_wdt_remove(struct platform_device *pdev)
+{
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
+
+	if (wdt->debugfs)
+		bcm_kona_debugfs_exit(wdt->debugfs);
+#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
+	bcm_kona_wdt_shutdown(pdev);
+	watchdog_unregister_device(&bcm_kona_wdt_wdd);
+	dev_info(&pdev->dev, "Watchdog driver disabled");
+
+	return 0;
+}
+
+static const struct of_device_id bcm_kona_wdt_of_match[] = {
+	{ .compatible = "brcm,kona-wdt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm_kona_wdt_of_match);
+
+static struct platform_driver bcm_kona_wdt_driver = {
+	.driver = {
+			.name = BCM_KONA_WDT_NAME,
+			.owner = THIS_MODULE,
+			.of_match_table = bcm_kona_wdt_of_match,
+		   },
+	.probe = bcm_kona_wdt_probe,
+	.remove = bcm_kona_wdt_remove,
+	.shutdown = bcm_kona_wdt_shutdown,
+};
+
+module_platform_driver(bcm_kona_wdt_driver);
+
+MODULE_AUTHOR("Markus Mayer <mmayer@broadcom.com>");
+MODULE_DESCRIPTION("Broadcom Kona Watchdog Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.7.9.5


