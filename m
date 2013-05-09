Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab3EIWdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:33:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab3EIWdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 64/73] drm/radeon: fix possible segfault when parsing pm tables
Date: Thu,  9 May 2013 15:32:27 -0700
Message-Id: <20130509222804.830683959@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f8e6bfc2ce162855fa4f9822a45659f4b542c960 upstream.

If we have a empty power table, bail early and allocate
the default power state.

Should fix:
https://bugs.freedesktop.org/show_bug.cgi?id=63865

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2028,6 +2028,8 @@ static int radeon_atombios_parse_power_t
 	num_modes = power_info->info.ucNumOfPowerModeEntries;
 	if (num_modes > ATOM_MAX_NUMBEROF_POWER_BLOCK)
 		num_modes = ATOM_MAX_NUMBEROF_POWER_BLOCK;
+	if (num_modes == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) * num_modes, GFP_KERNEL);
 	if (!rdev->pm.power_state)
 		return state_index;
@@ -2432,6 +2434,8 @@ static int radeon_atombios_parse_power_t
 	power_info = (union power_info *)(mode_info->atom_context->bios + data_offset);
 
 	radeon_atombios_add_pplib_thermal_controller(rdev, &power_info->pplib.sThermalController);
+	if (power_info->pplib.ucNumStates == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       power_info->pplib.ucNumStates, GFP_KERNEL);
 	if (!rdev->pm.power_state)
@@ -2530,6 +2534,8 @@ static int radeon_atombios_parse_power_t
 	non_clock_info_array = (struct _NonClockInfoArray *)
 		(mode_info->atom_context->bios + data_offset +
 		 le16_to_cpu(power_info->pplib.usNonClockInfoArrayOffset));
+	if (state_array->ucNumEntries == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       state_array->ucNumEntries, GFP_KERNEL);
 	if (!rdev->pm.power_state)
@@ -2620,7 +2626,9 @@ void radeon_atombios_get_power_modes(str
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


