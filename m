Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935014Ab3BTLBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:01:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933546Ab3BTLBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:01:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,701,1355068800"; 
   d="scan'208";a="6736030"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [Bug fix PATCH 2/2] acpi, movablemem_map: Make whatever nodes the kernel resides in un-hotpluggable.
Date: Wed, 20 Feb 2013 19:00:56 +0800
Message-Id: <1361358056-1793-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 19:00:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 19:00:59,
	Serialize complete at 2013/02/20 19:00:59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There could be several memory ranges in the node in which the kernel resides.
When using movablemem_map=acpi, we may skip one range that have memory reserved
by memblock. But if it is too small, then the kernel will fail to boot. So, make
the whole node which the kernel resides in un-hotpluggable. Then the kernel has
enough memory to use.

Reported-by: H Peter Anvin <hpa@zytor.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 arch/x86/mm/srat.c                  |   17 +++++++++++++++++
 include/linux/mm.h                  |    1 +
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 0b94b98..b9a3f9f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1652,6 +1652,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			in flags from SRAT from ACPI BIOS to determine which
 			memory devices could be hotplugged. The corresponding
 			memory ranges will be set as ZONE_MOVABLE.
+			NOTE: Whatever node the kernel resides in will always
+			      be un-hotpluggable.
 
 	movablemem_map=nn[KMG]@ss[KMG]
 			[KNL,X86,IA-64,PPC] This parameter is similar to
@@ -1673,6 +1675,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			satisfied. So the administrator should be careful that
 			the amount of movablemem_map areas are not too large.
 			Otherwise kernel won't have enough memory to start.
+			NOTE: We don't stop users specifying the node the
+			      kernel resides in as hotpluggable so that this
+			      option can be used as a workaround of firmware
+                              bugs.
 
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index b8028b2..79836d0 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -166,6 +166,9 @@ handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
 	 * for other purposes, such as for kernel image. We cannot prevent
 	 * kernel from using these memory, so we need to exclude these memory
 	 * even if it is hotpluggable.
+	 * Furthermore, to ensure the kernel has enough memory to boot, we make
+	 * all the memory on the node which the kernel resides in
+	 * un-hotpluggable.
 	 */
 	if (hotpluggable && movablemem_map.acpi) {
 		/* Exclude ranges reserved by memblock. */
@@ -176,9 +179,23 @@ handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
 			    start >= rgn->regions[i].base +
 			    rgn->regions[i].size)
 				continue;
+
+			/*
+			 * If the memory range overlaps the memory reserved by
+			 * memblock, then the kernel resides in this node.
+			 */
+			node_set(node, movablemem_map.numa_nodes_kernel);
+
 			goto out;
 		}
 
+		/*
+		 * If the kernel resides in this node, then the whole node
+		 * should not be hotpluggable.
+		 */
+		if (node_isset(node, movablemem_map.numa_nodes_kernel))
+			goto out;
+
 		insert_movablemem_map(start_pfn, end_pfn);
 
 		/*
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 107c288..00d2d85 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1345,6 +1345,7 @@ struct movablemem_map {
 	int nr_map;
 	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
 	nodemask_t numa_nodes_hotplug;	/* on which nodes we specify memory */
+	nodemask_t numa_nodes_kernel;	/* on which nodes kernel resides in */
 };
 
 extern void __init insert_movablemem_map(unsigned long start_pfn,
-- 
1.7.1

