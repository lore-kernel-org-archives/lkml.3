Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab3KFLsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:48:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47005 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab3KFLr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:47:59 -0500
Message-ID: <527A287C.2090401@ti.com>
Date: Wed, 6 Nov 2013 13:31:08 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>, <wim@iguana.be>,
        <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <galak@kernel.crashing.org>, <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Fwd: [PATCH 1/8] watchdog: davinci: change driver to use WDT core
References: <1383680783-12114-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1383680783-12114-2-git-send-email-ivan.khoronzhuk@ti.com>
X-Forwarded-Message-Id: <1383680783-12114-2-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To reduce code duplicate and increase code readability use WDT core
code to handle WDT interface.

Remove io_lock as the WDT core uses mutex to lock each wdt device.
Remove wdt_state as the WDT core track state with its own variable.

The watchdog_init_timeout() can read timeout value from timeout-sec
property if the passed value is out of bounds. So set initial
heartbeat value more than max value in order to initialize heartbeat
in next way. If heartbeat is not set thought module parameter, try
to read it's value from WDT node timeout-sec property. If node has
no one, use default value.

The heartbeat is hold in wdd->timeout by WDT core, so use it in
order to set timeout period.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/watchdog/Kconfig       |    1 +
 drivers/watchdog/davinci_wdt.c |  150 ++++++++++------------------------------
 2 files changed, 38 insertions(+), 113 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index d1d53f3..2c954b5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -271,6 +271,7 @@ config IOP_WATCHDOG
 config DAVINCI_WATCHDOG
 	tristate "DaVinci watchdog"
 	depends on ARCH_DAVINCI
+	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the DaVinci DM644x/DM646x processors.
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index bead774..a6eef71 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -3,7 +3,7 @@
  *
  * Watchdog driver for DaVinci DM644x/DM646x processors
  *
- * Copyright (C) 2006 Texas Instruments.
+ * Copyright (C) 2013 Texas Instruments.
  *
  * 2007 (c) MontaVista Software, Inc. This file is licensed under
  * the terms of the GNU General Public License version 2. This program
@@ -15,18 +15,12 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
-#include <linux/bitops.h>
 #include <linux/platform_device.h>
-#include <linux/spinlock.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/device.h>
 #include <linux/clk.h>
-#include <linux/slab.h>
 #include <linux/err.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
@@ -61,31 +55,13 @@
 #define WDKEY_SEQ0		(0xa5c6 << 16)
 #define WDKEY_SEQ1		(0xda7e << 16)
 
-static int heartbeat = DEFAULT_HEARTBEAT;
-
-static DEFINE_SPINLOCK(io_lock);
-static unsigned long wdt_status;
-#define WDT_IN_USE        0
-#define WDT_OK_TO_CLOSE   1
-#define WDT_REGION_INITED 2
-#define WDT_DEVICE_INITED 3
-
+static int heartbeat = MAX_HEARTBEAT + 1;
 static void __iomem	*wdt_base;
 struct clk		*wdt_clk;
+static struct watchdog_device	wdt_wdd;
 
-static void wdt_service(void)
-{
-	spin_lock(&io_lock);
-
-	/* put watchdog in service state */
-	iowrite32(WDKEY_SEQ0, wdt_base + WDTCR);
-	/* put watchdog in active state */
-	iowrite32(WDKEY_SEQ1, wdt_base + WDTCR);
-
-	spin_unlock(&io_lock);
-}
-
-static void wdt_enable(void)
+/* davinci_wdt_start - enable watchdog */
+static int davinci_wdt_start(struct watchdog_device *wdd)
 {
 	u32 tgcr;
 	u32 timer_margin;
@@ -93,8 +69,6 @@ static void wdt_enable(void)
 
 	wdt_freq = clk_get_rate(wdt_clk);
 
-	spin_lock(&io_lock);
-
 	/* disable, internal clock source */
 	iowrite32(0, wdt_base + TCR);
 	/* reset timer, set mode to 64-bit watchdog, and unreset */
@@ -105,9 +79,9 @@ static void wdt_enable(void)
 	iowrite32(0, wdt_base + TIM12);
 	iowrite32(0, wdt_base + TIM34);
 	/* set timeout period */
-	timer_margin = (((u64)heartbeat * wdt_freq) & 0xffffffff);
+	timer_margin = (((u64)wdd->timeout * wdt_freq) & 0xffffffff);
 	iowrite32(timer_margin, wdt_base + PRD12);
-	timer_margin = (((u64)heartbeat * wdt_freq) >> 32);
+	timer_margin = (((u64)wdd->timeout * wdt_freq) >> 32);
 	iowrite32(timer_margin, wdt_base + PRD34);
 	/* enable run continuously */
 	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
@@ -119,84 +93,28 @@ static void wdt_enable(void)
 	iowrite32(WDKEY_SEQ0 | WDEN, wdt_base + WDTCR);
 	/* put watchdog in active state */
 	iowrite32(WDKEY_SEQ1 | WDEN, wdt_base + WDTCR);
-
-	spin_unlock(&io_lock);
-}
-
-static int davinci_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-
-	wdt_enable();
-
-	return nonseekable_open(inode, file);
+	return 0;
 }
 
-static ssize_t
-davinci_wdt_write(struct file *file, const char *data, size_t len,
-		  loff_t *ppos)
+static int davinci_wdt_ping(struct watchdog_device *wdd)
 {
-	if (len)
-		wdt_service();
-
-	return len;
+	/* put watchdog in service state */
+	iowrite32(WDKEY_SEQ0, wdt_base + WDTCR);
+	/* put watchdog in active state */
+	iowrite32(WDKEY_SEQ1, wdt_base + WDTCR);
+	return 0;
 }
 
-static const struct watchdog_info ident = {
+static const struct watchdog_info davinci_wdt_info = {
 	.options = WDIOF_KEEPALIVEPING,
 	.identity = "DaVinci Watchdog",
 };
 
-static long davinci_wdt_ioctl(struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	int ret = -ENOTTY;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user((struct watchdog_info *)arg, &ident,
-				   sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_service();
-		ret = 0;
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, (int *)arg);
-		break;
-	}
-	return ret;
-}
-
-static int davinci_wdt_release(struct inode *inode, struct file *file)
-{
-	wdt_service();
-	clear_bit(WDT_IN_USE, &wdt_status);
-
-	return 0;
-}
-
-static const struct file_operations davinci_wdt_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = davinci_wdt_write,
-	.unlocked_ioctl = davinci_wdt_ioctl,
-	.open = davinci_wdt_open,
-	.release = davinci_wdt_release,
-};
-
-static struct miscdevice davinci_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &davinci_wdt_fops,
+static const struct watchdog_ops davinci_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= davinci_wdt_start,
+	.stop		= davinci_wdt_ping,
+	.ping		= davinci_wdt_ping,
 };
 
 static int davinci_wdt_probe(struct platform_device *pdev)
@@ -204,6 +122,7 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	int ret = 0;
 	struct device *dev = &pdev->dev;
 	struct resource  *wdt_mem;
+	struct watchdog_device *wdd;
 
 	wdt_clk = devm_clk_get(dev, NULL);
 	if (WARN_ON(IS_ERR(wdt_clk)))
@@ -211,29 +130,35 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 
 	clk_prepare_enable(wdt_clk);
 
-	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
-		heartbeat = DEFAULT_HEARTBEAT;
+	wdd			= &wdt_wdd;
+	wdd->info		= &davinci_wdt_info;
+	wdd->ops		= &davinci_wdt_ops;
+	wdd->min_timeout 	= 1;
+	wdd->max_timeout 	= MAX_HEARTBEAT;
+	wdd->timeout		= DEFAULT_HEARTBEAT;
+
+	if (heartbeat)
+		watchdog_init_timeout(wdd, heartbeat, dev);
+
+	dev_info(dev, "heartbeat %d sec\n", wdd->timeout);
 
-	dev_info(dev, "heartbeat %d sec\n", heartbeat);
+	watchdog_set_nowayout(wdd, WATCHDOG_NOWAYOUT);
 
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	wdt_base = devm_ioremap_resource(dev, wdt_mem);
 	if (IS_ERR(wdt_base))
 		return PTR_ERR(wdt_base);
 
-	ret = misc_register(&davinci_wdt_miscdev);
-	if (ret < 0) {
-		dev_err(dev, "cannot register misc device\n");
-	} else {
-		set_bit(WDT_DEVICE_INITED, &wdt_status);
-	}
+	ret = watchdog_register_device(wdd);
+	if (ret < 0)
+		dev_err(dev, "cannot register watchdog device\n");
 
 	return ret;
 }
 
 static int davinci_wdt_remove(struct platform_device *pdev)
 {
-	misc_deregister(&davinci_wdt_miscdev);
+	watchdog_unregister_device(&wdt_wdd);
 	clk_disable_unprepare(wdt_clk);
 
 	return 0;
@@ -267,5 +192,4 @@ MODULE_PARM_DESC(heartbeat,
 		 __MODULE_STRING(DEFAULT_HEARTBEAT));
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:watchdog");
-- 
1.7.9.5



