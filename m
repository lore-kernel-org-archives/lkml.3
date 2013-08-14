Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363Ab3HNTnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:43:52 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:52870 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760279Ab3HNTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:43 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Darren Etheridge <detheridge@ti.com>, David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/8] drm/i2c: tda998x: prepare for broken sync workaround
Date: Wed, 14 Aug 2013 21:43:32 +0200
Message-Id: <1376509413-1462-8-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LCD controller cannot provide valid VESA style sync, i.e. coincident
HS/VS edges. First, this patch adds hskew passed from the adjusted_mode to
reference pixel calculation to allow those controllers to add an offset
relative to the expected reference pixel.

Signed-off-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
for v1:
- reword comment

Cc: David Airlie <airlied@linux.ie>
Cc: Darren Etheridge <detheridge@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/i2c/tda998x_drv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 92fcb3d..c2bd711 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -782,6 +782,14 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	de_pix_s     = mode->htotal - mode->hdisplay;
 	ref_pix      = 3 + hs_pix_s;
 
+	/*
+	 * Attached LCD controllers may generate broken sync. Allow
+	 * those to adjust the position of the rising VS edge by adding
+	 * HSKEW to ref_pix.
+	 */
+	if (adjusted_mode->flags & DRM_MODE_FLAG_HSKEW)
+		ref_pix += adjusted_mode->hskew;
+
 	if ((mode->flags & DRM_MODE_FLAG_INTERLACE) == 0) {
 		ref_line     = 1 + mode->vsync_start - mode->vdisplay;
 		vwin1_line_s = mode->vtotal - mode->vdisplay - 1;
-- 
1.7.10.4

