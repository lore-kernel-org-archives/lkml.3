Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab3ERDQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:16:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab3ERDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:13 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=B7NhjVEVSPQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JDvErGSBc4oA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=31FYUmqyeZ1yupaIOyYA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021701.015115888@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 121/136 ] drm/radeon: update wait_for_vblank for r1xx-r4xx
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0121-drm-radeon-update-wait_for_vblank-for-r1xx-r4xx.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 2b48b968c0d00aa5ab520b65a15a4f374cda7dda ]

Properly wait for the next vblank region.  The previous
code didn't always wait long enough depending on the timing.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/r100.c |   77 ++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 8d7e33a..b08b5b9 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -70,6 +70,38 @@ MODULE_FIRMWARE(FIRMWARE_R520);
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
@@ -81,33 +113,30 @@ MODULE_FIRMWARE(FIRMWARE_R520);
 void r100_wait_for_vblank(struct radeon_device *rdev, int crtc)
 {
 	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc];
-	int i;
+	unsigned i = 0;
 
 	if (radeon_crtc->crtc_id == 0) {
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
-- 
1.7.10.4


