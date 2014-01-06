Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbaAFXrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:47:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530AbaAFWjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Sasha Levin <sasha.levin@oracle.com>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Bob Liu <bob.liu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 120/144] mm: munlock: fix a bug where THP tail page is encountered
Date: Mon,  6 Jan 2014 14:38:01 -0800
Message-Id: <20140106223748.786372734@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit c424be1cbbf852e46acc84d73162af3066cd2c86 upstream.

Since commit ff6a6da60b89 ("mm: accelerate munlock() treatment of THP
pages") munlock skips tail pages of a munlocked THP page.  However, when
the head page already has PageMlocked unset, it will not skip the tail
pages.

Commit 7225522bb429 ("mm: munlock: batch non-THP page isolation and
munlock+putback using pagevec") has added a PageTransHuge() check which
contains VM_BUG_ON(PageTail(page)).  Sasha Levin found this triggered
using trinity, on the first tail page of a THP page without PageMlocked
flag.

This patch fixes the issue by skipping tail pages also in the case when
PageMlocked flag is unset.  There is still a possibility of race with
THP page split between clearing PageMlocked and determining how many
pages to skip.  The race might result in former tail pages not being
skipped, which is however no longer a bug, as during the skip the
PageTail flags are cleared.

However this race also affects correctness of NR_MLOCK accounting, which
is to be fixed in a separate patch.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mlock.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -133,7 +133,10 @@ static void __munlock_isolation_failed(s
 
 /**
  * munlock_vma_page - munlock a vma page
- * @page - page to be unlocked
+ * @page - page to be unlocked, either a normal page or THP page head
+ *
+ * returns the size of the page as a page mask (0 for normal page,
+ *         HPAGE_PMD_NR - 1 for THP head page)
  *
  * called from munlock()/munmap() path with page supposedly on the LRU.
  * When we munlock a page, because the vma where we found the page is being
@@ -148,21 +151,30 @@ static void __munlock_isolation_failed(s
  */
 unsigned int munlock_vma_page(struct page *page)
 {
-	unsigned int page_mask = 0;
+	unsigned int nr_pages;
 
 	BUG_ON(!PageLocked(page));
 
 	if (TestClearPageMlocked(page)) {
-		unsigned int nr_pages = hpage_nr_pages(page);
+		nr_pages = hpage_nr_pages(page);
 		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
-		page_mask = nr_pages - 1;
 		if (!isolate_lru_page(page))
 			__munlock_isolated_page(page);
 		else
 			__munlock_isolation_failed(page);
+	} else {
+		nr_pages = hpage_nr_pages(page);
 	}
 
-	return page_mask;
+	/*
+	 * Regardless of the original PageMlocked flag, we determine nr_pages
+	 * after touching the flag. This leaves a possible race with a THP page
+	 * split, such that a whole THP page was munlocked, but nr_pages == 1.
+	 * Returning a smaller mask due to that is OK, the worst that can
+	 * happen is subsequent useless scanning of the former tail pages.
+	 * The NR_MLOCK accounting can however become broken.
+	 */
+	return nr_pages - 1;
 }
 
 /**
@@ -440,7 +452,8 @@ void munlock_vma_pages_range(struct vm_a
 
 	while (start < end) {
 		struct page *page = NULL;
-		unsigned int page_mask, page_increm;
+		unsigned int page_mask;
+		unsigned long page_increm;
 		struct pagevec pvec;
 		struct zone *zone;
 		int zoneid;
@@ -490,7 +503,9 @@ void munlock_vma_pages_range(struct vm_a
 				goto next;
 			}
 		}
-		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
+		/* It's a bug to munlock in the middle of a THP page */
+		VM_BUG_ON((start >> PAGE_SHIFT) & page_mask);
+		page_increm = 1 + page_mask;
 		start += page_increm * PAGE_SIZE;
 next:
 		cond_resched();


