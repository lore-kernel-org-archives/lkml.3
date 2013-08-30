Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3H3Rx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:53:27 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:44391 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab3H3Rx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:53:26 -0400
From: Fabio Estevam <festevam@gmail.com>
To: airlied@redhat.com
Cc: s.hauer@pengutronix.de, gregkh@linuxfoundation.org, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3] imx-drm: Fix probe failure
Date: Fri, 30 Aug 2013 14:53:12 -0300
Message-Id: <1377885192-22005-1-git-send-email-festevam@gmail.com>
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

The reason for the probe failure is that now 'imxdrm->references' is incremented
early in imx_drm_driver_load(), so the following checks in imx_drm_add_crtc()
and imx_drm_add_encoder():

	if (imxdrm->references) {
		ret = -EBUSY;
		goto err_busy;
	}

,will always fail.

Instead of manually keeping the references in the imx-drm driver, let's use
drm->open_count.

After this patch, lvds panel is functional on a mx6qsabrelite board.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
This one should go via Dave Airlie's tree instead of Greg's tree because
b5dc0d10 is in Dave's tree.

Changes since v2:
- Use imxdrm->drm->open_count for checking the references
Changes since v1:
- Improved commit log by providing an explanation to the probe failure
- Cc'ed Dave/Daniel

 drivers/staging/imx-drm/imx-drm-core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 47c5888..a2e52a0 100644
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
@@ -485,7 +480,7 @@ int imx_drm_add_crtc(struct drm_crtc *crtc,
 
 	mutex_lock(&imxdrm->mutex);
 
-	if (imxdrm->references) {
+	if (imxdrm->drm->open_count) {
 		ret = -EBUSY;
 		goto err_busy;
 	}
@@ -564,7 +559,7 @@ int imx_drm_add_encoder(struct drm_encoder *encoder,
 
 	mutex_lock(&imxdrm->mutex);
 
-	if (imxdrm->references) {
+	if (imxdrm->drm->open_count) {
 		ret = -EBUSY;
 		goto err_busy;
 	}
@@ -709,7 +704,7 @@ int imx_drm_add_connector(struct drm_connector *connector,
 
 	mutex_lock(&imxdrm->mutex);
 
-	if (imxdrm->references) {
+	if (imxdrm->drm->open_count) {
 		ret = -EBUSY;
 		goto err_busy;
 	}
-- 
1.8.1.2

