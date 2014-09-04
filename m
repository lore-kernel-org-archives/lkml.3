Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaIDQYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:24:48 -0400
Received: from v032797.home.net.pl ([89.161.177.31]:53965 "HELO
	v032797.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750980AbaIDQYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:24:46 -0400
Message-ID: <54089252.9060803@elproma.com.pl>
Date: Thu, 04 Sep 2014 18:24:50 +0200
From: =?windows-1250?Q?Janusz_U=BFycki?= <j.uzycki@elproma.com.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
CC: Wim Van Sebroeck <wim@iguana.be>
Subject: watchdog: WatchDog Timer Driver Core: ping a hardware watchdog in
 kernel's space [proposal]
References: <54088DC4.4020808@elproma.com.pl>
In-Reply-To: <54088DC4.4020808@elproma.com.pl>
X-Forwarded-Message-Id: <54088DC4.4020808@elproma.com.pl>
Content-Type: multipart/mixed;
 boundary="------------090204090207000004040208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090204090207000004040208
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Some applications require to start watchdog before userspace software.
This patch enables such feature. Only WATCHDOG_KERNEL_PING flag is necessary to enable it (attached example for stmp3xxx_rtc_wdt.c).
Moreover kernel's ping is re-enabled when userspace software closed watchdog using the magic character.
The features improves kernel's reliable if hardware watchdog is available.

* Can you comment the proposed patch?
* Shoud dynamic or static timer_list be used (small structure...)?
* I also added wdd->ops->ref/unref calls but I'm afraid that even original code is buggy in watchdog_dev.c.
Is any driver that uses the pointers?
In my opinion watchdog_open() should call wdd->ops->ref() before watchdog_start() and watchdog_release() should call wdd->ops->unref() before module_put().
Otherwise fault is possible if watchdog module is unloaded.
* I noticed that current watchdog core does not support suspend/resume case.
If you want to use suspend without the patch you need to close a watchdog in userspace using the magic character before suspend command.
With the patch you must to use WDIOC_SETOPTIONS ioctl and WDIOS_DISABLECARD/WDIOS_ENABLECARD.
Is there any other method to suspend with watchdog?

best regards
Janusz Uzycki


--------------090204090207000004040208
Content-Type: text/plain; charset=windows-1250;
 name="wdt_kernel_ping.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wdt_kernel_ping.diff"

Signed-off-by: Janusz Uzycki <j.uzycki@elproma.com.pl>

diff --git a/linux-3.14.17/drivers/watchdog/stmp3xxx_rtc_wdt.c b/linux-3.14.17/drivers/watchdog/stmp3xxx_rtc_wdt.c
index b4d6b34..52c5f1c 100644
--- a/linux-3.14.17/drivers/watchdog/stmp3xxx_rtc_wdt.c
+++ b/linux-3.14.17/drivers/watchdog/stmp3xxx_rtc_wdt.c
@@ -78,6 +78,7 @@ static int stmp3xxx_wdt_probe(struct platform_device *pdev)
 
 	stmp3xxx_wdd.timeout = clamp_t(unsigned, heartbeat, 1, STMP3XXX_MAX_TIMEOUT);
 
+	stmp3xxx_wdd.status |= WATCHDOG_KERNEL_PING;
 	ret = watchdog_register_device(&stmp3xxx_wdd);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "cannot register watchdog device\n");
diff --git a/linux-3.14.17/drivers/watchdog/watchdog_dev.c b/linux-3.14.17/drivers/watchdog/watchdog_dev.c
index 6aaefba..d4fae2c 100644
--- a/linux-3.14.17/drivers/watchdog/watchdog_dev.c
+++ b/linux-3.14.17/drivers/watchdog/watchdog_dev.c
@@ -41,6 +41,8 @@
 #include <linux/miscdevice.h>	/* For handling misc devices */
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
+#include <linux/slab.h>		/* for kernel ping timer (dynamic) */
+#include <linux/jiffies.h>	/* for kernel ping timer */
 
 #include "watchdog_core.h"
 
@@ -277,6 +279,34 @@ out_ioctl:
 	return err;
 }
 
+/* kernel ping feature */
+static void watchdog_kping_timer_cb(unsigned long data)
+{
+	struct watchdog_device *wdd = (struct watchdog_device *)data;
+	if (test_bit(WDOG_KERNEL_PING, &wdd->status) && !test_bit(WDOG_DEV_OPEN, &wdd->status)) {
+		watchdog_ping(wdd);
+		/* call next ping a second or 0.5s before hardware timeout */
+		mod_timer(wdd->kping_timer, wdd->timeout > 1 ?
+				jiffies + (wdd->timeout - 1) * HZ : jiffies + HZ/2);
+	}
+}
+
+static void watchdog_kping_start(struct watchdog_device *wdd)
+{
+	if (wdd->ops->ref)
+		wdd->ops->ref(wdd);
+	watchdog_start(wdd);
+	watchdog_ping(wdd);
+	mod_timer(wdd->kping_timer, jiffies + HZ/2);
+}
+
+static void watchdog_kping_stop(struct watchdog_device *wdd)
+{
+	del_timer_sync(wdd->kping_timer);
+	if (wdd->ops->unref)
+		wdd->ops->unref(wdd);
+}
+
 /*
  *	watchdog_write: writes to the watchdog.
  *	@file: file from VFS
@@ -430,6 +460,9 @@ static int watchdog_open(struct inode *inode, struct file *file)
 	if (!try_module_get(wdd->ops->owner))
 		goto out;
 
+	if (test_bit(WDOG_KERNEL_PING, &wdd->status))
+		watchdog_kping_stop(wdd);
+
 	err = watchdog_start(wdd);
 	if (err < 0)
 		goto out_mod;
@@ -472,8 +505,13 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	if (!test_bit(WDOG_ACTIVE, &wdd->status))
 		err = 0;
 	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
-		 !(wdd->info->options & WDIOF_MAGICCLOSE))
-		err = watchdog_stop(wdd);
+		 !(wdd->info->options & WDIOF_MAGICCLOSE)) {
+		if (test_bit(WDOG_KERNEL_PING, &wdd->status)) {
+			watchdog_kping_start(wdd);
+			err = 0;
+		} else
+			err = watchdog_stop(wdd);
+	}
 
 	/* If the watchdog was not stopped, send a keepalive ping */
 	if (err < 0) {
@@ -524,6 +562,16 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 {
 	int err, devno;
 
+	if (test_bit(WDOG_KERNEL_PING, &watchdog->status)) {
+		if (!try_module_get(watchdog->ops->owner))
+			return -ENODEV;
+		watchdog->kping_timer = kzalloc(sizeof(*watchdog->kping_timer), GFP_KERNEL);
+		if (!watchdog->kping_timer)
+			return -ENOMEM;
+		setup_timer(watchdog->kping_timer, watchdog_kping_timer_cb, (unsigned long)watchdog);
+		watchdog_kping_start(watchdog);
+	}
+
 	if (watchdog->id == 0) {
 		old_wdd = watchdog;
 		watchdog_miscdev.parent = watchdog->parent;
@@ -575,6 +623,15 @@ int watchdog_dev_unregister(struct watchdog_device *watchdog)
 		misc_deregister(&watchdog_miscdev);
 		old_wdd = NULL;
 	}
+
+	if (test_bit(WDOG_KERNEL_PING, &watchdog->status) || watchdog->kping_timer) {
+		watchdog_kping_stop(watchdog);
+		watchdog_stop(watchdog);
+		kfree(watchdog->kping_timer);
+		watchdog->kping_timer = NULL;
+		watchdog_stop(watchdog);
+		module_put(watchdog->ops->owner);
+	}
 	return 0;
 }
 
diff --git a/linux-3.14.17/include/linux/watchdog.h b/linux-3.14.17/include/linux/watchdog.h
index 2a3038e..8cf9148 100644
--- a/linux-3.14.17/include/linux/watchdog.h
+++ b/linux-3.14.17/include/linux/watchdog.h
@@ -12,6 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
+#include <linux/timer.h>		/* for kernel ping timer */
 #include <uapi/linux/watchdog.h>
 
 struct watchdog_ops;
@@ -95,6 +96,9 @@ struct watchdog_device {
 #define WDOG_ALLOW_RELEASE	2	/* Did we receive the magic char ? */
 #define WDOG_NO_WAY_OUT		3	/* Is 'nowayout' feature set ? */
 #define WDOG_UNREGISTERED	4	/* Has the device been unregistered */
+#define WDOG_KERNEL_PING	5	/* Ping is done by kernel if device not opened by userland */
+	struct timer_list *kping_timer;	/* kernel ping timer */
+#define WATCHDOG_KERNEL_PING	(1 << WDOG_KERNEL_PING)
 };
 
 #ifdef CONFIG_WATCHDOG_NOWAYOUT


--------------090204090207000004040208--
