Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3FXPsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:48:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22255 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3FXPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:48:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: dri-devel@lists.freedesktop.org, chris@chris-wilson.co.uk,
        imre.deak@intel.com, daniel.vetter@ffwll.ch, airlied@linux.ie,
        airlied@gmail.com
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] drm/i915: make compact dma scatter lists creation work with SWIOTLB backend.
Date: Mon, 24 Jun 2013 11:47:48 -0400
Message-Id: <1372088868-23477-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1372088868-23477-1-git-send-email-konrad.wilk@oracle.com>
References: <1372088868-23477-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git commit 90797e6d1ec0dfde6ba62a48b9ee3803887d6ed4
("drm/i915: create compact dma scatter lists for gem objects") makes
certain assumptions about the under laying DMA API that are not always
correct.

On a ThinkPad X230 with an Intel HD 4000 with Xen during the bootup
I see:

[drm:intel_pipe_set_base] *ERROR* pin & fence failed
[drm:intel_crtc_set_config] *ERROR* failed to set mode on [CRTC:3], err = -28

Bit of debugging traced it down to dma_map_sg failing (in
i915_gem_gtt_prepare_object) as some of the SG entries were huge (3MB).

That unfortunately are sizes that the SWIOTLB is incapable of handling -
the maximum it can handle is a an entry of 512KB of virtual contiguous
memory for its bounce buffer. (See IO_TLB_SEGSIZE).

Previous to the above mention git commit the SG entries were of 4KB, and
the code introduced by above git commit squashed the CPU contiguous PFNs
in one big virtual address provided to DMA API.

This patch is a simple semi-revert - were we emulate the old behavior
if we detect that SWIOTLB is online. If it is not online then we continue
on with the new compact scatter gather mechanism.

An alternative solution would be for the the '.get_pages' and the
i915_gem_gtt_prepare_object to retry with smaller max gap of the
amount of PFNs that can be combined together - but with this issue
discovered during rc7 that might be too risky.

Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Chris Wilson <chris@chris-wilson.co.uk>
CC: Imre Deak <imre.deak@intel.com>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: David Airlie <airlied@linux.ie>
CC: <dri-devel@lists.freedesktop.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 970ad17..7045f45 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1801,7 +1801,14 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 			gfp |= __GFP_NORETRY | __GFP_NOWARN | __GFP_NO_KSWAPD;
 			gfp &= ~(__GFP_IO | __GFP_WAIT);
 		}
-
+#ifdef CONFIG_SWIOTLB
+		if (swiotlb_nr_tbl()) {
+			st->nents++;
+			sg_set_page(sg, page, PAGE_SIZE, 0);
+			sg = sg_next(sg);
+			continue;
+		}
+#endif
 		if (!i || page_to_pfn(page) != last_pfn + 1) {
 			if (i)
 				sg = sg_next(sg);
@@ -1812,8 +1819,10 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 		}
 		last_pfn = page_to_pfn(page);
 	}
-
-	sg_mark_end(sg);
+#ifdef CONFIG_SWIOTLB
+	if (!swiotlb_nr_tbl())
+#endif
+		sg_mark_end(sg);
 	obj->pages = st;
 
 	if (i915_gem_object_needs_bit17_swizzle(obj))
-- 
1.8.1.4

