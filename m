Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaBJF6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 00:58:25 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10014 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaBJF6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 00:58:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 09 Feb 2014 21:56:03 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/nouveau: handle -EACCES runtime PM return code
Date: Mon, 10 Feb 2014 14:58:12 +0900
Message-ID: <1392011892-4339-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_runtime_get*() may return -EACCESS to indicate a device does not have
runtime PM enabled. This is the case when the nouveau.runpm parameter is
set to 0, and is not an error in that context. Handle this case without
failure.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/dispnv04/crtc.c     | 2 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c | 2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c       | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv04/crtc.c b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
index 0e3270c3ffd2..1caef1fd139e 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/crtc.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
@@ -1048,7 +1048,7 @@ nouveau_crtc_set_config(struct drm_mode_set *set)
 
 	/* get a pm reference here */
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -EACCES)
 		return ret;
 
 	ret = drm_crtc_helper_set_config(set);
diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 1674882d60d5..cddef546d9b0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -255,7 +255,7 @@ nouveau_connector_detect(struct drm_connector *connector, bool force)
 	}
 
 	ret = pm_runtime_get_sync(connector->dev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -EACCES)
 		return conn_status;
 
 	i2c = nouveau_connector_ddc_detect(connector, &nv_encoder);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 8a4630a1fc45..2617168af244 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -696,7 +696,7 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 
 	/* need to bring up power immediately if opening device */
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -EACCES)
 		return ret;
 
 	get_task_comm(tmpname, current);
@@ -781,7 +781,7 @@ long nouveau_drm_ioctl(struct file *filp,
 	dev = file_priv->minor->dev;
 
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -EACCES)
 		return ret;
 
 	ret = drm_ioctl(filp, cmd, arg);
-- 
1.8.5.4

