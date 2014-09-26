Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030182AbaIZO45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:56:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:27175 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaIZO4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:56:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292484"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 20/28] x86, irq: Move irq_cfg.irq_2_pin into io_apic.c
Date: Fri, 26 Sep 2014 22:57:50 +0800
Message-Id: <1411743478-31435-21-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now only io_apic.c accesses struct irq_cfg.irq_2_pin, so move irq_2_pin
into struct mp_chip_data in io_apic.c to clean up struct irq_cfg further.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h  |    7 --
 arch/x86/kernel/apic/io_apic.c |  175 +++++++++++++++++++---------------------
 arch/x86/kernel/apic/vector.c  |    3 -
 3 files changed, 82 insertions(+), 103 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 68412c2f97cd..4e46427f7945 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -168,13 +168,6 @@ struct irq_cfg {
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
index 7ab9cea9ae1b..ffa87ef3a2aa 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -78,7 +78,13 @@ static DEFINE_MUTEX(ioapic_mutex);
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
 	bool remapped;
 	bool isa_irq;
@@ -234,16 +240,6 @@ void mp_save_irq(struct mpc_intsrc *m)
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
@@ -398,16 +394,17 @@ static void ioapic_mask_entry(int apic, int pin)
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
@@ -415,16 +412,16 @@ static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pi
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
@@ -432,22 +429,23 @@ static void __remove_pin_from_irq(struct irq_cfg *cfg, int apic, int pin)
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
@@ -457,7 +455,7 @@ static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 	}
 
 	/* old apic/pin didn't exist, so just add new ones */
-	add_pin_to_irq_node(cfg, node, newapic, newpin);
+	add_pin_to_irq_node(data, node, newapic, newpin);
 }
 
 static void __io_apic_modify_irq(struct irq_pin_list *entry,
@@ -475,13 +473,13 @@ static void __io_apic_modify_irq(struct irq_pin_list *entry,
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
 
@@ -497,39 +495,31 @@ static void io_apic_sync(struct irq_pin_list *entry)
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
+static void __unmask_ioapic(struct mp_chip_data *data)
 {
-	mask_ioapic(irqd_cfg(data));
+	io_apic_modify_irq(data, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
-static void __unmask_ioapic(struct irq_cfg *cfg)
-{
-	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
-}
-
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
@@ -1026,14 +1016,13 @@ static int alloc_isa_irq_from_domain(struct irq_domain *domain,
 	struct mp_chip_data *data;
 
 	if (irq_data && irq_data->parent_data) {
-		struct irq_cfg *cfg = irqd_cfg(irq_data);
-
 		/*
 		 * Legacy ISA IRQ has already been allocated, just add pin to
 		 * the pin list assoicated with this IRQ and program the IOAPIC
 		 * entry. The IOAPIC entry
 		 */
-		if (__add_pin_to_irq_node(cfg, node, ioapic, info->ioapic_pin))
+		if (__add_pin_to_irq_node(irq_data->chip_data, node, ioapic,
+					  info->ioapic_pin))
 			return -ENOMEM;
 		data = irq_data->chip_data;
 		ioapic_write_entry(ioapic, pin, data->entry);
@@ -1396,9 +1385,7 @@ static void __init print_IO_APIC(int ioapic_idx)
 void __init print_IO_APICs(void)
 {
 	int ioapic_idx;
-	struct irq_cfg *cfg;
 	unsigned int irq;
-	struct irq_chip *chip;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for_each_ioapic(ioapic_idx)
@@ -1418,18 +1405,20 @@ void __init print_IO_APICs(void)
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
 	for_each_active_irq(irq) {
 		struct irq_pin_list *entry;
+		struct irq_chip *chip;
+		struct mp_chip_data *data;
 
 		chip = irq_get_chip(irq);
 		if (chip != &ioapic_chip)
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
@@ -1739,7 +1728,7 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
 	}
-	__unmask_ioapic(irqd_cfg(data));
+	__unmask_ioapic(data->chip_data);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
@@ -1754,13 +1743,15 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
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
@@ -1777,13 +1768,13 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
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
 
@@ -1800,18 +1791,17 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
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
@@ -1840,31 +1830,31 @@ static inline void ioapic_irqd_unmask(struct irq_data *data,
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
+	struct mp_chip_data *data = irq_data->chip_data;
 	struct irq_pin_list *entry;
 	unsigned long v, flags;
 	bool masked;
 	int i;
 
-	if (ioapic_irq_remapped(data)) {
+	if (ioapic_irq_remapped(irq_data)) {
 		/*
 		 * Intr-remapping uses pin number as the virtual vector
 		 * in the RTE. Actual vector is programmed in
@@ -1873,14 +1863,14 @@ static void ioapic_ack_level(struct irq_data *data)
 		 */
 		ack_APIC_irq();
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		for_each_irq_pin(entry, cfg->irq_2_pin)
+		for_each_irq_pin(entry, data->irq_2_pin)
 			eoi_io_apic(true, entry->apic, entry->pin, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 		return;
 	}
 
 	irq_complete_move(cfg);
-	masked = ioapic_irqd_mask(data, cfg);
+	masked = ioapic_irqd_mask(irq_data);
 
 	/*
 	 * It appears there is an erratum which affects at least version 0x11
@@ -1934,32 +1924,27 @@ static void ioapic_ack_level(struct irq_data *data)
 		atomic_inc(&irq_mis_count);
 
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		for_each_irq_pin(entry, cfg->irq_2_pin)
+		for_each_irq_pin(entry, data->irq_2_pin)
 			eoi_io_apic(false, entry->apic, entry->pin,
 				    cfg->vector);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 
-	ioapic_irqd_unmask(data, cfg, masked);
+	ioapic_irqd_unmask(irq_data, masked);
 }
 
-static int ioapic_set_affinity(struct irq_data *data,
+static int ioapic_set_affinity(struct irq_data *irq_data,
 			       const struct cpumask *mask, bool force)
 {
-	struct irq_data *parent = data->parent_data;
-	unsigned int dest, irq = data->irq;
-	struct irq_cfg *cfg;
+	struct irq_data *parent = irq_data->parent_data;
 	unsigned long flags;
 	int ret;
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	if (ret >= 0 && !ioapic_irq_remapped(data)) {
-		cfg = irqd_cfg(data);
-		/* Only the high 8 bits are valid. */
-		dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
-		__target_IO_APIC_irq(irq, dest, cfg);
-	}
+	if (ret >= 0 && !ioapic_irq_remapped(irq_data))
+		__target_IO_APIC_irq(irq_data->irq, irqd_cfg(irq_data),
+				     irq_data->chip_data);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return ret;
@@ -2108,10 +2093,11 @@ early_param("disable_timer_pin_1", disable_timer_pin_setup);
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
@@ -2133,7 +2119,9 @@ static int mp_alloc_timer_irq(int ioapic, int pin)
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
@@ -2197,9 +2185,9 @@ static inline void __init check_timer(void)
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
@@ -2219,8 +2207,8 @@ static inline void __init check_timer(void)
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
@@ -2306,7 +2294,7 @@ static int mp_irqdomain_create(int ioapic)
 	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
 	bool remapped = false;
 
-	size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(ioapic);
+	size = sizeof(struct mp_pin_info) * hwirqs;
 	ip->pin_info = kzalloc(size, GFP_KERNEL);
 	if (!ip->pin_info)
 		return -ENOMEM;
@@ -3101,12 +3089,13 @@ int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 	}
 
 	data->remapped = remapped;
+	INIT_LIST_HEAD(&data->irq_2_pin);
 	irq_data->hwirq = info->ioapic_pin;
 	irq_data->chip = &ioapic_chip;
 	irq_data->chip_data = data;
 
 	cfg = irqd_cfg(irq_data);
-	add_pin_to_irq_node(cfg, info->ioapic_node, ioapic, pin);
+	add_pin_to_irq_node(data, ioapic_alloc_attr_node(info), ioapic, pin);
 	mp_irqdomain_setup_entry(remapped, irq_data, cfg, pinfo, &data->entry);
 	mp_irqdomain_register_handler(virq, remapped, pinfo->trigger);
 	if (virq < nr_legacy_irqs())
@@ -3123,15 +3112,16 @@ int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
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
 	irq_set_handler(virq, NULL);
@@ -3145,10 +3135,9 @@ int mp_irqdomain_activate(struct irq_domain *domain,
 	unsigned long flags;
 	struct irq_pin_list *entry;
 	struct mp_chip_data *data = irq_data->chip_data;
-	struct irq_cfg *cfg = irqd_cfg(irq_data);
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin)
+	for_each_irq_pin(entry, data->irq_2_pin)
 		__ioapic_write_entry(entry->apic, entry->pin, data->entry);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index c3ba34553b29..89a57f3e353c 100644
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

