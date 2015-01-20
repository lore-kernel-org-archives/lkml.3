Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbbATDG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:06:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:3977 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbbATDGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:06:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442528293"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v7 05/38] x86/uv: Use new irqdomain interfaces to allocate/free IRQ
Date: Tue, 20 Jan 2015 11:08:08 +0800
Message-Id: <1421723321-8386-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new irqdomain interfaces to allocate/free IRQ, so we could
kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416894816-23245-6-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/platform/uv/uv_irq.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index 0ce673645432..474912d03f40 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -12,6 +12,7 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 
 #include <asm/apic.h>
 #include <asm/uv/uv_irq.h>
@@ -130,24 +131,14 @@ static int
 arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 		       unsigned long mmr_offset, int limit)
 {
-	const struct cpumask *eligible_cpu = cpumask_of(cpu);
 	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
-	int mmr_pnode, err;
-	unsigned int dest;
+	int mmr_pnode;
 
 	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
 			sizeof(unsigned long));
 
-	err = assign_irq_vector(irq, cfg, eligible_cpu);
-	if (err != 0)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(eligible_cpu, eligible_cpu, &dest);
-	if (err != 0)
-		return err;
-
 	if (limit == UV_AFFINITY_CPU)
 		irq_set_status_flags(irq, IRQ_NO_BALANCING);
 	else
@@ -164,7 +155,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	entry->polarity		= 0;
 	entry->trigger		= 0;
 	entry->mask		= 0;
-	entry->dest		= dest;
+	entry->dest		= cfg->dest_apicid;
 
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
@@ -238,9 +229,13 @@ uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
 		 unsigned long mmr_offset, int limit)
 {
-	int ret, irq = irq_alloc_hwirq(uv_blade_to_memory_nid(mmr_blade));
+	int ret, irq;
+	struct irq_alloc_info info;
 
-	if (!irq)
+	init_irq_alloc_info(&info, cpumask_of(cpu));
+	irq = irq_domain_alloc_irqs(NULL, 1, uv_blade_to_memory_nid(mmr_blade),
+				    &info);
+	if (irq <= 0)
 		return -EBUSY;
 
 	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset,
@@ -248,7 +243,7 @@ int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
 	if (ret == irq)
 		uv_set_irq_2_mmr_info(irq, mmr_offset, mmr_blade);
 	else
-		irq_free_hwirq(irq);
+		irq_domain_free_irqs(irq, 1);
 
 	return ret;
 }
@@ -283,6 +278,6 @@ void uv_teardown_irq(unsigned int irq)
 			n = n->rb_right;
 	}
 	spin_unlock_irqrestore(&uv_irq_lock, irqflags);
-	irq_free_hwirq(irq);
+	irq_domain_free_irqs(irq, 1);
 }
 EXPORT_SYMBOL_GPL(uv_teardown_irq);
-- 
1.7.10.4

