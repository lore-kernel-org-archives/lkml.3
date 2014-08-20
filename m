Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaHTAqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:46:20 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36631 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaHTAqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:46:15 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v7 07/11] watchdog: sunxi: Register restart handler with kernel restart handler
Date: Tue, 19 Aug 2014 17:45:34 -0700
Message-Id: <1408495538-27480-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel core now provides an API to trigger a system restart.
Register with it instead of setting arm_pm_restart.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heiko Stuebner <heiko@sntech.de>
---
v7: Added patch to series. Necessary since the restart handler in the driver
    is now available upstream.

 drivers/watchdog/sunxi_wdt.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index 60deb9d..480bb55 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -21,14 +21,13 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 
-#include <asm/system_misc.h>
-
 #define WDT_MAX_TIMEOUT         16
 #define WDT_MIN_TIMEOUT         1
 #define WDT_MODE_TIMEOUT(n)     ((n) << 3)
@@ -50,6 +49,7 @@ static unsigned int timeout = WDT_MAX_TIMEOUT;
 struct sunxi_wdt_dev {
 	struct watchdog_device wdt_dev;
 	void __iomem *wdt_base;
+	struct notifier_block restart_handler;
 };
 
 /*
@@ -74,24 +74,29 @@ static const int wdt_timeout_map[] = {
 	[16] = 0xB, /* 16s */
 };
 
-static void __iomem *reboot_wdt_base;
 
-static void sun4i_wdt_restart(enum reboot_mode mode, const char *cmd)
+static int sunxi_restart_handle(struct notifier_block *this, unsigned long mode,
+				void *cmd)
 {
+	struct sunxi_wdt_dev *sunxi_wdt = container_of(this,
+						       struct sunxi_wdt_dev,
+						       restart_handler);
+	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+
 	/* Enable timer and set reset bit in the watchdog */
-	writel(WDT_MODE_EN | WDT_MODE_RST_EN, reboot_wdt_base + WDT_MODE);
+	writel(WDT_MODE_EN | WDT_MODE_RST_EN, wdt_base + WDT_MODE);
 
 	/*
 	 * Restart the watchdog. The default (and lowest) interval
 	 * value for the watchdog is 0.5s.
 	 */
-	writel(WDT_CTRL_RELOAD, reboot_wdt_base + WDT_CTRL);
+	writel(WDT_CTRL_RELOAD, wdt_base + WDT_CTRL);
 
 	while (1) {
 		mdelay(5);
-		writel(WDT_MODE_EN | WDT_MODE_RST_EN,
-		       reboot_wdt_base + WDT_MODE);
+		writel(WDT_MODE_EN | WDT_MODE_RST_EN, wdt_base + WDT_MODE);
 	}
+	return NOTIFY_DONE;
 }
 
 static int sunxi_wdt_ping(struct watchdog_device *wdt_dev)
@@ -205,8 +210,12 @@ static int sunxi_wdt_probe(struct platform_device *pdev)
 	if (unlikely(err))
 		return err;
 
-	reboot_wdt_base = sunxi_wdt->wdt_base;
-	arm_pm_restart = sun4i_wdt_restart;
+	sunxi_wdt->restart_handler.notifier_call = sunxi_restart_handle;
+	sunxi_wdt->restart_handler.priority = 128;
+	err = register_restart_handler(&sunxi_wdt->restart_handler);
+	if (err)
+		dev_err(&pdev->dev,
+			"cannot register restart handler (err=%d)\n", err);
 
 	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
 			sunxi_wdt->wdt_dev.timeout, nowayout);
@@ -218,7 +227,7 @@ static int sunxi_wdt_remove(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
 
-	arm_pm_restart = NULL;
+	unregister_restart_handler(&sunxi_wdt->restart_handler);
 
 	watchdog_unregister_device(&sunxi_wdt->wdt_dev);
 	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, NULL);
-- 
1.9.1

