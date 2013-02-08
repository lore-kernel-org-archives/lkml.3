Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277Ab3BHQf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:35:58 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:35842 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212Ab3BHQfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:35:54 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <FlorianSchandinat@gmx.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <jhovold@gmail.com>,
        <jacmet@sunsite.dk>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/5] atmel_lcdfb: move lcdcon2 register access to compute_hozval
Date: Fri, 8 Feb 2013 17:35:17 +0100
Message-ID: <1b3f5134935c2476890db0a23d5b26cac7ed2d65.1360340791.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1360340791.git.nicolas.ferre@atmel.com>
References: <cover.1360340791.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

Pass atmel_lcd_info structure to compute_hozval and only do the register
access on SOCs that actually use it.

This will also simplify the removal of the cpu_is macros.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/video/atmel_lcdfb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index c5883ca..2effd35 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -193,14 +193,17 @@ static struct fb_fix_screeninfo atmel_lcdfb_fix __initdata = {
 	.accel		= FB_ACCEL_NONE,
 };
 
-static unsigned long compute_hozval(unsigned long xres, unsigned long lcdcon2)
+static unsigned long compute_hozval(struct atmel_lcdfb_info *sinfo,
+							unsigned long xres)
 {
+	unsigned long lcdcon2;
 	unsigned long value;
 
 	if (!(cpu_is_at91sam9261() || cpu_is_at91sam9g10()
 		|| cpu_is_at32ap7000()))
 		return xres;
 
+	lcdcon2 = lcdc_readl(sinfo, ATMEL_LCDC_LCDCON2);
 	value = xres;
 	if ((lcdcon2 & ATMEL_LCDC_DISTYPE) != ATMEL_LCDC_DISTYPE_TFT) {
 		/* STN display */
@@ -591,8 +594,7 @@ static int atmel_lcdfb_set_par(struct fb_info *info)
 	lcdc_writel(sinfo, ATMEL_LCDC_TIM2, value);
 
 	/* Horizontal value (aka line size) */
-	hozval_linesz = compute_hozval(info->var.xres,
-					lcdc_readl(sinfo, ATMEL_LCDC_LCDCON2));
+	hozval_linesz = compute_hozval(sinfo, info->var.xres);
 
 	/* Display size */
 	value = (hozval_linesz - 1) << ATMEL_LCDC_HOZVAL_OFFSET;
-- 
1.8.0

