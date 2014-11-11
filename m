Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaKKLJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbaKKLJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 037/170] qxl: don't create too large primary surface
Date: Tue, 11 Nov 2014 11:06:36 +0000
Message-Id: <1415704129-12709-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@gmail.com>

commit c572aaf46f71f63ae5914d4e194a955e0ba1b519 upstream.

Limit primary to qemu vgamem size, to avoid reaching
qemu guest bug "requested primary larger than framebuffer"
on resizing screen too large to fit.

Remove unneeded and misleading variables.

Related to:
https://bugzilla.redhat.com/show_bug.cgi?id=1127552

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/qxl/qxl_display.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index 5d7ea2461852..98a344cef531 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -523,7 +523,6 @@ static int qxl_crtc_mode_set(struct drm_crtc *crtc,
 	struct qxl_framebuffer *qfb;
 	struct qxl_bo *bo, *old_bo = NULL;
 	struct qxl_crtc *qcrtc = to_qxl_crtc(crtc);
-	uint32_t width, height, base_offset;
 	bool recreate_primary = false;
 	int ret;
 	int surf_id;
@@ -553,9 +552,10 @@ static int qxl_crtc_mode_set(struct drm_crtc *crtc,
 	if (qcrtc->index == 0)
 		recreate_primary = true;
 
-	width = mode->hdisplay;
-	height = mode->vdisplay;
-	base_offset = 0;
+	if (bo->surf.stride * bo->surf.height > qdev->vram_size) {
+		DRM_ERROR("Mode doesn't fit in vram size (vgamem)");
+		return -EINVAL;
+        }
 
 	ret = qxl_bo_reserve(bo, false);
 	if (ret != 0)
@@ -569,10 +569,10 @@ static int qxl_crtc_mode_set(struct drm_crtc *crtc,
 	if (recreate_primary) {
 		qxl_io_destroy_primary(qdev);
 		qxl_io_log(qdev,
-			   "recreate primary: %dx%d (was %dx%d,%d,%d)\n",
-			   width, height, bo->surf.width,
-			   bo->surf.height, bo->surf.stride, bo->surf.format);
-		qxl_io_create_primary(qdev, base_offset, bo);
+			   "recreate primary: %dx%d,%d,%d\n",
+			   bo->surf.width, bo->surf.height,
+			   bo->surf.stride, bo->surf.format);
+		qxl_io_create_primary(qdev, 0, bo);
 		bo->is_primary = true;
 	}
 
-- 
2.1.0

