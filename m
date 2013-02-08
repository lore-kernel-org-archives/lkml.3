Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853Ab3BHBJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:09:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759594Ab3BHA57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Staite <chris@yourdreamnet.co.uk>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 05/26] drm/radeon: fix MC blackout on evergreen+
Date: Thu,  7 Feb 2013 16:57:33 -0800
Message-Id: <20130208004628.114671446@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Staite <chris@yourdreamnet.co.uk>

commit bb588820ef421c6098dca1fec29c3b347f1c8c19 upstream.

Force the crtc mem requests on/off immediately rather
than waiting for the double buffered updates to kick in.
Seems we miss the update in certain conditions.  Also
handle the DCE6 case.

Signed-off-by: Christopher Staite <chris@yourdreamnet.co.uk>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1147,14 +1147,18 @@ void evergreen_mc_stop(struct radeon_dev
 				if (!(tmp & EVERGREEN_CRTC_BLANK_DATA_EN)) {
 					radeon_wait_for_vblank(rdev, i);
 					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			} else {
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE)) {
 					radeon_wait_for_vblank(rdev, i);
 					tmp |= EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			}
 			/* wait for the next frame */
@@ -1214,11 +1218,15 @@ void evergreen_mc_resume(struct radeon_d
 			if (ASIC_IS_DCE6(rdev)) {
 				tmp = RREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i]);
 				tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 				WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 			} else {
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				tmp &= ~EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 				WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 			}
 			/* wait for the next frame */
 			frame_count = radeon_get_vblank_counter(rdev, i);


