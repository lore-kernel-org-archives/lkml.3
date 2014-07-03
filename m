Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbaGCOuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:50:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51847 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932384AbaGCOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:50:13 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH RESEND 16/18] AT91: pm: Remove show_reset_status function
Date: Thu,  3 Jul 2014 16:41:31 +0200
Message-Id: <1404398493-28907-17-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the reset and poweroff drivers are now implementing what the
show_reset_status function used to do. Hence, we can remove this rather hackish
function that prevents us from doing further cleanup.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/pm.c | 72 -------------------------------------------------
 1 file changed, 72 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index e95554532987..213606111d9a 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -34,79 +34,8 @@
 #include "pm.h"
 #include "gpio.h"
 
-/*
- * Show the reason for the previous system reset.
- */
-
-#include "at91_rstc.h"
-#include "at91_shdwc.h"
-
 static void (*at91_pm_standby)(void);
 
-static void __init show_reset_status(void)
-{
-	static char reset[] __initdata = "reset";
-
-	static char general[] __initdata = "general";
-	static char wakeup[] __initdata = "wakeup";
-	static char watchdog[] __initdata = "watchdog";
-	static char software[] __initdata = "software";
-	static char user[] __initdata = "user";
-	static char unknown[] __initdata = "unknown";
-
-	static char signal[] __initdata = "signal";
-	static char rtc[] __initdata = "rtc";
-	static char rtt[] __initdata = "rtt";
-	static char restore[] __initdata = "power-restored";
-
-	char *reason, *r2 = reset;
-	u32 reset_type, wake_type;
-
-	if (!at91_shdwc_base || !at91_rstc_base)
-		return;
-
-	reset_type = at91_rstc_read(AT91_RSTC_SR) & AT91_RSTC_RSTTYP;
-	wake_type = at91_shdwc_read(AT91_SHDW_SR);
-
-	switch (reset_type) {
-	case AT91_RSTC_RSTTYP_GENERAL:
-		reason = general;
-		break;
-	case AT91_RSTC_RSTTYP_WAKEUP:
-		/* board-specific code enabled the wakeup sources */
-		reason = wakeup;
-
-		/* "wakeup signal" */
-		if (wake_type & AT91_SHDW_WAKEUP0)
-			r2 = signal;
-		else {
-			r2 = reason;
-			if (wake_type & AT91_SHDW_RTTWK)	/* rtt wakeup */
-				reason = rtt;
-			else if (wake_type & AT91_SHDW_RTCWK)	/* rtc wakeup */
-				reason = rtc;
-			else if (wake_type == 0)	/* power-restored wakeup */
-				reason = restore;
-			else				/* unknown wakeup */
-				reason = unknown;
-		}
-		break;
-	case AT91_RSTC_RSTTYP_WATCHDOG:
-		reason = watchdog;
-		break;
-	case AT91_RSTC_RSTTYP_SOFTWARE:
-		reason = software;
-		break;
-	case AT91_RSTC_RSTTYP_USER:
-		reason = user;
-		break;
-	default:
-		reason = unknown;
-		break;
-	}
-	pr_info("AT91: Starting after %s %s\n", reason, r2);
-}
-
 static int at91_pm_valid_state(suspend_state_t state)
 {
 	switch (state) {
@@ -338,7 +267,6 @@ static int __init at91_pm_init(void)
 
 	suspend_set_ops(&at91_pm_ops);
 
-	show_reset_status();
 	return 0;
 }
 arch_initcall(at91_pm_init);
-- 
2.0.1

