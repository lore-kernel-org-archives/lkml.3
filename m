Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab3APQDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36112 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3APQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 096/222] drm/i915: drop buggy write to FDI_RX_CHICKEN register
Date: Wed, 16 Jan 2013 13:54:56 -0200
Message-Id: <1358351822-7675-97-git-send-email-herton.krzesinski@canonical.com>
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

commit 607a6f7a6621f65706ff536b2615ee65b5c2f575 upstream.

Jani Nikula noticed that the parentheses are wrong and we & the bit
with the register address instead of the read-back value. He sent a
patch to correct that.

On second look, we write the same register in the previous line, and
the w/a seems to be to set FDI_RX_PHASE_SYNC_POINTER_OVR to enable the
logic, then keep always set FDI_RX_PHASE_SYNC_POINTER_OVR and toggle
FDI_RX_PHASE_SYNC_POINTER_EN before/after enabling the pc transcoder.

So the right things seems to be to simply kill the 2nd write.

Cc: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
[danvet: Dropped a bogus ~ from the commit message that somehow crept
in.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ herton: this looks a good bug fix, which also makes the next patch,
 "drm/i915: disable cpt phase pointer fdi rx workaround", easier to apply ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index c69444a..98ea04e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2609,9 +2609,6 @@ static void ironlake_fdi_disable(struct drm_crtc *crtc)
 	/* Ironlake workaround, disable clock pointer after downing FDI */
 	if (HAS_PCH_IBX(dev)) {
 		I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR);
-		I915_WRITE(FDI_RX_CHICKEN(pipe),
-			   I915_READ(FDI_RX_CHICKEN(pipe) &
-				     ~FDI_RX_PHASE_SYNC_POINTER_EN));
 	} else if (HAS_PCH_CPT(dev)) {
 		cpt_phase_pointer_disable(dev, pipe);
 	}
-- 
1.7.9.5

