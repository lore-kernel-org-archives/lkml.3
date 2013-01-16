Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab3APQKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:10:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3APQKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:10:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 202/222] drm/radeon: add connector table for Mac G4 Silver
Date: Wed, 16 Jan 2013 13:56:42 -0200
Message-Id: <1358351822-7675-203-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cafa59b9011a7790be4ddd5979419259844a165d upstream.

Apple cards do not provide data tables in the vbios
so we have to hard code the connector parameters
in the driver.

Reported-by: Albrecht Dreß <albrecht.dress@arcor.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_combios.c |   51 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_mode.h    |    3 +-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 576f4f6..558e5c0 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -1536,6 +1536,9 @@ bool radeon_get_legacy_connector_info_from_table(struct drm_device *dev)
 			   of_machine_is_compatible("PowerBook6,7")) {
 			/* ibook */
 			rdev->mode_info.connector_table = CT_IBOOK;
+		} else if (of_machine_is_compatible("PowerMac3,5")) {
+			/* PowerMac G4 Silver radeon 7500 */
+			rdev->mode_info.connector_table = CT_MAC_G4_SILVER;
 		} else if (of_machine_is_compatible("PowerMac4,4")) {
 			/* emac */
 			rdev->mode_info.connector_table = CT_EMAC;
@@ -2200,6 +2203,54 @@ bool radeon_get_legacy_connector_info_from_table(struct drm_device *dev)
 					    CONNECTOR_OBJECT_ID_SVIDEO,
 					    &hpd);
 		break;
+	case CT_MAC_G4_SILVER:
+		DRM_INFO("Connector Table: %d (mac g4 silver)\n",
+			 rdev->mode_info.connector_table);
+		/* DVI-I - tv dac, int tmds */
+		ddc_i2c = combios_setup_i2c_bus(rdev, DDC_DVI, 0, 0);
+		hpd.hpd = RADEON_HPD_1; /* ??? */
+		radeon_add_legacy_encoder(dev,
+					  radeon_get_encoder_enum(dev,
+								ATOM_DEVICE_DFP1_SUPPORT,
+								0),
+					  ATOM_DEVICE_DFP1_SUPPORT);
+		radeon_add_legacy_encoder(dev,
+					  radeon_get_encoder_enum(dev,
+								ATOM_DEVICE_CRT2_SUPPORT,
+								2),
+					  ATOM_DEVICE_CRT2_SUPPORT);
+		radeon_add_legacy_connector(dev, 0,
+					    ATOM_DEVICE_DFP1_SUPPORT |
+					    ATOM_DEVICE_CRT2_SUPPORT,
+					    DRM_MODE_CONNECTOR_DVII, &ddc_i2c,
+					    CONNECTOR_OBJECT_ID_SINGLE_LINK_DVI_I,
+					    &hpd);
+		/* VGA - primary dac */
+		ddc_i2c = combios_setup_i2c_bus(rdev, DDC_VGA, 0, 0);
+		hpd.hpd = RADEON_HPD_NONE;
+		radeon_add_legacy_encoder(dev,
+					  radeon_get_encoder_enum(dev,
+								ATOM_DEVICE_CRT1_SUPPORT,
+								1),
+					  ATOM_DEVICE_CRT1_SUPPORT);
+		radeon_add_legacy_connector(dev, 1, ATOM_DEVICE_CRT1_SUPPORT,
+					    DRM_MODE_CONNECTOR_VGA, &ddc_i2c,
+					    CONNECTOR_OBJECT_ID_VGA,
+					    &hpd);
+		/* TV - TV DAC */
+		ddc_i2c.valid = false;
+		hpd.hpd = RADEON_HPD_NONE;
+		radeon_add_legacy_encoder(dev,
+					  radeon_get_encoder_enum(dev,
+								ATOM_DEVICE_TV1_SUPPORT,
+								2),
+					  ATOM_DEVICE_TV1_SUPPORT);
+		radeon_add_legacy_connector(dev, 2, ATOM_DEVICE_TV1_SUPPORT,
+					    DRM_MODE_CONNECTOR_SVIDEO,
+					    &ddc_i2c,
+					    CONNECTOR_OBJECT_ID_SVIDEO,
+					    &hpd);
+		break;
 	default:
 		DRM_INFO("Connector table: %d (invalid)\n",
 			 rdev->mode_info.connector_table);
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index ce32fa9..7a9ac40 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -210,7 +210,8 @@ enum radeon_connector_table {
 	CT_RN50_POWER,
 	CT_MAC_X800,
 	CT_MAC_G5_9600,
-	CT_SAM440EP
+	CT_SAM440EP,
+	CT_MAC_G4_SILVER
 };
 
 enum radeon_dvo_chip {
-- 
1.7.9.5

