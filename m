Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbbAVQDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:03:01 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:48217 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbbAVQC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:02:56 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: fix PM initialization for newer SoCs
Date: Thu, 22 Jan 2015 17:03:04 +0100
Message-ID: <1421942584-2364-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421333971-7581-5-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421333971-7581-5-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer SoCs: at91sam9x5, at91sam9n12, sama5d3 and sama5d4 embed a DDR controller
and have a different PMC status register layout than the at91sam9g45. Create
another at91_sam9x5_pm_init() function to match this compatibility.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-dt-sam9.c  | 20 ++++++++++++++++++++
 arch/arm/mach-at91/board-dt-sama5.c |  2 +-
 arch/arm/mach-at91/pm.c             |  7 +++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 0fe1ced608c5..c8252ddac6f0 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -61,3 +61,23 @@ DT_MACHINE_START(at91sam9g45_dt, "Atmel AT91SAM9G45")
 	.init_machine	= sam9g45_dt_device_init,
 	.dt_compat	= at91_9g45_board_compat,
 MACHINE_END
+
+static void __init sam9x5_dt_device_init(void)
+{
+	at91_sam9x5_pm_init();
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char *at91_9x5_board_compat[] __initconst = {
+	"atmel,at91sam9x5",
+	"atmel,at91sam9n12",
+	NULL
+};
+
+DT_MACHINE_START(at91sam9x5_dt, "Atmel AT91SAM9")
+	/* Maintainer: Atmel */
+	.map_io		= at91_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= sam9x5_dt_device_init,
+	.dt_compat	= at91_9x5_board_compat,
+MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 44d372a22a29..b7338966c8ab 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -28,7 +28,7 @@
 
 static void __init sama5_dt_device_init(void)
 {
-	at91_sam9260_pm_init();
+	at91_sam9x5_pm_init();
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 81f2f12d3cc1..87c1fd8aa1b6 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -306,3 +306,10 @@ void __init at91_sam9g45_pm_init(void)
 	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
 	return at91_pm_init();
 }
+
+void __init at91_sam9x5_pm_init(void)
+{
+	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
+	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
+	return at91_pm_init();
+}
-- 
2.1.3

