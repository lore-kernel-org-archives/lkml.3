Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3LaVoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 16:44:19 -0500
Received: from mail-gw4-out.broadcom.com ([216.31.217.44]:53674 "EHLO
	mail-gw4-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3LaVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 16:44:18 -0500
X-IronPort-AV: E=Sophos;i="4.95,582,1384329600"; 
   d="scan'208";a="278660"
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Christian Daudt <bcm@fixthebug.org>
CC: Linaro Patches <patches@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH 1/2] watchdog: bcm281xx: Debugfs support
Date: Tue, 31 Dec 2013 13:22:13 -0800
Message-ID: <1388524934-10563-2-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388524934-10563-1-git-send-email-markus.mayer@linaro.org>
References: <1388524934-10563-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change introduces debugfs support for the BCM281xx watchdog driver.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/watchdog/Kconfig        |   10 ++++
 drivers/watchdog/bcm_kona_wdt.c |  116 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 122 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 10d188a..9b8b96d 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1152,6 +1152,16 @@ config BCM_KONA_WDT
 	  Say 'Y' or 'M' here to enable the driver. The module will be called
 	  bcm_kona_wdt.
 
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
diff --git a/drivers/watchdog/bcm_kona_wdt.c b/drivers/watchdog/bcm_kona_wdt.c
index 7e41a83..d3aa473 100644
--- a/drivers/watchdog/bcm_kona_wdt.c
+++ b/drivers/watchdog/bcm_kona_wdt.c
@@ -11,6 +11,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/io.h>
@@ -55,9 +56,13 @@ struct bcm_kona_wdt {
 	 */
 	int resolution;
 	spinlock_t lock;
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	unsigned long busy_count;
+	struct dentry *debugfs;
+#endif
 };
 
-static int secure_register_read(void __iomem *addr)
+static int secure_register_read(struct bcm_kona_wdt *wdt, uint32_t offset)
 {
 	uint32_t val;
 	unsigned count = 0;
@@ -70,10 +75,16 @@ static int secure_register_read(void __iomem *addr)
 	do {
 		if (unlikely(count > 1))
 			udelay(5);
-		val = readl_relaxed(addr);
+		val = readl_relaxed(wdt->base + offset);
 		count++;
 	} while ((val & SECWDOG_WD_LOAD_FLAG) && count < SECWDOG_MAX_TRY);
 
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	/* Remember the maximum number iterations due to WD_LOAD_FLAG */
+	if (count > wdt->busy_count)
+		wdt->busy_count = count;
+#endif
+
 	/* This is the only place we return a negative value. */
 	if (val & SECWDOG_WD_LOAD_FLAG)
 		return -ETIMEDOUT;
@@ -84,6 +95,80 @@ static int secure_register_read(void __iomem *addr)
 	return val;
 }
 
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+
+static int bcm_kona_wdt_dbg_show(struct seq_file *s, void *data)
+{
+	int ctl_val, cur_val, ret;
+	unsigned long flags;
+	struct bcm_kona_wdt *wdt = s->private;
+
+	if (!wdt)
+		return seq_puts(s, "No device pointer\n");
+
+	spin_lock_irqsave(&wdt->lock, flags);
+	ctl_val = secure_register_read(wdt, SECWDOG_CTRL_REG);
+	cur_val = secure_register_read(wdt, SECWDOG_COUNT_REG);
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	if (ctl_val < 0 || cur_val < 0) {
+		ret = seq_puts(s, "Error accessing hardware\n");
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
+				"Current: %d s / %d (%#x) ticks\n"
+				"Busy count: %lu\n", res,
+				wdt->resolution, ctl_sec, ctl, ctl, cur_sec,
+				cur, cur, wdt->busy_count);
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
+	if (IS_ERR_OR_NULL(dir))
+		return NULL;
+
+	if (debugfs_create_file("info", S_IFREG | S_IRUGO, dir, wdt,
+				&bcm_kona_dbg_operations))
+		return dir;
+
+	/* Clean up */
+	debugfs_remove_recursive(dir);
+	return NULL;
+}
+
+static void bcm_kona_debugfs_exit(struct dentry *dir)
+{
+	debugfs_remove_recursive(dir);
+}
+
+#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
+
 static int bcm_kona_wdt_ctrl_reg_modify(struct bcm_kona_wdt *wdt,
 					unsigned mask, unsigned newval)
 {
@@ -93,7 +178,7 @@ static int bcm_kona_wdt_ctrl_reg_modify(struct bcm_kona_wdt *wdt,
 
 	spin_lock_irqsave(&wdt->lock, flags);
 
-	val = secure_register_read(wdt->base + SECWDOG_CTRL_REG);
+	val = secure_register_read(wdt, SECWDOG_CTRL_REG);
 	if (val < 0) {
 		ret = val;
 	} else {
@@ -140,7 +225,7 @@ static unsigned int bcm_kona_wdt_get_timeleft(struct watchdog_device *wdog)
 	unsigned long flags;
 
 	spin_lock_irqsave(&wdt->lock, flags);
-	val = secure_register_read(wdt->base + SECWDOG_COUNT_REG);
+	val = secure_register_read(wdt, SECWDOG_COUNT_REG);
 	spin_unlock_irqrestore(&wdt->lock, flags);
 
 	if (val < 0)
@@ -190,6 +275,27 @@ static void bcm_kona_wdt_shutdown(struct platform_device *pdev)
 	bcm_kona_wdt_stop(&bcm_kona_wdt_wdd);
 }
 
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+static void bcm_kona_wdt_debug_init(struct platform_device *pdev)
+{
+	struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
+
+	wdt->debugfs = bcm_kona_wdt_debugfs_init(wdt, &bcm_kona_wdt_wdd);
+}
+
+static void bcm_kona_wdt_debug_exit(struct platform_device *pdev)
+{
+	struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
+
+	if (wdt->debugfs)
+		bcm_kona_debugfs_exit(wdt->debugfs);
+}
+
+#else
+static void bcm_kona_wdt_debug_init(struct platform_device *pdev) {}
+static void bcm_kona_wdt_debug_exit(struct platform_device *pdev) {}
+#endif
+
 static int bcm_kona_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -229,6 +335,7 @@ static int bcm_kona_wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	bcm_kona_wdt_debug_init(pdev);
 	dev_dbg(dev, "Broadcom Kona Watchdog Timer");
 
 	return 0;
@@ -236,6 +343,7 @@ static int bcm_kona_wdt_probe(struct platform_device *pdev)
 
 static int bcm_kona_wdt_remove(struct platform_device *pdev)
 {
+	bcm_kona_wdt_debug_exit(pdev);
 	bcm_kona_wdt_shutdown(pdev);
 	watchdog_unregister_device(&bcm_kona_wdt_wdd);
 	dev_dbg(&pdev->dev, "Watchdog driver disabled");
-- 
1.7.9.5

