Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3FNVcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:32:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3FNVce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:32:34 -0400
Date: Fri, 14 Jun 2013 14:32:23 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-3c5d8f9640b0c7c512434d7047c34bab976e1f9a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1371128589-8953-12-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-12-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm, numa: Call numa_meminfo_cover_memory()
  checking early
Git-Commit-ID: 3c5d8f9640b0c7c512434d7047c34bab976e1f9a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:32:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c5d8f9640b0c7c512434d7047c34bab976e1f9a
Gitweb:     http://git.kernel.org/tip/3c5d8f9640b0c7c512434d7047c34bab976e1f9a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:58 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:04:56 -0700

x86, mm, numa: Call numa_meminfo_cover_memory() checking early

In order to seperate parsing numa info procedure into two steps,
we need to set memblock nid later, as it could change memblock
array, and possible doube memblock.memory array which will need
to allocate buffer.

We do not need to use nid in memblock to find out absent pages.
So we can move that numa_meminfo_cover_memory() early.

Also we could change __absent_pages_in_range() to static and use
absent_pages_in_range() directly.

Later we will set memblock nid only once on successful path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-12-git-send-email-tangchen@cn.fujitsu.com
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa.c | 7 ++++---
 include/linux/mm.h | 2 --
 mm/page_alloc.c    | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 07ae800..1bb565d 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -457,7 +457,7 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 		u64 s = mi->blk[i].start >> PAGE_SHIFT;
 		u64 e = mi->blk[i].end >> PAGE_SHIFT;
 		numaram += e - s;
-		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
+		numaram -= absent_pages_in_range(s, e);
 		if ((s64)numaram < 0)
 			numaram = 0;
 	}
@@ -485,6 +485,9 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
+	if (!numa_meminfo_cover_memory(mi))
+		return -EINVAL;
+
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *mb = &mi->blk[i];
 		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
@@ -503,8 +506,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 		return -EINVAL;
 	}
 #endif
-	if (!numa_meminfo_cover_memory(mi))
-		return -EINVAL;
 
 	return 0;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e0c8528..28e9470 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1385,8 +1385,6 @@ static inline unsigned long free_initmem_default(int poison)
  */
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
-unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
-						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 378a15b..c427f46 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4395,7 +4395,7 @@ static unsigned long __meminit zone_spanned_pages_in_node(int nid,
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-unsigned long __meminit __absent_pages_in_range(int nid,
+static unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
