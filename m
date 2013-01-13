Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3AMR4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:56:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34943 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091Ab3AMRpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:24 -0500
Message-Id: <20130113174259.188202868@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:11 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Dave Airlie <airlied@redhat.com>
Subject: [ 16/49] drm/radeon: add connector table for SAM440ep embedded board
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6a556039e7823d27a0a7f7724d4d455053ea9253 upstream.

RV250 found on ppc embedded boards.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_combios.c |   66 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_mode.h    |    1 +
 2 files changed, 67 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 2cad9fd..576f4f6 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -1561,6 +1561,11 @@ bool radeon_get_legacy_connector_info_from_table(struct drm_device *dev)
 			   (rdev->pdev->subsystem_device == 0x4150)) {
 			/* Mac G5 tower 9600 */
 			rdev->mode_info.connector_table = CT_MAC_G5_9600;
+		} else if ((rdev->pdev->device == 0x4c66) &&
+			   (rdev->pdev->subsystem_vendor == 0x1002) &&
+			   (rdev->pdev->subsystem_device == 0x4c66)) {
+			/* SAM440ep RV250 embedded board */
+			rdev->mode_info.connector_table = CT_SAM440EP;
 		} else
 #endif /* CONFIG_PPC_PMAC */
 #ifdef CONFIG_PPC64
@@ -2134,6 +2139,67 @@ bool radeon_get_legacy_connector_info_from_table(struct drm_device *dev)
 					    CONNECTOR_OBJECT_ID_SVIDEO,
 					    &hpd);
 		break;
+	case CT_SAM440EP:
+		DRM_INFO("Connector Table: %d (SAM440ep embedded board)\n",
+			 rdev->mode_info.connector_table);
+		/* LVDS */
+		ddc_i2c = combios_setup_i2c_bus(rdev, DDC_NONE_DETECTED, 0, 0);
+		hpd.hpd = RADEON_HPD_NONE;
+		radeon_add_legacy_encoder(dev,
+					  radeon_get_encoder_enum(dev,
+								ATOM_DEVICE_LCD1_SUPPORT,
+								0),
+					  ATOM_DEVICE_LCD1_SUPPORT);
+		radeon_add_legacy_connector(dev, 0, ATOM_DEVICE_LCD1_SUPPORT,
+					    DRM_MODE_CONNECTOR_LVDS, &ddc_i2c,
+					    CONNECTOR_OBJECT_ID_LVDS,
+					    &hpd);
+		/* DVI-I - secondary dac, int tmds */
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
+		radeon_add_legacy_connector(dev, 1,
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
+		radeon_add_legacy_connector(dev, 2,
+					    ATOM_DEVICE_CRT1_SUPPORT,
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
+		radeon_add_legacy_connector(dev, 3, ATOM_DEVICE_TV1_SUPPORT,
+					    DRM_MODE_CONNECTOR_SVIDEO,
+					    &ddc_i2c,
+					    CONNECTOR_OBJECT_ID_SVIDEO,
+					    &hpd);
+		break;
 	default:
 		DRM_INFO("Connector table: %d (invalid)\n",
 			 rdev->mode_info.connector_table);
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 0c3cdbd..499a5fe 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -210,6 +210,7 @@ enum radeon_connector_table {
 	CT_RN50_POWER,
 	CT_MAC_X800,
 	CT_MAC_G5_9600,
+	CT_SAM440EP
 };
 
 enum radeon_dvo_chip {


