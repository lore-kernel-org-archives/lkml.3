Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbbAIKsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:48:07 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44604 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757501AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 24/78] drm/i915: More cautious with pch fifo underruns
Date: Fri,  9 Jan 2015 11:31:33 +0100
Message-Id: <6baff9ed39547e4dba50a0687871937660446370.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_display.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 837cc6cd7472..37a9d3c89feb 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3537,7 +3537,6 @@ static void ironlake_crtc_disable(struct drm_crtc *crtc)
 		ironlake_fdi_disable(crtc);
 
 		ironlake_disable_pch_transcoder(dev_priv, pipe);
-		intel_set_pch_fifo_underrun_reporting(dev, pipe, true);
 
 		if (HAS_PCH_CPT(dev)) {
 			/* disable TRANS_DP_CTL */
@@ -3613,7 +3612,6 @@ static void haswell_crtc_disable(struct drm_crtc *crtc)
 
 	if (intel_crtc->config.has_pch_encoder) {
 		lpt_disable_pch_transcoder(dev_priv);
-		intel_set_pch_fifo_underrun_reporting(dev, TRANSCODER_A, true);
 		intel_ddi_fdi_disable(crtc);
 	}
 
-- 
2.2.1

