Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3EJOVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57107 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754918Ab3EJOU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sylvain BERTRAND" <sylware@legeek.net>,
        "Alex Deucher" <alexander.deucher@amd.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.779969144@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [073/118] drm/radeon: fix handling of v6 power tables
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

commit 441e76ca83ac604eaf0f046def96d8e3a27eea28 upstream.

The code was mis-handling variable sized arrays.

Reported-by: Sylvain BERTRAND <sylware@legeek.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2447,6 +2447,7 @@ static int radeon_atombios_parse_power_t
 	int index = GetIndexIntoMasterTable(DATA, PowerPlayInfo);
         u16 data_offset;
 	u8 frev, crev;
+	u8 *power_state_offset;
 
 	if (!atom_parse_data_header(mode_info->atom_context, index, NULL,
 				   &frev, &crev, &data_offset))
@@ -2469,11 +2470,11 @@ static int radeon_atombios_parse_power_t
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
@@ -2485,9 +2486,6 @@ static int radeon_atombios_parse_power_t
 		if (power_state->v2.ucNumDPMLevels) {
 			for (j = 0; j < power_state->v2.ucNumDPMLevels; j++) {
 				clock_array_index = power_state->v2.clockInfoIndex[j];
-				/* XXX this might be an inagua bug... */
-				if (clock_array_index >= clock_info_array->ucNumEntries)
-					continue;
 				clock_info = (union pplib_clock_info *)
 					&clock_info_array->clockInfo[clock_array_index];
 				valid = radeon_atombios_parse_pplib_clock_info(rdev,
@@ -2509,6 +2507,7 @@ static int radeon_atombios_parse_power_t
 								   non_clock_info);
 			state_index++;
 		}
+		power_state_offset += 2 + power_state->v2.ucNumDPMLevels;
 	}
 	/* if multiple clock modes, mark the lowest as no display */
 	for (i = 0; i < state_index; i++) {

