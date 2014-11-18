Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaKROKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:10:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269AbaKROKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sinclair Yeh <syeh@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 205/206] When screen objects are enabled, the bpp is assumed to be 32, otherwise it is set to 16.
Date: Tue, 18 Nov 2014 15:09:20 +0100
Message-Id: <2edb76f37c9f8e3081c5b5619c51f8f291819531.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sinclair Yeh <syeh@vmware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

v2:
* Use u32 instead of u64 for assumed_bpp.
* Fixed mechanism to check for screen objects
* Limit the back buffer size to VRAM.

v3:
* Backported for 3.12-stable

Signed-off-by: Sinclair Yeh <syeh@vmware.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index fc43c0601236..dab6fab5dc99 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1939,6 +1939,14 @@ int vmw_du_connector_fill_modes(struct drm_connector *connector,
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
@@ -1949,8 +1957,9 @@ int vmw_du_connector_fill_modes(struct drm_connector *connector,
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
@@ -1972,7 +1981,8 @@ int vmw_du_connector_fill_modes(struct drm_connector *connector,
 		    bmode->vdisplay > max_height)
 			continue;
 
-		if (!vmw_kms_validate_mode_vram(dev_priv, bmode->hdisplay * 2,
+		if (!vmw_kms_validate_mode_vram(dev_priv,
+						bmode->hdisplay * assumed_bpp,
 						bmode->vdisplay))
 			continue;
 
-- 
2.1.3

