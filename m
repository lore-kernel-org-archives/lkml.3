Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3HPHZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:25:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41268 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753848Ab3HPHZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:25:50 -0400
Message-ID: <1376637949.1947.3.camel@joe-AO722>
Subject: Re: [PATCH 3/6] acpi cleanup: Use pr_info() instead of printk() in
 arch/x86/mm/srat.c
From: Joe Perches <joe@perches.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Fri, 16 Aug 2013 00:25:49 -0700
In-Reply-To: <1376636809-10159-4-git-send-email-tangchen@cn.fujitsu.com>
References: <1376636809-10159-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1376636809-10159-4-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-16 at 15:06 +0800, Tang Chen wrote:
> arch/x86/mm/srat.c

I think it'd be better to use pr_fmt
with the conversions to pr_info and pr_err.

pr_fmt can prefix the appropriate srat: and
so the format strings do not need it.

Something like:
---
 arch/x86/mm/srat.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index cdd0da9..350b4c5 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -9,6 +9,8 @@
  * are in one chunk. Holes between them will be included in the node.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/acpi.h>
 #include <linux/mmzone.h>
@@ -33,7 +35,7 @@ static __init int setup_node(int pxm)
 
 static __init void bad_srat(void)
 {
-	printk(KERN_ERR "SRAT: SRAT not used.\n");
+	pr_err("SRAT not used\n");
 	acpi_numa = -1;
 }
 
@@ -71,26 +73,25 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	pxm = pa->proximity_domain;
 	apic_id = pa->apic_id;
 	if (!apic->apic_id_valid(apic_id)) {
-		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
-			 pxm, apic_id);
+		pr_info("PXM %u -> X2APIC 0x%04x ignored\n", pxm, apic_id);
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
+		pr_info("PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n",
+			pxm, apic_id, node);
 		return;
 	}
 	set_apicid_to_node(apic_id, node);
 	node_set(node, numa_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
-	       pxm, apic_id, node);
+	pr_info("PXM %u -> APIC 0x%04x -> Node %u\n", pxm, apic_id, node);
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
@@ -113,7 +114,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node = setup_node(pxm);
 	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
+		pr_err("Too many proximity domains %x\n", pxm);
 		bad_srat();
 		return;
 	}
@@ -124,15 +125,15 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		apic_id = pa->apic_id;
 
 	if (apic_id >= MAX_LOCAL_APIC) {
-		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		pr_info("PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n",
+			pxm, apic_id, node);
 		return;
 	}
 
 	set_apicid_to_node(apic_id, node);
 	node_set(node, numa_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
-	       pxm, apic_id, node);
+	pr_info("PXM %u -> APIC 0x%02x -> Node %u\n", pxm, apic_id, node);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -165,7 +166,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	node = setup_node(pxm);
 	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
+		pr_err("Too many proximity domains\n");
 		goto out_err_bad_srat;
 	}
 
@@ -174,9 +175,9 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	node_set(node, numa_nodes_parsed);
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
-	       node, pxm,
-	       (unsigned long long) start, (unsigned long long) end - 1);
+	pr_info("Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
+		node, pxm,
+		(unsigned long long) start, (unsigned long long) end - 1);
 
 	return 0;
 out_err_bad_srat:


