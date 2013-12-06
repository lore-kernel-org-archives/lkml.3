Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161618Ab3LFOGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:06:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43837 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161335Ab3LFNA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 066/272] drm/qxl: fix memory leak in release list handling
Date: Fri,  6 Dec 2013 12:55:55 +0000
Message-Id: <1386334761-25517-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 1b28c3e628315ac0d9ef2d3fac0403f05ae692db upstream.

wow no idea how I got this far without seeing this,
leaking the entries in the list makes kmalloc-64 slab grow.

References: https://bugzilla.kernel.org/show_bug.cgi?id=65121
Reported-by: Matthew Stapleton <matthew4196@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/qxl/qxl_release.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/qxl/qxl_release.c b/drivers/gpu/drm/qxl/qxl_release.c
index b61449e..8c1909a 100644
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -92,6 +92,7 @@ qxl_release_free(struct qxl_device *qdev,
 						- DRM_FILE_OFFSET);
 		qxl_fence_remove_release(&bo->fence, release->id);
 		qxl_bo_unref(&bo);
+		kfree(entry);
 	}
 	spin_lock(&qdev->release_idr_lock);
 	idr_remove(&qdev->release_idr, release->id);
-- 
1.8.3.2

