Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaLSCCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:02:50 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46745 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaLSCBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:09 -0500
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
Subject: [PATCH v2 4/7] imx-drm: ipuv3-crtc: Implement mode_fixup
Date: Thu, 18 Dec 2014 18:00:23 -0800
Message-Id: <1418954426-21909-5-git-send-email-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ask the IPU display interface, via ipu_di_adjust_videomode(), to
adjust a video mode to meet any DI restrictions. The function takes
a subsystem independent videomode, so the drm_display_mode must be
converted to videomode first, and then the adjusted mode converted
back to a drm_display_mode.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 11e84a2..fb16026 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -242,6 +242,18 @@ static bool ipu_crtc_mode_fixup(struct drm_crtc *crtc,
 				  const struct drm_display_mode *mode,
 				  struct drm_display_mode *adjusted_mode)
 {
+	struct ipu_crtc *ipu_crtc = to_ipu_crtc(crtc);
+	struct videomode vm;
+	int ret;
+
+	videomode_from_drm_display_mode(adjusted_mode, &vm);
+
+	ret = ipu_di_adjust_videomode(ipu_crtc->di, &vm);
+	if (ret)
+		return false;
+
+	drm_display_mode_from_videomode(&vm, adjusted_mode);
+
 	return true;
 }
 
-- 
1.7.9.5

