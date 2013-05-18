Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab3ERDQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:16:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655Ab3ERDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:13 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=SCNrpma2QbQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CMSfbe0zZ7sA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021700.854028336@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 120/136 ] drm/radeon: update wait_for_vblank for evergreen+
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0120-drm-radeon-update-wait_for_vblank-for-evergreen.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 10257a6d8359c41407eb26b7ad7bf710a7e00155 ]

Properly wait for the next vblank region.  The previous
code didn't always wait long enough depending on the timing.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/evergreen.c |   44 +++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 5528fea..6cb958b 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -109,6 +109,27 @@ void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
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
@@ -119,21 +140,28 @@ void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
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
-- 
1.7.10.4


