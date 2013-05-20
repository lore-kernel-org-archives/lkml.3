Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3ETKwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3ETKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 013/115] drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
Date: Mon, 20 May 2013 11:50:13 +0100
Message-Id: <1369047116-9378-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2e97be73e5f74a317232740ae82eb8f95326a660 upstream.

Avoids potential interrupt storms when the display is disabled.

May fix:
https://bugzilla.kernel.org/show_bug.cgi?id=56041

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index ccac010..9cf8f35 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -445,6 +445,16 @@ void evergreen_hpd_init(struct radeon_device *rdev)
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		struct radeon_connector *radeon_connector = to_radeon_connector(connector);
+
+		if (connector->connector_type == DRM_MODE_CONNECTOR_eDP ||
+		    connector->connector_type == DRM_MODE_CONNECTOR_LVDS) {
+			/* don't try to enable hpd on eDP or LVDS avoid breaking the
+			 * aux dp channel on imac and help (but not completely fix)
+			 * https://bugzilla.redhat.com/show_bug.cgi?id=726143
+			 * also avoid interrupt storms during dpms.
+			 */
+			continue;
+		}
 		switch (radeon_connector->hpd.hpd) {
 		case RADEON_HPD_1:
 			WREG32(DC_HPD1_CONTROL, tmp);
-- 
1.8.1.2

