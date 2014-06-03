Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaFCLkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:40:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaFCLkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 012/138] drm/radeon: use pflip irq on R600+ v2
Date: Tue,  3 Jun 2014 12:37:38 +0100
Message-Id: <1401795584-22664-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit f5d636d2a74b755879feec35e14a259de52ccc07 upstream.

Testing the update pending bit directly after issuing an
update is nonsense cause depending on the pixel clock the
CRTC needs a bit of time to execute the flip even when we
are in the VBLANK period.

This is just a non invasive patch to solve the problem at
hand, a more complete and cleaner solution should follow
in the next merge window.

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=76564

v2: fix source IDs for CRTC2-6

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c            | 76 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/cikd.h           |  9 ++++
 drivers/gpu/drm/radeon/evergreen.c      | 28 +++++++++---
 drivers/gpu/drm/radeon/r600.c           | 13 ++++--
 drivers/gpu/drm/radeon/radeon.h         |  6 +++
 drivers/gpu/drm/radeon/radeon_display.c |  4 ++
 drivers/gpu/drm/radeon/si.c             | 28 +++++++++---
 7 files changed, 147 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 986537b59d7e..85647ab99fb1 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -5017,6 +5017,19 @@ static void cik_disable_interrupt_state(struct radeon_device *rdev)
 		WREG32(LB_INTERRUPT_MASK + EVERGREEN_CRTC4_REGISTER_OFFSET, 0);
 		WREG32(LB_INTERRUPT_MASK + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
 	}
+	/* pflip */
+	if (rdev->num_crtc >= 2) {
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET, 0);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET, 0);
+	}
+	if (rdev->num_crtc >= 4) {
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, 0);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, 0);
+	}
+	if (rdev->num_crtc >= 6) {
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, 0);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
+	}
 
 	/* dac hotplug */
 	WREG32(DAC_AUTODETECT_INT_CONTROL, 0);
@@ -5354,6 +5367,25 @@ int cik_irq_set(struct radeon_device *rdev)
 		WREG32(LB_INTERRUPT_MASK + EVERGREEN_CRTC5_REGISTER_OFFSET, crtc6);
 	}
 
+	if (rdev->num_crtc >= 2) {
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+	}
+	if (rdev->num_crtc >= 4) {
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+	}
+	if (rdev->num_crtc >= 6) {
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+	}
+
 	WREG32(DC_HPD1_INT_CONTROL, hpd1);
 	WREG32(DC_HPD2_INT_CONTROL, hpd2);
 	WREG32(DC_HPD3_INT_CONTROL, hpd3);
@@ -5385,6 +5417,29 @@ static inline void cik_irq_ack(struct radeon_device *rdev)
 	rdev->irq.stat_regs.cik.disp_int_cont5 = RREG32(DISP_INTERRUPT_STATUS_CONTINUE5);
 	rdev->irq.stat_regs.cik.disp_int_cont6 = RREG32(DISP_INTERRUPT_STATUS_CONTINUE6);
 
+	rdev->irq.stat_regs.cik.d1grph_int = RREG32(GRPH_INT_STATUS +
+		EVERGREEN_CRTC0_REGISTER_OFFSET);
+	rdev->irq.stat_regs.cik.d2grph_int = RREG32(GRPH_INT_STATUS +
+		EVERGREEN_CRTC1_REGISTER_OFFSET);
+	if (rdev->num_crtc >= 4) {
+		rdev->irq.stat_regs.cik.d3grph_int = RREG32(GRPH_INT_STATUS +
+			EVERGREEN_CRTC2_REGISTER_OFFSET);
+		rdev->irq.stat_regs.cik.d4grph_int = RREG32(GRPH_INT_STATUS +
+			EVERGREEN_CRTC3_REGISTER_OFFSET);
+	}
+	if (rdev->num_crtc >= 6) {
+		rdev->irq.stat_regs.cik.d5grph_int = RREG32(GRPH_INT_STATUS +
+			EVERGREEN_CRTC4_REGISTER_OFFSET);
+		rdev->irq.stat_regs.cik.d6grph_int = RREG32(GRPH_INT_STATUS +
+			EVERGREEN_CRTC5_REGISTER_OFFSET);
+	}
+
+	if (rdev->irq.stat_regs.cik.d1grph_int & GRPH_PFLIP_INT_OCCURRED)
+		WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC0_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_CLEAR);
+	if (rdev->irq.stat_regs.cik.d2grph_int & GRPH_PFLIP_INT_OCCURRED)
+		WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC1_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_CLEAR);
 	if (rdev->irq.stat_regs.cik.disp_int & LB_D1_VBLANK_INTERRUPT)
 		WREG32(LB_VBLANK_STATUS + EVERGREEN_CRTC0_REGISTER_OFFSET, VBLANK_ACK);
 	if (rdev->irq.stat_regs.cik.disp_int & LB_D1_VLINE_INTERRUPT)
@@ -5395,6 +5450,12 @@ static inline void cik_irq_ack(struct radeon_device *rdev)
 		WREG32(LB_VLINE_STATUS + EVERGREEN_CRTC1_REGISTER_OFFSET, VLINE_ACK);
 
 	if (rdev->num_crtc >= 4) {
+		if (rdev->irq.stat_regs.cik.d3grph_int & GRPH_PFLIP_INT_OCCURRED)
+			WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET,
+			       GRPH_PFLIP_INT_CLEAR);
+		if (rdev->irq.stat_regs.cik.d4grph_int & GRPH_PFLIP_INT_OCCURRED)
+			WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC3_REGISTER_OFFSET,
+			       GRPH_PFLIP_INT_CLEAR);
 		if (rdev->irq.stat_regs.cik.disp_int_cont2 & LB_D3_VBLANK_INTERRUPT)
 			WREG32(LB_VBLANK_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET, VBLANK_ACK);
 		if (rdev->irq.stat_regs.cik.disp_int_cont2 & LB_D3_VLINE_INTERRUPT)
@@ -5406,6 +5467,12 @@ static inline void cik_irq_ack(struct radeon_device *rdev)
 	}
 
 	if (rdev->num_crtc >= 6) {
+		if (rdev->irq.stat_regs.cik.d5grph_int & GRPH_PFLIP_INT_OCCURRED)
+			WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET,
+			       GRPH_PFLIP_INT_CLEAR);
+		if (rdev->irq.stat_regs.cik.d6grph_int & GRPH_PFLIP_INT_OCCURRED)
+			WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC5_REGISTER_OFFSET,
+			       GRPH_PFLIP_INT_CLEAR);
 		if (rdev->irq.stat_regs.cik.disp_int_cont4 & LB_D5_VBLANK_INTERRUPT)
 			WREG32(LB_VBLANK_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET, VBLANK_ACK);
 		if (rdev->irq.stat_regs.cik.disp_int_cont4 & LB_D5_VLINE_INTERRUPT)
@@ -5756,6 +5823,15 @@ restart_ih:
 				break;
 			}
 			break;
+		case 8: /* D1 page flip */
+		case 10: /* D2 page flip */
+		case 12: /* D3 page flip */
+		case 14: /* D4 page flip */
+		case 16: /* D5 page flip */
+		case 18: /* D6 page flip */
+			DRM_DEBUG("IH: D%d flip\n", ((src_id - 8) >> 1) + 1);
+			radeon_crtc_handle_flip(rdev, (src_id - 8) >> 1);
+			break;
 		case 42: /* HPD hotplug */
 			switch (src_data) {
 			case 0:
diff --git a/drivers/gpu/drm/radeon/cikd.h b/drivers/gpu/drm/radeon/cikd.h
index ade318ed9b70..302d2b756e94 100644
--- a/drivers/gpu/drm/radeon/cikd.h
+++ b/drivers/gpu/drm/radeon/cikd.h
@@ -370,6 +370,15 @@
 #       define DC_HPD6_RX_INTERRUPT                     (1 << 18)
 #define DISP_INTERRUPT_STATUS_CONTINUE6                 0x6780
 
+/* 0x6858, 0x7458, 0x10058, 0x10c58, 0x11858, 0x12458 */
+#define GRPH_INT_STATUS                                 0x6858
+#       define GRPH_PFLIP_INT_OCCURRED                  (1 << 0)
+#       define GRPH_PFLIP_INT_CLEAR                     (1 << 8)
+/* 0x685c, 0x745c, 0x1005c, 0x10c5c, 0x1185c, 0x1245c */
+#define GRPH_INT_CONTROL                                0x685c
+#       define GRPH_PFLIP_INT_MASK                      (1 << 0)
+#       define GRPH_PFLIP_INT_TYPE                      (1 << 8)
+
 #define	DAC_AUTODETECT_INT_CONTROL			0x67c8
 
 #define DC_HPD1_INT_STATUS                              0x601c
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index dfd2c516afca..f5eb157f69cd 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -4209,7 +4209,6 @@ int evergreen_irq_set(struct radeon_device *rdev)
 	u32 crtc1 = 0, crtc2 = 0, crtc3 = 0, crtc4 = 0, crtc5 = 0, crtc6 = 0;
 	u32 hpd1, hpd2, hpd3, hpd4, hpd5, hpd6;
 	u32 grbm_int_cntl = 0;
-	u32 grph1 = 0, grph2 = 0, grph3 = 0, grph4 = 0, grph5 = 0, grph6 = 0;
 	u32 afmt1 = 0, afmt2 = 0, afmt3 = 0, afmt4 = 0, afmt5 = 0, afmt6 = 0;
 	u32 dma_cntl, dma_cntl1 = 0;
 	u32 thermal_int = 0;
@@ -4392,15 +4391,21 @@ int evergreen_irq_set(struct radeon_device *rdev)
 		WREG32(INT_MASK + EVERGREEN_CRTC5_REGISTER_OFFSET, crtc6);
 	}
 
-	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET, grph1);
-	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET, grph2);
+	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET,
+	       GRPH_PFLIP_INT_MASK);
+	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET,
+	       GRPH_PFLIP_INT_MASK);
 	if (rdev->num_crtc >= 4) {
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, grph3);
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, grph4);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
 	}
 	if (rdev->num_crtc >= 6) {
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, grph5);
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, grph6);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
 	}
 
 	WREG32(DC_HPD1_INT_CONTROL, hpd1);
@@ -4789,6 +4794,15 @@ restart_ih:
 				break;
 			}
 			break;
+		case 8: /* D1 page flip */
+		case 10: /* D2 page flip */
+		case 12: /* D3 page flip */
+		case 14: /* D4 page flip */
+		case 16: /* D5 page flip */
+		case 18: /* D6 page flip */
+			DRM_DEBUG("IH: D%d flip\n", ((src_id - 8) >> 1) + 1);
+			radeon_crtc_handle_flip(rdev, (src_id - 8) >> 1);
+			break;
 		case 42: /* HPD hotplug */
 			switch (src_data) {
 			case 0:
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 8862411a57ef..33b35c9e82be 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -4143,7 +4143,6 @@ int r600_irq_set(struct radeon_device *rdev)
 	u32 hpd1, hpd2, hpd3, hpd4 = 0, hpd5 = 0, hpd6 = 0;
 	u32 grbm_int_cntl = 0;
 	u32 hdmi0, hdmi1;
-	u32 d1grph = 0, d2grph = 0;
 	u32 dma_cntl;
 	u32 thermal_int = 0;
 
@@ -4252,8 +4251,8 @@ int r600_irq_set(struct radeon_device *rdev)
 	WREG32(CP_INT_CNTL, cp_int_cntl);
 	WREG32(DMA_CNTL, dma_cntl);
 	WREG32(DxMODE_INT_MASK, mode_int);
-	WREG32(D1GRPH_INTERRUPT_CONTROL, d1grph);
-	WREG32(D2GRPH_INTERRUPT_CONTROL, d2grph);
+	WREG32(D1GRPH_INTERRUPT_CONTROL, DxGRPH_PFLIP_INT_MASK);
+	WREG32(D2GRPH_INTERRUPT_CONTROL, DxGRPH_PFLIP_INT_MASK);
 	WREG32(GRBM_INT_CNTL, grbm_int_cntl);
 	if (ASIC_IS_DCE3(rdev)) {
 		WREG32(DC_HPD1_INT_CONTROL, hpd1);
@@ -4556,6 +4555,14 @@ restart_ih:
 				break;
 			}
 			break;
+		case 9: /* D1 pflip */
+			DRM_DEBUG("IH: D1 flip\n");
+			radeon_crtc_handle_flip(rdev, 0);
+			break;
+		case 11: /* D2 pflip */
+			DRM_DEBUG("IH: D2 flip\n");
+			radeon_crtc_handle_flip(rdev, 1);
+			break;
 		case 19: /* HPD/DAC hotplug */
 			switch (src_data) {
 			case 0:
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 9f19259667df..c7899718f344 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -671,6 +671,12 @@ struct cik_irq_stat_regs {
 	u32 disp_int_cont4;
 	u32 disp_int_cont5;
 	u32 disp_int_cont6;
+	u32 d1grph_int;
+	u32 d2grph_int;
+	u32 d3grph_int;
+	u32 d4grph_int;
+	u32 d5grph_int;
+	u32 d6grph_int;
 };
 
 union radeon_irq_stat_regs {
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 4bc4c65c1445..7b9b98112545 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -281,6 +281,10 @@ void radeon_crtc_handle_flip(struct radeon_device *rdev, int crtc_id)
 	u32 update_pending;
 	int vpos, hpos;
 
+	/* can happen during initialization */
+	if (radeon_crtc == NULL)
+		return;
+
 	spin_lock_irqsave(&rdev->ddev->event_lock, flags);
 	work = radeon_crtc->unpin_work;
 	if (work == NULL ||
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index b1ccf78e4391..3479145e8f47 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -5745,7 +5745,6 @@ int si_irq_set(struct radeon_device *rdev)
 	u32 crtc1 = 0, crtc2 = 0, crtc3 = 0, crtc4 = 0, crtc5 = 0, crtc6 = 0;
 	u32 hpd1 = 0, hpd2 = 0, hpd3 = 0, hpd4 = 0, hpd5 = 0, hpd6 = 0;
 	u32 grbm_int_cntl = 0;
-	u32 grph1 = 0, grph2 = 0, grph3 = 0, grph4 = 0, grph5 = 0, grph6 = 0;
 	u32 dma_cntl, dma_cntl1;
 	u32 thermal_int = 0;
 
@@ -5881,16 +5880,22 @@ int si_irq_set(struct radeon_device *rdev)
 	}
 
 	if (rdev->num_crtc >= 2) {
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET, grph1);
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET, grph2);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
 	}
 	if (rdev->num_crtc >= 4) {
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, grph3);
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, grph4);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
 	}
 	if (rdev->num_crtc >= 6) {
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, grph5);
-		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, grph6);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET,
+		       GRPH_PFLIP_INT_MASK);
 	}
 
 	if (!ASIC_IS_NODCE(rdev)) {
@@ -6254,6 +6259,15 @@ restart_ih:
 				break;
 			}
 			break;
+		case 8: /* D1 page flip */
+		case 10: /* D2 page flip */
+		case 12: /* D3 page flip */
+		case 14: /* D4 page flip */
+		case 16: /* D5 page flip */
+		case 18: /* D6 page flip */
+			DRM_DEBUG("IH: D%d flip\n", ((src_id - 8) >> 1) + 1);
+			radeon_crtc_handle_flip(rdev, (src_id - 8) >> 1);
+			break;
 		case 42: /* HPD hotplug */
 			switch (src_data) {
 			case 0:
-- 
1.9.1

