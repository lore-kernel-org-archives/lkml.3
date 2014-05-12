Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbaELRhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:37:42 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63582 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaELRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:37:41 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: cl@linux.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, nasa4836@gmail.com,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/3] mm: add comment for __mod_zone_page_stat
Date: Tue, 13 May 2014 01:36:53 +0800
Message-Id: <1399916213-27071-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Preemption is mis-spelled throughout.
>
>Otherwise
>
>Reviewed-by: Christoph Lameter <cl@linux.com>

 Oops, corrected. Thanks.

-----<8-----
>From 1d0a080429542accfeac7de03e159a0bea12abba Mon Sep 17 00:00:00 2001
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 13 May 2014 00:19:08 +0800
Subject: [PATCH] mm: use the light version __mod_zone_page_state in
 mlocked_vma_newpage()

mlocked_vma_newpage() is called with pte lock held(a spinlock), which
implies preemtion disabled, and the vm stat counter is not modified from
interrupt context, so we need not use an irq-safe mod_zone_page_state() here,
using a light-weight version __mod_zone_page_state() would be OK.

This patch also documents __mod_zone_page_state() and some of its
callsites. The comment above __mod_zone_page_state() is from Hugh
Dickins, and acked by Christoph.

Most credits to Hugh and Christoph for the clarification on the usage of
the __mod_zone_page_state().

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/internal.h | 7 ++++++-
 mm/rmap.c     | 9 +++++++++
 mm/vmstat.c   | 4 +++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 07b6736..d6a4868 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -196,7 +196,12 @@ static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
 		return 0;
 
 	if (!TestSetPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK,
+		/*
+		 * We use the irq-unsafe __mod_zone_page_stat because
+		 * this counter is not modified from interrupt context, and the
+		 * pte lock is held(spinlock), which implies preemption disabled.
+		 */
+		__mod_zone_page_state(page_zone(page), NR_MLOCK,
 				    hpage_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 	}
diff --git a/mm/rmap.c b/mm/rmap.c
index 9c3e773..fa73194 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -986,6 +986,11 @@ void do_page_add_anon_rmap(struct page *page,
 {
 	int first = atomic_inc_and_test(&page->_mapcount);
 	if (first) {
+		/*
+		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
+		 * these counters are not modified from interrupt context, and
+		 * pte lock(a spinlock) is held, which implies preemption disabled.
+		 */
 		if (PageTransHuge(page))
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
@@ -1077,6 +1082,10 @@ void page_remove_rmap(struct page *page)
 	/*
 	 * Hugepages are not counted in NR_ANON_PAGES nor NR_FILE_MAPPED
 	 * and not charged by memcg for now.
+	 *
+	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
+	 * these counters are not modified from interrupt context, and
+	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
 	if (unlikely(PageHuge(page)))
 		goto out;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 302dd07..704928e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -207,7 +207,9 @@ void set_pgdat_percpu_threshold(pg_data_t *pgdat,
 }
 
 /*
- * For use when we know that interrupts are disabled.
+ * For use when we know that interrupts are disabled,
+ * or when we know that preemption is disabled and that
+ * particular counter cannot be updated from interrupt context.
  */
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 				int delta)
-- 
2.0.0-rc1

