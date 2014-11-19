Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaKSL2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:28:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbaKSL2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:28:22 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, Gerd Hoffmann <kraxel@redhat.com>,
        David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/4] bochs: add page_flip
Date: Wed, 19 Nov 2014 12:28:12 +0100
Message-Id: <1416396492-23214-5-git-send-email-kraxel@redhat.com>
In-Reply-To: <1416396492-23214-1-git-send-email-kraxel@redhat.com>
References: <1416396492-23214-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement crtc page_flip callback for bochsdrm.  The qemu stdvga has no
vblank signaling, so we have to fake it.  We do so by instantly calling
drm_send_vblank_event.  Tested with kmscon.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/bochs/bochs_kms.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/bochs/bochs_kms.c b/drivers/gpu/drm/bochs/bochs_kms.c
index 6b7efcf3..ee2013b 100644
--- a/drivers/gpu/drm/bochs/bochs_kms.c
+++ b/drivers/gpu/drm/bochs/bochs_kms.c
@@ -108,11 +108,32 @@ static void bochs_crtc_gamma_set(struct drm_crtc *crtc, u16 *red, u16 *green,
 {
 }
 
+static int bochs_crtc_page_flip(struct drm_crtc *crtc,
+				struct drm_framebuffer *fb,
+				struct drm_pending_vblank_event *event,
+				uint32_t page_flip_flags)
+{
+	struct bochs_device *bochs =
+		container_of(crtc, struct bochs_device, crtc);
+	struct drm_framebuffer *old_fb = crtc->primary->fb;
+	unsigned long irqflags;
+
+	crtc->primary->fb = fb;
+	bochs_crtc_mode_set_base(crtc, 0, 0, old_fb);
+	if (event) {
+		spin_lock_irqsave(&bochs->dev->event_lock, irqflags);
+		drm_send_vblank_event(bochs->dev, -1, event);
+		spin_unlock_irqrestore(&bochs->dev->event_lock, irqflags);
+	}
+	return 0;
+}
+
 /* These provide the minimum set of functions required to handle a CRTC */
 static const struct drm_crtc_funcs bochs_crtc_funcs = {
 	.gamma_set = bochs_crtc_gamma_set,
 	.set_config = drm_crtc_helper_set_config,
 	.destroy = drm_crtc_cleanup,
+	.page_flip = bochs_crtc_page_flip,
 };
 
 static const struct drm_crtc_helper_funcs bochs_helper_funcs = {
-- 
1.8.3.1

