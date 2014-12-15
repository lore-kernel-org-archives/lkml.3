Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaLOTgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:36:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaLOTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:33:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 72/96] drm/i915: More cautious with pch fifo underruns
Date: Mon, 15 Dec 2014 11:26:32 -0800
Message-Id: <1418671616-25482-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit b68362278af94e1171f5be9d4e44988601fb0439 upstream.

Apparently PCH fifo underruns are tricky, we have plenty reports that
we see the occasional underrun (especially at boot-up).

So for a change let's see what happens when we don't re-enable pch
fifo underrun reporting when the pipe is disabled. This means that the
kernel can't catch pch fifo underruns when they happen (except when
all pipes are on on the pch). But we'll still catch underruns when
disabling the pipe again. So not a terrible reduction in test
coverage.

Since the DRM_ERROR is new and hence a regression plan B would be to
revert it back to a debug output. Which would be a lot worse than this
hack for underrun test coverage in the wild. See the referenced
discussions for more.

References: http://mid.gmane.org/CA+gsUGRfGe3t4NcjdeA=qXysrhLY3r4CEu7z4bjTwxi1uOfy+g@mail.gmail.com
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=85898
References: https://bugs.freedesktop.org/show_bug.cgi?id=85898
References: https://bugs.freedesktop.org/show_bug.cgi?id=86233
References: https://bugs.freedesktop.org/show_bug.cgi?id=86478
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Tested-by: lu hua <huax.lu@intel.com>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 4a82251..2d2c1e1 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3755,7 +3755,6 @@ static void ironlake_crtc_disable(struct drm_crtc *crtc)
 		ironlake_fdi_disable(crtc);
 
 		ironlake_disable_pch_transcoder(dev_priv, pipe);
-		intel_set_pch_fifo_underrun_reporting(dev, pipe, true);
 
 		if (HAS_PCH_CPT(dev)) {
 			/* disable TRANS_DP_CTL */
@@ -3821,7 +3820,6 @@ static void haswell_crtc_disable(struct drm_crtc *crtc)
 
 	if (intel_crtc->config.has_pch_encoder) {
 		lpt_disable_pch_transcoder(dev_priv);
-		intel_set_pch_fifo_underrun_reporting(dev, TRANSCODER_A, true);
 		intel_ddi_fdi_disable(crtc);
 	}
 
-- 
1.9.1

