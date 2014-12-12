Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504AbaLLGfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:35:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51945 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759322AbaLLGQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sinclair Yeh" <syeh@vmware.com>,
        "Thomas Hellstrom" <thellstrom@vmware.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.766206221@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 104/164] drm/vmwgfx: Filter out modes those cannot be
 supported by the current VRAM size.
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: drop changes for dev_priv->prim_bb_mem]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |  6 +++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 16 +++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1826,6 +1826,14 @@ int vmw_du_connector_fill_modes(struct d
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
@@ -1836,8 +1844,9 @@ int vmw_du_connector_fill_modes(struct d
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
@@ -1859,7 +1868,8 @@ int vmw_du_connector_fill_modes(struct d
 		    bmode->vdisplay > max_height)
 			continue;
 
-		if (!vmw_kms_validate_mode_vram(dev_priv, bmode->hdisplay * 2,
+		if (!vmw_kms_validate_mode_vram(dev_priv,
+						bmode->hdisplay * assumed_bpp,
 						bmode->vdisplay))
 			continue;
 

