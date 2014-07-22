Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbaGVWYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:24:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbaGVWYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:24:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 108/116] mm: fix crashes from mbind() merging vmas
Date: Tue, 22 Jul 2014 15:21:59 -0700
Message-Id: <1406067727-19683-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit d05f0cdcbe6388723f1900c549b4850360545201 upstream.

In v2.6.34 commit 9d8cebd4bcd7 ("mm: fix mbind vma merge problem")
introduced vma merging to mbind(), but it should have also changed the
convention of passing start vma from queue_pages_range() (formerly
check_range()) to new_vma_page(): vma merging may have already freed
that structure, resulting in BUG at mm/mempolicy.c:1738 and probably
worse crashes.

Fixes: 9d8cebd4bcd7 ("mm: fix mbind vma merge problem")
Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ backport to 3.8-stable: queue_pages_range was check_range; context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/mempolicy.c | 44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eb2848e..58198da 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -621,19 +621,18 @@ static unsigned long change_prot_numa(struct vm_area_struct *vma,
  * If pagelist != NULL then isolate pages from the LRU and
  * put them on the pagelist.
  */
-static struct vm_area_struct *
+static int
 check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags, void *private)
 {
-	int err;
-	struct vm_area_struct *first, *vma, *prev;
-
+	int err = 0;
+	struct vm_area_struct *vma, *prev;
 
-	first = find_vma(mm, start);
-	if (!first)
-		return ERR_PTR(-EFAULT);
+	vma = find_vma(mm, start);
+	if (!vma)
+		return -EFAULT;
 	prev = NULL;
-	for (vma = first; vma && vma->vm_start < end; vma = vma->vm_next) {
+	for (; vma && vma->vm_start < end; vma = vma->vm_next) {
 		unsigned long endvma = vma->vm_end;
 
 		if (endvma > end)
@@ -643,9 +642,9 @@ check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 
 		if (!(flags & MPOL_MF_DISCONTIG_OK)) {
 			if (!vma->vm_next && vma->vm_end < end)
-				return ERR_PTR(-EFAULT);
+				return -EFAULT;
 			if (prev && prev->vm_end < vma->vm_start)
-				return ERR_PTR(-EFAULT);
+				return -EFAULT;
 		}
 
 		if (is_vm_hugetlb_page(vma))
@@ -662,15 +661,13 @@ check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 
 			err = check_pgd_range(vma, start, endvma, nodes,
 						flags, private);
-			if (err) {
-				first = ERR_PTR(err);
+			if (err)
 				break;
-			}
 		}
 next:
 		prev = vma;
 	}
-	return first;
+	return err;
 }
 
 /*
@@ -1152,16 +1149,17 @@ out:
 
 /*
  * Allocate a new page for page migration based on vma policy.
- * Start assuming that page is mapped by vma pointed to by @private.
+ * Start by assuming the page is mapped by the same vma as contains @start.
  * Search forward from there, if not.  N.B., this assumes that the
  * list of pages handed to migrate_pages()--which is how we get here--
  * is in virtual address order.
  */
-static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
+static struct page *new_page(struct page *page, unsigned long start, int **x)
 {
-	struct vm_area_struct *vma = (struct vm_area_struct *)private;
+	struct vm_area_struct *vma;
 	unsigned long uninitialized_var(address);
 
+	vma = find_vma(current->mm, start);
 	while (vma) {
 		address = page_address_in_vma(page, vma);
 		if (address != -EFAULT)
@@ -1187,7 +1185,7 @@ int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 	return -ENOSYS;
 }
 
-static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
+static struct page *new_page(struct page *page, unsigned long start, int **x)
 {
 	return NULL;
 }
@@ -1197,7 +1195,6 @@ static long do_mbind(unsigned long start, unsigned long len,
 		     unsigned short mode, unsigned short mode_flags,
 		     nodemask_t *nmask, unsigned long flags)
 {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	struct mempolicy *new;
 	unsigned long end;
@@ -1263,11 +1260,9 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (err)
 		goto mpol_out;
 
-	vma = check_range(mm, start, end, nmask,
+	err = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
-
-	err = PTR_ERR(vma);	/* maybe ... */
-	if (!IS_ERR(vma))
+	if (!err)
 		err = mbind_range(mm, start, end, new);
 
 	if (!err) {
@@ -1275,8 +1270,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 
 		if (!list_empty(&pagelist)) {
 			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
-			nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma,
+			nr_failed = migrate_pages(&pagelist, new_page, start,
 						false, MIGRATE_SYNC,
 						MR_MEMPOLICY_MBIND);
 			if (nr_failed)
-- 
1.9.1

