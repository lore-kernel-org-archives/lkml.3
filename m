Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaKYLXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:23:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaKYKmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sinclair Yeh <syeh@vmware.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 131/254] drm/vmwgfx: Filter out modes those cannot be supported by the current VRAM size.
Date: Tue, 25 Nov 2014 10:38:01 +0000
Message-Id: <1416912004-5928-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sinclair Yeh <syeh@vmware.com>

commit 9a72384d86b26cb8a2b25106677e1197f606668f upstream.

When screen objects are enabled, the bpp is assumed to be 32, otherwise
it is set to 16.

v2:
* Use u32 instead of u64 for assumed_bpp.
* Fixed mechanism to check for screen objects
* Limit the back buffer size to VRAM.

Signed-off-by: Sinclair Yeh <syeh@vmware.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |  6 +++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 16 +++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 246a62bab378..440b814046fb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -688,7 +688,11 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 		goto out_err0;
 	}
 
-	if (unlikely(dev_priv->prim_bb_mem < dev_priv->vram_size))
+	/*
+	 * Limit back buffer size to VRAM size.  Remove this once
+	 * screen targets are implemented.
+	 */
+	if (dev_priv->prim_bb_mem > dev_priv->vram_size)
 		dev_priv->prim_bb_mem = dev_priv->vram_size;
 
 	mutex_unlock(&dev_priv->hw_mutex);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 8f3edc4710f2..bedf18c054d1 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1952,6 +1952,14 @@ int vmw_du_connector_fill_modes(struct drm_connector *connector,
 		DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_PVSYNC)
 	};
 	int i;
+	u32 assumed_bpp = 2;
+
+	/*
+	 * If using screen objects, then assume 32-bpp because that's what the
+	 * SVGA device is assuming
+	 */
+	if (dev_priv->sou_priv)
+		assumed_bpp = 4;
 
 	/* Add preferred mode */
 	{
@@ -1962,8 +1970,9 @@ int vmw_du_connector_fill_modes(struct drm_connector *connector,
 		mode->vdisplay = du->pref_height;
 		vmw_guess_mode_timing(mode);
 
-		if (vmw_kms_validate_mode_vram(dev_priv, mode->hdisplay * 2,
-					       mode->vdisplay)) {
+		if (vmw_kms_validate_mode_vram(dev_priv,
+						mode->hdisplay * assumed_bpp,
+						mode->vdisplay)) {
 			drm_mode_probed_add(connector, mode);
 		} else {
 			drm_mode_destroy(dev, mode);
@@ -1985,7 +1994,8 @@ int vmw_du_connector_fill_modes(struct drm_connector *connector,
 		    bmode->vdisplay > max_height)
 			continue;
 
-		if (!vmw_kms_validate_mode_vram(dev_priv, bmode->hdisplay * 2,
+		if (!vmw_kms_validate_mode_vram(dev_priv,
+						bmode->hdisplay * assumed_bpp,
 						bmode->vdisplay))
 			continue;
 
-- 
2.1.0

