Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaFRWjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:39:05 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44125 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaFRWjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:39:03 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: daniel.vetter@ffwll.ch
Cc: jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH] drivers/i915: Fix unnoticed failure of init_ring_common()
Date: Thu, 19 Jun 2014 00:38:54 +0200
Message-Id: <1403131134-9533-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit add check for return value of init_ring_common() in the
init_render_ring(). Now, when failure is detected the error code is
propagated to the caller layer instead of being ignored.

I believe that this fix will have a positive impact on the oops that
I hit recently and which starts when init_ring_common() fails:

    [drm:init_ring_common] *ERROR* render ring initialization failed
             ctl 0001f001 head 0000000c tail 00000000 start 003eb000
    BUG: unable to handle kernel NULL pointer dereference at 0000006c
    IP: [<f8ca1679>] i915_gem_obj_to_ggtt+0x9/0x40 [i915]

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 279488a..d205b0d 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -604,6 +604,8 @@ static int init_render_ring(struct intel_engine_cs *ring)
 	struct drm_device *dev = ring->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret = init_ring_common(ring);
+	if (ret)
+		return ret;
 
 	/* WaTimedSingleVertexDispatch:cl,bw,ctg,elk,ilk,snb */
 	if (INTEL_INFO(dev)->gen >= 4 && INTEL_INFO(dev)->gen < 7)
-- 
1.8.1.2

