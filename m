Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030486Ab3HBKLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:11:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030385Ab3HBKLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 73/99] drm/i915: fix up ring cleanup for the i830/i845 CS tlb w/a
Date: Fri,  2 Aug 2013 18:08:26 +0800
Message-Id: <20130802100236.159924972@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -490,9 +490,6 @@ cleanup_pipe_control(struct intel_ring_b
 	struct pipe_control *pc = ring->private;
 	struct drm_i915_gem_object *obj;
 
-	if (!ring->private)
-		return;
-
 	obj = pc->obj;
 
 	kunmap(sg_page(obj->pages->sgl));
@@ -500,7 +497,6 @@ cleanup_pipe_control(struct intel_ring_b
 	drm_gem_object_unreference(&obj->base);
 
 	kfree(pc);
-	ring->private = NULL;
 }
 
 static int init_render_ring(struct intel_ring_buffer *ring)
@@ -571,7 +567,10 @@ static void render_ring_cleanup(struct i
 	if (HAS_BROKEN_CS_TLB(dev))
 		drm_gem_object_unreference(to_gem_object(ring->private));
 
-	cleanup_pipe_control(ring);
+	if (INTEL_INFO(dev)->gen >= 5)
+		cleanup_pipe_control(ring);
+
+	ring->private = NULL;
 }
 
 static void


