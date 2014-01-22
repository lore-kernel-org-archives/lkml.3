Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaAVLDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:03:43 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59440 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaAVLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:03:39 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [RFC PATCH V5] mm readahead: Fix readahead fail for no local memory and limit readahead pages
Date: Wed, 22 Jan 2014 16:23:45 +0530
Message-Id: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012211-9332-0000-0000-000002D8BC9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_sane_readahead returns zero on the cpu having no local memory
node. Fix that by returning a sanitized number of pages viz.,
minimum of (requested pages, 4k)

Result:
fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB testfile
32GB* 4G RAM  numa machine ( 12 iterations) yielded

Kernel     Avg      Stddev
base      7.2963    1.10 %
patched   7.2972    1.18 %

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 Changes in V5:
 - Drop the 4k limit for normal readahead. (Jan Kara)

 Changes in V4:
 - Check for total node memory to decide whether we don't
   have local memory (jan Kara)
 - Add 4k page limit on readahead for normal and remote readahead (Linus)
   (Linus suggestion was 16MB limit).

 Changes in V3:
 - Drop iterating over numa nodes that calculates total free pages (Linus)

 Agree that we do not have control on allocation for readahead on a
 particular numa node and hence for remote readahead we can not further
 sanitize based on potential free pages of that node. and also we do
 not want to itererate through all nodes to find total free pages.

 Suggestions and comments welcome

 mm/readahead.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 7cdbb44..9d2afd0 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -237,14 +237,32 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	return ret;
 }
 
+#define MAX_REMOTE_READAHEAD   4096UL
 /*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
  * sensible upper limit.
  */
 unsigned long max_sane_readahead(unsigned long nr)
 {
-	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
-		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
+	unsigned long local_free_page;
+	int nid;
+
+	nid = numa_node_id();
+	if (node_present_pages(nid)) {
+		/*
+		 * We sanitize readahead size depending on free memory in
+		 * the local node.
+		 */
+		local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
+				 + node_page_state(nid, NR_FREE_PAGES);
+		return min(nr, local_free_page / 2);
+	}
+	/*
+	 * Readahead onto remote memory is better than no readahead when local
+	 * numa node does not have memory. We limit the readahead to 4k
+	 * pages though to avoid trashing page cache.
+	 */
+	return min(nr, MAX_REMOTE_READAHEAD);
 }
 
 /*
-- 
1.7.11.7

