Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbaC1ApS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 20:45:18 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35078 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbaC1ApQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 20:45:16 -0400
From: Christopher Friedt <chrisfriedt@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, Christopher Friedt <chrisfriedt@gmail.com>
Subject: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
Date: Thu, 27 Mar 2014 20:45:02 -0400
Message-Id: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, the vmwgfx_fb driver would allow users to call FBIOSET_VINFO, but it would not adjust
the FINFO properly, resulting in distorted screen rendering. The patch corrects that behaviour.

See https://bugs.gentoo.org/show_bug.cgi?id=494794 for examples.

Signed-off-by: Christopher Friedt <chrisfriedt@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
index ed5ce2a..021b522 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -147,7 +147,7 @@ static int vmw_fb_check_var(struct fb_var_screeninfo *var,
 	}
 
 	if (!vmw_kms_validate_mode_vram(vmw_priv,
-					info->fix.line_length,
+					var->xres * var->bits_per_pixel/8,
 					var->yoffset + var->yres)) {
 		DRM_ERROR("Requested geom can not fit in framebuffer\n");
 		return -EINVAL;
@@ -162,6 +162,8 @@ static int vmw_fb_set_par(struct fb_info *info)
 	struct vmw_private *vmw_priv = par->vmw_priv;
 	int ret;
 
+	info->fix.line_length = info->var.xres * info->var.bits_per_pixel/8;
+
 	ret = vmw_kms_write_svga(vmw_priv, info->var.xres, info->var.yres,
 				 info->fix.line_length,
 				 par->bpp, par->depth);
@@ -177,6 +179,7 @@ static int vmw_fb_set_par(struct fb_info *info)
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_POSITION_Y, info->var.yoffset);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_WIDTH, info->var.xres);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_HEIGHT, info->var.yres);
+		vmw_write(vmw_priv, SVGA_REG_BYTES_PER_LINE, info->fix.line_length);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_ID, SVGA_ID_INVALID);
 	}
 
-- 
1.8.3.2

