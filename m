Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab3L1Uk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 15:40:57 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:49012 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750778Ab3L1Uk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 15:40:56 -0500
Date: Sat, 28 Dec 2013 21:40:39 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Christian Daudt <bcm@fixthebug.org>,
        Linaro Patches <patches@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/2] watchdog: bcm281xx: Watchdog Driver
Message-ID: <20131228204039.GA19982@spo001.leaseweb.com>
References: <1385160964-18578-1-git-send-email-markus.mayer@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385160964-18578-1-git-send-email-markus.mayer@linaro.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

> This is version 5 of the watchdog driver for the BCM281xx family of mobile
> SoCs.

I applied the patches but without the BCM_KONA_WDT_DEBUG part, because I
still have some questions about it. So what is left is the following patch:

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 10d1392..d4d0083 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -128,3 +128,4 @@ CONFIG_XZ_DEC=y
 CONFIG_AVERAGE=y
 CONFIG_WATCHDOG=y
 CONFIG_BCM_KONA_WDT=y
+CONFIG_BCM_KONA_WDT_DEBUG=y
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 042e452..24bc93a 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1151,6 +1151,16 @@ config BCM_KONA_WDT
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
index 7e41a83..9fe174b 100644
--- a/drivers/watchdog/bcm_kona_wdt.c
+++ b/drivers/watchdog/bcm_kona_wdt.c
@@ -11,6 +11,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/io.h>
@@ -55,8 +56,15 @@ struct bcm_kona_wdt {
 	 */
 	int resolution;
 	spinlock_t lock;
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	struct dentry *debugfs;
+#endif
 };
 
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+static unsigned long busy_count;
+#endif
+
 static int secure_register_read(void __iomem *addr)
 {
 	uint32_t val;
@@ -74,6 +82,12 @@ static int secure_register_read(void __iomem *addr)
 		count++;
 	} while ((val & SECWDOG_WD_LOAD_FLAG) && count < SECWDOG_MAX_TRY);
 
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	/* Remember the maximum number iterations due to WD_LOAD_FLAG */
+	if (count > busy_count)
+		busy_count = count;
+#endif
+
 	/* This is the only place we return a negative value. */
 	if (val & SECWDOG_WD_LOAD_FLAG)
 		return -ETIMEDOUT;
@@ -84,6 +98,80 @@ static int secure_register_read(void __iomem *addr)
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
+	ctl_val = secure_register_read(wdt->base + SECWDOG_CTRL_REG);
+	cur_val = secure_register_read(wdt->base + SECWDOG_COUNT_REG);
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
+				cur, cur, busy_count);
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
@@ -229,6 +317,9 @@ static int bcm_kona_wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	wdt->debugfs = bcm_kona_wdt_debugfs_init(wdt, &bcm_kona_wdt_wdd);
+#endif
 	dev_dbg(dev, "Broadcom Kona Watchdog Timer");
 
 	return 0;
@@ -236,6 +327,12 @@ static int bcm_kona_wdt_probe(struct platform_device *pdev)
 
 static int bcm_kona_wdt_remove(struct platform_device *pdev)
 {
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
+
+	if (wdt->debugfs)
+		bcm_kona_debugfs_exit(wdt->debugfs);
+#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
 	bcm_kona_wdt_shutdown(pdev);
 	watchdog_unregister_device(&bcm_kona_wdt_wdd);
 	dev_dbg(&pdev->dev, "Watchdog driver disabled");


Questions/remarks I still have:
1) *debugfs is defined in the bcm_kona_wdt struct, but busy_count isn't.
   Seems odd to me. What's the reason?
2) I don't like the #ifdef pieces in the probe and remove functions.
   The preferred method is to not have the #ifdefs there, but to have an
   init and exit function that is defined in a similar way:

	#ifdef CONFIG_BCM_KONA_WDT_DEBUG
	...
	static void bcm_kona_wdt_debug_init(struct bcm_kona_wdt *wdt)
	{
		wdt->debugfs = bcm_kona_wdt_debugfs_init(wdt, &bcm_kona_wdt_wdd);
	}
	...
	#else /* !CONFIG_BCM_KONA_WDT_DEBUG */
	static void bcm_kona_wdt_debug_init(struct bcm_kona_wdt *wdt) {}
	...
	#endif /* CONFIG_BCM_KONA_WDT_DEBUG */

Goal is to have as little #ifdef's as possible and to improve readability of the code.

So can you do the necessary?

Thanks in advance,
Wim.

