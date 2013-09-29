Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3I2Ty0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:54:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3I2T2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 29/49] drm/radeon: update line buffer allocation for dce6
Date: Sun, 29 Sep 2013 12:27:03 -0700
Message-Id: <20130929191604.988902175@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 290d24576ccf1aa0373d2185cedfe262d0d4952a upstream.

We need to allocate line buffer to each display when
setting up the watermarks.  Failure to do so can lead
to a blank screen.  This fixes blank screen problems
on dce6 asics.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=64850

Based on an initial fix from:
Jay Cornwall <jay.cornwall@amd.com>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si.c  |   23 +++++++++++++++++++----
 drivers/gpu/drm/radeon/sid.h |    4 ++++
 2 files changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1467,7 +1467,8 @@ static u32 dce6_line_buffer_adjust(struc
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *other_mode)
 {
-	u32 tmp;
+	u32 tmp, buffer_alloc, i;
+	u32 pipe_offset = radeon_crtc->crtc_id * 0x20;
 	/*
 	 * Line Buffer Setup
 	 * There are 3 line buffers, each one shared by 2 display controllers.
@@ -1482,16 +1483,30 @@ static u32 dce6_line_buffer_adjust(struc
 	 * non-linked crtcs for maximum line buffer allocation.
 	 */
 	if (radeon_crtc->base.enabled && mode) {
-		if (other_mode)
+		if (other_mode) {
 			tmp = 0; /* 1/2 */
-		else
+			buffer_alloc = 1;
+		} else {
 			tmp = 2; /* whole */
-	} else
+			buffer_alloc = 2;
+		}
+	} else {
 		tmp = 0;
+		buffer_alloc = 0;
+	}
 
 	WREG32(DC_LB_MEMORY_SPLIT + radeon_crtc->crtc_offset,
 	       DC_LB_MEMORY_CONFIG(tmp));
 
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
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -97,6 +97,10 @@
 
 #define DMIF_ADDR_CALC  				0xC00
 
+#define	PIPE0_DMIF_BUFFER_CONTROL			  0x0ca0
+#       define DMIF_BUFFERS_ALLOCATED(x)                  ((x) << 0)
+#       define DMIF_BUFFERS_ALLOCATED_COMPLETED           (1 << 4)
+
 #define	SRBM_STATUS				        0xE50
 #define		GRBM_RQ_PENDING 			(1 << 5)
 #define		VMC_BUSY 				(1 << 8)


