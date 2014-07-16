Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaGPVFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:05:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:59867 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaGPVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:08 -0400
Message-Id: <20140716205056.628471308@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [patch V2 52/64] drm: i915: Use nsec based interfaces
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=drm-i915-use-nsec-interfaces.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ktime_get_raw_ns() and get rid of the back and forth timespec
conversions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_drv.h |    2 +-
 drivers/gpu/drm/i915/i915_gem.c |   33 ++++++++++++---------------------
 drivers/gpu/drm/i915/intel_pm.c |   12 +++++-------
 3 files changed, 18 insertions(+), 29 deletions(-)

Index: tip/drivers/gpu/drm/i915/i915_drv.h
===================================================================
--- tip.orig/drivers/gpu/drm/i915/i915_drv.h
+++ tip/drivers/gpu/drm/i915/i915_drv.h
@@ -931,7 +931,7 @@ struct intel_ilk_power_mgmt {
 	unsigned long last_time1;
 	unsigned long chipset_power;
 	u64 last_count2;
-	struct timespec last_time2;
+	u64 last_time2;
 	unsigned long gfx_power;
 	u8 corr;
 
Index: tip/drivers/gpu/drm/i915/i915_gem.c
===================================================================
--- tip.orig/drivers/gpu/drm/i915/i915_gem.c
+++ tip/drivers/gpu/drm/i915/i915_gem.c
@@ -1149,16 +1149,16 @@ static bool can_wait_boost(struct drm_i9
 static int __wait_seqno(struct intel_engine_cs *ring, u32 seqno,
 			unsigned reset_counter,
 			bool interruptible,
-			struct timespec *timeout,
+			s64 *timeout,
 			struct drm_i915_file_private *file_priv)
 {
 	struct drm_device *dev = ring->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	const bool irq_test_in_progress =
 		ACCESS_ONCE(dev_priv->gpu_error.test_irq_rings) & intel_ring_flag(ring);
-	struct timespec before, now;
 	DEFINE_WAIT(wait);
 	unsigned long timeout_expire;
+	s64 before, now;
 	int ret;
 
 	WARN(dev_priv->pm.irqs_disabled, "IRQs disabled\n");
@@ -1166,7 +1166,7 @@ static int __wait_seqno(struct intel_eng
 	if (i915_seqno_passed(ring->get_seqno(ring, true), seqno))
 		return 0;
 
-	timeout_expire = timeout ? jiffies + timespec_to_jiffies_timeout(timeout) : 0;
+	timeout_expire = timeout ? jiffies + nsecs_to_jiffies((u64)*timeout) : 0;
 
 	if (INTEL_INFO(dev)->gen >= 6 && can_wait_boost(file_priv)) {
 		gen6_rps_boost(dev_priv);
@@ -1181,7 +1181,7 @@ static int __wait_seqno(struct intel_eng
 
 	/* Record current time in case interrupted by signal, or wedged */
 	trace_i915_gem_request_wait_begin(ring, seqno);
-	getrawmonotonic(&before);
+	before = ktime_get_raw_ns();
 	for (;;) {
 		struct timer_list timer;
 
@@ -1230,7 +1230,7 @@ static int __wait_seqno(struct intel_eng
 			destroy_timer_on_stack(&timer);
 		}
 	}
-	getrawmonotonic(&now);
+	now = ktime_get_raw_ns();
 	trace_i915_gem_request_wait_end(ring, seqno);
 
 	if (!irq_test_in_progress)
@@ -1239,10 +1239,9 @@ static int __wait_seqno(struct intel_eng
 	finish_wait(&ring->irq_queue, &wait);
 
 	if (timeout) {
-		struct timespec sleep_time = timespec_sub(now, before);
-		*timeout = timespec_sub(*timeout, sleep_time);
-		if (!timespec_valid(timeout)) /* i.e. negative time remains */
-			set_normalized_timespec(timeout, 0, 0);
+		s64 tres = *timeout - (now - before);
+
+		*timeout = tres < 0 ? 0 : tres;
 	}
 
 	return ret;
@@ -2753,16 +2752,10 @@ i915_gem_wait_ioctl(struct drm_device *d
 	struct drm_i915_gem_wait *args = data;
 	struct drm_i915_gem_object *obj;
 	struct intel_engine_cs *ring = NULL;
-	struct timespec timeout_stack, *timeout = NULL;
 	unsigned reset_counter;
 	u32 seqno = 0;
 	int ret = 0;
 
-	if (args->timeout_ns >= 0) {
-		timeout_stack = ns_to_timespec(args->timeout_ns);
-		timeout = &timeout_stack;
-	}
-
 	ret = i915_mutex_lock_interruptible(dev);
 	if (ret)
 		return ret;
@@ -2787,9 +2780,9 @@ i915_gem_wait_ioctl(struct drm_device *d
 		 goto out;
 
 	/* Do this after OLR check to make sure we make forward progress polling
-	 * on this IOCTL with a 0 timeout (like busy ioctl)
+	 * on this IOCTL with a timeout <=0 (like busy ioctl)
 	 */
-	if (!args->timeout_ns) {
+	if (args->timeout_ns <= 0) {
 		ret = -ETIME;
 		goto out;
 	}
@@ -2798,10 +2791,8 @@ i915_gem_wait_ioctl(struct drm_device *d
 	reset_counter = atomic_read(&dev_priv->gpu_error.reset_counter);
 	mutex_unlock(&dev->struct_mutex);
 
-	ret = __wait_seqno(ring, seqno, reset_counter, true, timeout, file->driver_priv);
-	if (timeout)
-		args->timeout_ns = timespec_to_ns(timeout);
-	return ret;
+	return __wait_seqno(ring, seqno, reset_counter, true, &args->timeout_ns,
+			    file->driver_priv);
 
 out:
 	drm_gem_object_unreference(&obj->base);
Index: tip/drivers/gpu/drm/i915/intel_pm.c
===================================================================
--- tip.orig/drivers/gpu/drm/i915/intel_pm.c
+++ tip/drivers/gpu/drm/i915/intel_pm.c
@@ -2993,7 +2993,7 @@ static void ironlake_enable_drps(struct
 		I915_READ(0x112e0);
 	dev_priv->ips.last_time1 = jiffies_to_msecs(jiffies);
 	dev_priv->ips.last_count2 = I915_READ(0x112f4);
-	getrawmonotonic(&dev_priv->ips.last_time2);
+	dev_priv->ips.last_time2 = ktime_get_raw_ns();
 
 	spin_unlock_irq(&mchdev_lock);
 }
@@ -4314,18 +4314,16 @@ static u16 pvid_to_extvid(struct drm_i91
 
 static void __i915_update_gfx_val(struct drm_i915_private *dev_priv)
 {
-	struct timespec now, diff1;
-	u64 diff;
-	unsigned long diffms;
+	u64 now, diff, diffms;
 	u32 count;
 
 	assert_spin_locked(&mchdev_lock);
 
-	getrawmonotonic(&now);
-	diff1 = timespec_sub(now, dev_priv->ips.last_time2);
+	now = ktime_get_raw_ns();
+	diffms = now - dev_priv->ips.last_time2;
+	do_div(diffms, NSEC_PER_MSEC);
 
 	/* Don't divide by 0 */
-	diffms = diff1.tv_sec * 1000 + diff1.tv_nsec / 1000000;
 	if (!diffms)
 		return;
 


