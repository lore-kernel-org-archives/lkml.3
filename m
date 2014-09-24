Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaIXQUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:20:20 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:40446 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaIXQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:20:19 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, daniel.lezcano@linaro.org,
        tglx@linutronix.de
Cc: festevam@gmail.com, jingchang.lu@freescale.com, bpringlemeir@nbsps.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 3/3] ARM: vf610: Add ARM Global Timer clocksource option
Date: Wed, 24 Sep 2014 18:20:10 +0200
Message-Id: <1411575610-20895-4-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411575610-20895-1-git-send-email-stefan@agner.ch>
References: <1411575610-20895-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ARM Global Timer as clocksource/scheduler clock option and
use it as default scheduler clock. This leaves the PIT timer for
other users e.g. the secondary Cortex-M4 core. Also, the Global Timer
has double the precission (running at pheripheral clock compared to
IPG clock) and a 64-bit incrementing counter register. We still keep
the PIT timer as an secondary option in case the ARM Global Timer is
not available.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/Kconfig | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 11b2957..9482f58 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -633,12 +633,29 @@ config SOC_VF610
 	bool "Vybrid Family VF610 support"
 	select ARM_GIC
 	select PINCTRL_VF610
-	select VF_PIT_TIMER
 	select PL310_ERRATA_769419 if CACHE_L2X0
 
 	help
 	  This enable support for Freescale Vybrid VF610 processor.
 
+choice
+	prompt "Clocksource for scheduler clock"
+	depends on SOC_VF610
+	default ARM_GLOBAL_TIMER
+
+	config ARM_GLOBAL_TIMER
+		bool "Use ARM Global Timer"
+		select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
+		help
+		  Use the ARM Global Timer as clocksource
+
+	config VF_PIT_TIMER
+		bool "Use PIT timer"
+		help
+		  Use SoC Periodic Interrupt Timer (PIT) as clocksource
+
+endchoice
+
 endif
 
 source "arch/arm/mach-imx/devices/Kconfig"
-- 
2.1.0

