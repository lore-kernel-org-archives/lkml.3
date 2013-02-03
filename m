Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3BCO5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:57:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34468 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730Ab3BCO5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:32 -0500
Message-Id: <20130203144652.052424421@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 090/128] drm/i915: Disable AsyncFlip performance optimisations
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - s/_MASKED_BIT/GFX_MODE/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h         |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c |   19 +++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -400,6 +400,7 @@
 #define MI_MODE		0x0209c
 # define VS_TIMER_DISPATCH				(1 << 6)
 # define MI_FLUSH_ENABLE				(1 << 12)
+# define ASYNC_FLIP_PERF_DISABLE			(1 << 14)
 
 #define GEN6_GT_MODE	0x20d0
 #define   GEN6_GT_MODE_HI	(1 << 9)
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -399,12 +399,20 @@ static int init_render_ring(struct intel
 	if (INTEL_INFO(dev)->gen > 3) {
 		int mode = VS_TIMER_DISPATCH << 16 | VS_TIMER_DISPATCH;
 		I915_WRITE(MI_MODE, mode);
-		if (IS_GEN7(dev))
-			I915_WRITE(GFX_MODE_GEN7,
-				   GFX_MODE_DISABLE(GFX_TLB_INVALIDATE_ALWAYS) |
-				   GFX_MODE_ENABLE(GFX_REPLAY_MODE));
 	}
 
+	/* We need to disable the AsyncFlip performance optimisations in order
+	 * to use MI_WAIT_FOR_EVENT within the CS. It should already be
+	 * programmed to '1' on all products.
+	 */
+	if (INTEL_INFO(dev)->gen >= 6)
+		I915_WRITE(MI_MODE, GFX_MODE_ENABLE(ASYNC_FLIP_PERF_DISABLE));
+
+	if (IS_GEN7(dev))
+		I915_WRITE(GFX_MODE_GEN7,
+			   GFX_MODE_DISABLE(GFX_TLB_INVALIDATE_ALWAYS) |
+			   GFX_MODE_ENABLE(GFX_REPLAY_MODE));
+
 	if (INTEL_INFO(dev)->gen >= 5) {
 		ret = init_pipe_control(ring);
 		if (ret)


