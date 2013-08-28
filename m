Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3H1Cks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 22:40:48 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:38470 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab3H1Ckr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 22:40:47 -0400
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: s.hauer@pengutronix.de, p.zabel@pengutronix.de, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] imx-drm: Fix probe failure
Date: Tue, 27 Aug 2013 23:32:43 -0300
Message-Id: <1377657163-6606-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Since commit b5dc0d10 (drm/imx: kill firstopen callback) the following probe
failure is seen:

[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] Initialized imx-drm 1.0.0 20120507 on minor 0
imx-ldb ldb.10: adding encoder failed with -16
imx-ldb: probe of ldb.10 failed with error -16
imx-ipuv3 2400000.ipu: IPUv3H probed
imx-ipuv3 2800000.ipu: IPUv3H probed
imx-ipuv3-crtc imx-ipuv3-crtc.0: adding crtc failed with -16.
imx-ipuv3-crtc: probe of imx-ipuv3-crtc.0 failed with error -16
imx-ipuv3-crtc imx-ipuv3-crtc.1: adding crtc failed with -16.
imx-ipuv3-crtc: probe of imx-ipuv3-crtc.1 failed with error -16
imx-ipuv3-crtc imx-ipuv3-crtc.2: adding crtc failed with -16.
imx-ipuv3-crtc: probe of imx-ipuv3-crtc.2 failed with error -16
imx-ipuv3-crtc imx-ipuv3-crtc.3: adding crtc failed with -16.
imx-ipuv3-crtc: probe of imx-ipuv3-crtc.3 failed with error -16

'imxdrm->references' is not keeping the references correctly, causing the probe
to fail, so let's get rid of it.

After this patch, lvds panel is functional on a mx6qsabrelite board.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/staging/imx-drm/imx-drm-core.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 47c5888..98eac33 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -41,7 +41,6 @@ struct imx_drm_device {
 	struct list_head			encoder_list;
 	struct list_head			connector_list;
 	struct mutex				mutex;
-	int					references;
 	int					pipes;
 	struct drm_fbdev_cma			*fbhelper;
 };
@@ -241,8 +240,6 @@ struct drm_device *imx_drm_device_get(void)
 		}
 	}
 
-	imxdrm->references++;
-
 	return imxdrm->drm;
 
 unwind_crtc:
@@ -280,8 +277,6 @@ void imx_drm_device_put(void)
 	list_for_each_entry(enc, &imxdrm->encoder_list, list)
 		module_put(enc->owner);
 
-	imxdrm->references--;
-
 	mutex_unlock(&imxdrm->mutex);
 }
 EXPORT_SYMBOL_GPL(imx_drm_device_put);
@@ -485,11 +480,6 @@ int imx_drm_add_crtc(struct drm_crtc *crtc,
 
 	mutex_lock(&imxdrm->mutex);
 
-	if (imxdrm->references) {
-		ret = -EBUSY;
-		goto err_busy;
-	}
-
 	imx_drm_crtc = kzalloc(sizeof(*imx_drm_crtc), GFP_KERNEL);
 	if (!imx_drm_crtc) {
 		ret = -ENOMEM;
@@ -523,7 +513,6 @@ int imx_drm_add_crtc(struct drm_crtc *crtc,
 err_register:
 	kfree(imx_drm_crtc);
 err_alloc:
-err_busy:
 	mutex_unlock(&imxdrm->mutex);
 	return ret;
 }
@@ -564,11 +553,6 @@ int imx_drm_add_encoder(struct drm_encoder *encoder,
 
 	mutex_lock(&imxdrm->mutex);
 
-	if (imxdrm->references) {
-		ret = -EBUSY;
-		goto err_busy;
-	}
-
 	imx_drm_encoder = kzalloc(sizeof(*imx_drm_encoder), GFP_KERNEL);
 	if (!imx_drm_encoder) {
 		ret = -ENOMEM;
@@ -583,7 +567,7 @@ int imx_drm_add_encoder(struct drm_encoder *encoder,
 		ret = -ENOMEM;
 		goto err_register;
 	}
-
+
 	list_add_tail(&imx_drm_encoder->list, &imxdrm->encoder_list);
 
 	*newenc = imx_drm_encoder;
@@ -595,7 +579,6 @@ int imx_drm_add_encoder(struct drm_encoder *encoder,
 err_register:
 	kfree(imx_drm_encoder);
 err_alloc:
-err_busy:
 	mutex_unlock(&imxdrm->mutex);
 
 	return ret;
@@ -709,11 +692,6 @@ int imx_drm_add_connector(struct drm_connector *connector,
 
 	mutex_lock(&imxdrm->mutex);
 
-	if (imxdrm->references) {
-		ret = -EBUSY;
-		goto err_busy;
-	}
-
 	imx_drm_connector = kzalloc(sizeof(*imx_drm_connector), GFP_KERNEL);
 	if (!imx_drm_connector) {
 		ret = -ENOMEM;
@@ -738,7 +716,6 @@ int imx_drm_add_connector(struct drm_connector *connector,
 err_register:
 	kfree(imx_drm_connector);
 err_alloc:
-err_busy:
 	mutex_unlock(&imxdrm->mutex);
 
 	return ret;
-- 
1.8.1.2

