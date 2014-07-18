Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965891AbaGRNRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:17:54 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17928 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935223AbaGRNRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:17:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/170] drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
Date: Fri, 18 Jul 2014 14:11:26 +0200
Message-Id: <85d9eb244713c9f0a820a9fd9d8ebe2eefc264c8.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3b6d9fd23e015b5397c438fd3cd74147d2c805b6 upstream.

Only DCE5+ asics support DP 1.2.

Noticed by ArtForz on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/atombios_dp.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 00885417ffff..4601969be373 100644
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
2.0.0

