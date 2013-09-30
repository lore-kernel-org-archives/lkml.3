Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3I3KXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:23:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43676 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3I3KNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 067/104] drm/radeon: update line buffer allocation for dce6
Date: Mon, 30 Sep 2013 11:10:44 +0100
Message-Id: <1380535881-9239-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/si.c  | 23 +++++++++++++++++++----
 drivers/gpu/drm/radeon/sid.h |  4 ++++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 625c4ba..d3454a0 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -411,7 +411,8 @@ static u32 dce6_line_buffer_adjust(struct radeon_device *rdev,
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *other_mode)
 {
-	u32 tmp;
+	u32 tmp, buffer_alloc, i;
+	u32 pipe_offset = radeon_crtc->crtc_id * 0x20;
 	/*
 	 * Line Buffer Setup
 	 * There are 3 line buffers, each one shared by 2 display controllers.
@@ -426,16 +427,30 @@ static u32 dce6_line_buffer_adjust(struct radeon_device *rdev,
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
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 916e13f..0a240fa 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -62,6 +62,10 @@
 
 #define DMIF_ADDR_CALC  				0xC00
 
+#define	PIPE0_DMIF_BUFFER_CONTROL			  0x0ca0
+#       define DMIF_BUFFERS_ALLOCATED(x)                  ((x) << 0)
+#       define DMIF_BUFFERS_ALLOCATED_COMPLETED           (1 << 4)
+
 #define	SRBM_STATUS				        0xE50
 
 #define	CC_SYS_RB_BACKEND_DISABLE			0xe80
-- 
1.8.3.2

