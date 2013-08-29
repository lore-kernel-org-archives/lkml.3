Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3H2N7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:59:40 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:44718 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001Ab3H2N7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:59:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <airlied@redhat.com>
CC: <daniel.vetter@ffwll.ch>, <gregkh@linuxfoundation.org>,
        <s.hauer@pengutronix.de>, <festevam@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2] imx-drm: Fix probe failure
Date: Thu, 29 Aug 2013 10:59:22 -0300
Message-ID: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Let the drm core handle the references instead of doing this manually in 
imx-drm. In imx-drm-core the open and close callbacks map to drm_open and 
drm_close, which handle the references via open_count.

After this patch, lvds panel is functional on a mx6qsabrelite board.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Improved commit log by providing an explanation to the probe failure
- Cc'ed Dave/Daniel

 drivers/staging/imx-drm/imx-drm-core.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 47c5888..6f0d24c 100644
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


