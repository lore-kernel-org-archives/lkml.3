Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaAFKOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:14:50 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35541 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbaAFKOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:14:48 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, jack@suse.cz,
        Linus <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [RFC PATCH V3] mm readahead: Fix the readahead fail in case of empty numa node
Date: Mon,  6 Jan 2014 15:51:55 +0530
Message-Id: <1389003715-29733-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010610-0320-0000-0000-0000021BFAF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, max_sane_readahead returns zero on the cpu with empty numa node,
fix this by checking for potential empty numa node case during calculation.
We also limit the number of readahead pages to 4k.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
The current patch limits the readahead into 4k pages (16MB was suggested by Linus).
and also handles the case of memoryless cpu issuing readahead failures.
We still do not consider [fm]advise() specific calculations here.
I have dropped the iterating over numa node to calculate free page idea.
I do not have much idea whether there is any impact on big streaming apps..
Comments/suggestions ?

 mm/readahead.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 7cdbb44..be4d205 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -237,14 +237,25 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
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
+	unsigned long sane_nr = min(nr, MAX_REMOTE_READAHEAD);
+
+	local_free_page = node_page_state(numa_node_id(), NR_INACTIVE_FILE)
+			  + node_page_state(numa_node_id(), NR_FREE_PAGES);
+
+	/*
+	 * Readahead onto remote memory is better than no readahead when local
+	 * numa node does not have memory. We sanitize readahead size depending
+	 * on free memory in the local node but limiting to 4k pages.
+	 */
+	return local_free_page ? min(sane_nr, local_free_page / 2) : sane_nr;
 }
 
 /*
-- 
1.7.11.7

