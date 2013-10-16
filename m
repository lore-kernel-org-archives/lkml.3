Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025Ab3JPUfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:35:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35743 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761656Ab3JPUfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:35:13 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: daniel.vetter@ffwll.ch
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, przanoni@gmail.com,
        airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [v3.10][v3.11][v3.12][Regression][PATCH 1/1] Revert "Revert "drm/i915: revert eDP bpp clamping code changes""
Date: Wed, 16 Oct 2013 16:34:57 -0400
Message-Id: <397b1b6f028317a3ef897cdaf79eb1e5519e587d.1381939165.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1381939165.git.joseph.salisbury@canonical.com>
References: <cover.1381939165.git.joseph.salisbury@canonical.com>
In-Reply-To: <cover.1381939165.git.joseph.salisbury@canonical.com>
References: <cover.1381939165.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1195483

This reverts commit 657445fe8660100ad174600ebfa61536392b7624.

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Paulo Zanoni <przanoni@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: stable@vger.kernel.org


---
 drivers/gpu/drm/i915/intel_dp.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 26e162b..ce933ad 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -709,10 +709,7 @@ intel_dp_compute_config(struct intel_encoder *encoder,
 
 	/* Walk through all bpp values. Luckily they're all nicely spaced with 2
 	 * bpc in between. */
-	bpp = pipe_config->pipe_bpp;
-	if (is_edp(intel_dp) && dev_priv->vbt.edp_bpp)
-		bpp = min_t(int, bpp, dev_priv->vbt.edp_bpp);
-
+	bpp = min_t(int, 8*3, pipe_config->pipe_bpp);
 	for (; bpp >= 6*3; bpp -= 2*3) {
 		mode_rate = intel_dp_link_required(adjusted_mode->clock, bpp);
 
@@ -763,6 +760,19 @@ found:
 			       &pipe_config->dp_m_n);
 
 	intel_dp_set_clock(encoder, pipe_config, intel_dp->link_bw);
+	/*
+	 * XXX: We have a strange regression where using the vbt edp bpp value
+	 * for the link bw computation results in black screens, the panel only
+	 * works when we do the computation at the usual 24bpp (but still
+	 * requires us to use 18bpp). Until that's fully debugged, stay
+	 * bug-for-bug compatible with the old code.
+	 */
+	if (is_edp(intel_dp) && dev_priv->vbt.edp_bpp) {
+		DRM_DEBUG_KMS("clamping display bpc (was %d) to eDP (%d)\n",
+			      bpp, dev_priv->vbt.edp_bpp);
+		bpp = min_t(int, bpp, dev_priv->vbt.edp_bpp);
+	}
+	pipe_config->pipe_bpp = bpp;
 
 	return true;
 }
-- 
1.7.9.5

