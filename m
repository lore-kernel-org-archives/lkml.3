Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab3FCWMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:12:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12159 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab3FCWLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:54 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=92vXL3gvV50A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=9tFmeKWsIIMA:10 a=xNf9USuDAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=2KMo9-giAAAA:8 a=eyp7A-Iwpl73VPO_AH8A:9 a=YPTUPuSgPjgA:10 a=MSl-tDqOz04A:10 a=x2szoZtqnggA:10 a=-ydLB92TkmgA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221152.485334854@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sebastian Reichel <sre@debian.org>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [02/65] ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI
 devices
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0002-ARM-OMAP-RX-51-change-probe-order-of-touchscreen-and.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit e65f131a14726e5f1b880a528271a52428e5b3a5 ]

Commit 9fdca9df (spi: omap2-mcspi: convert to module_platform_driver)
broke the SPI display/panel driver probe on RX-51/N900. The exact cause is
not fully understood, but it seems to be related to the probe order. SPI
communication to the panel driver (spi1.2) fails unless the touchscreen
(spi1.0) has been probed/initialized before. When the omap2-mcspi driver
was converted to a platform driver, it resulted in that the devices are
probed immediately after the board registers them in the order they are
listed in the board file.

Fix the issue by moving the touchscreen before the panel in the SPI
device list.

The patch fixes the following failure:

[    1.260955] acx565akm spi1.2: invalid display ID
[    1.265899] panel-acx565akm display0: acx_panel_probe panel detect error
[    1.273071] omapdss CORE error: driver probe failed: -19

Tested-by: Sebastian Reichel <sre@debian.org>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Pali Rohár <pali.rohar@gmail.com>
Cc: Joni Lapilainen <joni.lapilainen@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index df2534d..364e36a 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -67,11 +67,11 @@
 #define LIS302_IRQ1_GPIO 181
 #define LIS302_IRQ2_GPIO 180  /* Not yet in use */
 
-/* list all spi devices here */
+/* List all SPI devices here. Note that the list/probe order seems to matter! */
 enum {
 	RX51_SPI_WL1251,
-	RX51_SPI_MIPID,		/* LCD panel */
 	RX51_SPI_TSC2005,	/* Touch Controller */
+	RX51_SPI_MIPID,		/* LCD panel */
 };
 
 static struct wl12xx_platform_data wl1251_pdata;
-- 
1.7.10.4


