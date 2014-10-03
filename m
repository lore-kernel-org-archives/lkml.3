Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaJCVfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:35:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbaJCVfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:35:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.16 099/357] drm/radeon/dpm: fix resume on mullins
Date: Fri,  3 Oct 2014 14:28:05 -0700
Message-Id: <20141003212936.454932179@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 39da038479a81a35a7f8af3ab2c90effd5c8eff1 upstream.

Need to properly disable nb dpm on dpm disable.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/kv_dpm.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -33,6 +33,8 @@
 #define KV_MINIMUM_ENGINE_CLOCK         800
 #define SMC_RAM_END                     0x40000
 
+static int kv_enable_nb_dpm(struct radeon_device *rdev,
+			    bool enable);
 static void kv_init_graphics_levels(struct radeon_device *rdev);
 static int kv_calculate_ds_divider(struct radeon_device *rdev);
 static int kv_calculate_nbps_level_settings(struct radeon_device *rdev);
@@ -1295,6 +1297,9 @@ void kv_dpm_disable(struct radeon_device
 {
 	kv_smc_bapm_enable(rdev, false);
 
+	if (rdev->family == CHIP_MULLINS)
+		kv_enable_nb_dpm(rdev, false);
+
 	/* powerup blocks */
 	kv_dpm_powergate_acp(rdev, false);
 	kv_dpm_powergate_samu(rdev, false);
@@ -1769,15 +1774,24 @@ static int kv_update_dfs_bypass_settings
 	return ret;
 }
 
-static int kv_enable_nb_dpm(struct radeon_device *rdev)
+static int kv_enable_nb_dpm(struct radeon_device *rdev,
+			    bool enable)
 {
 	struct kv_power_info *pi = kv_get_pi(rdev);
 	int ret = 0;
 
-	if (pi->enable_nb_dpm && !pi->nb_dpm_enabled) {
-		ret = kv_notify_message_to_smu(rdev, PPSMC_MSG_NBDPM_Enable);
-		if (ret == 0)
-			pi->nb_dpm_enabled = true;
+	if (enable) {
+		if (pi->enable_nb_dpm && !pi->nb_dpm_enabled) {
+			ret = kv_notify_message_to_smu(rdev, PPSMC_MSG_NBDPM_Enable);
+			if (ret == 0)
+				pi->nb_dpm_enabled = true;
+		}
+	} else {
+		if (pi->enable_nb_dpm && pi->nb_dpm_enabled) {
+			ret = kv_notify_message_to_smu(rdev, PPSMC_MSG_NBDPM_Disable);
+			if (ret == 0)
+				pi->nb_dpm_enabled = false;
+		}
 	}
 
 	return ret;
@@ -1864,7 +1878,7 @@ int kv_dpm_set_power_state(struct radeon
 			}
 			kv_update_sclk_t(rdev);
 			if (rdev->family == CHIP_MULLINS)
-				kv_enable_nb_dpm(rdev);
+				kv_enable_nb_dpm(rdev, true);
 		}
 	} else {
 		if (pi->enable_dpm) {
@@ -1889,7 +1903,7 @@ int kv_dpm_set_power_state(struct radeon
 			}
 			kv_update_acp_boot_level(rdev);
 			kv_update_sclk_t(rdev);
-			kv_enable_nb_dpm(rdev);
+			kv_enable_nb_dpm(rdev, true);
 		}
 	}
 


