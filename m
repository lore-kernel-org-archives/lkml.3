Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaLSCBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:01:14 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51108 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaLSCBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:10 -0500
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
Subject: [PATCH v2 5/7] imx-drm: encoder prepare/mode_set must use adjusted mode
Date: Thu, 18 Dec 2014 18:00:24 -0800
Message-Id: <1418954426-21909-6-git-send-email-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The encoder ->prepare() and ->mode_set() methods need to use the
hw adjusted mode, not the original mode.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/drm/imx/imx-hdmi.c         |    4 ++--
 drivers/gpu/drm/imx/imx-ldb.c          |    6 +++---
 drivers/gpu/drm/imx/imx-tve.c          |    4 ++--
 drivers/gpu/drm/imx/parallel-display.c |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/imx/imx-hdmi.c b/drivers/gpu/drm/imx/imx-hdmi.c
index aaec6b2..32116cc 100644
--- a/drivers/gpu/drm/imx/imx-hdmi.c
+++ b/drivers/gpu/drm/imx/imx-hdmi.c
@@ -1417,8 +1417,8 @@ static struct drm_encoder *imx_hdmi_connector_best_encoder(struct drm_connector
 }
 
 static void imx_hdmi_encoder_mode_set(struct drm_encoder *encoder,
-			struct drm_display_mode *mode,
-			struct drm_display_mode *adjusted_mode)
+			struct drm_display_mode *orig_mode,
+			struct drm_display_mode *mode)
 {
 	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
 
diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 4662e00..5b9c875 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -168,7 +168,7 @@ static void imx_ldb_encoder_prepare(struct drm_encoder *encoder)
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
-	struct drm_display_mode *mode = &encoder->crtc->mode;
+	struct drm_display_mode *mode = &encoder->crtc->hwmode;
 	u32 pixel_fmt;
 	unsigned long serial_clk;
 	unsigned long di_clk = mode->clock * 1000;
@@ -246,8 +246,8 @@ static void imx_ldb_encoder_commit(struct drm_encoder *encoder)
 }
 
 static void imx_ldb_encoder_mode_set(struct drm_encoder *encoder,
-			 struct drm_display_mode *mode,
-			 struct drm_display_mode *adjusted_mode)
+			 struct drm_display_mode *orig_mode,
+			 struct drm_display_mode *mode)
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index 42c651b..9709bf9a 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -312,8 +312,8 @@ static void imx_tve_encoder_prepare(struct drm_encoder *encoder)
 }
 
 static void imx_tve_encoder_mode_set(struct drm_encoder *encoder,
-				     struct drm_display_mode *mode,
-				     struct drm_display_mode *adjusted_mode)
+				     struct drm_display_mode *orig_mode,
+				     struct drm_display_mode *mode)
 {
 	struct imx_tve *tve = enc_to_tve(encoder);
 	unsigned long rounded_rate;
diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index 015a454..d0842a4 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -131,8 +131,8 @@ static void imx_pd_encoder_commit(struct drm_encoder *encoder)
 }
 
 static void imx_pd_encoder_mode_set(struct drm_encoder *encoder,
-			 struct drm_display_mode *mode,
-			 struct drm_display_mode *adjusted_mode)
+			 struct drm_display_mode *orig_mode,
+			 struct drm_display_mode *mode)
 {
 }
 
-- 
1.7.9.5

