Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbbAIJwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:52:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38108 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756569AbbAIJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:51:41 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 6/8] clocksource: atmel-st: properly initialize driver
Date: Fri,  9 Jan 2015 10:51:32 +0100
Message-Id: <1420797094-9444-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clocksource_of_init to initialize the system timer instead of relying on a
custom function.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/board-dt-rm9200.c | 7 -------
 arch/arm/mach-at91/generic.h         | 3 ---
 drivers/clocksource/timer-atmel-st.c | 4 +++-
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index 76dfe8f9af50..d9a45f49c208 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -24,19 +24,12 @@
 
 #include "generic.h"
 
-static void __init at91rm9200_dt_timer_init(void)
-{
-	of_clk_init(NULL);
-	at91rm9200_timer_init();
-}
-
 static const char *at91rm9200_dt_board_compat[] __initdata = {
 	"atmel,at91rm9200",
 	NULL
 };
 
 DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
-	.init_time      = at91rm9200_dt_timer_init,
 	.map_io		= at91_map_io,
 	.init_early	= at91rm9200_dt_initialize,
 	.dt_compat	= at91rm9200_dt_board_compat,
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index d53324210adf..fc12f3d4b93c 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -29,9 +29,6 @@ extern void __init at91_dt_initialize(void);
 extern void __init at91_sysirq_mask_rtc(u32 rtc_base);
 extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
 
- /* Timer */
-extern void at91rm9200_timer_init(void);
-
 /* idle */
 extern void at91sam9_idle(void);
 
diff --git a/drivers/clocksource/timer-atmel-st.c b/drivers/clocksource/timer-atmel-st.c
index 522583d6cc78..ed0267f1c892 100644
--- a/drivers/clocksource/timer-atmel-st.c
+++ b/drivers/clocksource/timer-atmel-st.c
@@ -232,7 +232,7 @@ err:
 /*
  * ST (system timer) module supports both clockevents and clocksource.
  */
-void __init at91rm9200_timer_init(void)
+static void __init atmel_st_timer_init(struct device_node *node)
 {
 	/* For device tree enabled device: initialize here */
 	of_at91rm9200_st_init();
@@ -261,3 +261,5 @@ void __init at91rm9200_timer_init(void)
 
 	arm_pm_restart = at91rm9200_restart;
 }
+CLOCKSOURCE_OF_DECLARE(atmel_st_timer, "atmel,at91rm9200-st",
+		       atmel_st_timer_init);
-- 
2.1.0

