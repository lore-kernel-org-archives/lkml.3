Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaC3Xn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbaC3XnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:17 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Bjoern C" <lkml@call-home.ch>,
        "Enrico Tagliavini" <enrico.tagliavini@gmail.com>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=" 
	<ville.syrjala@linux.intel.com>,
        "Alexandru DAMIAN" <alexandru.damian@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.145478816@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 104/200] drm/i915: Add intel_ring_cachline_align()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 753b1ad4a281b0663329409d410243e91825c323 upstream.

intel_ring_cachline_align() emits MI_NOOPs until the ring tail is
aligned to a cacheline boundary.

Cc: Bjoern C <lkml@call-home.ch>
Cc: Alexandru DAMIAN <alexandru.damian@intel.com>
Cc: Enrico Tagliavini <enrico.tagliavini@gmail.com>
Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 21 +++++++++++++++++++++
 drivers/gpu/drm/i915/intel_ringbuffer.h |  1 +
 2 files changed, 22 insertions(+)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1213,6 +1213,27 @@ int intel_ring_begin(struct intel_ring_b
 	return 0;
 }
 
+/* Align the ring tail to a cacheline boundary */
+int intel_ring_cacheline_align(struct intel_ring_buffer *ring)
+{
+	int num_dwords = (64 - (ring->tail & 63)) / sizeof(uint32_t);
+	int ret;
+
+	if (num_dwords == 0)
+		return 0;
+
+	ret = intel_ring_begin(ring, num_dwords);
+	if (ret)
+		return ret;
+
+	while (num_dwords--)
+		intel_ring_emit(ring, MI_NOOP);
+
+	intel_ring_advance(ring);
+
+	return 0;
+}
+
 void intel_ring_advance(struct intel_ring_buffer *ring)
 {
 	ring->tail &= ring->size - 1;
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -174,6 +174,7 @@ static inline int intel_wait_ring_idle(s
 }
 
 int __must_check intel_ring_begin(struct intel_ring_buffer *ring, int n);
+int __must_check intel_ring_cacheline_align(struct intel_ring_buffer *ring);
 
 static inline void intel_ring_emit(struct intel_ring_buffer *ring,
 				   u32 data)

