Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbbAIJwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:52:40 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756493AbbAIJvl (ORCPT
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
Subject: [PATCH v2 5/8] ARM: at91: move the restart function to the system timer driver
Date: Fri,  9 Jan 2015 10:51:31 +0100
Message-Id: <1420797094-9444-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restarting on an at91rm9200 is handled by using the system timer. Move that
function to the system timer driver.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91rm9200.c      | 11 -----------
 drivers/clocksource/timer-atmel-st.c | 12 ++++++++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index b52916947535..4ea889cd6091 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -15,7 +15,6 @@
 
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
-#include <mach/at91_st.h>
 #include <mach/hardware.h>
 
 #include "soc.h"
@@ -30,15 +29,6 @@ static void at91rm9200_idle(void)
 	at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
 }
 
-static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
-{
-	/*
-	 * Perform a hardware reset with the use of the Watchdog timer.
-	 */
-	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
-	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
-}
-
 /* --------------------------------------------------------------------
  *  AT91RM9200 processor initialization
  * -------------------------------------------------------------------- */
@@ -51,7 +41,6 @@ static void __init at91rm9200_map_io(void)
 static void __init at91rm9200_initialize(void)
 {
 	arm_pm_idle = at91rm9200_idle;
-	arm_pm_restart = at91rm9200_restart;
 }
 
 
diff --git a/drivers/clocksource/timer-atmel-st.c b/drivers/clocksource/timer-atmel-st.c
index 51761f8927b7..522583d6cc78 100644
--- a/drivers/clocksource/timer-atmel-st.c
+++ b/drivers/clocksource/timer-atmel-st.c
@@ -29,6 +29,7 @@
 #include <linux/of_irq.h>
 
 #include <asm/mach/time.h>
+#include <asm/system_misc.h>
 
 #include <mach/at91_st.h>
 #include <mach/hardware.h>
@@ -180,6 +181,15 @@ static struct clock_event_device clkevt = {
 	.set_mode	= clkevt32k_mode,
 };
 
+static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
+{
+	/*
+	 * Perform a hardware reset with the use of the Watchdog timer.
+	 */
+	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
+	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
+}
+
 void __iomem *at91_st_base;
 EXPORT_SYMBOL_GPL(at91_st_base);
 
@@ -248,4 +258,6 @@ void __init at91rm9200_timer_init(void)
 
 	/* register clocksource */
 	clocksource_register_hz(&clk32k, AT91_SLOW_CLOCK);
+
+	arm_pm_restart = at91rm9200_restart;
 }
-- 
2.1.0

