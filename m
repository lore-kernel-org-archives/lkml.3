Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3HEWVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:21:05 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40241 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3HEWUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:20:31 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Darren Etheridge <detheridge@ti.com>, David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] drm/i2c: tda998x: prepare for broken sync workaround
Date: Tue,  6 Aug 2013 00:20:17 +0200
Message-Id: <1375741218-10225-8-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Etheridge <detheridge@ti.com>

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
 drivers/gpu/drm/i2c/tda998x_drv.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 7bf227a..7dc5650 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -784,6 +784,15 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	n_line       = mode->vtotal;
 
 	ref_pix      = 3 + mode->hsync_start - mode->hdisplay;
+
+	/*
+	 * Attached LCD controllers may generate broken sync. Allow
+	 * those to adjust the position of the rising VS edge by adding
+	 * HSKEW to ref_pix.
+	 */
+	if (adjusted_mode->flags & DRM_MODE_FLAG_HSKEW)
+		ref_pix += adjusted_mode->hskew;
+
 	de_pix_s     = mode->htotal - mode->hdisplay;
 	de_pix_e     = de_pix_s + mode->hdisplay;
 	hs_pix_s     = mode->hsync_start - mode->hdisplay;
-- 
1.7.10.4

