Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaLOOp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:45:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaLOO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 117/168] drm/radeon: report disconnected for LVDS/eDP with PX if ddc fails
Date: Mon, 15 Dec 2014 14:26:11 +0000
Message-Id: <1418653622-21105-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1348579433566355e570008929daa09a0db64fd8 upstream.

If ddc fails, presumably the i2c mux (and hopefully the signal
mux) are switched to the other GPU so don't fetch the edid from
the vbios so that the connector reports disconnected.

bug:
https://bugzilla.opensuse.org/show_bug.cgi?id=904417

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.16:
  - dropped changes to radeon_connector_get_edid() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 44831197e82e..eb76aa72466c 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -695,6 +695,8 @@ static int radeon_lvds_mode_valid(struct drm_connector *connector,
 static enum drm_connector_status
 radeon_lvds_detect(struct drm_connector *connector, bool force)
 {
+	struct drm_device *dev = connector->dev;
+	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_connector *radeon_connector = to_radeon_connector(connector);
 	struct drm_encoder *encoder = radeon_best_single_encoder(connector);
 	enum drm_connector_status ret = connector_status_disconnected;
@@ -711,7 +713,11 @@ radeon_lvds_detect(struct drm_connector *connector, bool force)
 		/* check if panel is valid */
 		if (native_mode->hdisplay >= 320 && native_mode->vdisplay >= 240)
 			ret = connector_status_connected;
-
+		/* don't fetch the edid from the vbios if ddc fails and runpm is
+		 * enabled so we report disconnected.
+		 */
+		if ((rdev->flags & RADEON_IS_PX) && (radeon_runtime_pm != 0))
+			ret = connector_status_disconnected;
 	}
 
 	/* check for edid as well */
@@ -1492,6 +1498,11 @@ radeon_dp_detect(struct drm_connector *connector, bool force)
 			/* check if panel is valid */
 			if (native_mode->hdisplay >= 320 && native_mode->vdisplay >= 240)
 				ret = connector_status_connected;
+			/* don't fetch the edid from the vbios if ddc fails and runpm is
+			 * enabled so we report disconnected.
+			 */
+			if ((rdev->flags & RADEON_IS_PX) && (radeon_runtime_pm != 0))
+				ret = connector_status_disconnected;
 		}
 		/* eDP is always DP */
 		radeon_dig_connector->dp_sink_type = CONNECTOR_OBJECT_ID_DISPLAYPORT;
-- 
2.1.3

