Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaAFX7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:59:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbaAFWjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 074/144] drm/i915: Fix erroneous dereference of batch_obj inside reset_status
Date: Mon,  6 Jan 2014 14:37:15 -0800
Message-Id: <20140106223747.468132822@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 4db080f9e93411c3c41ec402244da28e2bbde835 upstream.

As the rings may be processed and their requests deallocated in a
different order to the natural retirement during a reset,

/* Whilst this request exists, batch_obj will be on the
 * active_list, and so will hold the active reference. Only when this
 * request is retired will the the batch_obj be moved onto the
 * inactive_list and lose its active reference. Hence we do not need
 * to explicitly hold another reference here.
 */

is violated, and the batch_obj may be dereferenced after it had been
freed on another ring. This can be simply avoided by processing the
status update prior to deallocating any requests.

Fixes regression (a possible OOPS following a GPU hang) from
commit aa60c664e6df502578454621c3a9b1f087ff8d25
Author: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Date:   Wed Jun 12 15:13:20 2013 +0300

    drm/i915: find guilty batch buffer on ring resets

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@intel.com>
[danvet: Add the code comment Chris supplied.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2278,15 +2278,24 @@ static void i915_gem_free_request(struct
 	kfree(request);
 }
 
-static void i915_gem_reset_ring_lists(struct drm_i915_private *dev_priv,
-				      struct intel_ring_buffer *ring)
+static void i915_gem_reset_ring_status(struct drm_i915_private *dev_priv,
+				       struct intel_ring_buffer *ring)
 {
-	u32 completed_seqno;
-	u32 acthd;
+	u32 completed_seqno = ring->get_seqno(ring, false);
+	u32 acthd = intel_ring_get_active_head(ring);
+	struct drm_i915_gem_request *request;
+
+	list_for_each_entry(request, &ring->request_list, list) {
+		if (i915_seqno_passed(completed_seqno, request->seqno))
+			continue;
 
-	acthd = intel_ring_get_active_head(ring);
-	completed_seqno = ring->get_seqno(ring, false);
+		i915_set_reset_status(ring, request, acthd);
+	}
+}
 
+static void i915_gem_reset_ring_cleanup(struct drm_i915_private *dev_priv,
+					struct intel_ring_buffer *ring)
+{
 	while (!list_empty(&ring->request_list)) {
 		struct drm_i915_gem_request *request;
 
@@ -2294,9 +2303,6 @@ static void i915_gem_reset_ring_lists(st
 					   struct drm_i915_gem_request,
 					   list);
 
-		if (request->seqno > completed_seqno)
-			i915_set_reset_status(ring, request, acthd);
-
 		i915_gem_free_request(request);
 	}
 
@@ -2338,8 +2344,16 @@ void i915_gem_reset(struct drm_device *d
 	struct intel_ring_buffer *ring;
 	int i;
 
+	/*
+	 * Before we free the objects from the requests, we need to inspect
+	 * them for finding the guilty party. As the requests only borrow
+	 * their reference to the objects, the inspection must be done first.
+	 */
+	for_each_ring(ring, dev_priv, i)
+		i915_gem_reset_ring_status(dev_priv, ring);
+
 	for_each_ring(ring, dev_priv, i)
-		i915_gem_reset_ring_lists(dev_priv, ring);
+		i915_gem_reset_ring_cleanup(dev_priv, ring);
 
 	i915_gem_restore_fences(dev);
 }


