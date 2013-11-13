Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab3KMIeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:34:20 -0500
Received: from mo6.mail-out.ovh.net ([178.32.228.6]:40539 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab3KMIeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:34:10 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/6] ARM: at91: prepare sama5 dt boards transition to common clk
Date: Wed, 13 Nov 2013 09:32:07 +0100
Message-Id: <1384331532-2951-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384331532-2951-1-git-send-email-b.brezillon@overkiz.com>
References: <1384331532-2951-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4128956434315049185
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
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
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-dt-sama5.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index bf00d15..075ec05 100644
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
 
@@ -72,7 +80,7 @@ static const char *sama5_dt_board_compat[] __initdata = {
 
 DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= sama5_dt_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic5_handle_irq,
 	.init_early	= at91_dt_initialize,
-- 
1.7.9.5

