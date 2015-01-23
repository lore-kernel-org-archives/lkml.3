Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbbAWQSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:18:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50135 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbbAWQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:18:33 -0500
Message-ID: <1422029904.3017.37.camel@pengutronix.de>
Subject: Re: [PATCH v2 0/7] imx-drm: ipuv3-crtc: Implement mode_fixup
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Liu Ying <Ying.Liu@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Denis Carikli <denis@eukrea.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Date: Fri, 23 Jan 2015 17:18:24 +0100
In-Reply-To: <CAOMZO5AYKbq34j2VnZKWqSBVfJgoOOhZX+mPgnMwZ1mzBAKGJQ@mail.gmail.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
	 <1420655248.3191.73.camel@pengutronix.de> <20150123025643.GA11412@victor>
	 <CAOMZO5AYKbq34j2VnZKWqSBVfJgoOOhZX+mPgnMwZ1mzBAKGJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 23.01.2015, 13:06 -0200 schrieb Fabio Estevam:
> On Fri, Jan 23, 2015 at 12:56 AM, Liu Ying <Ying.Liu@freescale.com> wrote:
> > Hi,
> >
> > It looks that the below commit makes my Hannstar XGA LVDS panel stop working
> > on the i.MX6DL SabreSD board.  Any idea?
> 
> Yes, with eb10d6355532def3a ("mx-drm: encoder prepare/mode_set must
> use adjusted mode") applied
> the DI clock is 0:

My bad, the problem is we are misusing encoder_prepare to enable the
display interface clock needed for the following crtc mode set.

What we really want is to use is adjusted_mode given to
encoder_funcs->mode_set, before the clock is enabled by
crtc_funcs->commit.

How about this patch:

-----8<-----
diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index abceb3d..99fe4bb 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -193,22 +193,8 @@ static void imx_ldb_encoder_prepare(struct drm_encoder *encoder)
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
-	struct drm_display_mode *mode = &encoder->crtc->hwmode;
 	u32 pixel_fmt;
-	unsigned long serial_clk;
-	unsigned long di_clk = mode->clock * 1000;
-	int mux = imx_ldb_get_mux_id(imx_ldb_ch);
 
-	if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {
-		/* dual channel LVDS mode */
-		serial_clk = 3500UL * mode->clock;
-		imx_ldb_set_clock(ldb, mux, 0, serial_clk, di_clk);
-		imx_ldb_set_clock(ldb, mux, 1, serial_clk, di_clk);
-	} else {
-		serial_clk = 7000UL * mode->clock;
-		imx_ldb_set_clock(ldb, mux, imx_ldb_ch->chno, serial_clk,
-				di_clk);
-	}
 
 	switch (imx_ldb_ch->chno) {
 	case 0:
@@ -281,6 +267,9 @@ static void imx_ldb_encoder_mode_set(struct drm_encoder *encoder,
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
 	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
+	unsigned long serial_clk;
+	unsigned long di_clk = mode->clock * 1000;
+	int mux = imx_ldb_get_mux_id(imx_ldb_ch);
 
 	if (mode->clock > 170000) {
 		dev_warn(ldb->dev,
@@ -291,6 +280,16 @@ static void imx_ldb_encoder_mode_set(struct drm_encoder *encoder,
 			 "%s: mode exceeds 85 MHz pixel clock\n", __func__);
 	}
 
+	if (dual) {
+		serial_clk = 3500UL * mode->clock;
+		imx_ldb_set_clock(ldb, mux, 0, serial_clk, di_clk);
+		imx_ldb_set_clock(ldb, mux, 1, serial_clk, di_clk);
+	} else {
+		serial_clk = 7000UL * mode->clock;
+		imx_ldb_set_clock(ldb, mux, imx_ldb_ch->chno, serial_clk,
+				  di_clk);
+	}
+
 	/* FIXME - assumes straight connections DI0 --> CH0, DI1 --> CH1 */
 	if (imx_ldb_ch == &ldb->channel[0]) {
 		if (mode->flags & DRM_MODE_FLAG_NVSYNC)
-- 
2.1.4
----->8-----

regards
Philipp

