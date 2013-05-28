Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab3E1VXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:23:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59569 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab3E1VXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:23:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 27/78] ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices
Date: Tue, 28 May 2013 14:19:36 -0700
Message-Id: <1369776027-17859-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index cf07e28..b0197a9 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -73,11 +73,11 @@
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

