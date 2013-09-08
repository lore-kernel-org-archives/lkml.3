Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab3IHDsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:48:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56029 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755331Ab3IHDTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Thiago Macieira" <thiago@kde.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.177708502@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [078/121] drm/i915: Invalidate TLBs for the rings after a reset
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: add definition of RING_INSTPM() from
 commit c1cd90ed7957 'drm/i915: collect more per ring error state']
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h         |  2 ++
 drivers/gpu/drm/i915/intel_ringbuffer.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -362,6 +362,7 @@
 #define IPEIR_I965	0x02064
 #define IPEHR_I965	0x02068
 #define INSTDONE_I965	0x0206c
+#define RING_INSTPM(base)      ((base)+0xc0)
 #define INSTPS		0x02070 /* 965+ only */
 #define INSTDONE1	0x0207c /* 965+ only */
 #define ACTHD_I965	0x02074
@@ -458,6 +459,8 @@
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
@@ -776,6 +776,18 @@ void intel_ring_setup_status_page(struct
 
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

