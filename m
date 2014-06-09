Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaFIJJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:09:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58482 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 029/146] mm, thp: close race between mremap() and split_huge_page()
Date: Mon,  9 Jun 2014 10:49:24 +0200
Message-Id: <bf9a609ad58ca5e7f9e9d306f04c467da3cfcf95.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dd18dbc2d42af75fffa60c77e0f02220bc329829 upstream.

It's critical for split_huge_page() (and migration) to catch and freeze
all PMDs on rmap walk.  It gets tricky if there's concurrent fork() or
mremap() since usually we copy/move page table entries on dup_mm() or
move_page_tables() without rmap lock taken.  To get it work we rely on
rmap walk order to not miss any entry.  We expect to see destination VMA
after source one to work correctly.

But after switching rmap implementation to interval tree it's not always
possible to preserve expected walk order.

It works fine for dup_mm() since new VMA has the same vma_start_pgoff()
/ vma_last_pgoff() and explicitly insert dst VMA after src one with
vma_interval_tree_insert_after().

But on move_vma() destination VMA can be merged into adjacent one and as
result shifted left in interval tree.  Fortunately, we can detect the
situation and prevent race with rmap walk by moving page table entries
under rmap lock.  See commit 38a76013ad80.

Problem is that we miss the lock when we move transhuge PMD.  Most
likely this bug caused the crash[1].

[1] http://thread.gmane.org/gmane.linux.kernel.mm/96473

Fixes: 108d6642ad81 ("mm anon rmap: remove anon_vma_moveto_tail")

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Michel Lespinasse <walken@google.com>
Cc: Dave Jones <davej@redhat.com>
Cc: David Miller <davem@davemloft.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/mremap.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 0843feb66f3d..05f1180e9f21 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -194,10 +194,17 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 			break;
 		if (pmd_trans_huge(*old_pmd)) {
 			int err = 0;
-			if (extent == HPAGE_PMD_SIZE)
+			if (extent == HPAGE_PMD_SIZE) {
+				VM_BUG_ON(vma->vm_file || !vma->anon_vma);
+				/* See comment in move_ptes() */
+				if (need_rmap_locks)
+					anon_vma_lock_write(vma->anon_vma);
 				err = move_huge_pmd(vma, new_vma, old_addr,
 						    new_addr, old_end,
 						    old_pmd, new_pmd);
+				if (need_rmap_locks)
+					anon_vma_unlock_write(vma->anon_vma);
+			}
 			if (err > 0) {
 				need_flush = true;
 				continue;
-- 
1.9.3

