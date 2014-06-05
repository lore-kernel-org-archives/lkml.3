Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaFEEVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaFEEVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Albrecht=20Dre=C3=9F?= <albrecht.dress@arcor.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 163/214] drm/radeon: add connector table for Mac G4 Silver
Date: Wed,  4 Jun 2014 21:18:46 -0700
Message-Id: <20140605041701.443380511@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cafa59b9011a7790be4ddd5979419259844a165d upstream.

Apple cards do not provide data tables in the vbios
so we have to hard code the connector parameters
in the driver.

Reported-by: Albrecht Dreß <albrecht.dress@arcor.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_combios.c |   51 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_mode.h    |    3 +
 2 files changed, 53 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -1484,6 +1484,9 @@ bool radeon_get_legacy_connector_info_fr
 			   of_machine_is_compatible("PowerBook6,7")) {
 			/* ibook */
 			rdev->mode_info.connector_table = CT_IBOOK;
+		} else if (of_machine_is_compatible("PowerMac3,5")) {
+			/* PowerMac G4 Silver radeon 7500 */
+			rdev->mode_info.connector_table = CT_MAC_G4_SILVER;
 		} else if (of_machine_is_compatible("PowerMac4,4")) {
 			/* emac */
 			rdev->mode_info.connector_table = CT_EMAC;
@@ -2146,6 +2149,54 @@ bool radeon_get_legacy_connector_info_fr
 					    DRM_MODE_CONNECTOR_SVIDEO,
 					    &ddc_i2c,
 					    CONNECTOR_OBJECT_ID_SVIDEO,
+					    &hpd);
+		break;
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
 					    &hpd);
 		break;
 	default:
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


