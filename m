Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaLSCDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:03:37 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42805 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaLSCBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:05 -0500
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
        Jiada Wang <jiada_wang@mentor.com>, Deepak Das <deepak_das@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 1/7] gpu: ipu-di: Add ipu_di_adjust_videomode()
Date: Thu, 18 Dec 2014 18:00:20 -0800
Message-Id: <1418954426-21909-2-git-send-email-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiada Wang <jiada_wang@mentor.com>

On some monitors, high resolution modes are not working, exhibiting
pixel column truncation problems (for example, 1280x1024 displays as
1280x1022).

The function ipu_di_adjust_videomode() aims to fix these issues by
adjusting a passed videomode to IPU restrictions. The function can
be called from the drm_crtc_helper_funcs->mode_fixup() methods.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Deepak Das <deepak_das@mentor.com>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-di.c |   29 +++++++++++++++++++++++++++++
 include/video/imx-ipu-v3.h  |    2 ++
 2 files changed, 31 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index c490ba4..46f9570 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -511,6 +511,35 @@ static void ipu_di_config_clock(struct ipu_di *di,
 		clk_get_rate(di->clk_di_pixel) / (clkgen0 >> 4));
 }
 
+/*
+ * This function is called to adjust a video mode to IPU restrictions.
+ * It is meant to be called from drm crtc mode_fixup() methods.
+ */
+int ipu_di_adjust_videomode(struct ipu_di *di, struct videomode *mode)
+{
+	u32 diff;
+
+	if (mode->vfront_porch >= 2)
+		return 0;
+
+	diff = 2 - mode->vfront_porch;
+
+	if (mode->vback_porch >= diff) {
+		mode->vfront_porch = 2;
+		mode->vback_porch -= diff;
+	} else if (mode->vsync_len > diff) {
+		mode->vfront_porch = 2;
+		mode->vsync_len = mode->vsync_len - diff;
+	} else {
+		dev_warn(di->ipu->dev, "failed to adjust videomode\n");
+		return -EINVAL;
+	}
+
+	dev_warn(di->ipu->dev, "videomode adapted for IPU restrictions\n");
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_di_adjust_videomode);
+
 int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 {
 	u32 reg;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index c74bf4a..d333d54 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -17,6 +17,7 @@
 #include <linux/bitmap.h>
 #include <linux/fb.h>
 #include <media/v4l2-mediabus.h>
+#include <video/videomode.h>
 
 struct ipu_soc;
 
@@ -236,6 +237,7 @@ void ipu_di_put(struct ipu_di *);
 int ipu_di_disable(struct ipu_di *);
 int ipu_di_enable(struct ipu_di *);
 int ipu_di_get_num(struct ipu_di *);
+int ipu_di_adjust_videomode(struct ipu_di *di, struct videomode *mode);
 int ipu_di_init_sync_panel(struct ipu_di *, struct ipu_di_signal_cfg *sig);
 
 /*
-- 
1.7.9.5

