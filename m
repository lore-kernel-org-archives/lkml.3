Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbaKERPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:15:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41825 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaKERPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:15:30 -0500
Date: Wed, 5 Nov 2014 09:13:33 -0800
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-5e4df93bbb0be6203a0037676a430abf5373a70e@git.kernel.org>
Cc: bp@alien8.de, gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        tony.luck@intel.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, prarit@redhat.com, jiang.liu@linux.intel.com,
        bhelgaas@google.com, hpa@zytor.com, tglx@linutronix.de,
        rjw@rjwysocki.net, yinghai@kernel.org, rdunlap@infradead.org,
        sebastian@breakpoint.cc, konrad.wilk@oracle.com, joro@8bytes.org
Reply-To: joro@8bytes.org, konrad.wilk@oracle.com, sebastian@breakpoint.cc,
        rdunlap@infradead.org, yinghai@kernel.org, rjw@rjwysocki.net,
        tglx@linutronix.de, hpa@zytor.com, bhelgaas@google.com,
        jiang.liu@linux.intel.com, prarit@redhat.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tony.luck@intel.com,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org, bp@alien8.de
In-Reply-To: <1414397531-28254-5-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-5-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Convert irq_2_pin list to generic list
Git-Commit-ID: 5e4df93bbb0be6203a0037676a430abf5373a70e
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

Commit-ID:  5e4df93bbb0be6203a0037676a430abf5373a70e
Gitweb:     http://git.kernel.org/tip/5e4df93bbb0be6203a0037676a430abf5373a70e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Oct 2014 16:11:55 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 18:10:46 +0100

x86, irq: Convert irq_2_pin list to generic list

Use generic list to replace private list implementation so we can use
the existing helper functions.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1414397531-28254-5-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/include/asm/hw_irq.h  |  2 +-
 arch/x86/kernel/apic/io_apic.c | 28 +++++++++++-----------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b12c45c..66e59e6 100644
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
index 192ca0a..fac6be1 100644
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
@@ -4076,7 +4070,7 @@ void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
 
 	ioapic_mask_entry(ioapic, pin);
 	__remove_pin_from_irq(cfg, ioapic, pin);
-	WARN_ON(cfg->irq_2_pin != NULL);
+	WARN_ON(!list_empty(&cfg->irq_2_pin));
 	arch_teardown_hwirq(virq);
 }
 
