Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaIOTTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:19:34 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:60188 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaIOTTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:19:32 -0400
From: Peter Feiner <pfeiner@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] mm: softdirty: addresses before VMAs in PTE holes aren't softdirty
Date: Mon, 15 Sep 2014 12:19:27 -0700
Message-Id: <1410808767-9047-1-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410374050-13074-1-git-send-email-pfeiner@google.com>
References: <1410374050-13074-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In PTE holes that contain VM_SOFTDIRTY VMAs, unmapped addresses before
VM_SOFTDIRTY VMAs are reported as softdirty by /proc/pid/pagemap. This
bug was introduced in 68b5a652485682f67eacdee3deae640fb7845b63. The
aforementioned patch made /proc/pid/pagemap look at VM_SOFTDIRTY in PTE
holes but neglected to observe the start of VMAs returned by find_vma.

Tested:
  Wrote a selftest that creates a PMD-sized VMA then unmaps the first
  page and asserts that the page is not softdirty. I'm going to send the
  pagemap selftest in a later commit.

Signed-off-by: Peter Feiner <pfeiner@google.com>

---

v1 -> v2:
	Rewrote to make logic easier to follow.
---
 fs/proc/task_mmu.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index dfc791c..c341568 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -931,23 +931,32 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
 	while (addr < end) {
 		struct vm_area_struct *vma = find_vma(walk->mm, addr);
 		pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
-		unsigned long vm_end;
+		/* End of address space hole, which we mark as non-present. */
+		unsigned long hole_end;
 
-		if (!vma) {
-			vm_end = end;
-		} else {
-			vm_end = min(end, vma->vm_end);
-			if (vma->vm_flags & VM_SOFTDIRTY)
-				pme.pme |= PM_STATUS2(pm->v2, __PM_SOFT_DIRTY);
+		if (vma)
+			hole_end = min(end, vma->vm_start);
+		else
+			hole_end = end;
+
+		for (; addr < hole_end; addr += PAGE_SIZE) {
+			err = add_to_pagemap(addr, &pme, pm);
+			if (err)
+				goto out;
 		}
 
-		for (; addr < vm_end; addr += PAGE_SIZE) {
+		if (!vma)
+			break;
+
+		/* Addresses in the VMA. */
+		if (vma->vm_flags & VM_SOFTDIRTY)
+			pme.pme |= PM_STATUS2(pm->v2, __PM_SOFT_DIRTY);
+		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
 			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
 				goto out;
 		}
 	}
-
 out:
 	return err;
 }
-- 
2.1.0.rc2.206.gedb03e5

