Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3ITU0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:26:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41573 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3ITUOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 47/93] drm/radeon: update line buffer allocation for dce4.1/5
Date: Fri, 20 Sep 2013 13:08:42 -0700
Message-Id: <1379707768-1804-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0b31e02363b0db4e7931561bc6c141436e729d9f upstream.

We need to allocate line buffer to each display when
setting up the watermarks.  Failure to do so can lead
to a blank screen.  This fixes blank screen problems
on dce4.1/5 asics.

Based on an initial fix from:
Jay Cornwall <jay.cornwall@amd.com>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c  | 25 +++++++++++++++++++++----
 drivers/gpu/drm/radeon/evergreend.h |  4 ++++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index eeb1aad..c7a0488 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -724,7 +724,8 @@ static u32 evergreen_line_buffer_adjust(struct radeon_device *rdev,
 					struct drm_display_mode *mode,
 					struct drm_display_mode *other_mode)
 {
-	u32 tmp;
+	u32 tmp, buffer_alloc, i;
+	u32 pipe_offset = radeon_crtc->crtc_id * 0x20;
 	/*
 	 * Line Buffer Setup
 	 * There are 3 line buffers, each one shared by 2 display controllers.
@@ -747,18 +748,34 @@ static u32 evergreen_line_buffer_adjust(struct radeon_device *rdev,
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
 
 	/* second controller of the pair uses second half of the lb */
 	if (radeon_crtc->crtc_id % 2)
 		tmp += 4;
 	WREG32(DC_LB_MEMORY_SPLIT + radeon_crtc->crtc_offset, tmp);
 
+	if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
+		WREG32(PIPE0_DMIF_BUFFER_CONTROL + pipe_offset,
+		       DMIF_BUFFERS_ALLOCATED(buffer_alloc));
+		for (i = 0; i < rdev->usec_timeout; i++) {
+			if (RREG32(PIPE0_DMIF_BUFFER_CONTROL + pipe_offset) &
+			    DMIF_BUFFERS_ALLOCATED_COMPLETED)
+				break;
+			udelay(1);
+		}
+	}
+
 	if (radeon_crtc->base.enabled && mode) {
 		switch (tmp) {
 		case 0:
diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/evergreend.h
index 0bfd0e9e..f410b4d 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -760,6 +760,10 @@
 #       define LATENCY_LOW_WATERMARK(x)                   ((x) << 0)
 #       define LATENCY_HIGH_WATERMARK(x)                  ((x) << 16)
 
+#define	PIPE0_DMIF_BUFFER_CONTROL			  0x0ca0
+#       define DMIF_BUFFERS_ALLOCATED(x)                  ((x) << 0)
+#       define DMIF_BUFFERS_ALLOCATED_COMPLETED           (1 << 4)
+
 #define IH_RB_CNTL                                        0x3e00
 #       define IH_RB_ENABLE                               (1 << 0)
 #       define IH_IB_SIZE(x)                              ((x) << 1) /* log2 */
-- 
1.8.1.2

