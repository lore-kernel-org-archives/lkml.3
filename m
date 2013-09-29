Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab3I2Tbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:31:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab3I2TaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:30:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 38/71] drm/radeon: update line buffer allocation for dce8
Date: Sun, 29 Sep 2013 12:27:50 -0700
Message-Id: <20130929192646.098607477@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit bc01a8c7a24169f8b111b7dda6f5d8e7088309af upstream.

We need to allocate line buffer to each display when
setting up the watermarks.  Failure to do so can lead
to a blank screen.  This fixes blank screen problems
on dce8 asics.

Based on an initial fix from:
Jay Cornwall <jay.cornwall@amd.com>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c  |   29 ++++++++++++++++++++++-------
 drivers/gpu/drm/radeon/cikd.h |    4 ++++
 2 files changed, 26 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -6441,8 +6441,8 @@ static u32 dce8_line_buffer_adjust(struc
 				   struct radeon_crtc *radeon_crtc,
 				   struct drm_display_mode *mode)
 {
-	u32 tmp;
-
+	u32 tmp, buffer_alloc, i;
+	u32 pipe_offset = radeon_crtc->crtc_id * 0x20;
 	/*
 	 * Line Buffer Setup
 	 * There are 6 line buffers, one for each display controllers.
@@ -6452,22 +6452,37 @@ static u32 dce8_line_buffer_adjust(struc
 	 * them using the stereo blender.
 	 */
 	if (radeon_crtc->base.enabled && mode) {
-		if (mode->crtc_hdisplay < 1920)
+		if (mode->crtc_hdisplay < 1920) {
 			tmp = 1;
-		else if (mode->crtc_hdisplay < 2560)
+			buffer_alloc = 2;
+		} else if (mode->crtc_hdisplay < 2560) {
 			tmp = 2;
-		else if (mode->crtc_hdisplay < 4096)
+			buffer_alloc = 2;
+		} else if (mode->crtc_hdisplay < 4096) {
 			tmp = 0;
-		else {
+			buffer_alloc = (rdev->flags & RADEON_IS_IGP) ? 2 : 4;
+		} else {
 			DRM_DEBUG_KMS("Mode too big for LB!\n");
 			tmp = 0;
+			buffer_alloc = (rdev->flags & RADEON_IS_IGP) ? 2 : 4;
 		}
-	} else
+	} else {
 		tmp = 1;
+		buffer_alloc = 0;
+	}
 
 	WREG32(LB_MEMORY_CTRL + radeon_crtc->crtc_offset,
 	       LB_MEMORY_CONFIG(tmp) | LB_MEMORY_SIZE(0x6B0));
 
+	WREG32(PIPE0_DMIF_BUFFER_CONTROL + pipe_offset,
+	       DMIF_BUFFERS_ALLOCATED(buffer_alloc));
+	for (i = 0; i < rdev->usec_timeout; i++) {
+		if (RREG32(PIPE0_DMIF_BUFFER_CONTROL + pipe_offset) &
+		    DMIF_BUFFERS_ALLOCATED_COMPLETED)
+			break;
+		udelay(1);
+	}
+
 	if (radeon_crtc->base.enabled && mode) {
 		switch (tmp) {
 		case 0:
--- a/drivers/gpu/drm/radeon/cikd.h
+++ b/drivers/gpu/drm/radeon/cikd.h
@@ -43,6 +43,10 @@
 
 #define DMIF_ADDR_CALC  				0xC00
 
+#define	PIPE0_DMIF_BUFFER_CONTROL			  0x0ca0
+#       define DMIF_BUFFERS_ALLOCATED(x)                  ((x) << 0)
+#       define DMIF_BUFFERS_ALLOCATED_COMPLETED           (1 << 4)
+
 #define	SRBM_GFX_CNTL				        0xE44
 #define		PIPEID(x)					((x) << 0)
 #define		MEID(x)						((x) << 2)


