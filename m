Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaGQA73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:59:29 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:47125 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaGQA7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:59:25 -0400
Date: Wed, 16 Jul 2014 17:59:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <aarcange@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch v3] mm, thp: only collapse hugepages to nodes with affinity
 for zone_reclaim_mode
In-Reply-To: <alpine.DEB.2.02.1407161754000.23892@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407161757500.23892@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com> <alpine.DEB.2.02.1407151712520.12279@chino.kir.corp.google.com> <53C69C7B.1010709@suse.cz> <alpine.DEB.2.02.1407161754000.23892@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9f1b868a13ac ("mm: thp: khugepaged: add policy for finding target 
node") improved the previous khugepaged logic which allocated a 
transparent hugepages from the node of the first page being collapsed.

However, it is still possible to collapse pages to remote memory which may 
suffer from additional access latency.  With the current policy, it is 
possible that 255 pages (with PAGE_SHIFT == 12) will be collapsed remotely 
if the majority are allocated from that node.

When zone_reclaim_mode is enabled, it means the VM should make every attempt
to allocate locally to prevent NUMA performance degradation.  In this case,
we do not want to collapse hugepages to remote nodes that would suffer from
increased access latency.  Thus, when zone_reclaim_mode is enabled, only
allow collapsing to nodes with RECLAIM_DISTANCE or less.

There is no functional change for systems that disable zone_reclaim_mode.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2: only change behavior for zone_reclaim_mode per Dave Hansen
 v3: optimization based on previous node counts per Vlastimil Babka

 mm/huge_memory.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2234,6 +2234,30 @@ static void khugepaged_alloc_sleep(void)
 static int khugepaged_node_load[MAX_NUMNODES];
 
 #ifdef CONFIG_NUMA
+static bool khugepaged_scan_abort(int nid)
+{
+	int i;
+
+	/*
+	 * If zone_reclaim_mode is disabled, then no extra effort is made to
+	 * allocate memory locally.
+	 */
+	if (!zone_reclaim_mode)
+		return false;
+
+	/* If there is a count for this node already, it must be acceptable */
+	if (khugepaged_node_load[nid])
+		return false;
+
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		if (!khugepaged_node_load[i])
+			continue;
+		if (node_distance(nid, i) > RECLAIM_DISTANCE)
+			return true;
+	}
+	return false;
+}
+
 static int khugepaged_find_target_node(void)
 {
 	static int last_khugepaged_target_node = NUMA_NO_NODE;
@@ -2309,6 +2333,11 @@ static struct page
 	return *hpage;
 }
 #else
+static bool khugepaged_scan_abort(int nid)
+{
+	return false;
+}
+
 static int khugepaged_find_target_node(void)
 {
 	return 0;
@@ -2545,6 +2574,8 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = page_to_nid(page);
+		if (khugepaged_scan_abort(node))
+			goto out_unmap;
 		khugepaged_node_load[node]++;
 		VM_BUG_ON_PAGE(PageCompound(page), page);
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
