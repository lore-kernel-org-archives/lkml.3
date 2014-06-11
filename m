Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbaFKI7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:59:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33145 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbaFKI7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:59:17 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 33/36] ARM: OMAP2+: board-flash: Use gpmc_generic_init() for NOR
Date: Wed, 11 Jun 2014 11:56:38 +0300
Message-ID: <1402477001-31132-34-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't access any GPMC registers here. Use gpmc_generic_init()
to pass GPMC Chip Select settings, platform device and platform data
to the GPMC driver.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-flash.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-omap2/board-flash.c b/arch/arm/mach-omap2/board-flash.c
index b6885e4..617e441 100644
--- a/arch/arm/mach-omap2/board-flash.c
+++ b/arch/arm/mach-omap2/board-flash.c
@@ -41,7 +41,10 @@ static struct physmap_flash_data board_nor_data = {
 };
 
 static struct resource board_nor_resource = {
+	/* GPMC driver will fixup the resource, see gpmc_probe_legacy () */
 	.flags		= IORESOURCE_MEM,
+	.start		= 0,
+	.end		= FLASH_SIZE_SDPV1 - 1,	/* fixed @runtime for SDPV2 */
 };
 
 static struct platform_device board_nor_device = {
@@ -62,23 +65,14 @@ __init board_nor_init(struct mtd_partition *nor_parts, u8 nr_parts, u8 cs)
 	board_nor_data.parts	= nor_parts;
 	board_nor_data.nr_parts	= nr_parts;
 
-	/* Configure start address and size of NOR device */
-	if (omap_rev() >= OMAP3430_REV_ES1_0) {
-		err = gpmc_cs_request(cs, FLASH_SIZE_SDPV2 - 1,
-				(unsigned long *)&board_nor_resource.start);
-		board_nor_resource.end = board_nor_resource.start
-					+ FLASH_SIZE_SDPV2 - 1;
-	} else {
-		err = gpmc_cs_request(cs, FLASH_SIZE_SDPV1 - 1,
-				(unsigned long *)&board_nor_resource.start);
-		board_nor_resource.end = board_nor_resource.start
-					+ FLASH_SIZE_SDPV1 - 1;
-	}
-	if (err < 0) {
-		pr_err("NOR: Can't request GPMC CS\n");
-		return;
-	}
-	if (platform_device_register(&board_nor_device) < 0)
+	/* Configure size of NOR device */
+	if (omap_rev() >= OMAP3430_REV_ES1_0)
+		board_nor_resource.end = FLASH_SIZE_SDPV2 - 1;
+
+	err = gpmc_generic_init(cs, false,
+				NULL, NULL, NULL,
+				&board_nor_device, sizeof(board_nor_data));
+	if (err)
 		pr_err("Unable to register NOR device\n");
 }
 
-- 
1.8.3.2

