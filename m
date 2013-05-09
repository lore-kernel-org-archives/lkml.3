Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab3EIWtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:49:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab3EIWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 62/73] drm/radeon: disable the crtcs in mc_stop (r5xx-r7xx) (v2)
Date: Thu,  9 May 2013 15:32:25 -0700
Message-Id: <20130509222804.632655732@linuxfoundation.org>
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

commit e884fc640ccbdb6f94b9bdb57cfb8464b6688f4c upstream.

Just disabling the mem requests should be enough, but
that doesn't seem to work correctly on efi systems.

v2: blank displays first, then disable.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r500_reg.h |    1 +
 drivers/gpu/drm/radeon/rv515.c    |   11 +++++++++++
 2 files changed, 12 insertions(+)

--- a/drivers/gpu/drm/radeon/r500_reg.h
+++ b/drivers/gpu/drm/radeon/r500_reg.h
@@ -359,6 +359,7 @@
 
 #define AVIVO_D1MODE_MASTER_UPDATE_LOCK                         0x60e0
 #define AVIVO_D1MODE_MASTER_UPDATE_MODE                         0x60e4
+#define AVIVO_D1CRTC_UPDATE_LOCK                                0x60e8
 
 /* master controls */
 #define AVIVO_DC_CRTC_MASTER_EN                                 0x60f8
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -303,8 +303,10 @@ void rv515_mc_stop(struct radeon_device
 			tmp = RREG32(AVIVO_D1CRTC_CONTROL + crtc_offsets[i]);
 			if (!(tmp & AVIVO_CRTC_DISP_READ_REQUEST_DISABLE)) {
 				radeon_wait_for_vblank(rdev, i);
+				WREG32(AVIVO_D1CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 				tmp |= AVIVO_CRTC_DISP_READ_REQUEST_DISABLE;
 				WREG32(AVIVO_D1CRTC_CONTROL + crtc_offsets[i], tmp);
+				WREG32(AVIVO_D1CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 			}
 			/* wait for the next frame */
 			frame_count = radeon_get_vblank_counter(rdev, i);
@@ -313,6 +315,15 @@ void rv515_mc_stop(struct radeon_device
 					break;
 				udelay(1);
 			}
+
+			/* XXX this is a hack to avoid strange behavior with EFI on certain systems */
+			WREG32(AVIVO_D1CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
+			tmp = RREG32(AVIVO_D1CRTC_CONTROL + crtc_offsets[i]);
+			tmp &= ~AVIVO_CRTC_EN;
+			WREG32(AVIVO_D1CRTC_CONTROL + crtc_offsets[i], tmp);
+			WREG32(AVIVO_D1CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
+			save->crtc_enabled[i] = false;
+			/* ***** */
 		} else {
 			save->crtc_enabled[i] = false;
 		}


