Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaJCVda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:33:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaJCVdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:33:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.16 094/357] drm/radeon/dpm: set the thermal type properly for special configs
Date: Fri,  3 Oct 2014 14:28:00 -0700
Message-Id: <20141003212936.311018236@linuxfoundation.org>
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

commit ff4377924f7e587c61bcbc704eafecf6c7bd2e00 upstream.

On systems with special thermal configurations make sure we make
note of the thermal setup.  This is required for proper firmware
configuration on these systems.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2281,19 +2281,31 @@ static void radeon_atombios_add_pplib_th
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


