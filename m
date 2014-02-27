Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaB0LXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:23:51 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44177 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbaB0LWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:22:42 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 5/9] ARM: at91: prepare sam9 dt boards transition to common clk
Date: Thu, 27 Feb 2014 12:22:11 +0100
Message-Id: <1393500135-29636-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393500135-29636-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393500135-29636-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon@overkiz.com>

This patch prepare the transition to common clk for sam9 dt boards by
replacing the timer init callback.

Clocks registration cannot be done in early init callback (as formerly done
by the old clk implementation) because it requires dynamic allocation
which is not ready yet during early init.

In the other hand, at91 clocks must be registered before
at91sam926x_pit_init is called because PIT (Periodic Interval Timer) driver
request the master clk (mck).

A new function (at91sam9_dt_timer_init) is created to fullfil these needs.
This function registers all at91 clks using the dt definition before
calling the PIT init function.
The device tree clock registration is enabled only if common clk is
selected. Else the old clk registration is been done during
at91_dt_initialize call.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/board-dt-sam9.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 3dab868b02fa..575b0be66ca8 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -13,6 +13,7 @@
 #include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
+#include <linux/clk-provider.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -25,6 +26,14 @@
 #include "generic.h"
 
 
+static void __init sam9_dt_timer_init(void)
+{
+#if defined(CONFIG_COMMON_CLK)
+	of_clk_init(NULL);
+#endif
+	at91sam926x_pit_init();
+}
+
 static const struct of_device_id irq_of_match[] __initconst = {
 
 	{ .compatible = "atmel,at91rm9200-aic", .data = at91_aic_of_init },
@@ -43,7 +52,7 @@ static const char *at91_dt_board_compat[] __initdata = {
 
 DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= sam9_dt_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91_dt_initialize,
-- 
1.8.3.2

