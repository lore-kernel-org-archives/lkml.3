Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbbAYSxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:53:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbbAYSJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>, Sinclair Yeh <syeh@vmware.com>
Subject: [PATCH 3.18 026/183] drm/vmwgfx: Dont use memory accounting for kernel-side fence objects
Date: Sun, 25 Jan 2015 10:05:48 -0800
Message-Id: <20150125180811.300133649@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -545,35 +545,19 @@ void vmw_fence_obj_flush(struct vmw_fenc
 
 static void vmw_fence_destroy(struct vmw_fence_obj *fence)
 {
-	struct vmw_fence_manager *fman = fman_from_fence(fence);
-
 	fence_free(&fence->base);
-
-	/*
-	 * Free kernel space accounting.
-	 */
-	ttm_mem_global_free(vmw_mem_glob(fman->dev_priv),
-			    fman->fence_size);
 }
 
 int vmw_fence_create(struct vmw_fence_manager *fman,
 		     uint32_t seqno,
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
 
 	ret = vmw_fence_obj_init(fman, fence, seqno,
 				 vmw_fence_destroy);
@@ -585,8 +569,6 @@ int vmw_fence_create(struct vmw_fence_ma
 
 out_err_init:
 	kfree(fence);
-out_no_object:
-	ttm_mem_global_free(mem_glob, fman->fence_size);
 	return ret;
 }
 


