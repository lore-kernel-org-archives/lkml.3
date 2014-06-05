Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaFEFPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:15:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaFEEUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Friedt <chrisfriedt@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 3.4 012/214] drm/vmwgfx: correct fb_fix_screeninfo.line_length
Date: Wed,  4 Jun 2014 21:16:15 -0700
Message-Id: <20140605041641.394122176@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Friedt <chrisfriedt@gmail.com>

commit aa6de142c901cd2d90ef08db30ae87da214bedcc upstream.

Previously, the vmwgfx_fb driver would allow users to call FBIOSET_VINFO, but it would not adjust
the FINFO properly, resulting in distorted screen rendering. The patch corrects that behaviour.

See https://bugs.gentoo.org/show_bug.cgi?id=494794 for examples.

Signed-off-by: Christopher Friedt <chrisfriedt@gmail.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -147,7 +147,7 @@ static int vmw_fb_check_var(struct fb_va
 	}
 
 	if (!vmw_kms_validate_mode_vram(vmw_priv,
-					info->fix.line_length,
+					var->xres * var->bits_per_pixel/8,
 					var->yoffset + var->yres)) {
 		DRM_ERROR("Requested geom can not fit in framebuffer\n");
 		return -EINVAL;
@@ -162,6 +162,8 @@ static int vmw_fb_set_par(struct fb_info
 	struct vmw_private *vmw_priv = par->vmw_priv;
 	int ret;
 
+	info->fix.line_length = info->var.xres * info->var.bits_per_pixel/8;
+
 	ret = vmw_kms_write_svga(vmw_priv, info->var.xres, info->var.yres,
 				 info->fix.line_length,
 				 par->bpp, par->depth);
@@ -177,6 +179,7 @@ static int vmw_fb_set_par(struct fb_info
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_POSITION_Y, info->var.yoffset);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_WIDTH, info->var.xres);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_HEIGHT, info->var.yres);
+		vmw_write(vmw_priv, SVGA_REG_BYTES_PER_LINE, info->fix.line_length);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_ID, SVGA_ID_INVALID);
 	}
 


