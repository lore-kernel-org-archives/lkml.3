Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaDES1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 14:27:45 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46854 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaDES1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 14:27:43 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 1/2] watchdog: w83627hf_wdt: Add early_disable module parameter
Date: Sat,  5 Apr 2014 11:27:36 -0700
Message-Id: <1396722457-8275-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add early_disable module parameter to match functionality previously
available in the w83697hf_wdt driver.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/w83627hf_wdt.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index b1da0c1..7165704 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -64,6 +64,10 @@ MODULE_PARM_DESC(nowayout,
 		"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+static int early_disable;
+module_param(early_disable, int, 0);
+MODULE_PARM_DESC(early_disable, "Disable watchdog at boot time (default=0)");
+
 /*
  *	Kernel methods.
  */
@@ -208,9 +212,14 @@ static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
 
 	t = superio_inb(cr_wdt_timeout);
 	if (t != 0) {
-		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
-			wdog->timeout);
-		superio_outb(cr_wdt_timeout, wdog->timeout);
+		if (early_disable) {
+			pr_warn("Stopping previously enabled watchdog until userland kicks in\n");
+			superio_outb(cr_wdt_timeout, 0);
+		} else {
+			pr_info("Watchdog already running. Resetting timeout to %d sec\n",
+				wdog->timeout);
+			superio_outb(cr_wdt_timeout, wdog->timeout);
+		}
 	}
 
 	/* set second mode & disable keyboard turning off watchdog */
-- 
1.7.9.7

