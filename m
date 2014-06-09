Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbaFIIwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:52:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58472 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/146] drm/radeon/pm: don't walk the crtc list before it has been initialized (v2)
Date: Mon,  9 Jun 2014 10:49:42 +0200
Message-Id: <514ff7f7369a99ca4d0c3b909f46f088a6363efe.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3ed9a335cfc64b2c83545f341cdddf2347b12b97 upstream.

Avoids a crash in certain cases when thermal irqs are generated
before the display structures have been initialized.

v2: fix the vblank and vrefresh helpers as well

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=73931

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/r600_dpm.c  | 35 +++++++++++++++++++----------------
 drivers/gpu/drm/radeon/radeon_pm.c | 28 ++++++++++++++++------------
 2 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_dpm.c b/drivers/gpu/drm/radeon/r600_dpm.c
index 5513d8f06252..2df683aab9e9 100644
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
 
@@ -181,14 +183,15 @@ u32 r600_dpm_get_vrefresh(struct radeon_device *rdev)
 	struct radeon_crtc *radeon_crtc;
 	u32 vrefresh = 0;
 
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		radeon_crtc = to_radeon_crtc(crtc);
-		if (crtc->enabled && radeon_crtc->enabled && radeon_crtc->hw_mode.clock) {
-			vrefresh = radeon_crtc->hw_mode.vrefresh;
-			break;
+	if (rdev->num_crtc && rdev->mode_info.mode_config_initialized) {
+		list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+			radeon_crtc = to_radeon_crtc(crtc);
+			if (crtc->enabled && radeon_crtc->enabled && radeon_crtc->hw_mode.clock) {
+				vrefresh = radeon_crtc->hw_mode.vrefresh;
+				break;
+			}
 		}
 	}
-
 	return vrefresh;
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index a0ec4bb9d896..10fc97749a81 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1362,12 +1362,14 @@ static void radeon_pm_compute_clocks_old(struct radeon_device *rdev)
 
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
 
@@ -1431,12 +1433,14 @@ static void radeon_pm_compute_clocks_dpm(struct radeon_device *rdev)
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
1.9.3

