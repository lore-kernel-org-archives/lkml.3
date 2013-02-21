Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3BUI2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:28:21 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38378 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3BUI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:28:20 -0500
Date: Thu, 21 Feb 2013 00:27:39 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 6/7] mm: cleanup "swapcache" in do_swap_page
In-Reply-To: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils>
Message-ID: <alpine.LNX.2.00.1302210025480.17843@eggly.anvils>
References: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I dislike the way in which "swapcache" gets used in do_swap_page():
there is always a page from swapcache there (even if maybe uncached
by the time we lock it), but tests are made according to "swapcache".
Rework that with "page != swapcache", as has been done in unuse_pte().

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/memory.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- mmotm.orig/mm/memory.c	2013-02-20 22:43:47.228023344 -0800
+++ mmotm/mm/memory.c	2013-02-20 23:21:00.304076416 -0800
@@ -2954,7 +2954,7 @@ static int do_swap_page(struct mm_struct
 		unsigned int flags, pte_t orig_pte)
 {
 	spinlock_t *ptl;
-	struct page *page, *swapcache = NULL;
+	struct page *page, *swapcache;
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
@@ -3005,9 +3005,11 @@ static int do_swap_page(struct mm_struct
 		 */
 		ret = VM_FAULT_HWPOISON;
 		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+		swapcache = page;
 		goto out_release;
 	}
 
+	swapcache = page;
 	locked = lock_page_or_retry(page, mm, flags);
 
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
@@ -3025,16 +3027,12 @@ static int do_swap_page(struct mm_struct
 	if (unlikely(!PageSwapCache(page) || page_private(page) != entry.val))
 		goto out_page;
 
-	swapcache = page;
 	page = ksm_might_need_to_copy(page, vma, address);
 	if (unlikely(!page)) {
 		ret = VM_FAULT_OOM;
 		page = swapcache;
-		swapcache = NULL;
 		goto out_page;
 	}
-	if (page == swapcache)
-		swapcache = NULL;
 
 	if (mem_cgroup_try_charge_swapin(mm, page, GFP_KERNEL, &ptr)) {
 		ret = VM_FAULT_OOM;
@@ -3078,10 +3076,10 @@ static int do_swap_page(struct mm_struct
 	}
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
-	if (swapcache) /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, address);
-	else
+	if (page == swapcache)
 		do_page_add_anon_rmap(page, vma, address, exclusive);
+	else /* ksm created a completely new copy */
+		page_add_new_anon_rmap(page, vma, address);
 	/* It's better to call commit-charge after rmap is established */
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
@@ -3089,7 +3087,7 @@ static int do_swap_page(struct mm_struct
 	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
 		try_to_free_swap(page);
 	unlock_page(page);
-	if (swapcache) {
+	if (page != swapcache) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -3122,7 +3120,7 @@ out_page:
 	unlock_page(page);
 out_release:
 	page_cache_release(page);
-	if (swapcache) {
+	if (page != swapcache) {
 		unlock_page(swapcache);
 		page_cache_release(swapcache);
 	}
