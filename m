Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934596Ab3BSTPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:15:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54175 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933881Ab3BSSuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Staite <chris@yourdreamnet.co.uk>,
        Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 10/81] drm/radeon: fix MC blackout on evergreen+
Date: Tue, 19 Feb 2013 15:48:33 -0300
Message-Id: <1361299784-8830-11-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Staite <chris@yourdreamnet.co.uk>

commit bb588820ef421c6098dca1fec29c3b347f1c8c19 upstream.

Force the crtc mem requests on/off immediately rather
than waiting for the double buffered updates to kick in.
Seems we miss the update in certain conditions.  Also
handle the DCE6 case.

Signed-off-by: Christopher Staite <chris@yourdreamnet.co.uk>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 2aa7fdb..c490d16 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1147,14 +1147,18 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 				if (!(tmp & EVERGREEN_CRTC_BLANK_DATA_EN)) {
 					radeon_wait_for_vblank(rdev, i);
 					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			} else {
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE)) {
 					radeon_wait_for_vblank(rdev, i);
 					tmp |= EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			}
 			/* wait for the next frame */
@@ -1212,11 +1216,15 @@ void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *s
 			if (ASIC_IS_DCE6(rdev)) {
 				tmp = RREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i]);
 				tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 				WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 			} else {
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				tmp &= ~EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 				WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 			}
 			/* wait for the next frame */
 			frame_count = radeon_get_vblank_counter(rdev, i);
-- 
1.7.9.5

