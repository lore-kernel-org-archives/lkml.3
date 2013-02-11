Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3BKDSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 22:18:12 -0500
Received: from ozlabs.org ([203.10.76.45]:39916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab3BKDSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 22:18:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
        "Stewart Smith" <stewart@flamingspork.com>
Subject: RFC: mincore: add a bit to indicate a page is dirty.
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 11 Feb 2013 13:43:03 +1030
Message-ID: <87a9rbh7b4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am writing an app which really wants to know if a file is on the
disk or not (ie. do I need to sync?).

mincore() bits other than 0 are undefined (as documented in the man
page); in fact my Ubuntu 12.10 i386 system seems to write 129 in some
bytes, so it really shouldn't break anyone.

Is PG_dirty the right choice?  Is that right for huge pages?  Should I
assume is_migration_entry(entry) means it's not dirty, or is there some
other check here?

Thanks,
Rusty

diff --git a/mm/mincore.c b/mm/mincore.c
index 936b4ce..e1e8f03 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -19,6 +19,9 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
+#define MINCORE_INCORE 1
+#define MINCORE_DIRTY  2
+
 static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
 				unsigned long addr, unsigned long end,
 				unsigned char *vec)
@@ -28,7 +31,7 @@ static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
 
 	h = hstate_vma(vma);
 	while (1) {
-		unsigned char present;
+		unsigned char flags = 0;
 		pte_t *ptep;
 		/*
 		 * Huge pages are always in RAM for now, but
@@ -36,7 +39,15 @@ static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
 		 */
 		ptep = huge_pte_offset(current->mm,
 				       addr & huge_page_mask(h));
-		present = ptep && !huge_pte_none(huge_ptep_get(ptep));
+		if (ptep) {
+			pte_t pte = huge_ptep_get(ptep);
+
+			if (!huge_pte_none(pte)) {
+				flags = MINCORE_INCORE;
+				if (pte_dirty(pte))
+				    flags |= MINCORE_DIRTY;
+			}
+		}
 		while (1) {
 			*vec = present;
 			vec++;
@@ -61,7 +72,7 @@ static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
  */
 static unsigned char mincore_page(struct address_space *mapping, pgoff_t pgoff)
 {
-	unsigned char present = 0;
+	unsigned char flags = 0;
 	struct page *page;
 
 	/*
@@ -79,11 +90,15 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t pgoff)
 	}
 #endif
 	if (page) {
-		present = PageUptodate(page);
+		if (PageUptodate(page)) {
+			flags = MINCORE_INCORE;
+			if (PageDirty(page))
+				flags |= MINCORE_DIRTY;
+		}
 		page_cache_release(page);
 	}
 
-	return present;
+	return flags;
 }
 
 static void mincore_unmapped_range(struct vm_area_struct *vma,
@@ -121,9 +136,11 @@ static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		next = addr + PAGE_SIZE;
 		if (pte_none(pte))
 			mincore_unmapped_range(vma, addr, next, vec);
-		else if (pte_present(pte))
-			*vec = 1;
-		else if (pte_file(pte)) {
+		else if (pte_present(pte)) {
+			*vec = MINCORE_INCORE;
+			if (pte_dirty(pte))
+				*vec |= MINCORE_DIRTY;
+		} else if (pte_file(pte)) {
 			pgoff = pte_to_pgoff(pte);
 			*vec = mincore_page(vma->vm_file->f_mapping, pgoff);
 		} else { /* pte is a swap entry */
@@ -131,14 +148,15 @@ static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 			if (is_migration_entry(entry)) {
 				/* migration entries are always uptodate */
-				*vec = 1;
+				*vec = MINCORE_INCORE;
+				/* FIXME: Can they be dirty? */
 			} else {
 #ifdef CONFIG_SWAP
 				pgoff = entry.val;
 				*vec = mincore_page(&swapper_space, pgoff);
 #else
 				WARN_ON(1);
-				*vec = 1;
+				*vec = MINCORE_INCORE|MINCORE_DIRTY;
 #endif
 			}
 		}
@@ -246,7 +264,7 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
  * current process's address space specified by [addr, addr + len).
  * The status is returned in a vector of bytes.  The least significant
  * bit of each byte is 1 if the referenced page is in memory, otherwise
- * it is zero.
+ * it is zero.  The second bit indicates if page (may be) dirty.
  *
  * Because the status of a page can change after mincore() checks it
  * but before it returns to the application, the returned vector may
