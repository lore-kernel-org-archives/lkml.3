Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3LPNWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:22:09 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:62726 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3LPNWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:22:07 -0500
From: xuyongjiande@gmail.com
To: airlied@linux.ie, daniel.vetter@ffwll.ch, airlied@redhat.com
Cc: linux-kernel@vger.kernel.org, chyyuu@gmail.com, xiaoqixue_1@163.com,
        Yongjian Xu <xuyongjiande@gmail.com>
Subject: [PATCH] drm: integer overflow in vmw_kms_update_layout_ioctl()
Date: Mon, 16 Dec 2013 21:21:38 +0800
Message-Id: <1387200098-17694-1-git-send-email-xuyongjiande@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yongjian Xu <xuyongjiande@gmail.com>

rects is copy_from_user.
rects[i].x and rects[i].y are signed.
rects[i].w and rects[i].h are unsigned.
If rects[i].w is large enough, integer overflow could happen in: rects[i].x + rects[i].w
rects[i].h has the same problem.

Reported-by: Yongjian xu <xuyongjiande@gmail.com>
Suggested-by: Qixue Xiao <xiaoqixue_1@163.com>
Signed-off-by: Yu Chen <chyyuu@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 03f1c20..edec5f8 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2045,6 +2045,8 @@ int vmw_kms_update_layout_ioctl(struct drm_device *dev, void *data,
 	for (i = 0; i < arg->num_outputs; ++i) {
 		if (rects[i].x < 0 ||
 		    rects[i].y < 0 ||
+		    rects[i].w > mode_config->max_width ||
+		    rects[i].h > mode_config->max_height ||
 		    rects[i].x + rects[i].w > mode_config->max_width ||
 		    rects[i].y + rects[i].h > mode_config->max_height) {
 			DRM_ERROR("Invalid GUI layout.\n");
-- 
1.7.9.5

