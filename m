Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030245Ab3BANZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:25:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:44585 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab3BANJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:09:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 23/89] drm/i915: Disable AsyncFlip performance optimisations
Date: Fri,  1 Feb 2013 14:07:38 +0100
Message-Id: <20130201130209.141719758@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 1c8c38c588ea91f8deeae21284840459d1bb58e3 upstream.

This is a required workarounds for all products, especially on gen6+
where it causes the command streamer to fail to parse instructions
following a WAIT_FOR_EVENT. We use WAIT_FOR_EVENT for synchronising
between the GPU and the display engines, and so this bit being unset may
cause hangs.

References: https://bugzilla.kernel.org/show_bug.cgi?id=52311
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h         |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c |   19 +++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -527,6 +527,7 @@
 #define MI_MODE		0x0209c
 # define VS_TIMER_DISPATCH				(1 << 6)
 # define MI_FLUSH_ENABLE				(1 << 12)
+# define ASYNC_FLIP_PERF_DISABLE			(1 << 14)
 
 #define GEN6_GT_MODE	0x20d0
 #define   GEN6_GT_MODE_HI	(1 << 9)
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -505,13 +505,20 @@ static int init_render_ring(struct intel
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret = init_ring_common(ring);
 
-	if (INTEL_INFO(dev)->gen > 3) {
+	if (INTEL_INFO(dev)->gen > 3)
 		I915_WRITE(MI_MODE, _MASKED_BIT_ENABLE(VS_TIMER_DISPATCH));
-		if (IS_GEN7(dev))
-			I915_WRITE(GFX_MODE_GEN7,
-				   _MASKED_BIT_DISABLE(GFX_TLB_INVALIDATE_ALWAYS) |
-				   _MASKED_BIT_ENABLE(GFX_REPLAY_MODE));
-	}
+
+	/* We need to disable the AsyncFlip performance optimisations in order
+	 * to use MI_WAIT_FOR_EVENT within the CS. It should already be
+	 * programmed to '1' on all products.
+	 */
+	if (INTEL_INFO(dev)->gen >= 6)
+		I915_WRITE(MI_MODE, _MASKED_BIT_ENABLE(ASYNC_FLIP_PERF_DISABLE));
+
+	if (IS_GEN7(dev))
+		I915_WRITE(GFX_MODE_GEN7,
+			   _MASKED_BIT_DISABLE(GFX_TLB_INVALIDATE_ALWAYS) |
+			   _MASKED_BIT_ENABLE(GFX_REPLAY_MODE));
 
 	if (INTEL_INFO(dev)->gen >= 5) {
 		ret = init_pipe_control(ring);


