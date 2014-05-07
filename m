Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbaEGNON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:14:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbaEGNOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 19/70] drm/radeon/pm: don't walk the crtc list before it has been initialized (v2)
Date: Wed,  7 May 2014 14:12:22 +0100
Message-Id: <1399468393-10140-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 3ed9a335cfc64b2c83545f341cdddf2347b12b97 upstream.

Avoids a crash in certain cases when thermal irqs are generated
before the display structures have been initialized.

v2: fix the vblank and vrefresh helpers as well

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=73931

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.11:
  - dropped changes to r600_dpm_get_vrefresh() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r600_dpm.c  | 22 ++++++++++++----------
 drivers/gpu/drm/radeon/radeon_pm.c | 28 ++++++++++++++++------------
 2 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_dpm.c b/drivers/gpu/drm/radeon/r600_dpm.c
index e5c860f..23db5bd 100644
--- a/drivers/gpu/drm/radeon/r600_dpm.c
+++ b/drivers/gpu/drm/radeon/r600_dpm.c
@@ -158,16 +158,18 @@ u32 r600_dpm_get_vblank_time(struct radeon_device *rdev)
 	u32 line_time_us, vblank_lines;
 	u32 vblank_time_us = 0xffffffff; /* if the displays are off, vblank time is max */
 
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		radeon_crtc = to_radeon_crtc(crtc);
-		if (crtc->enabled && radeon_crtc->enabled && radeon_crtc->hw_mode.clock) {
-			line_time_us = (radeon_crtc->hw_mode.crtc_htotal * 1000) /
-				radeon_crtc->hw_mode.clock;
-			vblank_lines = radeon_crtc->hw_mode.crtc_vblank_end -
-				radeon_crtc->hw_mode.crtc_vdisplay +
-				(radeon_crtc->v_border * 2);
-			vblank_time_us = vblank_lines * line_time_us;
-			break;
+	if (rdev->num_crtc && rdev->mode_info.mode_config_initialized) {
+		list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+			radeon_crtc = to_radeon_crtc(crtc);
+			if (crtc->enabled && radeon_crtc->enabled && radeon_crtc->hw_mode.clock) {
+				line_time_us = (radeon_crtc->hw_mode.crtc_htotal * 1000) /
+					radeon_crtc->hw_mode.clock;
+				vblank_lines = radeon_crtc->hw_mode.crtc_vblank_end -
+					radeon_crtc->hw_mode.crtc_vdisplay +
+					(radeon_crtc->v_border * 2);
+				vblank_time_us = vblank_lines * line_time_us;
+				break;
+			}
 		}
 	}
 
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 418ca53..04b94ae 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1272,12 +1272,14 @@ static void radeon_pm_compute_clocks_old(struct radeon_device *rdev)
 
 	rdev->pm.active_crtcs = 0;
 	rdev->pm.active_crtc_count = 0;
-	list_for_each_entry(crtc,
-		&ddev->mode_config.crtc_list, head) {
-		radeon_crtc = to_radeon_crtc(crtc);
-		if (radeon_crtc->enabled) {
-			rdev->pm.active_crtcs |= (1 << radeon_crtc->crtc_id);
-			rdev->pm.active_crtc_count++;
+	if (rdev->num_crtc && rdev->mode_info.mode_config_initialized) {
+		list_for_each_entry(crtc,
+				    &ddev->mode_config.crtc_list, head) {
+			radeon_crtc = to_radeon_crtc(crtc);
+			if (radeon_crtc->enabled) {
+				rdev->pm.active_crtcs |= (1 << radeon_crtc->crtc_id);
+				rdev->pm.active_crtc_count++;
+			}
 		}
 	}
 
@@ -1341,12 +1343,14 @@ static void radeon_pm_compute_clocks_dpm(struct radeon_device *rdev)
 	/* update active crtc counts */
 	rdev->pm.dpm.new_active_crtcs = 0;
 	rdev->pm.dpm.new_active_crtc_count = 0;
-	list_for_each_entry(crtc,
-		&ddev->mode_config.crtc_list, head) {
-		radeon_crtc = to_radeon_crtc(crtc);
-		if (crtc->enabled) {
-			rdev->pm.dpm.new_active_crtcs |= (1 << radeon_crtc->crtc_id);
-			rdev->pm.dpm.new_active_crtc_count++;
+	if (rdev->num_crtc && rdev->mode_info.mode_config_initialized) {
+		list_for_each_entry(crtc,
+				    &ddev->mode_config.crtc_list, head) {
+			radeon_crtc = to_radeon_crtc(crtc);
+			if (crtc->enabled) {
+				rdev->pm.dpm.new_active_crtcs |= (1 << radeon_crtc->crtc_id);
+				rdev->pm.dpm.new_active_crtc_count++;
+			}
 		}
 	}
 
-- 
1.9.1

