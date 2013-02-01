Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab3BANJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:09:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:44597 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab3BANJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:09:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 24/89] drm/i915: GFX_MODE Flush TLB Invalidate Mode must be 1 for scanline waits
Date: Fri,  1 Feb 2013 14:07:39 +0100
Message-Id: <20130201130209.228535311@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -515,6 +515,11 @@ static int init_render_ring(struct intel
 	if (INTEL_INFO(dev)->gen >= 6)
 		I915_WRITE(MI_MODE, _MASKED_BIT_ENABLE(ASYNC_FLIP_PERF_DISABLE));
 
+	/* Required for the hardware to program scanline values for waiting */
+	if (INTEL_INFO(dev)->gen == 6)
+		I915_WRITE(GFX_MODE,
+			   _MASKED_BIT_ENABLE(GFX_TLB_INVALIDATE_ALWAYS));
+
 	if (IS_GEN7(dev))
 		I915_WRITE(GFX_MODE_GEN7,
 			   _MASKED_BIT_DISABLE(GFX_TLB_INVALIDATE_ALWAYS) |


