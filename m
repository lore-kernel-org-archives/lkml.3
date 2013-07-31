Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab3GaN0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:26:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47109 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759863Ab3GaN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felipe Balbi" <balbi@ti.com>,
        "=?UTF-8?Q?Pali=20Roh=C3=A1r?=" <pali.rohar@gmail.com>,
        "Aaro Koskinen" <aaro.koskinen@iki.fi>,
        "Sebastian Reichel" <sre@debian.org>,
        "Tony Lindgren" <tony@atomide.com>,
        "Tomi Valkeinen" <tomi.valkeinen@ti.com>,
        "Joni Lapilainen" <joni.lapilainen@gmail.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.521602504@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [26/84] ARM: OMAP: RX-51: change probe order of touchscreen and
 panel SPI devices
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -58,11 +58,11 @@
 
 #define RX51_USB_TRANSCEIVER_RST_GPIO	67
 
-/* list all spi devices here */
+/* List all SPI devices here. Note that the list/probe order seems to matter! */
 enum {
 	RX51_SPI_WL1251,
-	RX51_SPI_MIPID,		/* LCD panel */
 	RX51_SPI_TSC2005,	/* Touch Controller */
+	RX51_SPI_MIPID,		/* LCD panel */
 };
 
 static struct wl12xx_platform_data wl1251_pdata;

