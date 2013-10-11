Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab3JKKmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab3JKKmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 001/100] drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (v2)
Date: Fri, 11 Oct 2013 11:40:31 +0100
Message-Id: <1381488130-30235-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 66ecc38..64bc2bd 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1425,8 +1425,12 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *encoder, int mode)
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
-- 
1.8.3.2

