Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaEOUip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:38:45 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50281 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbaEOUil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:38:41 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 1/6] watchdog: Add API to trigger reboots
Date: Thu, 15 May 2014 13:38:19 -0700
Message-Id: <1400186304-1691-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
References: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
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

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Jonas Jensen <jonas.jensen@gmail.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Drop reboot mode and cmd string parameters from API
v2: Remove unnecessary check for ops in reboot function

 drivers/watchdog/watchdog_core.c | 15 +++++++++++++++
 include/linux/watchdog.h         |  8 ++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index cec9b55..24ce780 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -43,6 +43,15 @@
 static DEFINE_IDA(watchdog_ida);
 static struct class *watchdog_class;
 
+static struct watchdog_device *wdd_reboot_dev;
+
+void watchdog_do_reboot(void)
+{
+	if (wdd_reboot_dev)
+		wdd_reboot_dev->ops->reboot(wdd_reboot_dev);
+}
+EXPORT_SYMBOL(watchdog_do_reboot);
+
 static void watchdog_check_min_max_timeout(struct watchdog_device *wdd)
 {
 	/*
@@ -162,6 +171,9 @@ int watchdog_register_device(struct watchdog_device *wdd)
 		return ret;
 	}
 
+	if (wdd->ops->reboot)
+		wdd_reboot_dev = wdd;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(watchdog_register_device);
@@ -181,6 +193,9 @@ void watchdog_unregister_device(struct watchdog_device *wdd)
 	if (wdd == NULL)
 		return;
 
+	if (wdd == wdd_reboot_dev)
+		wdd_reboot_dev = NULL;
+
 	devno = wdd->cdev.dev;
 	ret = watchdog_dev_unregister(wdd);
 	if (ret)
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 2a3038e..1e9da0a 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -23,6 +23,7 @@ struct watchdog_device;
  * @start:	The routine for starting the watchdog device.
  * @stop:	The routine for stopping the watchdog device.
  * @ping:	The routine that sends a keepalive ping to the watchdog device.
+ * @reboot:	The routine for rebooting the system
  * @status:	The routine that shows the status of the watchdog device.
  * @set_timeout:The routine for setting the watchdog devices timeout value.
  * @get_timeleft:The routine that get's the time that's left before a reset.
@@ -42,6 +43,7 @@ struct watchdog_ops {
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	void (*reboot)(struct watchdog_device *);
 	unsigned int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, unsigned int);
 	unsigned int (*get_timeleft)(struct watchdog_device *);
@@ -142,4 +144,10 @@ extern int watchdog_init_timeout(struct watchdog_device *wdd,
 extern int watchdog_register_device(struct watchdog_device *);
 extern void watchdog_unregister_device(struct watchdog_device *);
 
+#ifdef CONFIG_WATCHDOG_CORE
+extern void watchdog_do_reboot(void);
+#else
+static inline void watchdog_do_reboot(void) { }
+#endif
+
 #endif  /* ifndef _LINUX_WATCHDOG_H */
-- 
1.9.1

