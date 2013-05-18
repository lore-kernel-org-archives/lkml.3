Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab3ERDSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:18:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607Ab3ERDAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:10 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=c97L0H1Y27kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=n5ZY8LWXLF8A:10 a=zd2uoN0lAAAA:8 a=OEdcoOUvAAAA:8 a=VwQbUJbxAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=wu_e27o_rKQA:10 a=ruvNhBkWaLwA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021702.592536655@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sylvain BERTRAND <sylware@legeek.net>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 131/136 ] drm/radeon: fix handling of v6 power tables
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0131-drm-radeon-fix-handling-of-v6-power-tables.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 441e76ca83ac604eaf0f046def96d8e3a27eea28 ]

The code was mis-handling variable sized arrays.

Reported-by: Sylvain BERTRAND <sylware@legeek.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 77fec04..3e3b3df 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2507,6 +2507,7 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 	int index = GetIndexIntoMasterTable(DATA, PowerPlayInfo);
         u16 data_offset;
 	u8 frev, crev;
+	u8 *power_state_offset;
 
 	if (!atom_parse_data_header(mode_info->atom_context, index, NULL,
 				   &frev, &crev, &data_offset))
@@ -2529,11 +2530,11 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
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
@@ -2545,9 +2546,6 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 		if (power_state->v2.ucNumDPMLevels) {
 			for (j = 0; j < power_state->v2.ucNumDPMLevels; j++) {
 				clock_array_index = power_state->v2.clockInfoIndex[j];
-				/* XXX this might be an inagua bug... */
-				if (clock_array_index >= clock_info_array->ucNumEntries)
-					continue;
 				clock_info = (union pplib_clock_info *)
 					&clock_info_array->clockInfo[clock_array_index * clock_info_array->ucEntrySize];
 				valid = radeon_atombios_parse_pplib_clock_info(rdev,
@@ -2569,6 +2567,7 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 								   non_clock_info);
 			state_index++;
 		}
+		power_state_offset += 2 + power_state->v2.ucNumDPMLevels;
 	}
 	/* if multiple clock modes, mark the lowest as no display */
 	for (i = 0; i < state_index; i++) {
-- 
1.7.10.4


