Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab3CHFBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:01:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43490 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760245Ab3CHE7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:59:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>
Subject: [PATCH 10/14] x86, mm, numa: Move emulation handling down.
Date: Thu,  7 Mar 2013 20:58:36 -0800
Message-Id: <1362718720-27048-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will need to allocate buffer for new numa_meminfo and
distance matrix, so move it down.

Also we change the behavoir:
before this patch, if user input wrong data in command line, it
will fall back to next numa or disabling numa.
after this patch, if user input wrong data in command line, it will
stay with numa info from probing before, like acpi srat or amd_numa.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/numa.c           |   15 +++++++++------
 arch/x86/mm/numa_emulation.c |    2 +-
 arch/x86/mm/numa_internal.h  |    2 ++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index e875c2b..ace0370 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -537,14 +537,16 @@ static unsigned long __init node_map_pfn_alignment(struct numa_meminfo *mi)
 }
 #endif
 
-static int __init numa_check_memblks(struct numa_meminfo *mi)
+
+int __init numa_check_memblks(struct numa_meminfo *mi)
 {
+	nodemask_t tmp_node_map;
 	unsigned long pfn_align;
 
 	/* Account for nodes with cpus and no memory */
-	node_possible_map = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&node_possible_map, mi);
-	if (WARN_ON(nodes_empty(node_possible_map)))
+	tmp_node_map = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&tmp_node_map, mi);
+	if (WARN_ON(nodes_empty(tmp_node_map)))
 		return -EINVAL;
 
 	if (!numa_meminfo_cover_memory(mi))
@@ -562,6 +564,7 @@ static int __init numa_check_memblks(struct numa_meminfo *mi)
 		return -EINVAL;
 	}
 
+	node_possible_map = tmp_node_map;
 	return 0;
 }
 
@@ -608,8 +611,6 @@ static int __init numa_init(int (*init_func)(void))
 	if (ret < 0)
 		return ret;
 
-	numa_emulation(&numa_meminfo, numa_distance_cnt);
-
 	ret = numa_check_memblks(&numa_meminfo);
 	if (ret < 0)
 		return ret;
@@ -669,6 +670,8 @@ void __init x86_numa_init(void)
 	numa_init(dummy_numa_init);
 
 out:
+	numa_emulation(&numa_meminfo, numa_distance_cnt);
+
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *mb = &mi->blk[i];
 		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index dbbbb47..5a0433d 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -348,7 +348,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	if (ret < 0)
 		goto no_emu;
 
-	if (numa_cleanup_meminfo(&ei) < 0) {
+	if (numa_cleanup_meminfo(&ei) < 0 || numa_check_memblks(&ei) < 0) {
 		pr_warning("NUMA: Warning: constructed meminfo invalid, disabling emulation\n");
 		goto no_emu;
 	}
diff --git a/arch/x86/mm/numa_internal.h b/arch/x86/mm/numa_internal.h
index ad86ec9..bb2fbcc 100644
--- a/arch/x86/mm/numa_internal.h
+++ b/arch/x86/mm/numa_internal.h
@@ -21,6 +21,8 @@ void __init numa_reset_distance(void);
 
 void __init x86_numa_init(void);
 
+int __init numa_check_memblks(struct numa_meminfo *mi);
+
 #ifdef CONFIG_NUMA_EMU
 void __init numa_emulation(struct numa_meminfo *numa_meminfo,
 			   int numa_dist_cnt);
-- 
1.7.10.4

