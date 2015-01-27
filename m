Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbbA0SHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:07:41 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10566 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273AbbA0SHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:07:40 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/7] ARM: at91: at91rm9200: set idle and restart from rm9200_dt_device_init()
Date: Tue, 27 Jan 2015 19:07:20 +0100
Message-ID: <18db7d680c8f526fb90198777fbb34222d74d606.1422381280.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1422381280.git.nicolas.ferre@atmel.com>
References: <cover.1422381280.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Setup arm_pm_idle and arm_pm_restart function pointers from
rm9200_dt_device_init() function to simplify the at91rm9200 initialization
process.
This same move is already done for the sam9s.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
[nicolas.ferre@atmel.com: adapt patch to newer series]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91rm9200.c      | 14 --------------
 arch/arm/mach-at91/board-dt-rm9200.c | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index 3be1963f5c56..ae0d5f0eb108 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -22,25 +22,11 @@
 #include "generic.h"
 
 
-static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
-{
-	/*
-	 * Perform a hardware reset with the use of the Watchdog timer.
-	 */
-	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
-	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
-}
 
 /* --------------------------------------------------------------------
  *  AT91RM9200 processor initialization
  * -------------------------------------------------------------------- */
 
-static void __init at91rm9200_initialize(void)
-{
-	arm_pm_idle = at91rm9200_idle;
-	arm_pm_restart = at91rm9200_restart;
-}
 
 AT91_SOC_START(at91rm9200)
-	.init = at91rm9200_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index d47c4433444d..5fcd1c73ece0 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -22,9 +22,21 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
+#include <asm/system_misc.h>
+
+#include <mach/at91_st.h>
 
 #include "generic.h"
 
+static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
+{
+	/*
+	 * Perform a hardware reset with the use of the Watchdog timer.
+	 */
+	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
+	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
+}
+
 static void __init at91rm9200_dt_timer_init(void)
 {
 	of_clk_init(NULL);
@@ -35,6 +47,8 @@ static void __init rm9200_dt_device_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
+	arm_pm_idle = at91rm9200_idle;
+	arm_pm_restart = at91rm9200_restart;
 	at91_rm9200_pm_init();
 }
 
-- 
2.1.3

