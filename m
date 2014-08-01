Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaHATVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248AbaHATV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:21:27 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH -mm v6 03/13] pagewalk: add walk_page_vma()
Date: Fri,  1 Aug 2014 15:20:39 -0400
Message-Id: <1406920849-25908-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces walk_page_vma(), which is useful for the callers which want to
walk over a given vma.  It's used by later patches.

ChangeLog v3:
- check walk_page_test's return value instead of walk->skip

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h |  1 +
 mm/pagewalk.c      | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git mmotm-2014-07-30-15-57.orig/include/linux/mm.h mmotm-2014-07-30-15-57/include/linux/mm.h
index 1640cf740837..84b2a6cf45f6 100644
--- mmotm-2014-07-30-15-57.orig/include/linux/mm.h
+++ mmotm-2014-07-30-15-57/include/linux/mm.h
@@ -1131,6 +1131,7 @@ struct mm_walk {
 
 int walk_page_range(unsigned long addr, unsigned long end,
 		struct mm_walk *walk);
+int walk_page_vma(struct vm_area_struct *vma, struct mm_walk *walk);
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
diff --git mmotm-2014-07-30-15-57.orig/mm/pagewalk.c mmotm-2014-07-30-15-57/mm/pagewalk.c
index 91810ba875ea..65fb68df3aa2 100644
--- mmotm-2014-07-30-15-57.orig/mm/pagewalk.c
+++ mmotm-2014-07-30-15-57/mm/pagewalk.c
@@ -272,3 +272,21 @@ int walk_page_range(unsigned long start, unsigned long end,
 	} while (start = next, start < end);
 	return err;
 }
+
+int walk_page_vma(struct vm_area_struct *vma, struct mm_walk *walk)
+{
+	int err;
+
+	if (!walk->mm)
+		return -EINVAL;
+
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+	VM_BUG_ON(!vma);
+	walk->vma = vma;
+	err = walk_page_test(vma->vm_start, vma->vm_end, walk);
+	if (err > 0)
+		return 0;
+	if (err < 0)
+		return err;
+	return __walk_page_range(vma->vm_start, vma->vm_end, walk);
+}
-- 
1.9.3

