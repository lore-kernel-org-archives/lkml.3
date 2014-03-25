Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaCYSAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:00:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55657 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaCYRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjoern C <lkml@call-home.ch>,
        Alexandru DAMIAN <alexandru.damian@intel.com>,
        Enrico Tagliavini <enrico.tagliavini@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 13/81] drm/i915: Add intel_ring_cachline_align()
Date: Tue, 25 Mar 2014 10:15:26 -0700
Message-Id: <1395767794-5012-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 21 +++++++++++++++++++++
 drivers/gpu/drm/i915/intel_ringbuffer.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index cd0ba21..b548cb2 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1453,6 +1453,27 @@ int intel_ring_begin(struct intel_ring_buffer *ring,
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
 	struct drm_i915_private *dev_priv = ring->dev->dev_private;
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.h b/drivers/gpu/drm/i915/intel_ringbuffer.h
index 6af87cd..f23812f 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -200,6 +200,7 @@ intel_read_status_page(struct intel_ring_buffer *ring,
 void intel_cleanup_ring_buffer(struct intel_ring_buffer *ring);
 
 int __must_check intel_ring_begin(struct intel_ring_buffer *ring, int n);
+int __must_check intel_ring_cacheline_align(struct intel_ring_buffer *ring);
 static inline void intel_ring_emit(struct intel_ring_buffer *ring,
 				   u32 data)
 {
-- 
1.8.3.2

