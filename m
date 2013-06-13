Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab3FMN2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:28:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39335 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757305Ab3FMN16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:27:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537677"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [Part1 PATCH v5 15/22] x86, mm, numa: Move node_possible_map setting later
Date: Thu, 13 Jun 2013 21:03:02 +0800
Message-Id: <1371128589-8953-16-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:26,
	Serialize complete at 2013/06/13 20:58:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Move node_possible_map handling out of numa_check_memblks()
to avoid side effect when changing numa_check_memblks().

Only set node_possible_map once for successful path instead
of resetting in numa_init() every time.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

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
-- 
1.7.1

