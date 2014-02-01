Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbaBAD27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:28:59 -0500
Received: from gnurou.org ([207.192.72.5]:51780 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbaBAD2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:28:23 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 01/16] drm/nouveau: handle -EACCES runtime PM return code
Date: Sat,  1 Feb 2014 12:16:43 +0900
Message-Id: <1391224618-3794-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
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
index 0e3270c..1caef1f 100644
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
index 1674882..cddef54 100644
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
index 98a22e6..23299ca 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -670,7 +670,7 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 
 	/* need to bring up power immediately if opening device */
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -EACCES)
 		return ret;
 
 	get_task_comm(tmpname, current);
@@ -753,7 +753,7 @@ long nouveau_drm_ioctl(struct file *filp,
 	dev = file_priv->minor->dev;
 
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0)
+	if (ret < 0 && ret != -EACCES)
 		return ret;
 
 	ret = drm_ioctl(filp, cmd, arg);
-- 
1.8.5.3

