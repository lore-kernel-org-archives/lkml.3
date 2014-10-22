Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaJVP36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:29:58 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61382 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaJVP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:29:55 -0400
From: Robert Bragg <robert@sixbynine.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Robert Bragg <robert@sixbynine.org>
Subject: [RFC PATCH 3/3] i915: Expose PMU for Observation Architecture
Date: Wed, 22 Oct 2014 16:28:51 +0100
Message-Id: <1413991731-20628-4-git-send-email-robert@sixbynine.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gen graphics hardware can be set up to periodically write snapshots of
performance counters into a circular buffer and this patch exposes that
capability to userspace via the perf interface.

Only Haswell is supported currently.

Signed-off-by: Robert Bragg <robert@sixbynine.org>
---
 drivers/gpu/drm/i915/Makefile       |   1 +
 drivers/gpu/drm/i915/i915_dma.c     |   2 +
 drivers/gpu/drm/i915/i915_drv.h     |  33 ++
 drivers/gpu/drm/i915/i915_oa_perf.c | 675 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h     |  87 +++++
 include/uapi/drm/i915_drm.h         |  21 ++
 6 files changed, 819 insertions(+)
 create mode 100644 drivers/gpu/drm/i915/i915_oa_perf.c

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index c1dd485..2ddd97d 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -14,6 +14,7 @@ i915-y := i915_drv.o \
 	  intel_pm.o
 i915-$(CONFIG_COMPAT)   += i915_ioc32.o
 i915-$(CONFIG_DEBUG_FS) += i915_debugfs.o
+i915-$(CONFIG_PERF_EVENTS) += i915_oa_perf.o
 
 # GEM code
 i915-y += i915_cmd_parser.o \
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 3f676f9..ce1e1ea 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1792,6 +1792,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 		intel_gpu_ips_init(dev_priv);
 
 	intel_init_runtime_pm(dev_priv);
+	i915_oa_pmu_register(dev);
 
 	return 0;
 
@@ -1839,6 +1840,7 @@ int i915_driver_unload(struct drm_device *dev)
 		return ret;
 	}
 
+	i915_oa_pmu_unregister(dev);
 	intel_fini_runtime_pm(dev_priv);
 
 	intel_gpu_ips_teardown();
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 6fbd316..1b2c557 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -45,6 +45,7 @@
 #include <linux/hashtable.h>
 #include <linux/intel-iommu.h>
 #include <linux/kref.h>
+#include <linux/perf_event.h>
 #include <linux/pm_qos.h>
 
 /* General customization:
@@ -1636,6 +1637,29 @@ struct drm_i915_private {
 	 */
 	struct workqueue_struct *dp_wq;
 
+#ifdef CONFIG_PERF_EVENTS
+	struct {
+	    struct pmu pmu;
+	    spinlock_t lock;
+	    struct hrtimer timer;
+	    struct pt_regs dummy_regs;
+
+	    struct perf_event *exclusive_event;
+	    struct intel_context *specific_ctx;
+
+	    struct {
+		struct kref refcount;
+		struct drm_i915_gem_object *obj;
+		u32 gtt_offset;
+		u8 *addr;
+		u32 head;
+		u32 tail;
+		int format;
+		int format_size;
+	    } oa_buffer;
+	} oa_pmu;
+#endif
+
 	/* Old dri1 support infrastructure, beware the dragons ya fools entering
 	 * here! */
 	struct i915_dri1_state dri1;
@@ -2688,6 +2712,15 @@ int i915_parse_cmds(struct intel_engine_cs *ring,
 		    u32 batch_start_offset,
 		    bool is_master);
 
+/* i915_oa_perf.c */
+#ifdef CONFIG_PERF_EVENTS
+extern void i915_oa_pmu_register(struct drm_device *dev);
+extern void i915_oa_pmu_unregister(struct drm_device *dev);
+#else
+static inline void i915_oa_pmu_register(struct drm_device *dev) {}
+static inline void i915_oa_pmu_unregister(struct drm_device *dev) {}
+#endif
+
 /* i915_suspend.c */
 extern int i915_save_state(struct drm_device *dev);
 extern int i915_restore_state(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/i915_oa_perf.c b/drivers/gpu/drm/i915/i915_oa_perf.c
new file mode 100644
index 0000000..d86aaf0
--- /dev/null
+++ b/drivers/gpu/drm/i915/i915_oa_perf.c
@@ -0,0 +1,675 @@
+#include <linux/perf_event.h>
+#include <linux/sizes.h>
+
+#include "i915_drv.h"
+#include "intel_ringbuffer.h"
+
+/* Must be a power of two */
+#define OA_BUFFER_SIZE	     SZ_16M
+#define OA_TAKEN(tail, head) ((tail - head) & (OA_BUFFER_SIZE - 1))
+
+#define FREQUENCY 200
+#define PERIOD max_t(u64, 10000, NSEC_PER_SEC / FREQUENCY)
+
+static int hsw_perf_format_sizes[] = {
+	64,  /* A13_HSW */
+	128, /* A29_HSW */
+	128, /* A13_B8_C8_HSW */
+
+	/* XXX: If we were to disallow this format we could avoid needing to
+	 * handle snapshots being split in two when they don't factor into
+	 * the buffer size... */
+	192, /* A29_B8_C8_HSW */
+	64,  /* B4_C8_HSW */
+	256, /* A45_B8_C8_HSW */
+	128, /* B4_C8_A16_HSW */
+	64   /* C4_B8_HSW */
+};
+
+static void forward_one_oa_snapshot_to_event(struct drm_i915_private *dev_priv,
+					     u8 *snapshot,
+					     struct perf_event *event)
+{
+	struct perf_sample_data data;
+	int snapshot_size = dev_priv->oa_pmu.oa_buffer.format_size;
+	struct perf_raw_record raw;
+
+	perf_sample_data_init(&data, 0, event->hw.last_period);
+
+	/* XXX: It seems strange that kernel/events/core.c only initialises
+	 * data->type if event->attr.sample_id_all is set
+	 *
+	 * For now, we explicitly set this otherwise perf_event_overflow()
+	 * may reference an uninitialised sample_type and may not actually
+	 * forward our raw data.
+	 */
+	data.type = event->attr.sample_type;
+
+	/* Note: the 32 bit size + raw data must be 8 byte aligned.
+	 *
+	 * So that we don't have to first copy the data out of the
+	 * OABUFFER, we instead allow an overrun and forward the 32 bit
+	 * report id of the next snapshot...
+	 */
+	raw.size = snapshot_size + 4;
+	raw.data = snapshot;
+
+	data.raw = &raw;
+
+	perf_event_overflow(event, &data, &dev_priv->oa_pmu.dummy_regs);
+}
+
+static u32 forward_oa_snapshots(struct drm_i915_private *dev_priv,
+				u32 head,
+				u32 tail)
+{
+	struct perf_event *exclusive_event = dev_priv->oa_pmu.exclusive_event;
+	int snapshot_size = dev_priv->oa_pmu.oa_buffer.format_size;
+	u8 *oa_buf_base = dev_priv->oa_pmu.oa_buffer.addr;
+	u32 mask = (OA_BUFFER_SIZE - 1);
+	u8 scratch[snapshot_size + 4];
+	u8 *snapshot;
+	u32 taken;
+
+	head -= dev_priv->oa_pmu.oa_buffer.gtt_offset;
+	tail -= dev_priv->oa_pmu.oa_buffer.gtt_offset;
+
+	/* Note: the gpu doesn't wrap the tail according to the OA buffer size
+	 * so when we need to make sure our head/tail values are in-bounds we
+	 * use the above mask.
+	 */
+
+	while ((taken = OA_TAKEN(tail, head))) {
+		u32 before;
+
+		/* The tail increases in 64 byte increments, not in
+		 * format_size steps. */
+		if (taken < snapshot_size)
+			break;
+
+		/* As well as handling snapshots that are split in two we also
+		 * need to pad snapshots at the end of the oabuffer so that
+		 * forward_one_oa_snapshot_to_event() can safely overrun by 4
+		 * bytes for alignment. */
+		before = OA_BUFFER_SIZE - (head & mask);
+		if (before <= snapshot_size) {
+			u32 after = snapshot_size - before;
+
+			memcpy(scratch, oa_buf_base + (head & mask), before);
+			if (after)
+				memcpy(scratch + before, oa_buf_base, after);
+			snapshot = scratch;
+		} else
+			snapshot = oa_buf_base + (head & mask);
+
+		head += snapshot_size;
+
+		/* We currently only allow exclusive access to the counters
+		 * so only have one event to forward too... */
+		if (exclusive_event->state == PERF_EVENT_STATE_ACTIVE)
+			forward_one_oa_snapshot_to_event(dev_priv, snapshot,
+							 exclusive_event);
+	}
+
+	return dev_priv->oa_pmu.oa_buffer.gtt_offset + head;
+}
+
+static void flush_oa_snapshots(struct drm_i915_private *dev_priv,
+			       bool force_wake)
+{
+	unsigned long flags;
+	u32 oastatus2;
+	u32 oastatus1;
+	u32 head;
+	u32 tail;
+
+	/* Can either flush via hrtimer callback or pmu methods/fops */
+	if (!force_wake) {
+
+		/* If the hrtimer triggers at the same time that we are
+		 * responding to a userspace initiated flush then we can
+		 * just bail out...
+		 *
+		 * FIXME: strictly this lock doesn't imply we are already
+		 * flushing though it shouldn't really be a problem to skip
+		 * the odd hrtimer flush anyway.
+		 */
+		if (!spin_trylock_irqsave(&dev_priv->oa_pmu.lock, flags))
+			return;
+	} else
+		spin_lock_irqsave(&dev_priv->oa_pmu.lock, flags);
+
+	WARN_ON(!dev_priv->oa_pmu.oa_buffer.addr);
+
+	oastatus2 = I915_READ(OASTATUS2);
+	oastatus1 = I915_READ(OASTATUS1);
+
+	head = oastatus2 & OASTATUS2_HEAD_MASK;
+	tail = oastatus1 & OASTATUS1_TAIL_MASK;
+
+	if (oastatus1 & (OASTATUS1_OABUFFER_OVERFLOW |
+			 OASTATUS1_REPORT_LOST)) {
+
+		/* XXX: How can we convey report-lost errors to userspace?  It
+		 * doesn't look like perf's _REPORT_LOST mechanism is
+		 * appropriate in this case; that's just for cases where we
+		 * run out of space for samples in the perf circular buffer.
+		 *
+		 * Maybe we can claim a special report-id and use that to
+		 * forward status flags?
+		 */
+		pr_debug("OA buffer read error: addr = %p, head = %u, offset = %u, tail = %u cnt o'flow = %d, buf o'flow = %d, rpt lost = %d\n",
+			 dev_priv->oa_pmu.oa_buffer.addr,
+			 head,
+			 head - dev_priv->oa_pmu.oa_buffer.gtt_offset,
+			 tail,
+			 oastatus1 & OASTATUS1_COUNTER_OVERFLOW ? 1 : 0,
+			 oastatus1 & OASTATUS1_OABUFFER_OVERFLOW ? 1 : 0,
+			 oastatus1 & OASTATUS1_REPORT_LOST ? 1 : 0);
+
+		I915_WRITE(OASTATUS1, oastatus1 &
+			   ~(OASTATUS1_OABUFFER_OVERFLOW |
+			     OASTATUS1_REPORT_LOST));
+	}
+
+	head = forward_oa_snapshots(dev_priv, head, tail);
+
+	I915_WRITE(OASTATUS2, (head & OASTATUS2_HEAD_MASK) | OASTATUS2_GGTT);
+
+	spin_unlock_irqrestore(&dev_priv->oa_pmu.lock, flags);
+}
+
+static void
+oa_buffer_free(struct kref *kref)
+{
+	struct drm_i915_private *i915 =
+		container_of(kref, typeof(*i915), oa_pmu.oa_buffer.refcount);
+
+	BUG_ON(!mutex_is_locked(&i915->dev->struct_mutex));
+
+	vunmap(i915->oa_pmu.oa_buffer.addr);
+	i915_gem_object_ggtt_unpin(i915->oa_pmu.oa_buffer.obj);
+	drm_gem_object_unreference(&i915->oa_pmu.oa_buffer.obj->base);
+
+	i915->oa_pmu.oa_buffer.obj = NULL;
+	i915->oa_pmu.oa_buffer.gtt_offset = 0;
+	i915->oa_pmu.oa_buffer.addr = NULL;
+}
+
+static inline void oa_buffer_reference(struct drm_i915_private *i915)
+{
+	kref_get(&i915->oa_pmu.oa_buffer.refcount);
+}
+
+static void oa_buffer_unreference(struct drm_i915_private *i915)
+{
+	WARN_ON(!i915->oa_pmu.oa_buffer.obj);
+
+	kref_put(&i915->oa_pmu.oa_buffer.refcount, oa_buffer_free);
+}
+
+static void i915_oa_event_destroy(struct perf_event *event)
+{
+	struct drm_i915_private *i915 =
+		container_of(event->pmu, typeof(*i915), oa_pmu.pmu);
+
+	WARN_ON(event->parent);
+
+	mutex_lock(&i915->dev->struct_mutex);
+
+	oa_buffer_unreference(i915);
+
+	if (i915->oa_pmu.specific_ctx) {
+		struct drm_i915_gem_object *obj;
+
+		obj = i915->oa_pmu.specific_ctx->legacy_hw_ctx.rcs_state;
+		if (i915_gem_obj_is_pinned(obj))
+			i915_gem_object_ggtt_unpin(obj);
+		i915->oa_pmu.specific_ctx = NULL;
+	}
+
+	BUG_ON(i915->oa_pmu.exclusive_event != event);
+	i915->oa_pmu.exclusive_event = NULL;
+
+	mutex_unlock(&i915->dev->struct_mutex);
+
+	gen6_gt_force_wake_put(i915, FORCEWAKE_ALL);
+}
+
+static void *vmap_oa_buffer(struct drm_i915_gem_object *obj)
+{
+	int i;
+	void *addr = NULL;
+	struct sg_page_iter sg_iter;
+	struct page **pages;
+
+	pages = drm_malloc_ab(obj->base.size >> PAGE_SHIFT, sizeof(*pages));
+	if (pages == NULL) {
+		DRM_DEBUG_DRIVER("Failed to get space for pages\n");
+		goto finish;
+	}
+
+	i = 0;
+	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents, 0) {
+		pages[i] = sg_page_iter_page(&sg_iter);
+		i++;
+	}
+
+	addr = vmap(pages, i, 0, PAGE_KERNEL);
+	if (addr == NULL) {
+		DRM_DEBUG_DRIVER("Failed to vmap pages\n");
+		goto finish;
+	}
+
+finish:
+	if (pages)
+		drm_free_large(pages);
+	return addr;
+}
+
+static int init_oa_buffer(struct perf_event *event)
+{
+	struct drm_i915_private *dev_priv =
+		container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
+	struct drm_i915_gem_object *bo;
+	int ret;
+
+	BUG_ON(!IS_HASWELL(dev_priv->dev));
+	BUG_ON(!mutex_is_locked(&dev_priv->dev->struct_mutex));
+	BUG_ON(dev_priv->oa_pmu.oa_buffer.obj);
+
+	kref_init(&dev_priv->oa_pmu.oa_buffer.refcount);
+
+	bo = i915_gem_alloc_object(dev_priv->dev, OA_BUFFER_SIZE);
+	if (bo == NULL) {
+		DRM_ERROR("Failed to allocate OA buffer\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	dev_priv->oa_pmu.oa_buffer.obj = bo;
+
+	ret = i915_gem_object_set_cache_level(bo, I915_CACHE_LLC);
+	if (ret)
+		goto err_unref;
+
+	/* PreHSW required 512K alignment, HSW requires 16M */
+	ret = i915_gem_obj_ggtt_pin(bo, SZ_16M, 0);
+	if (ret)
+		goto err_unref;
+
+	dev_priv->oa_pmu.oa_buffer.gtt_offset = i915_gem_obj_ggtt_offset(bo);
+	dev_priv->oa_pmu.oa_buffer.addr = vmap_oa_buffer(bo);
+
+	/* Pre-DevBDW: OABUFFER must be set with counters off,
+	 * before OASTATUS1, but after OASTATUS2 */
+	I915_WRITE(OASTATUS2, dev_priv->oa_pmu.oa_buffer.gtt_offset |
+		   OASTATUS2_GGTT); /* head */
+	I915_WRITE(GEN7_OABUFFER, dev_priv->oa_pmu.oa_buffer.gtt_offset);
+	I915_WRITE(OASTATUS1, dev_priv->oa_pmu.oa_buffer.gtt_offset |
+		   OASTATUS1_OABUFFER_SIZE_16M); /* tail */
+
+	DRM_DEBUG_DRIVER("OA Buffer initialized, gtt offset = 0x%x, vaddr = %p",
+			 dev_priv->oa_pmu.oa_buffer.gtt_offset,
+			 dev_priv->oa_pmu.oa_buffer.addr);
+
+	return 0;
+
+err_unref:
+	drm_gem_object_unreference_unlocked(&bo->base);
+err:
+	return ret;
+}
+
+static enum hrtimer_restart hrtimer_sample(struct hrtimer *hrtimer)
+{
+	struct drm_i915_private *i915 =
+		container_of(hrtimer, typeof(*i915), oa_pmu.timer);
+
+	flush_oa_snapshots(i915, false);
+
+	hrtimer_forward_now(hrtimer, ns_to_ktime(PERIOD));
+	return HRTIMER_RESTART;
+}
+
+static struct intel_context *
+lookup_context(struct drm_i915_private *dev_priv,
+	       struct file *user_filp,
+	       u32 ctx_user_handle)
+{
+	struct intel_context *ctx;
+
+	mutex_lock(&dev_priv->dev->struct_mutex);
+	list_for_each_entry(ctx, &dev_priv->context_list, link) {
+		struct drm_file *drm_file;
+
+		if (!ctx->file_priv)
+			continue;
+
+		drm_file = ctx->file_priv->file;
+
+		if (user_filp->private_data == drm_file &&
+		    ctx->user_handle == ctx_user_handle) {
+			mutex_unlock(&dev_priv->dev->struct_mutex);
+			return ctx;
+		}
+	}
+	mutex_unlock(&dev_priv->dev->struct_mutex);
+
+	return NULL;
+}
+
+static int i915_oa_event_init(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	struct drm_i915_private *dev_priv =
+		container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
+	int ret = 0;
+
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	/* When tracing a specific pid events/core will enable/disable
+	 * the event only while that pid is running on a cpu but that
+	 * doesn't really make sense here. */
+	if (ctx) {
+		if (ctx->task)
+			return -EINVAL;
+	}
+#if 0
+	else
+	    pr_err("Unexpected NULL perf_event_context\n");
+
+	 /* XXX: it looks like we get a NULL ctx, so check if setting
+	  * pmu->task_ctx_nr to perf_invalid_context in _pmu_register
+	  * implies events/core.c will also implicitly disallow
+	  * associating a perf_oa event with a task?
+	  */
+#endif
+
+	/* To avoid the complexity of having to accurately filter
+	 * counter snapshots and marshal to the appropriate client
+	 * we currently only allow exclusive access */
+	if (dev_priv->oa_pmu.oa_buffer.obj)
+		return -EBUSY;
+
+	/* TODO: improve cooperation with the cmd_parser which provides
+	 * another mechanism for enabling the OA counters. */
+	if (I915_READ(OACONTROL) & OACONTROL_ENABLE)
+		return -EBUSY;
+
+	/* Since we are limited to an exponential scale for
+	 * programming the OA sampling period we don't allow userspace
+	 * to pass a precise attr.sample_period. */
+	if (event->attr.freq ||
+	    (event->attr.sample_period != 0 &&
+	     event->attr.sample_period != 1))
+		return -EINVAL;
+
+	/* Instead of allowing userspace to configure the period via
+	 * attr.sample_period we instead accept an exponent whereby
+	 * the sample_period will be:
+	 *
+	 *   80ns * 2^(period_exponent + 1)
+	 *
+	 * Programming a period of 160 nanoseconds would not be very
+	 * polite, so higher frequencies are reserved for root.
+	 */
+	if (event->attr.sample_period) {
+		u64 period_exponent =
+			event->attr.config & I915_PERF_OA_TIMER_EXPONENT_MASK;
+		period_exponent >>= I915_PERF_OA_TIMER_EXPONENT_SHIFT;
+
+		if (period_exponent < 15 && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
+	}
+
+	if (!IS_HASWELL(dev_priv->dev))
+		return -ENODEV;
+
+	/* We bypass the default perf core perf_paranoid_cpu() ||
+	 * CAP_SYS_ADMIN check by using the PERF_PMU_CAP_IS_DEVICE
+	 * flag and instead authenticate based on whether the current
+	 * pid owns the specified context, or require CAP_SYS_ADMIN
+	 * when collecting cross-context metrics.
+	 */
+	dev_priv->oa_pmu.specific_ctx = NULL;
+	if (event->attr.config & I915_PERF_OA_SINGLE_CONTEXT_ENABLE) {
+		u32 ctx_id = event->attr.config & I915_PERF_OA_CTX_ID_MASK;
+		unsigned int drm_fd = event->attr.config1;
+		struct fd fd = fdget(drm_fd);
+
+		if (fd.file) {
+			dev_priv->oa_pmu.specific_ctx =
+				lookup_context(dev_priv, fd.file, ctx_id);
+		}
+	}
+
+	if (!dev_priv->oa_pmu.specific_ctx && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	mutex_lock(&dev_priv->dev->struct_mutex);
+
+	/* XXX: Not sure that this is really acceptable...
+	 *
+	 * i915_gem_context.c currently owns pinning/unpinning legacy
+	 * context buffers and although that code has a
+	 * get_context_alignment() func to handle a different
+	 * constraint for gen6 we are assuming it's fixed for gen7
+	 * here. Another option besides pinning here would be to
+	 * instead hook into context switching and update the
+	 * OACONTROL configuration on the fly.
+	 */
+	if (dev_priv->oa_pmu.specific_ctx) {
+		struct intel_context *ctx = dev_priv->oa_pmu.specific_ctx;
+		int ret;
+
+		ret = i915_gem_obj_ggtt_pin(ctx->legacy_hw_ctx.rcs_state,
+					    4096, 0);
+		if (ret) {
+			DRM_DEBUG_DRIVER("Couldn't pin %d\n", ret);
+			ret = -EBUSY;
+			goto err;
+		}
+	}
+
+	if (!dev_priv->oa_pmu.oa_buffer.obj)
+		ret = init_oa_buffer(event);
+	else
+		oa_buffer_reference(dev_priv);
+
+	if (ret)
+		goto err;
+
+	BUG_ON(dev_priv->oa_pmu.exclusive_event);
+	dev_priv->oa_pmu.exclusive_event = event;
+
+	event->destroy = i915_oa_event_destroy;
+
+	mutex_unlock(&dev_priv->dev->struct_mutex);
+
+	/* PRM - observability performance counters:
+	 *
+	 *   OACONTROL, performance counter enable, note:
+	 *
+	 *   "When this bit is set, in order to have coherent counts,
+	 *   RC6 power state and trunk clock gating must be disabled.
+	 *   This can be achieved by programming MMIO registers as
+	 *   0xA094=0 and 0xA090[31]=1"
+	 *
+	 *   0xA094 corresponds to GEN6_RC_STATE
+	 *   0xA090[31] corresponds to GEN6_RC_CONTROL, GEN6_RC_CTL_HW_ENABLE
+	 */
+	/* XXX: We should probably find a more refined way of disabling RC6
+	 * in cooperation with intel_pm.c.
+	 * TODO: Find a way to disable clock gating too
+	 */
+	gen6_gt_force_wake_get(dev_priv, FORCEWAKE_ALL);
+
+	return 0;
+
+err:
+	mutex_unlock(&dev_priv->dev->struct_mutex);
+
+	return ret;
+}
+
+static void i915_oa_event_start(struct perf_event *event, int flags)
+{
+	struct drm_i915_private *dev_priv =
+		container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
+	u64 report_format;
+	int snapshot_size;
+	unsigned long ctx_id;
+	u64 period_exponent;
+
+	/* PRM - observability performance counters:
+	 *
+	 *   OACONTROL, specific context enable:
+	 *
+	 *   "OA unit level clock gating must be ENABLED when using
+	 *   specific ContextID feature."
+	 *
+	 * Assuming we don't ever disable OA unit level clock gating
+	 * lets just assert that this condition is met...
+	 */
+	WARN_ONCE(I915_READ(GEN6_UCGCTL3) & GEN6_OACSUNIT_CLOCK_GATE_DISABLE,
+		  "disabled OA unit level clock gating will result in incorrect per-context OA counters");
+
+	/* XXX: On Haswell, when threshold disable mode is desired,
+	 * instead of setting the threshold enable to '0', we need to
+	 * program it to '1' and set OASTARTTRIG1 bits 15:0 to 0
+	 * (threshold value of 0)
+	 */
+	I915_WRITE(OASTARTTRIG6, (OASTARTTRIG6_B4_TO_B7_THRESHOLD_ENABLE |
+				  OASTARTTRIG6_B4_CUSTOM_EVENT_ENABLE));
+	I915_WRITE(OASTARTTRIG5, 0); /* threshold value */
+
+	I915_WRITE(OASTARTTRIG2, (OASTARTTRIG2_B0_TO_B3_THRESHOLD_ENABLE |
+				  OASTARTTRIG2_B0_CUSTOM_EVENT_ENABLE));
+	I915_WRITE(OASTARTTRIG1, 0); /* threshold value */
+
+	/* Setup B0 as the gpu clock counter... */
+	I915_WRITE(OACEC0_0, OACEC0_0_B0_COMPARE_GREATER_OR_EQUAL); /* to 0 */
+	I915_WRITE(OACEC0_1, 0xfffe); /* Select NOA[0] */
+
+	period_exponent = event->attr.config & I915_PERF_OA_TIMER_EXPONENT_MASK;
+	period_exponent >>= I915_PERF_OA_TIMER_EXPONENT_SHIFT;
+
+	if (dev_priv->oa_pmu.specific_ctx) {
+		struct intel_context *ctx = dev_priv->oa_pmu.specific_ctx;
+
+		ctx_id = i915_gem_obj_ggtt_offset(ctx->legacy_hw_ctx.rcs_state);
+	} else
+		ctx_id = 0;
+
+	report_format = event->attr.config & I915_PERF_OA_FORMAT_MASK;
+	report_format >>= I915_PERF_OA_FORMAT_SHIFT;
+	snapshot_size = hsw_perf_format_sizes[report_format];
+
+	I915_WRITE(OACONTROL,  0 |
+		   (ctx_id & OACONTROL_CTX_MASK) |
+		   period_exponent << OACONTROL_TIMER_PERIOD_SHIFT |
+		   (event->attr.sample_period ? OACONTROL_TIMER_ENABLE : 0) |
+		   report_format << OACONTROL_FORMAT_SHIFT|
+		   (ctx_id ? OACONTROL_PER_CTX_ENABLE : 0) |
+		   OACONTROL_ENABLE);
+
+	if (event->attr.sample_period) {
+		__hrtimer_start_range_ns(&dev_priv->oa_pmu.timer,
+					 ns_to_ktime(PERIOD), 0,
+					 HRTIMER_MODE_REL_PINNED, 0);
+	}
+
+	dev_priv->oa_pmu.oa_buffer.format = report_format;
+	dev_priv->oa_pmu.oa_buffer.format_size = snapshot_size;
+
+	event->hw.state = 0;
+}
+
+static void i915_oa_event_stop(struct perf_event *event, int flags)
+{
+	struct drm_i915_private *dev_priv =
+		container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
+
+	I915_WRITE(OACONTROL, I915_READ(OACONTROL) & ~OACONTROL_ENABLE);
+
+	if (event->attr.sample_period) {
+		hrtimer_cancel(&dev_priv->oa_pmu.timer);
+		flush_oa_snapshots(dev_priv, true);
+	}
+
+	event->hw.state = PERF_HES_STOPPED;
+}
+
+static int i915_oa_event_add(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_START)
+		i915_oa_event_start(event, flags);
+
+	return 0;
+}
+
+static void i915_oa_event_del(struct perf_event *event, int flags)
+{
+	i915_oa_event_stop(event, flags);
+}
+
+static void i915_oa_event_read(struct perf_event *event)
+{
+	struct drm_i915_private *i915 =
+		container_of(event->pmu, typeof(*i915), oa_pmu.pmu);
+
+	/* We want userspace to be able to use a read() to explicitly
+	 * flush OA counter snapshots... */
+	if (event->attr.sample_period)
+		flush_oa_snapshots(i915, true);
+
+	/* XXX: What counter would be useful here? */
+	local64_set(&event->count, 0);
+}
+
+static int i915_oa_event_event_idx(struct perf_event *event)
+{
+	return 0;
+}
+
+void i915_oa_pmu_register(struct drm_device *dev)
+{
+	struct drm_i915_private *i915 = to_i915(dev);
+
+	/* We need to be careful about forwarding cpu metrics to
+	 * userspace considering that PERF_PMU_CAP_IS_DEVICE bypasses
+	 * the events/core security check that stops an unprivileged
+	 * process collecting metrics for other processes.
+	 */
+	i915->oa_pmu.dummy_regs = *task_pt_regs(current);
+
+	hrtimer_init(&i915->oa_pmu.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	i915->oa_pmu.timer.function = hrtimer_sample;
+
+	spin_lock_init(&i915->oa_pmu.lock);
+
+	i915->oa_pmu.pmu.capabilities  = PERF_PMU_CAP_IS_DEVICE;
+	i915->oa_pmu.pmu.task_ctx_nr   = perf_invalid_context;
+	i915->oa_pmu.pmu.event_init    = i915_oa_event_init;
+	i915->oa_pmu.pmu.add	       = i915_oa_event_add;
+	i915->oa_pmu.pmu.del	       = i915_oa_event_del;
+	i915->oa_pmu.pmu.start	       = i915_oa_event_start;
+	i915->oa_pmu.pmu.stop	       = i915_oa_event_stop;
+	i915->oa_pmu.pmu.read	       = i915_oa_event_read;
+	i915->oa_pmu.pmu.event_idx     = i915_oa_event_event_idx;
+
+	if (perf_pmu_register(&i915->oa_pmu.pmu, "i915_oa", -1))
+		i915->oa_pmu.pmu.event_init = NULL;
+}
+
+void i915_oa_pmu_unregister(struct drm_device *dev)
+{
+	struct drm_i915_private *i915 = to_i915(dev);
+
+	if (i915->oa_pmu.pmu.event_init == NULL)
+		return;
+
+	perf_pmu_unregister(&i915->oa_pmu.pmu);
+	i915->oa_pmu.pmu.event_init = NULL;
+}
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 203062e..1e7cfd4 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -457,6 +457,92 @@
 #define GEN7_3DPRIM_BASE_VERTEX         0x2440
 
 #define OACONTROL 0x2360
+#define  OACONTROL_CTX_MASK		0xFFFFF000
+#define  OACONTROL_TIMER_PERIOD_MASK	0x3F
+#define  OACONTROL_TIMER_PERIOD_SHIFT	6
+#define  OACONTROL_TIMER_ENABLE		(1<<5)
+#define  OACONTROL_FORMAT_A13_HSW	(0<<2)
+#define  OACONTROL_FORMAT_A29_HSW       (1<<2)
+#define  OACONTROL_FORMAT_A13_B8_C8_HSW (2<<2)
+#define  OACONTROL_FORMAT_A29_B8_C8_HSW (3<<2)
+#define  OACONTROL_FORMAT_B4_C8_HSW     (4<<2)
+#define  OACONTROL_FORMAT_A45_B8_C8_HSW (5<<2)
+#define  OACONTROL_FORMAT_B4_C8_A16_HSW (6<<2)
+#define  OACONTROL_FORMAT_C4_B8_HSW     (7<<2)
+#define  OACONTROL_FORMAT_SHIFT         2
+#define  OACONTROL_PER_CTX_ENABLE	(1<<1)
+#define  OACONTROL_ENABLE		(1<<0)
+
+#define OASTARTTRIG5 0x02720
+#define  OASTARTTRIG5_THRESHOLD_VALUE_MASK	0xffff
+
+#define OASTARTTRIG6 0x02724
+#define  OASTARTTRIG6_B4_TO_B7_THRESHOLD_ENABLE (1<<23)
+#define  OASTARTTRIG6_B4_CUSTOM_EVENT_ENABLE	(1<<28)
+
+#define OASTARTTRIG1 0x02710
+#define  OASTARTTRIG1_THRESHOLD_VALUE_MASK	0xffff
+
+#define OASTARTTRIG2 0x02714
+#define  OASTARTTRIG2_B0_TO_B3_THRESHOLD_ENABLE (1<<23)
+#define  OASTARTTRIG2_B0_CUSTOM_EVENT_ENABLE	(1<<28)
+
+#define OACEC0_0 0x2770
+#define  OACEC0_0_B0_COMPARE_ANY_EQUAL		0
+#define  OACEC0_0_B0_COMPARE_OR			0
+#define  OACEC0_0_B0_COMPARE_GREATER_THAN	1
+#define  OACEC0_0_B0_COMPARE_EQUAL		2
+#define  OACEC0_0_B0_COMPARE_GREATER_OR_EQUAL	3
+#define  OACEC0_0_B0_COMPARE_LESS_THAN		4
+#define  OACEC0_0_B0_COMPARE_NOT_EQUAL		5
+#define  OACEC0_0_B0_COMPARE_LESS_OR_EQUAL	6
+#define  OACEC0_0_B0_COMPARE_VALUE_MASK		0xffff
+#define  OACEC0_0_B0_COMPARE_VALUE_SHIFT	3
+
+#define OACEC0_1 0x2774
+#define  OACEC0_1_B0_NOA_SELECT_MASK		0xffff
+
+#define GEN7_OABUFFER 0x23B0 /* R/W */
+#define  GEN7_OABUFFER_OVERRUN_DISABLE	    (1<<3)
+#define  GEN7_OABUFFER_EDGE_TRIGGER	    (1<<2)
+#define  GEN7_OABUFFER_STOP_RESUME_ENABLE   (1<<1)
+#define  GEN7_OABUFFER_RESUME		    (1<<0)
+
+#define GEN8_OABUFFER 0x2B14 /* R/W */
+#define  GEN8_OABUFFER_SIZE_MASK	0x7
+#define  GEN8_OABUFFER_SIZE_128K	(0<<3)
+#define  GEN8_OABUFFER_SIZE_256K	(1<<3)
+#define  GEN8_OABUFFER_SIZE_512K	(2<<3)
+#define  GEN8_OABUFFER_SIZE_1M		(3<<3)
+#define  GEN8_OABUFFER_SIZE_2M		(4<<3)
+#define  GEN8_OABUFFER_SIZE_4M		(5<<3)
+#define  GEN8_OABUFFER_SIZE_8M		(6<<3)
+#define  GEN8_OABUFFER_SIZE_16M		(7<<3)
+#define  GEN8_OABUFFER_EDGE_TRIGGER	(1<<2)
+#define  GEN8_OABUFFER_OVERRUN_DISABLE  (1<<1)
+#define  GEN8_OABUFFER_MEM_SELECT_GGTT  (1<<0)
+
+#define OASTATUS1 0x2364
+#define  OASTATUS1_TAIL_MASK		0xffffffc0
+#define  OASTATUS1_OABUFFER_SIZE_128K	(0<<3)
+#define  OASTATUS1_OABUFFER_SIZE_256K	(1<<3)
+#define  OASTATUS1_OABUFFER_SIZE_512K	(2<<3)
+#define  OASTATUS1_OABUFFER_SIZE_1M	(3<<3)
+#define  OASTATUS1_OABUFFER_SIZE_2M	(4<<3)
+#define  OASTATUS1_OABUFFER_SIZE_4M	(5<<3)
+#define  OASTATUS1_OABUFFER_SIZE_8M	(6<<3)
+#define  OASTATUS1_OABUFFER_SIZE_16M	(7<<3)
+#define  OASTATUS1_COUNTER_OVERFLOW	(1<<2)
+#define  OASTATUS1_OABUFFER_OVERFLOW	(1<<1)
+#define  OASTATUS1_REPORT_LOST		(1<<0)
+
+
+#define OASTATUS2 0x2368
+#define OASTATUS2_HEAD_MASK 0xffffffc0
+#define OASTATUS2_GGTT 0x1
+
+#define GEN8_OAHEADPTR 0x2B0C
+#define GEN8_OATAILPTR 0x2B10
 
 #define _GEN7_PIPEA_DE_LOAD_SL	0x70068
 #define _GEN7_PIPEB_DE_LOAD_SL	0x71068
@@ -5551,6 +5637,7 @@ enum punit_power_well {
 # define GEN6_RCCUNIT_CLOCK_GATE_DISABLE		(1 << 11)
 
 #define GEN6_UCGCTL3				0x9408
+# define GEN6_OACSUNIT_CLOCK_GATE_DISABLE		(1 << 20)
 
 #define GEN7_UCGCTL4				0x940c
 #define  GEN7_L3BANK2X_CLOCK_GATE_DISABLE	(1<<25)
diff --git a/include/uapi/drm/i915_drm.h b/include/uapi/drm/i915_drm.h
index ff57f07..fd3b0cb 100644
--- a/include/uapi/drm/i915_drm.h
+++ b/include/uapi/drm/i915_drm.h
@@ -58,6 +58,27 @@
 #define I915_ERROR_UEVENT		"ERROR"
 #define I915_RESET_UEVENT		"RESET"
 
+/**
+ * DOC: perf events configuration exposed by i915 through /sys/bus/event_sources/drivers/i915_oa
+ *
+ */
+#define I915_PERF_OA_CTX_ID_MASK	    0xffffffff
+#define I915_PERF_OA_SINGLE_CONTEXT_ENABLE  (1ULL << 32)
+
+#define I915_PERF_OA_FORMAT_SHIFT	    33
+#define I915_PERF_OA_FORMAT_MASK	    (0x7ULL << 33)
+#define I915_PERF_OA_FORMAT_A13_HSW	    (0ULL << 33)
+#define I915_PERF_OA_FORMAT_A29_HSW	    (1ULL << 33)
+#define I915_PERF_OA_FORMAT_A13_B8_C8_HSW   (2ULL << 33)
+#define I915_PERF_OA_FORMAT_A29_B8_C8_HSW   (3ULL << 33)
+#define I915_PERF_OA_FORMAT_B4_C8_HSW	    (4ULL << 33)
+#define I915_PERF_OA_FORMAT_A45_B8_C8_HSW   (5ULL << 33)
+#define I915_PERF_OA_FORMAT_B4_C8_A16_HSW   (6ULL << 33)
+#define I915_PERF_OA_FORMAT_C4_B8_HSW	    (7ULL << 33)
+
+#define I915_PERF_OA_TIMER_EXPONENT_SHIFT   36
+#define I915_PERF_OA_TIMER_EXPONENT_MASK    (0x3fULL << 36)
+
 /* Each region is a minimum of 16k, and there are at most 255 of them.
  */
 #define I915_NR_TEX_REGIONS 255	/* table size 2k - maximum due to use
-- 
2.1.2

