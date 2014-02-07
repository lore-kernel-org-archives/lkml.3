Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaBGLtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:49:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41797 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaBGLtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 084/233] drm/i915: Flush outstanding requests before allocating new seqno
Date: Fri,  7 Feb 2014 11:45:03 +0000
Message-Id: <1391773652-25214-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 304d695c3dc8eb65206b9eaf16f8d1a41510d1cf upstream.

In very rare cases (such as a memory failure stress test) it is possible
to fill the entire ring without emitting a request. Under this
circumstance, the outstanding request is flushed and waited upon. After
space on the ring is cleared, we return to emitting the new command -
except that we just cleared the seqno allocated for this operation and
trigger the sanity check that a request is only ever emitted with a
valid seqno. The fix is to rearrange the code to make sure the
allocation of the seqno for this operation is after any required flushes
of outstanding operations.

The bug exists since the preallocation was introduced in
commit 9d7730914f4cd496e356acfab95b41075aa8eae8
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Nov 27 16:22:52 2012 +0000

    drm/i915: Preallocate next seqno before touching the ring

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 079ef01..9e171c2 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1557,8 +1557,8 @@ intel_ring_alloc_seqno(struct intel_ring_buffer *ring)
 	return i915_gem_get_seqno(ring->dev, &ring->outstanding_lazy_request);
 }
 
-static int __intel_ring_begin(struct intel_ring_buffer *ring,
-			      int bytes)
+static int __intel_ring_prepare(struct intel_ring_buffer *ring,
+				int bytes)
 {
 	int ret;
 
@@ -1574,7 +1574,6 @@ static int __intel_ring_begin(struct intel_ring_buffer *ring,
 			return ret;
 	}
 
-	ring->space -= bytes;
 	return 0;
 }
 
@@ -1589,12 +1588,17 @@ int intel_ring_begin(struct intel_ring_buffer *ring,
 	if (ret)
 		return ret;
 
+	ret = __intel_ring_prepare(ring, num_dwords * sizeof(uint32_t));
+	if (ret)
+		return ret;
+
 	/* Preallocate the olr before touching the ring */
 	ret = intel_ring_alloc_seqno(ring);
 	if (ret)
 		return ret;
 
-	return __intel_ring_begin(ring, num_dwords * sizeof(uint32_t));
+	ring->space -= num_dwords * sizeof(uint32_t);
+	return 0;
 }
 
 void intel_ring_init_seqno(struct intel_ring_buffer *ring, u32 seqno)
-- 
1.8.3.2

