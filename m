Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763898AbbA2DPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:15:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762200AbbA2CgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 076/139] drm/vmwgfx: Don't use memory accounting for kernel-side fence objects
Date: Wed, 28 Jan 2015 14:20:19 -0800
Message-Id: <1422483682-15393-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 1f563a6a46544602183e7493b6ef69769d3d76d9 upstream.

Kernel side fence objects are used when unbinding resources and may thus be
created as part of a memory reclaim operation. This might trigger recursive
memory reclaims and result in the kernel running out of stack space.

So a simple way out is to avoid accounting of these fence objects.
In principle this is OK since while user-space can trigger the creation of
such objects, it can't really hold on to them. However, their lifetime is
quite long, so some form of accounting should perhaps be implemented in the
future.

Fixes kernel crashes when running, for example viewperf11 ensight-04 test 3
with low system memory settings.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Reviewed-by: Sinclair Yeh <syeh@vmware.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index c62d20e..dc338fe 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -485,14 +485,7 @@ void vmw_fence_obj_flush(struct vmw_fence_obj *fence)
 
 static void vmw_fence_destroy(struct vmw_fence_obj *fence)
 {
-	struct vmw_fence_manager *fman = fence->fman;
-
 	kfree(fence);
-	/*
-	 * Free kernel space accounting.
-	 */
-	ttm_mem_global_free(vmw_mem_glob(fman->dev_priv),
-			    fman->fence_size);
 }
 
 int vmw_fence_create(struct vmw_fence_manager *fman,
@@ -500,20 +493,12 @@ int vmw_fence_create(struct vmw_fence_manager *fman,
 		     uint32_t mask,
 		     struct vmw_fence_obj **p_fence)
 {
-	struct ttm_mem_global *mem_glob = vmw_mem_glob(fman->dev_priv);
 	struct vmw_fence_obj *fence;
 	int ret;
 
-	ret = ttm_mem_global_alloc(mem_glob, fman->fence_size,
-				   false, false);
-	if (unlikely(ret != 0))
-		return ret;
-
 	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
-	if (unlikely(fence == NULL)) {
-		ret = -ENOMEM;
-		goto out_no_object;
-	}
+	if (unlikely(fence == NULL))
+		return -ENOMEM;
 
 	ret = vmw_fence_obj_init(fman, fence, seqno, mask,
 				 vmw_fence_destroy);
@@ -525,8 +510,6 @@ int vmw_fence_create(struct vmw_fence_manager *fman,
 
 out_err_init:
 	kfree(fence);
-out_no_object:
-	ttm_mem_global_free(mem_glob, fman->fence_size);
 	return ret;
 }
 
-- 
1.9.1

