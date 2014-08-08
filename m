Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091AbaHHUxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:53:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41311 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbaHHUxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 087/259] drm/i915: Don't clobber the GTT when it's within stolen memory
Date: Fri,  8 Aug 2014 13:38:30 -0700
Message-Id: <1407530482-4483-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit f1e1c2129b79cfdaf07bca37c5a10569fe021abe upstream.

On most gen2-4 platforms the GTT can be (or maybe always is?)
inside the stolen memory region. If that's the case, reduce the
size of the stolen memory appropriately to make make sure we
don't clobber the GTT.

v2: Deal with gen4 36 bit physical address

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=80151
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_stolen.c | 44 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h        |  3 +++
 2 files changed, 47 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index 4a699d2..6471872 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -74,6 +74,50 @@ static unsigned long i915_stolen_to_physical(struct drm_device *dev)
 	if (base == 0)
 		return 0;
 
+	/* make sure we don't clobber the GTT if it's within stolen memory */
+	if (INTEL_INFO(dev)->gen <= 4 && !IS_G33(dev) && !IS_G4X(dev)) {
+		struct {
+			u32 start, end;
+		} stolen[2] = {
+			{ .start = base, .end = base + dev_priv->gtt.stolen_size, },
+			{ .start = base, .end = base + dev_priv->gtt.stolen_size, },
+		};
+		u64 gtt_start, gtt_end;
+
+		gtt_start = I915_READ(PGTBL_CTL);
+		if (IS_GEN4(dev))
+			gtt_start = (gtt_start & PGTBL_ADDRESS_LO_MASK) |
+				(gtt_start & PGTBL_ADDRESS_HI_MASK) << 28;
+		else
+			gtt_start &= PGTBL_ADDRESS_LO_MASK;
+		gtt_end = gtt_start + gtt_total_entries(dev_priv->gtt) * 4;
+
+		if (gtt_start >= stolen[0].start && gtt_start < stolen[0].end)
+			stolen[0].end = gtt_start;
+		if (gtt_end > stolen[1].start && gtt_end <= stolen[1].end)
+			stolen[1].start = gtt_end;
+
+		/* pick the larger of the two chunks */
+		if (stolen[0].end - stolen[0].start >
+		    stolen[1].end - stolen[1].start) {
+			base = stolen[0].start;
+			dev_priv->gtt.stolen_size = stolen[0].end - stolen[0].start;
+		} else {
+			base = stolen[1].start;
+			dev_priv->gtt.stolen_size = stolen[1].end - stolen[1].start;
+		}
+
+		if (stolen[0].start != stolen[1].start ||
+		    stolen[0].end != stolen[1].end) {
+			DRM_DEBUG_KMS("GTT within stolen memory at 0x%llx-0x%llx\n",
+				      (unsigned long long) gtt_start,
+				      (unsigned long long) gtt_end - 1);
+			DRM_DEBUG_KMS("Stolen memory adjusted to 0x%x-0x%x\n",
+				      base, base + (u32) dev_priv->gtt.stolen_size - 1);
+		}
+	}
+
+
 	/* Verify that nothing else uses this physical address. Stolen
 	 * memory should be reserved by the BIOS and hidden from the
 	 * kernel. So if the region is already marked as busy, something
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 9a1a96a..7047e35 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -628,6 +628,9 @@
 /*
  * Instruction and interrupt control regs
  */
+#define PGTBL_CTL	0x02020
+#define   PGTBL_ADDRESS_LO_MASK	0xfffff000 /* bits [31:12] */
+#define   PGTBL_ADDRESS_HI_MASK	0x000000f0 /* bits [35:32] (gen4) */
 #define PGTBL_ER	0x02024
 #define RENDER_RING_BASE	0x02000
 #define BSD_RING_BASE		0x04000
-- 
1.9.1

