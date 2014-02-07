Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbaBGMat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:30:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42078 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaBGLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 140/233] drm/mgag200: fix oops in cursor code.
Date: Fri,  7 Feb 2014 11:45:59 +0000
Message-Id: <1391773652-25214-141-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 53dac830537b51df555ba5e7ebb236705b7eaa7c upstream.

In some cases we enter the cursor code with file_priv = NULL causing an oops,
we also can try to unpin something that isn't pinned, and this is a good fix for it.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_cursor.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_cursor.c b/drivers/gpu/drm/mgag200/mgag200_cursor.c
index 801731a..9f9780b 100644
--- a/drivers/gpu/drm/mgag200/mgag200_cursor.c
+++ b/drivers/gpu/drm/mgag200/mgag200_cursor.c
@@ -22,8 +22,10 @@ static void mga_hide_cursor(struct mga_device *mdev)
 {
 	WREG8(MGA_CURPOSXL, 0);
 	WREG8(MGA_CURPOSXH, 0);
-	mgag200_bo_unpin(mdev->cursor.pixels_1);
-	mgag200_bo_unpin(mdev->cursor.pixels_2);
+	if (mdev->cursor.pixels_1->pin_count)
+		mgag200_bo_unpin(mdev->cursor.pixels_1);
+	if (mdev->cursor.pixels_2->pin_count)
+		mgag200_bo_unpin(mdev->cursor.pixels_2);
 }
 
 int mga_crtc_cursor_set(struct drm_crtc *crtc,
@@ -32,7 +34,7 @@ int mga_crtc_cursor_set(struct drm_crtc *crtc,
 			uint32_t width,
 			uint32_t height)
 {
-	struct drm_device *dev = (struct drm_device *)file_priv->minor->dev;
+	struct drm_device *dev = crtc->dev;
 	struct mga_device *mdev = (struct mga_device *)dev->dev_private;
 	struct mgag200_bo *pixels_1 = mdev->cursor.pixels_1;
 	struct mgag200_bo *pixels_2 = mdev->cursor.pixels_2;
-- 
1.8.3.2

