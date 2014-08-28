Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaH1TCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:02:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaH1SgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:24 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 35/97] mm/readahead.c: fix readahead failure for memoryless NUMA nodes and limit readahead pages
Date: Thu, 28 Aug 2014 19:34:43 +0100
Message-Id: <1409250945-30874-36-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

commit 6d2be915e589b58cb11418cbe1f22ff90732b6ac upstream.

Currently max_sane_readahead() returns zero on the cpu whose NUMA node
has no local memory which leads to readahead failure.  Fix this
readahead failure by returning minimum of (requested pages, 512).  Users
running applications on a memory-less cpu which needs readahead such as
streaming application see considerable boost in the performance.

Result:

fadvise experiment with FADV_WILLNEED on a PPC machine having memoryless
CPU with 1GB testfile (12 iterations) yielded around 46.66% improvement.

fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB
testfile 32GB* 4G RAM numa machine (12 iterations) showed no impact on
the normal NUMA cases w/ patch.

  Kernel       Avg  Stddev
  base      7.4975   3.92%
  patched   7.4174   3.26%

[Andrew: making return value PAGE_SIZE independent]
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/readahead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 5b637b5..e9c4a6a 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -237,14 +237,14 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	return ret;
 }
 
+#define MAX_READAHEAD   ((512*4096)/PAGE_CACHE_SIZE)
 /*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
  * sensible upper limit.
  */
 unsigned long max_sane_readahead(unsigned long nr)
 {
-	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
-		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
+	return min(nr, MAX_READAHEAD);
 }
 
 /*
-- 
1.8.4.5

