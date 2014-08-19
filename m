Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaHSKC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:02:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34308 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaHSKC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:02:57 -0400
Message-ID: <53F320B7.30002@huawei.com>
Date: Tue, 19 Aug 2014 18:02:31 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Tang Chen <tangchen@cn.fujitsu.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mem-hotplug: introduce movablenodes boot option for memory
 hotplug debugging
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new boot option "movablenodes". This parameter
depends on movable_node, it is used for debugging memory hotplug.
Instead SRAT specifies which memory is hotpluggable.

e.g. movable_node movablenodes=1,2,4

It means nodes 1,2,4 will be set to movable nodes, the other nodes are
unmovable nodes. Usually movable nodes are parsed from SRAT table which
offered by BIOS.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/kernel-parameters.txt |    5 ++++
 arch/x86/mm/srat.c                  |   36 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5ae8608..e072ccf 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1949,6 +1949,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	movable_node	[KNL,X86] Boot-time switch to enable the effects
 			of CONFIG_MOVABLE_NODE=y. See mm/Kconfig for details.
 
+	movablenodes=	[KNL,X86] This parameter depends on movable_node, it
+			is used for debugging memory hotplug. Instead SRAT
+			specifies which memory is hotpluggable.
+			e.g. movablenodes=1,2,4
+
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
 
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 66338a6..523e58b 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -157,6 +157,37 @@ static inline int save_add_info(void) {return 1;}
 static inline int save_add_info(void) {return 0;}
 #endif
 
+static nodemask_t movablenodes_mask;
+
+static void __init parse_movablenodes_one(char *p)
+{
+	int node;
+
+	get_option(&p, &node);
+	node_set(node, movablenodes_mask);
+}
+
+static int __init parse_movablenodes_opt(char *str)
+{
+	nodes_clear(movablenodes_mask);
+
+#ifdef CONFIG_MOVABLE_NODE
+	while (str) {
+		char *k = strchr(str, ',');
+
+		if (k)
+			*k++ = 0;
+		parse_movablenodes_one(str);
+		str = k;
+	}
+#else
+	pr_warn("movable_node option not supported\n");
+#endif
+
+	return 0;
+}
+early_param("movablenodes", parse_movablenodes_opt);
+
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
 int __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
@@ -202,6 +233,11 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		pr_warn("SRAT: Failed to mark hotplug range [mem %#010Lx-%#010Lx] in memblock\n",
 			(unsigned long long)start, (unsigned long long)end - 1);
 
+	if (node_isset(node, movablenodes_mask) &&
+		memblock_mark_hotplug(start, ma->length))
+		pr_warn("SRAT debug: Failed to mark hotplug range [mem %#010Lx-%#010Lx] in memblock\n",
+			(unsigned long long)start, (unsigned long long)end - 1);
+
 	return 0;
 out_err_bad_srat:
 	bad_srat();
-- 
1.7.1


