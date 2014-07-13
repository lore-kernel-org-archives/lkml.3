Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaGMPbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 11:31:15 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44958 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaGMPa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 11:30:56 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v4 5/7] watchdog: moxart: Register restart handler with restart notifier
Date: Sun, 13 Jul 2014 08:30:29 -0700
Message-Id: <1405265431-4561-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405265431-4561-1-git-send-email-linux@roeck-us.net>
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel now provides an API to trigger a system restart.
Register with it instead of setting arm_pm_restart.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v4: Set notifier priority to 128.
v3: Move struct notifier_block into struct moxart_wdt_dev.
    Drop static variable previously needed to access struct moxart_wdt_dev
    from notifier function; use container_of instead.
v2: No change.

 drivers/watchdog/moxart_wdt.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/moxart_wdt.c b/drivers/watchdog/moxart_wdt.c
index 4aa3a8a..5080b50 100644
--- a/drivers/watchdog/moxart_wdt.c
+++ b/drivers/watchdog/moxart_wdt.c
@@ -15,12 +15,12 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/notifier.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/watchdog.h>
 #include <linux/moduleparam.h>
 
-#include <asm/system_misc.h>
-
 #define REG_COUNT			0x4
 #define REG_MODE			0x8
 #define REG_ENABLE			0xC
@@ -29,17 +29,22 @@ struct moxart_wdt_dev {
 	struct watchdog_device dev;
 	void __iomem *base;
 	unsigned int clock_frequency;
+	struct notifier_block restart_notifier;
 };
 
-static struct moxart_wdt_dev *moxart_restart_ctx;
-
 static int heartbeat;
 
-static void moxart_wdt_restart(enum reboot_mode reboot_mode, const char *cmd)
+static int moxart_restart_notify(struct notifier_block *this,
+				 unsigned long mode, void *cmd)
 {
-	writel(1, moxart_restart_ctx->base + REG_COUNT);
-	writel(0x5ab9, moxart_restart_ctx->base + REG_MODE);
-	writel(0x03, moxart_restart_ctx->base + REG_ENABLE);
+	struct moxart_wdt_dev *moxart_wdt = container_of(this,
+							 struct moxart_wdt_dev,
+							 restart_notifier);
+	writel(1, moxart_wdt->base + REG_COUNT);
+	writel(0x5ab9, moxart_wdt->base + REG_MODE);
+	writel(0x03, moxart_wdt->base + REG_ENABLE);
+
+	return NOTIFY_DONE;
 }
 
 static int moxart_wdt_stop(struct watchdog_device *wdt_dev)
@@ -136,8 +141,12 @@ static int moxart_wdt_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	moxart_restart_ctx = moxart_wdt;
-	arm_pm_restart = moxart_wdt_restart;
+	moxart_wdt->restart_notifier.notifier_call = moxart_restart_notify;
+	moxart_wdt->restart_notifier.priority = 128;
+	err = register_restart_notifier(&moxart_wdt->restart_notifier);
+	if (err)
+		dev_err(dev, "cannot register restart notifier (err=%d)\n",
+			err);
 
 	dev_dbg(dev, "Watchdog enabled (heartbeat=%d sec, nowayout=%d)\n",
 		moxart_wdt->dev.timeout, nowayout);
@@ -149,9 +158,8 @@ static int moxart_wdt_remove(struct platform_device *pdev)
 {
 	struct moxart_wdt_dev *moxart_wdt = platform_get_drvdata(pdev);
 
-	arm_pm_restart = NULL;
+	unregister_restart_notifier(&moxart_wdt->restart_notifier);
 	moxart_wdt_stop(&moxart_wdt->dev);
-	watchdog_unregister_device(&moxart_wdt->dev);
 
 	return 0;
 }
-- 
1.9.1

