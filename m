Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3HQU65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 16:58:57 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56639 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3HQU6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 16:58:54 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: =?UTF-8?q?=5BPATCH=20v3=201/8=5D=20watchdog=3A=20w83627hf=3A=20Convert=20to=20watchdog=20infrastructure?=
Date: Sat, 17 Aug 2013 13:58:39 -0700
Message-Id: <1376773126-2717-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
References: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/Kconfig        |    1 +
 drivers/watchdog/w83627hf_wdt.c |  225 +++++++++------------------------------
 2 files changed, 51 insertions(+), 175 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 362085d..c73db85 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -858,6 +858,7 @@ config VIA_WDT
 config W83627HF_WDT
 	tristate "W83627HF/W83627DHG Watchdog Timer"
 	depends on X86
+	select WATCHDOG_CORE
 	---help---
 	  This is the driver for the hardware watchdog on the W83627HF chipset
 	  as used in Advantech PC-9578 and Tyan S2721-533 motherboards
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 92f1326..51a22ab 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -1,6 +1,9 @@
 /*
  *	w83627hf/thf WDT driver
  *
+ *	(c) Copyright 2013 Guenter Roeck
+ *		converted to watchdog infrastructure
+ *
  *	(c) Copyright 2007 Vlad Drukker <vlad@storewiz.com>
  *		added support for W83627THF.
  *
@@ -31,42 +34,27 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <linux/fs.h>
 #include <linux/ioport.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
-#include <linux/spinlock.h>
 #include <linux/io.h>
-#include <linux/uaccess.h>
-
 
 #define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
-static unsigned long wdt_is_open;
-static char expect_close;
-static DEFINE_SPINLOCK(io_lock);
-
 /* You must set this - there is no sane way to probe for this board. */
 static int wdt_io = 0x2E;
 module_param(wdt_io, int, 0);
 MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
 
-static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
+static int timeout;			/* in seconds */
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout,
 		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
 				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
-static bool nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout,
-		"Watchdog cannot be stopped once started (default="
-				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
 /*
  *	Kernel methods.
  */
@@ -110,7 +98,7 @@ static void w83627hf_unselect_wd_register(void)
 /* tyan motherboards seem to set F5 to 0x4C ?
  * So explicitly init to appropriate value. */
 
-static void w83627hf_init(void)
+static void w83627hf_init(struct watchdog_device *wdog)
 {
 	unsigned char t;
 
@@ -120,8 +108,8 @@ static void w83627hf_init(void)
 	t = inb_p(WDT_EFDR);      /* read CRF6 */
 	if (t != 0) {
 		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
-			timeout);
-		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
+			wdog->timeout);
+		outb_p(wdog->timeout, WDT_EFDR);	/* Write back to CRF6 */
 	}
 
 	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
@@ -141,10 +129,8 @@ static void w83627hf_init(void)
 	w83627hf_unselect_wd_register();
 }
 
-static void wdt_set_time(int timeout)
+static int wdt_set_time(unsigned int timeout)
 {
-	spin_lock(&io_lock);
-
 	w83627hf_select_wd_register();
 
 	outb_p(0xF6, WDT_EFER);    /* Select CRF6 */
@@ -152,34 +138,30 @@ static void wdt_set_time(int timeout)
 
 	w83627hf_unselect_wd_register();
 
-	spin_unlock(&io_lock);
+	return 0;
 }
 
-static int wdt_ping(void)
+static int wdt_start(struct watchdog_device *wdog)
 {
-	wdt_set_time(timeout);
-	return 0;
+	return wdt_set_time(wdog->timeout);
 }
 
-static int wdt_disable(void)
+static int wdt_stop(struct watchdog_device *wdog)
 {
-	wdt_set_time(0);
-	return 0;
+	return wdt_set_time(0);
 }
 
-static int wdt_set_heartbeat(int t)
+static int wdt_set_timeout(struct watchdog_device *wdog, unsigned int timeout)
 {
-	if (t < 1 || t > 255)
-		return -EINVAL;
-	timeout = t;
+	wdt_set_time(timeout);
+	wdog->timeout = timeout;
+
 	return 0;
 }
 
-static int wdt_get_time(void)
+static unsigned int wdt_get_time(struct watchdog_device *wdog)
 {
-	int timeleft;
-
-	spin_lock(&io_lock);
+	unsigned int timeleft;
 
 	w83627hf_select_wd_register();
 
@@ -188,124 +170,17 @@ static int wdt_get_time(void)
 
 	w83627hf_unselect_wd_register();
 
-	spin_unlock(&io_lock);
-
 	return timeleft;
 }
 
-static ssize_t wdt_write(struct file *file, const char __user *buf,
-						size_t count, loff_t *ppos)
-{
-	if (count) {
-		if (!nowayout) {
-			size_t i;
-
-			expect_close = 0;
-
-			for (i = 0; i != count; i++) {
-				char c;
-				if (get_user(c, buf + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		wdt_ping();
-	}
-	return count;
-}
-
-static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int timeval;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
-							WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "W83627HF WDT",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof(ident)))
-			return -EFAULT;
-		break;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_SETOPTIONS:
-	{
-		int options, retval = -EINVAL;
-
-		if (get_user(options, p))
-			return -EFAULT;
-		if (options & WDIOS_DISABLECARD) {
-			wdt_disable();
-			retval = 0;
-		}
-		if (options & WDIOS_ENABLECARD) {
-			wdt_ping();
-			retval = 0;
-		}
-		return retval;
-	}
-	case WDIOC_KEEPALIVE:
-		wdt_ping();
-		break;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(timeval, p))
-			return -EFAULT;
-		if (wdt_set_heartbeat(timeval))
-			return -EINVAL;
-		wdt_ping();
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
-	case WDIOC_GETTIMELEFT:
-		timeval = wdt_get_time();
-		return put_user(timeval, p);
-	default:
-		return -ENOTTY;
-	}
-	return 0;
-}
-
-static int wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &wdt_is_open))
-		return -EBUSY;
-	/*
-	 *	Activate
-	 */
-
-	wdt_ping();
-	return nonseekable_open(inode, file);
-}
-
-static int wdt_close(struct inode *inode, struct file *file)
-{
-	if (expect_close == 42)
-		wdt_disable();
-	else {
-		pr_crit("Unexpected close, not stopping watchdog!\n");
-		wdt_ping();
-	}
-	expect_close = 0;
-	clear_bit(0, &wdt_is_open);
-	return 0;
-}
-
 /*
  *	Notifier for system down
  */
-
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
-		wdt_disable();	/* Turn the WDT off */
+		wdt_set_time(0);	/* Turn the WDT off */
 
 	return NOTIFY_DONE;
 }
@@ -314,19 +189,26 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
  *	Kernel Interfaces
  */
 
-static const struct file_operations wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= wdt_write,
-	.unlocked_ioctl	= wdt_ioctl,
-	.open		= wdt_open,
-	.release	= wdt_close,
+static struct watchdog_info wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "W83627HF Watchdog",
+};
+
+static struct watchdog_ops wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = wdt_start,
+	.stop = wdt_stop,
+	.ping = wdt_start,
+	.set_timeout = wdt_set_timeout,
+	.get_timeleft = wdt_get_time,
 };
 
-static struct miscdevice wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &wdt_fops,
+static struct watchdog_device wdt_dev = {
+	.info = &wdt_info,
+	.ops = &wdt_ops,
+	.timeout = WATCHDOG_TIMEOUT,
+	.min_timeout = 1,
+	.max_timeout = 255,
 };
 
 /*
@@ -341,22 +223,19 @@ static struct notifier_block wdt_notifier = {
 static int __init wdt_init(void)
 {
 	int ret;
+	bool nowayout = WATCHDOG_NOWAYOUT;
 
 	pr_info("WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising\n");
 
-	if (wdt_set_heartbeat(timeout)) {
-		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info("timeout value must be 1 <= timeout <= 255, using %d\n",
-			WATCHDOG_TIMEOUT);
-	}
-
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
 		pr_err("I/O address 0x%04x already in use\n", wdt_io);
-		ret = -EIO;
-		goto out;
+		return -EIO;
 	}
 
-	w83627hf_init();
+	watchdog_init_timeout(&wdt_dev, timeout, NULL);
+	watchdog_set_nowayout(&wdt_dev, nowayout);
+
+	w83627hf_init(&wdt_dev);
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
@@ -364,28 +243,25 @@ static int __init wdt_init(void)
 		goto unreg_regions;
 	}
 
-	ret = misc_register(&wdt_miscdev);
-	if (ret != 0) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
+	ret = watchdog_register_device(&wdt_dev);
+	if (ret)
 		goto unreg_reboot;
-	}
 
 	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
-		timeout, nowayout);
+		wdt_dev.timeout, nowayout);
 
-out:
 	return ret;
+
 unreg_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 unreg_regions:
 	release_region(wdt_io, 1);
-	goto out;
+	return ret;
 }
 
 static void __exit wdt_exit(void)
 {
-	misc_deregister(&wdt_miscdev);
+	watchdog_unregister_device(&wdt_dev);
 	unregister_reboot_notifier(&wdt_notifier);
 	release_region(wdt_io, 1);
 }
@@ -396,4 +272,3 @@ module_exit(wdt_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pádraig  Brady <P@draigBrady.com>");
 MODULE_DESCRIPTION("w83627hf/thf WDT driver");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.7.9.7

