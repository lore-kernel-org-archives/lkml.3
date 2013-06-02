Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3FBKN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 06:13:28 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48593 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3FBKNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:13:20 -0400
From: anish kumar <anish198519851985@gmail.com>
To: wim@iguana.be, linux@roeck-us.net
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [RFC]Watchdog:core: constant pinging until userspace timesout when delay very less
Date: Sun,  2 Jun 2013 15:43:07 +0530
Message-Id: <1370167987-14252-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain watchdog drivers use a timer to keep kicking the watchdog at
a rate of 0.5s (HZ/2) untill userspace times out.They do this as
we can't guarantee that watchdog will be pinged fast enough
for all system loads, especially if timeout is configured for
less than or equal to 1 second(basically small values).

As suggested by Wim Van Sebroeck & Guenter Roeck we should
add this functionality of individual watchdog drivers in the core
watchdog core.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/watchdog/watchdog_dev.c |   34 +++++++++++++++++++++++++++++-----
 include/linux/watchdog.h        |    1 +
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index faf4e18..0305803 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -41,9 +41,14 @@
 #include <linux/miscdevice.h>	/* For handling misc devices */
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
+#include <linux/timer.h>
+#include <linux/jiffies.h>
 
 #include "watchdog_core.h"
 
+/* Timer heartbeat (500ms) */
+#define WDT_TIMEOUT	(HZ/2) /* should this be sysfs? */
+
 /* the dev_t structure to store the dynamically allocated watchdog devices */
 static dev_t watchdog_devt;
 /* the watchdog device behind /dev/watchdog */
@@ -73,16 +78,33 @@ static int watchdog_ping(struct watchdog_device *wddev)
 	if (!watchdog_active(wddev))
 		goto out_ping;
 
-	if (wddev->ops->ping)
-		err = wddev->ops->ping(wddev);  /* ping the watchdog */
-	else
-		err = wddev->ops->start(wddev); /* restart watchdog */
+	/* should we check ping interval value i.e. timeout value
+	   if it is less than certain threshold then only we 
+	   should add this logic of periodic pinging? */
+	if (time_before(jiffies, (unsigned long)wddev->timeout)) {
+		if (wddev->ops->ping)
+			err = wddev->ops->ping(wddev);/* ping the watchdog */
+		else
+			err = wddev->ops->start(wddev);/* restart watchdog */
+		mod_timer(&wddev->timer, jiffies + WDT_TIMEOUT);
+	} else {
+		/*
+		 *what we should when we find out that userspace
+		 *has timed out?
+		 **/
+	}
 
 out_ping:
 	mutex_unlock(&wddev->lock);
 	return err;
 }
 
+static void watchdog_ping_wrapper(unsigned long priv)
+{
+	struct watchdog_device *wdd = (void *)priv;
+	watchdog_ping(wdd);
+}
+
 /*
  *	watchdog_start: wrapper to start the watchdog.
  *	@wddev: the watchdog device to start
@@ -109,7 +131,8 @@ static int watchdog_start(struct watchdog_device *wddev)
 	err = wddev->ops->start(wddev);
 	if (err == 0)
 		set_bit(WDOG_ACTIVE, &wddev->status);
-
+	
+	mod_timer(&wddev->timer, jiffies + WDT_TIMEOUT);
 out_start:
 	mutex_unlock(&wddev->lock);
 	return err;
@@ -552,6 +575,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 			old_wdd = NULL;
 		}
 	}
+	setup_timer(&watchdog->timer, 0, (long)watchdog_ping_wrapper);
 	return err;
 }
 
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 2a3038e..e5f18f7 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -84,6 +84,7 @@ struct watchdog_device {
 	const struct watchdog_ops *ops;
 	unsigned int bootstatus;
 	unsigned int timeout;
+	struct timer_list timer;
 	unsigned int min_timeout;
 	unsigned int max_timeout;
 	void *driver_data;
-- 
1.7.10.4

