Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3FNVdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:33:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3FNVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:33:11 -0400
Date: Fri, 14 Jun 2013 14:32:59 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-052f56f9b1ffa4b1d1fffb7beb43511e0c630305@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tj@kernel.org, tangchen@cn.fujitsu.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tangchen@cn.fujitsu.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1371128589-8953-16-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-16-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm, numa: Move node_possible_map setting later
Git-Commit-ID: 052f56f9b1ffa4b1d1fffb7beb43511e0c630305
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:33:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  052f56f9b1ffa4b1d1fffb7beb43511e0c630305
Gitweb:     http://git.kernel.org/tip/052f56f9b1ffa4b1d1fffb7beb43511e0c630305
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:03:02 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:05:03 -0700

x86, mm, numa: Move node_possible_map setting later

Move node_possible_map handling out of numa_check_memblks()
to avoid side effect when changing numa_check_memblks().

Only set node_possible_map once for successful path instead
of resetting in numa_init() every time.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-16-git-send-email-tangchen@cn.fujitsu.com
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index e448b6f..da2ebab 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -536,12 +536,13 @@ static unsigned long __init node_map_pfn_alignment(struct numa_meminfo *mi)
 
 static int __init numa_check_memblks(struct numa_meminfo *mi)
 {
+	nodemask_t nodes_parsed;
 	unsigned long pfn_align;
 
 	/* Account for nodes with cpus and no memory */
-	node_possible_map = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&node_possible_map, mi);
-	if (WARN_ON(nodes_empty(node_possible_map)))
+	nodes_parsed = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&nodes_parsed, mi);
+	if (WARN_ON(nodes_empty(nodes_parsed)))
 		return -EINVAL;
 
 	if (!numa_meminfo_cover_memory(mi))
@@ -593,7 +594,6 @@ static int __init numa_init(int (*init_func)(void))
 		set_apicid_to_node(i, NUMA_NO_NODE);
 
 	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	numa_reset_distance();
 
@@ -669,6 +669,9 @@ void __init x86_numa_init(void)
 
 	early_x86_numa_init();
 
+	node_possible_map = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&node_possible_map, mi);
+
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *mb = &mi->blk[i];
 		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
