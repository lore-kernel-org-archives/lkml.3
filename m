Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaG1LVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:21:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38370 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaG1LVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:21:00 -0400
Date: Mon, 28 Jul 2014 13:20:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] work around warning in i915_gem_gtt
Message-ID: <20140728112058.GA17504@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gcc warns that addr might be used uninitialized. It may not, but I see
why gcc gets confused.

Additionally, hiding code with side-effects inside WARN_ON() argument
seems uncool, so I moved it outside.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 8b3cde7..8fcc974 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -1448,7 +1448,7 @@ static void gen6_ggtt_insert_entries(struct i915_address_space *vm,
 		(gen6_gtt_pte_t __iomem *)dev_priv->gtt.gsm + first_entry;
 	int i = 0;
 	struct sg_page_iter sg_iter;
-	dma_addr_t addr;
+	dma_addr_t addr = 0;
 
 	for_each_sg_page(st->sgl, &sg_iter, st->nents, 0) {
 		addr = sg_page_iter_dma_address(&sg_iter);
@@ -1462,9 +1462,10 @@ static void gen6_ggtt_insert_entries(struct i915_address_space *vm,
 	 * of NUMA access patterns. Therefore, even with the way we assume
 	 * hardware should work, we must keep this posting read for paranoia.
 	 */
-	if (i != 0)
-		WARN_ON(readl(&gtt_entries[i-1]) !=
-			vm->pte_encode(addr, level, true));
+	if (i != 0) {
+		unsigned long gtt = readl(&gtt_entries[i-1]);
+		WARN_ON(gtt != vm->pte_encode(addr, level, true));
+	}
 
 	/* This next bit makes the above posting read even more important. We
 	 * want to flush the TLBs only after we're certain all the PTE updates

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
