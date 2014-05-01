Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaEAPlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:41:52 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34454 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaEAPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:41:49 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 1/5] watchdog: Add API to trigger reboots
Date: Thu,  1 May 2014 08:41:29 -0700
Message-Id: <1398958893-30049-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware implements reboot through its watchdog hardware,
for example by triggering a watchdog timeout. Platform specific
code starts to spread into watchdog drivers, typically by setting
pointers to a callback functions which is then called from the
platform reset handler.

To simplify code and provide a unified API to trigger reboots by
watchdog drivers, provide a single API to trigger such reboots
through the watchdog subsystem.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/watchdog_core.c |   17 +++++++++++++++++
 include/linux/watchdog.h         |   11 +++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index cec9b55..4ec6e2f 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -43,6 +43,17 @@
 static DEFINE_IDA(watchdog_ida);
 static struct class *watchdog_class;
 
+static struct watchdog_device *wdd_reboot_dev;
+
+void watchdog_do_reboot(enum reboot_mode mode, const char *cmd)
+{
+	if (wdd_reboot_dev) {
+		if (wdd_reboot_dev->ops->reboot)
+			wdd_reboot_dev->ops->reboot(wdd_reboot_dev, mode, cmd);
+	}
+}
+EXPORT_SYMBOL(watchdog_do_reboot);
+
 static void watchdog_check_min_max_timeout(struct watchdog_device *wdd)
 {
 	/*
@@ -162,6 +173,9 @@ int watchdog_register_device(struct watchdog_device *wdd)
 		return ret;
 	}
 
+	if (wdd->ops->reboot)
+		wdd_reboot_dev = wdd;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(watchdog_register_device);
@@ -181,6 +195,9 @@ void watchdog_unregister_device(struct watchdog_device *wdd)
 	if (wdd == NULL)
 		return;
 
+	if (wdd == wdd_reboot_dev)
+		wdd_reboot_dev = NULL;
+
 	devno = wdd->cdev.dev;
 	ret = watchdog_dev_unregister(wdd);
 	if (ret)
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 2a3038e..0d204af 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -12,6 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
+#include <linux/reboot.h>
 #include <uapi/linux/watchdog.h>
 
 struct watchdog_ops;
@@ -23,6 +24,7 @@ struct watchdog_device;
  * @start:	The routine for starting the watchdog device.
  * @stop:	The routine for stopping the watchdog device.
  * @ping:	The routine that sends a keepalive ping to the watchdog device.
+ * @reboot:	The routine for rebooting the system
  * @status:	The routine that shows the status of the watchdog device.
  * @set_timeout:The routine for setting the watchdog devices timeout value.
  * @get_timeleft:The routine that get's the time that's left before a reset.
@@ -42,6 +44,8 @@ struct watchdog_ops {
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	void (*reboot)(struct watchdog_device *, enum reboot_mode,
+		       const char *);
 	unsigned int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, unsigned int);
 	unsigned int (*get_timeleft)(struct watchdog_device *);
@@ -142,4 +146,11 @@ extern int watchdog_init_timeout(struct watchdog_device *wdd,
 extern int watchdog_register_device(struct watchdog_device *);
 extern void watchdog_unregister_device(struct watchdog_device *);
 
+#ifdef CONFIG_WATCHDOG_CORE
+extern void watchdog_do_reboot(enum reboot_mode mode, const char *cmd);
+#else
+static inline void watchdog_do_reboot(enum reboot_mode mode,
+				      const char *cmd) { }
+#endif
+
 #endif  /* ifndef _LINUX_WATCHDOG_H */
-- 
1.7.9.7

