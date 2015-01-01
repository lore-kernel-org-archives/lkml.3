Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbbAAP0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:26:13 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63541 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbAAP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:26:10 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Archit Taneja <archit@ti.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] video: fbdev: omap2: dss: dispc.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 16:29:09 +0100
Message-Id: <1420126149-27019-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
dispc_wb_go() dispc_wb_go_busy() dispc_wb_get_framedone_irq()
dispc_mgr_get_clock_div() dispc_wb_is_enabled() dispc_wb_enable()
dispc_wb_setup() dispc_enable_fifomerge() dispc_wb_set_channel_in()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/omap2/dss/dispc.c |  124 ---------------------------------
 drivers/video/fbdev/omap2/dss/dss.h   |   12 ----
 2 files changed, 136 deletions(-)

diff --git a/drivers/video/fbdev/omap2/dss/dispc.c b/drivers/video/fbdev/omap2/dss/dispc.c
index 0e9a74b..9fb2743 100644
--- a/drivers/video/fbdev/omap2/dss/dispc.c
+++ b/drivers/video/fbdev/omap2/dss/dispc.c
@@ -536,11 +536,6 @@ u32 dispc_mgr_get_sync_lost_irq(enum omap_channel channel)
 }
 EXPORT_SYMBOL(dispc_mgr_get_sync_lost_irq);
 
-u32 dispc_wb_get_framedone_irq(void)
-{
-	return DISPC_IRQ_FRAMEDONEWB;
-}
-
 bool dispc_mgr_go_busy(enum omap_channel channel)
 {
 	return mgr_fld_read(channel, DISPC_MGR_FLD_GO) == 1;
@@ -558,30 +553,6 @@ void dispc_mgr_go(enum omap_channel channel)
 }
 EXPORT_SYMBOL(dispc_mgr_go);
 
-bool dispc_wb_go_busy(void)
-{
-	return REG_GET(DISPC_CONTROL2, 6, 6) == 1;
-}
-
-void dispc_wb_go(void)
-{
-	enum omap_plane plane = OMAP_DSS_WB;
-	bool enable, go;
-
-	enable = REG_GET(DISPC_OVL_ATTRIBUTES(plane), 0, 0) == 1;
-
-	if (!enable)
-		return;
-
-	go = REG_GET(DISPC_CONTROL2, 6, 6) == 1;
-	if (go) {
-		DSSERR("GO bit not down for WB\n");
-		return;
-	}
-
-	REG_FLD_MOD(DISPC_CONTROL2, 1, 6, 6);
-}
-
 static void dispc_ovl_write_firh_reg(enum omap_plane plane, int reg, u32 value)
 {
 	dispc_write_reg(DISPC_OVL_FIR_COEF_H(plane, reg), value);
@@ -1003,13 +974,6 @@ static enum omap_channel dispc_ovl_get_channel_out(enum omap_plane plane)
 	return channel;
 }
 
-void dispc_wb_set_channel_in(enum dss_writeback_channel channel)
-{
-	enum omap_plane plane = OMAP_DSS_WB;
-
-	REG_FLD_MOD(DISPC_OVL_ATTRIBUTES(plane), channel, 18, 16);
-}
-
 static void dispc_ovl_set_burst_size(enum omap_plane plane,
 		enum omap_burst_size burst_size)
 {
@@ -1213,17 +1177,6 @@ void dispc_ovl_set_fifo_threshold(enum omap_plane plane, u32 low, u32 high)
 }
 EXPORT_SYMBOL(dispc_ovl_set_fifo_threshold);
 
-void dispc_enable_fifomerge(bool enable)
-{
-	if (!dss_has_feature(FEAT_FIFO_MERGE)) {
-		WARN_ON(enable);
-		return;
-	}
-
-	DSSDBG("FIFO merge %s\n", enable ? "enabled" : "disabled");
-	REG_FLD_MOD(DISPC_CONFIG, enable ? 1 : 0, 14, 14);
-}
-
 void dispc_ovl_compute_fifo_thresholds(enum omap_plane plane,
 		u32 *fifo_low, u32 *fifo_high, bool use_fifomerge,
 		bool manual_update)
@@ -2593,57 +2546,6 @@ int dispc_ovl_setup(enum omap_plane plane, const struct omap_overlay_info *oi,
 }
 EXPORT_SYMBOL(dispc_ovl_setup);
 
-int dispc_wb_setup(const struct omap_dss_writeback_info *wi,
-		bool mem_to_mem, const struct omap_video_timings *mgr_timings)
-{
-	int r;
-	u32 l;
-	enum omap_plane plane = OMAP_DSS_WB;
-	const int pos_x = 0, pos_y = 0;
-	const u8 zorder = 0, global_alpha = 0;
-	const bool replication = false;
-	bool truncation;
-	int in_width = mgr_timings->x_res;
-	int in_height = mgr_timings->y_res;
-	enum omap_overlay_caps caps =
-		OMAP_DSS_OVL_CAP_SCALE | OMAP_DSS_OVL_CAP_PRE_MULT_ALPHA;
-
-	DSSDBG("dispc_wb_setup, pa %x, pa_uv %x, %d,%d -> %dx%d, cmode %x, "
-		"rot %d, mir %d\n", wi->paddr, wi->p_uv_addr, in_width,
-		in_height, wi->width, wi->height, wi->color_mode, wi->rotation,
-		wi->mirror);
-
-	r = dispc_ovl_setup_common(plane, caps, wi->paddr, wi->p_uv_addr,
-		wi->buf_width, pos_x, pos_y, in_width, in_height, wi->width,
-		wi->height, wi->color_mode, wi->rotation, wi->mirror, zorder,
-		wi->pre_mult_alpha, global_alpha, wi->rotation_type,
-		replication, mgr_timings, mem_to_mem);
-
-	switch (wi->color_mode) {
-	case OMAP_DSS_COLOR_RGB16:
-	case OMAP_DSS_COLOR_RGB24P:
-	case OMAP_DSS_COLOR_ARGB16:
-	case OMAP_DSS_COLOR_RGBA16:
-	case OMAP_DSS_COLOR_RGB12U:
-	case OMAP_DSS_COLOR_ARGB16_1555:
-	case OMAP_DSS_COLOR_XRGB16_1555:
-	case OMAP_DSS_COLOR_RGBX16:
-		truncation = true;
-		break;
-	default:
-		truncation = false;
-		break;
-	}
-
-	/* setup extra DISPC_WB_ATTRIBUTES */
-	l = dispc_read_reg(DISPC_OVL_ATTRIBUTES(plane));
-	l = FLD_MOD(l, truncation, 10, 10);	/* TRUNCATIONENABLE */
-	l = FLD_MOD(l, mem_to_mem, 19, 19);	/* WRITEBACKMODE */
-	dispc_write_reg(DISPC_OVL_ATTRIBUTES(plane), l);
-
-	return r;
-}
-
 int dispc_ovl_enable(enum omap_plane plane, bool enable)
 {
 	DSSDBG("dispc_enable_plane %d, %d\n", plane, enable);
@@ -2674,16 +2576,6 @@ bool dispc_mgr_is_enabled(enum omap_channel channel)
 }
 EXPORT_SYMBOL(dispc_mgr_is_enabled);
 
-void dispc_wb_enable(bool enable)
-{
-	dispc_ovl_enable(OMAP_DSS_WB, enable);
-}
-
-bool dispc_wb_is_enabled(void)
-{
-	return dispc_ovl_enabled(OMAP_DSS_WB);
-}
-
 static void dispc_lcd_enable_signal_polarity(bool act_high)
 {
 	if (!dss_has_feature(FEAT_LCDENABLEPOL))
@@ -3446,22 +3338,6 @@ void dispc_mgr_set_clock_div(enum omap_channel channel,
 	dispc_mgr_set_lcd_divisor(channel, cinfo->lck_div, cinfo->pck_div);
 }
 
-int dispc_mgr_get_clock_div(enum omap_channel channel,
-		struct dispc_clock_info *cinfo)
-{
-	unsigned long fck;
-
-	fck = dispc_fclk_rate();
-
-	cinfo->lck_div = REG_GET(DISPC_DIVISORo(channel), 23, 16);
-	cinfo->pck_div = REG_GET(DISPC_DIVISORo(channel), 7, 0);
-
-	cinfo->lck = fck / cinfo->lck_div;
-	cinfo->pck = cinfo->lck / cinfo->pck_div;
-
-	return 0;
-}
-
 u32 dispc_read_irqstatus(void)
 {
 	return dispc_read_reg(DISPC_IRQSTATUS);
diff --git a/drivers/video/fbdev/omap2/dss/dss.h b/drivers/video/fbdev/omap2/dss/dss.h
index 8ff22c1..229c4c5 100644
--- a/drivers/video/fbdev/omap2/dss/dss.h
+++ b/drivers/video/fbdev/omap2/dss/dss.h
@@ -371,7 +371,6 @@ void dispc_disable_sidle(void);
 
 void dispc_lcd_enable_signal(bool enable);
 void dispc_pck_free_enable(bool enable);
-void dispc_enable_fifomerge(bool enable);
 void dispc_enable_gamma_table(bool enable);
 void dispc_set_loadmode(enum omap_dss_load_mode mode);
 
@@ -398,19 +397,8 @@ unsigned long dispc_mgr_pclk_rate(enum omap_channel channel);
 unsigned long dispc_core_clk_rate(void);
 void dispc_mgr_set_clock_div(enum omap_channel channel,
 		const struct dispc_clock_info *cinfo);
-int dispc_mgr_get_clock_div(enum omap_channel channel,
-		struct dispc_clock_info *cinfo);
 void dispc_set_tv_pclk(unsigned long pclk);
 
-u32 dispc_wb_get_framedone_irq(void);
-bool dispc_wb_go_busy(void);
-void dispc_wb_go(void);
-void dispc_wb_enable(bool enable);
-bool dispc_wb_is_enabled(void);
-void dispc_wb_set_channel_in(enum dss_writeback_channel channel);
-int dispc_wb_setup(const struct omap_dss_writeback_info *wi,
-		bool mem_to_mem, const struct omap_video_timings *timings);
-
 /* VENC */
 int venc_init_platform_driver(void) __init;
 void venc_uninit_platform_driver(void) __exit;
-- 
1.7.10.4

