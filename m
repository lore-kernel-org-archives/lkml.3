Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab3FEVUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:20:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab3FEVM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:12:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 31/44] drm/radeon: fix card_posted check for newer asics
Date: Wed,  5 Jun 2013 14:12:29 -0700
Message-Id: <20130605211225.094839749@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 09fb8bd1a63b0f9f15e655c4fe8d047e5d2bf67a upstream.

Newer asics have variable numbers of crtcs.  Use that
rather than the asic family to determine which crtcs
to check.  This avoids checking non-existent crtcs or
missing crtcs on certain asics.

Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_device.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -363,18 +363,17 @@ bool radeon_card_posted(struct radeon_de
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


