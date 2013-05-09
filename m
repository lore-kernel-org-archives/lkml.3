Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3EIWwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:52:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898Ab3EIWdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 50/73] drm/radeon: update wait_for_vblank for r5xx-r7xx
Date: Thu,  9 May 2013 15:32:13 -0700
Message-Id: <20130509222803.396368205@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit bea5497bfc1067620c8c8e9d37a42e0bb6d7d7fa upstream.

Properly wait for the next vblank region.  The previous
code didn't always wait long enough depending on the timing.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rs600.c |   52 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -52,23 +52,59 @@ static const u32 crtc_offsets[2] =
 	AVIVO_D2CRTC_H_TOTAL - AVIVO_D1CRTC_H_TOTAL
 };
 
+static bool avivo_is_in_vblank(struct radeon_device *rdev, int crtc)
+{
+	if (RREG32(AVIVO_D1CRTC_STATUS + crtc_offsets[crtc]) & AVIVO_D1CRTC_V_BLANK)
+		return true;
+	else
+		return false;
+}
+
+static bool avivo_is_counter_moving(struct radeon_device *rdev, int crtc)
+{
+	u32 pos1, pos2;
+
+	pos1 = RREG32(AVIVO_D1CRTC_STATUS_POSITION + crtc_offsets[crtc]);
+	pos2 = RREG32(AVIVO_D1CRTC_STATUS_POSITION + crtc_offsets[crtc]);
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
-	int i;
+	unsigned i = 0;
 
 	if (crtc >= rdev->num_crtc)
 		return;
 
-	if (RREG32(AVIVO_D1CRTC_CONTROL + crtc_offsets[crtc]) & AVIVO_CRTC_EN) {
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (!(RREG32(AVIVO_D1CRTC_STATUS + crtc_offsets[crtc]) & AVIVO_D1CRTC_V_BLANK))
+	if (!(RREG32(AVIVO_D1CRTC_CONTROL + crtc_offsets[crtc]) & AVIVO_CRTC_EN))
+		return;
+
+	/* depending on when we hit vblank, we may be close to active; if so,
+	 * wait for another frame.
+	 */
+	while (avivo_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!avivo_is_counter_moving(rdev, crtc))
 				break;
-			udelay(1);
 		}
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (RREG32(AVIVO_D1CRTC_STATUS + crtc_offsets[crtc]) & AVIVO_D1CRTC_V_BLANK)
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


