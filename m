Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343AbaKLCcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:32:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935079AbaKLBsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:48:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 3.14 191/203] drm/vmwgfx: Filter out modes those cannot be supported by the current VRAM size.
Date: Wed, 12 Nov 2014 10:17:41 +0900
Message-Id: <20141112011551.454116769@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    6 +++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |   16 +++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -688,7 +688,11 @@ static int vmw_driver_load(struct drm_de
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
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1954,6 +1954,14 @@ int vmw_du_connector_fill_modes(struct d
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
@@ -1964,8 +1972,9 @@ int vmw_du_connector_fill_modes(struct d
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
@@ -1987,7 +1996,8 @@ int vmw_du_connector_fill_modes(struct d
 		    bmode->vdisplay > max_height)
 			continue;
 
-		if (!vmw_kms_validate_mode_vram(dev_priv, bmode->hdisplay * 2,
+		if (!vmw_kms_validate_mode_vram(dev_priv,
+						bmode->hdisplay * assumed_bpp,
 						bmode->vdisplay))
 			continue;
 


