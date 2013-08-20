Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3HTQSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:18:01 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58147 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3HTQR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:17:59 -0400
Subject: [PATCH v3 trivial 7/7] DRM: cleanup: Remove unused `gamma_size'
Date: Tue, 20 Aug 2013 16:05:27 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <cfb0987b439f4723a4458ac47e20a47b-mfwitten@gmail.com>
In-Reply-To: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
References: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 15 Sep 2011 21:12:19 +0000

The value of `gamma_size' is guaranteed to be zero when
the following `if' statement is reached:

  if (gamma_size == 0)
  	gamma_size = fb_helper->crtc_info[i].mode_set.crtc->gamma_size

Thus, it could be reduced to just the following:

  gamma_size = fb_helper->crtc_info[i].mode_set.crtc->gamma_size

However, `gamma_size' is never actually used anywhere. So, what's
the point? This commit removes it entirely from the function.

Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 drivers/gpu/drm/drm_fb_helper.c | 3 ---
 1 file changed, 3 deletions(-)


        FOR YOUR CONVENIENCE, THE ENTIRE FUNCTION
        IN QUESTION IS REPRODUCED HERE IN THE PATCH;
        NOTICE THAT `gamma_size' IS NEVER USED
        MEANINGFULLY.


diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 3d13ca6e2..a6aab13 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -883,119 +883,116 @@
 static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 					 int preferred_bpp)
 {
 	int ret = 0;
 	int crtc_count = 0;
 	int i;
 	struct fb_info *info;
 	struct drm_fb_helper_surface_size sizes;
-	int gamma_size = 0;
 
 	memset(&sizes, 0, sizeof(struct drm_fb_helper_surface_size));
 	sizes.surface_depth = 24;
 	sizes.surface_bpp = 32;
 	sizes.fb_width = (unsigned)-1;
 	sizes.fb_height = (unsigned)-1;
 
 	/* if driver picks 8 or 16 by default use that
 	   for both depth/bpp */
 	if (preferred_bpp != sizes.surface_bpp)
 		sizes.surface_depth = sizes.surface_bpp = preferred_bpp;
 
 	/* first up get a count of crtcs now in use and new min/maxes width/heights */
 	for (i = 0; i < fb_helper->connector_count; i++) {
 		struct drm_fb_helper_connector *fb_helper_conn = fb_helper->connector_info[i];
 		struct drm_cmdline_mode *cmdline_mode;
 
 		cmdline_mode = &fb_helper_conn->cmdline_mode;
 
 		if (cmdline_mode->bpp_specified) {
 			switch (cmdline_mode->bpp) {
 			case 8:
 				sizes.surface_depth = sizes.surface_bpp = 8;
 				break;
 			case 15:
 				sizes.surface_depth = 15;
 				sizes.surface_bpp = 16;
 				break;
 			case 16:
 				sizes.surface_depth = sizes.surface_bpp = 16;
 				break;
 			case 24:
 				sizes.surface_depth = sizes.surface_bpp = 24;
 				break;
 			case 32:
 				sizes.surface_depth = 24;
 				sizes.surface_bpp = 32;
 				break;
 			}
 			break;
 		}
 	}
 
 	crtc_count = 0;
 	for (i = 0; i < fb_helper->crtc_count; i++) {
 		struct drm_display_mode *desired_mode;
 		desired_mode = fb_helper->crtc_info[i].desired_mode;
 
 		if (desired_mode) {
-			if (gamma_size == 0)
-				gamma_size = fb_helper->crtc_info[i].mode_set.crtc->gamma_size;
 			if (desired_mode->hdisplay < sizes.fb_width)
 				sizes.fb_width = desired_mode->hdisplay;
 			if (desired_mode->vdisplay < sizes.fb_height)
 				sizes.fb_height = desired_mode->vdisplay;
 			if (desired_mode->hdisplay > sizes.surface_width)
 				sizes.surface_width = desired_mode->hdisplay;
 			if (desired_mode->vdisplay > sizes.surface_height)
 				sizes.surface_height = desired_mode->vdisplay;
 			crtc_count++;
 		}
 	}
 
 	if (crtc_count == 0 || sizes.fb_width == -1 || sizes.fb_height == -1) {
 		/* hmm everyone went away - assume VGA cable just fell out
 		   and will come back later. */
 		DRM_INFO("Cannot find any crtc or sizes - going 1024x768\n");
 		sizes.fb_width = sizes.surface_width = 1024;
 		sizes.fb_height = sizes.surface_height = 768;
 	}
 
 	/* push down into drivers */
 	ret = (*fb_helper->funcs->fb_probe)(fb_helper, &sizes);
 	if (ret < 0)
 		return ret;
 
 	info = fb_helper->fbdev;
 
 	/*
 	 * Set the fb pointer - usually drm_setup_crtcs does this for hotplug
 	 * events, but at init time drm_setup_crtcs needs to be called before
 	 * the fb is allocated (since we need to figure out the desired size of
 	 * the fb before we can allocate it ...). Hence we need to fix things up
 	 * here again.
 	 */
 	for (i = 0; i < fb_helper->crtc_count; i++)
 		if (fb_helper->crtc_info[i].mode_set.num_connectors)
 			fb_helper->crtc_info[i].mode_set.fb = fb_helper->fb;
 
 
 	info->var.pixclock = 0;
 	if (register_framebuffer(info) < 0)
 		return -EINVAL;
 
 	dev_info(fb_helper->dev->dev, "fb%d: %s frame buffer device\n",
 			info->node, info->fix.id);
 
 	/* Switch back to kernel console on panic */
 	/* multi card linked list maybe */
 	if (list_empty(&kernel_fb_helper_list)) {
 		dev_info(fb_helper->dev->dev, "registered panic notifier\n");
 		atomic_notifier_chain_register(&panic_notifier_list,
 					       &paniced);
 		register_sysrq_key('v', &sysrq_drm_fb_helper_restore_op);
 	}
 
 	list_add(&fb_helper->kernel_fb_list, &kernel_fb_helper_list);
 
 	return 0;
 }
-- 
1.7.11.2.252.gc4a64c8

