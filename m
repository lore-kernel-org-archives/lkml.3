Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaBJIX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:23:29 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37158 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaBJIXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:23:24 -0500
Date: Mon, 10 Feb 2014 13:59:32 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        nacc@linux.vnet.ibm.com
Subject: Re: [RFC PATCH V5 RESEND] mm readahead: Fix readahead fail for no
 local memory and limit readahead pages
Message-ID: <20140210082931.GA25323@linux.vnet.ibm.com>
Reply-To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021008-7182-0000-0000-000009CA687A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2014-02-06 14:51:05]:

> On Wed, 22 Jan 2014 16:23:45 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
> 
> 
> Looks reasonable to me.  Please send along a fixed up changelog.
> 

Hi Andrew,
Sorry took some time to get and measure benefit on the memoryless system.
Resending patch with changelog and comment changes based on your and
David's suggestion.

----8<--- 
>From fc8186b5c33a34810a34f5aadd50082463117636 Mon Sep 17 00:00:00 2001
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Date: Mon, 25 Nov 2013 14:29:03 +0530
Subject: [RFC PATCH V5 RESEND] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages

Currently max_sane_readahead() returns zero on the cpu having no local memory node
which leads to readahead failure. Fix the readahead failure by returning
minimum of (requested pages, 4k). Users running application a on memory less cpu
which needs readahead such as streaming application see considerable boost in the
performance.

Result:
fadvise experiment with FADV_WILLNEED on a PPC machine having memoryless CPU
with 1GB testfile ( 12 iterations) yielded 46.66% improvement

kernel             Avg        Stddev
base_ppc         11.946833     1.34%
patched_ppc       6.3720833    1.80%

Below result proves that there is no impact on the normal NUMA cases w/ patch.

fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB testfile
32GB* 4G RAM  numa machine ( 12 iterations) yielded

Kernel     Avg      Stddev
base      7.2963    1.10 %
patched   7.2972    1.18 %

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 
 Changes in V5:
 - Updated the changelog with benefit seen (Andrew)
 - Discard remote memroy term in comment since memoryless CPU
   will have affinity to numa_mem_id() (David)
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
 mm/readahead.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 0de2360..4c7343b 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -233,14 +233,31 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	return 0;
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
+	 * Ensure readahead success on a memoryless node cpu. But we limit
+	 * the readahead to 4k pages to avoid trashing page cache.
+	 */
+	return min(nr, MAX_REMOTE_READAHEAD);
 }
 
 /*
-- 
1.7.11.7

