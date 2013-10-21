Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3JUIve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39523 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694Ab3JUIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.541937954@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 062/149] drm/radeon/atom: workaround vbios bug in
 transmitter table on rs880 (v2)
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 91f3a6aaf280294b07c05dfe606e6c27b7ba3c72 upstream.

The OUTPUT_ENABLE action jumps past the point in the coder where
the data_offset is set on certain rs780 cards.  This worked
previously because the OUTPUT_ENABLE action is always called
immediately after the ENABLE action so the data_offset remained
set.  In 6f8bbaf568c7f2c497558bfd04654c0b9841ad57
(drm/radeon/atom: initialize more atom interpretor elements to 0),
we explictly reset data_offset to 0 between atom calls which then
caused this to fail.  The fix is to just skip calling the
OUTPUT_ENABLE action on the problematic chipsets.  The ENABLE
action does the same thing and more.  Ultimately, we could
probably drop the OUTPUT_ENABLE action all together on DCE3
asics.

fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60791

v2: only rs880 seems to be affected

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1385,8 +1385,12 @@ radeon_atom_encoder_dpms_dig(struct drm_
 			atombios_dig_encoder_setup(encoder, ATOM_ENABLE, 0);
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_SETUP, 0, 0);
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
-			/* some early dce3.2 boards have a bug in their transmitter control table */
-			if ((rdev->family != CHIP_RV710) && (rdev->family != CHIP_RV730))
+			/* some dce3.x boards have a bug in their transmitter control table.
+			 * ACTION_ENABLE_OUTPUT can probably be dropped since ACTION_ENABLE
+			 * does the same thing and more.
+			 */
+			if ((rdev->family != CHIP_RV710) && (rdev->family != CHIP_RV730) &&
+			    (rdev->family != CHIP_RS880))
 				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {

