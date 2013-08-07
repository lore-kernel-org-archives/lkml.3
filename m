Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab3HGKxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:53:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24966 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932580Ab3HGKxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:53:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8144150"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH v3 01/25] acpi: Print Hot-Pluggable Field in SRAT.
Date: Wed, 7 Aug 2013 18:51:52 +0800
Message-Id: <1375872736-4822-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:17,
	Serialize complete at 2013/08/07 18:52:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hot-Pluggable field in SRAT suggests if the memory could be
hotplugged while the system is running. Print it as well when
parsing SRAT will help users to know which memory is hotpluggable.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/mm/srat.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index cdd0da9..d44c8a4 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -146,6 +146,7 @@ int __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 {
 	u64 start, end;
+	u32 hotpluggable;
 	int node, pxm;
 
 	if (srat_disabled())
@@ -154,7 +155,8 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		goto out_err_bad_srat;
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		goto out_err;
-	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
+	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
+	if (hotpluggable && !save_add_info())
 		goto out_err;
 
 	start = ma->base_address;
@@ -174,9 +176,10 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	node_set(node, numa_nodes_parsed);
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
-	       node, pxm,
-	       (unsigned long long) start, (unsigned long long) end - 1);
+	pr_info("SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]%s\n",
+		node, pxm,
+		(unsigned long long) start, (unsigned long long) end - 1,
+		hotpluggable ? " Hot Pluggable" : "");
 
 	return 0;
 out_err_bad_srat:
-- 
1.7.1

