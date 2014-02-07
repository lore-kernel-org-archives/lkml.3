Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaBGNOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:14:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41591 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaBGLsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 044/233] drm/rcar-du: Update plane pitch in .mode_set_base() operation
Date: Fri,  7 Feb 2014 11:44:23 +0000
Message-Id: <1391773652-25214-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit eb86301f293da3c362db729a9f40ddb25755902b upstream.

When setting a new frame buffer with the mode set base operation the
pitch value might change. Set the hardware plane pitch register at the
same time as the plane base address in the rcar_du_plane_update_base()
function to make sure the pitch value always matches the frame buffer.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
[ luis: backported to 3.11:
  - replaced 'rgrp' by 'rcdu' in rcar_du_plane_write() call ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c  |  1 -
 drivers/gpu/drm/rcar-du/rcar_du_plane.c | 21 +++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 24183fb..23a946d 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -408,7 +408,6 @@ static int rcar_du_crtc_mode_set(struct drm_crtc *crtc,
 		goto error;
 
 	rcrtc->plane->format = format;
-	rcrtc->plane->pitch = crtc->fb->pitches[0];
 
 	rcrtc->plane->src_x = x;
 	rcrtc->plane->src_y = y;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.c b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
index a65f81d..e376b4c 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
@@ -102,6 +102,15 @@ void rcar_du_plane_update_base(struct rcar_du_plane *plane)
 {
 	struct rcar_du_device *rcdu = plane->dev;
 	unsigned int index = plane->hwindex;
+	u32 mwr;
+
+	/* Memory pitch (expressed in pixels) */
+	if (plane->format->planes == 2)
+		mwr = plane->pitch;
+	else
+		mwr = plane->pitch * 8 / plane->format->bpp;
+
+	rcar_du_plane_write(rcdu, index, PnMWR, mwr);
 
 	/* According to the datasheet the Y position is expressed in raster line
 	 * units. However, 32bpp formats seem to require a doubled Y position
@@ -128,6 +137,8 @@ void rcar_du_plane_compute_base(struct rcar_du_plane *plane,
 {
 	struct drm_gem_cma_object *gem;
 
+	plane->pitch = fb->pitches[0];
+
 	gem = drm_fb_cma_get_gem_obj(fb, 0);
 	plane->dma[0] = gem->paddr + fb->offsets[0];
 
@@ -204,7 +215,6 @@ static void __rcar_du_plane_setup(struct rcar_du_plane *plane,
 	struct rcar_du_device *rcdu = plane->dev;
 	u32 ddcr2 = PnDDCR2_CODE;
 	u32 ddcr4;
-	u32 mwr;
 
 	/* Data format
 	 *
@@ -235,14 +245,6 @@ static void __rcar_du_plane_setup(struct rcar_du_plane *plane,
 	rcar_du_plane_write(rcdu, index, PnDDCR2, ddcr2);
 	rcar_du_plane_write(rcdu, index, PnDDCR4, ddcr4);
 
-	/* Memory pitch (expressed in pixels) */
-	if (plane->format->planes == 2)
-		mwr = plane->pitch;
-	else
-		mwr = plane->pitch * 8 / plane->format->bpp;
-
-	rcar_du_plane_write(rcdu, index, PnMWR, mwr);
-
 	/* Destination position and size */
 	rcar_du_plane_write(rcdu, index, PnDSXR, plane->width);
 	rcar_du_plane_write(rcdu, index, PnDSYR, plane->height);
@@ -304,7 +306,6 @@ rcar_du_plane_update(struct drm_plane *plane, struct drm_crtc *crtc,
 
 	rplane->crtc = crtc;
 	rplane->format = format;
-	rplane->pitch = fb->pitches[0];
 
 	rplane->src_x = src_x >> 16;
 	rplane->src_y = src_y >> 16;
-- 
1.8.3.2

