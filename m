Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3BEWWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:22:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48059 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab3BEWKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 48/93] drm/i915: Disable AsyncFlip performance optimisations
Date: Tue,  5 Feb 2013 20:06:37 -0200
Message-Id: <1360102042-10732-49-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h         |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c |   19 +++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 8ccfe28..623224c 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -513,6 +513,7 @@
 #define MI_MODE		0x0209c
 # define VS_TIMER_DISPATCH				(1 << 6)
 # define MI_FLUSH_ENABLE				(1 << 12)
+# define ASYNC_FLIP_PERF_DISABLE			(1 << 14)
 
 #define GEN6_GT_MODE	0x20d0
 #define   GEN6_GT_MODE_HI	(1 << 9)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index e5b84ff..78486c7 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -411,13 +411,20 @@ static int init_render_ring(struct intel_ring_buffer *ring)
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
-- 
1.7.9.5

