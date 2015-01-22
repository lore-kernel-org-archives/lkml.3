Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbbAVKbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:31:16 -0500
Received: from regular1.263xmail.com ([211.150.99.137]:58353 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbbAVKbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:31:04 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: mark.yao@rock-chips.com
X-SENDER-IP: 192.69.251.64
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <ca18565c959da3dae3a0ae28eac0ec71>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Mark Yao <mark.yao@rock-chips.com>
To: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Kurtz <djkurtz@chromium.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc: Mark Yao <mark.yao@rock-chips.com>
Subject: [PATCH v2 2/2] drm/rockchip: vop: set vop enabled after enable iommu
Date: Thu, 22 Jan 2015 18:29:57 +0800
Message-Id: <1421922597-18351-3-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421922597-18351-1-git-send-email-mark.yao@rock-chips.com>
References: <1421922597-18351-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there is a Bug that:
  vop_enable()->drm_vblank_on, drm_vblank_on may call vop
enable vblank. if it happen, vblank enable would failed,
then cause irq status error. because is_enabled value is set
after drm_vblank_on.

after enable vop clocks and iommu regs, we can sure that
R/W vop regs and do vop plane flip is safe, so place
is_enabled = true after enable iommu is suitable.

Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
---
Changes in v2:
- fix mistake that set is_enabled wrong.

 drivers/gpu/drm/rockchip/rockchip_drm_vop.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index d03eb7e..fb25836 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -420,6 +420,11 @@ static void vop_enable(struct drm_crtc *crtc)
 		goto err_disable_aclk;
 	}
 
+	/*
+	 * At here, vop clock & iommu is enable, R/W vop regs would be safe.
+	 */
+	vop->is_enabled = true;
+
 	spin_lock(&vop->reg_lock);
 
 	VOP_CTRL_SET(vop, standby, 0);
@@ -430,8 +435,6 @@ static void vop_enable(struct drm_crtc *crtc)
 
 	drm_vblank_on(vop->drm_dev, vop->pipe);
 
-	vop->is_enabled = true;
-
 	return;
 
 err_disable_aclk:
@@ -462,6 +465,8 @@ static void vop_disable(struct drm_crtc *crtc)
 	VOP_CTRL_SET(vop, standby, 1);
 
 	spin_unlock(&vop->reg_lock);
+
+	vop->is_enabled = false;
 	/*
 	 * disable dclk to stop frame scan, so we can safely detach iommu,
 	 */
@@ -471,8 +476,6 @@ static void vop_disable(struct drm_crtc *crtc)
 
 	clk_disable(vop->aclk);
 	clk_disable(vop->hclk);
-
-	vop->is_enabled = false;
 }
 
 /*
-- 
1.7.9.5


