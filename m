Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab3ERDSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:18:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab3ERDAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:11 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=R5XFhYdM2VUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=nZY67rQhkJUA:10 a=zd2uoN0lAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=nv7G8JH7TvOyfoGN:21 a=pgo3y3UkzAVwXDKt:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021702.275955253@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 129/136 ] drm/radeon: fix possible segfault when parsing pm tables
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0129-drm-radeon-fix-possible-segfault-when-parsing-pm-tab.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f8e6bfc2ce162855fa4f9822a45659f4b542c960 ]

If we have a empty power table, bail early and allocate
the default power state.

Should fix:
https://bugs.freedesktop.org/show_bug.cgi?id=63865

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index d67d4f3..77fec04 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2023,6 +2023,8 @@ static int radeon_atombios_parse_power_table_1_3(struct radeon_device *rdev)
 	num_modes = power_info->info.ucNumOfPowerModeEntries;
 	if (num_modes > ATOM_MAX_NUMBEROF_POWER_BLOCK)
 		num_modes = ATOM_MAX_NUMBEROF_POWER_BLOCK;
+	if (num_modes == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) * num_modes, GFP_KERNEL);
 	if (!rdev->pm.power_state)
 		return state_index;
@@ -2421,6 +2423,8 @@ static int radeon_atombios_parse_power_table_4_5(struct radeon_device *rdev)
 	power_info = (union power_info *)(mode_info->atom_context->bios + data_offset);
 
 	radeon_atombios_add_pplib_thermal_controller(rdev, &power_info->pplib.sThermalController);
+	if (power_info->pplib.ucNumStates == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       power_info->pplib.ucNumStates, GFP_KERNEL);
 	if (!rdev->pm.power_state)
@@ -2519,6 +2523,8 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 	non_clock_info_array = (struct _NonClockInfoArray *)
 		(mode_info->atom_context->bios + data_offset +
 		 le16_to_cpu(power_info->pplib.usNonClockInfoArrayOffset));
+	if (state_array->ucNumEntries == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       state_array->ucNumEntries, GFP_KERNEL);
 	if (!rdev->pm.power_state)
@@ -2609,7 +2615,9 @@ void radeon_atombios_get_power_modes(struct radeon_device *rdev)
 		default:
 			break;
 		}
-	} else {
+	}
+
+	if (state_index == 0) {
 		rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state), GFP_KERNEL);
 		if (rdev->pm.power_state) {
 			rdev->pm.power_state[0].clock_info =
-- 
1.7.10.4


