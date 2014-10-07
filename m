Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbaJGX1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:27:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbaJGXUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3.14 30/37] mm/readahead.c: fix readahead failure for memoryless NUMA nodes and limit readahead pages
Date: Tue,  7 Oct 2014 16:19:47 -0700
Message-Id: <20141007231827.978466469@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/readahead.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -233,14 +233,14 @@ int force_page_cache_readahead(struct ad
 	return 0;
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


