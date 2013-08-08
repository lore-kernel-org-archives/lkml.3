Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab3HHJVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:21:12 -0400
Received: from 1.mo4.mail-out.ovh.net ([178.33.248.196]:55711 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934111Ab3HHJVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:21:10 -0400
X-Greylist: delayed 3621 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 05:21:10 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 1/6] ARM: at91: prepare sama5 dt boards transition to common clk
Date: Thu,  8 Aug 2013 11:20:54 +0200
Message-Id: <1375953654-11168-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375951572-10829-1-git-send-email-b.brezillon@overkiz.com>
References: <1375951572-10829-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 7191404180964931763
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepare the transition to common clk for sama5 dt boards by
replacing the timer init callback.

Clocks registration cannot be done in early init callback (as formerly done
by the old clk implementation) because it requires dynamic allocation
which is not ready yet during early init.

In the other hand, at91 clocks must be registered before
at91sam926x_pit_init is called because PIT (Periodic Interval Timer) driver
request the master clk (mck).

A new function (at91sama5_dt_timer_init) is created to fullfil these needs.
This function registers all at91 clks using the dt definition before
calling the PIT init function.
The device tree clock registration is enabled only if common clk is
selected. Else the old clk registration is been done during
at91_dt_initialize call.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/board-dt-sama5.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index ad95f6a..10b6913 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -16,6 +16,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/phy.h>
+#include <linux/clk-provider.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -26,6 +27,13 @@
 #include "at91_aic.h"
 #include "generic.h"
 
+static void __init sama5_dt_timer_init(void)
+{
+#if defined(CONFIG_COMMON_CLK)
+	of_clk_init(NULL);
+#endif
+	at91sam926x_pit_init();
+}
 
 static const struct of_device_id irq_of_match[] __initconst = {
 
@@ -77,7 +85,7 @@ static const char *sama5_dt_board_compat[] __initdata = {
 
 DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= sama5_dt_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic5_handle_irq,
 	.init_early	= at91_dt_initialize,
-- 
1.7.9.5

