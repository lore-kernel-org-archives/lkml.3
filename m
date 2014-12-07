Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaLGWkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:40:20 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51777 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaLGWkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:40:17 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: i915: intel_dsi_pll.c:  Remove unused function
Date: Sun,  7 Dec 2014 23:42:55 +0100
Message-Id: <1417992176-20712-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function dsi_rr_formula() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/i915/intel_dsi_pll.c |   83 +---------------------------------
 1 file changed, 1 insertion(+), 82 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dsi_pll.c b/drivers/gpu/drm/i915/intel_dsi_pll.c
index fa7a6ca..20086e8 100644
--- a/drivers/gpu/drm/i915/intel_dsi_pll.c
+++ b/drivers/gpu/drm/i915/intel_dsi_pll.c
@@ -50,88 +50,7 @@ static const u32 lfsr_converts[] = {
 	71, 35							/* 91 - 92 */
 };
 
-#ifdef DSI_CLK_FROM_RR
-
-static u32 dsi_rr_formula(const struct drm_display_mode *mode,
-			  int pixel_format, int video_mode_format,
-			  int lane_count, bool eotp)
-{
-	u32 bpp;
-	u32 hactive, vactive, hfp, hsync, hbp, vfp, vsync, vbp;
-	u32 hsync_bytes, hbp_bytes, hactive_bytes, hfp_bytes;
-	u32 bytes_per_line, bytes_per_frame;
-	u32 num_frames;
-	u32 bytes_per_x_frames, bytes_per_x_frames_x_lanes;
-	u32 dsi_bit_clock_hz;
-	u32 dsi_clk;
-
-	switch (pixel_format) {
-	default:
-	case VID_MODE_FORMAT_RGB888:
-	case VID_MODE_FORMAT_RGB666_LOOSE:
-		bpp = 24;
-		break;
-	case VID_MODE_FORMAT_RGB666:
-		bpp = 18;
-		break;
-	case VID_MODE_FORMAT_RGB565:
-		bpp = 16;
-		break;
-	}
-
-	hactive = mode->hdisplay;
-	vactive = mode->vdisplay;
-	hfp = mode->hsync_start - mode->hdisplay;
-	hsync = mode->hsync_end - mode->hsync_start;
-	hbp = mode->htotal - mode->hsync_end;
-
-	vfp = mode->vsync_start - mode->vdisplay;
-	vsync = mode->vsync_end - mode->vsync_start;
-	vbp = mode->vtotal - mode->vsync_end;
-
-	hsync_bytes = DIV_ROUND_UP(hsync * bpp, 8);
-	hbp_bytes = DIV_ROUND_UP(hbp * bpp, 8);
-	hactive_bytes = DIV_ROUND_UP(hactive * bpp, 8);
-	hfp_bytes = DIV_ROUND_UP(hfp * bpp, 8);
-
-	bytes_per_line = DSI_HSS_PACKET_SIZE + hsync_bytes +
-		DSI_HSA_PACKET_EXTRA_SIZE + DSI_HSE_PACKET_SIZE +
-		hbp_bytes + DSI_HBP_PACKET_EXTRA_SIZE +
-		hactive_bytes + DSI_HACTIVE_PACKET_EXTRA_SIZE +
-		hfp_bytes + DSI_HFP_PACKET_EXTRA_SIZE;
-
-	/*
-	 * XXX: Need to accurately calculate LP to HS transition timeout and add
-	 * it to bytes_per_line/bytes_per_frame.
-	 */
-
-	if (eotp && video_mode_format == VIDEO_MODE_BURST)
-		bytes_per_line += DSI_EOTP_PACKET_SIZE;
-
-	bytes_per_frame = vsync * bytes_per_line + vbp * bytes_per_line +
-		vactive * bytes_per_line + vfp * bytes_per_line;
-
-	if (eotp &&
-	    (video_mode_format == VIDEO_MODE_NON_BURST_WITH_SYNC_PULSE ||
-	     video_mode_format == VIDEO_MODE_NON_BURST_WITH_SYNC_EVENTS))
-		bytes_per_frame += DSI_EOTP_PACKET_SIZE;
-
-	num_frames = drm_mode_vrefresh(mode);
-	bytes_per_x_frames = num_frames * bytes_per_frame;
-
-	bytes_per_x_frames_x_lanes = bytes_per_x_frames / lane_count;
-
-	/* the dsi clock is divided by 2 in the hardware to get dsi ddr clock */
-	dsi_bit_clock_hz = bytes_per_x_frames_x_lanes * 8;
-	dsi_clk = dsi_bit_clock_hz / 1000;
-
-	if (eotp && video_mode_format == VIDEO_MODE_BURST)
-		dsi_clk *= 2;
-
-	return dsi_clk;
-}
-
-#else
+#ifndef DSI_CLK_FROM_RR
 
 /* Get DSI clock from pixel clock */
 static u32 dsi_clk_from_pclk(u32 pclk, int pixel_format, int lane_count)
-- 
1.7.10.4

