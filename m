Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbaGVTBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:01:39 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:41063 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaGVTBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:01:33 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        linux-kernel@vger.kernel.org,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        David Rientjes <rientjes@google.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 6/8] mm/highmem: make kmap cache coloring aware
Date: Tue, 22 Jul 2014 23:01:11 +0400
Message-Id: <1406055673-10100-7-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
References: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>

Provide hooks that allow architectures with aliasing cache to align
mapping address of high pages according to their color. Such architectures
may enforce similar coloring of low- and high-memory page mappings and
reuse existing cache management functions to support highmem.

Cc: linux-mm@kvack.org
Cc: linux-arch@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
[ Max: extract architecture-independent part of the original patch, clean
  up checkpatch and build warnings. ]
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
Changes since the initial version:
- define set_pkmap_color(pg, cl) as do { } while (0) instead of /* */;
- rename is_no_more_pkmaps to no_more_pkmaps;
- change 'if (count > 0)' to 'if (count)' to better match the original
  code behavior;

 mm/highmem.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index b32b70c..88fb62e 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -44,6 +44,14 @@ DEFINE_PER_CPU(int, __kmap_atomic_idx);
  */
 #ifdef CONFIG_HIGHMEM
 
+#ifndef ARCH_PKMAP_COLORING
+#define set_pkmap_color(pg, cl)		do { } while (0)
+#define get_last_pkmap_nr(p, cl)	(p)
+#define get_next_pkmap_nr(p, cl)	(((p) + 1) & LAST_PKMAP_MASK)
+#define no_more_pkmaps(p, cl)		(!(p))
+#define get_next_pkmap_counter(c, cl)	((c) - 1)
+#endif
+
 unsigned long totalhigh_pages __read_mostly;
 EXPORT_SYMBOL(totalhigh_pages);
 
@@ -161,19 +169,24 @@ static inline unsigned long map_new_virtual(struct page *page)
 {
 	unsigned long vaddr;
 	int count;
+	int color __maybe_unused;
+
+	set_pkmap_color(page, color);
+	last_pkmap_nr = get_last_pkmap_nr(last_pkmap_nr, color);
 
 start:
 	count = LAST_PKMAP;
 	/* Find an empty entry */
 	for (;;) {
-		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
-		if (!last_pkmap_nr) {
+		last_pkmap_nr = get_next_pkmap_nr(last_pkmap_nr, color);
+		if (no_more_pkmaps(last_pkmap_nr, color)) {
 			flush_all_zero_pkmaps();
 			count = LAST_PKMAP;
 		}
 		if (!pkmap_count[last_pkmap_nr])
 			break;	/* Found a usable entry */
-		if (--count)
+		count = get_next_pkmap_counter(count, color);
+		if (count)
 			continue;
 
 		/*
-- 
1.8.1.4

