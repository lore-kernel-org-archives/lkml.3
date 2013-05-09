Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab3EIWd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:33:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab3EIWdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 51/73] drm/radeon: update wait_for_vblank for evergreen+
Date: Thu,  9 May 2013 15:32:14 -0700
Message-Id: <20130509222803.496199584@linuxfoundation.org>
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

commit 10257a6d8359c41407eb26b7ad7bf710a7e00155 upstream.

Properly wait for the next vblank region.  The previous
code didn't always wait long enough depending on the timing.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |   44 ++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -105,6 +105,27 @@ void evergreen_fix_pci_max_read_req_size
 	}
 }
 
+static bool dce4_is_in_vblank(struct radeon_device *rdev, int crtc)
+{
+	if (RREG32(EVERGREEN_CRTC_STATUS + crtc_offsets[crtc]) & EVERGREEN_CRTC_V_BLANK)
+		return true;
+	else
+		return false;
+}
+
+static bool dce4_is_counter_moving(struct radeon_device *rdev, int crtc)
+{
+	u32 pos1, pos2;
+
+	pos1 = RREG32(EVERGREEN_CRTC_STATUS_POSITION + crtc_offsets[crtc]);
+	pos2 = RREG32(EVERGREEN_CRTC_STATUS_POSITION + crtc_offsets[crtc]);
+
+	if (pos1 != pos2)
+		return true;
+	else
+		return false;
+}
+
 /**
  * dce4_wait_for_vblank - vblank wait asic callback.
  *
@@ -115,21 +136,28 @@ void evergreen_fix_pci_max_read_req_size
  */
 void dce4_wait_for_vblank(struct radeon_device *rdev, int crtc)
 {
-	int i;
+	unsigned i = 0;
 
 	if (crtc >= rdev->num_crtc)
 		return;
 
-	if (RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[crtc]) & EVERGREEN_CRTC_MASTER_EN) {
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (!(RREG32(EVERGREEN_CRTC_STATUS + crtc_offsets[crtc]) & EVERGREEN_CRTC_V_BLANK))
+	if (!(RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[crtc]) & EVERGREEN_CRTC_MASTER_EN))
+		return;
+
+	/* depending on when we hit vblank, we may be close to active; if so,
+	 * wait for another frame.
+	 */
+	while (dce4_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!dce4_is_counter_moving(rdev, crtc))
 				break;
-			udelay(1);
 		}
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (RREG32(EVERGREEN_CRTC_STATUS + crtc_offsets[crtc]) & EVERGREEN_CRTC_V_BLANK)
+	}
+
+	while (!dce4_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!dce4_is_counter_moving(rdev, crtc))
 				break;
-			udelay(1);
 		}
 	}
 }


