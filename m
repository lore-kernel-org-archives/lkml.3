Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab3GCSyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:54:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31313 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab3GCSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:56 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=i1YXgyqgbXwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fDzRA8jHWsoA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=DBEIwHZtFz6s429R:21 a=6SlrXzAHoUUvTEUG:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184050.745346488@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [037/141] drm/radeon: fix card_posted check for newer asics
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0037-drm-radeon-fix-card_posted-check-for-newer-asics.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 09fb8bd1a63b0f9f15e655c4fe8d047e5d2bf67a ]

Newer asics have variable numbers of crtcs.  Use that
rather than the asic family to determine which crtcs
to check.  This avoids checking non-existent crtcs or
missing crtcs on certain asics.

Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/radeon_device.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 7a3daeb..32cea73 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -431,18 +431,17 @@ bool radeon_card_posted(struct radeon_device *rdev)
 		return false;
 
 	/* first check CRTCs */
-	if (ASIC_IS_DCE41(rdev)) {
+	if (ASIC_IS_DCE4(rdev)) {
 		reg = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET) |
 			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET);
-		if (reg & EVERGREEN_CRTC_MASTER_EN)
-			return true;
-	} else if (ASIC_IS_DCE4(rdev)) {
-		reg = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET);
+			if (rdev->num_crtc >= 4) {
+				reg |= RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET) |
+					RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET);
+			}
+			if (rdev->num_crtc >= 6) {
+				reg |= RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET) |
+					RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET);
+			}
 		if (reg & EVERGREEN_CRTC_MASTER_EN)
 			return true;
 	} else if (ASIC_IS_AVIVO(rdev)) {
-- 
1.7.10.4


