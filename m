Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3DLBOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:14:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59065 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab3DLBOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:53 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 25/25] mm: add a early_param "extra_nr_node_ids" to increase nr_node_ids above the minimum by a percentage.
Date: Thu, 11 Apr 2013 18:13:57 -0700
Message-Id: <1365729237-29711-26-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-2876-0000-0000-0000075D353A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For dynamic numa, sometimes the hypervisor we're running under will want
to split a single NUMA node into multiple NUMA nodes. If the number of
numa nodes is limited to the number avaliable when the system booted (as
it is on x86), we may not be able to fully adopt the new memory layout
provided by the hypervisor.

This option allows reserving some extra node ids as a percentage of the
boot time node ids. While not perfect (idealy nr_node_ids would be fully
dynamic), this allows decent functionality without invasive changes to
the SL{U,A}B allocators.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt |  6 ++++++
 mm/page_alloc.c                     | 24 ++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..b0523d8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2033,6 +2033,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			use hotplug cpu feature to put more cpu back to online.
 			just like you compile the kernel NR_CPUS=n
 
+	extra_nr_node_ids= [NUMA] Increase the maximum number of NUMA nodes
+			above the number detected at boot by the specified
+			percentage (rounded up). For example:
+			extra_nr_node_ids=100 would double the number of
+			node_ids avaliable (up to a max of MAX_NUMNODES).
+
 	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
 
 	numa_balancing=	[KNL,X86] Enable or disable automatic NUMA balancing.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 686d8f8..d333d91 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4798,6 +4798,17 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 
 #if MAX_NUMNODES > 1
+
+static unsigned nr_node_ids_mod_percent;
+static int __init setup_extra_nr_node_ids(char *arg)
+{
+	int r = kstrtouint(arg, 10, &nr_node_ids_mod_percent);
+	if (r)
+		pr_err("invalid param value extra_nr_node_ids=\"%s\"\n", arg);
+	return 0;
+}
+early_param("extra_nr_node_ids", setup_extra_nr_node_ids);
+
 /*
  * Figure out the number of possible node ids.
  */
@@ -4809,6 +4820,19 @@ void __init setup_nr_node_ids(void)
 	for_each_node_mask(node, node_possible_map)
 		highest = node;
 	nr_node_ids = highest + 1;
+
+	/*
+	 * expand nr_node_ids and node_possible_map so more can be onlined
+	 * later
+	 */
+	nr_node_ids +=
+		DIV_ROUND_UP(nr_node_ids * nr_node_ids_mod_percent, 100);
+
+	if (nr_node_ids > MAX_NUMNODES)
+		nr_node_ids = MAX_NUMNODES;
+
+	for (node = highest + 1; node < nr_node_ids; node++)
+		node_set(node, node_possible_map);
 }
 #endif
 
-- 
1.8.2.1

