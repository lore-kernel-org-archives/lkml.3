Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaIOWOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:14:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50867 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbaIOWOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:14:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 154/187] drm/radeon/atom: add new voltage fetch function for hawaii
Date: Mon, 15 Sep 2014 15:09:24 -0700
Message-Id: <1410818997-9432-155-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e9f274b2a1bd4ecc569b823b1e7942e9bf92593e upstream.

Some hawaii boards use a different method for fetching the
voltage information from the vbios.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon.h          |  3 +++
 drivers/gpu/drm/radeon/radeon_atombios.c | 35 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 68b29d9..6cc9331 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -289,6 +289,9 @@ int radeon_atom_get_leakage_vddc_based_on_leakage_params(struct radeon_device *r
 							 u16 *vddc, u16 *vddci,
 							 u16 virtual_voltage_id,
 							 u16 vbios_voltage_id);
+int radeon_atom_get_voltage_evv(struct radeon_device *rdev,
+				u16 virtual_voltage_id,
+				u16 *voltage);
 int radeon_atom_round_to_true_voltage(struct radeon_device *rdev,
 				      u8 voltage_type,
 				      u16 nominal_voltage,
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 402d463..4af5a78 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -3236,6 +3236,41 @@ int radeon_atom_get_leakage_vddc_based_on_leakage_params(struct radeon_device *r
 	return 0;
 }
 
+union get_voltage_info {
+	struct  _GET_VOLTAGE_INFO_INPUT_PARAMETER_V1_2 in;
+	struct  _GET_EVV_VOLTAGE_INFO_OUTPUT_PARAMETER_V1_2 evv_out;
+};
+
+int radeon_atom_get_voltage_evv(struct radeon_device *rdev,
+				u16 virtual_voltage_id,
+				u16 *voltage)
+{
+	int index = GetIndexIntoMasterTable(COMMAND, GetVoltageInfo);
+	u32 entry_id;
+	u32 count = rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.count;
+	union get_voltage_info args;
+
+	for (entry_id = 0; entry_id < count; entry_id++) {
+		if (rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.entries[entry_id].v ==
+		    virtual_voltage_id)
+			break;
+	}
+
+	if (entry_id >= count)
+		return -EINVAL;
+
+	args.in.ucVoltageType = VOLTAGE_TYPE_VDDC;
+	args.in.ucVoltageMode = ATOM_GET_VOLTAGE_EVV_VOLTAGE;
+	args.in.ulSCLKFreq =
+		cpu_to_le32(rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.entries[entry_id].clk);
+
+	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+
+	*voltage = le16_to_cpu(args.evv_out.usVoltageLevel);
+
+	return 0;
+}
+
 int radeon_atom_get_voltage_gpio_settings(struct radeon_device *rdev,
 					  u16 voltage_level, u8 voltage_type,
 					  u32 *gpio_value, u32 *gpio_mask)
-- 
1.9.1

