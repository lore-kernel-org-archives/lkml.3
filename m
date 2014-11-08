Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaKHSQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:16:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:2167 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaKHSQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:16:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413534039"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part3 v3 25/38] x86, irq: Move irq_cfg.irq_2_pin into io_apic.c
Date: Sun,  9 Nov 2014 02:13:25 +0800
Message-Id: <1415470418-10874-26-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now only io_apic.c accesses struct irq_cfg.irq_2_pin, so move irq_2_pin
into struct mp_chip_data in io_apic.c to clean up struct irq_cfg further.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h  |    7 --
 arch/x86/kernel/apic/io_apic.c |  164 +++++++++++++++++++---------------------
 arch/x86/kernel/apic/vector.c  |    3 -
 3 files changed, 77 insertions(+), 97 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a086893fa710..75789c0299e0 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -174,13 +174,6 @@ struct irq_cfg {
 	unsigned int		dest_apicid;
 	u8			vector;
 	u8			move_in_progress : 1;
-	union {
-#ifdef CONFIG_X86_IO_APIC
-		struct {
-			struct list_head	irq_2_pin;
-		};
-#endif
-	};
 };
 
 extern struct irq_domain *x86_vector_domain;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2a10cb9f03bf..69aa3b04448b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -80,7 +80,13 @@ static DEFINE_MUTEX(ioapic_mutex);
 static unsigned int ioapic_dynirq_base;
 static int ioapic_initialized;
 
+struct irq_pin_list {
+	struct list_head list;
+	int apic, pin;
+};
+
 struct mp_chip_data {
+	struct list_head irq_2_pin;
 	struct IO_APIC_route_entry entry;
 	int trigger;
 	int polarity;
@@ -212,16 +218,6 @@ void mp_save_irq(struct mpc_intsrc *m)
 		panic("Max # of irq sources exceeded!!\n");
 }
 
-struct irq_pin_list {
-	struct list_head list;
-	int apic, pin;
-};
-
-static struct irq_pin_list *alloc_irq_pin_list(int node)
-{
-	return kzalloc_node(sizeof(struct irq_pin_list), GFP_ATOMIC, node);
-}
-
 static void alloc_ioapic_saved_registers(int idx)
 {
 	size_t size;
@@ -376,16 +372,17 @@ static void ioapic_mask_entry(int apic, int pin)
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static int __add_pin_to_irq_node(struct mp_chip_data *data,
+				 int node, int apic, int pin)
 {
 	struct irq_pin_list *entry;
 
 	/* don't allow duplicates */
-	for_each_irq_pin(entry, cfg->irq_2_pin)
+	for_each_irq_pin(entry, data->irq_2_pin)
 		if (entry->apic == apic && entry->pin == pin)
 			return 0;
 
-	entry = alloc_irq_pin_list(node);
+	entry = kzalloc_node(sizeof(struct irq_pin_list), GFP_ATOMIC, node);
 	if (!entry) {
 		pr_err("can not alloc irq_pin_list (%d,%d,%d)\n",
 		       node, apic, pin);
@@ -393,16 +390,16 @@ static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pi
 	}
 	entry->apic = apic;
 	entry->pin = pin;
+	list_add_tail(&entry->list, &data->irq_2_pin);
 
-	list_add_tail(&entry->list, &cfg->irq_2_pin);
 	return 0;
 }
 
-static void __remove_pin_from_irq(struct irq_cfg *cfg, int apic, int pin)
+static void __remove_pin_from_irq(struct mp_chip_data *data, int apic, int pin)
 {
 	struct irq_pin_list *tmp, *entry;
 
-	list_for_each_entry_safe(entry, tmp, &cfg->irq_2_pin, list)
+	list_for_each_entry_safe(entry, tmp, &data->irq_2_pin, list)
 		if (entry->apic == apic && entry->pin == pin) {
 			list_del(&entry->list);
 			kfree(entry);
@@ -410,22 +407,23 @@ static void __remove_pin_from_irq(struct irq_cfg *cfg, int apic, int pin)
 		}
 }
 
-static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static void add_pin_to_irq_node(struct mp_chip_data *data,
+				int node, int apic, int pin)
 {
-	if (__add_pin_to_irq_node(cfg, node, apic, pin))
+	if (__add_pin_to_irq_node(data, node, apic, pin))
 		panic("IO-APIC: failed to add irq-pin. Can not proceed\n");
 }
 
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
+static void __init replace_pin_at_irq_node(struct mp_chip_data *data, int node,
 					   int oldapic, int oldpin,
 					   int newapic, int newpin)
 {
 	struct irq_pin_list *entry;
 
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
+	for_each_irq_pin(entry, data->irq_2_pin) {
 		if (entry->apic == oldapic && entry->pin == oldpin) {
 			entry->apic = newapic;
 			entry->pin = newpin;
@@ -435,7 +433,7 @@ static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 	}
 
 	/* old apic/pin didn't exist, so just add new ones */
-	add_pin_to_irq_node(cfg, node, newapic, newpin);
+	add_pin_to_irq_node(data, node, newapic, newpin);
 }
 
 static void __io_apic_modify_irq(struct irq_pin_list *entry,
@@ -453,13 +451,13 @@ static void __io_apic_modify_irq(struct irq_pin_list *entry,
 		final(entry);
 }
 
-static void io_apic_modify_irq(struct irq_cfg *cfg,
+static void io_apic_modify_irq(struct mp_chip_data *data,
 			       int mask_and, int mask_or,
 			       void (*final)(struct irq_pin_list *entry))
 {
 	struct irq_pin_list *entry;
 
-	for_each_irq_pin(entry, cfg->irq_2_pin)
+	for_each_irq_pin(entry, data->irq_2_pin)
 		__io_apic_modify_irq(entry, mask_and, mask_or, final);
 }
 
@@ -475,39 +473,31 @@ static void io_apic_sync(struct irq_pin_list *entry)
 	readl(&io_apic->data);
 }
 
-static void mask_ioapic(struct irq_cfg *cfg)
+static void mask_ioapic_irq(struct irq_data *irq_data)
 {
+	struct mp_chip_data *data = irq_data->chip_data;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
+	io_apic_modify_irq(data, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void mask_ioapic_irq(struct irq_data *data)
-{
-	mask_ioapic(irqd_cfg(data));
-}
-
-static void __unmask_ioapic(struct irq_cfg *cfg)
+static void __unmask_ioapic(struct mp_chip_data *data)
 {
-	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
+	io_apic_modify_irq(data, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
-static void unmask_ioapic(struct irq_cfg *cfg)
+static void unmask_ioapic_irq(struct irq_data *irq_data)
 {
+	struct mp_chip_data *data = irq_data->chip_data;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	__unmask_ioapic(cfg);
+	__unmask_ioapic(data);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void unmask_ioapic_irq(struct irq_data *data)
-{
-	unmask_ioapic(irqd_cfg(data));
-}
-
 /*
  * IO-APIC versions below 0x20 don't support EOI register.
  * For the record, here is the information about various versions:
@@ -548,13 +538,13 @@ static void __eoi_ioapic_pin(int apic, int pin, int vector)
 	}
 }
 
-void eoi_ioapic_pin(int vector, struct irq_cfg *cfg)
+void eoi_ioapic_pin(int vector, struct mp_chip_data *data)
 {
 	unsigned long flags;
 	struct irq_pin_list *entry;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin)
+	for_each_irq_pin(entry, data->irq_2_pin)
 		__eoi_ioapic_pin(entry->apic, entry->pin, vector);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
@@ -1061,11 +1051,10 @@ static int alloc_isa_irq_from_domain(struct irq_domain *domain,
 	 * entry. The IOAPIC entry
 	 */
 	if (irq_data && irq_data->parent_data) {
-		struct irq_cfg *cfg = irqd_cfg(irq_data);
-
 		if (!mp_check_pin_attr(irq, info))
 			return -EBUSY;
-		if (__add_pin_to_irq_node(cfg, node, ioapic, info->ioapic_pin))
+		if (__add_pin_to_irq_node(irq_data->chip_data, node, ioapic,
+					  info->ioapic_pin))
 			return -ENOMEM;
 	} else {
 		irq = __irq_domain_alloc_irqs(domain, irq, 1, node, info, true);
@@ -1387,9 +1376,7 @@ static void __init print_IO_APIC(int ioapic_idx)
 void __init print_IO_APICs(void)
 {
 	int ioapic_idx;
-	struct irq_cfg *cfg;
 	unsigned int irq;
-	struct irq_chip *chip;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for_each_ioapic(ioapic_idx)
@@ -1409,18 +1396,20 @@ void __init print_IO_APICs(void)
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
 	for_each_active_irq(irq) {
 		struct irq_pin_list *entry;
+		struct irq_chip *chip;
+		struct mp_chip_data *data;
 
 		chip = irq_get_chip(irq);
 		if (chip != &ioapic_chip && chip != &ioapic_ir_chip)
 			continue;
-
-		cfg = irq_cfg(irq);
-		if (!cfg)
+		data = irq_get_chip_data(irq);
+		if (!data)
 			continue;
-		if (list_empty(&cfg->irq_2_pin))
+		if (list_empty(&data->irq_2_pin))
 			continue;
+
 		printk(KERN_DEBUG "IRQ%d ", irq);
-		for_each_irq_pin(entry, cfg->irq_2_pin)
+		for_each_irq_pin(entry, data->irq_2_pin)
 			pr_cont("-> %d:%d", entry->apic, entry->pin);
 		pr_cont("\n");
 	}
@@ -1730,7 +1719,7 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
 	}
-	__unmask_ioapic(irqd_cfg(data));
+	__unmask_ioapic(data->chip_data);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
@@ -1745,13 +1734,15 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
  * races.
  */
 
-static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
+static void __target_IO_APIC_irq(unsigned int irq, struct irq_cfg *cfg,
+				 struct mp_chip_data *data)
 {
 	int apic, pin;
 	struct irq_pin_list *entry;
 	u8 vector = cfg->vector;
+	unsigned int dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
 
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
+	for_each_irq_pin(entry, data->irq_2_pin) {
 		unsigned int reg;
 
 		apic = entry->apic;
@@ -1768,13 +1759,13 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 atomic_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
+static bool io_apic_level_ack_pending(struct mp_chip_data *data)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
+	for_each_irq_pin(entry, data->irq_2_pin) {
 		unsigned int reg;
 		int pin;
 
@@ -1791,18 +1782,17 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 	return false;
 }
 
-static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
+static inline bool ioapic_irqd_mask(struct irq_data *data)
 {
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irqd_is_setaffinity_pending(data))) {
-		mask_ioapic(cfg);
+		mask_ioapic_irq(data);
 		return true;
 	}
 	return false;
 }
 
-static inline void ioapic_irqd_unmask(struct irq_data *data,
-				      struct irq_cfg *cfg, bool masked)
+static inline void ioapic_irqd_unmask(struct irq_data *data, bool masked)
 {
 	if (unlikely(masked)) {
 		/* Only migrate the irq if the ack has been received.
@@ -1831,31 +1821,30 @@ static inline void ioapic_irqd_unmask(struct irq_data *data,
 		 * accurate and is causing problems then it is a hardware bug
 		 * and you can go talk to the chipset vendor about it.
 		 */
-		if (!io_apic_level_ack_pending(cfg))
+		if (!io_apic_level_ack_pending(data->chip_data))
 			irq_move_masked_irq(data);
-		unmask_ioapic(cfg);
+		unmask_ioapic_irq(data);
 	}
 }
 #else
-static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
+static inline bool ioapic_irqd_mask(struct irq_data *data)
 {
 	return false;
 }
-static inline void ioapic_irqd_unmask(struct irq_data *data,
-				      struct irq_cfg *cfg, bool masked)
+static inline void ioapic_irqd_unmask(struct irq_data *data, bool masked)
 {
 }
 #endif
 
-static void ioapic_ack_level(struct irq_data *data)
+static void ioapic_ack_level(struct irq_data *irq_data)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
+	struct irq_cfg *cfg = irqd_cfg(irq_data);
 	unsigned long v;
 	bool masked;
 	int i;
 
 	irq_complete_move(cfg);
-	masked = ioapic_irqd_mask(data, cfg);
+	masked = ioapic_irqd_mask(irq_data);
 
 	/*
 	 * It appears there is an erratum which affects at least version 0x11
@@ -1907,10 +1896,10 @@ static void ioapic_ack_level(struct irq_data *data)
 	 */
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
-		eoi_ioapic_pin(cfg->vector, cfg);
+		eoi_ioapic_pin(cfg->vector, irq_data->chip_data);
 	}
 
-	ioapic_irqd_unmask(data, cfg, masked);
+	ioapic_irqd_unmask(irq_data, masked);
 }
 
 static void ioapic_ir_ack_level(struct irq_data *irq_data)
@@ -1924,7 +1913,7 @@ static void ioapic_ir_ack_level(struct irq_data *irq_data)
 	 * EOI we use the pin number.
 	 */
 	ack_APIC_irq();
-	eoi_ioapic_pin(data->entry.vector, irqd_cfg(irq_data));
+	eoi_ioapic_pin(data->entry.vector, data);
 }
 
 static int ioapic_set_affinity(struct irq_data *irq_data,
@@ -1932,7 +1921,6 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
 {
 	struct irq_data *parent = irq_data->parent_data;
 	struct mp_chip_data *data = irq_data->chip_data;
-	unsigned int dest, irq = irq_data->irq;
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	int ret;
@@ -1943,9 +1931,7 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
 		cfg = irqd_cfg(irq_data);
 		data->entry.dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
 		data->entry.vector = cfg->vector;
-		/* Only the high 8 bits are valid. */
-		dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
-		__target_IO_APIC_irq(irq, dest, cfg);
+		__target_IO_APIC_irq(irq_data->irq, cfg, irq_data->chip_data);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -2106,10 +2092,11 @@ early_param("disable_timer_pin_1", disable_timer_pin_setup);
 static int mp_alloc_timer_irq(int ioapic, int pin)
 {
 	int irq = -1;
-	struct irq_alloc_info info;
 	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
 
 	if (domain) {
+		struct irq_alloc_info info;
+
 		ioapic_set_alloc_attr(&info, NUMA_NO_NODE, 0, 0);
 		info.ioapic_id = mpc_ioapic_id(ioapic);
 		info.ioapic_pin = pin;
@@ -2131,7 +2118,9 @@ static int mp_alloc_timer_irq(int ioapic, int pin)
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = irq_cfg(0);
+	struct irq_data *irq_data = irq_get_irq_data(0);
+	struct mp_chip_data *data = irq_data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(irq_data);
 	int node = cpu_to_node(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
@@ -2195,9 +2184,9 @@ static inline void __init check_timer(void)
 			int idx;
 			idx = find_irq_entry(apic1, pin1, mp_INT);
 			if (idx != -1 && irq_trigger(idx))
-				unmask_ioapic(cfg);
+				unmask_ioapic_irq(irq_get_chip_data(0));
 		}
-		irq_domain_activate_irq(irq_get_irq_data(0));
+		irq_domain_activate_irq(irq_data);
 		if (timer_irq_works()) {
 			if (disable_timer_pin_1 > 0)
 				clear_IO_APIC_pin(0, pin1);
@@ -2217,8 +2206,8 @@ static inline void __init check_timer(void)
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
-		irq_domain_activate_irq(irq_get_irq_data(0));
+		replace_pin_at_irq_node(data, node, apic1, pin1, apic2, pin2);
+		irq_domain_activate_irq(irq_data);
 		legacy_pic->unmask(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
@@ -3034,6 +3023,7 @@ int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 		return ret;
 	}
 
+	INIT_LIST_HEAD(&data->irq_2_pin);
 	irq_data->hwirq = info->ioapic_pin;
 	irq_data->chip = (domain->parent == x86_vector_domain) ?
 			  &ioapic_chip : &ioapic_ir_chip;
@@ -3041,7 +3031,7 @@ int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 	mp_irqdomain_get_attr(mp_pin_to_gsi(ioapic, pin), data, info);
 
 	cfg = irqd_cfg(irq_data);
-	add_pin_to_irq_node(cfg, info->ioapic_node, ioapic, pin);
+	add_pin_to_irq_node(data, ioapic_alloc_attr_node(info), ioapic, pin);
 	if (info->ioapic_entry)
 		mp_setup_entry(cfg, data, info->ioapic_entry);
 	mp_register_handler(virq, data->trigger);
@@ -3059,15 +3049,16 @@ int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 void mp_irqdomain_free(struct irq_domain *domain, unsigned int virq,
 		       unsigned int nr_irqs)
 {
-	struct irq_cfg *cfg = irq_cfg(virq);
 	struct irq_data *irq_data;
+	struct mp_chip_data *data;
 
 	BUG_ON(nr_irqs != 1);
 	irq_data = irq_domain_get_irq_data(domain, virq);
 	if (irq_data && irq_data->chip_data) {
-		__remove_pin_from_irq(cfg, mp_irqdomain_ioapic_idx(domain),
+		data = irq_data->chip_data;
+		__remove_pin_from_irq(data, mp_irqdomain_ioapic_idx(domain),
 				      (int)irq_data->hwirq);
-		WARN_ON(!list_empty(&cfg->irq_2_pin));
+		WARN_ON(!list_empty(&data->irq_2_pin));
 		kfree(irq_data->chip_data);
 	}
 	irq_domain_free_irqs_top(domain, virq, nr_irqs);
@@ -3079,10 +3070,9 @@ void mp_irqdomain_activate(struct irq_domain *domain,
 	unsigned long flags;
 	struct irq_pin_list *entry;
 	struct mp_chip_data *data = irq_data->chip_data;
-	struct irq_cfg *cfg = irqd_cfg(irq_data);
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin)
+	for_each_irq_pin(entry, data->irq_2_pin)
 		__ioapic_write_entry(entry->apic, entry->pin, data->entry);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 292ed916032f..59faffbf39cc 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -68,9 +68,6 @@ static struct irq_cfg *alloc_irq_cfg(int node)
 		goto out_cfg;
 	if (!zalloc_cpumask_var_node(&cfg->old_domain, GFP_KERNEL, node))
 		goto out_domain;
-#ifdef	CONFIG_X86_IO_APIC
-	INIT_LIST_HEAD(&cfg->irq_2_pin);
-#endif
 	return cfg;
 out_domain:
 	free_cpumask_var(cfg->domain);
-- 
1.7.10.4

