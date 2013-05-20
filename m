Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3ETLFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:05:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3ETKxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 074/115] ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices
Date: Mon, 20 May 2013 11:51:14 +0100
Message-Id: <1369047116-9378-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit e65f131a14726e5f1b880a528271a52428e5b3a5 upstream.

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
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c | 4 ++--
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
1.8.1.2

