Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab3ERDPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:15:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663Ab3ERDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:14 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LXa1dq4ucqkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JDvErGSBc4oA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=LKAOgVyRmNvUTPBgwCEA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021700.707550941@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 119/136 ] drm/radeon: update wait_for_vblank for r5xx-r7xx
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0119-drm-radeon-update-wait_for_vblank-for-r5xx-r7xx.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit bea5497bfc1067620c8c8e9d37a42e0bb6d7d7fa ]

Properly wait for the next vblank region.  The previous
code didn't always wait long enough depending on the timing.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/rs600.c |   54 ++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 5301b3d..78aa835 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -46,21 +46,61 @@
 void rs600_gpu_init(struct radeon_device *rdev);
 int rs600_mc_wait_for_idle(struct radeon_device *rdev);
 
+static bool avivo_is_in_vblank(struct radeon_device *rdev, int crtc)
+{
+	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc];
+
+	if (RREG32(AVIVO_D1CRTC_STATUS + radeon_crtc->crtc_offset) & AVIVO_D1CRTC_V_BLANK)
+		return true;
+	else
+		return false;
+}
+
+static bool avivo_is_counter_moving(struct radeon_device *rdev, int crtc)
+{
+	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc];
+	u32 pos1, pos2;
+
+	pos1 = RREG32(AVIVO_D1CRTC_STATUS_POSITION + radeon_crtc->crtc_offset);
+	pos2 = RREG32(AVIVO_D1CRTC_STATUS_POSITION + radeon_crtc->crtc_offset);
+
+	if (pos1 != pos2)
+		return true;
+	else
+		return false;
+}
+
+/**
+ * avivo_wait_for_vblank - vblank wait asic callback.
+ *
+ * @rdev: radeon_device pointer
+ * @crtc: crtc to wait for vblank on
+ *
+ * Wait for vblank on the requested crtc (r5xx-r7xx).
+ */
 void avivo_wait_for_vblank(struct radeon_device *rdev, int crtc)
 {
 	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc];
-	int i;
+	unsigned i = 0;
+
+	if (!(RREG32(AVIVO_D1CRTC_CONTROL + radeon_crtc->crtc_offset) & AVIVO_CRTC_EN))
+		return;
 
-	if (RREG32(AVIVO_D1CRTC_CONTROL + radeon_crtc->crtc_offset) & AVIVO_CRTC_EN) {
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (!(RREG32(AVIVO_D1CRTC_STATUS + radeon_crtc->crtc_offset) & AVIVO_D1CRTC_V_BLANK))
+	/* depending on when we hit vblank, we may be close to active; if so,
+	 * wait for another frame.
+	 */
+	while (avivo_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!avivo_is_counter_moving(rdev, crtc))
 				break;
 			udelay(1);
 		}
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (RREG32(AVIVO_D1CRTC_STATUS + radeon_crtc->crtc_offset) & AVIVO_D1CRTC_V_BLANK)
+	}
+
+	while (!avivo_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!avivo_is_counter_moving(rdev, crtc))
 				break;
-			udelay(1);
 		}
 	}
 }
-- 
1.7.10.4


