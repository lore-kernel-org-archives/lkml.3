Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3BCO5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:57:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34484 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab3BCO5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:37 -0500
Message-Id: <20130203144652.119144738@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 091/128] drm/i915: GFX_MODE Flush TLB Invalidate Mode must be 1 for
 scanline waits
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

commit f05bb0c7b624252a5e768287e340e8e45df96e42 upstream.

On SNB, if bit 13 of GFX_MODE, Flush TLB Invalidate Mode, is not set to 1,
the hardware can not program the scanline values. Those scanline values
then control when the signal is sent from the display engine to the render
ring for MI_WAIT_FOR_EVENTs. Note setting this bit means that TLB
invalidations must be performed explicitly through the appropriate bits
being set in PIPE_CONTROL.

References: https://bugzilla.kernel.org/show_bug.cgi?id=52311
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: s/_MASKED_BIT/GFX_MODE/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -407,6 +407,11 @@ static int init_render_ring(struct intel
 	if (INTEL_INFO(dev)->gen >= 6)
 		I915_WRITE(MI_MODE, GFX_MODE_ENABLE(ASYNC_FLIP_PERF_DISABLE));
 
+	/* Required for the hardware to program scanline values for waiting */
+	if (INTEL_INFO(dev)->gen == 6)
+		I915_WRITE(GFX_MODE,
+			   GFX_MODE_ENABLE(GFX_TLB_INVALIDATE_ALWAYS));
+
 	if (IS_GEN7(dev))
 		I915_WRITE(GFX_MODE_GEN7,
 			   GFX_MODE_DISABLE(GFX_TLB_INVALIDATE_ALWAYS) |


