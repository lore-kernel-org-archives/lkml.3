Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184Ab3BMXK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:10:28 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:34929 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997Ab3BMXK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:10:27 -0500
Date: Thu, 14 Feb 2013 00:10:07 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, fabio.porcedda@gmail.com, JM.Lin@atmel.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/8] watchdog/at91sam9_wdt: Convert to use the watchdog framework
Message-ID: <20130213231007.GE7867@spo001.leaseweb.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com> <1359702386-21284-4-git-send-email-wenyou.yang@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359702386-21284-4-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wenyou,

> According to Documentation/watchdog/convert_drivers_to_kernel_api.txt,
> remove the file_operations struct, miscdevice, and obsolete includes
> 
> Since the at91sam watchdog inherent characteristics, add the watchdog
> operations: at91wdt_start, at91wdt_stop and at91wdt_ping.
> 

This code not only converts the watchdog to the new framework,
but it also adds the is_enable related code changes which should
be a seperate patch.

So I took your original patch and changed it to the below at91sam9_wdt
watchdog conversion patch. Note: this is also without Fabio's timeout-sec
patch, this one needs to come after the conversion.

Please test this patch and let me know if this works (the watchdog should
behave the same before as after this patch).

Kind regards,
Wim.
---
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 5e8a034..c36fcb0 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -125,6 +125,7 @@ config AT91RM9200_WATCHDOG
 config AT91SAM9X_WATCHDOG
 	tristate "AT91SAM9X / AT91CAP9 watchdog"
 	depends on ARCH_AT91 && !ARCH_AT91RM9200
+	select WATCHDOG_CORE
 	help
 	  Watchdog timer embedded into AT91SAM9X and AT91CAP9 chips. This will
 	  reboot your system when the timeout is reached.
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 6dad954..53fa325 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -18,11 +18,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/errno.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
@@ -68,19 +66,17 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+static struct watchdog_device at91_wdt_dev;
 static void at91_ping(unsigned long data);
 
 static struct {
 	void __iomem *base;
 	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
-	unsigned long open;
-	char expect_close;
 	struct timer_list timer;	/* The timer that pings the watchdog */
 } at91wdt_private;
 
 /* ......................................................................... */
 
-
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
@@ -95,39 +91,37 @@ static inline void at91_wdt_reset(void)
 static void at91_ping(unsigned long data)
 {
 	if (time_before(jiffies, at91wdt_private.next_heartbeat) ||
-			(!nowayout && !at91wdt_private.open)) {
+	    (!watchdog_active(&at91_wdt_dev))) {
 		at91_wdt_reset();
 		mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 	} else
 		pr_crit("I will reset your machine !\n");
 }
 
-/*
- * Watchdog device is opened, and watchdog starts running.
- */
-static int at91_wdt_open(struct inode *inode, struct file *file)
+static int at91_wdt_ping(struct watchdog_device *wdd)
 {
-	if (test_and_set_bit(0, &at91wdt_private.open))
-		return -EBUSY;
+	/* calculate when the next userspace timeout will be */
+	at91wdt_private.next_heartbeat = jiffies + wdd->timeout * HZ;
+	return 0;
+}
 
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
+static int at91_wdt_start(struct watchdog_device *wdd)
+{
+	/* calculate the next userspace timeout and modify the timer */
+	at91_wdt_ping(wdd);
 	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
-
-	return nonseekable_open(inode, file);
+	return 0;
 }
 
-/*
- * Close the watchdog device.
- */
-static int at91_wdt_close(struct inode *inode, struct file *file)
+static int at91_wdt_stop(struct watchdog_device *wdd)
 {
-	clear_bit(0, &at91wdt_private.open);
-
-	/* stop internal ping */
-	if (!at91wdt_private.expect_close)
-		del_timer(&at91wdt_private.timer);
+	/* The watchdog timer hardware can not be stopped... */
+	return 0;
+}
 
-	at91wdt_private.expect_close = 0;
+static int at91_wdt_set_timeout(struct watchdog_device *wdd, unsigned int new_timeout)
+{
+	wdd->timeout = new_timeout;
 	return 0;
 }
 
@@ -163,96 +157,27 @@ static int at91_wdt_settimeout(unsigned int timeout)
 	return 0;
 }
 
+/* ......................................................................... */
+
 static const struct watchdog_info at91_wdt_info = {
 	.identity	= DRV_NAME,
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
 						WDIOF_MAGICCLOSE,
 };
 
-/*
- * Handle commands from user-space.
- */
-static long at91_wdt_ioctl(struct file *file,
-		unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_value;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &at91_wdt_info,
-				    sizeof(at91_wdt_info)) ? -EFAULT : 0;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_value, p))
-			return -EFAULT;
-
-		heartbeat = new_value;
-		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-
-		return put_user(new_value, p);  /* return current value */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(heartbeat, p);
-	}
-	return -ENOTTY;
-}
-
-/*
- * Pat the watchdog whenever device is written to.
- */
-static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len,
-								loff_t *ppos)
-{
-	if (!len)
-		return 0;
-
-	/* Scan for magic character */
-	if (!nowayout) {
-		size_t i;
-
-		at91wdt_private.expect_close = 0;
-
-		for (i = 0; i < len; i++) {
-			char c;
-			if (get_user(c, data + i))
-				return -EFAULT;
-			if (c == 'V') {
-				at91wdt_private.expect_close = 42;
-				break;
-			}
-		}
-	}
-
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-
-	return len;
-}
-
-/* ......................................................................... */
-
-static const struct file_operations at91wdt_fops = {
-	.owner			= THIS_MODULE,
-	.llseek			= no_llseek,
-	.unlocked_ioctl	= at91_wdt_ioctl,
-	.open			= at91_wdt_open,
-	.release		= at91_wdt_close,
-	.write			= at91_wdt_write,
+static const struct watchdog_ops at91_wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	at91_wdt_start,
+	.stop =		at91_wdt_stop,
+	.ping =		at91_wdt_ping,
+	.set_timeout =	at91_wdt_set_timeout,
 };
 
-static struct miscdevice at91wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &at91wdt_fops,
+static struct watchdog_device at91_wdt_dev = {
+	.info =		&at91_wdt_info,
+	.ops =		&at91_wdt_ops,
+	.min_timeout =	1,
+	.max_timeout =	0xFFFF,
 };
 
 static int __init at91wdt_probe(struct platform_device *pdev)
@@ -260,10 +185,6 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	struct resource	*r;
 	int res;
 
-	if (at91wdt_miscdev.parent)
-		return -EBUSY;
-	at91wdt_miscdev.parent = &pdev->dev;
-
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -ENODEV;
@@ -273,16 +194,20 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	at91_wdt_dev.timeout = heartbeat;
+	at91_wdt_dev.parent = &pdev->dev;
+	watchdog_set_nowayout(&at91_wdt_dev, nowayout);
+
 	/* Set watchdog */
 	res = at91_wdt_settimeout(ms_to_ticks(WDT_HW_TIMEOUT * 1000));
 	if (res)
 		return res;
 
-	res = misc_register(&at91wdt_miscdev);
+	res = watchdog_register_device(&at91_wdt_dev);
 	if (res)
 		return res;
 
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
+	at91wdt_private.next_heartbeat = jiffies + wdd->timeout * HZ;
 	setup_timer(&at91wdt_private.timer, at91_ping, 0);
 	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 
@@ -294,13 +219,12 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 
 static int __exit at91wdt_remove(struct platform_device *pdev)
 {
-	int res;
+	watchdog_unregister_device(&at91_wdt_dev);
 
-	res = misc_deregister(&at91wdt_miscdev);
-	if (!res)
-		at91wdt_miscdev.parent = NULL;
+	pr_warn("I quit now, hardware will probably reboot!\n");
+	del_timer(&at91wdt_private.timer);
 
-	return res;
+	return 0;
 }
 
 #if defined(CONFIG_OF)
@@ -337,4 +261,3 @@ module_exit(at91sam_wdt_exit);
 MODULE_AUTHOR("Renaud CERRATO <r.cerrato@til-technologies.fr>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT91SAM9x processors");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
