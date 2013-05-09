Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab3EIWcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:32:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab3EIW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 52/73] drm/radeon: update wait_for_vblank for r1xx-r4xx
Date: Thu,  9 May 2013 15:25:42 -0700
Message-Id: <20130509222531.717503766@linuxfoundation.org>
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

commit 2b48b968c0d00aa5ab520b65a15a4f374cda7dda upstream.

Properly wait for the next vblank region.  The previous
code didn't always wait long enough depending on the timing.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r100.c |   77 ++++++++++++++++++++++++++++--------------
 1 file changed, 53 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -69,6 +69,38 @@ MODULE_FIRMWARE(FIRMWARE_R520);
  * and others in some cases.
  */
 
+static bool r100_is_in_vblank(struct radeon_device *rdev, int crtc)
+{
+	if (crtc == 0) {
+		if (RREG32(RADEON_CRTC_STATUS) & RADEON_CRTC_VBLANK_CUR)
+			return true;
+		else
+			return false;
+	} else {
+		if (RREG32(RADEON_CRTC2_STATUS) & RADEON_CRTC2_VBLANK_CUR)
+			return true;
+		else
+			return false;
+	}
+}
+
+static bool r100_is_counter_moving(struct radeon_device *rdev, int crtc)
+{
+	u32 vline1, vline2;
+
+	if (crtc == 0) {
+		vline1 = (RREG32(RADEON_CRTC_VLINE_CRNT_VLINE) >> 16) & RADEON_CRTC_V_TOTAL;
+		vline2 = (RREG32(RADEON_CRTC_VLINE_CRNT_VLINE) >> 16) & RADEON_CRTC_V_TOTAL;
+	} else {
+		vline1 = (RREG32(RADEON_CRTC2_VLINE_CRNT_VLINE) >> 16) & RADEON_CRTC_V_TOTAL;
+		vline2 = (RREG32(RADEON_CRTC2_VLINE_CRNT_VLINE) >> 16) & RADEON_CRTC_V_TOTAL;
+	}
+	if (vline1 != vline2)
+		return true;
+	else
+		return false;
+}
+
 /**
  * r100_wait_for_vblank - vblank wait asic callback.
  *
@@ -79,36 +111,33 @@ MODULE_FIRMWARE(FIRMWARE_R520);
  */
 void r100_wait_for_vblank(struct radeon_device *rdev, int crtc)
 {
-	int i;
+	unsigned i = 0;
 
 	if (crtc >= rdev->num_crtc)
 		return;
 
 	if (crtc == 0) {
-		if (RREG32(RADEON_CRTC_GEN_CNTL) & RADEON_CRTC_EN) {
-			for (i = 0; i < rdev->usec_timeout; i++) {
-				if (!(RREG32(RADEON_CRTC_STATUS) & RADEON_CRTC_VBLANK_CUR))
-					break;
-				udelay(1);
-			}
-			for (i = 0; i < rdev->usec_timeout; i++) {
-				if (RREG32(RADEON_CRTC_STATUS) & RADEON_CRTC_VBLANK_CUR)
-					break;
-				udelay(1);
-			}
-		}
+		if (!(RREG32(RADEON_CRTC_GEN_CNTL) & RADEON_CRTC_EN))
+			return;
 	} else {
-		if (RREG32(RADEON_CRTC2_GEN_CNTL) & RADEON_CRTC2_EN) {
-			for (i = 0; i < rdev->usec_timeout; i++) {
-				if (!(RREG32(RADEON_CRTC2_STATUS) & RADEON_CRTC2_VBLANK_CUR))
-					break;
-				udelay(1);
-			}
-			for (i = 0; i < rdev->usec_timeout; i++) {
-				if (RREG32(RADEON_CRTC2_STATUS) & RADEON_CRTC2_VBLANK_CUR)
-					break;
-				udelay(1);
-			}
+		if (!(RREG32(RADEON_CRTC2_GEN_CNTL) & RADEON_CRTC2_EN))
+			return;
+	}
+
+	/* depending on when we hit vblank, we may be close to active; if so,
+	 * wait for another frame.
+	 */
+	while (r100_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!r100_is_counter_moving(rdev, crtc))
+				break;
+		}
+	}
+
+	while (!r100_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!r100_is_counter_moving(rdev, crtc))
+				break;
 		}
 	}
 }


