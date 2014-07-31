Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaGaPed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:34:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56949 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGaPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:34:31 -0400
Subject: [PATCH 14/19] drm/vmwgfx: rework to new fence interface
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:34:14 +0200
Message-ID: <20140731153413.15061.31735.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c  |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c    |  299 ++++++++++++++++++------------
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.h    |   29 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    9 -
 4 files changed, 200 insertions(+), 139 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 214fcfd13cb2..0ceaddc8e4f7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2389,7 +2389,7 @@ vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 		BUG_ON(fence == NULL);
 
 		fence_rep.handle = fence_handle;
-		fence_rep.seqno = fence->seqno;
+		fence_rep.seqno = fence->base.seqno;
 		vmw_update_seqno(dev_priv, &dev_priv->fifo);
 		fence_rep.passed_seqno = dev_priv->last_read_seqno;
 	}
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 05b9eea8e875..77f416b7552c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -46,6 +46,7 @@ struct vmw_fence_manager {
 	bool goal_irq_on; /* Protected by @goal_irq_mutex */
 	bool seqno_valid; /* Protected by @lock, and may not be set to true
 			     without the @goal_irq_mutex held. */
+	unsigned ctx;
 };
 
 struct vmw_user_fence {
@@ -80,6 +81,12 @@ struct vmw_event_fence_action {
 	uint32_t *tv_usec;
 };
 
+static struct vmw_fence_manager *
+fman_from_fence(struct vmw_fence_obj *fence)
+{
+	return container_of(fence->base.lock, struct vmw_fence_manager, lock);
+}
+
 /**
  * Note on fencing subsystem usage of irqs:
  * Typically the vmw_fences_update function is called
@@ -102,25 +109,130 @@ struct vmw_event_fence_action {
  * objects with actions attached to them.
  */
 
-static void vmw_fence_obj_destroy_locked(struct kref *kref)
+static void vmw_fence_obj_destroy(struct fence *f)
 {
 	struct vmw_fence_obj *fence =
-		container_of(kref, struct vmw_fence_obj, kref);
+		container_of(f, struct vmw_fence_obj, base);
 
-	struct vmw_fence_manager *fman = fence->fman;
-	unsigned int num_fences;
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
+	unsigned long irq_flags;
 
+	spin_lock_irqsave(&fman->lock, irq_flags);
 	list_del_init(&fence->head);
-	num_fences = --fman->num_fence_objects;
-	spin_unlock_irq(&fman->lock);
-	if (fence->destroy)
-		fence->destroy(fence);
-	else
-		kfree(fence);
+	--fman->num_fence_objects;
+	spin_unlock_irqrestore(&fman->lock, irq_flags);
+	fence->destroy(fence);
+}
 
-	spin_lock_irq(&fman->lock);
+static const char *vmw_fence_get_driver_name(struct fence *f)
+{
+	return "vmwgfx";
+}
+
+static const char *vmw_fence_get_timeline_name(struct fence *f)
+{
+	return "svga";
+}
+
+static bool vmw_fence_enable_signaling(struct fence *f)
+{
+	struct vmw_fence_obj *fence =
+		container_of(f, struct vmw_fence_obj, base);
+
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
+
+	__le32 __iomem *fifo_mem = fman->dev_priv->mmio_virt;
+	u32 seqno = ioread32(fifo_mem + SVGA_FIFO_FENCE);
+	if (seqno - fence->base.seqno < VMW_FENCE_WRAP)
+		return false;
+
+	vmw_fifo_ping_host(fman->dev_priv, SVGA_SYNC_GENERIC);
+
+	return true;
+}
+
+struct vmwgfx_wait_cb {
+	struct fence_cb base;
+	struct task_struct *task;
+};
+
+static void
+vmwgfx_wait_cb(struct fence *fence, struct fence_cb *cb)
+{
+	struct vmwgfx_wait_cb *wait =
+		container_of(cb, struct vmwgfx_wait_cb, base);
+
+	wake_up_process(wait->task);
 }
 
+static void __vmw_fences_update(struct vmw_fence_manager *fman);
+
+static long vmw_fence_wait(struct fence *f, bool intr, signed long timeout)
+{
+	struct vmw_fence_obj *fence =
+		container_of(f, struct vmw_fence_obj, base);
+
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
+	struct vmw_private *dev_priv = fman->dev_priv;
+	struct vmwgfx_wait_cb cb;
+	long ret = timeout;
+	unsigned long irq_flags;
+
+	if (likely(vmw_fence_obj_signaled(fence)))
+		return timeout;
+
+	vmw_fifo_ping_host(dev_priv, SVGA_SYNC_GENERIC);
+	vmw_seqno_waiter_add(dev_priv);
+
+	spin_lock_irqsave(f->lock, irq_flags);
+
+	if (intr && signal_pending(current)) {
+		ret = -ERESTARTSYS;
+		goto out;
+	}
+
+	cb.base.func = vmwgfx_wait_cb;
+	cb.task = current;
+	list_add(&cb.base.node, &f->cb_list);
+
+	while (ret > 0) {
+		__vmw_fences_update(fman);
+		if (test_bit(FENCE_FLAG_SIGNALED_BIT, &f->flags))
+			break;
+
+		if (intr)
+			__set_current_state(TASK_INTERRUPTIBLE);
+		else
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock_irqrestore(f->lock, irq_flags);
+
+		ret = schedule_timeout(ret);
+
+		spin_lock_irqsave(f->lock, irq_flags);
+		if (ret > 0 && intr && signal_pending(current))
+			ret = -ERESTARTSYS;
+	}
+
+	if (!list_empty(&cb.base.node))
+		list_del(&cb.base.node);
+	__set_current_state(TASK_RUNNING);
+
+out:
+	spin_unlock_irqrestore(f->lock, irq_flags);
+
+	vmw_seqno_waiter_remove(dev_priv);
+
+	return ret;
+}
+
+static struct fence_ops vmw_fence_ops = {
+	.get_driver_name = vmw_fence_get_driver_name,
+	.get_timeline_name = vmw_fence_get_timeline_name,
+	.enable_signaling = vmw_fence_enable_signaling,
+	.wait = vmw_fence_wait,
+	.release = vmw_fence_obj_destroy,
+};
+
 
 /**
  * Execute signal actions on fences recently signaled.
@@ -186,6 +298,7 @@ struct vmw_fence_manager *vmw_fence_manager_init(struct vmw_private *dev_priv)
 	fman->event_fence_action_size =
 		ttm_round_pot(sizeof(struct vmw_event_fence_action));
 	mutex_init(&fman->goal_irq_mutex);
+	fman->ctx = fence_context_alloc(1);
 
 	return fman;
 }
@@ -211,16 +324,12 @@ static int vmw_fence_obj_init(struct vmw_fence_manager *fman,
 			      void (*destroy) (struct vmw_fence_obj *fence))
 {
 	unsigned long irq_flags;
-	unsigned int num_fences;
 	int ret = 0;
 
-	fence->seqno = seqno;
+	fence_init(&fence->base, &vmw_fence_ops, &fman->lock,
+		   fman->ctx, seqno);
 	INIT_LIST_HEAD(&fence->seq_passed_actions);
-	fence->fman = fman;
-	fence->signaled = 0;
-	kref_init(&fence->kref);
 	fence->destroy = destroy;
-	init_waitqueue_head(&fence->queue);
 
 	spin_lock_irqsave(&fman->lock, irq_flags);
 	if (unlikely(fman->fifo_down)) {
@@ -228,7 +337,7 @@ static int vmw_fence_obj_init(struct vmw_fence_manager *fman,
 		goto out_unlock;
 	}
 	list_add_tail(&fence->head, &fman->fence_list);
-	num_fences = ++fman->num_fence_objects;
+	++fman->num_fence_objects;
 
 out_unlock:
 	spin_unlock_irqrestore(&fman->lock, irq_flags);
@@ -236,38 +345,6 @@ out_unlock:
 
 }
 
-struct vmw_fence_obj *vmw_fence_obj_reference(struct vmw_fence_obj *fence)
-{
-	if (unlikely(fence == NULL))
-		return NULL;
-
-	kref_get(&fence->kref);
-	return fence;
-}
-
-/**
- * vmw_fence_obj_unreference
- *
- * Note that this function may not be entered with disabled irqs since
- * it may re-enable them in the destroy function.
- *
- */
-void vmw_fence_obj_unreference(struct vmw_fence_obj **fence_p)
-{
-	struct vmw_fence_obj *fence = *fence_p;
-	struct vmw_fence_manager *fman;
-
-	if (unlikely(fence == NULL))
-		return;
-
-	fman = fence->fman;
-	*fence_p = NULL;
-	spin_lock_irq(&fman->lock);
-	BUG_ON(atomic_read(&fence->kref.refcount) == 0);
-	kref_put(&fence->kref, vmw_fence_obj_destroy_locked);
-	spin_unlock_irq(&fman->lock);
-}
-
 static void vmw_fences_perform_actions(struct vmw_fence_manager *fman,
 				struct list_head *list)
 {
@@ -323,7 +400,7 @@ static bool vmw_fence_goal_new_locked(struct vmw_fence_manager *fman,
 	list_for_each_entry(fence, &fman->fence_list, head) {
 		if (!list_empty(&fence->seq_passed_actions)) {
 			fman->seqno_valid = true;
-			iowrite32(fence->seqno,
+			iowrite32(fence->base.seqno,
 				  fifo_mem + SVGA_FIFO_FENCE_GOAL);
 			break;
 		}
@@ -350,27 +427,27 @@ static bool vmw_fence_goal_new_locked(struct vmw_fence_manager *fman,
  */
 static bool vmw_fence_goal_check_locked(struct vmw_fence_obj *fence)
 {
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
 	u32 goal_seqno;
 	__le32 __iomem *fifo_mem;
 
-	if (fence->signaled)
+	if (fence_is_signaled_locked(&fence->base))
 		return false;
 
-	fifo_mem = fence->fman->dev_priv->mmio_virt;
+	fifo_mem = fman->dev_priv->mmio_virt;
 	goal_seqno = ioread32(fifo_mem + SVGA_FIFO_FENCE_GOAL);
-	if (likely(fence->fman->seqno_valid &&
-		   goal_seqno - fence->seqno < VMW_FENCE_WRAP))
+	if (likely(fman->seqno_valid &&
+		   goal_seqno - fence->base.seqno < VMW_FENCE_WRAP))
 		return false;
 
-	iowrite32(fence->seqno, fifo_mem + SVGA_FIFO_FENCE_GOAL);
-	fence->fman->seqno_valid = true;
+	iowrite32(fence->base.seqno, fifo_mem + SVGA_FIFO_FENCE_GOAL);
+	fman->seqno_valid = true;
 
 	return true;
 }
 
-void vmw_fences_update(struct vmw_fence_manager *fman)
+static void __vmw_fences_update(struct vmw_fence_manager *fman)
 {
-	unsigned long flags;
 	struct vmw_fence_obj *fence, *next_fence;
 	struct list_head action_list;
 	bool needs_rerun;
@@ -379,32 +456,25 @@ void vmw_fences_update(struct vmw_fence_manager *fman)
 
 	seqno = ioread32(fifo_mem + SVGA_FIFO_FENCE);
 rerun:
-	spin_lock_irqsave(&fman->lock, flags);
 	list_for_each_entry_safe(fence, next_fence, &fman->fence_list, head) {
-		if (seqno - fence->seqno < VMW_FENCE_WRAP) {
+		if (seqno - fence->base.seqno < VMW_FENCE_WRAP) {
 			list_del_init(&fence->head);
-			fence->signaled = 1;
+			fence_signal_locked(&fence->base);
 			INIT_LIST_HEAD(&action_list);
 			list_splice_init(&fence->seq_passed_actions,
 					 &action_list);
 			vmw_fences_perform_actions(fman, &action_list);
-			wake_up_all(&fence->queue);
 		} else
 			break;
 	}
 
-	needs_rerun = vmw_fence_goal_new_locked(fman, seqno);
-
-	if (!list_empty(&fman->cleanup_list))
-		(void) schedule_work(&fman->work);
-	spin_unlock_irqrestore(&fman->lock, flags);
-
 	/*
 	 * Rerun if the fence goal seqno was updated, and the
 	 * hardware might have raced with that update, so that
 	 * we missed a fence_goal irq.
 	 */
 
+	needs_rerun = vmw_fence_goal_new_locked(fman, seqno);
 	if (unlikely(needs_rerun)) {
 		new_seqno = ioread32(fifo_mem + SVGA_FIFO_FENCE);
 		if (new_seqno != seqno) {
@@ -412,75 +482,58 @@ rerun:
 			goto rerun;
 		}
 	}
+
+	if (!list_empty(&fman->cleanup_list))
+		(void) schedule_work(&fman->work);
 }
 
-bool vmw_fence_obj_signaled(struct vmw_fence_obj *fence)
+void vmw_fences_update(struct vmw_fence_manager *fman)
 {
-	struct vmw_fence_manager *fman = fence->fman;
 	unsigned long irq_flags;
-	uint32_t signaled;
 
 	spin_lock_irqsave(&fman->lock, irq_flags);
-	signaled = fence->signaled;
+	__vmw_fences_update(fman);
 	spin_unlock_irqrestore(&fman->lock, irq_flags);
+}
+
+bool vmw_fence_obj_signaled(struct vmw_fence_obj *fence)
+{
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
 
-	if (signaled)
+	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->base.flags))
 		return 1;
 
 	vmw_fences_update(fman);
 
-	spin_lock_irqsave(&fman->lock, irq_flags);
-	signaled = fence->signaled;
-	spin_unlock_irqrestore(&fman->lock, irq_flags);
-
-	return signaled;
+	return fence_is_signaled(&fence->base);
 }
 
 int vmw_fence_obj_wait(struct vmw_fence_obj *fence, bool lazy,
 		       bool interruptible, unsigned long timeout)
 {
-	struct vmw_private *dev_priv = fence->fman->dev_priv;
-	long ret;
+	long ret = fence_wait_timeout(&fence->base, interruptible, timeout);
 
-	if (likely(vmw_fence_obj_signaled(fence)))
+	if (likely(ret > 0))
 		return 0;
-
-	vmw_fifo_ping_host(dev_priv, SVGA_SYNC_GENERIC);
-	vmw_seqno_waiter_add(dev_priv);
-
-	if (interruptible)
-		ret = wait_event_interruptible_timeout
-			(fence->queue,
-			 vmw_fence_obj_signaled(fence),
-			 timeout);
+	else if (ret == 0)
+		return -EBUSY;
 	else
-		ret = wait_event_timeout
-			(fence->queue,
-			 vmw_fence_obj_signaled(fence),
-			 timeout);
-
-	vmw_seqno_waiter_remove(dev_priv);
-
-	if (unlikely(ret == 0))
-		ret = -EBUSY;
-	else if (likely(ret > 0))
-		ret = 0;
-
-	return ret;
+		return ret;
 }
 
 void vmw_fence_obj_flush(struct vmw_fence_obj *fence)
 {
-	struct vmw_private *dev_priv = fence->fman->dev_priv;
+	struct vmw_private *dev_priv = fman_from_fence(fence)->dev_priv;
 
 	vmw_fifo_ping_host(dev_priv, SVGA_SYNC_GENERIC);
 }
 
 static void vmw_fence_destroy(struct vmw_fence_obj *fence)
 {
-	struct vmw_fence_manager *fman = fence->fman;
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
+
+	fence_free(&fence->base);
 
-	kfree(fence);
 	/*
 	 * Free kernel space accounting.
 	 */
@@ -527,7 +580,7 @@ static void vmw_user_fence_destroy(struct vmw_fence_obj *fence)
 {
 	struct vmw_user_fence *ufence =
 		container_of(fence, struct vmw_user_fence, fence);
-	struct vmw_fence_manager *fman = fence->fman;
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
 
 	ttm_base_object_kfree(ufence, base);
 	/*
@@ -620,7 +673,6 @@ out_no_object:
 
 void vmw_fence_fifo_down(struct vmw_fence_manager *fman)
 {
-	unsigned long irq_flags;
 	struct list_head action_list;
 	int ret;
 
@@ -629,13 +681,13 @@ void vmw_fence_fifo_down(struct vmw_fence_manager *fman)
 	 * restart when we've released the fman->lock.
 	 */
 
-	spin_lock_irqsave(&fman->lock, irq_flags);
+	spin_lock_irq(&fman->lock);
 	fman->fifo_down = true;
 	while (!list_empty(&fman->fence_list)) {
 		struct vmw_fence_obj *fence =
 			list_entry(fman->fence_list.prev, struct vmw_fence_obj,
 				   head);
-		kref_get(&fence->kref);
+		fence_get(&fence->base);
 		spin_unlock_irq(&fman->lock);
 
 		ret = vmw_fence_obj_wait(fence, false, false,
@@ -643,20 +695,18 @@ void vmw_fence_fifo_down(struct vmw_fence_manager *fman)
 
 		if (unlikely(ret != 0)) {
 			list_del_init(&fence->head);
-			fence->signaled = 1;
+			fence_signal(&fence->base);
 			INIT_LIST_HEAD(&action_list);
 			list_splice_init(&fence->seq_passed_actions,
 					 &action_list);
 			vmw_fences_perform_actions(fman, &action_list);
-			wake_up_all(&fence->queue);
 		}
 
-		spin_lock_irq(&fman->lock);
-
 		BUG_ON(!list_empty(&fence->head));
-		kref_put(&fence->kref, vmw_fence_obj_destroy_locked);
+		fence_put(&fence->base);
+		spin_lock_irq(&fman->lock);
 	}
-	spin_unlock_irqrestore(&fman->lock, irq_flags);
+	spin_unlock_irq(&fman->lock);
 }
 
 void vmw_fence_fifo_up(struct vmw_fence_manager *fman)
@@ -748,12 +798,12 @@ int vmw_fence_obj_signaled_ioctl(struct drm_device *dev, void *data,
 	}
 
 	fence = &(container_of(base, struct vmw_user_fence, base)->fence);
-	fman = fence->fman;
+	fman = fman_from_fence(fence);
 
 	arg->signaled = vmw_fence_obj_signaled(fence);
-	spin_lock_irq(&fman->lock);
 
 	arg->signaled_flags = arg->flags;
+	spin_lock_irq(&fman->lock);
 	arg->passed_seqno = dev_priv->last_read_seqno;
 	spin_unlock_irq(&fman->lock);
 
@@ -866,7 +916,7 @@ static void vmw_event_fence_action_cleanup(struct vmw_fence_action *action)
 {
 	struct vmw_event_fence_action *eaction =
 		container_of(action, struct vmw_event_fence_action, action);
-	struct vmw_fence_manager *fman = eaction->fence->fman;
+	struct vmw_fence_manager *fman = fman_from_fence(eaction->fence);
 	unsigned long irq_flags;
 
 	spin_lock_irqsave(&fman->lock, irq_flags);
@@ -890,7 +940,7 @@ static void vmw_event_fence_action_cleanup(struct vmw_fence_action *action)
 static void vmw_fence_obj_add_action(struct vmw_fence_obj *fence,
 			      struct vmw_fence_action *action)
 {
-	struct vmw_fence_manager *fman = fence->fman;
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
 	unsigned long irq_flags;
 	bool run_update = false;
 
@@ -898,7 +948,7 @@ static void vmw_fence_obj_add_action(struct vmw_fence_obj *fence,
 	spin_lock_irqsave(&fman->lock, irq_flags);
 
 	fman->pending_actions[action->type]++;
-	if (fence->signaled) {
+	if (fence_is_signaled_locked(&fence->base)) {
 		struct list_head action_list;
 
 		INIT_LIST_HEAD(&action_list);
@@ -950,7 +1000,7 @@ int vmw_event_fence_action_queue(struct drm_file *file_priv,
 				 bool interruptible)
 {
 	struct vmw_event_fence_action *eaction;
-	struct vmw_fence_manager *fman = fence->fman;
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
 	struct vmw_fpriv *vmw_fp = vmw_fpriv(file_priv);
 	unsigned long irq_flags;
 
@@ -990,7 +1040,8 @@ static int vmw_event_fence_action_create(struct drm_file *file_priv,
 				  bool interruptible)
 {
 	struct vmw_event_fence_pending *event;
-	struct drm_device *dev = fence->fman->dev_priv->dev;
+	struct vmw_fence_manager *fman = fman_from_fence(fence);
+	struct drm_device *dev = fman->dev_priv->dev;
 	unsigned long irq_flags;
 	int ret;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
index 8c18d32bd1c3..26a4add39208 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
@@ -27,6 +27,8 @@
 
 #ifndef _VMWGFX_FENCE_H_
 
+#include <linux/fence.h>
+
 #define VMW_FENCE_WAIT_TIMEOUT (5*HZ)
 
 struct vmw_private;
@@ -50,15 +52,11 @@ struct vmw_fence_action {
 };
 
 struct vmw_fence_obj {
-	struct kref kref;
-	u32 seqno;
+	struct fence base;
 
-	struct vmw_fence_manager *fman;
 	struct list_head head;
-	uint32_t signaled;
 	struct list_head seq_passed_actions;
 	void (*destroy)(struct vmw_fence_obj *fence);
-	wait_queue_head_t queue;
 };
 
 extern struct vmw_fence_manager *
@@ -66,10 +64,23 @@ vmw_fence_manager_init(struct vmw_private *dev_priv);
 
 extern void vmw_fence_manager_takedown(struct vmw_fence_manager *fman);
 
-extern void vmw_fence_obj_unreference(struct vmw_fence_obj **fence_p);
-
-extern struct vmw_fence_obj *
-vmw_fence_obj_reference(struct vmw_fence_obj *fence);
+static inline void
+vmw_fence_obj_unreference(struct vmw_fence_obj **fence_p)
+{
+	struct vmw_fence_obj *fence = *fence_p;
+
+	*fence_p = NULL;
+	if (fence)
+		fence_put(&fence->base);
+}
+
+static inline struct vmw_fence_obj *
+vmw_fence_obj_reference(struct vmw_fence_obj *fence)
+{
+	if (fence)
+		fence_get(&fence->base);
+	return fence;
+}
 
 extern void vmw_fences_update(struct vmw_fence_manager *fman);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 936777e469bb..294a0a3e48cb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -1419,21 +1419,20 @@ void vmw_fence_single_bo(struct ttm_buffer_object *bo,
 			 struct vmw_fence_obj *fence)
 {
 	struct ttm_bo_device *bdev = bo->bdev;
-	struct ttm_bo_driver *driver = bdev->driver;
 	struct vmw_fence_obj *old_fence_obj;
 	struct vmw_private *dev_priv =
 		container_of(bdev, struct vmw_private, bdev);
 
-	if (fence == NULL)
+	if (fence == NULL) {
 		vmw_execbuf_fence_commands(NULL, dev_priv, &fence, NULL);
-	else
-		driver->sync_obj_ref(fence);
+	} else
+		vmw_fence_obj_reference(fence);
 
+	reservation_object_add_excl_fence(bo->resv, &fence->base);
 
 	old_fence_obj = bo->sync_obj;
 	bo->sync_obj = fence;
 
-
 	if (old_fence_obj)
 		vmw_fence_obj_unreference(&old_fence_obj);
 }

