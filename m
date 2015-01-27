Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbbA0Qge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:36:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40010 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbbA0Qgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:36:32 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH] drm/msm/mdp5: only flush on a CRTC ->atomic_flush()
Date: Tue, 27 Jan 2015 11:35:56 -0500
Message-Id: <1422376556-25904-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MDP5 hardware has some limitation and requires to avoid flushing
registers more than once between two Vblanks.

This change removes all FLUSH operations (except for HW cursor)
beside the one coming from a CRTC's ->atomic_flush().

This avoid this type of behavior (eg: CRTC + 1 plane overlay):

	[drm:mdp5_crtc_vblank_irq] vblank
	[drm:mdp5_ctl_commit] flush (20048)   CTL + LM0 + RGB0
	[drm:mdp5_ctl_commit] flush (20040)   CTL + LM0
	[drm:mdp5_crtc_vblank_irq] blank
	[drm:mdp5_ctl_commit] flush (20049)   CTL + LM0 + RGB0 + VIG0
	[drm:mdp5_crtc_vblank_irq] blank

and replaces it by:

	[drm:mdp5_crtc_vblank_irq] vblank
	[drm:mdp5_ctl_commit] flush (20048)   CTL + LM0 + RGB0
	[drm:mdp5_crtc_vblank_irq] blank
	[drm:mdp5_ctl_commit] flush (20049)   CTL + LM0 + RGB0 + VIG0
	[drm:mdp5_crtc_vblank_irq] blank

Only *one* FLUSH is called between Vblanks interrupts.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
index 10f93cf..f455f38 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
@@ -297,7 +297,7 @@ static void mdp5_crtc_commit(struct drm_crtc *crtc)
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
 	DBG("%s", mdp5_crtc->name);
 	mdp5_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
-	crtc_flush_all(crtc);
+
 	/* drop the ref to mdp clk's that we got in prepare: */
 	mdp5_disable(get_kms(crtc));
 }
@@ -600,7 +600,6 @@ void mdp5_crtc_set_intf(struct drm_crtc *crtc, int intf,
 {
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
 	struct mdp5_kms *mdp5_kms = get_kms(crtc);
-	uint32_t flush_mask = 0;
 	uint32_t intf_sel;
 	unsigned long flags;
 
@@ -639,10 +638,6 @@ void mdp5_crtc_set_intf(struct drm_crtc *crtc, int intf,
 
 	DBG("%s: intf_sel=%08x", mdp5_crtc->name, intf_sel);
 	mdp5_ctl_set_intf(mdp5_crtc->ctl, intf);
-	flush_mask |= mdp5_ctl_get_flush(mdp5_crtc->ctl);
-	flush_mask |= mdp5_lm_get_flush(mdp5_crtc->lm);
-
-	crtc_flush(crtc, flush_mask);
 }
 
 int mdp5_crtc_get_lm(struct drm_crtc *crtc)
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

