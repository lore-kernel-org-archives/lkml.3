Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3DXMBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:01:12 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46911 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab3DXMBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:01:08 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/6] media: davinci: vpbe: enable vpbe for fbdev addition
Date: Wed, 24 Apr 2013 17:30:04 +0530
Message-Id: <1366804808-22720-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

enable the venc, osd and vpbe display driver for addition
of fbdev driver. Mainly includes fbdev ops structure inclusion,
palette and osd layer related functionality for OSD block.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c |    6 +
 drivers/media/platform/davinci/vpbe_osd.c     |  796 ++++++++++++++++++++++++-
 drivers/media/platform/davinci/vpbe_venc.c    |   43 ++
 include/media/davinci/vpbe_osd.h              |   62 ++
 include/media/davinci/vpbe_venc.h             |   21 +
 5 files changed, 920 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 1c4ba89..0341dcc 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -121,10 +121,12 @@ static void vpbe_isr_odd_field(struct vpbe_display *disp_obj,
 static irqreturn_t venc_isr(int irq, void *arg)
 {
 	struct vpbe_display *disp_dev = (struct vpbe_display *)arg;
+	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
 	struct vpbe_layer *layer;
 	static unsigned last_event;
 	unsigned event = 0;
 	int fid;
+	int ret;
 	int i;
 
 	if ((NULL == arg) || (NULL == disp_dev->dev[0]))
@@ -195,6 +197,10 @@ static irqreturn_t venc_isr(int irq, void *arg)
 				vpbe_isr_odd_field(disp_dev, layer);
 		}
 	}
+	ret = v4l2_subdev_call(vpbe_dev->venc, core, ioctl, VENC_INTERRUPT,
+				&event);
+	if (ret < 0)
+		v4l2_err(&vpbe_dev->v4l2_dev, "Error in getting Field ID 0\n");
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index 6ed82e8..455b0ca 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -175,6 +175,13 @@ static int _osd_dm6446_vid0_pingpong(struct osd_state *sd,
 	return 0;
 }
 
+static int osd_get_field_inversion(struct osd_state *sd)
+{
+	struct osd_state *osd = sd;
+
+	return osd->field_inversion;
+}
+
 static void _osd_set_field_inversion(struct osd_state *sd, int enable)
 {
 	unsigned fsinv = 0;
@@ -185,6 +192,365 @@ static void _osd_set_field_inversion(struct osd_state *sd, int enable)
 	osd_modify(sd, OSD_MODE_FSINV, fsinv, OSD_MODE);
 }
 
+static void osd_set_field_inversion(struct osd_state *sd, int enable)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->field_inversion = (enable != 0);
+	_osd_set_field_inversion(sd, enable);
+
+	osd->pingpong = _osd_dm6446_vid0_pingpong(sd, osd->field_inversion,
+					osd->win[WIN_VID0].fb_base_phys,
+						  &osd->win[WIN_VID0].lconfig);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void osd_get_background(struct osd_state *sd, enum osd_clut *clut,
+				 unsigned char *clut_index)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	*clut = osd->backg_clut;
+	*clut_index = osd->backg_clut_index;
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void _osd_set_background(struct osd_state *sd, enum osd_clut clut,
+				unsigned char clut_index)
+{
+	u32 mode = 0;
+
+	if (clut == RAM_CLUT)
+		mode |= OSD_MODE_BCLUT;
+	mode |= clut_index;
+	osd_modify(sd, OSD_MODE_BCLUT | OSD_MODE_CABG, mode, OSD_MODE);
+}
+
+static void osd_set_background(struct osd_state *sd, enum osd_clut clut,
+			       unsigned char clut_index)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->backg_clut = clut;
+	osd->backg_clut_index = clut_index;
+	_osd_set_background(sd, clut, clut_index);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static int osd_get_interpolation_filter(struct osd_state *sd)
+{
+	struct osd_state *osd = sd;
+
+	return osd->interpolation_filter;
+}
+
+static void _osd_set_interpolation_filter(struct osd_state *sd, int filter)
+{
+	struct osd_state *osd = sd;
+
+	if (osd->vpbe_type == VPBE_VERSION_3 ||
+	    osd->vpbe_type == VPBE_VERSION_2)
+		osd_clear(sd, OSD_EXTMODE_EXPMDSEL, OSD_EXTMODE);
+
+	osd_modify(sd, OSD_MODE_EF, filter ? OSD_MODE_EF : 0, OSD_MODE);
+}
+
+static void osd_set_interpolation_filter(struct osd_state *sd, int filter)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->interpolation_filter = (filter != 0);
+	_osd_set_interpolation_filter(sd, filter);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void osd_get_cursor_config(struct osd_state *sd,
+				  struct osd_cursor_config *cursor)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	*cursor = osd->cursor.config;
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void _osd_set_cursor_config(struct osd_state *sd,
+				   const struct osd_cursor_config *cursor)
+{
+	struct osd_state *osd = sd;
+	unsigned rectcur = 0;
+
+	osd_write(sd, cursor->xsize, OSD_CURXL);
+	osd_write(sd, cursor->xpos, OSD_CURXP);
+
+	if (cursor->interlaced) {
+		osd_write(sd, cursor->ypos >> 1, OSD_CURYP);
+		if (osd->vpbe_type == VPBE_VERSION_1)
+			/* Must add 1 to ysize due to device erratum. */
+			osd_write(sd, (cursor->ysize >> 1) + 1, OSD_CURYL);
+		else
+			osd_write(sd, cursor->ysize >> 1, OSD_CURYL);
+	} else {
+		osd_write(sd, cursor->ypos, OSD_CURYP);
+		if (osd->vpbe_type == VPBE_VERSION_1)
+			/* Must add 1 to ysize due to device erratum. */
+			osd_write(sd, cursor->ysize + 1, OSD_CURYL);
+		else
+			osd_write(sd, cursor->ysize, OSD_CURYL);
+	}
+
+	if (cursor->clut == RAM_CLUT)
+		rectcur |= OSD_RECTCUR_CLUTSR;
+
+	rectcur |= (cursor->clut_index << OSD_RECTCUR_RCAD_SHIFT);
+	rectcur |= (cursor->h_width << OSD_RECTCUR_RCHW_SHIFT);
+	rectcur |= (cursor->v_width << OSD_RECTCUR_RCVW_SHIFT);
+	osd_modify(sd, OSD_RECTCUR_RCAD | OSD_RECTCUR_CLUTSR |
+		   OSD_RECTCUR_RCHW | OSD_RECTCUR_RCVW, rectcur, OSD_RECTCUR);
+}
+
+static void osd_set_cursor_config(struct osd_state *sd,
+				  struct osd_cursor_config *cursor)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	cursor->xpos = min_t(unsigned, cursor->xpos, (unsigned)OSD_CURXP_RCSX);
+	cursor->ypos = min_t(unsigned, cursor->ypos, (unsigned)OSD_CURYP_RCSY);
+	cursor->xsize =
+		min_t(unsigned, cursor->xsize, (unsigned)OSD_CURXL_RCSW);
+	cursor->ysize =
+		min_t(unsigned, cursor->ysize, (unsigned)OSD_CURYL_RCSH);
+	cursor->interlaced = (cursor->interlaced != 0);
+	if (cursor->interlaced) {
+		cursor->ysize &= ~1;
+		cursor->ypos &= ~1;
+	}
+	cursor->h_width &= (OSD_RECTCUR_RCHW >> OSD_RECTCUR_RCHW_SHIFT);
+	cursor->v_width &= (OSD_RECTCUR_RCVW >> OSD_RECTCUR_RCVW_SHIFT);
+	cursor->clut = (cursor->clut == RAM_CLUT) ? RAM_CLUT : ROM_CLUT;
+
+	osd->cursor.config = *cursor;
+	_osd_set_cursor_config(sd, cursor);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static int osd_cursor_is_enabled(struct osd_state *sd)
+{
+	struct osd_state *osd = sd;
+
+	return osd->cursor.is_enabled;
+}
+
+static void _osd_cursor_disable(struct osd_state *sd)
+{
+	osd_clear(sd, OSD_RECTCUR_RCACT, OSD_RECTCUR);
+}
+
+static void osd_cursor_disable(struct osd_state *sd)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->cursor.is_enabled = 0;
+	_osd_cursor_disable(sd);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void _osd_cursor_enable(struct osd_state *sd)
+{
+	osd_set(sd, OSD_RECTCUR_RCACT, OSD_RECTCUR);
+}
+
+static void osd_cursor_enable(struct osd_state *sd)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->cursor.is_enabled = 1;
+	_osd_cursor_enable(sd);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void osd_get_vid_expansion(struct osd_state *sd,
+				  enum osd_h_exp_ratio *h_exp,
+				  enum osd_v_exp_ratio *v_exp)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	*h_exp = osd->vid_h_exp;
+	*v_exp = osd->vid_v_exp;
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void _osd_set_vid_expansion(struct osd_state *sd,
+				   enum osd_h_exp_ratio h_exp,
+				   enum osd_v_exp_ratio v_exp)
+{
+	struct osd_state *osd = sd;
+	u32 mode = 0;
+	u32 extmode = 0;
+
+	switch (h_exp) {
+	case H_EXP_OFF:
+		break;
+	case H_EXP_9_OVER_8:
+		mode |= OSD_MODE_VHRSZ;
+		break;
+	case H_EXP_3_OVER_2:
+		extmode |= OSD_EXTMODE_VIDHRSZ15;
+		break;
+	}
+
+	switch (v_exp) {
+	case V_EXP_OFF:
+		break;
+	case V_EXP_6_OVER_5:
+		mode |= OSD_MODE_VVRSZ;
+		break;
+	}
+
+	if (osd->vpbe_type == VPBE_VERSION_3 ||
+	    osd->vpbe_type == VPBE_VERSION_2)
+		osd_modify(sd, OSD_EXTMODE_VIDHRSZ15, extmode, OSD_EXTMODE);
+
+	osd_modify(sd, OSD_MODE_VHRSZ | OSD_MODE_VVRSZ, mode, OSD_MODE);
+}
+
+static int osd_set_vid_expansion(struct osd_state *sd,
+				 enum osd_h_exp_ratio h_exp,
+				 enum osd_v_exp_ratio v_exp)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	if (h_exp == H_EXP_3_OVER_2 && (osd->vpbe_type == VPBE_VERSION_1))
+		return -EINVAL;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->vid_h_exp = h_exp;
+	osd->vid_v_exp = v_exp;
+	_osd_set_vid_expansion(sd, h_exp, v_exp);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+	return 0;
+}
+
+static void osd_get_osd_expansion(struct osd_state *sd,
+				  enum osd_h_exp_ratio *h_exp,
+				  enum osd_v_exp_ratio *v_exp)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	*h_exp = osd->osd_h_exp;
+	*v_exp = osd->osd_v_exp;
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void _osd_set_osd_expansion(struct osd_state *sd,
+				   enum osd_h_exp_ratio h_exp,
+				   enum osd_v_exp_ratio v_exp)
+{
+	struct osd_state *osd = sd;
+	u32 mode = 0;
+	u32 extmode = 0;
+
+	switch (h_exp) {
+	case H_EXP_OFF:
+		break;
+	case H_EXP_9_OVER_8:
+		mode |= OSD_MODE_OHRSZ;
+		break;
+	case H_EXP_3_OVER_2:
+		extmode |= OSD_EXTMODE_OSDHRSZ15;
+		break;
+	}
+
+	switch (v_exp) {
+	case V_EXP_OFF:
+		break;
+	case V_EXP_6_OVER_5:
+		mode |= OSD_MODE_OVRSZ;
+		break;
+	}
+
+	if (osd->vpbe_type == VPBE_VERSION_3 ||
+	    osd->vpbe_type == VPBE_VERSION_2)
+		osd_modify(sd, OSD_EXTMODE_OSDHRSZ15, extmode, OSD_EXTMODE);
+
+	osd_modify(sd, OSD_MODE_OHRSZ | OSD_MODE_OVRSZ, mode, OSD_MODE);
+}
+
+static int osd_set_osd_expansion(struct osd_state *sd,
+				 enum osd_h_exp_ratio h_exp,
+				 enum osd_v_exp_ratio v_exp)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	if (h_exp == H_EXP_3_OVER_2 && (osd->vpbe_type == VPBE_VERSION_1))
+		return -EINVAL;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->osd_h_exp = h_exp;
+	osd->osd_v_exp = v_exp;
+	_osd_set_osd_expansion(sd, h_exp, v_exp);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+	return 0;
+}
+
+static void osd_get_blink_attribute(struct osd_state *sd, int *enable,
+				    enum osd_blink_interval *blink)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	*enable = osd->is_blinking;
+	*blink = osd->blink;
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
 static void _osd_set_blink_attribute(struct osd_state *sd, int enable,
 				     enum osd_blink_interval blink)
 {
@@ -199,6 +565,29 @@ static void _osd_set_blink_attribute(struct osd_state *sd, int enable,
 		  OSD_OSDATRMD);
 }
 
+static void osd_set_blink_attribute(struct osd_state *sd, int enable,
+				    enum osd_blink_interval blink)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->is_blinking = (enable != 0);
+	osd->blink = blink;
+	if (osd->win[WIN_OSD1].lconfig.pixfmt == PIXFMT_OSD_ATTR)
+		_osd_set_blink_attribute(sd, enable, blink);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static enum osd_rom_clut osd_get_rom_clut(struct osd_state *sd)
+{
+	struct osd_state *osd = sd;
+
+	return osd->rom_clut;
+}
+
 static void _osd_set_rom_clut(struct osd_state *sd,
 			      enum osd_rom_clut rom_clut)
 {
@@ -208,6 +597,150 @@ static void _osd_set_rom_clut(struct osd_state *sd,
 		osd_set(sd, OSD_MISCCTL_RSEL, OSD_MISCCTL);
 }
 
+static void osd_set_rom_clut(struct osd_state *sd,
+			     enum osd_rom_clut rom_clut)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->rom_clut = rom_clut;
+	_osd_set_rom_clut(sd, rom_clut);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void _osd_set_clut_ycbcr(struct osd_state *sd,
+				unsigned char clut_index,
+				unsigned char y, unsigned char cb,
+				unsigned char cr)
+{
+	/* wait until any previous writes to the CLUT RAM have completed */
+	while (osd_read(sd, OSD_MISCCTL) & OSD_MISCCTL_CPBSY)
+		cpu_relax();
+
+	osd_write(sd, (y << OSD_CLUTRAMYCB_Y_SHIFT) | cb, OSD_CLUTRAMYCB);
+	osd_write(sd, (cr << OSD_CLUTRAMCR_CR_SHIFT) | clut_index,
+		  OSD_CLUTRAMCR);
+}
+
+static void osd_set_clut_ycbcr(struct osd_state *sd,
+			       unsigned char clut_index, unsigned char y,
+			       unsigned char cb, unsigned char cr)
+{
+	struct osd_state *osd = sd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->clut_ram[clut_index][0] = y;
+	osd->clut_ram[clut_index][1] = cb;
+	osd->clut_ram[clut_index][2] = cr;
+	_osd_set_clut_ycbcr(sd, clut_index, y, cb, cr);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void _osd_rgb_to_ycbcr(const unsigned char rgb[3],
+			      unsigned char ycbcr[3])
+{
+	int y, cb, cr;
+	int r = rgb[0];
+	int g = rgb[1];
+	int b = rgb[2];
+	/*
+	 * This conversion matrix corresponds to the conversion matrix used
+	 * by the OSD to convert RGB values to YCbCr values.  All coefficients
+	 * have been scaled by a factor of 2^22.
+	 */
+	static const int rgb_to_ycbcr[3][3] = {
+		{1250330, 2453618, 490352},
+		{-726093, -1424868, 2150957},
+		{2099836, -1750086, -349759}
+	};
+
+	y = rgb_to_ycbcr[0][0] * r + rgb_to_ycbcr[0][1] * g +
+			rgb_to_ycbcr[0][2] * b;
+	cb = rgb_to_ycbcr[1][0] * r + rgb_to_ycbcr[1][1] * g +
+			rgb_to_ycbcr[1][2] * b;
+	cr = rgb_to_ycbcr[2][0] * r + rgb_to_ycbcr[2][1] * g +
+			rgb_to_ycbcr[2][2] * b;
+
+	/* round and scale */
+	y = ((y + (1 << 21)) >> 22);
+	cb = ((cb + (1 << 21)) >> 22) + 128;
+	cr = ((cr + (1 << 21)) >> 22) + 128;
+
+	/* clip */
+	y = (y < 0) ? 0 : y;
+	y = (y > 255) ? 255 : y;
+	cb = (cb < 0) ? 0 : cb;
+	cb = (cb > 255) ? 255 : cb;
+	cr = (cr < 0) ? 0 : cr;
+	cr = (cr > 255) ? 255 : cr;
+
+	ycbcr[0] = y;
+	ycbcr[1] = cb;
+	ycbcr[2] = cr;
+}
+
+static void osd_set_clut_rgb(struct osd_state *sd, unsigned char clut_index,
+			     unsigned char r, unsigned char g, unsigned char b)
+{
+	struct osd_state *osd = sd;
+	unsigned char rgb[3], ycbcr[3];
+	unsigned long flags;
+
+	rgb[0] = r;
+	rgb[1] = g;
+	rgb[2] = b;
+	_osd_rgb_to_ycbcr(rgb, ycbcr);
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osd->clut_ram[clut_index][0] = ycbcr[0];
+	osd->clut_ram[clut_index][1] = ycbcr[1];
+	osd->clut_ram[clut_index][2] = ycbcr[2];
+	_osd_set_clut_ycbcr(sd, clut_index, ycbcr[0], ycbcr[1], ycbcr[2]);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static unsigned char osd_get_palette_map(struct osd_state *sd,
+					 enum osd_win_layer osdwin,
+					 unsigned char pixel_value)
+{
+	struct osd_state *osd = sd;
+	enum osd_layer layer =
+	    (osdwin == OSDWIN_OSD0) ? WIN_OSD0 : WIN_OSD1;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+	unsigned char clut_index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	switch (win->lconfig.pixfmt) {
+	case PIXFMT_1BPP:
+		clut_index = osdwin_state->palette_map[pixel_value & 0x1];
+		break;
+	case PIXFMT_2BPP:
+		clut_index = osdwin_state->palette_map[pixel_value & 0x3];
+		break;
+	case PIXFMT_4BPP:
+		clut_index = osdwin_state->palette_map[pixel_value & 0xf];
+		break;
+	default:
+		clut_index = 0;
+		break;
+	}
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+
+	return clut_index;
+}
+
 static void _osd_set_palette_map(struct osd_state *sd,
 				 enum osd_win_layer osdwin,
 				 unsigned char pixel_value,
@@ -257,14 +790,55 @@ static void _osd_set_palette_map(struct osd_state *sd,
 	osd_modify(sd, bmp_mask, clut_index << bmp_shift, bmp_offset);
 }
 
+static void osd_set_palette_map(struct osd_state *sd,
+				enum osd_win_layer osdwin,
+				unsigned char pixel_value,
+				unsigned char clut_index)
+{
+	struct osd_state *osd = sd;
+	enum osd_layer layer =
+	    (osdwin == OSDWIN_OSD0) ? WIN_OSD0 : WIN_OSD1;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	switch (win->lconfig.pixfmt) {
+	case PIXFMT_1BPP:
+		osdwin_state->palette_map[pixel_value & 0x1] = clut_index;
+		break;
+	case PIXFMT_2BPP:
+		osdwin_state->palette_map[pixel_value & 0x3] = clut_index;
+		break;
+	case PIXFMT_4BPP:
+		osdwin_state->palette_map[pixel_value & 0xf] = clut_index;
+		break;
+	default:
+		spin_unlock_irqrestore(&osd->lock, flags);
+		return;
+	}
+
+	_osd_set_palette_map(sd, osdwin, pixel_value, clut_index,
+			     win->lconfig.pixfmt);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static int osd_get_rec601_attenuation(struct osd_state *sd,
+				      enum osd_win_layer osdwin)
+{
+	struct osd_state *osd = sd;
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+
+	return osdwin_state->rec601_attenuation;
+}
+
 static void _osd_set_rec601_attenuation(struct osd_state *sd,
 					enum osd_win_layer osdwin, int enable)
 {
 	switch (osdwin) {
 	case OSDWIN_OSD0:
-		osd_modify(sd, OSD_OSDWIN0MD_ATN0E,
-			  enable ? OSD_OSDWIN0MD_ATN0E : 0,
-			  OSD_OSDWIN0MD);
 		if (sd->vpbe_type == VPBE_VERSION_1)
 			osd_modify(sd, OSD_OSDWIN0MD_ATN0E,
 				  enable ? OSD_OSDWIN0MD_ATN0E : 0,
@@ -276,9 +850,6 @@ static void _osd_set_rec601_attenuation(struct osd_state *sd,
 				  OSD_EXTMODE);
 		break;
 	case OSDWIN_OSD1:
-		osd_modify(sd, OSD_OSDWIN1MD_ATN1E,
-			  enable ? OSD_OSDWIN1MD_ATN1E : 0,
-			  OSD_OSDWIN1MD);
 		if (sd->vpbe_type == VPBE_VERSION_1)
 			osd_modify(sd, OSD_OSDWIN1MD_ATN1E,
 				  enable ? OSD_OSDWIN1MD_ATN1E : 0,
@@ -292,6 +863,35 @@ static void _osd_set_rec601_attenuation(struct osd_state *sd,
 	}
 }
 
+static void osd_set_rec601_attenuation(struct osd_state *sd,
+				       enum osd_win_layer osdwin,
+				       int enable)
+{
+	struct osd_state *osd = sd;
+	enum osd_layer layer =
+	    (osdwin == OSDWIN_OSD0) ? WIN_OSD0 : WIN_OSD1;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osdwin_state->rec601_attenuation = (enable != 0);
+	if (win->lconfig.pixfmt != PIXFMT_OSD_ATTR)
+		_osd_set_rec601_attenuation(sd, osdwin, enable);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static enum osd_blending_factor
+osd_get_blending_factor(struct osd_state *sd, enum osd_win_layer osdwin)
+{
+	struct osd_state *osd = sd;
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+
+	return osdwin_state->blend;
+}
+
 static void _osd_set_blending_factor(struct osd_state *sd,
 				     enum osd_win_layer osdwin,
 				     enum osd_blending_factor blend)
@@ -308,6 +908,25 @@ static void _osd_set_blending_factor(struct osd_state *sd,
 	}
 }
 
+static void osd_set_blending_factor(struct osd_state *sd,
+				    enum osd_win_layer osdwin,
+				    enum osd_blending_factor blend)
+{
+	struct osd_state *osd = sd;
+	enum osd_layer layer =
+	    (osdwin == OSDWIN_OSD0) ? WIN_OSD0 : WIN_OSD1;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osdwin_state->blend = blend;
+	if (win->lconfig.pixfmt != PIXFMT_OSD_ATTR)
+		_osd_set_blending_factor(sd, osdwin, blend);
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
 static void _osd_enable_rgb888_pixblend(struct osd_state *sd,
 					enum osd_win_layer osdwin)
 {
@@ -388,6 +1007,28 @@ static void _osd_enable_color_key(struct osd_state *sd,
 	}
 }
 
+static void osd_enable_color_key(struct osd_state *sd,
+				 enum osd_win_layer osdwin,
+				 unsigned colorkey)
+{
+	struct osd_state *osd = sd;
+	enum osd_layer layer =
+	    (osdwin == OSDWIN_OSD0) ? WIN_OSD0 : WIN_OSD1;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osdwin_state->colorkey_blending = 1;
+	osdwin_state->colorkey = colorkey;
+	if (win->lconfig.pixfmt != PIXFMT_OSD_ATTR)
+		_osd_enable_color_key(sd, osdwin, colorkey,
+				      win->lconfig.pixfmt);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
 static void _osd_disable_color_key(struct osd_state *sd,
 				   enum osd_win_layer osdwin)
 {
@@ -421,6 +1062,69 @@ static void _osd_set_osd_clut(struct osd_state *sd,
 	}
 }
 
+static void osd_disable_color_key(struct osd_state *sd,
+				  enum osd_win_layer osdwin)
+{
+	struct osd_state *osd = sd;
+	enum osd_layer layer =
+	    (osdwin == OSDWIN_OSD0) ? WIN_OSD0 : WIN_OSD1;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osdwin_state->colorkey_blending = 0;
+	if (win->lconfig.pixfmt != PIXFMT_OSD_ATTR)
+		_osd_disable_color_key(sd, osdwin);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static void osd_set_osd_clut(struct osd_state *sd, enum osd_win_layer osdwin,
+			     enum osd_clut clut)
+{
+	struct osd_state *osd = sd;
+	enum osd_layer layer =
+	    (osdwin == OSDWIN_OSD0) ? WIN_OSD0 : WIN_OSD1;
+	struct osd_window_state *win = &osd->win[layer];
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	osdwin_state->clut = clut;
+	if (win->lconfig.pixfmt != PIXFMT_OSD_ATTR)
+		_osd_set_osd_clut(sd, osdwin, clut);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+static enum osd_clut osd_get_osd_clut(struct osd_state *sd,
+				      enum osd_win_layer osdwin)
+{
+	struct osd_state *osd = sd;
+	struct osd_osdwin_state *osdwin_state = &osd->osdwin[osdwin];
+
+	return osdwin_state->clut;
+}
+
+static void osd_get_zoom(struct osd_state *sd, enum osd_layer layer,
+			 enum osd_zoom_factor *h_zoom,
+			 enum osd_zoom_factor *v_zoom)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	*h_zoom = win->h_zoom;
+	*v_zoom = win->v_zoom;
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
 static void _osd_set_zoom(struct osd_state *sd, enum osd_layer layer,
 			  enum osd_zoom_factor h_zoom,
 			  enum osd_zoom_factor v_zoom)
@@ -454,6 +1158,31 @@ static void _osd_set_zoom(struct osd_state *sd, enum osd_layer layer,
 		break;
 	}
 }
+static void osd_set_zoom(struct osd_state *sd, enum osd_layer layer,
+			 enum osd_zoom_factor h_zoom,
+			 enum osd_zoom_factor v_zoom)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	win->h_zoom = h_zoom;
+	win->v_zoom = v_zoom;
+	_osd_set_zoom(sd, layer, h_zoom, v_zoom);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+}
+
+
+static int osd_layer_is_enabled(struct osd_state *sd, enum osd_layer layer)
+{
+	struct osd_state *osd = sd;
+	struct osd_window_state *win = &osd->win[layer];
+
+	return win->is_enabled;
+}
 
 static void _osd_disable_layer(struct osd_state *sd, enum osd_layer layer)
 {
@@ -497,7 +1226,7 @@ static void osd_disable_layer(struct osd_state *sd, enum osd_layer layer)
 static void _osd_enable_attribute_mode(struct osd_state *sd)
 {
 	/* enable attribute mode for OSD1 */
-	osd_set(sd, OSD_OSDWIN1MD_OASW, OSD_OSDWIN1MD);
+	osd_set(sd, OSD_OSDWIN1MD_OASW | OSD_OSDWIN1MD_OACT1, OSD_OSDWIN1MD);
 }
 
 static void _osd_enable_layer(struct osd_state *sd, enum osd_layer layer)
@@ -811,7 +1540,7 @@ static int try_layer_config(struct osd_state *sd, enum osd_layer layer,
 	case PIXFMT_8BPP:
 	case PIXFMT_RGB565:
 		if (osd->vpbe_type == VPBE_VERSION_1)
-			bad_config = !is_vid_win(layer);
+			bad_config = !is_osd_win(layer);
 		break;
 	case PIXFMT_YCBCRI:
 	case PIXFMT_YCRCBI:
@@ -910,6 +1639,22 @@ static int try_layer_config(struct osd_state *sd, enum osd_layer layer,
 	return 0;
 }
 
+static int osd_try_layer_config(struct osd_state *sd, enum osd_layer layer,
+				struct osd_layer_config *lconfig)
+{
+	struct osd_state *osd = sd;
+	int reject_config;
+	unsigned long flags;
+
+	spin_lock_irqsave(&osd->lock, flags);
+
+	reject_config = try_layer_config(sd, layer, lconfig);
+
+	spin_unlock_irqrestore(&osd->lock, flags);
+
+	return reject_config;
+}
+
 static void _osd_disable_vid_rgb888(struct osd_state *sd)
 {
 	/*
@@ -1530,16 +2275,51 @@ static int osd_initialize(struct osd_state *osd)
 }
 
 static const struct vpbe_osd_ops osd_ops = {
+	.set_clut_ycbcr = osd_set_clut_ycbcr,
+	.set_clut_rgb = osd_set_clut_rgb,
+	.set_osd_clut = osd_set_osd_clut,
+	.get_osd_clut = osd_get_osd_clut,
+	.enable_color_key = osd_enable_color_key,
+	.disable_color_key = osd_disable_color_key,
+	.set_blending_factor = osd_set_blending_factor,
+	.get_blending_factor = osd_get_blending_factor,
+	.set_rec601_attenuation = osd_set_rec601_attenuation,
+	.get_rec601_attenuation = osd_get_rec601_attenuation,
+	.set_palette_map = osd_set_palette_map,
+	.get_palette_map = osd_get_palette_map,
+	.set_blink_attribute = osd_set_blink_attribute,
+	.get_blink_attribute = osd_get_blink_attribute,
+	.cursor_enable = osd_cursor_enable,
+	.cursor_disable = osd_cursor_disable,
+	.cursor_is_enabled = osd_cursor_is_enabled,
+	.set_cursor_config = osd_set_cursor_config,
+	.get_cursor_config = osd_get_cursor_config,
+	.set_field_inversion = osd_set_field_inversion,
+	.get_field_inversion = osd_get_field_inversion,
 	.initialize = osd_initialize,
 	.request_layer = osd_request_layer,
 	.release_layer = osd_release_layer,
 	.enable_layer = osd_enable_layer,
 	.disable_layer = osd_disable_layer,
+	.layer_is_enabled = osd_layer_is_enabled,
 	.set_layer_config = osd_set_layer_config,
+	.try_layer_config = osd_try_layer_config,
 	.get_layer_config = osd_get_layer_config,
 	.start_layer = osd_start_layer,
 	.set_left_margin = osd_set_left_margin,
 	.set_top_margin = osd_set_top_margin,
+	.set_interpolation_filter = osd_set_interpolation_filter,
+	.get_interpolation_filter = osd_get_interpolation_filter,
+	.set_osd_expansion = osd_set_osd_expansion,
+	.get_osd_expansion = osd_get_osd_expansion,
+	.set_vid_expansion = osd_set_vid_expansion,
+	.get_vid_expansion = osd_get_vid_expansion,
+	.set_zoom = osd_set_zoom,
+	.get_zoom = osd_get_zoom,
+	.set_background = osd_set_background,
+	.get_background = osd_get_background,
+	.set_rom_clut = osd_set_rom_clut,
+	.get_rom_clut = osd_get_rom_clut,
 };
 
 static int osd_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index 87eef9b..787a3ca 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <linux/slab.h>
+#include <linux/v4l2-dv-timings.h>
 
 #include <mach/hardware.h>
 #include <mach/mux.h>
@@ -31,6 +32,7 @@
 
 #include <linux/io.h>
 
+#include <media/v4l2-mediabus.h>
 #include <media/davinci/vpbe_types.h>
 #include <media/davinci/vpbe_venc.h>
 #include <media/davinci/vpss.h>
@@ -66,6 +68,7 @@ struct venc_state {
 	struct v4l2_subdev sd;
 	struct venc_callback *callback;
 	struct venc_platform_data *pdata;
+	enum v4l2_mbus_pixelcode if_params;
 	struct device *pdev;
 	u32 output;
 	v4l2_std_id std;
@@ -539,6 +542,10 @@ static long venc_ioctl(struct v4l2_subdev *sd,
 			unsigned int cmd,
 			void *arg)
 {
+	struct venc_callback *next, *prev, *callback;
+	struct venc_state *venc = to_state(sd);
+	unsigned long flags;
+	unsigned event = 0;
 	u32 val;
 
 	switch (cmd) {
@@ -547,6 +554,42 @@ static long venc_ioctl(struct v4l2_subdev *sd,
 		*((int *)arg) = ((val & VENC_VSTAT_FIDST) ==
 		VENC_VSTAT_FIDST);
 		break;
+	case VENC_REG_CALLBACK:
+		spin_lock_irqsave(&venc->lock, flags);
+		callback = (struct venc_callback *)arg;
+		next = venc->callback;
+		venc->callback = callback;
+		callback->next = next;
+		spin_unlock_irqrestore(&venc->lock, flags);
+		break;
+	case VENC_UNREG_CALLBACK:
+		spin_lock_irqsave(&venc->lock, flags);
+		callback = (struct venc_callback *)arg;
+		prev = venc->callback;
+		if (!prev)
+			return -EINVAL;
+
+		if (prev == callback) {
+			venc->callback = callback->next;
+		} else {
+			while (prev->next && (prev->next != callback))
+				prev = prev->next;
+			if (!prev->next)
+				return -EINVAL;
+			else
+				prev->next = callback->next;
+		}
+		spin_unlock_irqrestore(&venc->lock, flags);
+		break;
+	case VENC_INTERRUPT:
+		callback = venc->callback;
+		event = *((unsigned *)arg);
+		while (callback) {
+			if (callback->mask & event)
+				callback->handler(event, callback->arg);
+		callback = callback->next;
+		}
+		break;
 	default:
 		v4l2_err(sd, "Wrong IOCTL cmd\n");
 		break;
diff --git a/include/media/davinci/vpbe_osd.h b/include/media/davinci/vpbe_osd.h
index de59364..3df34c6 100644
--- a/include/media/davinci/vpbe_osd.h
+++ b/include/media/davinci/vpbe_osd.h
@@ -327,14 +327,59 @@ struct osd_cursor_state {
 struct osd_state;
 
 struct vpbe_osd_ops {
+	void (*set_clut_ycbcr)(struct osd_state *sd,
+			       unsigned char clut_index, unsigned char y,
+			       unsigned char cb, unsigned char cr);
+	void (*set_clut_rgb)(struct osd_state *sd, unsigned char clut_index,
+			     unsigned char r, unsigned char g,
+			     unsigned char b);
+	void (*set_osd_clut)(struct osd_state *sd, enum osd_win_layer osdwin,
+			     enum osd_clut clut);
+	enum osd_clut (*get_osd_clut)(struct osd_state *sd,
+				      enum osd_win_layer osdwin);
+	void (*enable_color_key)(struct osd_state *sd,
+				 enum osd_win_layer osdwin, unsigned colorkey);
+	void (*disable_color_key)(struct osd_state *sd,
+				  enum osd_win_layer osdwin);
+	void (*set_blending_factor)(struct osd_state *sd,
+				    enum osd_win_layer osdwin,
+				    enum osd_blending_factor blend);
+	enum osd_blending_factor (*get_blending_factor)(struct osd_state *sd,
+				  enum osd_win_layer osdwin);
+	void (*set_rec601_attenuation)(struct osd_state *sd,
+				  enum osd_win_layer osdwin, int enable);
+	int (*get_rec601_attenuation)(struct osd_state *sd,
+				  enum osd_win_layer osdwin);
+	void (*set_palette_map)(struct osd_state *sd,
+				enum osd_win_layer osdwin,
+				unsigned char pixel_value,
+				unsigned char clut_index);
+	unsigned char (*get_palette_map)(struct osd_state *sd,
+			enum osd_win_layer osdwin, unsigned char pixel_value);
+	void (*set_blink_attribute)(struct osd_state *sd, int enable,
+				    enum osd_blink_interval blink);
+	void (*get_blink_attribute)(struct osd_state *sd, int *enable,
+				    enum osd_blink_interval *blink);
+	void (*cursor_enable)(struct osd_state *sd);
+	void (*cursor_disable)(struct osd_state *sd);
+	int (*cursor_is_enabled)(struct osd_state *sd);
+	void (*set_cursor_config)(struct osd_state *sd,
+			  struct osd_cursor_config *cursor);
+	void (*get_cursor_config)(struct osd_state *sd,
+			  struct osd_cursor_config *cursor);
+	void (*set_field_inversion)(struct osd_state *sd, int enable);
+	int (*get_field_inversion)(struct osd_state *sd);
 	int (*initialize)(struct osd_state *sd);
 	int (*request_layer)(struct osd_state *sd, enum osd_layer layer);
 	void (*release_layer)(struct osd_state *sd, enum osd_layer layer);
 	int (*enable_layer)(struct osd_state *sd, enum osd_layer layer,
 			    int otherwin);
 	void (*disable_layer)(struct osd_state *sd, enum osd_layer layer);
+	int (*layer_is_enabled)(struct osd_state *sd, enum osd_layer layer);
 	int (*set_layer_config)(struct osd_state *sd, enum osd_layer layer,
 				struct osd_layer_config *lconfig);
+	int (*try_layer_config)(struct osd_state *sd, enum osd_layer layer,
+				struct osd_layer_config *lconfig);
 	void (*get_layer_config)(struct osd_state *sd, enum osd_layer layer,
 				 struct osd_layer_config *lconfig);
 	void (*start_layer)(struct osd_state *sd, enum osd_layer layer,
@@ -343,6 +388,13 @@ struct vpbe_osd_ops {
 	void (*set_left_margin)(struct osd_state *sd, u32 val);
 	void (*set_top_margin)(struct osd_state *sd, u32 val);
 	void (*set_interpolation_filter)(struct osd_state *sd, int filter);
+	int (*get_interpolation_filter)(struct osd_state *sd);
+	int (*set_osd_expansion)(struct osd_state *sd,
+				 enum osd_h_exp_ratio h_exp,
+				 enum osd_v_exp_ratio v_exp);
+	void (*get_osd_expansion)(struct osd_state *sd,
+				  enum osd_h_exp_ratio *h_exp,
+				  enum osd_v_exp_ratio *v_exp);
 	int (*set_vid_expansion)(struct osd_state *sd,
 					enum osd_h_exp_ratio h_exp,
 					enum osd_v_exp_ratio v_exp);
@@ -352,6 +404,16 @@ struct vpbe_osd_ops {
 	void (*set_zoom)(struct osd_state *sd, enum osd_layer layer,
 				enum osd_zoom_factor h_zoom,
 				enum osd_zoom_factor v_zoom);
+	void (*get_zoom)(struct osd_state *sd, enum osd_layer layer,
+			 enum osd_zoom_factor *h_zoom,
+			 enum osd_zoom_factor *v_zoom);
+	void (*set_background)(struct osd_state *sd, enum osd_clut clut,
+			       unsigned char clut_index);
+	void (*get_background)(struct osd_state *sd, enum osd_clut *clut,
+			      unsigned char *clut_index);
+	void (*set_rom_clut)(struct osd_state *sd,
+			     enum osd_rom_clut rom_clut);
+	enum osd_rom_clut (*get_rom_clut)(struct osd_state *sd);
 };
 
 struct osd_state {
diff --git a/include/media/davinci/vpbe_venc.h b/include/media/davinci/vpbe_venc.h
index 476fafc..98d73a9 100644
--- a/include/media/davinci/vpbe_venc.h
+++ b/include/media/davinci/vpbe_venc.h
@@ -29,6 +29,24 @@
 #define VENC_FIRST_FIELD	BIT(1)
 #define VENC_SECOND_FIELD	BIT(2)
 
+/**
+ * struct venc_callback
+ * @next: used internally by the venc driver to maintain a linked list of
+ *        callbacks
+ * @mask: a bitmask specifying the venc event(s) for which the
+ *        callback will be invoked
+ * @handler: the callback routine
+ * @arg: a null pointer that is passed as the second argument to the callback
+ *       routine
+ */
+struct venc_callback {
+	struct venc_callback *next;
+	char *owner;
+	unsigned mask;
+	void (*handler) (unsigned event, void *arg);
+	void *arg;
+};
+
 struct venc_platform_data {
 	int (*setup_pinmux)(enum v4l2_mbus_pixelcode if_type,
 			    int field);
@@ -42,6 +60,9 @@ struct venc_platform_data {
 
 enum venc_ioctls {
 	VENC_GET_FLD = 1,
+	VENC_REG_CALLBACK,
+	VENC_UNREG_CALLBACK,
+	VENC_INTERRUPT,
 };
 
 /* exported functions */
-- 
1.7.4.1

