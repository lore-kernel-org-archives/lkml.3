Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3H0BJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:09:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3H0BHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thiago Macieira <thiago@kde.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 52/74] drm/i915: Invalidate TLBs for the rings after a reset
Date: Mon, 26 Aug 2013 18:08:50 -0700
Message-Id: <20130827010435.247279805@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h         |    2 ++
 drivers/gpu/drm/i915/intel_ringbuffer.c |   12 ++++++++++++
 2 files changed, 14 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -617,6 +617,8 @@
 					will not assert AGPBUSY# and will only
 					be delivered when out of C3. */
 #define   INSTPM_FORCE_ORDERING				(1<<7) /* GEN6+ */
+#define   INSTPM_TLB_INVALIDATE	(1<<9)
+#define   INSTPM_SYNC_FLUSH	(1<<5)
 #define ACTHD	        0x020c8
 #define FW_BLC		0x020d8
 #define FW_BLC2		0x020dc
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -907,6 +907,18 @@ void intel_ring_setup_status_page(struct
 
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


