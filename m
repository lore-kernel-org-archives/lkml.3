Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaLSCBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:01:48 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63712 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaLSCBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:12 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 6/7] gpu: ipu-v3: Use videomode in struct ipu_di_signal_cfg
Date: Thu, 18 Dec 2014 18:00:25 -0800
Message-Id: <1418954426-21909-7-git-send-email-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes struct ipu_di_signal_cfg to use struct videomode
to define video timings and flags.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c |   26 +++--------
 drivers/gpu/ipu-v3/ipu-di.c      |   89 ++++++++++++++++++++------------------
 include/video/imx-ipu-v3.h       |   19 ++------
 3 files changed, 56 insertions(+), 78 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index fb16026..1ca6492 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -158,35 +158,19 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 
 	out_pixel_fmt = ipu_crtc->interface_pix_fmt;
 
-	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
-		sig_cfg.interlaced = 1;
-	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
-		sig_cfg.Hsync_pol = 1;
-	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
-		sig_cfg.Vsync_pol = 1;
-
 	sig_cfg.enable_pol = 1;
 	sig_cfg.clk_pol = 0;
-	sig_cfg.width = mode->hdisplay;
-	sig_cfg.height = mode->vdisplay;
 	sig_cfg.pixel_fmt = out_pixel_fmt;
-	sig_cfg.h_start_width = mode->htotal - mode->hsync_end;
-	sig_cfg.h_sync_width = mode->hsync_end - mode->hsync_start;
-	sig_cfg.h_end_width = mode->hsync_start - mode->hdisplay;
-
-	sig_cfg.v_start_width = mode->vtotal - mode->vsync_end;
-	sig_cfg.v_sync_width = mode->vsync_end - mode->vsync_start;
-	sig_cfg.v_end_width = mode->vsync_start - mode->vdisplay;
-	sig_cfg.pixelclock = mode->clock * 1000;
 	sig_cfg.clkflags = ipu_crtc->di_clkflags;
-
 	sig_cfg.v_to_h_sync = 0;
-
 	sig_cfg.hsync_pin = ipu_crtc->di_hsync_pin;
 	sig_cfg.vsync_pin = ipu_crtc->di_vsync_pin;
 
-	ret = ipu_dc_init_sync(ipu_crtc->dc, ipu_crtc->di, sig_cfg.interlaced,
-			out_pixel_fmt, mode->hdisplay);
+	videomode_from_drm_display_mode(mode, &sig_cfg.mode);
+
+	ret = ipu_dc_init_sync(ipu_crtc->dc, ipu_crtc->di,
+			       mode->flags & DRM_MODE_FLAG_INTERLACE,
+			       out_pixel_fmt, mode->hdisplay);
 	if (ret) {
 		dev_err(ipu_crtc->dev,
 				"initializing display controller failed with %d\n",
diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index 41df8d7..d95fbd0 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -207,10 +207,10 @@ static void ipu_di_sync_config(struct ipu_di *di, struct di_sync_config *config,
 static void ipu_di_sync_config_interlaced(struct ipu_di *di,
 		struct ipu_di_signal_cfg *sig)
 {
-	u32 h_total = sig->width + sig->h_sync_width +
-		sig->h_start_width + sig->h_end_width;
-	u32 v_total = sig->height + sig->v_sync_width +
-		sig->v_start_width + sig->v_end_width;
+	u32 h_total = sig->mode.hactive + sig->mode.hsync_len +
+		sig->mode.hback_porch + sig->mode.hfront_porch;
+	u32 v_total = sig->mode.vactive + sig->mode.vsync_len +
+		sig->mode.vback_porch + sig->mode.vfront_porch;
 	u32 reg;
 	struct di_sync_config cfg[] = {
 		{
@@ -229,13 +229,13 @@ static void ipu_di_sync_config_interlaced(struct ipu_di *di,
 		}, {
 			.run_count = v_total / 2 - 1,
 			.run_src = DI_SYNC_HSYNC,
-			.offset_count = sig->v_start_width,
+			.offset_count = sig->mode.vback_porch,
 			.offset_src = DI_SYNC_HSYNC,
 			.repeat_count = 2,
 			.cnt_clr_src = DI_SYNC_VSYNC,
 		}, {
 			.run_src = DI_SYNC_HSYNC,
-			.repeat_count = sig->height / 2,
+			.repeat_count = sig->mode.vactive / 2,
 			.cnt_clr_src = 4,
 		}, {
 			.run_count = v_total - 1,
@@ -249,9 +249,9 @@ static void ipu_di_sync_config_interlaced(struct ipu_di *di,
 			.cnt_clr_src = DI_SYNC_VSYNC,
 		}, {
 			.run_src = DI_SYNC_CLK,
-			.offset_count = sig->h_start_width,
+			.offset_count = sig->mode.hback_porch,
 			.offset_src = DI_SYNC_CLK,
-			.repeat_count = sig->width,
+			.repeat_count = sig->mode.hactive,
 			.cnt_clr_src = 5,
 		}, {
 			.run_count = v_total - 1,
@@ -277,10 +277,10 @@ static void ipu_di_sync_config_interlaced(struct ipu_di *di,
 static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 		struct ipu_di_signal_cfg *sig, int div)
 {
-	u32 h_total = sig->width + sig->h_sync_width + sig->h_start_width +
-		sig->h_end_width;
-	u32 v_total = sig->height + sig->v_sync_width + sig->v_start_width +
-		sig->v_end_width;
+	u32 h_total = sig->mode.hactive + sig->mode.hsync_len +
+		sig->mode.hback_porch + sig->mode.hfront_porch;
+	u32 v_total = sig->mode.vactive + sig->mode.vsync_len +
+		sig->mode.vback_porch + sig->mode.vfront_porch;
 	struct di_sync_config cfg[] = {
 		{
 			/* 1: INT_HSYNC */
@@ -294,27 +294,29 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 			.offset_src = DI_SYNC_CLK,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_CLK,
-			.cnt_down = sig->h_sync_width * 2,
+			.cnt_down = sig->mode.hsync_len * 2,
 		} , {
 			/* PIN3: VSYNC */
 			.run_count = v_total - 1,
 			.run_src = DI_SYNC_INT_HSYNC,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_INT_HSYNC,
-			.cnt_down = sig->v_sync_width * 2,
+			.cnt_down = sig->mode.vsync_len * 2,
 		} , {
 			/* 4: Line Active */
 			.run_src = DI_SYNC_HSYNC,
-			.offset_count = sig->v_sync_width + sig->v_start_width,
+			.offset_count = sig->mode.vsync_len +
+					sig->mode.vback_porch,
 			.offset_src = DI_SYNC_HSYNC,
-			.repeat_count = sig->height,
+			.repeat_count = sig->mode.vactive,
 			.cnt_clr_src = DI_SYNC_VSYNC,
 		} , {
 			/* 5: Pixel Active, referenced by DC */
 			.run_src = DI_SYNC_CLK,
-			.offset_count = sig->h_sync_width + sig->h_start_width,
+			.offset_count = sig->mode.hsync_len +
+					sig->mode.hback_porch,
 			.offset_src = DI_SYNC_CLK,
-			.repeat_count = sig->width,
+			.repeat_count = sig->mode.hactive,
 			.cnt_clr_src = 5, /* Line Active */
 		} , {
 			/* unused */
@@ -339,9 +341,10 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 		} , {
 			/* 3: Line Active */
 			.run_src = DI_SYNC_INT_HSYNC,
-			.offset_count = sig->v_sync_width + sig->v_start_width,
+			.offset_count = sig->mode.vsync_len +
+					sig->mode.vback_porch,
 			.offset_src = DI_SYNC_INT_HSYNC,
-			.repeat_count = sig->height,
+			.repeat_count = sig->mode.vactive,
 			.cnt_clr_src = 3 /* VSYNC */,
 		} , {
 			/* PIN4: HSYNC for VGA via TVEv2 on TQ MBa53 */
@@ -351,13 +354,14 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 			.offset_src = DI_SYNC_CLK,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_CLK,
-			.cnt_down = sig->h_sync_width * 2,
+			.cnt_down = sig->mode.hsync_len * 2,
 		} , {
 			/* 5: Pixel Active signal to DC */
 			.run_src = DI_SYNC_CLK,
-			.offset_count = sig->h_sync_width + sig->h_start_width,
+			.offset_count = sig->mode.hsync_len +
+					sig->mode.hback_porch,
 			.offset_src = DI_SYNC_CLK,
-			.repeat_count = sig->width,
+			.repeat_count = sig->mode.hactive,
 			.cnt_clr_src = 4, /* Line Active */
 		} , {
 			/* PIN6: VSYNC for VGA via TVEv2 on TQ MBa53 */
@@ -367,7 +371,7 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 			.offset_src = DI_SYNC_INT_HSYNC,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_INT_HSYNC,
-			.cnt_down = sig->v_sync_width * 2,
+			.cnt_down = sig->mode.vsync_len * 2,
 		} , {
 			/* PIN4: HSYNC for VGA via TVEv2 on i.MX53-QSB */
 			.run_count = h_total - 1,
@@ -376,7 +380,7 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 			.offset_src = DI_SYNC_CLK,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_CLK,
-			.cnt_down = sig->h_sync_width * 2,
+			.cnt_down = sig->mode.hsync_len * 2,
 		} , {
 			/* PIN6: VSYNC for VGA via TVEv2 on i.MX53-QSB */
 			.run_count = v_total - 1,
@@ -385,7 +389,7 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 			.offset_src = DI_SYNC_INT_HSYNC,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_INT_HSYNC,
-			.cnt_down = sig->v_sync_width * 2,
+			.cnt_down = sig->mode.vsync_len * 2,
 		} , {
 			/* unused */
 		},
@@ -433,10 +437,11 @@ static void ipu_di_config_clock(struct ipu_di *di,
 			unsigned long in_rate;
 			unsigned div;
 
-			clk_set_rate(clk, sig->pixelclock);
+			clk_set_rate(clk, sig->mode.pixelclock);
 
 			in_rate = clk_get_rate(clk);
-			div = (in_rate + sig->pixelclock / 2) / sig->pixelclock;
+			div = (in_rate + sig->mode.pixelclock / 2) /
+				sig->mode.pixelclock;
 			if (div == 0)
 				div = 1;
 
@@ -454,10 +459,11 @@ static void ipu_di_config_clock(struct ipu_di *di,
 		unsigned div, error;
 
 		clkrate = clk_get_rate(di->clk_ipu);
-		div = (clkrate + sig->pixelclock / 2) / sig->pixelclock;
+		div = (clkrate + sig->mode.pixelclock / 2) /
+			sig->mode.pixelclock;
 		rate = clkrate / div;
 
-		error = rate / (sig->pixelclock / 1000);
+		error = rate / (sig->mode.pixelclock / 1000);
 
 		dev_dbg(di->ipu->dev, "  IPU clock can give %lu with divider %u, error %d.%u%%\n",
 			rate, div, (signed)(error - 1000) / 10, error % 10);
@@ -473,10 +479,11 @@ static void ipu_di_config_clock(struct ipu_di *di,
 
 			clk = di->clk_di;
 
-			clk_set_rate(clk, sig->pixelclock);
+			clk_set_rate(clk, sig->mode.pixelclock);
 
 			in_rate = clk_get_rate(clk);
-			div = (in_rate + sig->pixelclock / 2) / sig->pixelclock;
+			div = (in_rate + sig->mode.pixelclock / 2) /
+				sig->mode.pixelclock;
 			if (div == 0)
 				div = 1;
 
@@ -504,7 +511,7 @@ static void ipu_di_config_clock(struct ipu_di *di,
 	ipu_di_write(di, val, DI_GENERAL);
 
 	dev_dbg(di->ipu->dev, "Want %luHz IPU %luHz DI %luHz using %s, %luHz\n",
-		sig->pixelclock,
+		sig->mode.pixelclock,
 		clk_get_rate(di->clk_ipu),
 		clk_get_rate(di->clk_di),
 		clk == di->clk_di ? "DI" : "IPU",
@@ -547,15 +554,15 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 	u32 div;
 
 	dev_dbg(di->ipu->dev, "disp %d: panel size = %d x %d\n",
-		di->id, sig->width, sig->height);
+		di->id, sig->mode.hactive, sig->mode.vactive);
 
-	if ((sig->v_sync_width == 0) || (sig->h_sync_width == 0))
+	if ((sig->mode.vsync_len == 0) || (sig->mode.hsync_len == 0))
 		return -EINVAL;
 
 	dev_dbg(di->ipu->dev, "Clocks: IPU %luHz DI %luHz Needed %luHz\n",
 		clk_get_rate(di->clk_ipu),
 		clk_get_rate(di->clk_di),
-		sig->pixelclock);
+		sig->mode.pixelclock);
 
 	mutex_lock(&di_mutex);
 
@@ -574,7 +581,7 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 	di_gen = ipu_di_read(di, DI_GENERAL) & DI_GEN_DI_CLK_EXT;
 	di_gen |= DI_GEN_DI_VSYNC_EXT;
 
-	if (sig->interlaced) {
+	if (sig->mode.flags & DISPLAY_FLAGS_INTERLACED) {
 		ipu_di_sync_config_interlaced(di, sig);
 
 		/* set y_sel = 1 */
@@ -584,9 +591,9 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 
 		vsync_cnt = 7;
 
-		if (sig->Hsync_pol)
+		if (sig->mode.flags & DISPLAY_FLAGS_HSYNC_HIGH)
 			di_gen |= DI_GEN_POLARITY_3;
-		if (sig->Vsync_pol)
+		if (sig->mode.flags & DISPLAY_FLAGS_VSYNC_HIGH)
 			di_gen |= DI_GEN_POLARITY_2;
 	} else {
 		ipu_di_sync_config_noninterlaced(di, sig, div);
@@ -600,7 +607,7 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 			if (!(sig->hsync_pin == 2 && sig->vsync_pin == 3))
 				vsync_cnt = 6;
 
-		if (sig->Hsync_pol) {
+		if (sig->mode.flags & DISPLAY_FLAGS_HSYNC_HIGH) {
 			if (sig->hsync_pin == 2)
 				di_gen |= DI_GEN_POLARITY_2;
 			else if (sig->hsync_pin == 4)
@@ -608,7 +615,7 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 			else if (sig->hsync_pin == 7)
 				di_gen |= DI_GEN_POLARITY_7;
 		}
-		if (sig->Vsync_pol) {
+		if (sig->mode.flags & DISPLAY_FLAGS_VSYNC_HIGH) {
 			if (sig->vsync_pin == 3)
 				di_gen |= DI_GEN_POLARITY_3;
 			else if (sig->vsync_pin == 6)
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index d333d54..73390c1 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -33,28 +33,15 @@ enum ipuv3_type {
  * Bitfield of Display Interface signal polarities.
  */
 struct ipu_di_signal_cfg {
-	unsigned datamask_en:1;
-	unsigned interlaced:1;
-	unsigned odd_field_first:1;
-	unsigned clksel_en:1;
-	unsigned clkidle_en:1;
 	unsigned data_pol:1;	/* true = inverted */
 	unsigned clk_pol:1;	/* true = rising edge */
 	unsigned enable_pol:1;
-	unsigned Hsync_pol:1;	/* true = active high */
-	unsigned Vsync_pol:1;
 
-	u16 width;
-	u16 height;
+	struct videomode mode;
+
 	u32 pixel_fmt;
-	u16 h_start_width;
-	u16 h_sync_width;
-	u16 h_end_width;
-	u16 v_start_width;
-	u16 v_sync_width;
-	u16 v_end_width;
 	u32 v_to_h_sync;
-	unsigned long pixelclock;
+
 #define IPU_DI_CLKMODE_SYNC	(1 << 0)
 #define IPU_DI_CLKMODE_EXT	(1 << 1)
 	unsigned long clkflags;
-- 
1.7.9.5

