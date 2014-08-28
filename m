Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaH1Sh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbaH1ShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:17 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 88/97] mm, thp: only collapse hugepages to nodes with affinity for zone_reclaim_mode
Date: Thu, 28 Aug 2014 19:35:36 +0100
Message-Id: <1409250945-30874-89-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit 14a4e2141e24304fff2c697be6382ffb83888185 upstream.

Commit 9f1b868a13ac ("mm: thp: khugepaged: add policy for finding target
node") improved the previous khugepaged logic which allocated a
transparent hugepages from the node of the first page being collapsed.

However, it is still possible to collapse pages to remote memory which
may suffer from additional access latency.  With the current policy, it
is possible that 255 pages (with PAGE_SHIFT == 12) will be collapsed
remotely if the majority are allocated from that node.

When zone_reclaim_mode is enabled, it means the VM should make every
attempt to allocate locally to prevent NUMA performance degradation.  In
this case, we do not want to collapse hugepages to remote nodes that
would suffer from increased access latency.  Thus, when
zone_reclaim_mode is enabled, only allow collapsing to nodes with
RECLAIM_DISTANCE or less.

There is no functional change for systems that disable
zone_reclaim_mode.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 515e589..2ee5374 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2191,6 +2191,30 @@ static void khugepaged_alloc_sleep(void)
 
 static int khugepaged_node_load[MAX_NUMNODES];
 
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
 #ifdef CONFIG_NUMA
 static int khugepaged_find_target_node(void)
 {
@@ -2507,6 +2531,8 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = page_to_nid(page);
+		if (khugepaged_scan_abort(node))
+			goto out_unmap;
 		khugepaged_node_load[node]++;
 		VM_BUG_ON(PageCompound(page));
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
-- 
1.8.4.5

