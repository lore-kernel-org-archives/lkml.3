Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab3GKOcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:32:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43234 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab3GKO1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julia Lemire <jlemire@matrox.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 79/98] drm/mgag200: Added resolution and bandwidth limits for various G200e products.
Date: Thu, 11 Jul 2013 15:24:49 +0100
Message-Id: <1373552708-15235-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lemire <jlemire@matrox.com>

commit abbee6238775c6633a3779962e9e5b5cb9823749 upstream.

At the larger resolutions, the g200e series sometimes struggles with
maintaining a proper output.  Problems like flickering or black bands appearing
on screen can occur.  In order to avoid this, limitations regarding resolutions
and bandwidth have been added for the different variations of the g200e series.
This code was ported from the old xorg mga driver.

Signed-off-by: Julia Lemire <jlemire@matrox.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_drv.h  |  3 +-
 drivers/gpu/drm/mgag200/mgag200_main.c |  2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c | 70 ++++++++++++++++++++++++++++++++--
 3 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index aa2fa4d..01cc01b 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -200,7 +200,8 @@ struct mga_device {
 		atomic_t validate_sequence;
 	} ttm;
 
-	u32 reg_1e24; /* SE model number */
+	/* SE model number stored in reg 0x1e24 */
+	u32 unique_rev_id;
 };
 
 
diff --git a/drivers/gpu/drm/mgag200/mgag200_main.c b/drivers/gpu/drm/mgag200/mgag200_main.c
index 636a81c..3663a11 100644
--- a/drivers/gpu/drm/mgag200/mgag200_main.c
+++ b/drivers/gpu/drm/mgag200/mgag200_main.c
@@ -190,7 +190,7 @@ static int mgag200_device_init(struct drm_device *dev,
 
 	/* stash G200 SE model number for later use */
 	if (IS_G200_SE(mdev))
-		mdev->reg_1e24 = RREG32(0x1e24);
+		mdev->unique_rev_id = RREG32(0x1e24);
 
 	ret = mga_vram_init(mdev);
 	if (ret) {
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 6356ea1..f780f2c 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1016,7 +1016,7 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 
 
 	if (IS_G200_SE(mdev)) {
-		if (mdev->reg_1e24 >= 0x02) {
+		if (mdev->unique_rev_id >= 0x02) {
 			u8 hi_pri_lvl;
 			u32 bpp;
 			u32 mb;
@@ -1046,7 +1046,7 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 			WREG8(MGAREG_CRTCEXT_DATA, hi_pri_lvl);
 		} else {
 			WREG8(MGAREG_CRTCEXT_INDEX, 0x06);
-			if (mdev->reg_1e24 >= 0x01)
+			if (mdev->unique_rev_id >= 0x01)
 				WREG8(MGAREG_CRTCEXT_DATA, 0x03);
 			else
 				WREG8(MGAREG_CRTCEXT_DATA, 0x04);
@@ -1420,6 +1420,32 @@ static int mga_vga_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
+static uint32_t mga_vga_calculate_mode_bandwidth(struct drm_display_mode *mode,
+							int bits_per_pixel)
+{
+	uint32_t total_area, divisor;
+	int64_t active_area, pixels_per_second, bandwidth;
+	uint64_t bytes_per_pixel = (bits_per_pixel + 7) / 8;
+
+	divisor = 1024;
+
+	if (!mode->htotal || !mode->vtotal || !mode->clock)
+		return 0;
+
+	active_area = mode->hdisplay * mode->vdisplay;
+	total_area = mode->htotal * mode->vtotal;
+
+	pixels_per_second = active_area * mode->clock * 1000;
+	do_div(pixels_per_second, total_area);
+
+	bandwidth = pixels_per_second * bytes_per_pixel * 100;
+	do_div(bandwidth, divisor);
+
+	return (uint32_t)(bandwidth);
+}
+
+#define MODE_BANDWIDTH	MODE_BAD
+
 static int mga_vga_mode_valid(struct drm_connector *connector,
 				 struct drm_display_mode *mode)
 {
@@ -1431,7 +1457,45 @@ static int mga_vga_mode_valid(struct drm_connector *connector,
 	int bpp = 32;
 	int i = 0;
 
-	/* FIXME: Add bandwidth and g200se limitations */
+	if (IS_G200_SE(mdev)) {
+		if (mdev->unique_rev_id == 0x01) {
+			if (mode->hdisplay > 1600)
+				return MODE_VIRTUAL_X;
+			if (mode->vdisplay > 1200)
+				return MODE_VIRTUAL_Y;
+			if (mga_vga_calculate_mode_bandwidth(mode, bpp)
+				> (24400 * 1024))
+				return MODE_BANDWIDTH;
+		} else if (mdev->unique_rev_id >= 0x02) {
+			if (mode->hdisplay > 1920)
+				return MODE_VIRTUAL_X;
+			if (mode->vdisplay > 1200)
+				return MODE_VIRTUAL_Y;
+			if (mga_vga_calculate_mode_bandwidth(mode, bpp)
+				> (30100 * 1024))
+				return MODE_BANDWIDTH;
+		}
+	} else if (mdev->type == G200_WB) {
+		if (mode->hdisplay > 1280)
+			return MODE_VIRTUAL_X;
+		if (mode->vdisplay > 1024)
+			return MODE_VIRTUAL_Y;
+		if (mga_vga_calculate_mode_bandwidth(mode,
+			bpp > (31877 * 1024)))
+			return MODE_BANDWIDTH;
+	} else if (mdev->type == G200_EV &&
+		(mga_vga_calculate_mode_bandwidth(mode, bpp)
+			> (32700 * 1024))) {
+		return MODE_BANDWIDTH;
+	} else if (mode->type == G200_EH &&
+		(mga_vga_calculate_mode_bandwidth(mode, bpp)
+			> (37500 * 1024))) {
+		return MODE_BANDWIDTH;
+	} else if (mode->type == G200_ER &&
+		(mga_vga_calculate_mode_bandwidth(mode,
+			bpp) > (55000 * 1024))) {
+		return MODE_BANDWIDTH;
+	}
 
 	if (mode->crtc_hdisplay > 2048 || mode->crtc_hsync_start > 4096 ||
 	    mode->crtc_hsync_end > 4096 || mode->crtc_htotal > 4096 ||
-- 
1.8.1.2

