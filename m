Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaKZXHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:07:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaKZXHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:07:51 -0500
Date: Wed, 26 Nov 2014 15:06:57 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-d3555fdf8d5724886e9cdaaa11c1c1c978b3832a@git.kernel.org>
Cc: jiang.liu@linux.intel.com, joro@8bytes.org, konrad.wilk@oracle.com,
        bhelgaas@google.com, rdunlap@infradead.org, mingo@kernel.org,
        hpa@zytor.com, bp@alien8.de, tony.luck@intel.com,
        gregkh@linuxfoundation.org, rjw@rjwysocki.net, tglx@linutronix.de,
        yinghai@kernel.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Reply-To: benh@kernel.crashing.org, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        bp@alien8.de, gregkh@linuxfoundation.org, tony.luck@intel.com,
        bhelgaas@google.com, mingo@kernel.org, hpa@zytor.com,
        rdunlap@infradead.org, jiang.liu@linux.intel.com,
        konrad.wilk@oracle.com, joro@8bytes.org
In-Reply-To: <1416894816-23245-6-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-6-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, uv: Use new irqdomain interfaces to allocate/
 free IRQ
Git-Commit-ID: d3555fdf8d5724886e9cdaaa11c1c1c978b3832a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3555fdf8d5724886e9cdaaa11c1c1c978b3832a
Gitweb:     http://git.kernel.org/tip/d3555fdf8d5724886e9cdaaa11c1c1c978b3832a
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:14 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:24 +0100

x86, uv: Use new irqdomain interfaces to allocate/free IRQ

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
 arch/x86/platform/uv/uv_irq.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index 0ce6736..474912d 100644
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
