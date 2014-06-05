Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaFEEV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaFEEVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 162/214] drm/radeon: add connector table for SAM440ep embedded board
Date: Wed,  4 Jun 2014 21:18:45 -0700
Message-Id: <20140605041701.319658944@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6a556039e7823d27a0a7f7724d4d455053ea9253 upstream.

RV250 found on ppc embedded boards.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_combios.c |   66 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_mode.h    |    1 
 2 files changed, 67 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -1509,6 +1509,11 @@ bool radeon_get_legacy_connector_info_fr
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
@@ -2080,6 +2085,67 @@ bool radeon_get_legacy_connector_info_fr
 					    DRM_MODE_CONNECTOR_SVIDEO,
 					    &ddc_i2c,
 					    CONNECTOR_OBJECT_ID_SVIDEO,
+					    &hpd);
+		break;
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
 					    &hpd);
 		break;
 	default:
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -210,6 +210,7 @@ enum radeon_connector_table {
 	CT_RN50_POWER,
 	CT_MAC_X800,
 	CT_MAC_G5_9600,
+	CT_SAM440EP
 };
 
 enum radeon_dvo_chip {


