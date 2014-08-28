Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaH1TKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:10:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaH1Sfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:35:50 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 02/97] mm: thp: khugepaged: add policy for finding target node
Date: Thu, 28 Aug 2014 19:34:10 +0100
Message-Id: <1409250945-30874-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Liu <lliubbo@gmail.com>

commit 9f1b868a13ac36bd207a571f5ea1193d823ab18d upstream.

Khugepaged will scan/free HPAGE_PMD_NR normal pages and replace with a
hugepage which is allocated from the node of the first scanned normal
page, but this policy is too rough and may end with unexpected result to
upper users.

The problem is the original page-balancing among all nodes will be
broken after hugepaged started.  Thinking about the case if the first
scanned normal page is allocated from node A, most of other scanned
normal pages are allocated from node B or C..  But hugepaged will always
allocate hugepage from node A which will cause extra memory pressure on
node A which is not the situation before khugepaged started.

This patch try to fix this problem by making khugepaged allocate
hugepage from the node which have max record of scaned normal pages hit,
so that the effect to original page-balancing can be minimized.

The other problem is if normal scanned pages are equally allocated from
Node A,B and C, after khugepaged started Node A will still suffer extra
memory pressure.

Andrew Davidoff reported a related issue several days ago.  He wanted
his application interleaving among all nodes and "numactl
--interleave=all ./test" was used to run the testcase, but the result
wasn't not as expected.

  cat /proc/2814/numa_maps:
  7f50bd440000 interleave:0-3 anon=51403 dirty=51403 N0=435 N1=435 N2=435 N3=50098

The end result showed that most pages are from Node3 instead of
interleave among node0-3 which was unreasonable.

This patch also fix this issue by allocating hugepage round robin from
all nodes have the same record, after this patch the result was as
expected:

  7f78399c0000 interleave:0-3 anon=51403 dirty=51403 N0=12723 N1=12723 N2=13235 N3=12722

The simple testcase is like this:

int main() {
	char *p;
	int i;
	int j;

	for (i=0; i < 200; i++) {
		p = (char *)malloc(1048576);
		printf("malloc done\n");

		if (p == 0) {
			printf("Out of memory\n");
			return 1;
		}
		for (j=0; j < 1048576; j++) {
			p[j] = 'A';
		}
		printf("touched memory\n");

		sleep(1);
	}
	printf("enter sleep\n");
	while(1) {
		sleep(100);
	}
}

[akpm@linux-foundation.org: make last_khugepaged_target_node local to khugepaged_find_target_node()]
Reported-by: Andrew Davidoff <davidoff@qedmf.net>
Tested-by: Andrew Davidoff <davidoff@qedmf.net>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 53 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 738a57e..515e589 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2189,7 +2189,34 @@ static void khugepaged_alloc_sleep(void)
 			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
 }
 
+static int khugepaged_node_load[MAX_NUMNODES];
+
 #ifdef CONFIG_NUMA
+static int khugepaged_find_target_node(void)
+{
+	static int last_khugepaged_target_node = NUMA_NO_NODE;
+	int nid, target_node = 0, max_value = 0;
+
+	/* find first node with max normal pages hit */
+	for (nid = 0; nid < MAX_NUMNODES; nid++)
+		if (khugepaged_node_load[nid] > max_value) {
+			max_value = khugepaged_node_load[nid];
+			target_node = nid;
+		}
+
+	/* do some balance if several nodes have the same hit record */
+	if (target_node <= last_khugepaged_target_node)
+		for (nid = last_khugepaged_target_node + 1; nid < MAX_NUMNODES;
+				nid++)
+			if (max_value == khugepaged_node_load[nid]) {
+				target_node = nid;
+				break;
+			}
+
+	last_khugepaged_target_node = target_node;
+	return target_node;
+}
+
 static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
 {
 	if (IS_ERR(*hpage)) {
@@ -2223,9 +2250,8 @@ static struct page
 	 * mmap_sem in read mode is good idea also to allow greater
 	 * scalability.
 	 */
-	*hpage  = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
-				      node, __GFP_OTHER_NODE);
-
+	*hpage = alloc_pages_exact_node(node, alloc_hugepage_gfpmask(
+		khugepaged_defrag(), __GFP_OTHER_NODE), HPAGE_PMD_ORDER);
 	/*
 	 * After allocating the hugepage, release the mmap_sem read lock in
 	 * preparation for taking it in write mode.
@@ -2241,6 +2267,11 @@ static struct page
 	return *hpage;
 }
 #else
+static int khugepaged_find_target_node(void)
+{
+	return 0;
+}
+
 static inline struct page *alloc_hugepage(int defrag)
 {
 	return alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
@@ -2453,6 +2484,7 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 	if (pmd_trans_huge(*pmd))
 		goto out;
 
+	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	for (_address = address, _pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, _address += PAGE_SIZE) {
@@ -2469,12 +2501,13 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 		if (unlikely(!page))
 			goto out_unmap;
 		/*
-		 * Chose the node of the first page. This could
-		 * be more sophisticated and look at more pages,
-		 * but isn't for now.
+		 * Record which node the original page is from and save this
+		 * information to khugepaged_node_load[].
+		 * Khupaged will allocate hugepage from the node has the max
+		 * hit record.
 		 */
-		if (node == NUMA_NO_NODE)
-			node = page_to_nid(page);
+		node = page_to_nid(page);
+		khugepaged_node_load[node]++;
 		VM_BUG_ON(PageCompound(page));
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
 			goto out_unmap;
@@ -2489,9 +2522,11 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 		ret = 1;
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret)
+	if (ret) {
+		node = khugepaged_find_target_node();
 		/* collapse_huge_page will return with the mmap_sem released */
 		collapse_huge_page(mm, address, hpage, vma, node);
+	}
 out:
 	return ret;
 }
-- 
1.8.4.5

