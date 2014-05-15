Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaEOUi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:38:59 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45803 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaEOUi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:38:56 -0400
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
Subject: [PATCH v3 5/6] watchdog: moxart: Register reboot handler with watchdog subsystem
Date: Thu, 15 May 2014 13:38:23 -0700
Message-Id: <1400186304-1691-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
References: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The watchdog subsystem now provides an API to trigger a system reboot.
Register with it.

Tested-by: Jonas Jensen <jonas.jensen@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Drop reboot mode and cmd string parameters from API
v2: No change

 drivers/watchdog/moxart_wdt.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/moxart_wdt.c b/drivers/watchdog/moxart_wdt.c
index 4aa3a8a..9698c83 100644
--- a/drivers/watchdog/moxart_wdt.c
+++ b/drivers/watchdog/moxart_wdt.c
@@ -19,8 +19,6 @@
 #include <linux/watchdog.h>
 #include <linux/moduleparam.h>
 
-#include <asm/system_misc.h>
-
 #define REG_COUNT			0x4
 #define REG_MODE			0x8
 #define REG_ENABLE			0xC
@@ -31,15 +29,15 @@ struct moxart_wdt_dev {
 	unsigned int clock_frequency;
 };
 
-static struct moxart_wdt_dev *moxart_restart_ctx;
-
 static int heartbeat;
 
-static void moxart_wdt_restart(enum reboot_mode reboot_mode, const char *cmd)
+static void moxart_wdt_reboot(struct watchdog_device *wdt_dev)
 {
-	writel(1, moxart_restart_ctx->base + REG_COUNT);
-	writel(0x5ab9, moxart_restart_ctx->base + REG_MODE);
-	writel(0x03, moxart_restart_ctx->base + REG_ENABLE);
+	struct moxart_wdt_dev *moxart_wdt = watchdog_get_drvdata(wdt_dev);
+
+	writel(1, moxart_wdt->base + REG_COUNT);
+	writel(0x5ab9, moxart_wdt->base + REG_MODE);
+	writel(0x03, moxart_wdt->base + REG_ENABLE);
 }
 
 static int moxart_wdt_stop(struct watchdog_device *wdt_dev)
@@ -81,6 +79,7 @@ static const struct watchdog_ops moxart_wdt_ops = {
 	.owner          = THIS_MODULE,
 	.start          = moxart_wdt_start,
 	.stop           = moxart_wdt_stop,
+	.reboot		= moxart_wdt_reboot,
 	.set_timeout    = moxart_wdt_set_timeout,
 };
 
@@ -136,9 +135,6 @@ static int moxart_wdt_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	moxart_restart_ctx = moxart_wdt;
-	arm_pm_restart = moxart_wdt_restart;
-
 	dev_dbg(dev, "Watchdog enabled (heartbeat=%d sec, nowayout=%d)\n",
 		moxart_wdt->dev.timeout, nowayout);
 
@@ -149,7 +145,6 @@ static int moxart_wdt_remove(struct platform_device *pdev)
 {
 	struct moxart_wdt_dev *moxart_wdt = platform_get_drvdata(pdev);
 
-	arm_pm_restart = NULL;
 	moxart_wdt_stop(&moxart_wdt->dev);
 	watchdog_unregister_device(&moxart_wdt->dev);
 
-- 
1.9.1

