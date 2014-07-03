Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbaGCNrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:47:17 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39931 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108AbaGCNrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:47:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: linux-fbdev@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH] video: da8xx-fb: preserve display width when changing HSYNC
Date: Thu,  3 Jul 2014 14:46:39 +0100
Message-Id: <1404395199-5726-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When looking at this driver for a client, I noticed the code that
configures the HSYNC pulse clobbers the display width in the same
register.  It only preserves the MS part of the width in bit 3 and zeros
the LS part of the width in bits 9 to 4.  This doesn't matter during
initialization as the width is configured afterwards, but subsequent use
of the FBIPUT_HSYNC ioctl would clobber the width.

Preserve bits 9 to 0 of LCD_RASTER_TIMING_0_REG when configuring the
horizontal sync.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
I haven't tested this change, but it's pretty trivial.
---
 drivers/video/fbdev/da8xx-fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/da8xx-fb.c b/drivers/video/fbdev/da8xx-fb.c
index 788f6b3..10c876c 100644
--- a/drivers/video/fbdev/da8xx-fb.c
+++ b/drivers/video/fbdev/da8xx-fb.c
@@ -419,7 +419,7 @@ static void lcd_cfg_horizontal_sync(int back_porch, int pulse_width,
 {
 	u32 reg;
 
-	reg = lcdc_read(LCD_RASTER_TIMING_0_REG) & 0xf;
+	reg = lcdc_read(LCD_RASTER_TIMING_0_REG) & 0x3ff;
 	reg |= (((back_porch-1) & 0xff) << 24)
 	    | (((front_porch-1) & 0xff) << 16)
 	    | (((pulse_width-1) & 0x3f) << 10);
-- 
2.0.0

