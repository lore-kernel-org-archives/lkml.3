Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab3ICIrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:47:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60257 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932578Ab3ICIrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:47:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,1012,1367942400"; 
   d="scan'208";a="8390259"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org, joe@perches.com, toshi.kani@hp.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH v2 2/4] acpi cleanup: Use pr_{info|err}() instead of printk() in arch/x86/mm/srat.c
Date: Tue, 3 Sep 2013 16:45:39 +0800
Message-Id: <1378197941-26479-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 16:44:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 16:44:52,
	Serialize complete at 2013/09/03 16:44:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_{info|err}() instead of printk() in arch/x86/mm/srat.c.

As suggested by Joe Perches <joe@perches.com>, use pr_fmt(fmt) to simplify
the output format.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/mm/srat.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 1613c02..5adfcfb 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -24,6 +24,8 @@
 #include <asm/apic.h>
 #include <asm/uv/uv.h>
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 int acpi_numa __initdata;
 
 static __init int setup_node(int pxm)
@@ -33,7 +35,7 @@ static __init int setup_node(int pxm)
 
 static __init void bad_srat(void)
 {
-	printk(KERN_ERR "SRAT: SRAT not used.\n");
+	pr_err("SRAT not used.\n");
 	acpi_numa = -1;
 }
 
@@ -71,26 +73,26 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
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
 	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
+		pr_err("Too many proximity domains %x\n", pxm);
 		bad_srat();
 		return;
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
-	       pxm, apic_id, node);
+	pr_info("PXM %u -> APIC 0x%04x -> Node %u\n",
+	        pxm, apic_id, node);
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
@@ -113,7 +115,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node = setup_node(pxm);
 	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
+		pr_err("Too many proximity domains %x\n", pxm);
 		bad_srat();
 		return;
 	}
@@ -124,15 +126,15 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
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
-	       pxm, apic_id, node);
+	pr_info("PXM %u -> APIC 0x%02x -> Node %u\n",
+	        pxm, apic_id, node);
 }
 
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
@@ -157,7 +159,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	node = setup_node(pxm);
 	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
+		pr_err("Too many proximity domains.\n");
 		goto out_err_bad_srat;
 	}
 
@@ -166,9 +168,9 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	node_set(node, numa_nodes_parsed);
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
-	       node, pxm,
-	       (unsigned long long) start, (unsigned long long) end - 1);
+	pr_info("Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
+	        node, pxm,
+	        (unsigned long long) start, (unsigned long long) end - 1);
 
 	return 0;
 out_err_bad_srat:
-- 
1.7.1

