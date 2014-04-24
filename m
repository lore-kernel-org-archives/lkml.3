Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaDXJtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:49:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46811 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaDXIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Friedt <chrisfriedt@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/182] drm/vmwgfx: correct fb_fix_screeninfo.line_length
Date: Thu, 24 Apr 2014 09:50:43 +0100
Message-Id: <1398329507-5911-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Friedt <chrisfriedt@gmail.com>

commit aa6de142c901cd2d90ef08db30ae87da214bedcc upstream.

Previously, the vmwgfx_fb driver would allow users to call FBIOSET_VINFO, but it would not adjust
the FINFO properly, resulting in distorted screen rendering. The patch corrects that behaviour.

See https://bugs.gentoo.org/show_bug.cgi?id=494794 for examples.

Signed-off-by: Christopher Friedt <chrisfriedt@gmail.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

