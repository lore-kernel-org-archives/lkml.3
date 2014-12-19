Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaLSCDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:03:15 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35799 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaLSCBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:07 -0500
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
Subject: [PATCH v2 3/7] drm_modes: add videomode_from_drm_display_mode
Date: Thu, 18 Dec 2014 18:00:22 -0800
Message-Id: <1418954426-21909-4-git-send-email-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add conversion from drm_display_mode to videomode.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/drm/drm_modes.c |   40 ++++++++++++++++++++++++++++++++++++++++
 include/drm/drm_modes.h     |    2 ++
 2 files changed, 42 insertions(+)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 6d8b941..583a391 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -615,6 +615,46 @@ void drm_display_mode_from_videomode(const struct videomode *vm,
 }
 EXPORT_SYMBOL_GPL(drm_display_mode_from_videomode);
 
+/**
+ * videomode_from_drm_display_mode - fill in @vm using @dmode,
+ * @dmode: drm_display_mode structure to use as source
+ * @vm: videomode structure to use as destination
+ *
+ * Fills out @vm using the display mode specified in @dmode.
+ */
+void videomode_from_drm_display_mode(const struct drm_display_mode *dmode,
+				     struct videomode *vm)
+{
+	vm->hactive = dmode->hdisplay;
+	vm->hfront_porch = dmode->hsync_start - dmode->hdisplay;
+	vm->hsync_len = dmode->hsync_end - dmode->hsync_start;
+	vm->hback_porch = dmode->htotal - dmode->hsync_end;
+
+	vm->vactive = dmode->vdisplay;
+	vm->vfront_porch = dmode->vsync_start - dmode->vdisplay;
+	vm->vsync_len = dmode->vsync_end - dmode->vsync_start;
+	vm->vback_porch = dmode->vtotal - dmode->vsync_end;
+
+	vm->pixelclock = dmode->clock * 1000;
+
+	vm->flags = 0;
+	if (dmode->flags & DRM_MODE_FLAG_PHSYNC)
+		vm->flags |= DISPLAY_FLAGS_HSYNC_HIGH;
+	else if (dmode->flags & DRM_MODE_FLAG_NHSYNC)
+		vm->flags |= DISPLAY_FLAGS_HSYNC_LOW;
+	if (dmode->flags & DRM_MODE_FLAG_PVSYNC)
+		vm->flags |= DISPLAY_FLAGS_VSYNC_HIGH;
+	else if (dmode->flags & DRM_MODE_FLAG_NVSYNC)
+		vm->flags |= DISPLAY_FLAGS_VSYNC_LOW;
+	if (dmode->flags & DRM_MODE_FLAG_INTERLACE)
+		vm->flags |= DISPLAY_FLAGS_INTERLACED;
+	if (dmode->flags & DRM_MODE_FLAG_DBLSCAN)
+		vm->flags |= DISPLAY_FLAGS_DOUBLESCAN;
+	if (dmode->flags & DRM_MODE_FLAG_DBLCLK)
+		vm->flags |= DISPLAY_FLAGS_DOUBLECLK;
+}
+EXPORT_SYMBOL_GPL(videomode_from_drm_display_mode);
+
 #ifdef CONFIG_OF
 /**
  * of_get_drm_display_mode - get a drm_display_mode from devicetree
diff --git a/include/drm/drm_modes.h b/include/drm/drm_modes.h
index 91d0582..60c0144 100644
--- a/include/drm/drm_modes.h
+++ b/include/drm/drm_modes.h
@@ -197,6 +197,8 @@ struct drm_display_mode *drm_gtf_mode_complex(struct drm_device *dev,
 					      int GTF_K, int GTF_2J);
 void drm_display_mode_from_videomode(const struct videomode *vm,
 				     struct drm_display_mode *dmode);
+void videomode_from_drm_display_mode(const struct drm_display_mode *dmode,
+				     struct videomode *vm);
 int of_get_drm_display_mode(struct device_node *np,
 			    struct drm_display_mode *dmode,
 			    int index);
-- 
1.7.9.5

