Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaEJHRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:17:31 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63934 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaEJHR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 03:17:29 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        nasa4836@gmail.com, fabf@skynet.be, cldu@marvell.com,
        sasha.levin@oracle.com, aarcange@redhat.com,
        zhangyanfei@cn.fujitsu.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com,
        iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com,
        liwanp@linux.vnet.ibm.com, gorcunov@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mm: use a light-weight __mod_zone_page_state in mlocked_vma_newpage()
Date: Sat, 10 May 2014 15:17:16 +0800
Message-Id: <d756fd253f7f32da37f5320a8e6dc9207ea5ba86.1399705884.git.nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc1
In-Reply-To: <1d32d83e54542050dba3f711a8d10b1e951a9a58.1399705884.git.nasa4836@gmail.com>
References: <1d32d83e54542050dba3f711a8d10b1e951a9a58.1399705884.git.nasa4836@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mlocked_vma_newpage() is only called in fault path by
page_add_new_anon_rmap(), which is called on a *new* page.
And such page is initially only visible via the pagetables, and the
pte is locked while calling page_add_new_anon_rmap(), so we need not
use an irq-safe mod_zone_page_state() here, using a light-weight version
__mod_zone_page_state() would be OK.

And as suggested by Andrew, to reduce the risks that new call sites
incorrectly using mlocked_vma_newpage() without knowing they are adding
racing, this patch also moves it from internal.h to right before its only
call site page_add_new_anon_rmap() in rmap.c, with detailed document added.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/internal.h | 22 ++--------------------
 mm/rmap.c     | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 07b6736..20abafb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -183,26 +183,8 @@ static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
 	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
 }
 
-/*
- * Called only in fault path, to determine if a new page is being
- * mapped into a LOCKED vma.  If it is, mark page as mlocked.
- */
-static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
-				    struct page *page)
-{
-	VM_BUG_ON_PAGE(PageLRU(page), page);
-
-	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
-		return 0;
-
-	if (!TestSetPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    hpage_nr_pages(page));
-		count_vm_event(UNEVICTABLE_PGMLOCKED);
-	}
-	return 1;
-}
-
+extern int mlocked_vma_newpage(struct vm_area_struct *vma,
+				struct page *page);
 /*
  * must be called with vma's mmap_sem held for read or write, and page locked.
  */
diff --git a/mm/rmap.c b/mm/rmap.c
index 6078a30..a9d02ef 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1005,6 +1005,30 @@ void do_page_add_anon_rmap(struct page *page,
 		__page_check_anon_rmap(page, vma, address);
 }
 
+/*
+ * Called only in fault path, to determine if a new page is being
+ * mapped into a LOCKED vma.  If it is, mark page as mlocked.
+ * This function is only called in fault path by
+ * page_add_new_anon_rmap(), which is called on a *new* page.
+ * And such page is initially only visible via the pagetables, and the
+ * pte is locked while calling page_add_new_anon_rmap(), so using a
+ * light-weight version __mod_zone_page_state() would be OK.
+ */
+int mlocked_vma_newpage(struct vm_area_struct *vma,
+					struct page *page)
+{
+	VM_BUG_ON_PAGE(PageLRU(page), page);
+	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
+		return 0;
+
+	if (!TestSetPageMlocked(page)) {
+		__mod_zone_page_state(page_zone(page), NR_MLOCK,
+					hpage_nr_pages(page));
+		count_vm_event(UNEVICTABLE_PGMLOCKED);
+	}
+	return 1;
+}
+
 /**
  * page_add_new_anon_rmap - add pte mapping to a new anonymous page
  * @page:	the page to add the mapping to
-- 
2.0.0-rc1

