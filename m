Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966724Ab3HIKWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:22:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40725 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965879Ab3HIKWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:22:36 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-0f-5204c2e97c6c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCH v2 2/4] mm: split code for unusing swap entries from
 try_to_unuse
Date: Fri, 09 Aug 2013 12:22:18 +0200
Message-id: <1376043740-10576-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com>
References: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Nd2Xh1iCDCb90rWYs34Nm8XGGetZ
	LT69fMBo8fqFocXZpjfsFpd3zWGzuLfmP6vF2iN32S0mv3vGaHFo3yp2By6PxXteMnls+jSJ
	3ePEjN8sHg8ObWbx6NuyitFj8+lqj8+b5ALYo7hsUlJzMstSi/TtErgyug80MhZcSqm4snU9
	ewPjFd8uRk4OCQETiY7HZ9kgbDGJC/fWA9lcHEICSxklrnx9AZYQEuhjkli2BqyBTcBYYvPy
	JWBxEYE+RolJly1AGpgFepgk3r+ZzNjFyMEhLBAucXx3OUgNi4CqxMqGSUwgNq+Au8TM3z+Y
	QEokBBQk5kyyAQlzCnhI3H1zgBlilbvEu33zGCcw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqX
	rpecn7uJERKAX3YwLj5mdYhRgINRiYf3xBbmICHWxLLiytxDjBIczEoivNsnsAQJ8aYkVlal
	FuXHF5XmpBYfYmTi4JRqYOwU17OTf/R0sVvFjkk8R69s+6RQWCF370DU/l0NChtiGXWb96eU
	qXgycileXGxscqBcYI746yV3YlcfE0iyKsi217a+Wv43RuragYspJewzL6/O0nZ+eyapnz3w
	QHxAeYVr4uLJZYpFZ/rlFllwfBSapuVsO7+8MlX9f1iRFlP50rCd10P1lFiKMxINtZiLihMB
	pXlTyh4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move out the code for unusing swap entries from loop in try_to_unuse()
to separate function: try_to_unuse_swp_entry(). Export this new function
in swapfile.h just like try_to_unuse() is exported.

This new function will be used for unusing swap entries from subsystems
(e.g. zswap).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/swapfile.h |    2 +
 mm/swapfile.c            |  356 ++++++++++++++++++++++++----------------------
 2 files changed, 189 insertions(+), 169 deletions(-)

diff --git a/include/linux/swapfile.h b/include/linux/swapfile.h
index e282624..68c24a7 100644
--- a/include/linux/swapfile.h
+++ b/include/linux/swapfile.h
@@ -9,5 +9,7 @@ extern spinlock_t swap_lock;
 extern struct swap_list_t swap_list;
 extern struct swap_info_struct *swap_info[];
 extern int try_to_unuse(unsigned int, bool, unsigned long);
+extern int try_to_unuse_swp_entry(struct mm_struct **start_mm,
+		struct swap_info_struct *si, swp_entry_t entry);
 
 #endif /* _LINUX_SWAPFILE_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 36af6ee..4ba21ec 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1100,6 +1100,190 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 }
 
 /*
+ * Returns:
+ *  - negative on error,
+ *  - 0 on success (entry unused, freed independently or shmem entry
+ *			already released)
+ */
+int try_to_unuse_swp_entry(struct mm_struct **start_mm,
+		struct swap_info_struct *si, swp_entry_t entry)
+{
+	pgoff_t offset = swp_offset(entry);
+	unsigned char *swap_map;
+	unsigned char swcount;
+	struct page *page;
+	int retval = 0;
+
+	if (signal_pending(current)) {
+		retval = -EINTR;
+		goto out;
+	}
+
+	/*
+	 * Get a page for the entry, using the existing swap
+	 * cache page if there is one.  Otherwise, get a clean
+	 * page and read the swap into it.
+	 */
+	swap_map = &si->swap_map[offset];
+	page = read_swap_cache_async(entry,
+				GFP_HIGHUSER_MOVABLE, NULL, 0);
+	if (!page) {
+		/*
+		 * Either swap_duplicate() failed because entry
+		 * has been freed independently, and will not be
+		 * reused since sys_swapoff() already disabled
+		 * allocation from here, or alloc_page() failed.
+		 */
+		if (!*swap_map)
+			retval = 0;
+		else
+			retval = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * Don't hold on to start_mm if it looks like exiting.
+	 */
+	if (atomic_read(&(*start_mm)->mm_users) == 1) {
+		mmput(*start_mm);
+		*start_mm = &init_mm;
+		atomic_inc(&init_mm.mm_users);
+	}
+
+	/*
+	 * Wait for and lock page.  When do_swap_page races with
+	 * try_to_unuse, do_swap_page can handle the fault much
+	 * faster than try_to_unuse can locate the entry.  This
+	 * apparently redundant "wait_on_page_locked" lets try_to_unuse
+	 * defer to do_swap_page in such a case - in some tests,
+	 * do_swap_page and try_to_unuse repeatedly compete.
+	 */
+	wait_on_page_locked(page);
+	wait_on_page_writeback(page);
+	lock_page(page);
+	wait_on_page_writeback(page);
+
+	/*
+	 * Remove all references to entry.
+	 */
+	swcount = *swap_map;
+	if (swap_count(swcount) == SWAP_MAP_SHMEM) {
+		retval = shmem_unuse(entry, page);
+		VM_BUG_ON(retval > 0);
+		/* page has already been unlocked and released */
+		goto out;
+	}
+	if (swap_count(swcount) && *start_mm != &init_mm)
+		retval = unuse_mm(*start_mm, entry, page);
+
+	if (swap_count(*swap_map)) {
+		int set_start_mm = (*swap_map >= swcount);
+		struct list_head *p = &(*start_mm)->mmlist;
+		struct mm_struct *new_start_mm = *start_mm;
+		struct mm_struct *prev_mm = *start_mm;
+		struct mm_struct *mm;
+
+		atomic_inc(&new_start_mm->mm_users);
+		atomic_inc(&prev_mm->mm_users);
+		spin_lock(&mmlist_lock);
+		while (swap_count(*swap_map) && !retval &&
+				(p = p->next) != &(*start_mm)->mmlist) {
+			mm = list_entry(p, struct mm_struct, mmlist);
+			if (!atomic_inc_not_zero(&mm->mm_users))
+				continue;
+			spin_unlock(&mmlist_lock);
+			mmput(prev_mm);
+			prev_mm = mm;
+
+			cond_resched();
+
+			swcount = *swap_map;
+			if (!swap_count(swcount)) /* any usage ? */
+				;
+			else if (mm == &init_mm)
+				set_start_mm = 1;
+			else
+				retval = unuse_mm(mm, entry, page);
+
+			if (set_start_mm && *swap_map < swcount) {
+				mmput(new_start_mm);
+				atomic_inc(&mm->mm_users);
+				new_start_mm = mm;
+				set_start_mm = 0;
+			}
+			spin_lock(&mmlist_lock);
+		}
+		spin_unlock(&mmlist_lock);
+		mmput(prev_mm);
+		mmput(*start_mm);
+		*start_mm = new_start_mm;
+	}
+	if (retval) {
+		unlock_page(page);
+		page_cache_release(page);
+		goto out;
+	}
+
+	/*
+	 * If a reference remains (rare), we would like to leave
+	 * the page in the swap cache; but try_to_unmap could
+	 * then re-duplicate the entry once we drop page lock,
+	 * so we might loop indefinitely; also, that page could
+	 * not be swapped out to other storage meanwhile.  So:
+	 * delete from cache even if there's another reference,
+	 * after ensuring that the data has been saved to disk -
+	 * since if the reference remains (rarer), it will be
+	 * read from disk into another page.  Splitting into two
+	 * pages would be incorrect if swap supported "shared
+	 * private" pages, but they are handled by tmpfs files.
+	 *
+	 * Given how unuse_vma() targets one particular offset
+	 * in an anon_vma, once the anon_vma has been determined,
+	 * this splitting happens to be just what is needed to
+	 * handle where KSM pages have been swapped out: re-reading
+	 * is unnecessarily slow, but we can fix that later on.
+	 */
+	if (swap_count(*swap_map) &&
+	     PageDirty(page) && PageSwapCache(page)) {
+		struct writeback_control wbc = {
+			.sync_mode = WB_SYNC_NONE,
+		};
+
+		swap_writepage(page, &wbc);
+		lock_page(page);
+		wait_on_page_writeback(page);
+	}
+
+	/*
+	 * It is conceivable that a racing task removed this page from
+	 * swap cache just before we acquired the page lock at the top,
+	 * or while we dropped it in unuse_mm().  The page might even
+	 * be back in swap cache on another swap area: that we must not
+	 * delete, since it may not have been written out to swap yet.
+	 */
+	if (PageSwapCache(page) &&
+	    likely(page_private(page) == entry.val))
+		delete_from_swap_cache(page);
+
+	/*
+	 * So we could skip searching mms once swap count went
+	 * to 1, we did not mark any present ptes as dirty: must
+	 * mark page dirty so shrink_page_list will preserve it.
+	 */
+	SetPageDirty(page);
+	unlock_page(page);
+	page_cache_release(page);
+
+	/*
+	 * Make sure that we aren't completely killing
+	 * interactive performance.
+	 */
+	cond_resched();
+out:
+	return retval;
+}
+
+/*
  * We completely avoid races by reading each swap page in advance,
  * and then search for the process using it.  All the necessary
  * page table adjustments can then be made atomically.
@@ -1112,10 +1296,6 @@ int try_to_unuse(unsigned int type, bool frontswap,
 {
 	struct swap_info_struct *si = swap_info[type];
 	struct mm_struct *start_mm;
-	unsigned char *swap_map;
-	unsigned char swcount;
-	struct page *page;
-	swp_entry_t entry;
 	unsigned int i = 0;
 	int retval = 0;
 
@@ -1142,172 +1322,10 @@ int try_to_unuse(unsigned int type, bool frontswap,
 	 * there are races when an instance of an entry might be missed.
 	 */
 	while ((i = find_next_to_unuse(si, i, frontswap)) != 0) {
-		if (signal_pending(current)) {
-			retval = -EINTR;
-			break;
-		}
-
-		/*
-		 * Get a page for the entry, using the existing swap
-		 * cache page if there is one.  Otherwise, get a clean
-		 * page and read the swap into it.
-		 */
-		swap_map = &si->swap_map[i];
-		entry = swp_entry(type, i);
-		page = read_swap_cache_async(entry,
-					GFP_HIGHUSER_MOVABLE, NULL, 0);
-		if (!page) {
-			/*
-			 * Either swap_duplicate() failed because entry
-			 * has been freed independently, and will not be
-			 * reused since sys_swapoff() already disabled
-			 * allocation from here, or alloc_page() failed.
-			 */
-			if (!*swap_map)
-				continue;
-			retval = -ENOMEM;
-			break;
-		}
-
-		/*
-		 * Don't hold on to start_mm if it looks like exiting.
-		 */
-		if (atomic_read(&start_mm->mm_users) == 1) {
-			mmput(start_mm);
-			start_mm = &init_mm;
-			atomic_inc(&init_mm.mm_users);
-		}
-
-		/*
-		 * Wait for and lock page.  When do_swap_page races with
-		 * try_to_unuse, do_swap_page can handle the fault much
-		 * faster than try_to_unuse can locate the entry.  This
-		 * apparently redundant "wait_on_page_locked" lets try_to_unuse
-		 * defer to do_swap_page in such a case - in some tests,
-		 * do_swap_page and try_to_unuse repeatedly compete.
-		 */
-		wait_on_page_locked(page);
-		wait_on_page_writeback(page);
-		lock_page(page);
-		wait_on_page_writeback(page);
-
-		/*
-		 * Remove all references to entry.
-		 */
-		swcount = *swap_map;
-		if (swap_count(swcount) == SWAP_MAP_SHMEM) {
-			retval = shmem_unuse(entry, page);
-			/* page has already been unlocked and released */
-			if (retval < 0)
-				break;
-			continue;
-		}
-		if (swap_count(swcount) && start_mm != &init_mm)
-			retval = unuse_mm(start_mm, entry, page);
-
-		if (swap_count(*swap_map)) {
-			int set_start_mm = (*swap_map >= swcount);
-			struct list_head *p = &start_mm->mmlist;
-			struct mm_struct *new_start_mm = start_mm;
-			struct mm_struct *prev_mm = start_mm;
-			struct mm_struct *mm;
-
-			atomic_inc(&new_start_mm->mm_users);
-			atomic_inc(&prev_mm->mm_users);
-			spin_lock(&mmlist_lock);
-			while (swap_count(*swap_map) && !retval &&
-					(p = p->next) != &start_mm->mmlist) {
-				mm = list_entry(p, struct mm_struct, mmlist);
-				if (!atomic_inc_not_zero(&mm->mm_users))
-					continue;
-				spin_unlock(&mmlist_lock);
-				mmput(prev_mm);
-				prev_mm = mm;
-
-				cond_resched();
-
-				swcount = *swap_map;
-				if (!swap_count(swcount)) /* any usage ? */
-					;
-				else if (mm == &init_mm)
-					set_start_mm = 1;
-				else
-					retval = unuse_mm(mm, entry, page);
-
-				if (set_start_mm && *swap_map < swcount) {
-					mmput(new_start_mm);
-					atomic_inc(&mm->mm_users);
-					new_start_mm = mm;
-					set_start_mm = 0;
-				}
-				spin_lock(&mmlist_lock);
-			}
-			spin_unlock(&mmlist_lock);
-			mmput(prev_mm);
-			mmput(start_mm);
-			start_mm = new_start_mm;
-		}
-		if (retval) {
-			unlock_page(page);
-			page_cache_release(page);
+		retval = try_to_unuse_swp_entry(&start_mm, si,
+				swp_entry(type, i));
+		if (retval != 0)
 			break;
-		}
-
-		/*
-		 * If a reference remains (rare), we would like to leave
-		 * the page in the swap cache; but try_to_unmap could
-		 * then re-duplicate the entry once we drop page lock,
-		 * so we might loop indefinitely; also, that page could
-		 * not be swapped out to other storage meanwhile.  So:
-		 * delete from cache even if there's another reference,
-		 * after ensuring that the data has been saved to disk -
-		 * since if the reference remains (rarer), it will be
-		 * read from disk into another page.  Splitting into two
-		 * pages would be incorrect if swap supported "shared
-		 * private" pages, but they are handled by tmpfs files.
-		 *
-		 * Given how unuse_vma() targets one particular offset
-		 * in an anon_vma, once the anon_vma has been determined,
-		 * this splitting happens to be just what is needed to
-		 * handle where KSM pages have been swapped out: re-reading
-		 * is unnecessarily slow, but we can fix that later on.
-		 */
-		if (swap_count(*swap_map) &&
-		     PageDirty(page) && PageSwapCache(page)) {
-			struct writeback_control wbc = {
-				.sync_mode = WB_SYNC_NONE,
-			};
-
-			swap_writepage(page, &wbc);
-			lock_page(page);
-			wait_on_page_writeback(page);
-		}
-
-		/*
-		 * It is conceivable that a racing task removed this page from
-		 * swap cache just before we acquired the page lock at the top,
-		 * or while we dropped it in unuse_mm().  The page might even
-		 * be back in swap cache on another swap area: that we must not
-		 * delete, since it may not have been written out to swap yet.
-		 */
-		if (PageSwapCache(page) &&
-		    likely(page_private(page) == entry.val))
-			delete_from_swap_cache(page);
-
-		/*
-		 * So we could skip searching mms once swap count went
-		 * to 1, we did not mark any present ptes as dirty: must
-		 * mark page dirty so shrink_page_list will preserve it.
-		 */
-		SetPageDirty(page);
-		unlock_page(page);
-		page_cache_release(page);
-
-		/*
-		 * Make sure that we aren't completely killing
-		 * interactive performance.
-		 */
-		cond_resched();
 		if (frontswap && pages_to_unuse > 0) {
 			if (!--pages_to_unuse)
 				break;
-- 
1.7.9.5

