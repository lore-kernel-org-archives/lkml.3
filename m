Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3JUJXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:23:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39457 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616Ab3JUIvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.987912759@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 043/149] drm/radeon: update line buffer allocation for
 dce4.1/5
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/evergreen.c  | 25 +++++++++++++++++++++----
 drivers/gpu/drm/radeon/evergreend.h |  4 ++++
 2 files changed, 25 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -501,7 +501,8 @@ static u32 evergreen_line_buffer_adjust(
 					struct drm_display_mode *mode,
 					struct drm_display_mode *other_mode)
 {
-	u32 tmp;
+	u32 tmp, buffer_alloc, i;
+	u32 pipe_offset = radeon_crtc->crtc_id * 0x20;
 	/*
 	 * Line Buffer Setup
 	 * There are 3 line buffers, each one shared by 2 display controllers.
@@ -524,18 +525,34 @@ static u32 evergreen_line_buffer_adjust(
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
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -459,6 +459,10 @@
 #       define LATENCY_LOW_WATERMARK(x)                   ((x) << 0)
 #       define LATENCY_HIGH_WATERMARK(x)                  ((x) << 16)
 
+#define	PIPE0_DMIF_BUFFER_CONTROL			  0x0ca0
+#       define DMIF_BUFFERS_ALLOCATED(x)                  ((x) << 0)
+#       define DMIF_BUFFERS_ALLOCATED_COMPLETED           (1 << 4)
+
 #define IH_RB_CNTL                                        0x3e00
 #       define IH_RB_ENABLE                               (1 << 0)
 #       define IH_IB_SIZE(x)                              ((x) << 1) /* log2 */

