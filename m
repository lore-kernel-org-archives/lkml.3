Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968091Ab3DSJ36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:29:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51768 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S968037Ab3DSJ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:29:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,508,1363104000"; 
   d="scan'208";a="7095299"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, davej@redhat.com, agordeev@redhat.com,
        suresh.b.siddha@intel.com, mst@redhat.com, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com, tj@kernel.org,
        laijs@cn.fujitsu.com, hannes@cmpxchg.org, davem@davemloft.net,
        mgorman@suse.de, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v1 02/12] acpi: Print Hot-Pluggable Field in SRAT.
Date: Fri, 19 Apr 2013 17:31:39 +0800
Message-Id: <1366363909-12771-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1366363909-12771-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1366363909-12771-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 17:27:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 17:27:28,
	Serialize complete at 2013/04/19 17:27:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hot-Pluggable field in SRAT suggests if the memory could be
hotplugged while the system is running. Print it as well when
parsing SRAT will help users to know which memory is hotpluggable.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/srat.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 443f9ef..5055fa7 100644
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
+	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
 	       node, pxm,
-	       (unsigned long long) start, (unsigned long long) end - 1);
+	       (unsigned long long) start, (unsigned long long) end - 1,
+	       hotpluggable ? "Hot Pluggable" : "");
 
 	return 0;
 out_err_bad_srat:
-- 
1.7.1

