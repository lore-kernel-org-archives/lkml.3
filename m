Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab3GKO06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43215 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab3GKO0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Harvey <charvey@matrox.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 78/98] drm/mgag200: Reject modes that are too big for VRAM
Date: Thu, 11 Jul 2013 15:24:48 +0100
Message-Id: <1373552708-15235-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

commit 0ba53171583f86bbcbba951fe172982f7fc3761c upstream.

A monitor or a user could request a resolution greater than the
available VRAM for the backing framebuffer. This change checks the
required framebuffer size against the max VRAM size and rejects modes
if they are too big. This change can also remove a mode request passed
in via the video= parameter.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 4e48f91..6356ea1 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1423,6 +1423,14 @@ static int mga_vga_get_modes(struct drm_connector *connector)
 static int mga_vga_mode_valid(struct drm_connector *connector,
 				 struct drm_display_mode *mode)
 {
+	struct drm_device *dev = connector->dev;
+	struct mga_device *mdev = (struct mga_device*)dev->dev_private;
+	struct mga_fbdev *mfbdev = mdev->mfbdev;
+	struct drm_fb_helper *fb_helper = &mfbdev->helper;
+	struct drm_fb_helper_connector *fb_helper_conn = NULL;
+	int bpp = 32;
+	int i = 0;
+
 	/* FIXME: Add bandwidth and g200se limitations */
 
 	if (mode->crtc_hdisplay > 2048 || mode->crtc_hsync_start > 4096 ||
@@ -1432,6 +1440,25 @@ static int mga_vga_mode_valid(struct drm_connector *connector,
 		return MODE_BAD;
 	}
 
+	/* Validate the mode input by the user */
+	for (i = 0; i < fb_helper->connector_count; i++) {
+		if (fb_helper->connector_info[i]->connector == connector) {
+			/* Found the helper for this connector */
+			fb_helper_conn = fb_helper->connector_info[i];
+			if (fb_helper_conn->cmdline_mode.specified) {
+				if (fb_helper_conn->cmdline_mode.bpp_specified) {
+					bpp = fb_helper_conn->cmdline_mode.bpp;
+				}
+			}
+		}
+	}
+
+	if ((mode->hdisplay * mode->vdisplay * (bpp/8)) > mdev->mc.vram_size) {
+		if (fb_helper_conn)
+			fb_helper_conn->cmdline_mode.specified = false;
+		return MODE_BAD;
+	}
+
 	return MODE_OK;
 }
 
-- 
1.8.1.2

