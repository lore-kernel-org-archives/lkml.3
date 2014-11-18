Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbaKROuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:50:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbaKROJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@gmail.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 116/206] qxl: don't create too large primary surface
Date: Tue, 18 Nov 2014 15:07:51 +0100
Message-Id: <ff4b0a924a8d99fb56e77760ebe7ea1e0129163b.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc-André Lureau <marcandre.lureau@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c572aaf46f71f63ae5914d4e194a955e0ba1b519 upstream.

Limit primary to qemu vgamem size, to avoid reaching
qemu guest bug "requested primary larger than framebuffer"
on resizing screen too large to fit.

Remove unneeded and misleading variables.

Related to:
https://bugzilla.redhat.com/show_bug.cgi?id=1127552

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/qxl/qxl_display.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index 835caba026d3..5f79e511c2a6 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -508,7 +508,6 @@ static int qxl_crtc_mode_set(struct drm_crtc *crtc,
 	struct qxl_framebuffer *qfb;
 	struct qxl_bo *bo, *old_bo = NULL;
 	struct qxl_crtc *qcrtc = to_qxl_crtc(crtc);
-	uint32_t width, height, base_offset;
 	bool recreate_primary = false;
 	int ret;
 	int surf_id;
@@ -538,9 +537,10 @@ static int qxl_crtc_mode_set(struct drm_crtc *crtc,
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
@@ -554,10 +554,10 @@ static int qxl_crtc_mode_set(struct drm_crtc *crtc,
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
 		surf_id = 0;
 	} else {
-- 
2.1.3

