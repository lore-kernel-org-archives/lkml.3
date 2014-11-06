Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaKFWkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:40:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58620 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKFWkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:40:08 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 145/162] drm/radeon: dpm fixes for asrock systems
Date: Thu,  6 Nov 2014 14:36:49 -0800
Message-Id: <1415313426-9622-146-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 72b3f9183ed57e4a2f0601a1c25ae2fd39855952 upstream.

- bapm seems to cause CPU stuck messages so disable it.
- nb dpm seems to prevent GPU dpm from getting enabled, so
disable it.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=85107

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/kv_dpm.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/kv_dpm.c b/drivers/gpu/drm/radeon/kv_dpm.c
index 1b0331c..8fcc491 100644
--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -2620,7 +2620,11 @@ int kv_dpm_init(struct radeon_device *rdev)
 	if (rdev->family == CHIP_KABINI)
 		pi->high_voltage_t = 4001;
 
-	pi->enable_nb_dpm = true;
+	/* Enabling nb dpm on an asrock system prevents dpm from working */
+	if (rdev->pdev->subsystem_vendor == 0x1849)
+		pi->enable_nb_dpm = false;
+	else
+		pi->enable_nb_dpm = true;
 
 	pi->caps_power_containment = true;
 	pi->caps_cac = true;
@@ -2635,10 +2639,19 @@ int kv_dpm_init(struct radeon_device *rdev)
 	pi->caps_sclk_ds = true;
 	pi->enable_auto_thermal_throttling = true;
 	pi->disable_nb_ps3_in_battery = false;
-	if (radeon_bapm == 0)
+	if (radeon_bapm == -1) {
+		/* There are stability issues reported on with
+		 * bapm enabled on an asrock system.
+		 */
+		if (rdev->pdev->subsystem_vendor == 0x1849)
+			pi->bapm_enable = false;
+		else
+			pi->bapm_enable = true;
+	} else if (radeon_bapm == 0) {
 		pi->bapm_enable = false;
-	else
+	} else {
 		pi->bapm_enable = true;
+	}
 	pi->voltage_drop_t = 0;
 	pi->caps_sclk_throttle_low_notification = false;
 	pi->caps_fps = false; /* true? */
-- 
1.9.1

