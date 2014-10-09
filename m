Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbaJIVkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:40:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59150 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaJIVIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 045/163] drm/radeon/dpm: set the thermal type properly for special configs
Date: Thu,  9 Oct 2014 14:01:10 -0700
Message-Id: <1412888588-26755-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ff4377924f7e587c61bcbc704eafecf6c7bd2e00 upstream.

On systems with special thermal configurations make sure we make
note of the thermal setup.  This is required for proper firmware
configuration on these systems.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 9e53064..2f7e9b8 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2288,19 +2288,31 @@ static void radeon_atombios_add_pplib_thermal_controller(struct radeon_device *r
 				 (controller->ucFanParameters &
 				  ATOM_PP_FANPARAMETERS_NOFAN) ? "without" : "with");
 			rdev->pm.int_thermal_type = THERMAL_TYPE_KV;
-		} else if ((controller->ucType ==
-			    ATOM_PP_THERMALCONTROLLER_EXTERNAL_GPIO) ||
-			   (controller->ucType ==
-			    ATOM_PP_THERMALCONTROLLER_ADT7473_WITH_INTERNAL) ||
-			   (controller->ucType ==
-			    ATOM_PP_THERMALCONTROLLER_EMC2103_WITH_INTERNAL)) {
-			DRM_INFO("Special thermal controller config\n");
+		} else if (controller->ucType ==
+			   ATOM_PP_THERMALCONTROLLER_EXTERNAL_GPIO) {
+			DRM_INFO("External GPIO thermal controller %s fan control\n",
+				 (controller->ucFanParameters &
+				  ATOM_PP_FANPARAMETERS_NOFAN) ? "without" : "with");
+			rdev->pm.int_thermal_type = THERMAL_TYPE_EXTERNAL_GPIO;
+		} else if (controller->ucType ==
+			   ATOM_PP_THERMALCONTROLLER_ADT7473_WITH_INTERNAL) {
+			DRM_INFO("ADT7473 with internal thermal controller %s fan control\n",
+				 (controller->ucFanParameters &
+				  ATOM_PP_FANPARAMETERS_NOFAN) ? "without" : "with");
+			rdev->pm.int_thermal_type = THERMAL_TYPE_ADT7473_WITH_INTERNAL;
+		} else if (controller->ucType ==
+			   ATOM_PP_THERMALCONTROLLER_EMC2103_WITH_INTERNAL) {
+			DRM_INFO("EMC2103 with internal thermal controller %s fan control\n",
+				 (controller->ucFanParameters &
+				  ATOM_PP_FANPARAMETERS_NOFAN) ? "without" : "with");
+			rdev->pm.int_thermal_type = THERMAL_TYPE_EMC2103_WITH_INTERNAL;
 		} else if (controller->ucType < ARRAY_SIZE(pp_lib_thermal_controller_names)) {
 			DRM_INFO("Possible %s thermal controller at 0x%02x %s fan control\n",
 				 pp_lib_thermal_controller_names[controller->ucType],
 				 controller->ucI2cAddress >> 1,
 				 (controller->ucFanParameters &
 				  ATOM_PP_FANPARAMETERS_NOFAN) ? "without" : "with");
+			rdev->pm.int_thermal_type = THERMAL_TYPE_EXTERNAL;
 			i2c_bus = radeon_lookup_i2c_gpio(rdev, controller->ucI2cLine);
 			rdev->pm.i2c_bus = radeon_i2c_lookup(rdev, &i2c_bus);
 			if (rdev->pm.i2c_bus) {
-- 
1.9.1

