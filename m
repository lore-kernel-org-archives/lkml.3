Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaGHAT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:19:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaGGXzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 17/53] drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
Date: Mon,  7 Jul 2014 16:58:02 -0700
Message-Id: <20140707235829.816676496@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3b6d9fd23e015b5397c438fd3cd74147d2c805b6 upstream.

Only DCE5+ asics support DP 1.2.

Noticed by ArtForz on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_dp.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -384,6 +384,19 @@ static int dp_get_max_dp_pix_clock(int l
 
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
@@ -393,7 +406,7 @@ static int radeon_dp_get_dp_lane_number(
 					int pix_clock)
 {
 	int bpp = convert_bpc_to_bpp(radeon_get_monitor_bpc(connector));
-	int max_link_rate = drm_dp_max_link_rate(dpcd);
+	int max_link_rate = radeon_dp_get_max_link_rate(connector, dpcd);
 	int max_lane_num = drm_dp_max_lane_count(dpcd);
 	int lane_num;
 	int max_dp_pix_clock;
@@ -431,7 +444,7 @@ static int radeon_dp_get_dp_link_clock(s
 			return 540000;
 	}
 
-	return drm_dp_max_link_rate(dpcd);
+	return radeon_dp_get_max_link_rate(connector, dpcd);
 }
 
 static u8 radeon_dp_encoder_service(struct radeon_device *rdev,


