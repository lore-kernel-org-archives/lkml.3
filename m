Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaFDXs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:48:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaFDXX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Dave Jones <davej@redhat.com>,
        David Miller <davem@davemloft.net>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 018/103] mm, thp: close race between mremap() and split_huge_page()
Date: Wed,  4 Jun 2014 16:24:41 -0700
Message-Id: <20140604232547.433371659@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mremap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -175,10 +175,17 @@ unsigned long move_page_tables(struct vm
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


