Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3EIWsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:48:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab3EIWdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 55/73] drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)
Date: Thu,  9 May 2013 15:32:18 -0700
Message-Id: <20130509222803.889778915@linuxfoundation.org>
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

commit abf1457bbbe4c62066bd03c6d31837dea28644dc upstream.

Just disabling the mem requests should be enough, but
that doesn't seem to work correctly on efi systems.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=57567
https://bugs.freedesktop.org/show_bug.cgi?id=43655
https://bugzilla.kernel.org/show_bug.cgi?id=56441

v2: blank displays first, then disable.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1353,6 +1353,7 @@ void evergreen_mc_stop(struct radeon_dev
 				tmp = RREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_BLANK_DATA_EN)) {
 					radeon_wait_for_vblank(rdev, i);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
 					WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
 				}
@@ -1360,8 +1361,10 @@ void evergreen_mc_stop(struct radeon_dev
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE)) {
 					radeon_wait_for_vblank(rdev, i);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					tmp |= EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
 					WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			}
 			/* wait for the next frame */
@@ -1371,6 +1374,15 @@ void evergreen_mc_stop(struct radeon_dev
 					break;
 				udelay(1);
 			}
+
+			/* XXX this is a hack to avoid strange behavior with EFI on certain systems */
+			WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
+			tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
+			tmp &= ~EVERGREEN_CRTC_MASTER_EN;
+			WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+			WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
+			save->crtc_enabled[i] = false;
+			/* ***** */
 		} else {
 			save->crtc_enabled[i] = false;
 		}


