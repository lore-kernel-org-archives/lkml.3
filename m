Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693AbaGQQVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:21:04 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:48063 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934471AbaGQQVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:21:01 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-mm@kvack.org
Cc: linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] mm/highmem.c: make kmap cache coloring aware
Date: Thu, 17 Jul 2014 20:20:35 +0400
Message-Id: <1405614035-11413-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>

Provide hooks that allow architectures with aliasing cache to align
mapping address of high pages according to their color.

Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
[ Max: extract architecture-independent part of the original patch, clean
  up checkpatch and build warnings. ]
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 mm/highmem.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index b32b70c..6898a8b 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -44,6 +44,14 @@ DEFINE_PER_CPU(int, __kmap_atomic_idx);
  */
 #ifdef CONFIG_HIGHMEM
 
+#ifndef ARCH_PKMAP_COLORING
+#define set_pkmap_color(pg, cl)		/* */
+#define get_last_pkmap_nr(p, cl)	(p)
+#define get_next_pkmap_nr(p, cl)	(((p) + 1) & LAST_PKMAP_MASK)
+#define is_no_more_pkmaps(p, cl)	(!(p))
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
+		if (is_no_more_pkmaps(last_pkmap_nr, color)) {
 			flush_all_zero_pkmaps();
 			count = LAST_PKMAP;
 		}
 		if (!pkmap_count[last_pkmap_nr])
 			break;	/* Found a usable entry */
-		if (--count)
+		count = get_next_pkmap_counter(count, color);
+		if (count > 0)
 			continue;
 
 		/*
-- 
1.8.1.4

