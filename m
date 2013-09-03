Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300Ab3ICQdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:33:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46564 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759978Ab3ICQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:27:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 41/58] drm/i915: Invalidate TLBs for the rings after a reset
Date: Tue,  3 Sep 2013 09:23:45 -0700
Message-Id: <1378225442-20654-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 884020bf3d2a3787a1cc6df902e98e0eec60330b upstream.

After any "soft gfx reset" we must manually invalidate the TLBs
associated with each ring. Empirically, it seems that a
suspend/resume or D3-D0 cycle count as a "soft reset". The symptom is
that the hardware would fail to note the new address for its status
page, and so it would continue to write the shadow registers and
breadcrumbs into the old physical address (now used by something
completely different, scary). Whereas the driver would read the new
status page and never see any progress, it would appear that the GPU
hung immediately upon resume.

Based on a patch by naresh kumar kachhi <naresh.kumar.kacchi@intel.com>

Reported-by: Thiago Macieira <thiago@kde.org>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=64725
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Thiago Macieira <thiago@kde.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h         |  2 ++
 drivers/gpu/drm/i915/intel_ringbuffer.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 24f0368..8028dcf 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -596,6 +596,8 @@
 					will not assert AGPBUSY# and will only
 					be delivered when out of C3. */
 #define   INSTPM_FORCE_ORDERING				(1<<7) /* GEN6+ */
+#define   INSTPM_TLB_INVALIDATE	(1<<9)
+#define   INSTPM_SYNC_FLUSH	(1<<5)
 #define ACTHD	        0x020c8
 #define FW_BLC		0x020d8
 #define FW_BLC2		0x020dc
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 27f810f..cd0ba21 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -874,6 +874,18 @@ void intel_ring_setup_status_page(struct intel_ring_buffer *ring)
 
 	I915_WRITE(mmio, (u32)ring->status_page.gfx_addr);
 	POSTING_READ(mmio);
+
+	/* Flush the TLB for this page */
+	if (INTEL_INFO(dev)->gen >= 6) {
+		u32 reg = RING_INSTPM(ring->mmio_base);
+		I915_WRITE(reg,
+			   _MASKED_BIT_ENABLE(INSTPM_TLB_INVALIDATE |
+					      INSTPM_SYNC_FLUSH));
+		if (wait_for((I915_READ(reg) & INSTPM_SYNC_FLUSH) == 0,
+			     1000))
+			DRM_ERROR("%s: wait for SyncFlush to complete for TLB invalidation timed out\n",
+				  ring->name);
+	}
 }
 
 static int
-- 
1.8.1.2

