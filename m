Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3BEUOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:14:22 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55328 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3BEUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:14:19 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 05 Feb 2013 14:14:18 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] watchdog: Convert BookE watchdog driver to watchdog infrastructure
Date: Tue,  5 Feb 2013 12:14:23 -0800
Message-Id: <1360095263-2550-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/Kconfig     |    1 +
 drivers/watchdog/booke_wdt.c |  185 +++++++++++++++---------------------------
 2 files changed, 66 insertions(+), 120 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 7f809fd..a5a9728 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1119,6 +1119,7 @@ config PIKA_WDT
 config BOOKE_WDT
 	tristate "PowerPC Book-E Watchdog Timer"
 	depends on BOOKE || 4xx
+	select WATCHDOG_CORE
 	---help---
 	  Watchdog driver for PowerPC Book-E chips, such as the Freescale
 	  MPC85xx SOCs and the IBM PowerPC 440.
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index c0bc92d..a8dbceb3 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -15,12 +15,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/fs.h>
 #include <linux/smp.h>
-#include <linux/miscdevice.h>
-#include <linux/notifier.h>
 #include <linux/watchdog.h>
-#include <linux/uaccess.h>
 
 #include <asm/reg_booke.h>
 #include <asm/time.h>
@@ -45,7 +41,7 @@ u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
 #define WDTP_MASK	(TCR_WP_MASK)
 #endif
 
-static DEFINE_SPINLOCK(booke_wdt_lock);
+#ifdef CONFIG_PPC_FSL_BOOK3E
 
 /* For the specified period, determine the number of seconds
  * corresponding to the reset time.  There will be a watchdog
@@ -86,6 +82,24 @@ static unsigned int sec_to_period(unsigned int secs)
 	return 0;
 }
 
+#define MAX_WDT_TIMEOUT		period_to_sec(1)
+
+#else /* CONFIG_PPC_FSL_BOOK3E */
+
+static unsigned long long period_to_sec(unsigned int period)
+{
+	return period;
+}
+
+static unsigned int sec_to_period(unsigned int secs)
+{
+	return secs;
+}
+
+#define MAX_WDT_TIMEOUT		3	/* from Kconfig */
+
+#endif /* !CONFIG_PPC_FSL_BOOK3E */
+
 static void __booke_wdt_set(void *data)
 {
 	u32 val;
@@ -107,9 +121,11 @@ static void __booke_wdt_ping(void *data)
 	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
 }
 
-static void booke_wdt_ping(void)
+static int booke_wdt_ping(struct watchdog_device *wdog)
 {
 	on_each_cpu(__booke_wdt_ping, NULL, 0);
+
+	return 0;
 }
 
 static void __booke_wdt_enable(void *data)
@@ -146,152 +162,81 @@ static void __booke_wdt_disable(void *data)
 
 }
 
-static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
+static void __booke_wdt_start(struct watchdog_device *wdog)
 {
-	booke_wdt_ping();
-	return count;
+	on_each_cpu(__booke_wdt_enable, NULL, 0);
+	pr_debug("watchdog enabled (timeout = %u sec)\n", wdog->timeout);
 }
 
-static struct watchdog_info ident = {
-	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-	.identity = "PowerPC Book-E Watchdog",
-};
-
-static long booke_wdt_ioctl(struct file *file,
-				unsigned int cmd, unsigned long arg)
+static int booke_wdt_start(struct watchdog_device *wdog)
 {
-	u32 tmp = 0;
-	u32 __user *p = (u32 __user *)arg;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(p, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-		return put_user(0, p);
-	case WDIOC_GETBOOTSTATUS:
-		/* XXX: something is clearing TSR */
-		tmp = mfspr(SPRN_TSR) & TSR_WRS(3);
-		/* returns CARDRESET if last reset was caused by the WDT */
-		return put_user((tmp ? WDIOF_CARDRESET : 0), p);
-	case WDIOC_SETOPTIONS:
-		if (get_user(tmp, p))
-			return -EFAULT;
-		if (tmp == WDIOS_ENABLECARD) {
-			booke_wdt_ping();
-			break;
-		} else
-			return -EINVAL;
-		return 0;
-	case WDIOC_KEEPALIVE:
-		booke_wdt_ping();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(tmp, p))
-			return -EFAULT;
-#ifdef	CONFIG_PPC_FSL_BOOK3E
-		/* period of 1 gives the largest possible timeout */
-		if (tmp > period_to_sec(1))
-			return -EINVAL;
-		booke_wdt_period = sec_to_period(tmp);
-#else
-		booke_wdt_period = tmp;
-#endif
-		booke_wdt_set();
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-#ifdef	CONFIG_FSL_BOOKE
-		return put_user(period_to_sec(booke_wdt_period), p);
-#else
-		return put_user(booke_wdt_period, p);
-#endif
-	default:
-		return -ENOTTY;
-	}
-
-	return 0;
-}
-
-/* wdt_is_active stores whether or not the /dev/watchdog device is opened */
-static unsigned long wdt_is_active;
-
-static int booke_wdt_open(struct inode *inode, struct file *file)
-{
-	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &wdt_is_active))
-		return -EBUSY;
-
-	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
-		on_each_cpu(__booke_wdt_enable, NULL, 0);
-		pr_debug("watchdog enabled (timeout = %llu sec)\n",
-			 period_to_sec(booke_wdt_period));
+		__booke_wdt_start(wdog);
 	}
-	spin_unlock(&booke_wdt_lock);
-
-	return nonseekable_open(inode, file);
+	return 0;
 }
 
-static int booke_wdt_release(struct inode *inode, struct file *file)
+static int booke_wdt_stop(struct watchdog_device *wdog)
 {
-#ifndef CONFIG_WATCHDOG_NOWAYOUT
-	/* Normally, the watchdog is disabled when /dev/watchdog is closed, but
-	 * if CONFIG_WATCHDOG_NOWAYOUT is defined, then it means that the
-	 * watchdog should remain enabled.  So we disable it only if
-	 * CONFIG_WATCHDOG_NOWAYOUT is not defined.
-	 */
 	on_each_cpu(__booke_wdt_disable, NULL, 0);
 	booke_wdt_enabled = 0;
 	pr_debug("watchdog disabled\n");
-#endif
 
-	clear_bit(0, &wdt_is_active);
+	return 0;
+}
+
+static int booke_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				 unsigned int timeout)
+{
+	if (timeout > MAX_WDT_TIMEOUT)
+		return -EINVAL;
+	booke_wdt_period = sec_to_period(timeout);
+	wdt_dev->timeout = timeout;
+	booke_wdt_set();
 
 	return 0;
 }
 
-static const struct file_operations booke_wdt_fops = {
+static struct watchdog_info booke_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "PowerPC Book-E Watchdog",
+};
+
+static struct watchdog_ops booke_wdt_ops = {
 	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = booke_wdt_write,
-	.unlocked_ioctl = booke_wdt_ioctl,
-	.open = booke_wdt_open,
-	.release = booke_wdt_release,
+	.start = booke_wdt_start,
+	.stop = booke_wdt_stop,
+	.ping = booke_wdt_ping,
+	.set_timeout = booke_wdt_set_timeout,
 };
 
-static struct miscdevice booke_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &booke_wdt_fops,
+static struct watchdog_device booke_wdt_dev = {
+	.info = &booke_wdt_info,
+	.ops = &booke_wdt_ops,
+	.min_timeout = 1,
+	.max_timeout = 0xFFFF
 };
 
 static void __exit booke_wdt_exit(void)
 {
-	misc_deregister(&booke_wdt_miscdev);
+	watchdog_unregister_device(&booke_wdt_dev);
 }
 
 static int __init booke_wdt_init(void)
 {
 	int ret = 0;
+	bool nowayout = WATCHDOG_NOWAYOUT;
 
 	pr_info("powerpc book-e watchdog driver loaded\n");
-	ident.firmware_version = cur_cpu_spec->pvr_value;
-
-	ret = misc_register(&booke_wdt_miscdev);
-	if (ret) {
-		pr_err("cannot register device (minor=%u, ret=%i)\n",
-		       WATCHDOG_MINOR, ret);
-		return ret;
-	}
-
-	spin_lock(&booke_wdt_lock);
-	if (booke_wdt_enabled == 1) {
-		pr_info("watchdog enabled (timeout = %llu sec)\n",
-			period_to_sec(booke_wdt_period));
-		on_each_cpu(__booke_wdt_enable, NULL, 0);
-	}
-	spin_unlock(&booke_wdt_lock);
+	booke_wdt_info.firmware_version = cur_cpu_spec->pvr_value;
+	booke_wdt_set_timeout(&booke_wdt_dev,
+			      period_to_sec(CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT));
+	watchdog_set_nowayout(&booke_wdt_dev, nowayout);
+	if (booke_wdt_enabled)
+		__booke_wdt_start(&booke_wdt_dev);
+
+	ret = watchdog_register_device(&booke_wdt_dev);
 
 	return ret;
 }
-- 
1.7.9.7

