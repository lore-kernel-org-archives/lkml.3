Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbaGCKA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:00:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbaGCJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 084/198] drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
Date: Thu,  3 Jul 2014 10:18:47 +0100
Message-Id: <1404379241-8590-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3b6d9fd23e015b5397c438fd3cd74147d2c805b6 upstream.

Only DCE5+ asics support DP 1.2.

Noticed by ArtForz on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_dp.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 16023986d301..4c05f2b015cf 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -384,6 +384,19 @@ static int dp_get_max_dp_pix_clock(int link_rate,
 
 /***** radeon specific DP functions *****/
 
+static int radeon_dp_get_max_link_rate(struct drm_connector *connector,
+				       u8 dpcd[DP_DPCD_SIZE])
+{
+	int max_link_rate;
+
+	if (radeon_connector_is_dp12_capable(connector))
+		max_link_rate = min(drm_dp_max_link_rate(dpcd), 540000);
+	else
+		max_link_rate = min(drm_dp_max_link_rate(dpcd), 270000);
+
+	return max_link_rate;
+}
+
 /* First get the min lane# when low rate is used according to pixel clock
  * (prefer low rate), second check max lane# supported by DP panel,
  * if the max lane# < low rate lane# then use max lane# instead.
@@ -393,7 +406,7 @@ static int radeon_dp_get_dp_lane_number(struct drm_connector *connector,
 					int pix_clock)
 {
 	int bpp = convert_bpc_to_bpp(radeon_get_monitor_bpc(connector));
-	int max_link_rate = drm_dp_max_link_rate(dpcd);
+	int max_link_rate = radeon_dp_get_max_link_rate(connector, dpcd);
 	int max_lane_num = drm_dp_max_lane_count(dpcd);
 	int lane_num;
 	int max_dp_pix_clock;
@@ -431,7 +444,7 @@ static int radeon_dp_get_dp_link_clock(struct drm_connector *connector,
 			return 540000;
 	}
 
-	return drm_dp_max_link_rate(dpcd);
+	return radeon_dp_get_max_link_rate(connector, dpcd);
 }
 
 static u8 radeon_dp_encoder_service(struct radeon_device *rdev,
-- 
1.9.1

