Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaLEXh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:37:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaLEWz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:55:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.17 112/122] drm/radeon: report disconnected for LVDS/eDP with PX if ddc fails
Date: Fri,  5 Dec 2014 14:44:46 -0800
Message-Id: <20141205223322.976859851@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1348579433566355e570008929daa09a0db64fd8 upstream.

If ddc fails, presumably the i2c mux (and hopefully the signal
mux) are switched to the other GPU so don't fetch the edid from
the vbios so that the connector reports disconnected.

bug:
https://bugzilla.opensuse.org/show_bug.cgi?id=904417

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -322,6 +322,12 @@ static void radeon_connector_get_edid(st
 	}
 
 	if (!radeon_connector->edid) {
+		/* don't fetch the edid from the vbios if ddc fails and runpm is
+		 * enabled so we report disconnected.
+		 */
+		if ((rdev->flags & RADEON_IS_PX) && (radeon_runtime_pm != 0))
+			return;
+
 		if (rdev->is_atom_bios) {
 			/* some laptops provide a hardcoded edid in rom for LCDs */
 			if (((connector->connector_type == DRM_MODE_CONNECTOR_LVDS) ||
@@ -826,6 +832,8 @@ static int radeon_lvds_mode_valid(struct
 static enum drm_connector_status
 radeon_lvds_detect(struct drm_connector *connector, bool force)
 {
+	struct drm_device *dev = connector->dev;
+	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_connector *radeon_connector = to_radeon_connector(connector);
 	struct drm_encoder *encoder = radeon_best_single_encoder(connector);
 	enum drm_connector_status ret = connector_status_disconnected;
@@ -842,7 +850,11 @@ radeon_lvds_detect(struct drm_connector
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
@@ -1589,6 +1601,11 @@ radeon_dp_detect(struct drm_connector *c
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


