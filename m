Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3APQDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36117 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3APQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Runyan, Arthur J" <arthur.j.runyan@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 097/222] drm/i915: disable cpt phase pointer fdi rx workaround
Date: Wed, 16 Jan 2013 13:54:57 -0200
Message-Id: <1358351822-7675-98-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 539526b4137bc0e7a8806c38c8522f226814a0e6 upstream.

We've originally added this in

commit 291427f5fdadec6e4be2924172e83588880e1539
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Jul 29 12:42:37 2011 -0700

    drm/i915: apply phase pointer override on SNB+ too

and then copy-pasted it over to ivb/ppt. The w/a was originally added
for ilk/ibx in

commit 5b2adf897146edeac6a1e438fb67b5a53dbbdf34
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Oct 7 16:01:15 2010 -0700

    drm/i915: add Ironlake clock gating workaround for FDI link training

and fixed up a bit in

commit 6f06ce184c765fd8d50669a8d12fdd566c920859
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Jan 4 15:09:38 2011 -0800

    drm/i915: set phase sync pointer override enable before setting phase sync pointer

It turns out that this w/a isn't actually required on cpt/ppt and
positively harmful on ivb/ppt when using fdi B/C links - it results in
a black screen occasionally, with seemingfully everything working as
it should. The only failure indication I've found in the hw is that
eventually (but not right after the modeset completes) a pipe underrun
is signalled.

Big thanks to Arthur Runyan for all the ideas for registers to check
and changes to test, otherwise I couldn't ever have tracked this down!

Cc: "Runyan, Arthur J" <arthur.j.runyan@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ herton: backported to 3.5, it still has the if checks for HAS_PCH_CPT
  which are removed now ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |   31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 98ea04e..fb20654 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2165,18 +2165,6 @@ static void intel_fdi_normal_train(struct drm_crtc *crtc)
 			   FDI_FE_ERRC_ENABLE);
 }
 
-static void cpt_phase_pointer_enable(struct drm_device *dev, int pipe)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 flags = I915_READ(SOUTH_CHICKEN1);
-
-	flags |= FDI_PHASE_SYNC_OVR(pipe);
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* once to unlock... */
-	flags |= FDI_PHASE_SYNC_EN(pipe);
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* then again to enable */
-	POSTING_READ(SOUTH_CHICKEN1);
-}
-
 /* The FDI link training functions for ILK/Ibexpeak. */
 static void ironlake_fdi_link_train(struct drm_crtc *crtc)
 {
@@ -2327,9 +2315,6 @@ static void gen6_fdi_link_train(struct drm_crtc *crtc)
 	POSTING_READ(reg);
 	udelay(150);
 
-	if (HAS_PCH_CPT(dev))
-		cpt_phase_pointer_enable(dev, pipe);
-
 	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);
 		temp = I915_READ(reg);
@@ -2456,9 +2441,6 @@ static void ivb_manual_fdi_link_train(struct drm_crtc *crtc)
 	POSTING_READ(reg);
 	udelay(150);
 
-	if (HAS_PCH_CPT(dev))
-		cpt_phase_pointer_enable(dev, pipe);
-
 	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);
 		temp = I915_READ(reg);
@@ -2572,17 +2554,6 @@ static void ironlake_fdi_pll_enable(struct drm_crtc *crtc)
 	}
 }
 
-static void cpt_phase_pointer_disable(struct drm_device *dev, int pipe)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 flags = I915_READ(SOUTH_CHICKEN1);
-
-	flags &= ~(FDI_PHASE_SYNC_EN(pipe));
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* once to disable... */
-	flags &= ~(FDI_PHASE_SYNC_OVR(pipe));
-	I915_WRITE(SOUTH_CHICKEN1, flags); /* then again to lock */
-	POSTING_READ(SOUTH_CHICKEN1);
-}
 static void ironlake_fdi_disable(struct drm_crtc *crtc)
 {
 	struct drm_device *dev = crtc->dev;
@@ -2609,8 +2580,6 @@ static void ironlake_fdi_disable(struct drm_crtc *crtc)
 	/* Ironlake workaround, disable clock pointer after downing FDI */
 	if (HAS_PCH_IBX(dev)) {
 		I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR);
-	} else if (HAS_PCH_CPT(dev)) {
-		cpt_phase_pointer_disable(dev, pipe);
 	}
 
 	/* still set train pattern 1 */
-- 
1.7.9.5

