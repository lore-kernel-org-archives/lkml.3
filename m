Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3ETLO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:14:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56110 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab3ETKwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 043/115] drm/radeon: properly lock disp in mc_stop/resume for evergreen+
Date: Mon, 20 May 2013 11:50:43 +0100
Message-Id: <1369047116-9378-44-git-send-email-luis.henriques@canonical.com>
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

commit 968c01664ccbe0e46c19a1af662c4c266a904203 upstream.

Need to wait for the new addresses to take affect before
re-enabling the MC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c     | 47 +++++++++++++++++++++++++++++++---
 drivers/gpu/drm/radeon/evergreen_reg.h |  2 ++
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 9cf8f35..1ed051e 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1157,18 +1157,14 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 				if (!(tmp & EVERGREEN_CRTC_BLANK_DATA_EN)) {
 					radeon_wait_for_vblank(rdev, i);
 					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
-					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
-					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			} else {
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE)) {
 					radeon_wait_for_vblank(rdev, i);
 					tmp |= EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
-					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
-					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			}
 			/* wait for the next frame */
@@ -1195,6 +1191,22 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 	}
 	/* wait for the MC to settle */
 	udelay(100);
+
+	/* lock double buffered regs */
+	for (i = 0; i < rdev->num_crtc; i++) {
+		if (save->crtc_enabled[i]) {
+			tmp = RREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i]);
+			if (!(tmp & EVERGREEN_GRPH_UPDATE_LOCK)) {
+				tmp |= EVERGREEN_GRPH_UPDATE_LOCK;
+				WREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i], tmp);
+			}
+			tmp = RREG32(EVERGREEN_MASTER_UPDATE_LOCK + crtc_offsets[i]);
+			if (!(tmp & 1)) {
+				tmp |= 1;
+				WREG32(EVERGREEN_MASTER_UPDATE_LOCK + crtc_offsets[i], tmp);
+			}
+		}
+	}
 }
 
 void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save)
@@ -1216,6 +1228,33 @@ void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *s
 	WREG32(EVERGREEN_VGA_MEMORY_BASE_ADDRESS_HIGH, upper_32_bits(rdev->mc.vram_start));
 	WREG32(EVERGREEN_VGA_MEMORY_BASE_ADDRESS, (u32)rdev->mc.vram_start);
 
+	/* unlock regs and wait for update */
+	for (i = 0; i < rdev->num_crtc; i++) {
+		if (save->crtc_enabled[i]) {
+			tmp = RREG32(EVERGREEN_MASTER_UPDATE_MODE + crtc_offsets[i]);
+			if ((tmp & 0x3) != 0) {
+				tmp &= ~0x3;
+				WREG32(EVERGREEN_MASTER_UPDATE_MODE + crtc_offsets[i], tmp);
+			}
+			tmp = RREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i]);
+			if (tmp & EVERGREEN_GRPH_UPDATE_LOCK) {
+				tmp &= ~EVERGREEN_GRPH_UPDATE_LOCK;
+				WREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i], tmp);
+			}
+			tmp = RREG32(EVERGREEN_MASTER_UPDATE_LOCK + crtc_offsets[i]);
+			if (tmp & 1) {
+				tmp &= ~1;
+				WREG32(EVERGREEN_MASTER_UPDATE_LOCK + crtc_offsets[i], tmp);
+			}
+			for (j = 0; j < rdev->usec_timeout; j++) {
+				tmp = RREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i]);
+				if ((tmp & EVERGREEN_GRPH_SURFACE_UPDATE_PENDING) == 0)
+					break;
+				udelay(1);
+			}
+		}
+	}
+
 	/* unblackout the MC */
 	tmp = RREG32(MC_SHARED_BLACKOUT_CNTL);
 	tmp &= ~BLACKOUT_MODE_MASK;
diff --git a/drivers/gpu/drm/radeon/evergreen_reg.h b/drivers/gpu/drm/radeon/evergreen_reg.h
index 034f4c2..3e9773a 100644
--- a/drivers/gpu/drm/radeon/evergreen_reg.h
+++ b/drivers/gpu/drm/radeon/evergreen_reg.h
@@ -225,6 +225,8 @@
 #define EVERGREEN_CRTC_STATUS_POSITION                  0x6e90
 #define EVERGREEN_MASTER_UPDATE_MODE                    0x6ef8
 #define EVERGREEN_CRTC_UPDATE_LOCK                      0x6ed4
+#define EVERGREEN_MASTER_UPDATE_LOCK                    0x6ef4
+#define EVERGREEN_MASTER_UPDATE_MODE                    0x6ef8
 
 #define EVERGREEN_DC_GPIO_HPD_MASK                      0x64b0
 #define EVERGREEN_DC_GPIO_HPD_A                         0x64b4
-- 
1.8.1.2

