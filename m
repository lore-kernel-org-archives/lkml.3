Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3CDBy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:54:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36458 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3CDBy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:54:27 -0500
MIME-Version: 1.0
Date: Mon, 4 Mar 2013 09:54:26 +0800
Message-ID: <CAFNq8R7tq9kvD9LyhZJ-Cj0kexQfDsPhB4iQYyZ9s9+8Jo82QA@mail.gmail.com>
Subject: [PATCH] mm: Fixup the condition whether the page cache is free
From: Li Haifeng <omycle@gmail.com>
To: "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a page cache is to reclaim, we should to decide whether the page
cache is free.
IMO, the condition whether a page cache is free should be 3 in page
frame reclaiming. The reason lists as below.

When page is allocated, the page->_count is 1(code fragment is code-1 ).
And when the page is allocated for reading files from extern disk, the
page->_count will increment 1 by page_cache_get() in
add_to_page_cache_locked()(code fragment is code-2). When the page is to
reclaim, the isolated LRU list also increase the page->_count(code
fragment is code-3).

According above reasons, when the file page is freeable, the
page->_count should be 3 instead of 2.

<code-1>
buffered_rmqueue ->prep_new_page->set_page_refcounted:
24 /*
25  * Turn a non-refcounted page (->_count == 0) into refcounted with
26  * a count of one.
27  */
28 static inline void set_page_refcounted(struct page *page)
29 {
30         VM_BUG_ON(PageTail(page));
31         VM_BUG_ON(atomic_read(&page->_count));
32         set_page_count(page, 1);
33 }

<code-2>
do_generic_file_read ->add_to_page_cache_lru-> add_to_page_cache->
add_to_page_cache_locked:
int add_to_page_cache_locked(struct page *page, struct address_space
*mapping,
                pgoff_t offset, gfp_t gfp_mask)
{
…
           page_cache_get(page);
                page->mapping = mapping;
                page->index = offset;

                spin_lock_irq(&mapping->tree_lock);
                error = radix_tree_insert(&mapping->page_tree, offset,
page);
                if (likely(!error)) {
                        mapping->nrpages++;
                        __inc_zone_page_state(page, NR_FILE_PAGES);
                        spin_unlock_irq(&mapping->tree_lock);
…
}
<code-3>
static noinline_for_stack unsigned long
shrink_inactive_list(unsigned long nr_to_scan, struct mem_cgroup_zone
*mz,
                     struct scan_control *sc, int priority, int file)
{
…
       nr_taken = isolate_lru_pages(nr_to_scan, mz, &page_list,
&nr_scanned,
                                     sc, isolate_mode, 0, file);
…
	   nr_reclaimed = shrink_page_list(&page_list, mz, sc, priority,
                                                &nr_dirty,
&nr_writeback);
}
Remarks for code-3:
isolate_lru_pages() will call get_page_unless_zero() ultimately to
increase the page->_count by 1.
And shrink_page_list() will call is_page_cache_freeable() finally to
check whether the page cache is free.

>From 59b25b5e0163dcb120d913b570c1b8b5b0c47c5d Mon Sep 17 00:00:00 2001
From: Haifeng Li <hfli@marvell.com>
Date: Mon, 4 Mar 2013 09:42:53 +0800
Subject: [PATCH] mm: Fixup the condition whether the page cache is free

When a page is allocated, its reference is 1. If the page is
inserted into page cache tree, the referenced also should be
increased by 1. In reclaiming routine, it also referenced by
isolated list. So here, the condition whether the page is free
should be 3.

Signed-off-by: Haifeng Li <omycle@gmail.com>
---
 mm/vmscan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6759993..b588378 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -400,11 +400,12 @@ static void reset_reclaim_mode(struct scan_control *sc)
 static inline int is_page_cache_freeable(struct page *page)
 {
        /*
-        * A freeable page cache page is referenced only by the caller
-        * that isolated the page, the page cache radix tree and
-        * optional buffer heads at page->private.
+        * A freeable page cache page, _count of which is
+        * initialized by 1. And it is also referenced only
+        * by the caller that isolated the page, the page cache
+        * radix tree and optional buffer heads at page->private.
         */
-       return page_count(page) - page_has_private(page) == 2;
+       return page_count(page) - page_has_private(page) == 3;
 }

 static int may_write_to_queue(struct backing_dev_info *bdi,
--
1.7.9.5
