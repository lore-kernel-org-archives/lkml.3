Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935031AbaE2OPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:15:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59366 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933219AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christopher Friedt <chrisfriedt@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 052/103] drm/vmwgfx: correct fb_fix_screeninfo.line_length
Date: Thu, 29 May 2014 15:48:37 +0200
Message-Id: <e30112b512c46e5fbf87b444aadab5154bc8cceb.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christopher Friedt <chrisfriedt@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit aa6de142c901cd2d90ef08db30ae87da214bedcc upstream.

Previously, the vmwgfx_fb driver would allow users to call FBIOSET_VINFO, but it would not adjust
the FINFO properly, resulting in distorted screen rendering. The patch corrects that behaviour.

See https://bugs.gentoo.org/show_bug.cgi?id=494794 for examples.

Signed-off-by: Christopher Friedt <chrisfriedt@gmail.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
index ed5ce2a41bbf..021b5227e783 100644
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
1.9.3

