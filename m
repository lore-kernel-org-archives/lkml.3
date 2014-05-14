Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaENO6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:58:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42729 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaENO6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:58:53 -0400
Subject: [RFC PATCH v1 15/16] drm/vmwgfx: use rcu in
 vmw_user_dmabuf_synccpu_grab
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Wed, 14 May 2014 16:58:50 +0200
Message-ID: <20140514145850.21163.43443.stgit@patser>
In-Reply-To: <20140514145134.21163.32350.stgit@patser>
References: <20140514145134.21163.32350.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 20a1a866ceeb..79e950df3018 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -567,13 +567,16 @@ static int vmw_user_dmabuf_synccpu_grab(struct vmw_user_dma_buffer *user_bo,
 	int ret;
 
 	if (flags & drm_vmw_synccpu_allow_cs) {
-		ret = ttm_bo_reserve(bo, true, !!(flags & drm_vmw_synccpu_dontblock), false, 0);
-		if (!ret) {
-			ret = ttm_bo_wait(bo, false, true,
-					  !!(flags & drm_vmw_synccpu_dontblock));
-			ttm_bo_unreserve(bo);
-		}
-		return ret;
+		long lret;
+		if (flags & drm_vmw_synccpu_dontblock)
+			return reservation_object_test_signaled_rcu(bo->resv, true) ? 0 : -EBUSY;
+
+		lret = reservation_object_wait_timeout_rcu(bo->resv, true, true, MAX_SCHEDULE_TIMEOUT);
+		if (!lret)
+			return -EBUSY;
+		else if (lret < 0)
+			return lret;
+		return 0;
 	}
 
 	ret = ttm_bo_synccpu_write_grab

