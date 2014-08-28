Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaH1Sga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaH1SgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:00 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 13/97] readahead: fix sequential read cache miss detection
Date: Thu, 28 Aug 2014 19:34:21 +0100
Message-Id: <1409250945-30874-14-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Damien Ramonda <damien.ramonda@intel.com>

commit af248a0c67457e5c6d2bcf288f07b4b2ed064f1f upstream.

The kernel's readahead algorithm sometimes interprets random read
accesses as sequential and triggers unnecessary data prefecthing from
storage device (impacting random read average latency).

In order to identify sequential cache read misses, the readahead
algorithm intends to check whether offset - previous offset == 1
(trivial sequential reads) or offset - previous offset == 0 (sequential
reads not aligned on page boundary):

  if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL)

The current offset is stored in the "offset" variable of type "pgoff_t"
(unsigned long), while previous offset is stored in "ra->prev_pos" of
type "loff_t" (long long).  Therefore, operands of the if statement are
implicitly converted to type long long.  Consequently, when previous
offset > current offset (which happens on random pattern), the if
condition is true and access is wrongly interpeted as sequential.  An
unnecessary data prefetching is triggered, impacting the average random
read latency.

Storing the previous offset value in a "pgoff_t" variable (unsigned
long) fixes the sequential read detection logic.

Signed-off-by: Damien Ramonda <damien.ramonda@intel.com>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Pierre Tardy <pierre.tardy@intel.com>
Acked-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/readahead.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index e4ed041..5b637b5 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -401,6 +401,7 @@ ondemand_readahead(struct address_space *mapping,
 		   unsigned long req_size)
 {
 	unsigned long max = max_sane_readahead(ra->ra_pages);
+	pgoff_t prev_offset;
 
 	/*
 	 * start of file
@@ -452,8 +453,11 @@ ondemand_readahead(struct address_space *mapping,
 
 	/*
 	 * sequential cache miss
+	 * trivial case: (offset - prev_offset) == 1
+	 * unaligned reads: (offset - prev_offset) == 0
 	 */
-	if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL)
+	prev_offset = (unsigned long long)ra->prev_pos >> PAGE_CACHE_SHIFT;
+	if (offset - prev_offset <= 1UL)
 		goto initial_readahead;
 
 	/*
-- 
1.8.4.5

