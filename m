Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3G3PZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:25:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55315 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 05/75] drm/i915: fix up ring cleanup for the i830/i845 CS tlb w/a
Date: Tue, 30 Jul 2013 08:16:34 -0700
Message-Id: <1375197464-27962-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit aaf8a5167291b65e9116cb8736d862965b57c13a upstream.

It's not a good idea to also run the pipe_control cleanup.

This regression has been introduced whith the original cs tlb w/a in

commit b45305fce5bb1abec263fcff9d81ebecd6306ede
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Dec 17 16:21:27 2012 +0100

    drm/i915: Implement workaround for broken CS tlb on i830/845

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=64610
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 42ff97d..27f810f 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -486,9 +486,6 @@ cleanup_pipe_control(struct intel_ring_buffer *ring)
 	struct pipe_control *pc = ring->private;
 	struct drm_i915_gem_object *obj;
 
-	if (!ring->private)
-		return;
-
 	obj = pc->obj;
 
 	kunmap(sg_page(obj->pages->sgl));
@@ -496,7 +493,6 @@ cleanup_pipe_control(struct intel_ring_buffer *ring)
 	drm_gem_object_unreference(&obj->base);
 
 	kfree(pc);
-	ring->private = NULL;
 }
 
 static int init_render_ring(struct intel_ring_buffer *ring)
@@ -567,7 +563,10 @@ static void render_ring_cleanup(struct intel_ring_buffer *ring)
 	if (HAS_BROKEN_CS_TLB(dev))
 		drm_gem_object_unreference(to_gem_object(ring->private));
 
-	cleanup_pipe_control(ring);
+	if (INTEL_INFO(dev)->gen >= 5)
+		cleanup_pipe_control(ring);
+
+	ring->private = NULL;
 }
 
 static void
-- 
1.8.1.2

