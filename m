Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966855AbaFTUMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:12:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342AbaFTUML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:12:11 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v3 06/13] pagemap: use walk->vma instead of calling find_vma()
Date: Fri, 20 Jun 2014 16:11:32 -0400
Message-Id: <1403295099-6407-7-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1403295099-6407-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1403295099-6407-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page table walker has the information of the current vma in mm_walk, so
we don't have to call find_vma() in each pagemap_hugetlb_range() call.

NULL-vma check is omitted because we assume that we never run hugetlb_entry()
callback on the address without vma. And even if it were broken, null pointer
dereference would be detected, so we can get enough information for debugging.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/proc/task_mmu.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git v3.16-rc1.orig/fs/proc/task_mmu.c v3.16-rc1/fs/proc/task_mmu.c
index 3c42cd40ad36..74f87794afab 100644
--- v3.16-rc1.orig/fs/proc/task_mmu.c
+++ v3.16-rc1/fs/proc/task_mmu.c
@@ -1082,15 +1082,12 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
 				 struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = walk->vma;
 	int err = 0;
 	int flags2;
 	pagemap_entry_t pme;
 
-	vma = find_vma(walk->mm, addr);
-	WARN_ON_ONCE(!vma);
-
-	if (vma && (vma->vm_flags & VM_SOFTDIRTY))
+	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags2 = __PM_SOFT_DIRTY;
 	else
 		flags2 = 0;
-- 
1.9.3

