Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3AONej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:34:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46288 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab3AONbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:31:07 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 01/10] video: da8xx-fb: fb_check_var enhancement
Date: Tue, 15 Jan 2013 19:01:36 +0530
Message-ID: <4cc2a1179d24e067623b9516946e222b22d79f7e.1358250489.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358250489.git.afzal@ti.com>
References: <cover.1358250489.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether "struct fb_var_screeninfo" fields are sane, if not
update it to be within allowed limits.

If user sends down buggy "var" values, this will bring those within
allowable limits. And fb_set_par is not supposed to change "var"
values, fb_check_var has to ensure that values are proper.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 0810939..d00dd17 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -888,6 +888,9 @@ static int fb_check_var(struct fb_var_screeninfo *var,
 			struct fb_info *info)
 {
 	int err = 0;
+	struct da8xx_fb_par *par = info->par;
+	int bpp = var->bits_per_pixel >> 3;
+	unsigned long line_size = var->xres_virtual * bpp;
 
 	if (var->bits_per_pixel > 16 && lcd_revision == LCD_VERSION_1)
 		return -EINVAL;
@@ -955,6 +958,21 @@ static int fb_check_var(struct fb_var_screeninfo *var,
 	var->green.msb_right = 0;
 	var->blue.msb_right = 0;
 	var->transp.msb_right = 0;
+
+	if (line_size * var->yres_virtual > par->vram_size)
+		var->yres_virtual = par->vram_size / line_size;
+
+	if (var->yres > var->yres_virtual)
+		var->yres = var->yres_virtual;
+
+	if (var->xres > var->xres_virtual)
+		var->xres = var->xres_virtual;
+
+	if (var->xres + var->xoffset > var->xres_virtual)
+		var->xoffset = var->xres_virtual - var->xres;
+	if (var->yres + var->yoffset > var->yres_virtual)
+		var->yoffset = var->yres_virtual - var->yres;
+
 	return err;
 }
 
-- 
1.7.9.5

