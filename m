Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3IKE6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3IKE4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:54 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ulrQG1oqknQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ewoGgRs3NZEA:10 a=taGs_qngAAAA:8 a=QyXUC8HyAAAA:8 a=3fyaaF4VAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=AlTRyC3qrIU2tG0Po3kA:9 a=n7Cch7CHiCMA:10 a=dGJ0OcVc7YAA:10 a=UgvI5mY6lN8A:10 a=jeBq3FmKZ4MA:10 a=Aa9zaP5xHjQ4x36A:21 a=pSaEjilkFu5rldJa:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042929.349387898@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thiago Macieira <thiago@kde.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [223/251] drm/i915: Invalidate TLBs for the rings after a reset
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0223-drm-i915-Invalidate-TLBs-for-the-rings-after-a-reset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 884020bf3d2a3787a1cc6df902e98e0eec60330b ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/i915_reg.h         |    2 ++
 drivers/gpu/drm/i915/intel_ringbuffer.c |   12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 3814aa3..bbdb976 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -575,6 +575,8 @@
 					will not assert AGPBUSY# and will only
 					be delivered when out of C3. */
 #define   INSTPM_FORCE_ORDERING				(1<<7) /* GEN6+ */
+#define   INSTPM_TLB_INVALIDATE	(1<<9)
+#define   INSTPM_SYNC_FLUSH	(1<<5)
 #define ACTHD	        0x020c8
 #define FW_BLC		0x020d8
 #define FW_BLC2		0x020dc
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index e2a73b3..77ee475 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -793,6 +793,18 @@ void intel_ring_setup_status_page(struct intel_ring_buffer *ring)
 
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
1.7.10.4


