Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965588AbbA1EnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:43:13 -0500
Received: from mail.kernel.org ([198.145.29.136]:40479 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964995AbbA1EXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:48 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sinclair Yeh <syeh@vmware.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 118/177] drm/vmwgfx: Filter out modes those cannot be supported by the current VRAM size.
Date: Wed, 28 Jan 2015 12:09:36 +0800
Message-Id: <1422418236-12852-209-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sinclair Yeh <syeh@vmware.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 9a72384d86b26cb8a2b25106677e1197f606668f upstream.

When screen objects are enabled, the bpp is assumed to be 32, otherwise
it is set to 16.

v2:
* Use u32 instead of u64 for assumed_bpp.
* Fixed mechanism to check for screen objects
* Limit the back buffer size to VRAM.

Signed-off-by: Sinclair Yeh <syeh@vmware.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
[lizf: Backported to 3.4: drop the changes to vmw_driver_load()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 00fb5aa..7ca1d47 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1915,6 +1915,14 @@ int vmw_du_connector_fill_modes(struct drm_connector *connector,
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
@@ -1925,8 +1933,9 @@ int vmw_du_connector_fill_modes(struct drm_connector *connector,
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
@@ -1948,7 +1957,8 @@ int vmw_du_connector_fill_modes(struct drm_connector *connector,
 		    bmode->vdisplay > max_height)
 			continue;
 
-		if (!vmw_kms_validate_mode_vram(dev_priv, bmode->hdisplay * 2,
+		if (!vmw_kms_validate_mode_vram(dev_priv,
+						bmode->hdisplay * assumed_bpp,
 						bmode->vdisplay))
 			continue;
 
-- 
1.9.1

