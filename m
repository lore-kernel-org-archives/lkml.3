Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaHTQzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:55:46 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:52941 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaHTQzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:55:44 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org (open list:WATCHDOG DEVICE D...),
        linux-kernel@vger.kernel.org (open list)
Cc: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] powerpc: booke_wdt: Fix build error as a module
Date: Wed, 20 Aug 2014 12:55:44 -0400
Message-Id: <1408553745-3536-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building booke_wdt fails when trying to build as a module as there is no
early_param() in module. Fix by using module_param() instead of early_param().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/booke_wdt.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 08a7853..65f5e9f 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -30,8 +30,6 @@
  * occur, and the final time the board will reset.
  */
 
-u32 booke_wdt_enabled;
-u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
 
 #ifdef	CONFIG_PPC_FSL_BOOK3E
 #define WDTP(x)		((((x)&0x3)<<30)|(((x)&0x3c)<<15))
@@ -41,27 +39,10 @@ u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
 #define WDTP_MASK	(TCR_WP_MASK)
 #endif
 
-/* Checks wdt=x and wdt_period=xx command-line option */
-notrace int __init early_parse_wdt(char *p)
-{
-	if (p && strncmp(p, "0", 1) != 0)
-		booke_wdt_enabled = 1;
-
-	return 0;
-}
-early_param("wdt", early_parse_wdt);
-
-int __init early_parse_wdt_period(char *p)
-{
-	unsigned long ret;
-	if (p) {
-		if (!kstrtol(p, 0, &ret))
-			booke_wdt_period = ret;
-	}
-
-	return 0;
-}
-early_param("wdt_period", early_parse_wdt_period);
+static bool booke_wdt_enabled = true;
+module_param(booke_wdt_enabled, bool, 0444);
+static int  booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
+module_param(booke_wdt_period, int, 0444);
 
 #ifdef CONFIG_PPC_FSL_BOOK3E
 
@@ -259,5 +240,6 @@ static int __init booke_wdt_init(void)
 module_init(booke_wdt_init);
 module_exit(booke_wdt_exit);
 
+MODULE_ALIAS("booke_wdt");
 MODULE_DESCRIPTION("PowerPC Book-E watchdog driver");
 MODULE_LICENSE("GPL");
-- 
1.9.1

