Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab3HPKMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:12:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12841 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab3HPKMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:12:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,894,1367942400"; 
   d="scan'208";a="8219332"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org, joe@perches.com,
        akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 3/6] acpi cleanup: Use pr_info() instead of printk() in arch/x86/mm/srat.c
Date: Fri, 16 Aug 2013 18:11:11 +0800
Message-Id: <1376647871-17345-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376637949.1947.3.camel@joe-AO722>
References: <1376637949.1947.3.camel@joe-AO722>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 18:10:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 18:10:54,
	Serialize complete at 2013/08/16 18:10:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_info() instead of printk() in arch/x86/mm/srat.c.

As Joe suggested, define pr_fmt(fmt) as KBUILD_MODNAME ": " fmt to
prefix message with "srat: ".

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/mm/srat.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 71411aa..591f4bb 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -24,6 +24,8 @@
 #include <asm/apic.h>
 #include <asm/uv/uv.h>
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 int acpi_numa __initdata;
 
 static __init int setup_node(int pxm)
@@ -71,8 +73,8 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	pxm = pa->proximity_domain;
 	apic_id = pa->apic_id;
 	if (!apic->apic_id_valid(apic_id)) {
-		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
-			 pxm, apic_id);
+		pr_info("PXM %u -> X2APIC 0x%04x ignored\n",
+			pxm, apic_id);
 		return;
 	}
 	node = setup_node(pxm);
@@ -83,13 +85,13 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	}
 
 	if (apic_id >= MAX_LOCAL_APIC) {
-		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		pr_info("PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;
 	}
 	set_apicid_to_node(apic_id, node);
 	node_set(node, numa_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
+	pr_info("PXM %u -> APIC 0x%04x -> Node %u\n",
 	       pxm, apic_id, node);
 }
 
@@ -124,14 +126,14 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		apic_id = pa->apic_id;
 
 	if (apic_id >= MAX_LOCAL_APIC) {
-		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		pr_info("PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;
 	}
 
 	set_apicid_to_node(apic_id, node);
 	node_set(node, numa_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
+	pr_info("PXM %u -> APIC 0x%02x -> Node %u\n",
 	       pxm, apic_id, node);
 }
 
@@ -169,8 +171,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	node_set(node, numa_nodes_parsed);
 
-	pr_info("SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]%s\n",
-		node, pxm,
+	pr_info("Node %u PXM %u [mem %#010Lx-%#010Lx]%s\n", node, pxm,
 		(unsigned long long) start, (unsigned long long) end - 1,
 		hotpluggable ? " hotplug" : "");
 
-- 
1.7.1

