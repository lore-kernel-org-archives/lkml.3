Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3ETKxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56085 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3ETKwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 038/115] drm/radeon: fix handling of v6 power tables
Date: Mon, 20 May 2013 11:50:38 +0100
Message-Id: <1369047116-9378-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 441e76ca83ac604eaf0f046def96d8e3a27eea28 upstream.

The code was mis-handling variable sized arrays.

Reported-by: Sylvain BERTRAND <sylware@legeek.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 78d584e..38d87e1 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2482,6 +2482,7 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 	int index = GetIndexIntoMasterTable(DATA, PowerPlayInfo);
         u16 data_offset;
 	u8 frev, crev;
+	u8 *power_state_offset;
 
 	if (!atom_parse_data_header(mode_info->atom_context, index, NULL,
 				   &frev, &crev, &data_offset))
@@ -2504,11 +2505,11 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 				       state_array->ucNumEntries, GFP_KERNEL);
 	if (!rdev->pm.power_state)
 		return state_index;
+	power_state_offset = (u8 *)state_array->states;
 	for (i = 0; i < state_array->ucNumEntries; i++) {
 		mode_index = 0;
-		power_state = (union pplib_power_state *)&state_array->states[i];
-		/* XXX this might be an inagua bug... */
-		non_clock_array_index = i; /* power_state->v2.nonClockInfoIndex */
+		power_state = (union pplib_power_state *)power_state_offset;
+		non_clock_array_index = power_state->v2.nonClockInfoIndex;
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
 		rdev->pm.power_state[i].clock_info = kzalloc(sizeof(struct radeon_pm_clock_info) *
@@ -2520,9 +2521,6 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 		if (power_state->v2.ucNumDPMLevels) {
 			for (j = 0; j < power_state->v2.ucNumDPMLevels; j++) {
 				clock_array_index = power_state->v2.clockInfoIndex[j];
-				/* XXX this might be an inagua bug... */
-				if (clock_array_index >= clock_info_array->ucNumEntries)
-					continue;
 				clock_info = (union pplib_clock_info *)
 					&clock_info_array->clockInfo[clock_array_index * clock_info_array->ucEntrySize];
 				valid = radeon_atombios_parse_pplib_clock_info(rdev,
@@ -2544,6 +2542,7 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 								   non_clock_info);
 			state_index++;
 		}
+		power_state_offset += 2 + power_state->v2.ucNumDPMLevels;
 	}
 	/* if multiple clock modes, mark the lowest as no display */
 	for (i = 0; i < state_index; i++) {
-- 
1.8.1.2

