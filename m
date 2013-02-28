Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836Ab3B1Rvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 12:51:33 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44473 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759637Ab3B1Rvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 12:51:32 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: [PATCH] tidspbridge: Fix compilation
Date: Thu, 28 Feb 2013 18:51:06 +0100
Message-Id: <1362073866-8462-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix includes and use clk_prepare_enable/clk_disable_unprepare

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
---
 drivers/staging/tidspbridge/core/dsp-clock.c  |   16 ++++++++--------
 drivers/staging/tidspbridge/core/tiomap3430.c |    2 ++
 drivers/staging/tidspbridge/core/tiomap_io.c  |    2 ++
 drivers/staging/tidspbridge/core/wdt.c        |    8 ++++----
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 2f084e18..7d56693 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -221,7 +221,7 @@ int dsp_clk_enable(enum dsp_clk_id clk_id)
 
 	switch (get_clk_type(clk_id)) {
 	case IVA2_CLK:
-		clk_enable(iva2_clk);
+		clk_prepare_enable(iva2_clk);
 		break;
 	case GPT_CLK:
 		status = omap_dm_timer_start(timer[clk_id - 1]);
@@ -236,9 +236,9 @@ int dsp_clk_enable(enum dsp_clk_id clk_id)
 		dev_err(bridge, "ERROR: DSP requested to enable WDT3 clk\n");
 		break;
 	case SSI_CLK:
-		clk_enable(ssi.sst_fck);
-		clk_enable(ssi.ssr_fck);
-		clk_enable(ssi.ick);
+		clk_prepare_enable(ssi.sst_fck);
+		clk_prepare_enable(ssi.ssr_fck);
+		clk_prepare_enable(ssi.ick);
 
 		/*
 		 * The SSI module need to configured not to have the Forced
@@ -297,7 +297,7 @@ int dsp_clk_disable(enum dsp_clk_id clk_id)
 
 	switch (get_clk_type(clk_id)) {
 	case IVA2_CLK:
-		clk_disable(iva2_clk);
+		clk_disable_unprepare(iva2_clk);
 		break;
 	case GPT_CLK:
 		status = omap_dm_timer_stop(timer[clk_id - 1]);
@@ -314,9 +314,9 @@ int dsp_clk_disable(enum dsp_clk_id clk_id)
 	case SSI_CLK:
 		ssi_clk_prepare(false);
 		ssi_clk_prepare(false);
-		clk_disable(ssi.sst_fck);
-		clk_disable(ssi.ssr_fck);
-		clk_disable(ssi.ick);
+		clk_disable_unprepare(ssi.sst_fck);
+		clk_disable_unprepare(ssi.ssr_fck);
+		clk_disable_unprepare(ssi.ick);
 		break;
 	default:
 		dev_err(bridge, "Invalid clock id for disable\n");
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index f619fb3..1ba45b1 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -55,6 +55,8 @@
 #include "_tiomap_pwr.h"
 #include "tiomap_io.h"
 
+#include "../../../../arch/arm/mach-omap2/cm3xxx.h"
+
 /* Offset in shared mem to write to in order to synchronize start with DSP */
 #define SHMSYNCOFFSET 4		/* GPP byte offset */
 
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index f53ed98..b481bd8 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -33,6 +33,8 @@
 #include "_tiomap_pwr.h"
 #include "tiomap_io.h"
 
+#include "../../../../arch/arm/mach-omap2/cm3xxx.h"
+
 static u32 ul_ext_base;
 static u32 ul_ext_end;
 
diff --git a/drivers/staging/tidspbridge/core/wdt.c b/drivers/staging/tidspbridge/core/wdt.c
index 7ff0e6c..b7f2348 100644
--- a/drivers/staging/tidspbridge/core/wdt.c
+++ b/drivers/staging/tidspbridge/core/wdt.c
@@ -128,8 +128,8 @@ void dsp_wdt_enable(bool enable)
 	wdt_enable = enable;
 
 	if (enable) {
-		clk_enable(dsp_wdt.fclk);
-		clk_enable(dsp_wdt.iclk);
+		clk_prepare_enable(dsp_wdt.fclk);
+		clk_prepare_enable(dsp_wdt.iclk);
 		dsp_wdt.sm_wdt->wdt_setclocks = 1;
 		tmp = __raw_readl(dsp_wdt.reg_base + OMAP3_WDT3_ISR_OFFSET);
 		__raw_writel(tmp, dsp_wdt.reg_base + OMAP3_WDT3_ISR_OFFSET);
@@ -137,7 +137,7 @@ void dsp_wdt_enable(bool enable)
 	} else {
 		disable_irq(INT_34XX_WDT3_IRQ);
 		dsp_wdt.sm_wdt->wdt_setclocks = 0;
-		clk_disable(dsp_wdt.iclk);
-		clk_disable(dsp_wdt.fclk);
+		clk_disable_unprepare(dsp_wdt.iclk);
+		clk_disable_unprepare(dsp_wdt.fclk);
 	}
 }
-- 
1.7.10.4

