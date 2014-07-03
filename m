Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbaGCNFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:05:54 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:38380 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbaGCNFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:05:53 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        rientjes@google.com, Linus <torvalds@linux-foundation.org>,
        nacc@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH] mm readahead: Fix sys_readahead breakage by reverting 2MB limit (bug 79111)
Date: Thu,  3 Jul 2014 18:32:27 +0530
Message-Id: <1404392547-11648-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6d2be915 (mm/readahead.c: fix readahead failure for memoryless NUMA nodes
and limit readahead pages) imposed 2MB limits to readahed that yielded good
performance since it avoided unnecessay page caching.

However it broke sys_readahead semantics: 'readahead() blocks until the specified
data has been read'

This patch still retains the fix for memoryless nodes which used to return zero
and limits its readahead to 2MB to avoid unnecessary page cache thrashing but
reverts to old sanitized readahead for cpu with memory nodes.

link: https://bugzilla.kernel.org/show_bug.cgi?id=79111

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 mm/readahead.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/readahead.c b/mm/readahead.c
index 0ca36a7..4514cf6 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -239,6 +239,24 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
  */
 unsigned long max_sane_readahead(unsigned long nr)
 {
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
+	 * numa node does not have memory. We limit the readahead to 2MB to
+	 * avoid trashing page cache.
+	 */
 	return min(nr, MAX_READAHEAD);
 }
 
-- 
1.7.11.7

