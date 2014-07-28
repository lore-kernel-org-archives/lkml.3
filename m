Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaG1NMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:12:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaG1NMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:12:06 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v5 01/14] mm, THP: don't hold mmap_sem in khugepaged when allocating THP
Date: Mon, 28 Jul 2014 15:11:28 +0200
Message-Id: <1406553101-29326-2-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating huge page for collapsing, khugepaged currently holds mmap_sem
for reading on the mm where collapsing occurs. Afterwards the read lock is
dropped before write lock is taken on the same mmap_sem.

Holding mmap_sem during whole huge page allocation is therefore useless, the
vma needs to be rechecked after taking the write lock anyway. Furthemore, huge
page allocation might involve a rather long sync compaction, and thus block
any mmap_sem writers and i.e. affect workloads that perform frequent m(un)map
or mprotect oterations.

This patch simply releases the read lock before allocating a huge page. It
also deletes an outdated comment that assumed vma must be stable, as it was
using alloc_hugepage_vma(). This is no longer true since commit 9f1b868a13ac
("mm: thp: khugepaged: add policy for finding target node").

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
---
 mm/huge_memory.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d9a21d06..7cfc325 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2319,23 +2319,17 @@ static struct page
 		       int node)
 {
 	VM_BUG_ON_PAGE(*hpage, *hpage);
+
 	/*
-	 * Allocate the page while the vma is still valid and under
-	 * the mmap_sem read mode so there is no memory allocation
-	 * later when we take the mmap_sem in write mode. This is more
-	 * friendly behavior (OTOH it may actually hide bugs) to
-	 * filesystems in userland with daemons allocating memory in
-	 * the userland I/O paths.  Allocating memory with the
-	 * mmap_sem in read mode is good idea also to allow greater
-	 * scalability.
+	 * Before allocating the hugepage, release the mmap_sem read lock.
+	 * The allocation can take potentially a long time if it involves
+	 * sync compaction, and we do not need to hold the mmap_sem during
+	 * that. We will recheck the vma after taking it again in write mode.
 	 */
+	up_read(&mm->mmap_sem);
+
 	*hpage = alloc_pages_exact_node(node, alloc_hugepage_gfpmask(
 		khugepaged_defrag(), __GFP_OTHER_NODE), HPAGE_PMD_ORDER);
-	/*
-	 * After allocating the hugepage, release the mmap_sem read lock in
-	 * preparation for taking it in write mode.
-	 */
-	up_read(&mm->mmap_sem);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
-- 
1.8.4.5

