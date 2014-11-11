Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaKKLTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:19:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57821 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaKKLLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 144/170] drm/radeon: dpm fixes for asrock systems
Date: Tue, 11 Nov 2014 11:08:23 +0000
Message-Id: <1415704129-12709-145-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 72b3f9183ed57e4a2f0601a1c25ae2fd39855952 upstream.

- bapm seems to cause CPU stuck messages so disable it.
- nb dpm seems to prevent GPU dpm from getting enabled, so
disable it.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=85107

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/kv_dpm.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/kv_dpm.c b/drivers/gpu/drm/radeon/kv_dpm.c
index 67cb472d188c..e79b7ebf5894 100644
--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -2725,7 +2725,11 @@ int kv_dpm_init(struct radeon_device *rdev)
 
         pi->sram_end = SMC_RAM_END;
 
-	pi->enable_nb_dpm = true;
+	/* Enabling nb dpm on an asrock system prevents dpm from working */
+	if (rdev->pdev->subsystem_vendor == 0x1849)
+		pi->enable_nb_dpm = false;
+	else
+		pi->enable_nb_dpm = true;
 
 	pi->caps_power_containment = true;
 	pi->caps_cac = true;
@@ -2740,10 +2744,19 @@ int kv_dpm_init(struct radeon_device *rdev)
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
2.1.0

