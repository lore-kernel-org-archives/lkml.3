Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbaKSW0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:26:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbaKSUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        James Ausmus <james.ausmus@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 3.17 063/141] drm/i915: Disable caches for Global GTT.
Date: Wed, 19 Nov 2014 12:51:26 -0800
Message-Id: <20141119205152.737584518@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

commit d6a8b72edc92471283925ceb4ba12799b67c3ff8 upstream.

Global GTT doesn't have pat_sel[2:0] so it always point to pat_sel = 000;
So the only way to avoid screen corruptions is setting PAT 0 to Uncached.

MOCS can still be used though. But if userspace is trusting PTE for
cache selection the safest thing to do is to let caches disabled.

BSpec: "For GGTT, there is NO pat_sel[2:0] from the entry,
so RTL will always use the value corresponding to pat_sel = 000"

- System agent ggtt writes (i.e. cpu gtt mmaps) already work before
this patch, i.e. the same uncached + snooping access like on gen6/7
seems to be in effect.
- So this just fixes blitter/render access. Again it looks like it's
not just uncached access, but uncached + snooping. So we can still
hold onto all our assumptions wrt cpu clflushing on LLC machines.

v2: Cleaner patch as suggested by Chris.
v3: Add Daniel's comment

Reference: https://bugs.freedesktop.org/show_bug.cgi?id=85576
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: James Ausmus <james.ausmus@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@intel.com>
Tested-by: James Ausmus <james.ausmus@intel.com>
Reviewed-by: James Ausmus <james.ausmus@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_gtt.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -1901,6 +1901,22 @@ static void bdw_setup_private_ppat(struc
 	      GEN8_PPAT(6, GEN8_PPAT_WB | GEN8_PPAT_LLCELLC | GEN8_PPAT_AGE(2)) |
 	      GEN8_PPAT(7, GEN8_PPAT_WB | GEN8_PPAT_LLCELLC | GEN8_PPAT_AGE(3));
 
+	if (!USES_PPGTT(dev_priv->dev))
+		/* Spec: "For GGTT, there is NO pat_sel[2:0] from the entry,
+		 * so RTL will always use the value corresponding to
+		 * pat_sel = 000".
+		 * So let's disable cache for GGTT to avoid screen corruptions.
+		 * MOCS still can be used though.
+		 * - System agent ggtt writes (i.e. cpu gtt mmaps) already work
+		 * before this patch, i.e. the same uncached + snooping access
+		 * like on gen6/7 seems to be in effect.
+		 * - So this just fixes blitter/render access. Again it looks
+		 * like it's not just uncached access, but uncached + snooping.
+		 * So we can still hold onto all our assumptions wrt cpu
+		 * clflushing on LLC machines.
+		 */
+		pat = GEN8_PPAT(0, GEN8_PPAT_UC);
+
 	/* XXX: spec defines this as 2 distinct registers. It's unclear if a 64b
 	 * write would work. */
 	I915_WRITE(GEN8_PRIVATE_PAT, pat);


