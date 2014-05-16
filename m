Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaEPBWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 21:22:51 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42065 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaEPBWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 21:22:49 -0400
Date: Thu, 15 May 2014 18:22:34 -0700
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
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/6] watchdog: Add API to trigger reboots
Message-ID: <20140516012234.GA16592@roeck-us.net>
References: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
 <1400186304-1691-2-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400186304-1691-2-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
v4: Protect accesses to wdd_reboot_dev with spinlock to avoid potential
    race conditions.
    Drop Acked-by and Tested-by tags because changes are too significant
    and warrant re-evaluation and re-testing.
v3: Drop reboot mode and cmd string parameters from API
v2: Remove unnecessary check for ops in reboot function

 drivers/watchdog/watchdog_core.c | 27 +++++++++++++++++++++++++++
 include/linux/watchdog.h         |  8 ++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index cec9b55..e61f4ed 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -37,12 +37,27 @@
 #include <linux/idr.h>		/* For ida_* macros */
 #include <linux/err.h>		/* For IS_ERR macros */
 #include <linux/of.h>		/* For of_get_timeout_sec */
+#include <linux/spinlock.h>	/* For spinlock */
 
 #include "watchdog_core.h"	/* For watchdog_dev_register/... */
 
 static DEFINE_IDA(watchdog_ida);
 static struct class *watchdog_class;
 
+static DEFINE_SPINLOCK(wdd_reboot_lock);
+static struct watchdog_device *wdd_reboot_dev;
+
+void watchdog_do_reboot(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdd_reboot_lock, flags);
+	if (wdd_reboot_dev)
+		wdd_reboot_dev->ops->reboot(wdd_reboot_dev);
+	spin_unlock_irqrestore(&wdd_reboot_lock, flags);
+}
+EXPORT_SYMBOL(watchdog_do_reboot);
+
 static void watchdog_check_min_max_timeout(struct watchdog_device *wdd)
 {
 	/*
@@ -111,6 +126,7 @@ EXPORT_SYMBOL_GPL(watchdog_init_timeout);
 int watchdog_register_device(struct watchdog_device *wdd)
 {
 	int ret, id, devno;
+	unsigned long flags;
 
 	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
 		return -EINVAL;
@@ -162,6 +178,11 @@ int watchdog_register_device(struct watchdog_device *wdd)
 		return ret;
 	}
 
+	spin_lock_irqsave(&wdd_reboot_lock, flags);
+	if (wdd->ops->reboot && !wdd_reboot_dev)
+		wdd_reboot_dev = wdd;
+	spin_unlock_irqrestore(&wdd_reboot_lock, flags);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(watchdog_register_device);
@@ -177,10 +198,16 @@ void watchdog_unregister_device(struct watchdog_device *wdd)
 {
 	int ret;
 	int devno;
+	unsigned long flags;
 
 	if (wdd == NULL)
 		return;
 
+	spin_lock_irqsave(&wdd_reboot_lock, flags);
+	if (wdd == wdd_reboot_dev)
+		wdd_reboot_dev = NULL;
+	spin_unlock_irqrestore(&wdd_reboot_lock, flags);
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

