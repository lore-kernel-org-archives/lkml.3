Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab3BEWKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3BEWKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 49/93] drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for scanline waits
Date: Tue,  5 Feb 2013 20:06:38 -0200
Message-Id: <1360102042-10732-50-git-send-email-herton.krzesinski@canonical.com>
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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 78486c7..e75d794 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -421,6 +421,11 @@ static int init_render_ring(struct intel_ring_buffer *ring)
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
-- 
1.7.9.5

