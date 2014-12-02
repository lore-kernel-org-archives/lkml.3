Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaLBIcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:32:19 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:56562 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaLBIaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:30:20 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
CC: David Rientjes <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v5 4/8] mm/hugetlb: fix getting refcount 0 page in
 hugetlb_fault()
Thread-Topic: [PATCH v5 4/8] mm/hugetlb: fix getting refcount 0 page in
 hugetlb_fault()
Thread-Index: AQHQDgmxRbwqv2I5b0OTht1lz07Irw==
Date: Tue, 2 Dec 2014 08:26:39 +0000
Message-ID: <1417508759-10848-5-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1417508759-10848-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1417508759-10848-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.13]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running the test which causes the race as shown in the previous patch,
we can hit the BUG "get_page() on refcount 0 page" in hugetlb_fault().

This race happens when pte turns into migration entry just after the first
check of is_hugetlb_entry_migration() in hugetlb_fault() passed with false.
To fix this, we need to check pte_present() again after huge_ptep_get().

This patch also reorders taking ptl and doing pte_page(), because pte_page()
should be done in ptl. Due to this reordering, we need use trylock_page()
in page != pagecache_page case to respect locking order.

Fixes: 66aebce747ea ("hugetlb: fix race condition in hugetlb_fault()")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>  # [3.2+]
---
ChangeLog v5:
- add comment to justify calling wait_on_page_locked without taking refcount
- remove stale comment about lock order

ChangeLog v4:
- move !pte_present(entry) (i.e. migration/hwpoison) check before
  taking page table lock
- call wait_on_page_locked() if trylock_page() returns false
- remove unused label out_unlock_page
- fix the order of put_page() and unlock_page() after out_put_page label
- move changelog under '---'

Hugh advised me for ver.3 that we can call migration_entry_wait_huge()
when the !pte_present(entry) check returns true to avoid busy faulting.
But it seems that in that case only one additional page fault happens
instead of busy faulting, because is_hugetlb_entry_migration() in the
second call of hugetlb_fault() should return true and then
migration_entry_wait_huge() is called. We could avoid this additional
page fault by adding another migration_entry_wait_huge(), but then
we should separate pte_present() check into is_hugetlb_entry_migration()
path and is_hugetlb_entry_hwpoisoned() path, which makes code complicated.
So let me take the simpler approach for sending stable tree.
And it's also advised that we can clean up is_hugetlb_entry_migration()
and is_hugetlb_entry_hwpoisoned() things. This will be done in another
work, and the above migration_entry_wait_huge problem will be revisited
there.

ChangeLog v3:
- doing pte_page() and taking refcount under page table lock
- check pte_present after taking ptl, which makes it unnecessary to use
  get_page_unless_zero()
- use trylock_page in page != pagecache_page case
- fixed target stable version
---
 mm/hugetlb.c | 52 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git mmotm-2014-11-26-15-45.orig/mm/hugetlb.c mmotm-2014-11-26-15-45/mm/hugetlb.c
index adafced1aa17..dfc1527e8f4e 100644
--- mmotm-2014-11-26-15-45.orig/mm/hugetlb.c
+++ mmotm-2014-11-26-15-45/mm/hugetlb.c
@@ -3134,6 +3134,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *pagecache_page = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
+	int need_wait_lock = 0;
 
 	address &= huge_page_mask(h);
 
@@ -3172,6 +3173,16 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	ret = 0;
 
 	/*
+	 * entry could be a migration/hwpoison entry at this point, so this
+	 * check prevents the kernel from going below assuming that we have
+	 * a active hugepage in pagecache. This goto expects the 2nd page fault,
+	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
+	 * handle it.
+	 */
+	if (!pte_present(entry))
+		goto out_mutex;
+
+	/*
 	 * If we are going to COW the mapping later, we examine the pending
 	 * reservations for this page now. This will ensure that any
 	 * allocations necessary to record that reservation occur outside the
@@ -3190,30 +3201,31 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 								vma, address);
 	}
 
+	ptl = huge_pte_lock(h, mm, ptep);
+
+	/* Check for a racing update before calling hugetlb_cow */
+	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
+		goto out_ptl;
+
 	/*
 	 * hugetlb_cow() requires page locks of pte_page(entry) and
 	 * pagecache_page, so here we need take the former one
 	 * when page != pagecache_page or !pagecache_page.
-	 * Note that locking order is always pagecache_page -> page,
-	 * so no worry about deadlock.
 	 */
 	page = pte_page(entry);
-	get_page(page);
 	if (page != pagecache_page)
-		lock_page(page);
-
-	ptl = huge_pte_lockptr(h, mm, ptep);
-	spin_lock(ptl);
-	/* Check for a racing update before calling hugetlb_cow */
-	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
-		goto out_ptl;
+		if (!trylock_page(page)) {
+			need_wait_lock = 1;
+			goto out_ptl;
+		}
 
+	get_page(page);
 
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!huge_pte_write(entry)) {
 			ret = hugetlb_cow(mm, vma, address, ptep, entry,
 					pagecache_page, ptl);
-			goto out_ptl;
+			goto out_put_page;
 		}
 		entry = huge_pte_mkdirty(entry);
 	}
@@ -3221,7 +3233,10 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (huge_ptep_set_access_flags(vma, address, ptep, entry,
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, address, ptep);
-
+out_put_page:
+	if (page != pagecache_page)
+		unlock_page(page);
+	put_page(page);
 out_ptl:
 	spin_unlock(ptl);
 
@@ -3229,12 +3244,17 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	if (page != pagecache_page)
-		unlock_page(page);
-	put_page(page);
-
 out_mutex:
 	mutex_unlock(&htlb_fault_mutex_table[hash]);
+	/*
+	 * Generally it's safe to hold refcount during waiting page lock. But
+	 * here we just wait to defer the next page fault to avoid busy loop and
+	 * the page is not used after unlocked before returning from the current
+	 * page fault. So we are safe from accessing freed page, even if we wait
+	 * here without taking refcount.
+	 */
+	if (need_wait_lock)
+		wait_on_page_locked(page);
 	return ret;
 }
 
-- 
2.2.0.rc0.2.gf745acb
