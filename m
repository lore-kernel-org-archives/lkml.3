Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbbAVKbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:31:10 -0500
Received: from regular1.263xmail.com ([211.150.99.138]:35583 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbAVKaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:30:55 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: mark.yao@rock-chips.com
X-SENDER-IP: 192.69.251.64
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <95cedd902920c9fe4760a1fde3e549a2>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Mark Yao <mark.yao@rock-chips.com>
To: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Kurtz <djkurtz@chromium.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc: Mark Yao <mark.yao@rock-chips.com>
Subject: [PATCH v2 1/2] drm/rockchip: vop use is_enabled instead of dpms mode
Date: Thu, 22 Jan 2015 18:29:56 +0800
Message-Id: <1421922597-18351-2-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421922597-18351-1-git-send-email-mark.yao@rock-chips.com>
References: <1421922597-18351-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm dpms have many power modes: ON,OFF,SUSPEND,STANDBY, etc.
but vop only have enable/disable mode, maybe case such bug:
 --> DRM_DPMS_ON: power on vop
 --> DRM_DPMS_SUSPEND: power off vop
 --> DRM_DPMS_OFF: already power off at SUSPEND, crash
so use a bool val is more suitable.

Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
---
Changes in v2:
- fix mistake that set is_enabled wrong.

 drivers/gpu/drm/rockchip/rockchip_drm_vop.c |   34 ++++++++++++++-------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 9a5c571..d03eb7e 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -81,7 +81,7 @@ struct vop {
 	struct drm_crtc crtc;
 	struct device *dev;
 	struct drm_device *drm_dev;
-	unsigned int dpms;
+	bool is_enabled;
 
 	int connector_type;
 	int connector_out_mode;
@@ -387,6 +387,9 @@ static void vop_enable(struct drm_crtc *crtc)
 	struct vop *vop = to_vop(crtc);
 	int ret;
 
+	if (vop->is_enabled)
+		return;
+
 	ret = clk_enable(vop->hclk);
 	if (ret < 0) {
 		dev_err(vop->dev, "failed to enable hclk - %d\n", ret);
@@ -427,6 +430,8 @@ static void vop_enable(struct drm_crtc *crtc)
 
 	drm_vblank_on(vop->drm_dev, vop->pipe);
 
+	vop->is_enabled = true;
+
 	return;
 
 err_disable_aclk:
@@ -441,6 +446,9 @@ static void vop_disable(struct drm_crtc *crtc)
 {
 	struct vop *vop = to_vop(crtc);
 
+	if (!vop->is_enabled)
+		return;
+
 	drm_vblank_off(crtc->dev, vop->pipe);
 
 	disable_irq(vop->irq);
@@ -463,6 +471,8 @@ static void vop_disable(struct drm_crtc *crtc)
 
 	clk_disable(vop->aclk);
 	clk_disable(vop->hclk);
+
+	vop->is_enabled = false;
 }
 
 /*
@@ -742,7 +752,7 @@ static int vop_crtc_enable_vblank(struct drm_crtc *crtc)
 	struct vop *vop = to_vop(crtc);
 	unsigned long flags;
 
-	if (vop->dpms != DRM_MODE_DPMS_ON)
+	if (!vop->is_enabled)
 		return -EPERM;
 
 	spin_lock_irqsave(&vop->irq_lock, flags);
@@ -759,8 +769,9 @@ static void vop_crtc_disable_vblank(struct drm_crtc *crtc)
 	struct vop *vop = to_vop(crtc);
 	unsigned long flags;
 
-	if (vop->dpms != DRM_MODE_DPMS_ON)
+	if (!vop->is_enabled)
 		return;
+
 	spin_lock_irqsave(&vop->irq_lock, flags);
 	vop_mask_write(vop, INTR_CTRL0, FS_INTR_MASK, FS_INTR_EN(0));
 	spin_unlock_irqrestore(&vop->irq_lock, flags);
@@ -773,15 +784,8 @@ static const struct rockchip_crtc_funcs private_crtc_funcs = {
 
 static void vop_crtc_dpms(struct drm_crtc *crtc, int mode)
 {
-	struct vop *vop = to_vop(crtc);
-
 	DRM_DEBUG_KMS("crtc[%d] mode[%d]\n", crtc->base.id, mode);
 
-	if (vop->dpms == mode) {
-		DRM_DEBUG_KMS("desired dpms mode is same as previous one.\n");
-		return;
-	}
-
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
 		vop_enable(crtc);
@@ -795,8 +799,6 @@ static void vop_crtc_dpms(struct drm_crtc *crtc, int mode)
 		DRM_DEBUG_KMS("unspecified mode %d\n", mode);
 		break;
 	}
-
-	vop->dpms = mode;
 }
 
 static void vop_crtc_prepare(struct drm_crtc *crtc)
@@ -934,9 +936,9 @@ static int vop_crtc_page_flip(struct drm_crtc *crtc,
 	struct drm_framebuffer *old_fb = crtc->primary->fb;
 	int ret;
 
-	/* when the page flip is requested, crtc's dpms should be on */
-	if (vop->dpms > DRM_MODE_DPMS_ON) {
-		DRM_DEBUG("failed page flip request at dpms[%d].\n", vop->dpms);
+	/* when the page flip is requested, crtc should be on */
+	if (!vop->is_enabled) {
+		DRM_DEBUG("page flip request rejected because crtc is off.\n");
 		return 0;
 	}
 
@@ -1302,7 +1304,7 @@ static int vop_initial(struct vop *vop)
 
 	clk_disable(vop->hclk);
 
-	vop->dpms = DRM_MODE_DPMS_OFF;
+	vop->is_enabled = false;
 
 	return 0;
 
-- 
1.7.9.5


