Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3LPMSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:18:09 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34801 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3LPMSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:18:05 -0500
From: xuyongjiande@gmail.com
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, xuyongjian <xuyongjiande@gmail.com>
Subject: [PATCH] drm: integer overflow in vmw_surface_define_ioctl()
Date: Mon, 16 Dec 2013 20:16:42 +0800
Message-Id: <1387196202-15125-1-git-send-email-xuyongjiande@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xuyongjian <xuyongjiande@gmail.com>

req comes from user-space, then integer overflow may happen in this line:
		num_sizes += req->mip_levels[i];

Signed-off-by: xuyongjian <xuyongjiande@gmail.com>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index 7de2ea8..5b7c7d2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -678,8 +678,12 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 			128;
 
 	num_sizes = 0;
-	for (i = 0; i < DRM_VMW_MAX_SURFACE_FACES; ++i)
+	for (i = 0; i < DRM_VMW_MAX_SURFACE_FACES; ++i) {
+		if (req->mip_levels[i] > DRM_VMW_MAX_SURFACE_FACES *
+			DRM_VMW_MAX_MIP_LEVELS)
+			return -EINVAL
 		num_sizes += req->mip_levels[i];
+	}
 
 	if (num_sizes > DRM_VMW_MAX_SURFACE_FACES *
 	    DRM_VMW_MAX_MIP_LEVELS)
-- 
1.7.9.5

