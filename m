Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaJ0IJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:09:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:23545 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaJ0IJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:09:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,794,1406617200"; 
   d="scan'208";a="621212717"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [Patch Part1 v3 04/20] x86, irq: Convert irq_2_pin list to generic list
Date: Mon, 27 Oct 2014 16:11:55 +0800
Message-Id: <1414397531-28254-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Use generic list to replace private list implementation so we could
use generic helper functions to operate it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/include/asm/hw_irq.h  |    2 +-
 arch/x86/kernel/apic/io_apic.c |   28 +++++++++++-----------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 64330c2e172e..28f283988c8e 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -138,7 +138,7 @@ struct irq_2_irte {
  * Most irqs are mapped 1:1 with pins.
  */
 struct irq_cfg {
-	struct irq_pin_list	*irq_2_pin;
+	struct list_head	irq_2_pin;
 	cpumask_var_t		domain;
 	cpumask_var_t		old_domain;
 	u8			vector;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 117ec58fff02..00bd61fd1b5a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -74,7 +74,7 @@
 		for_each_pin((idx), (pin))
 
 #define for_each_irq_pin(entry, head) \
-	for (entry = head; entry; entry = entry->next)
+	list_for_each_entry(entry, &head, list)
 
 /*
  *      Is the SiS APIC rmw bug present ?
@@ -229,8 +229,8 @@ void mp_save_irq(struct mpc_intsrc *m)
 }
 
 struct irq_pin_list {
+	struct list_head list;
 	int apic, pin;
-	struct irq_pin_list *next;
 };
 
 static struct irq_pin_list *alloc_irq_pin_list(int node)
@@ -297,6 +297,7 @@ static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
 		goto out_cfg;
 	if (!zalloc_cpumask_var_node(&cfg->old_domain, GFP_KERNEL, node))
 		goto out_domain;
+	INIT_LIST_HEAD(&cfg->irq_2_pin);
 	return cfg;
 out_domain:
 	free_cpumask_var(cfg->domain);
@@ -460,15 +461,12 @@ static void ioapic_mask_entry(int apic, int pin)
  */
 static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
-	struct irq_pin_list **last, *entry;
+	struct irq_pin_list *entry;
 
 	/* don't allow duplicates */
-	last = &cfg->irq_2_pin;
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
+	for_each_irq_pin(entry, cfg->irq_2_pin)
 		if (entry->apic == apic && entry->pin == pin)
 			return 0;
-		last = &entry->next;
-	}
 
 	entry = alloc_irq_pin_list(node);
 	if (!entry) {
@@ -479,22 +477,19 @@ static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pi
 	entry->apic = apic;
 	entry->pin = pin;
 
-	*last = entry;
+	list_add_tail(&entry->list, &cfg->irq_2_pin);
 	return 0;
 }
 
 static void __remove_pin_from_irq(struct irq_cfg *cfg, int apic, int pin)
 {
-	struct irq_pin_list **last, *entry;
+	struct irq_pin_list *tmp, *entry;
 
-	last = &cfg->irq_2_pin;
-	for_each_irq_pin(entry, cfg->irq_2_pin)
+	list_for_each_entry_safe(entry, tmp, &cfg->irq_2_pin, list)
 		if (entry->apic == apic && entry->pin == pin) {
-			*last = entry->next;
+			list_del(&entry->list);
 			kfree(entry);
 			return;
-		} else {
-			last = &entry->next;
 		}
 }
 
@@ -1739,8 +1734,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 		cfg = irq_cfg(irq);
 		if (!cfg)
 			continue;
-		entry = cfg->irq_2_pin;
-		if (!entry)
+		if (list_empty(&cfg->irq_2_pin))
 			continue;
 		printk(KERN_DEBUG "IRQ%d ", irq);
 		for_each_irq_pin(entry, cfg->irq_2_pin)
@@ -4068,7 +4062,7 @@ void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
 
 	ioapic_mask_entry(ioapic, pin);
 	__remove_pin_from_irq(cfg, ioapic, pin);
-	WARN_ON(cfg->irq_2_pin != NULL);
+	WARN_ON(!list_empty(&cfg->irq_2_pin));
 	arch_teardown_hwirq(virq);
 }
 
-- 
1.7.10.4

