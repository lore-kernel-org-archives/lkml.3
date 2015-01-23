Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbbAWPHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:07:01 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49903 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbAWPG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:06:59 -0500
MIME-Version: 1.0
In-Reply-To: <20150123025643.GA11412@victor>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
	<1420655248.3191.73.camel@pengutronix.de>
	<20150123025643.GA11412@victor>
Date: Fri, 23 Jan 2015 13:06:56 -0200
Message-ID: <CAOMZO5AYKbq34j2VnZKWqSBVfJgoOOhZX+mPgnMwZ1mzBAKGJQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] imx-drm: ipuv3-crtc: Implement mode_fixup
From: Fabio Estevam <festevam@gmail.com>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 12:56 AM, Liu Ying <Ying.Liu@freescale.com> wrote:
> Hi,
>
> It looks that the below commit makes my Hannstar XGA LVDS panel stop working
> on the i.MX6DL SabreSD board.  Any idea?

Yes, with eb10d6355532def3a ("mx-drm: encoder prepare/mode_set must
use adjusted mode") applied
the DI clock is 0:

--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -169,6 +169,8 @@ static void imx_ldb_encoder_prepare(struct
drm_encoder *encoder)
        unsigned long di_clk = mode->clock * 1000;
        int mux = imx_drm_encoder_get_mux_id(imx_ldb_ch->child, encoder);

+       pr_err("********* DI clock is %ld\n", di_clk);
+
        if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {

With eb10d6355532def3a applied:

[    1.493745] ********* DI clock is 0

With eb10d6355532def3a reverted:

[    1.493639] ********* DI clock is 65000000

Should we just go back to the previous usage?

--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -163,12 +163,14 @@ static void imx_ldb_encoder_prepare(struct
drm_encoder *encoder)
 {
        struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
        struct imx_ldb *ldb = imx_ldb_ch->ldb;
-       struct drm_display_mode *mode = &encoder->crtc->hwmode;
+       struct drm_display_mode *mode = &encoder->crtc->mode;
        u32 pixel_fmt;
