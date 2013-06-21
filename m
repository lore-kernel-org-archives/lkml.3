Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423311Ab3FUPh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:37:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:40065 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161506Ab3FUPh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:37:57 -0400
Date: Fri, 21 Jun 2013 17:37:54 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.8.13-rt12
Message-ID: <20130621153754.GF21228@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.8.13-rt12 release.

changes since v3.8.13-rt11:
- added the missing "acpi/rt: Convert acpi_gbl_hardware lock back to a
  raw_spinlock_t", reported by Steven.
- added an option to the i915 driver to disable the expensive wbinvd. A
  warning is printed once on RT if wbinvd is not disabled to let the
  user know about this problem. This problem was decoded by Carsten Emde.
- disable the trace_i915_gem_ring_dispatch() tracepoint on RT. Earlier
  it was reported that using this trace point leads to "scheduled while
  atomic" warnings. To fix this I pulled out the function in question out
  of the tracing macro. Upstream complains that this leads to too much
  overhead if the tracing point is not enabled so not it is gone.

The delta patch against v3.8.13-rt11 is appended below and can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13-rt11-rt12.patch.xz

The RT patch against 3.8.11 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13-rt12.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.13-rt12.tar.xz

Sebastian

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 64472e4..26b3cc7 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -231,7 +231,7 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pending;
  * interrupt level
  */
 ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
-ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
+ACPI_EXTERN acpi_raw_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
 
 /*****************************************************************************
  *
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index f4e5750..1feedd3 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -270,14 +270,14 @@ acpi_status acpi_hw_clear_acpi_status(void)
 			  ACPI_BITMASK_ALL_FIXED_STATUS,
 			  ACPI_FORMAT_UINT64(acpi_gbl_xpm1a_status.address)));
 
-	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(acpi_gbl_hardware_lock, lock_flags);
 
 	/* Clear the fixed events in PM1 A/B */
 
 	status = acpi_hw_register_write(ACPI_REGISTER_PM1_STATUS,
 					ACPI_BITMASK_ALL_FIXED_STATUS);
 
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(acpi_gbl_hardware_lock, lock_flags);
 
 	if (ACPI_FAILURE(status))
 		goto exit;
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index 05a154c..9e2d253 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -365,7 +365,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u32 value)
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(acpi_gbl_hardware_lock, lock_flags);
 
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -426,7 +426,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u32 value)
 
 unlock_and_exit:
 
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 5ccf57c..db85f08 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -88,7 +88,7 @@ acpi_status acpi_ut_mutex_initialize(void)
 		return_ACPI_STATUS (status);
 	}
 
-	status = acpi_os_create_lock (&acpi_gbl_hardware_lock);
+	status = acpi_os_create_raw_lock (&acpi_gbl_hardware_lock);
 	if (ACPI_FAILURE (status)) {
 		return_ACPI_STATUS (status);
 	}
@@ -135,7 +135,7 @@ void acpi_ut_mutex_terminate(void)
 	/* Delete the spinlocks */
 
 	acpi_os_delete_lock(acpi_gbl_gpe_lock);
-	acpi_os_delete_lock(acpi_gbl_hardware_lock);
+	acpi_os_delete_raw_lock(acpi_gbl_hardware_lock);
 
 	/* Delete the reader/writer lock */
 
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 339540d..dce41f4 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -35,6 +35,7 @@
 #include <linux/swap.h>
 #include <linux/pci.h>
 #include <linux/dma-buf.h>
+#include <linux/module.h>
 
 static void i915_gem_object_flush_gtt_write_domain(struct drm_i915_gem_object *obj);
 static void i915_gem_object_flush_cpu_write_domain(struct drm_i915_gem_object *obj);
@@ -2656,6 +2657,10 @@ static inline int fence_number(struct drm_i915_private *dev_priv,
 	return fence - dev_priv->fence_regs;
 }
 
+static bool do_wbinvd = true;
+module_param(do_wbinvd, bool, 0644);
+MODULE_PARM_DESC(do_wbinvd, "Do expensive synchronization. Say no after you pin each GPU process to the same CPU in order to lower the latency.");
+
 static void i915_gem_write_fence__ipi(void *data)
 {
 	wbinvd();
@@ -2679,8 +2684,16 @@ static void i915_gem_object_update_fence(struct drm_i915_gem_object *obj,
 	 * on each processor in order to manually flush all memory
 	 * transactions before updating the fence register.
 	 */
-	if (HAS_LLC(obj->base.dev))
-		on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
+	if (HAS_LLC(obj->base.dev)) {
+		if (do_wbinvd) {
+#ifdef CONFIG_PREEMPT_RT_FULL
+			pr_err_once("WARNING! The i915 invalidates all caches which increases the latency.");
+			pr_err_once("As a workaround use 'i915.do_wbinvd=no' and PIN each process doing ");
+			pr_err_once("any kind of GPU activity to the same CPU to avoid problems.");
+#endif
+			on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
+		}
+	}
 	i915_gem_write_fence(dev, fence_reg, enable ? obj : NULL);
 
 	if (enable) {
diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index eabd3dd..3f9c99e 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -814,7 +814,6 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 	struct intel_ring_buffer *ring;
 	u32 ctx_id = i915_execbuffer2_get_context_id(*args);
 	u32 exec_start, exec_len;
-	u32 seqno;
 	u32 mask;
 	u32 flags;
 	int ret, mode, i;
@@ -1069,9 +1068,9 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 			goto err;
 	}
 
-	seqno = intel_ring_get_seqno(ring);
-	trace_i915_gem_ring_dispatch(ring, seqno, flags);
-	i915_trace_irq_get(ring, seqno);
+#ifndef CONFIG_PREEMPT_RT_BASE
+	trace_i915_gem_ring_dispatch(ring, intel_ring_get_seqno(ring), flags);
+#endif
 
 	i915_gem_execbuffer_move_to_active(&objects, ring);
 	i915_gem_execbuffer_retire_commands(dev, file, ring);
diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index 29217db..3db4a68 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -244,6 +244,7 @@ TRACE_EVENT(i915_gem_ring_dispatch,
 			   __entry->ring = ring->id;
 			   __entry->seqno = seqno;
 			   __entry->flags = flags;
+			   i915_trace_irq_get(ring, seqno);
 			   ),
 
 	    TP_printk("dev=%u, ring=%u, seqno=%u, flags=%x",
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.h b/drivers/gpu/drm/i915/intel_ringbuffer.h
index 8b5e4ae..6af87cd 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -232,10 +232,8 @@ static inline u32 intel_ring_get_seqno(struct intel_ring_buffer *ring)
 
 static inline void i915_trace_irq_get(struct intel_ring_buffer *ring, u32 seqno)
 {
-#ifdef CONFIG_TRACEPOINTS
 	if (ring->trace_irq_seqno == 0 && ring->irq_get(ring))
 		ring->trace_irq_seqno = seqno;
-#endif
 }
 
 /* DRI warts */
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 85d5d8f..59445e5 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -72,6 +72,7 @@
 
 #define acpi_cache_t                        struct kmem_cache
 #define acpi_spinlock                       spinlock_t *
+#define acpi_raw_spinlock                   raw_spinlock_t *
 #define acpi_cpu_flags                      unsigned long
 
 #else /* !__KERNEL__ */
@@ -175,6 +176,19 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 	lock ? AE_OK : AE_NO_MEMORY;				\
 })
 
+#define acpi_os_create_raw_lock(__handle)			\
+({								\
+	raw_spinlock_t *lock = ACPI_ALLOCATE(sizeof(*lock));	\
+								\
+	if (lock) {						\
+		*(__handle) = lock;				\
+		raw_spin_lock_init(*(__handle));		\
+	}							\
+	lock ? AE_OK : AE_NO_MEMORY;				\
+})
+
+#define acpi_os_delete_raw_lock(__handle)	kfree(__handle)
+
 #endif /* __KERNEL__ */
 
 #endif /* __ACLINUX_H__ */
diff --git a/localversion-rt b/localversion-rt
index 05c35cb..6e44e54 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt11
+-rt12
