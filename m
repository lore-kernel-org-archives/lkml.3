Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab3GOP11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:27:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:58111 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab3GOP1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:27:24 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com, Thomas Petazzoni <thomas@free-electrons.com>,
        plagnioj@jcrosoft.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/3] video: mxsfb: fix color settings for 18bit data bus and 32bpp
Date: Mon, 15 Jul 2013 17:27:00 +0200
Message-Id: <1373902022-20439-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373902022-20439-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1373902022-20439-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hector Palacios <hector.palacios@digi.com>

For a combination of 18bit LCD data bus width and a color
mode of 32bpp, the driver was setting the color mapping to
rgb666, which is wrong, as the color in memory realy has an
rgb888 layout.

This patch also removes the setting of flag CTRL_DF24 that
makes the driver dimiss the upper 2 bits when handling 32/24bpp
colors in a diplay with 18bit data bus width. This flag made
true color images display wrong in such configurations.

Finally, the color mapping rgb666 has also been removed as nobody
is using it and high level applications like Qt5 cannot work
with it either.

Reference: https://lkml.org/lkml/2013/5/23/220
Signed-off-by: Hector Palacios <hector.palacios@digi.com>
Acked-by: Juergen Beisert <jbe@pengutronix.de>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/video/mxsfb.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 3ba3771..dc09ebe 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -239,24 +239,6 @@ static const struct fb_bitfield def_rgb565[] = {
 	}
 };
 
-static const struct fb_bitfield def_rgb666[] = {
-	[RED] = {
-		.offset = 16,
-		.length = 6,
-	},
-	[GREEN] = {
-		.offset = 8,
-		.length = 6,
-	},
-	[BLUE] = {
-		.offset = 0,
-		.length = 6,
-	},
-	[TRANSP] = {	/* no support for transparency */
-		.length = 0,
-	}
-};
-
 static const struct fb_bitfield def_rgb888[] = {
 	[RED] = {
 		.offset = 16,
@@ -309,9 +291,6 @@ static int mxsfb_check_var(struct fb_var_screeninfo *var,
 			break;
 		case STMLCDIF_16BIT:
 		case STMLCDIF_18BIT:
-			/* 24 bit to 18 bit mapping */
-			rgb = def_rgb666;
-			break;
 		case STMLCDIF_24BIT:
 			/* real 24 bit */
 			rgb = def_rgb888;
@@ -453,11 +432,6 @@ static int mxsfb_set_par(struct fb_info *fb_info)
 			return -EINVAL;
 		case STMLCDIF_16BIT:
 		case STMLCDIF_18BIT:
-			/* 24 bit to 18 bit mapping */
-			ctrl |= CTRL_DF24; /* ignore the upper 2 bits in
-					    *  each colour component
-					    */
-			break;
 		case STMLCDIF_24BIT:
 			/* real 24 bit */
 			break;
-- 
1.8.3.2

