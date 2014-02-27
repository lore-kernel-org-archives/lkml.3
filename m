Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaB0ILt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:11:49 -0500
Received: from arlo.cworth.org ([50.126.95.6]:32959 "EHLO arlo.cworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaB0ILs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:11:48 -0500
From: Carl Worth <cworth@cworth.org>
To: intel-gfx@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Carl Worth <cworth@cworth.org>
Subject: [PATCH] drm/i915/dp: Allow for 5.4Gbps for Haswell.
Date: Thu, 27 Feb 2014 00:11:39 -0800
Message-Id: <1393488699-6265-1-git-send-email-cworth@cworth.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With Haswell, 5.4Gbps is supported. And almost all of the code was
already in place already. All that was missing was this tiny bit of
additional wiring.

Signed-off-by: Carl Worth <cworth@cworth.org>
Reviewed-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 57552eb..ce9739e 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -101,7 +101,11 @@ intel_dp_max_link_bw(struct intel_dp *intel_dp)
 	case DP_LINK_BW_1_62:
 	case DP_LINK_BW_2_7:
 		break;
-	case DP_LINK_BW_5_4: /* 1.2 capable displays may advertise higher bw */
+	case DP_LINK_BW_5_4:
+		/* XXX: But not HASWELL ULX. */
+		if (IS_HASWELL(intel_dp_to_dev(intel_dp)))
+			break;
+		/* Prior to HASWELL, maximum support is for 2.7 Gbps */
 		max_link_bw = DP_LINK_BW_2_7;
 		break;
 	default:
@@ -810,12 +814,24 @@ intel_dp_compute_config(struct intel_encoder *encoder,
 	enum port port = dp_to_dig_port(intel_dp)->port;
 	struct intel_crtc *intel_crtc = encoder->new_crtc;
 	struct intel_connector *intel_connector = intel_dp->attached_connector;
-	int lane_count, clock;
+	int lane_count;
 	int max_lane_count = drm_dp_max_lane_count(intel_dp->dpcd);
-	int max_clock = intel_dp_max_link_bw(intel_dp) == DP_LINK_BW_2_7 ? 1 : 0;
 	int bpp, mode_rate;
-	static int bws[2] = { DP_LINK_BW_1_62, DP_LINK_BW_2_7 };
 	int link_avail, link_clock;
+	int max_link_bw;
+	/* The clock and max_clock values are an index into bws. */
+	int clock, max_clock = 0;
+	static int bws[3] = { DP_LINK_BW_1_62, DP_LINK_BW_2_7, DP_LINK_BW_5_4};
+
+	max_link_bw = intel_dp_max_link_bw(intel_dp);
+
+	for (clock = 0; clock < ARRAY_SIZE(bws); clock++) {
+		if (bws[clock] == max_link_bw) {
+			max_clock = clock;
+			break;
+		}
+	}
+
 
 	if (HAS_PCH_SPLIT(dev) && !HAS_DDI(dev) && port != PORT_A)
 		pipe_config->has_pch_encoder = true;
-- 
1.9.0

