Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3EIW0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:26:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab3EIW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 51/73] drm/radeon: properly lock disp in mc_stop/resume for r5xx-r7xx
Date: Thu,  9 May 2013 15:25:41 -0700
Message-Id: <20130509222531.616558188@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2f86e2ede39a98650c2d465857405ef1c51372b1 upstream.

Need to wait for the new addresses to take affect before
re-enabling the MC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r500_reg.h |    1 
 drivers/gpu/drm/radeon/rv515.c    |   43 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

--- a/drivers/gpu/drm/radeon/r500_reg.h
+++ b/drivers/gpu/drm/radeon/r500_reg.h
@@ -358,6 +358,7 @@
 #define AVIVO_D1CRTC_STATUS_HV_COUNT                            0x60ac
 #define AVIVO_D1CRTC_STEREO_CONTROL                             0x60c4
 
+#define AVIVO_D1MODE_MASTER_UPDATE_LOCK                         0x60e0
 #define AVIVO_D1MODE_MASTER_UPDATE_MODE                         0x60e4
 
 /* master controls */
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -338,6 +338,22 @@ void rv515_mc_stop(struct radeon_device
 	}
 	/* wait for the MC to settle */
 	udelay(100);
+
+	/* lock double buffered regs */
+	for (i = 0; i < rdev->num_crtc; i++) {
+		if (save->crtc_enabled[i]) {
+			tmp = RREG32(AVIVO_D1GRPH_UPDATE + crtc_offsets[i]);
+			if (!(tmp & AVIVO_D1GRPH_UPDATE_LOCK)) {
+				tmp |= AVIVO_D1GRPH_UPDATE_LOCK;
+				WREG32(AVIVO_D1GRPH_UPDATE + crtc_offsets[i], tmp);
+			}
+			tmp = RREG32(AVIVO_D1MODE_MASTER_UPDATE_LOCK + crtc_offsets[i]);
+			if (!(tmp & 1)) {
+				tmp |= 1;
+				WREG32(AVIVO_D1MODE_MASTER_UPDATE_LOCK + crtc_offsets[i], tmp);
+			}
+		}
+	}
 }
 
 void rv515_mc_resume(struct radeon_device *rdev, struct rv515_mc_save *save)
@@ -367,6 +383,33 @@ void rv515_mc_resume(struct radeon_devic
 	}
 	WREG32(R_000310_VGA_MEMORY_BASE_ADDRESS, (u32)rdev->mc.vram_start);
 
+	/* unlock regs and wait for update */
+	for (i = 0; i < rdev->num_crtc; i++) {
+		if (save->crtc_enabled[i]) {
+			tmp = RREG32(AVIVO_D1MODE_MASTER_UPDATE_MODE + crtc_offsets[i]);
+			if ((tmp & 0x3) != 0) {
+				tmp &= ~0x3;
+				WREG32(AVIVO_D1MODE_MASTER_UPDATE_MODE + crtc_offsets[i], tmp);
+			}
+			tmp = RREG32(AVIVO_D1GRPH_UPDATE + crtc_offsets[i]);
+			if (tmp & AVIVO_D1GRPH_UPDATE_LOCK) {
+				tmp &= ~AVIVO_D1GRPH_UPDATE_LOCK;
+				WREG32(AVIVO_D1GRPH_UPDATE + crtc_offsets[i], tmp);
+			}
+			tmp = RREG32(AVIVO_D1MODE_MASTER_UPDATE_LOCK + crtc_offsets[i]);
+			if (tmp & 1) {
+				tmp &= ~1;
+				WREG32(AVIVO_D1MODE_MASTER_UPDATE_LOCK + crtc_offsets[i], tmp);
+			}
+			for (j = 0; j < rdev->usec_timeout; j++) {
+				tmp = RREG32(AVIVO_D1GRPH_UPDATE + crtc_offsets[i]);
+				if ((tmp & AVIVO_D1GRPH_SURFACE_UPDATE_PENDING) == 0)
+					break;
+				udelay(1);
+			}
+		}
+	}
+
 	if (rdev->family >= CHIP_R600) {
 		/* unblackout the MC */
 		if (rdev->family >= CHIP_RV770)


