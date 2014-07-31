Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaGaPeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:34:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56907 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaGaPeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:34:15 -0400
Subject: [PATCH 13/19] drm/vmwgfx: get rid of different types of fence_flags
 entirely
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:34:07 +0200
Message-ID: <20140731153407.15061.64281.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one type was ever used. This is needed to simplify the fence
support in the next commit.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c  |    5 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h     |    1 -
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |   14 ++-------
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c   |   50 ++++++++++++-------------------
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.h   |    8 +----
 5 files changed, 26 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
index 4a36bb1dc525..f15718cc631d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
@@ -792,15 +792,12 @@ static int vmw_sync_obj_flush(void *sync_obj)
 
 static bool vmw_sync_obj_signaled(void *sync_obj)
 {
-	return	vmw_fence_obj_signaled((struct vmw_fence_obj *) sync_obj,
-				       DRM_VMW_FENCE_FLAG_EXEC);
-
+	return vmw_fence_obj_signaled((struct vmw_fence_obj *) sync_obj);
 }
 
 static int vmw_sync_obj_wait(void *sync_obj, bool lazy, bool interruptible)
 {
 	return vmw_fence_obj_wait((struct vmw_fence_obj *) sync_obj,
-				  DRM_VMW_FENCE_FLAG_EXEC,
 				  lazy, interruptible,
 				  VMW_FENCE_WAIT_TIMEOUT);
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index c1811750cc8d..0b1e4b0c919e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -342,7 +342,6 @@ struct vmw_sw_context{
 	uint32_t *cmd_bounce;
 	uint32_t cmd_bounce_size;
 	struct list_head resource_list;
-	uint32_t fence_flags;
 	struct ttm_buffer_object *cur_query_bo;
 	struct list_head res_relocations;
 	uint32_t *buf_start;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index b19b2b980cb4..214fcfd13cb2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -350,8 +350,6 @@ static int vmw_bo_to_validate_list(struct vmw_sw_context *sw_context,
 		vval_buf->validate_as_mob = validate_as_mob;
 	}
 
-	sw_context->fence_flags |= DRM_VMW_FENCE_FLAG_EXEC;
-
 	if (p_val_node)
 		*p_val_node = val_node;
 
@@ -2337,13 +2335,9 @@ int vmw_execbuf_fence_commands(struct drm_file *file_priv,
 
 	if (p_handle != NULL)
 		ret = vmw_user_fence_create(file_priv, dev_priv->fman,
-					    sequence,
-					    DRM_VMW_FENCE_FLAG_EXEC,
-					    p_fence, p_handle);
+					    sequence, p_fence, p_handle);
 	else
-		ret = vmw_fence_create(dev_priv->fman, sequence,
-				       DRM_VMW_FENCE_FLAG_EXEC,
-				       p_fence);
+		ret = vmw_fence_create(dev_priv->fman, sequence, p_fence);
 
 	if (unlikely(ret != 0 && !synced)) {
 		(void) vmw_fallback_wait(dev_priv, false, false,
@@ -2416,8 +2410,7 @@ vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 		ttm_ref_object_base_unref(vmw_fp->tfile,
 					  fence_handle, TTM_REF_USAGE);
 		DRM_ERROR("Fence copy error. Syncing.\n");
-		(void) vmw_fence_obj_wait(fence, fence->signal_mask,
-					  false, false,
+		(void) vmw_fence_obj_wait(fence, false, false,
 					  VMW_FENCE_WAIT_TIMEOUT);
 	}
 }
@@ -2469,7 +2462,6 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	sw_context->fp = vmw_fpriv(file_priv);
 	sw_context->cur_reloc = 0;
 	sw_context->cur_val_buf = 0;
-	sw_context->fence_flags = 0;
 	INIT_LIST_HEAD(&sw_context->resource_list);
 	sw_context->cur_query_bo = dev_priv->pinned_bo;
 	sw_context->last_query_ctx = NULL;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 436b013b4231..05b9eea8e875 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -207,9 +207,7 @@ void vmw_fence_manager_takedown(struct vmw_fence_manager *fman)
 }
 
 static int vmw_fence_obj_init(struct vmw_fence_manager *fman,
-			      struct vmw_fence_obj *fence,
-			      u32 seqno,
-			      uint32_t mask,
+			      struct vmw_fence_obj *fence, u32 seqno,
 			      void (*destroy) (struct vmw_fence_obj *fence))
 {
 	unsigned long irq_flags;
@@ -220,7 +218,6 @@ static int vmw_fence_obj_init(struct vmw_fence_manager *fman,
 	INIT_LIST_HEAD(&fence->seq_passed_actions);
 	fence->fman = fman;
 	fence->signaled = 0;
-	fence->signal_mask = mask;
 	kref_init(&fence->kref);
 	fence->destroy = destroy;
 	init_waitqueue_head(&fence->queue);
@@ -356,7 +353,7 @@ static bool vmw_fence_goal_check_locked(struct vmw_fence_obj *fence)
 	u32 goal_seqno;
 	__le32 __iomem *fifo_mem;
 
-	if (fence->signaled & DRM_VMW_FENCE_FLAG_EXEC)
+	if (fence->signaled)
 		return false;
 
 	fifo_mem = fence->fman->dev_priv->mmio_virt;
@@ -386,7 +383,7 @@ rerun:
 	list_for_each_entry_safe(fence, next_fence, &fman->fence_list, head) {
 		if (seqno - fence->seqno < VMW_FENCE_WRAP) {
 			list_del_init(&fence->head);
-			fence->signaled |= DRM_VMW_FENCE_FLAG_EXEC;
+			fence->signaled = 1;
 			INIT_LIST_HEAD(&action_list);
 			list_splice_init(&fence->seq_passed_actions,
 					 &action_list);
@@ -417,8 +414,7 @@ rerun:
 	}
 }
 
-bool vmw_fence_obj_signaled(struct vmw_fence_obj *fence,
-			    uint32_t flags)
+bool vmw_fence_obj_signaled(struct vmw_fence_obj *fence)
 {
 	struct vmw_fence_manager *fman = fence->fman;
 	unsigned long irq_flags;
@@ -428,28 +424,25 @@ bool vmw_fence_obj_signaled(struct vmw_fence_obj *fence,
 	signaled = fence->signaled;
 	spin_unlock_irqrestore(&fman->lock, irq_flags);
 
-	flags &= fence->signal_mask;
-	if ((signaled & flags) == flags)
+	if (signaled)
 		return 1;
 
-	if ((signaled & DRM_VMW_FENCE_FLAG_EXEC) == 0)
-		vmw_fences_update(fman);
+	vmw_fences_update(fman);
 
 	spin_lock_irqsave(&fman->lock, irq_flags);
 	signaled = fence->signaled;
 	spin_unlock_irqrestore(&fman->lock, irq_flags);
 
-	return ((signaled & flags) == flags);
+	return signaled;
 }
 
-int vmw_fence_obj_wait(struct vmw_fence_obj *fence,
-		       uint32_t flags, bool lazy,
+int vmw_fence_obj_wait(struct vmw_fence_obj *fence, bool lazy,
 		       bool interruptible, unsigned long timeout)
 {
 	struct vmw_private *dev_priv = fence->fman->dev_priv;
 	long ret;
 
-	if (likely(vmw_fence_obj_signaled(fence, flags)))
+	if (likely(vmw_fence_obj_signaled(fence)))
 		return 0;
 
 	vmw_fifo_ping_host(dev_priv, SVGA_SYNC_GENERIC);
@@ -458,12 +451,12 @@ int vmw_fence_obj_wait(struct vmw_fence_obj *fence,
 	if (interruptible)
 		ret = wait_event_interruptible_timeout
 			(fence->queue,
-			 vmw_fence_obj_signaled(fence, flags),
+			 vmw_fence_obj_signaled(fence),
 			 timeout);
 	else
 		ret = wait_event_timeout
 			(fence->queue,
-			 vmw_fence_obj_signaled(fence, flags),
+			 vmw_fence_obj_signaled(fence),
 			 timeout);
 
 	vmw_seqno_waiter_remove(dev_priv);
@@ -497,7 +490,6 @@ static void vmw_fence_destroy(struct vmw_fence_obj *fence)
 
 int vmw_fence_create(struct vmw_fence_manager *fman,
 		     uint32_t seqno,
-		     uint32_t mask,
 		     struct vmw_fence_obj **p_fence)
 {
 	struct ttm_mem_global *mem_glob = vmw_mem_glob(fman->dev_priv);
@@ -515,7 +507,7 @@ int vmw_fence_create(struct vmw_fence_manager *fman,
 		goto out_no_object;
 	}
 
-	ret = vmw_fence_obj_init(fman, fence, seqno, mask,
+	ret = vmw_fence_obj_init(fman, fence, seqno,
 				 vmw_fence_destroy);
 	if (unlikely(ret != 0))
 		goto out_err_init;
@@ -559,7 +551,6 @@ static void vmw_user_fence_base_release(struct ttm_base_object **p_base)
 int vmw_user_fence_create(struct drm_file *file_priv,
 			  struct vmw_fence_manager *fman,
 			  uint32_t seqno,
-			  uint32_t mask,
 			  struct vmw_fence_obj **p_fence,
 			  uint32_t *p_handle)
 {
@@ -586,7 +577,7 @@ int vmw_user_fence_create(struct drm_file *file_priv,
 	}
 
 	ret = vmw_fence_obj_init(fman, &ufence->fence, seqno,
-				 mask, vmw_user_fence_destroy);
+				 vmw_user_fence_destroy);
 	if (unlikely(ret != 0)) {
 		kfree(ufence);
 		goto out_no_object;
@@ -647,13 +638,12 @@ void vmw_fence_fifo_down(struct vmw_fence_manager *fman)
 		kref_get(&fence->kref);
 		spin_unlock_irq(&fman->lock);
 
-		ret = vmw_fence_obj_wait(fence, fence->signal_mask,
-					 false, false,
+		ret = vmw_fence_obj_wait(fence, false, false,
 					 VMW_FENCE_WAIT_TIMEOUT);
 
 		if (unlikely(ret != 0)) {
 			list_del_init(&fence->head);
-			fence->signaled |= DRM_VMW_FENCE_FLAG_EXEC;
+			fence->signaled = 1;
 			INIT_LIST_HEAD(&action_list);
 			list_splice_init(&fence->seq_passed_actions,
 					 &action_list);
@@ -716,14 +706,14 @@ int vmw_fence_obj_wait_ioctl(struct drm_device *dev, void *data,
 
 	timeout = jiffies;
 	if (time_after_eq(timeout, (unsigned long)arg->kernel_cookie)) {
-		ret = ((vmw_fence_obj_signaled(fence, arg->flags)) ?
+		ret = ((vmw_fence_obj_signaled(fence)) ?
 		       0 : -EBUSY);
 		goto out;
 	}
 
 	timeout = (unsigned long)arg->kernel_cookie - timeout;
 
-	ret = vmw_fence_obj_wait(fence, arg->flags, arg->lazy, true, timeout);
+	ret = vmw_fence_obj_wait(fence, arg->lazy, true, timeout);
 
 out:
 	ttm_base_object_unref(&base);
@@ -760,10 +750,10 @@ int vmw_fence_obj_signaled_ioctl(struct drm_device *dev, void *data,
 	fence = &(container_of(base, struct vmw_user_fence, base)->fence);
 	fman = fence->fman;
 
-	arg->signaled = vmw_fence_obj_signaled(fence, arg->flags);
+	arg->signaled = vmw_fence_obj_signaled(fence);
 	spin_lock_irq(&fman->lock);
 
-	arg->signaled_flags = fence->signaled;
+	arg->signaled_flags = arg->flags;
 	arg->passed_seqno = dev_priv->last_read_seqno;
 	spin_unlock_irq(&fman->lock);
 
@@ -908,7 +898,7 @@ static void vmw_fence_obj_add_action(struct vmw_fence_obj *fence,
 	spin_lock_irqsave(&fman->lock, irq_flags);
 
 	fman->pending_actions[action->type]++;
-	if (fence->signaled & DRM_VMW_FENCE_FLAG_EXEC) {
+	if (fence->signaled) {
 		struct list_head action_list;
 
 		INIT_LIST_HEAD(&action_list);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
index faf2e7873860..8c18d32bd1c3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
@@ -56,7 +56,6 @@ struct vmw_fence_obj {
 	struct vmw_fence_manager *fman;
 	struct list_head head;
 	uint32_t signaled;
-	uint32_t signal_mask;
 	struct list_head seq_passed_actions;
 	void (*destroy)(struct vmw_fence_obj *fence);
 	wait_queue_head_t queue;
@@ -74,10 +73,9 @@ vmw_fence_obj_reference(struct vmw_fence_obj *fence);
 
 extern void vmw_fences_update(struct vmw_fence_manager *fman);
 
-extern bool vmw_fence_obj_signaled(struct vmw_fence_obj *fence,
-				   uint32_t flags);
+extern bool vmw_fence_obj_signaled(struct vmw_fence_obj *fence);
 
-extern int vmw_fence_obj_wait(struct vmw_fence_obj *fence, uint32_t flags,
+extern int vmw_fence_obj_wait(struct vmw_fence_obj *fence,
 			      bool lazy,
 			      bool interruptible, unsigned long timeout);
 
@@ -85,13 +83,11 @@ extern void vmw_fence_obj_flush(struct vmw_fence_obj *fence);
 
 extern int vmw_fence_create(struct vmw_fence_manager *fman,
 			    uint32_t seqno,
-			    uint32_t mask,
 			    struct vmw_fence_obj **p_fence);
 
 extern int vmw_user_fence_create(struct drm_file *file_priv,
 				 struct vmw_fence_manager *fman,
 				 uint32_t sequence,
-				 uint32_t mask,
 				 struct vmw_fence_obj **p_fence,
 				 uint32_t *p_handle);
 

