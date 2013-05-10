Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab3EJOVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57119 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754982Ab3EJOVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.204682631@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [072/118] drm/radeon: fix possible segfault when parsing pm tables
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f8e6bfc2ce162855fa4f9822a45659f4b542c960 upstream.

If we have a empty power table, bail early and allocate
the default power state.

Should fix:
https://bugs.freedesktop.org/show_bug.cgi?id=63865

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1989,6 +1989,8 @@ static int radeon_atombios_parse_power_t
 	num_modes = power_info->info.ucNumOfPowerModeEntries;
 	if (num_modes > ATOM_MAX_NUMBEROF_POWER_BLOCK)
 		num_modes = ATOM_MAX_NUMBEROF_POWER_BLOCK;
+	if (num_modes == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) * num_modes, GFP_KERNEL);
 	if (!rdev->pm.power_state)
 		return state_index;
@@ -2361,6 +2363,8 @@ static int radeon_atombios_parse_power_t
 	power_info = (union power_info *)(mode_info->atom_context->bios + data_offset);
 
 	radeon_atombios_add_pplib_thermal_controller(rdev, &power_info->pplib.sThermalController);
+	if (power_info->pplib.ucNumStates == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       power_info->pplib.ucNumStates, GFP_KERNEL);
 	if (!rdev->pm.power_state)
@@ -2459,6 +2463,8 @@ static int radeon_atombios_parse_power_t
 	non_clock_info_array = (struct NonClockInfoArray *)
 		(mode_info->atom_context->bios + data_offset +
 		 le16_to_cpu(power_info->pplib.usNonClockInfoArrayOffset));
+	if (state_array->ucNumEntries == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       state_array->ucNumEntries, GFP_KERNEL);
 	if (!rdev->pm.power_state)
@@ -2549,7 +2555,9 @@ void radeon_atombios_get_power_modes(str
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

