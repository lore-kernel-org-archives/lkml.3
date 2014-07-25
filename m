Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaGYOn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:43:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:25721 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbaGYOnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:43:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,731,1400050800"; 
   d="scan'208";a="575405152"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 1/2] x86: Resolve shadow warnings from apic_io.h
Date: Fri, 25 Jul 2014 07:43:16 -0700
Message-Id: <1406299397-30077-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Change the name of formal parameters in some static inlines from
apic, which shadows a global of the same name, to apicid. Also
change the formal parameter name on some trace functions for the
same reason. This eliminates many thousands of shadow warnings
in my W=2 kernel build.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 arch/x86/include/asm/io_apic.h |  14 +-
 arch/x86/kernel/apic/io_apic.c | 211 ++++++------
 arch/x86/kvm/lapic.c           | 758 +++++++++++++++++++++--------------------
 arch/x86/kvm/lapic.h           |  23 +-
 arch/x86/kvm/trace.h           |  12 +-
 5 files changed, 518 insertions(+), 500 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0aeed5c..d2205d6 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -211,18 +211,20 @@ extern int native_ioapic_set_affinity(struct irq_data *,
 				      const struct cpumask *,
 				      bool);
 
-static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+static inline unsigned int io_apic_read(unsigned int apicid, unsigned int reg)
 {
-	return x86_io_apic_ops.read(apic, reg);
+	return x86_io_apic_ops.read(apicid, reg);
 }
 
-static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+static inline void io_apic_write(unsigned int apicid, unsigned int reg,
+				 unsigned int value)
 {
-	x86_io_apic_ops.write(apic, reg, value);
+	x86_io_apic_ops.write(apicid, reg, value);
 }
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+static inline void io_apic_modify(unsigned int apicid, unsigned int reg,
+				  unsigned int value)
 {
-	x86_io_apic_ops.modify(apic, reg, value);
+	x86_io_apic_ops.modify(apicid, reg, value);
 }
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a44dce8..03f9f46 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -335,22 +335,23 @@ static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 		+ (mpc_ioapic_addr(idx) & ~PAGE_MASK);
 }
 
-void io_apic_eoi(unsigned int apic, unsigned int vector)
+void io_apic_eoi(unsigned int apicid, unsigned int vector)
 {
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	struct io_apic __iomem *io_apic = io_apic_base(apicid);
 	writel(vector, &io_apic->eoi);
 }
 
-unsigned int native_io_apic_read(unsigned int apic, unsigned int reg)
+unsigned int native_io_apic_read(unsigned int apicid, unsigned int reg)
 {
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	struct io_apic __iomem *io_apic = io_apic_base(apicid);
 	writel(reg, &io_apic->index);
 	return readl(&io_apic->data);
 }
 
-void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+void native_io_apic_write(unsigned int apicid, unsigned int reg,
+			  unsigned int value)
 {
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	struct io_apic __iomem *io_apic = io_apic_base(apicid);
 
 	writel(reg, &io_apic->index);
 	writel(value, &io_apic->data);
@@ -362,9 +363,10 @@ void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int valu
  *
  * Older SiS APIC requires we rewrite the index register
  */
-void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+void native_io_apic_modify(unsigned int apicid, unsigned int reg,
+			   unsigned int value)
 {
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	struct io_apic __iomem *io_apic = io_apic_base(apicid);
 
 	if (sis_apic_bug)
 		writel(reg, &io_apic->index);
@@ -376,23 +378,23 @@ union entry_union {
 	struct IO_APIC_route_entry entry;
 };
 
-static struct IO_APIC_route_entry __ioapic_read_entry(int apic, int pin)
+static struct IO_APIC_route_entry __ioapic_read_entry(int apicid, int pin)
 {
 	union entry_union eu;
 
-	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
-	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
+	eu.w1 = io_apic_read(apicid, 0x10 + 2 * pin);
+	eu.w2 = io_apic_read(apicid, 0x11 + 2 * pin);
 
 	return eu.entry;
 }
 
-static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
+static struct IO_APIC_route_entry ioapic_read_entry(int apicid, int pin)
 {
 	union entry_union eu;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	eu.entry = __ioapic_read_entry(apic, pin);
+	eu.entry = __ioapic_read_entry(apicid, pin);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return eu.entry;
@@ -404,21 +406,23 @@ static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
  * the interrupt, and we need to make sure the entry is fully populated
  * before that happens.
  */
-static void __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
+static void __ioapic_write_entry(int apicid, int pin,
+				 struct IO_APIC_route_entry e)
 {
 	union entry_union eu = {{0, 0}};
 
 	eu.entry = e;
-	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
-	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
+	io_apic_write(apicid, 0x11 + 2*pin, eu.w2);
+	io_apic_write(apicid, 0x10 + 2*pin, eu.w1);
 }
 
-static void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
+static void ioapic_write_entry(int apicid, int pin,
+			       struct IO_APIC_route_entry e)
 {
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	__ioapic_write_entry(apic, pin, e);
+	__ioapic_write_entry(apicid, pin, e);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -427,14 +431,14 @@ static void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
  * word first, in order to set the mask bit before we change the
  * high bits!
  */
-static void ioapic_mask_entry(int apic, int pin)
+static void ioapic_mask_entry(int apicid, int pin)
 {
 	unsigned long flags;
 	union entry_union eu = { .entry.mask = 1 };
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
-	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
+	io_apic_write(apicid, 0x10 + 2*pin, eu.w1);
+	io_apic_write(apicid, 0x11 + 2*pin, eu.w2);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -443,14 +447,15 @@ static void ioapic_mask_entry(int apic, int pin)
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apicid,
+				 int pin)
 {
 	struct irq_pin_list **last, *entry;
 
 	/* don't allow duplicates */
 	last = &cfg->irq_2_pin;
 	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		if (entry->apic == apic && entry->pin == pin)
+		if (entry->apic == apicid && entry->pin == pin)
 			return 0;
 		last = &entry->next;
 	}
@@ -458,23 +463,23 @@ static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pi
 	entry = alloc_irq_pin_list(node);
 	if (!entry) {
 		pr_err("can not alloc irq_pin_list (%d,%d,%d)\n",
-		       node, apic, pin);
+		       node, apicid, pin);
 		return -ENOMEM;
 	}
-	entry->apic = apic;
+	entry->apic = apicid;
 	entry->pin = pin;
 
 	*last = entry;
 	return 0;
 }
 
-static void __remove_pin_from_irq(struct irq_cfg *cfg, int apic, int pin)
+static void __remove_pin_from_irq(struct irq_cfg *cfg, int apicid, int pin)
 {
 	struct irq_pin_list **last, *entry;
 
 	last = &cfg->irq_2_pin;
 	for_each_irq_pin(entry, cfg->irq_2_pin)
-		if (entry->apic == apic && entry->pin == pin) {
+		if (entry->apic == apicid && entry->pin == pin) {
 			*last = entry->next;
 			kfree(entry);
 			return;
@@ -483,9 +488,10 @@ static void __remove_pin_from_irq(struct irq_cfg *cfg, int apic, int pin)
 		}
 }
 
-static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apicid,
+				int pin)
 {
-	if (__add_pin_to_irq_node(cfg, node, apic, pin))
+	if (__add_pin_to_irq_node(cfg, node, apicid, pin))
 		panic("IO-APIC: failed to add irq-pin. Can not proceed\n");
 }
 
@@ -597,14 +603,14 @@ static void unmask_ioapic_irq(struct irq_data *data)
  * Otherwise, we simulate the EOI message manually by changing the trigger
  * mode to edge and then back to level, with RTE being masked during this.
  */
-void native_eoi_ioapic_pin(int apic, int pin, int vector)
+void native_eoi_ioapic_pin(int apicid, int pin, int vector)
 {
-	if (mpc_ioapic_ver(apic) >= 0x20) {
-		io_apic_eoi(apic, vector);
+	if (mpc_ioapic_ver(apicid) >= 0x20) {
+		io_apic_eoi(apicid, vector);
 	} else {
 		struct IO_APIC_route_entry entry, entry1;
 
-		entry = entry1 = __ioapic_read_entry(apic, pin);
+		entry = entry1 = __ioapic_read_entry(apicid, pin);
 
 		/*
 		 * Mask the entry and change the trigger mode to edge.
@@ -612,12 +618,12 @@ void native_eoi_ioapic_pin(int apic, int pin, int vector)
 		entry1.mask = 1;
 		entry1.trigger = IOAPIC_EDGE;
 
-		__ioapic_write_entry(apic, pin, entry1);
+		__ioapic_write_entry(apicid, pin, entry1);
 
 		/*
 		 * Restore the previous level triggered entry.
 		 */
-		__ioapic_write_entry(apic, pin, entry);
+		__ioapic_write_entry(apicid, pin, entry);
 	}
 }
 
@@ -633,12 +639,12 @@ void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
+static void clear_IO_APIC_pin(unsigned int apicid, unsigned int pin)
 {
 	struct IO_APIC_route_entry entry;
 
 	/* Check delivery_mode to be sure we're not clearing an SMI pin */
-	entry = ioapic_read_entry(apic, pin);
+	entry = ioapic_read_entry(apicid, pin);
 	if (entry.delivery_mode == dest_SMI)
 		return;
 
@@ -648,8 +654,8 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 	 */
 	if (!entry.mask) {
 		entry.mask = 1;
-		ioapic_write_entry(apic, pin, entry);
-		entry = ioapic_read_entry(apic, pin);
+		ioapic_write_entry(apicid, pin, entry);
+		entry = ioapic_read_entry(apicid, pin);
 	}
 
 	if (entry.irr) {
@@ -662,11 +668,11 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 		 */
 		if (!entry.trigger) {
 			entry.trigger = IOAPIC_LEVEL;
-			ioapic_write_entry(apic, pin, entry);
+			ioapic_write_entry(apicid, pin, entry);
 		}
 
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		x86_io_apic_ops.eoi_ioapic_pin(apic, pin, entry.vector);
+		x86_io_apic_ops.eoi_ioapic_pin(apicid, pin, entry.vector);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 
@@ -674,19 +680,19 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 	 * Clear the rest of the bits in the IO-APIC RTE except for the mask
 	 * bit.
 	 */
-	ioapic_mask_entry(apic, pin);
-	entry = ioapic_read_entry(apic, pin);
+	ioapic_mask_entry(apicid, pin);
+	entry = ioapic_read_entry(apicid, pin);
 	if (entry.irr)
 		pr_err("Unable to reset IRR for apic: %d, pin :%d\n",
-		       mpc_ioapic_id(apic), pin);
+		       mpc_ioapic_id(apicid), pin);
 }
 
 static void clear_IO_APIC (void)
 {
-	int apic, pin;
+	int apicid, pin;
 
-	for_each_ioapic_pin(apic, pin)
-		clear_IO_APIC_pin(apic, pin);
+	for_each_ioapic_pin(apicid, pin)
+		clear_IO_APIC_pin(apicid, pin);
 }
 
 #ifdef CONFIG_X86_32
@@ -732,18 +738,18 @@ __setup("pirq=", ioapic_pirq_setup);
  */
 int save_ioapic_entries(void)
 {
-	int apic, pin;
+	int apicid, pin;
 	int err = 0;
 
-	for_each_ioapic(apic) {
-		if (!ioapics[apic].saved_registers) {
+	for_each_ioapic(apicid) {
+		if (!ioapics[apicid].saved_registers) {
 			err = -ENOMEM;
 			continue;
 		}
 
-		for_each_pin(apic, pin)
-			ioapics[apic].saved_registers[pin] =
-				ioapic_read_entry(apic, pin);
+		for_each_pin(apicid, pin)
+			ioapics[apicid].saved_registers[pin] =
+				ioapic_read_entry(apicid, pin);
 	}
 
 	return err;
@@ -754,19 +760,19 @@ int save_ioapic_entries(void)
  */
 void mask_ioapic_entries(void)
 {
-	int apic, pin;
+	int apicid, pin;
 
-	for_each_ioapic(apic) {
-		if (!ioapics[apic].saved_registers)
+	for_each_ioapic(apicid) {
+		if (!ioapics[apicid].saved_registers)
 			continue;
 
-		for_each_pin(apic, pin) {
+		for_each_pin(apicid, pin) {
 			struct IO_APIC_route_entry entry;
 
-			entry = ioapics[apic].saved_registers[pin];
+			entry = ioapics[apicid].saved_registers[pin];
 			if (!entry.mask) {
 				entry.mask = 1;
-				ioapic_write_entry(apic, pin, entry);
+				ioapic_write_entry(apicid, pin, entry);
 			}
 		}
 	}
@@ -777,15 +783,15 @@ void mask_ioapic_entries(void)
  */
 int restore_ioapic_entries(void)
 {
-	int apic, pin;
+	int apicid, pin;
 
-	for_each_ioapic(apic) {
-		if (!ioapics[apic].saved_registers)
+	for_each_ioapic(apicid) {
+		if (!ioapics[apicid].saved_registers)
 			continue;
 
-		for_each_pin(apic, pin)
-			ioapic_write_entry(apic, pin,
-					   ioapics[apic].saved_registers[pin]);
+		for_each_pin(apicid, pin)
+			ioapic_write_entry(apicid, pin,
+					  ioapics[apicid].saved_registers[pin]);
 	}
 	return 0;
 }
@@ -1028,12 +1034,12 @@ static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin)
 	return irq > 0 ? irq : -1;
 }
 
-static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
+static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapicid, int pin,
 			     unsigned int flags)
 {
 	int irq;
-	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
-	struct mp_pin_info *info = mp_pin_info(ioapic, pin);
+	struct irq_domain *domain = mp_ioapic_irqdomain(ioapicid);
+	struct mp_pin_info *info = mp_pin_info(ioapicid, pin);
 
 	if (!domain)
 		return -1;
@@ -1081,9 +1087,9 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 	return irq > 0 ? irq : -1;
 }
 
-static int pin_2_irq(int idx, int ioapic, int pin, unsigned int flags)
+static int pin_2_irq(int idx, int ioapicid, int pin, unsigned int flags)
 {
-	u32 gsi = mp_pin_to_gsi(ioapic, pin);
+	u32 gsi = mp_pin_to_gsi(ioapicid, pin);
 
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
@@ -1111,43 +1117,43 @@ static int pin_2_irq(int idx, int ioapic, int pin, unsigned int flags)
 	}
 #endif
 
-	return  mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags);
+	return  mp_map_pin_to_irq(gsi, idx, ioapicid, pin, flags);
 }
 
 int mp_map_gsi_to_irq(u32 gsi, unsigned int flags)
 {
-	int ioapic, pin, idx;
+	int ioapicid, pin, idx;
 
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0)
+	ioapicid = mp_find_ioapic(gsi);
+	if (ioapicid < 0)
 		return -1;
 
-	pin = mp_find_ioapic_pin(ioapic, gsi);
-	idx = find_irq_entry(ioapic, pin, mp_INT);
+	pin = mp_find_ioapic_pin(ioapicid, gsi);
+	idx = find_irq_entry(ioapicid, pin, mp_INT);
 	if ((flags & IOAPIC_MAP_CHECK) && idx < 0)
 		return -1;
 
-	return mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags);
+	return mp_map_pin_to_irq(gsi, idx, ioapicid, pin, flags);
 }
 
 void mp_unmap_irq(int irq)
 {
 	struct irq_data *data = irq_get_irq_data(irq);
 	struct mp_pin_info *info;
-	int ioapic, pin;
+	int ioapicid, pin;
 
 	if (!data || !data->domain)
 		return;
 
-	ioapic = (int)(long)data->domain->host_data;
+	ioapicid = (int)(long)data->domain->host_data;
 	pin = (int)data->hwirq;
-	info = mp_pin_info(ioapic, pin);
+	info = mp_pin_info(ioapicid, pin);
 
 	mutex_lock(&ioapic_mutex);
 	if (--info->count == 0) {
 		info->set = 0;
 		if (irq < nr_legacy_irqs() &&
-		    ioapics[ioapic].irqdomain_cfg.type == IOAPIC_DOMAIN_LEGACY)
+		   ioapics[ioapicid].irqdomain_cfg.type == IOAPIC_DOMAIN_LEGACY)
 			mp_irqdomain_unmap(data->domain, irq);
 		else
 			irq_dispose_mapping(irq);
@@ -1576,7 +1582,7 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 	ioapic_write_entry(ioapic_idx, pin, entry);
 }
 
-void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
+void native_io_apic_print_entries(unsigned int apicid, unsigned int nr_entries)
 {
 	int i;
 
@@ -1585,7 +1591,7 @@ void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 	for (i = 0; i <= nr_entries; i++) {
 		struct IO_APIC_route_entry entry;
 
-		entry = ioapic_read_entry(apic, i);
+		entry = ioapic_read_entry(apicid, i);
 
 		pr_debug(" %02x %02X  ", i, entry.dest);
 		pr_cont("%1d    %1d    %1d   %1d   %1d    "
@@ -1601,7 +1607,7 @@ void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 	}
 }
 
-void intel_ir_io_apic_print_entries(unsigned int apic,
+void intel_ir_io_apic_print_entries(unsigned int apicid,
 				    unsigned int nr_entries)
 {
 	int i;
@@ -1612,7 +1618,7 @@ void intel_ir_io_apic_print_entries(unsigned int apic,
 		struct IR_IO_APIC_route_entry *ir_entry;
 		struct IO_APIC_route_entry entry;
 
-		entry = ioapic_read_entry(apic, i);
+		entry = ioapic_read_entry(apicid, i);
 
 		ir_entry = (struct IR_IO_APIC_route_entry *)&entry;
 
@@ -1943,20 +1949,21 @@ static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 void __init enable_IO_APIC(void)
 {
 	int i8259_apic, i8259_pin;
-	int apic, pin;
+	int apicid, pin;
 
 	if (!nr_legacy_irqs())
 		return;
 
-	for_each_ioapic_pin(apic, pin) {
+	for_each_ioapic_pin(apicid, pin) {
 		/* See if any of the pins is in ExtINT mode */
-		struct IO_APIC_route_entry entry = ioapic_read_entry(apic, pin);
+		struct IO_APIC_route_entry entry = ioapic_read_entry(apicid,
+								     pin);
 
 		/* If the interrupt line is enabled and in ExtInt mode
 		 * I have found the pin where the i8259 is connected.
 		 */
 		if ((entry.mask == 0) && (entry.delivery_mode == dest_ExtINT)) {
-			ioapic_i8259.apic = apic;
+			ioapic_i8259.apic = apicid;
 			ioapic_i8259.pin  = pin;
 			goto found_i8259;
 		}
@@ -2377,21 +2384,21 @@ static inline void irq_complete_move(struct irq_cfg *cfg) { }
 
 static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
 {
-	int apic, pin;
+	int apicid, pin;
 	struct irq_pin_list *entry;
 	u8 vector = cfg->vector;
 
 	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 
-		apic = entry->apic;
+		apicid = entry->apic;
 		pin = entry->pin;
 
-		io_apic_write(apic, 0x11 + pin*2, dest);
-		reg = io_apic_read(apic, 0x10 + pin*2);
+		io_apic_write(apicid, 0x11 + pin*2, dest);
+		reg = io_apic_read(apicid, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
-		io_apic_modify(apic, 0x10 + pin*2, reg);
+		io_apic_modify(apicid, 0x10 + pin*2, reg);
 	}
 }
 
@@ -2690,7 +2697,7 @@ static void lapic_register_intr(int irq)
  */
 static inline void __init unlock_ExtINT_logic(void)
 {
-	int apic, pin, i;
+	int apicid, pin, i;
 	struct IO_APIC_route_entry entry0, entry1;
 	unsigned char save_control, save_freq_select;
 
@@ -2699,14 +2706,14 @@ static inline void __init unlock_ExtINT_logic(void)
 		WARN_ON_ONCE(1);
 		return;
 	}
-	apic = find_isa_irq_apic(8, mp_INT);
-	if (apic == -1) {
+	apicid = find_isa_irq_apic(8, mp_INT);
+	if (apicid == -1) {
 		WARN_ON_ONCE(1);
 		return;
 	}
 
-	entry0 = ioapic_read_entry(apic, pin);
-	clear_IO_APIC_pin(apic, pin);
+	entry0 = ioapic_read_entry(apicid, pin);
+	clear_IO_APIC_pin(apicid, pin);
 
 	memset(&entry1, 0, sizeof(entry1));
 
@@ -2718,7 +2725,7 @@ static inline void __init unlock_ExtINT_logic(void)
 	entry1.trigger = 0;
 	entry1.vector = 0;
 
-	ioapic_write_entry(apic, pin, entry1);
+	ioapic_write_entry(apicid, pin, entry1);
 
 	save_control = CMOS_READ(RTC_CONTROL);
 	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
@@ -2735,9 +2742,9 @@ static inline void __init unlock_ExtINT_logic(void)
 
 	CMOS_WRITE(save_control, RTC_CONTROL);
 	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
-	clear_IO_APIC_pin(apic, pin);
+	clear_IO_APIC_pin(apicid, pin);
 
-	ioapic_write_entry(apic, pin, entry0);
+	ioapic_write_entry(apicid, pin, entry0);
 }
 
 static int disable_timer_pin_1 __initdata;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0069118..e33d61c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -71,9 +71,9 @@
 #define VEC_POS(v) ((v) & (32 - 1))
 #define REG_POS(v) (((v) >> 5) << 4)
 
-static inline void apic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
+static inline void apic_set_reg(struct kvm_lapic *lapic, int reg_off, u32 val)
 {
-	*((u32 *) (apic->regs + reg_off)) = val;
+	*((u32 *) (lapic->regs + reg_off)) = val;
 }
 
 static inline int apic_test_vector(int vec, void *bitmap)
@@ -83,10 +83,10 @@ static inline int apic_test_vector(int vec, void *bitmap)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
-	return apic_test_vector(vector, apic->regs + APIC_ISR) ||
-		apic_test_vector(vector, apic->regs + APIC_IRR);
+	return apic_test_vector(vector, lapic->regs + APIC_ISR) ||
+		apic_test_vector(vector, lapic->regs + APIC_IRR);
 }
 
 static inline void apic_set_vector(int vec, void *bitmap)
@@ -112,20 +112,21 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
 struct static_key_deferred apic_hw_disabled __read_mostly;
 struct static_key_deferred apic_sw_disabled __read_mostly;
 
-static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
+static inline void apic_set_spiv(struct kvm_lapic *lapic, u32 val)
 {
-	if ((kvm_apic_get_reg(apic, APIC_SPIV) ^ val) & APIC_SPIV_APIC_ENABLED) {
+	if ((kvm_apic_get_reg(lapic, APIC_SPIV) ^ val) &
+	    APIC_SPIV_APIC_ENABLED) {
 		if (val & APIC_SPIV_APIC_ENABLED)
 			static_key_slow_dec_deferred(&apic_sw_disabled);
 		else
 			static_key_slow_inc(&apic_sw_disabled.key);
 	}
-	apic_set_reg(apic, APIC_SPIV, val);
+	apic_set_reg(lapic, APIC_SPIV, val);
 }
 
-static inline int apic_enabled(struct kvm_lapic *apic)
+static inline int apic_enabled(struct kvm_lapic *lapic)
 {
-	return kvm_apic_sw_enabled(apic) &&	kvm_apic_hw_enabled(apic);
+	return kvm_apic_sw_enabled(lapic) && kvm_apic_hw_enabled(lapic);
 }
 
 #define LVT_MASK	\
@@ -135,9 +136,9 @@ static inline int apic_enabled(struct kvm_lapic *apic)
 	(LVT_MASK | APIC_MODE_MASK | APIC_INPUT_POLARITY | \
 	 APIC_LVT_REMOTE_IRR | APIC_LVT_LEVEL_TRIGGER)
 
-static inline int kvm_apic_id(struct kvm_lapic *apic)
+static inline int kvm_apic_id(struct kvm_lapic *lapic)
 {
-	return (kvm_apic_get_reg(apic, APIC_ID) >> 24) & 0xff;
+	return (kvm_apic_get_reg(lapic, APIC_ID) >> 24) & 0xff;
 }
 
 #define KVM_X2APIC_CID_BITS 0
@@ -162,7 +163,7 @@ static void recalculate_apic_map(struct kvm *kvm)
 	new->lid_mask = 0xff;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		struct kvm_lapic *apic = vcpu->arch.apic;
+		struct kvm_lapic *lapic = vcpu->arch.apic;
 		u16 cid, lid;
 		u32 ldr;
 
@@ -176,27 +177,28 @@ static void recalculate_apic_map(struct kvm *kvm)
 		 * find apic with different setting we assume this is the mode
 		 * OS wants all apics to be in; build lookup table accordingly.
 		 */
-		if (apic_x2apic_mode(apic)) {
+		if (apic_x2apic_mode(lapic)) {
 			new->ldr_bits = 32;
 			new->cid_shift = 16;
 			new->cid_mask = (1 << KVM_X2APIC_CID_BITS) - 1;
 			new->lid_mask = 0xffff;
-		} else if (kvm_apic_sw_enabled(apic) &&
+		} else if (kvm_apic_sw_enabled(lapic) &&
 				!new->cid_mask /* flat mode */ &&
-				kvm_apic_get_reg(apic, APIC_DFR) == APIC_DFR_CLUSTER) {
+				kvm_apic_get_reg(lapic, APIC_DFR) ==
+						 APIC_DFR_CLUSTER) {
 			new->cid_shift = 4;
 			new->cid_mask = 0xf;
 			new->lid_mask = 0xf;
 		}
 
-		new->phys_map[kvm_apic_id(apic)] = apic;
+		new->phys_map[kvm_apic_id(lapic)] = lapic;
 
-		ldr = kvm_apic_get_reg(apic, APIC_LDR);
+		ldr = kvm_apic_get_reg(lapic, APIC_LDR);
 		cid = apic_cluster_id(new, ldr);
 		lid = apic_logical_id(new, ldr);
 
 		if (lid)
-			new->logical_map[cid][ffs(lid) - 1] = apic;
+			new->logical_map[cid][ffs(lid) - 1] = lapic;
 	}
 out:
 	old = rcu_dereference_protected(kvm->arch.apic_map,
@@ -210,44 +212,44 @@ out:
 	kvm_vcpu_request_scan_ioapic(kvm);
 }
 
-static inline void kvm_apic_set_id(struct kvm_lapic *apic, u8 id)
+static inline void kvm_apic_set_id(struct kvm_lapic *lapic, u8 id)
 {
-	apic_set_reg(apic, APIC_ID, id << 24);
-	recalculate_apic_map(apic->vcpu->kvm);
+	apic_set_reg(lapic, APIC_ID, id << 24);
+	recalculate_apic_map(lapic->vcpu->kvm);
 }
 
-static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
+static inline void kvm_apic_set_ldr(struct kvm_lapic *lapic, u32 id)
 {
-	apic_set_reg(apic, APIC_LDR, id);
-	recalculate_apic_map(apic->vcpu->kvm);
+	apic_set_reg(lapic, APIC_LDR, id);
+	recalculate_apic_map(lapic->vcpu->kvm);
 }
 
-static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
+static inline int apic_lvt_enabled(struct kvm_lapic *lapic, int lvt_type)
 {
-	return !(kvm_apic_get_reg(apic, lvt_type) & APIC_LVT_MASKED);
+	return !(kvm_apic_get_reg(lapic, lvt_type) & APIC_LVT_MASKED);
 }
 
-static inline int apic_lvt_vector(struct kvm_lapic *apic, int lvt_type)
+static inline int apic_lvt_vector(struct kvm_lapic *lapic, int lvt_type)
 {
-	return kvm_apic_get_reg(apic, lvt_type) & APIC_VECTOR_MASK;
+	return kvm_apic_get_reg(lapic, lvt_type) & APIC_VECTOR_MASK;
 }
 
-static inline int apic_lvtt_oneshot(struct kvm_lapic *apic)
+static inline int apic_lvtt_oneshot(struct kvm_lapic *lapic)
 {
-	return ((kvm_apic_get_reg(apic, APIC_LVTT) &
-		apic->lapic_timer.timer_mode_mask) == APIC_LVT_TIMER_ONESHOT);
+	return ((kvm_apic_get_reg(lapic, APIC_LVTT) &
+		lapic->lapic_timer.timer_mode_mask) == APIC_LVT_TIMER_ONESHOT);
 }
 
-static inline int apic_lvtt_period(struct kvm_lapic *apic)
+static inline int apic_lvtt_period(struct kvm_lapic *lapic)
 {
-	return ((kvm_apic_get_reg(apic, APIC_LVTT) &
-		apic->lapic_timer.timer_mode_mask) == APIC_LVT_TIMER_PERIODIC);
+	return ((kvm_apic_get_reg(lapic, APIC_LVTT) &
+		lapic->lapic_timer.timer_mode_mask) == APIC_LVT_TIMER_PERIODIC);
 }
 
-static inline int apic_lvtt_tscdeadline(struct kvm_lapic *apic)
+static inline int apic_lvtt_tscdeadline(struct kvm_lapic *lapic)
 {
-	return ((kvm_apic_get_reg(apic, APIC_LVTT) &
-		apic->lapic_timer.timer_mode_mask) ==
+	return ((kvm_apic_get_reg(lapic, APIC_LVTT) &
+		lapic->lapic_timer.timer_mode_mask) ==
 			APIC_LVT_TIMER_TSCDEADLINE);
 }
 
@@ -258,17 +260,17 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *feat;
 	u32 v = APIC_VERSION;
 
 	if (!kvm_vcpu_has_lapic(vcpu))
 		return;
 
-	feat = kvm_find_cpuid_entry(apic->vcpu, 0x1, 0);
+	feat = kvm_find_cpuid_entry(lapic->vcpu, 0x1, 0);
 	if (feat && (feat->ecx & (1 << (X86_FEATURE_X2APIC & 31))))
 		v |= APIC_LVR_DIRECTED_EOI;
-	apic_set_reg(apic, APIC_LVR, v);
+	apic_set_reg(lapic, APIC_LVR, v);
 }
 
 static const unsigned int apic_lvt_mask[APIC_LVT_NUM] = {
@@ -311,28 +313,29 @@ static u8 count_vectors(void *bitmap)
 void kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir)
 {
 	u32 i, pir_val;
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
 	for (i = 0; i <= 7; i++) {
 		pir_val = xchg(&pir[i], 0);
-		if (pir_val)
-			*((u32 *)(apic->regs + APIC_IRR + i * 0x10)) |= pir_val;
+		if (!pir_val)
+			continue;
+		*((u32 *)(lapic->regs + APIC_IRR + i * 0x10)) |= pir_val;
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_apic_update_irr);
 
-static inline void apic_set_irr(int vec, struct kvm_lapic *apic)
+static inline void apic_set_irr(int vec, struct kvm_lapic *lapic)
 {
-	apic->irr_pending = true;
-	apic_set_vector(vec, apic->regs + APIC_IRR);
+	lapic->irr_pending = true;
+	apic_set_vector(vec, lapic->regs + APIC_IRR);
 }
 
-static inline int apic_search_irr(struct kvm_lapic *apic)
+static inline int apic_search_irr(struct kvm_lapic *lapic)
 {
-	return find_highest_vector(apic->regs + APIC_IRR);
+	return find_highest_vector(lapic->regs + APIC_IRR);
 }
 
-static inline int apic_find_highest_irr(struct kvm_lapic *apic)
+static inline int apic_find_highest_irr(struct kvm_lapic *lapic)
 {
 	int result;
 
@@ -340,40 +343,40 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 	 * Note that irr_pending is just a hint. It will be always
 	 * true with virtual interrupt delivery enabled.
 	 */
-	if (!apic->irr_pending)
+	if (!lapic->irr_pending)
 		return -1;
 
-	kvm_x86_ops->sync_pir_to_irr(apic->vcpu);
-	result = apic_search_irr(apic);
+	kvm_x86_ops->sync_pir_to_irr(lapic->vcpu);
+	result = apic_search_irr(lapic);
 	ASSERT(result == -1 || result >= 16);
 
 	return result;
 }
 
-static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
+static inline void apic_clear_irr(int vec, struct kvm_lapic *lapic)
 {
-	apic->irr_pending = false;
-	apic_clear_vector(vec, apic->regs + APIC_IRR);
-	if (apic_search_irr(apic) != -1)
-		apic->irr_pending = true;
+	lapic->irr_pending = false;
+	apic_clear_vector(vec, lapic->regs + APIC_IRR);
+	if (apic_search_irr(lapic) != -1)
+		lapic->irr_pending = true;
 }
 
-static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
+static inline void apic_set_isr(int vec, struct kvm_lapic *lapic)
 {
 	/* Note that we never get here with APIC virtualization enabled.  */
 
-	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
-		++apic->isr_count;
-	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
+	if (!__apic_test_and_set_vector(vec, lapic->regs + APIC_ISR))
+		++lapic->isr_count;
+	BUG_ON(lapic->isr_count > MAX_APIC_VECTOR);
 	/*
 	 * ISR (in service register) bit is set when injecting an interrupt.
 	 * The highest vector is injected. Thus the latest bit set matches
 	 * the highest bit in ISR.
 	 */
-	apic->highest_isr_cache = vec;
+	lapic->highest_isr_cache = vec;
 }
 
-static inline int apic_find_highest_isr(struct kvm_lapic *apic)
+static inline int apic_find_highest_isr(struct kvm_lapic *lapic)
 {
 	int result;
 
@@ -381,24 +384,24 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 	 * Note that isr_count is always 1, and highest_isr_cache
 	 * is always -1, with APIC virtualization enabled.
 	 */
-	if (!apic->isr_count)
+	if (!lapic->isr_count)
 		return -1;
-	if (likely(apic->highest_isr_cache != -1))
-		return apic->highest_isr_cache;
+	if (likely(lapic->highest_isr_cache != -1))
+		return lapic->highest_isr_cache;
 
-	result = find_highest_vector(apic->regs + APIC_ISR);
+	result = find_highest_vector(lapic->regs + APIC_ISR);
 	ASSERT(result == -1 || result >= 16);
 
 	return result;
 }
 
-static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
+static inline void apic_clear_isr(int vec, struct kvm_lapic *lapic)
 {
 	struct kvm_vcpu *vcpu;
-	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
+	if (!__apic_test_and_clear_vector(vec, lapic->regs + APIC_ISR))
 		return;
 
-	vcpu = apic->vcpu;
+	vcpu = lapic->vcpu;
 
 	/*
 	 * We do get here for APIC virtualization enabled if the guest
@@ -409,11 +412,11 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 */
 	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
 		kvm_x86_ops->hwapic_isr_update(vcpu->kvm,
-					       apic_find_highest_isr(apic));
+					       apic_find_highest_isr(lapic));
 	else {
-		--apic->isr_count;
-		BUG_ON(apic->isr_count < 0);
-		apic->highest_isr_cache = -1;
+		--lapic->isr_count;
+		BUG_ON(lapic->isr_count < 0);
+		lapic->highest_isr_cache = -1;
 	}
 }
 
@@ -433,16 +436,16 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 	return highest_irr;
 }
 
-static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
+static int __apic_accept_irq(struct kvm_lapic *lapic, int delivery_mode,
 			     int vector, int level, int trig_mode,
 			     unsigned long *dest_map);
 
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		unsigned long *dest_map)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
-	return __apic_accept_irq(apic, irq->delivery_mode, irq->vector,
+	return __apic_accept_irq(lapic, irq->delivery_mode, irq->vector,
 			irq->level, irq->trig_mode, dest_map);
 }
 
@@ -496,21 +499,21 @@ static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
 
 void kvm_apic_update_tmr(struct kvm_vcpu *vcpu, u32 *tmr)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 	int i;
 
 	for (i = 0; i < 8; i++)
-		apic_set_reg(apic, APIC_TMR + 0x10 * i, tmr[i]);
+		apic_set_reg(lapic, APIC_TMR + 0x10 * i, tmr[i]);
 }
 
-static void apic_update_ppr(struct kvm_lapic *apic)
+static void apic_update_ppr(struct kvm_lapic *lapic)
 {
 	u32 tpr, isrv, ppr, old_ppr;
 	int isr;
 
-	old_ppr = kvm_apic_get_reg(apic, APIC_PROCPRI);
-	tpr = kvm_apic_get_reg(apic, APIC_TASKPRI);
-	isr = apic_find_highest_isr(apic);
+	old_ppr = kvm_apic_get_reg(lapic, APIC_PROCPRI);
+	tpr = kvm_apic_get_reg(lapic, APIC_TASKPRI);
+	isr = apic_find_highest_isr(lapic);
 	isrv = (isr != -1) ? isr : 0;
 
 	if ((tpr & 0xf0) >= (isrv & 0xf0))
@@ -519,39 +522,39 @@ static void apic_update_ppr(struct kvm_lapic *apic)
 		ppr = isrv & 0xf0;
 
 	apic_debug("vlapic %p, ppr 0x%x, isr 0x%x, isrv 0x%x",
-		   apic, ppr, isr, isrv);
+		   lapic, ppr, isr, isrv);
 
 	if (old_ppr != ppr) {
-		apic_set_reg(apic, APIC_PROCPRI, ppr);
+		apic_set_reg(lapic, APIC_PROCPRI, ppr);
 		if (ppr < old_ppr)
-			kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+			kvm_make_request(KVM_REQ_EVENT, lapic->vcpu);
 	}
 }
 
-static void apic_set_tpr(struct kvm_lapic *apic, u32 tpr)
+static void apic_set_tpr(struct kvm_lapic *lapic, u32 tpr)
 {
-	apic_set_reg(apic, APIC_TASKPRI, tpr);
-	apic_update_ppr(apic);
+	apic_set_reg(lapic, APIC_TASKPRI, tpr);
+	apic_update_ppr(lapic);
 }
 
-int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest)
+int kvm_apic_match_physical_addr(struct kvm_lapic *lapic, u16 dest)
 {
-	return dest == 0xff || kvm_apic_id(apic) == dest;
+	return dest == 0xff || kvm_apic_id(lapic) == dest;
 }
 
-int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
+int kvm_apic_match_logical_addr(struct kvm_lapic *lapic, u8 mda)
 {
 	int result = 0;
 	u32 logical_id;
 
-	if (apic_x2apic_mode(apic)) {
-		logical_id = kvm_apic_get_reg(apic, APIC_LDR);
+	if (apic_x2apic_mode(lapic)) {
+		logical_id = kvm_apic_get_reg(lapic, APIC_LDR);
 		return logical_id & mda;
 	}
 
-	logical_id = GET_APIC_LOGICAL_ID(kvm_apic_get_reg(apic, APIC_LDR));
+	logical_id = GET_APIC_LOGICAL_ID(kvm_apic_get_reg(lapic, APIC_LDR));
 
-	switch (kvm_apic_get_reg(apic, APIC_DFR)) {
+	switch (kvm_apic_get_reg(lapic, APIC_DFR)) {
 	case APIC_DFR_FLAT:
 		if (logical_id & mda)
 			result = 1;
@@ -563,7 +566,8 @@ int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
 		break;
 	default:
 		apic_debug("Bad DFR vcpu %d: %08x\n",
-			   apic->vcpu->vcpu_id, kvm_apic_get_reg(apic, APIC_DFR));
+			   lapic->vcpu->vcpu_id,
+			   kvm_apic_get_reg(lapic, APIC_DFR));
 		break;
 	}
 
@@ -678,19 +682,19 @@ out:
  * Add a pending IRQ into lapic.
  * Return 1 if successfully added and 0 if discarded.
  */
-static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
+static int __apic_accept_irq(struct kvm_lapic *lapic, int delivery_mode,
 			     int vector, int level, int trig_mode,
 			     unsigned long *dest_map)
 {
 	int result = 0;
-	struct kvm_vcpu *vcpu = apic->vcpu;
+	struct kvm_vcpu *vcpu = lapic->vcpu;
 
 	switch (delivery_mode) {
 	case APIC_DM_LOWEST:
 		vcpu->arch.apic_arb_prio++;
 	case APIC_DM_FIXED:
 		/* FIXME add logic for vcpu on reset */
-		if (unlikely(!apic_enabled(apic)))
+		if (unlikely(!apic_enabled(lapic)))
 			break;
 
 		result = 1;
@@ -701,7 +705,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		if (kvm_x86_ops->deliver_posted_interrupt)
 			kvm_x86_ops->deliver_posted_interrupt(vcpu, vector);
 		else {
-			apic_set_irr(vector, apic);
+			apic_set_irr(vector, lapic);
 
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
@@ -731,7 +735,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		if (!trig_mode || level) {
 			result = 1;
 			/* assumes that there are only KVM_APIC_INIT/SIPI */
-			apic->pending_events = (1UL << KVM_APIC_INIT);
+			lapic->pending_events = (1UL << KVM_APIC_INIT);
 			/* make sure pending_events is visible before sending
 			 * the request */
 			smp_wmb();
@@ -747,10 +751,10 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		apic_debug("SIPI to vcpu %d vector 0x%02x\n",
 			   vcpu->vcpu_id, vector);
 		result = 1;
-		apic->sipi_vector = vector;
+		lapic->sipi_vector = vector;
 		/* make sure sipi_vector is visible for the receiver */
 		smp_wmb();
-		set_bit(KVM_APIC_SIPI, &apic->pending_events);
+		set_bit(KVM_APIC_SIPI, &lapic->pending_events);
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_vcpu_kick(vcpu);
 		break;
@@ -776,24 +780,24 @@ int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
 }
 
-static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
+static void kvm_ioapic_send_eoi(struct kvm_lapic *lapic, int vector)
 {
-	if (!(kvm_apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
-	    kvm_ioapic_handles_vector(apic->vcpu->kvm, vector)) {
+	if (!(kvm_apic_get_reg(lapic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
+	    kvm_ioapic_handles_vector(lapic->vcpu->kvm, vector)) {
 		int trigger_mode;
-		if (apic_test_vector(vector, apic->regs + APIC_TMR))
+		if (apic_test_vector(vector, lapic->regs + APIC_TMR))
 			trigger_mode = IOAPIC_LEVEL_TRIG;
 		else
 			trigger_mode = IOAPIC_EDGE_TRIG;
-		kvm_ioapic_update_eoi(apic->vcpu, vector, trigger_mode);
+		kvm_ioapic_update_eoi(lapic->vcpu, vector, trigger_mode);
 	}
 }
 
-static int apic_set_eoi(struct kvm_lapic *apic)
+static int apic_set_eoi(struct kvm_lapic *lapic)
 {
-	int vector = apic_find_highest_isr(apic);
+	int vector = apic_find_highest_isr(lapic);
 
-	trace_kvm_eoi(apic, vector);
+	trace_kvm_eoi(lapic, vector);
 
 	/*
 	 * Not every write EOI will has corresponding ISR,
@@ -802,11 +806,11 @@ static int apic_set_eoi(struct kvm_lapic *apic)
 	if (vector == -1)
 		return vector;
 
-	apic_clear_isr(vector, apic);
-	apic_update_ppr(apic);
+	apic_clear_isr(vector, lapic);
+	apic_update_ppr(lapic);
 
-	kvm_ioapic_send_eoi(apic, vector);
-	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+	kvm_ioapic_send_eoi(lapic, vector);
+	kvm_make_request(KVM_REQ_EVENT, lapic->vcpu);
 	return vector;
 }
 
@@ -816,19 +820,19 @@ static int apic_set_eoi(struct kvm_lapic *apic)
  */
 void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
-	trace_kvm_eoi(apic, vector);
+	trace_kvm_eoi(lapic, vector);
 
-	kvm_ioapic_send_eoi(apic, vector);
-	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+	kvm_ioapic_send_eoi(lapic, vector);
+	kvm_make_request(KVM_REQ_EVENT, lapic->vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
 
-static void apic_send_ipi(struct kvm_lapic *apic)
+static void apic_send_ipi(struct kvm_lapic *lapic)
 {
-	u32 icr_low = kvm_apic_get_reg(apic, APIC_ICR);
-	u32 icr_high = kvm_apic_get_reg(apic, APIC_ICR2);
+	u32 icr_low = kvm_apic_get_reg(lapic, APIC_ICR);
+	u32 icr_high = kvm_apic_get_reg(lapic, APIC_ICR2);
 	struct kvm_lapic_irq irq;
 
 	irq.vector = icr_low & APIC_VECTOR_MASK;
@@ -837,7 +841,7 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	irq.level = icr_low & APIC_INT_ASSERT;
 	irq.trig_mode = icr_low & APIC_INT_LEVELTRIG;
 	irq.shorthand = icr_low & APIC_SHORT_MASK;
-	if (apic_x2apic_mode(apic))
+	if (apic_x2apic_mode(lapic))
 		irq.dest_id = icr_high;
 	else
 		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
@@ -851,36 +855,36 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 		   irq.trig_mode, irq.level, irq.dest_mode, irq.delivery_mode,
 		   irq.vector);
 
-	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
+	kvm_irq_delivery_to_apic(lapic->vcpu->kvm, lapic, &irq, NULL);
 }
 
-static u32 apic_get_tmcct(struct kvm_lapic *apic)
+static u32 apic_get_tmcct(struct kvm_lapic *lapic)
 {
 	ktime_t remaining;
 	s64 ns;
 	u32 tmcct;
 
-	ASSERT(apic != NULL);
+	ASSERT(lapic != NULL);
 
 	/* if initial count is 0, current count should also be 0 */
-	if (kvm_apic_get_reg(apic, APIC_TMICT) == 0 ||
-		apic->lapic_timer.period == 0)
+	if (kvm_apic_get_reg(lapic, APIC_TMICT) == 0 ||
+		lapic->lapic_timer.period == 0)
 		return 0;
 
-	remaining = hrtimer_get_remaining(&apic->lapic_timer.timer);
+	remaining = hrtimer_get_remaining(&lapic->lapic_timer.timer);
 	if (ktime_to_ns(remaining) < 0)
 		remaining = ktime_set(0, 0);
 
-	ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
+	ns = mod_64(ktime_to_ns(remaining), lapic->lapic_timer.period);
 	tmcct = div64_u64(ns,
-			 (APIC_BUS_CYCLE_NS * apic->divide_count));
+			  (APIC_BUS_CYCLE_NS * lapic->divide_count));
 
 	return tmcct;
 }
 
-static void __report_tpr_access(struct kvm_lapic *apic, bool write)
+static void __report_tpr_access(struct kvm_lapic *lapic, bool write)
 {
-	struct kvm_vcpu *vcpu = apic->vcpu;
+	struct kvm_vcpu *vcpu = lapic->vcpu;
 	struct kvm_run *run = vcpu->run;
 
 	kvm_make_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu);
@@ -888,13 +892,13 @@ static void __report_tpr_access(struct kvm_lapic *apic, bool write)
 	run->tpr_access.is_write = write;
 }
 
-static inline void report_tpr_access(struct kvm_lapic *apic, bool write)
+static inline void report_tpr_access(struct kvm_lapic *lapic, bool write)
 {
-	if (apic->vcpu->arch.tpr_access_reporting)
-		__report_tpr_access(apic, write);
+	if (lapic->vcpu->arch.tpr_access_reporting)
+		__report_tpr_access(lapic, write);
 }
 
-static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
+static u32 __apic_read(struct kvm_lapic *lapic, unsigned int offset)
 {
 	u32 val = 0;
 
@@ -903,30 +907,30 @@ static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
 
 	switch (offset) {
 	case APIC_ID:
-		if (apic_x2apic_mode(apic))
-			val = kvm_apic_id(apic);
+		if (apic_x2apic_mode(lapic))
+			val = kvm_apic_id(lapic);
 		else
-			val = kvm_apic_id(apic) << 24;
+			val = kvm_apic_id(lapic) << 24;
 		break;
 	case APIC_ARBPRI:
 		apic_debug("Access APIC ARBPRI register which is for P6\n");
 		break;
 
 	case APIC_TMCCT:	/* Timer CCR */
-		if (apic_lvtt_tscdeadline(apic))
+		if (apic_lvtt_tscdeadline(lapic))
 			return 0;
 
-		val = apic_get_tmcct(apic);
+		val = apic_get_tmcct(lapic);
 		break;
 	case APIC_PROCPRI:
-		apic_update_ppr(apic);
-		val = kvm_apic_get_reg(apic, offset);
+		apic_update_ppr(lapic);
+		val = kvm_apic_get_reg(lapic, offset);
 		break;
 	case APIC_TASKPRI:
-		report_tpr_access(apic, false);
+		report_tpr_access(lapic, false);
 		/* fall thru */
 	default:
-		val = kvm_apic_get_reg(apic, offset);
+		val = kvm_apic_get_reg(lapic, offset);
 		break;
 	}
 
@@ -938,7 +942,7 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_lapic, dev);
 }
 
-static int apic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
+static int apic_reg_read(struct kvm_lapic *lapic, u32 offset, int len,
 		void *data)
 {
 	unsigned char alignment = offset & 0xf;
@@ -958,7 +962,7 @@ static int apic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		return 1;
 	}
 
-	result = __apic_read(apic, offset & ~0xf);
+	result = __apic_read(lapic, offset & ~0xf);
 
 	trace_kvm_apic_read(offset, result);
 
@@ -976,73 +980,74 @@ static int apic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	return 0;
 }
 
-static int apic_mmio_in_range(struct kvm_lapic *apic, gpa_t addr)
+static int apic_mmio_in_range(struct kvm_lapic *lapic, gpa_t addr)
 {
-	return kvm_apic_hw_enabled(apic) &&
-	    addr >= apic->base_address &&
-	    addr < apic->base_address + LAPIC_MMIO_LENGTH;
+	return kvm_apic_hw_enabled(lapic) &&
+	       addr >= lapic->base_address &&
+	       addr < lapic->base_address + LAPIC_MMIO_LENGTH;
 }
 
 static int apic_mmio_read(struct kvm_io_device *this,
 			   gpa_t address, int len, void *data)
 {
-	struct kvm_lapic *apic = to_lapic(this);
-	u32 offset = address - apic->base_address;
+	struct kvm_lapic *lapic = to_lapic(this);
+	u32 offset = address - lapic->base_address;
 
-	if (!apic_mmio_in_range(apic, address))
+	if (!apic_mmio_in_range(lapic, address))
 		return -EOPNOTSUPP;
 
-	apic_reg_read(apic, offset, len, data);
+	apic_reg_read(lapic, offset, len, data);
 
 	return 0;
 }
 
-static void update_divide_count(struct kvm_lapic *apic)
+static void update_divide_count(struct kvm_lapic *lapic)
 {
 	u32 tmp1, tmp2, tdcr;
 
-	tdcr = kvm_apic_get_reg(apic, APIC_TDCR);
+	tdcr = kvm_apic_get_reg(lapic, APIC_TDCR);
 	tmp1 = tdcr & 0xf;
 	tmp2 = ((tmp1 & 0x3) | ((tmp1 & 0x8) >> 1)) + 1;
-	apic->divide_count = 0x1 << (tmp2 & 0x7);
+	lapic->divide_count = 0x1 << (tmp2 & 0x7);
 
 	apic_debug("timer divide count is 0x%x\n",
-				   apic->divide_count);
+		   lapic->divide_count);
 }
 
-static void start_apic_timer(struct kvm_lapic *apic)
+static void start_apic_timer(struct kvm_lapic *lapic)
 {
 	ktime_t now;
-	atomic_set(&apic->lapic_timer.pending, 0);
+	atomic_set(&lapic->lapic_timer.pending, 0);
 
-	if (apic_lvtt_period(apic) || apic_lvtt_oneshot(apic)) {
+	if (apic_lvtt_period(lapic) || apic_lvtt_oneshot(lapic)) {
 		/* lapic timer in oneshot or periodic mode */
-		now = apic->lapic_timer.timer.base->get_time();
-		apic->lapic_timer.period = (u64)kvm_apic_get_reg(apic, APIC_TMICT)
-			    * APIC_BUS_CYCLE_NS * apic->divide_count;
+		now = lapic->lapic_timer.timer.base->get_time();
+		lapic->lapic_timer.period = (u64)kvm_apic_get_reg(lapic,
+								  APIC_TMICT)
+			    * APIC_BUS_CYCLE_NS * lapic->divide_count;
 
-		if (!apic->lapic_timer.period)
+		if (!lapic->lapic_timer.period)
 			return;
 		/*
 		 * Do not allow the guest to program periodic timers with small
 		 * interval, since the hrtimers are not throttled by the host
 		 * scheduler.
 		 */
-		if (apic_lvtt_period(apic)) {
+		if (apic_lvtt_period(lapic)) {
 			s64 min_period = min_timer_period_us * 1000LL;
 
-			if (apic->lapic_timer.period < min_period) {
+			if (lapic->lapic_timer.period < min_period) {
 				pr_info_ratelimited(
 				    "kvm: vcpu %i: requested %lld ns "
 				    "lapic timer period limited to %lld ns\n",
-				    apic->vcpu->vcpu_id,
-				    apic->lapic_timer.period, min_period);
-				apic->lapic_timer.period = min_period;
+				    lapic->vcpu->vcpu_id,
+				    lapic->lapic_timer.period, min_period);
+				lapic->lapic_timer.period = min_period;
 			}
 		}
 
-		hrtimer_start(&apic->lapic_timer.timer,
-			      ktime_add_ns(now, apic->lapic_timer.period),
+		hrtimer_start(&lapic->lapic_timer.timer,
+			      ktime_add_ns(now, lapic->lapic_timer.period),
 			      HRTIMER_MODE_ABS);
 
 		apic_debug("%s: bus cycle is %" PRId64 "ns, now 0x%016"
@@ -1050,15 +1055,15 @@ static void start_apic_timer(struct kvm_lapic *apic)
 			   "timer initial count 0x%x, period %lldns, "
 			   "expire @ 0x%016" PRIx64 ".\n", __func__,
 			   APIC_BUS_CYCLE_NS, ktime_to_ns(now),
-			   kvm_apic_get_reg(apic, APIC_TMICT),
-			   apic->lapic_timer.period,
+			   kvm_apic_get_reg(lapic, APIC_TMICT),
+			   lapic->lapic_timer.period,
 			   ktime_to_ns(ktime_add_ns(now,
-					apic->lapic_timer.period)));
-	} else if (apic_lvtt_tscdeadline(apic)) {
+						   lapic->lapic_timer.period)));
+	} else if (apic_lvtt_tscdeadline(lapic)) {
 		/* lapic timer in tsc deadline mode */
-		u64 guest_tsc, tscdeadline = apic->lapic_timer.tscdeadline;
+		u64 guest_tsc, tscdeadline = lapic->lapic_timer.tscdeadline;
 		u64 ns = 0;
-		struct kvm_vcpu *vcpu = apic->vcpu;
+		struct kvm_vcpu *vcpu = lapic->vcpu;
 		unsigned long this_tsc_khz = vcpu->arch.virtual_tsc_khz;
 		unsigned long flags;
 
@@ -1067,34 +1072,35 @@ static void start_apic_timer(struct kvm_lapic *apic)
 
 		local_irq_save(flags);
 
-		now = apic->lapic_timer.timer.base->get_time();
+		now = lapic->lapic_timer.timer.base->get_time();
 		guest_tsc = kvm_x86_ops->read_l1_tsc(vcpu, native_read_tsc());
 		if (likely(tscdeadline > guest_tsc)) {
 			ns = (tscdeadline - guest_tsc) * 1000000ULL;
 			do_div(ns, this_tsc_khz);
 		}
-		hrtimer_start(&apic->lapic_timer.timer,
+		hrtimer_start(&lapic->lapic_timer.timer,
 			ktime_add_ns(now, ns), HRTIMER_MODE_ABS);
 
 		local_irq_restore(flags);
 	}
 }
 
-static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
+static void apic_manage_nmi_watchdog(struct kvm_lapic *lapic, u32 lvt0_val)
 {
-	int nmi_wd_enabled = apic_lvt_nmi_mode(kvm_apic_get_reg(apic, APIC_LVT0));
+	int nmi_wd_enabled = apic_lvt_nmi_mode(kvm_apic_get_reg(lapic,
+								APIC_LVT0));
 
 	if (apic_lvt_nmi_mode(lvt0_val)) {
 		if (!nmi_wd_enabled) {
-			apic_debug("Receive NMI setting on APIC_LVT0 "
-				   "for cpu %d\n", apic->vcpu->vcpu_id);
-			apic->vcpu->kvm->arch.vapics_in_nmi_mode++;
+			apic_debug("Receive NMI setting on APIC_LVT0 for cpu %d\n",
+				   lapic->vcpu->vcpu_id);
+			lapic->vcpu->kvm->arch.vapics_in_nmi_mode++;
 		}
 	} else if (nmi_wd_enabled)
-		apic->vcpu->kvm->arch.vapics_in_nmi_mode--;
+		lapic->vcpu->kvm->arch.vapics_in_nmi_mode--;
 }
 
-static int apic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
+static int apic_reg_write(struct kvm_lapic *lapic, u32 reg, u32 val)
 {
 	int ret = 0;
 
@@ -1102,122 +1108,122 @@ static int apic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 	switch (reg) {
 	case APIC_ID:		/* Local APIC ID */
-		if (!apic_x2apic_mode(apic))
-			kvm_apic_set_id(apic, val >> 24);
+		if (!apic_x2apic_mode(lapic))
+			kvm_apic_set_id(lapic, val >> 24);
 		else
 			ret = 1;
 		break;
 
 	case APIC_TASKPRI:
-		report_tpr_access(apic, true);
-		apic_set_tpr(apic, val & 0xff);
+		report_tpr_access(lapic, true);
+		apic_set_tpr(lapic, val & 0xff);
 		break;
 
 	case APIC_EOI:
-		apic_set_eoi(apic);
+		apic_set_eoi(lapic);
 		break;
 
 	case APIC_LDR:
-		if (!apic_x2apic_mode(apic))
-			kvm_apic_set_ldr(apic, val & APIC_LDR_MASK);
+		if (!apic_x2apic_mode(lapic))
+			kvm_apic_set_ldr(lapic, val & APIC_LDR_MASK);
 		else
 			ret = 1;
 		break;
 
 	case APIC_DFR:
-		if (!apic_x2apic_mode(apic)) {
-			apic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
-			recalculate_apic_map(apic->vcpu->kvm);
+		if (!apic_x2apic_mode(lapic)) {
+			apic_set_reg(lapic, APIC_DFR, val | 0x0FFFFFFF);
+			recalculate_apic_map(lapic->vcpu->kvm);
 		} else
 			ret = 1;
 		break;
 
 	case APIC_SPIV: {
 		u32 mask = 0x3ff;
-		if (kvm_apic_get_reg(apic, APIC_LVR) & APIC_LVR_DIRECTED_EOI)
+		if (kvm_apic_get_reg(lapic, APIC_LVR) & APIC_LVR_DIRECTED_EOI)
 			mask |= APIC_SPIV_DIRECTED_EOI;
-		apic_set_spiv(apic, val & mask);
+		apic_set_spiv(lapic, val & mask);
 		if (!(val & APIC_SPIV_APIC_ENABLED)) {
 			int i;
 			u32 lvt_val;
 
 			for (i = 0; i < APIC_LVT_NUM; i++) {
-				lvt_val = kvm_apic_get_reg(apic,
+				lvt_val = kvm_apic_get_reg(lapic,
 						       APIC_LVTT + 0x10 * i);
-				apic_set_reg(apic, APIC_LVTT + 0x10 * i,
+				apic_set_reg(lapic, APIC_LVTT + 0x10 * i,
 					     lvt_val | APIC_LVT_MASKED);
 			}
-			atomic_set(&apic->lapic_timer.pending, 0);
+			atomic_set(&lapic->lapic_timer.pending, 0);
 
 		}
 		break;
 	}
 	case APIC_ICR:
 		/* No delay here, so we always clear the pending bit */
-		apic_set_reg(apic, APIC_ICR, val & ~(1 << 12));
-		apic_send_ipi(apic);
+		apic_set_reg(lapic, APIC_ICR, val & ~(1 << 12));
+		apic_send_ipi(lapic);
 		break;
 
 	case APIC_ICR2:
-		if (!apic_x2apic_mode(apic))
+		if (!apic_x2apic_mode(lapic))
 			val &= 0xff000000;
-		apic_set_reg(apic, APIC_ICR2, val);
+		apic_set_reg(lapic, APIC_ICR2, val);
 		break;
 
 	case APIC_LVT0:
-		apic_manage_nmi_watchdog(apic, val);
+		apic_manage_nmi_watchdog(lapic, val);
 	case APIC_LVTTHMR:
 	case APIC_LVTPC:
 	case APIC_LVT1:
 	case APIC_LVTERR:
 		/* TODO: Check vector */
-		if (!kvm_apic_sw_enabled(apic))
+		if (!kvm_apic_sw_enabled(lapic))
 			val |= APIC_LVT_MASKED;
 
 		val &= apic_lvt_mask[(reg - APIC_LVTT) >> 4];
-		apic_set_reg(apic, reg, val);
+		apic_set_reg(lapic, reg, val);
 
 		break;
 
 	case APIC_LVTT:
-		if ((kvm_apic_get_reg(apic, APIC_LVTT) &
-		    apic->lapic_timer.timer_mode_mask) !=
-		   (val & apic->lapic_timer.timer_mode_mask))
-			hrtimer_cancel(&apic->lapic_timer.timer);
+		if ((kvm_apic_get_reg(lapic, APIC_LVTT) &
+		    lapic->lapic_timer.timer_mode_mask) !=
+		   (val & lapic->lapic_timer.timer_mode_mask))
+			hrtimer_cancel(&lapic->lapic_timer.timer);
 
-		if (!kvm_apic_sw_enabled(apic))
+		if (!kvm_apic_sw_enabled(lapic))
 			val |= APIC_LVT_MASKED;
-		val &= (apic_lvt_mask[0] | apic->lapic_timer.timer_mode_mask);
-		apic_set_reg(apic, APIC_LVTT, val);
+		val &= (apic_lvt_mask[0] | lapic->lapic_timer.timer_mode_mask);
+		apic_set_reg(lapic, APIC_LVTT, val);
 		break;
 
 	case APIC_TMICT:
-		if (apic_lvtt_tscdeadline(apic))
+		if (apic_lvtt_tscdeadline(lapic))
 			break;
 
-		hrtimer_cancel(&apic->lapic_timer.timer);
-		apic_set_reg(apic, APIC_TMICT, val);
-		start_apic_timer(apic);
+		hrtimer_cancel(&lapic->lapic_timer.timer);
+		apic_set_reg(lapic, APIC_TMICT, val);
+		start_apic_timer(lapic);
 		break;
 
 	case APIC_TDCR:
 		if (val & 4)
 			apic_debug("KVM_WRITE:TDCR %x\n", val);
-		apic_set_reg(apic, APIC_TDCR, val);
-		update_divide_count(apic);
+		apic_set_reg(lapic, APIC_TDCR, val);
+		update_divide_count(lapic);
 		break;
 
 	case APIC_ESR:
-		if (apic_x2apic_mode(apic) && val != 0) {
+		if (apic_x2apic_mode(lapic) && val != 0) {
 			apic_debug("KVM_WRITE:ESR not zero %x\n", val);
 			ret = 1;
 		}
 		break;
 
 	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic)) {
-			apic_reg_write(apic, APIC_ICR, 0x40000 | (val & 0xff));
-		} else
+		if (apic_x2apic_mode(lapic))
+			apic_reg_write(lapic, APIC_ICR, 0x40000 | (val & 0xff));
+		else
 			ret = 1;
 		break;
 	default:
@@ -1232,11 +1238,11 @@ static int apic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 static int apic_mmio_write(struct kvm_io_device *this,
 			    gpa_t address, int len, const void *data)
 {
-	struct kvm_lapic *apic = to_lapic(this);
-	unsigned int offset = address - apic->base_address;
+	struct kvm_lapic *lapic = to_lapic(this);
+	unsigned int offset = address - lapic->base_address;
 	u32 val;
 
-	if (!apic_mmio_in_range(apic, address))
+	if (!apic_mmio_in_range(lapic, address))
 		return -EOPNOTSUPP;
 
 	/*
@@ -1257,7 +1263,7 @@ static int apic_mmio_write(struct kvm_io_device *this,
 		apic_debug("%s: offset 0x%x with length 0x%x, and value is "
 			   "0x%x\n", __func__, offset, len, val);
 
-	apic_reg_write(apic, offset & 0xff0, val);
+	apic_reg_write(lapic, offset & 0xff0, val);
 
 	return 0;
 }
@@ -1286,23 +1292,23 @@ EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
 
 void kvm_free_lapic(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
 	if (!vcpu->arch.apic)
 		return;
 
-	hrtimer_cancel(&apic->lapic_timer.timer);
+	hrtimer_cancel(&lapic->lapic_timer.timer);
 
 	if (!(vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE))
 		static_key_slow_dec_deferred(&apic_hw_disabled);
 
-	if (!(kvm_apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_APIC_ENABLED))
+	if (!(kvm_apic_get_reg(lapic, APIC_SPIV) & APIC_SPIV_APIC_ENABLED))
 		static_key_slow_dec_deferred(&apic_sw_disabled);
 
-	if (apic->regs)
-		free_page((unsigned long)apic->regs);
+	if (lapic->regs)
+		free_page((unsigned long)lapic->regs);
 
-	kfree(apic);
+	kfree(lapic);
 }
 
 /*
@@ -1313,37 +1319,37 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
-	if (!kvm_vcpu_has_lapic(vcpu) || apic_lvtt_oneshot(apic) ||
-			apic_lvtt_period(apic))
+	if (!kvm_vcpu_has_lapic(vcpu) || apic_lvtt_oneshot(lapic) ||
+			apic_lvtt_period(lapic))
 		return 0;
 
-	return apic->lapic_timer.tscdeadline;
+	return lapic->lapic_timer.tscdeadline;
 }
 
 void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
-	if (!kvm_vcpu_has_lapic(vcpu) || apic_lvtt_oneshot(apic) ||
-			apic_lvtt_period(apic))
+	if (!kvm_vcpu_has_lapic(vcpu) || apic_lvtt_oneshot(lapic) ||
+			apic_lvtt_period(lapic))
 		return;
 
-	hrtimer_cancel(&apic->lapic_timer.timer);
-	apic->lapic_timer.tscdeadline = data;
-	start_apic_timer(apic);
+	hrtimer_cancel(&lapic->lapic_timer.timer);
+	lapic->lapic_timer.tscdeadline = data;
+	start_apic_timer(lapic);
 }
 
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
 	if (!kvm_vcpu_has_lapic(vcpu))
 		return;
 
-	apic_set_tpr(apic, ((cr8 & 0x0f) << 4)
-		     | (kvm_apic_get_reg(apic, APIC_TASKPRI) & 4));
+	apic_set_tpr(lapic, ((cr8 & 0x0f) << 4)
+		     | (kvm_apic_get_reg(lapic, APIC_TASKPRI) & 4));
 }
 
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
@@ -1361,15 +1367,15 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 {
 	u64 old_value = vcpu->arch.apic_base;
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
-	if (!apic) {
+	if (!lapic) {
 		value |= MSR_IA32_APICBASE_BSP;
 		vcpu->arch.apic_base = value;
 		return;
 	}
 
-	if (!kvm_vcpu_is_bsp(apic->vcpu))
+	if (!kvm_vcpu_is_bsp(lapic->vcpu))
 		value &= ~MSR_IA32_APICBASE_BSP;
 	vcpu->arch.apic_base = value;
 
@@ -1384,77 +1390,78 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 
 	if ((old_value ^ value) & X2APIC_ENABLE) {
 		if (value & X2APIC_ENABLE) {
-			u32 id = kvm_apic_id(apic);
+			u32 id = kvm_apic_id(lapic);
 			u32 ldr = ((id >> 4) << 16) | (1 << (id & 0xf));
-			kvm_apic_set_ldr(apic, ldr);
+			kvm_apic_set_ldr(lapic, ldr);
 			kvm_x86_ops->set_virtual_x2apic_mode(vcpu, true);
 		} else
 			kvm_x86_ops->set_virtual_x2apic_mode(vcpu, false);
 	}
 
-	apic->base_address = apic->vcpu->arch.apic_base &
-			     MSR_IA32_APICBASE_BASE;
+	lapic->base_address = lapic->vcpu->arch.apic_base &
+			      MSR_IA32_APICBASE_BASE;
 
 	/* with FSB delivery interrupt, we can restart APIC functionality */
-	apic_debug("apic base msr is 0x%016" PRIx64 ", and base address is "
-		   "0x%lx.\n", apic->vcpu->arch.apic_base, apic->base_address);
+	apic_debug("apic base msr is 0x%016" PRIx64
+		   ", and base address is 0x%lx.\n",
+		   lapic->vcpu->arch.apic_base, lapic->base_address);
 
 }
 
 void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic;
+	struct kvm_lapic *lapic;
 	int i;
 
 	apic_debug("%s\n", __func__);
 
 	ASSERT(vcpu);
-	apic = vcpu->arch.apic;
-	ASSERT(apic != NULL);
+	lapic = vcpu->arch.apic;
+	ASSERT(lapic != NULL);
 
 	/* Stop the timer in case it's a reset to an active apic */
-	hrtimer_cancel(&apic->lapic_timer.timer);
+	hrtimer_cancel(&lapic->lapic_timer.timer);
 
-	kvm_apic_set_id(apic, vcpu->vcpu_id);
-	kvm_apic_set_version(apic->vcpu);
+	kvm_apic_set_id(lapic, vcpu->vcpu_id);
+	kvm_apic_set_version(lapic->vcpu);
 
 	for (i = 0; i < APIC_LVT_NUM; i++)
-		apic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
-	apic_set_reg(apic, APIC_LVT0,
+		apic_set_reg(lapic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
+	apic_set_reg(lapic, APIC_LVT0,
 		     SET_APIC_DELIVERY_MODE(0, APIC_MODE_EXTINT));
 
-	apic_set_reg(apic, APIC_DFR, 0xffffffffU);
-	apic_set_spiv(apic, 0xff);
-	apic_set_reg(apic, APIC_TASKPRI, 0);
-	kvm_apic_set_ldr(apic, 0);
-	apic_set_reg(apic, APIC_ESR, 0);
-	apic_set_reg(apic, APIC_ICR, 0);
-	apic_set_reg(apic, APIC_ICR2, 0);
-	apic_set_reg(apic, APIC_TDCR, 0);
-	apic_set_reg(apic, APIC_TMICT, 0);
+	apic_set_reg(lapic, APIC_DFR, 0xffffffffU);
+	apic_set_spiv(lapic, 0xff);
+	apic_set_reg(lapic, APIC_TASKPRI, 0);
+	kvm_apic_set_ldr(lapic, 0);
+	apic_set_reg(lapic, APIC_ESR, 0);
+	apic_set_reg(lapic, APIC_ICR, 0);
+	apic_set_reg(lapic, APIC_ICR2, 0);
+	apic_set_reg(lapic, APIC_TDCR, 0);
+	apic_set_reg(lapic, APIC_TMICT, 0);
 	for (i = 0; i < 8; i++) {
-		apic_set_reg(apic, APIC_IRR + 0x10 * i, 0);
-		apic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
-		apic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
+		apic_set_reg(lapic, APIC_IRR + 0x10 * i, 0);
+		apic_set_reg(lapic, APIC_ISR + 0x10 * i, 0);
+		apic_set_reg(lapic, APIC_TMR + 0x10 * i, 0);
 	}
-	apic->irr_pending = kvm_apic_vid_enabled(vcpu->kvm);
-	apic->isr_count = kvm_apic_vid_enabled(vcpu->kvm);
-	apic->highest_isr_cache = -1;
-	update_divide_count(apic);
-	atomic_set(&apic->lapic_timer.pending, 0);
+	lapic->irr_pending = kvm_apic_vid_enabled(vcpu->kvm);
+	lapic->isr_count = kvm_apic_vid_enabled(vcpu->kvm);
+	lapic->highest_isr_cache = -1;
+	update_divide_count(lapic);
+	atomic_set(&lapic->lapic_timer.pending, 0);
 	if (kvm_vcpu_is_bsp(vcpu))
 		kvm_lapic_set_base(vcpu,
 				vcpu->arch.apic_base | MSR_IA32_APICBASE_BSP);
 	vcpu->arch.pv_eoi.msr_val = 0;
-	apic_update_ppr(apic);
+	apic_update_ppr(lapic);
 
 	vcpu->arch.apic_arb_prio = 0;
 	vcpu->arch.apic_attention = 0;
 
 	apic_debug(KERN_INFO "%s: vcpu=%p, id=%d, base_msr="
 		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __func__,
-		   vcpu, kvm_apic_id(apic),
-		   vcpu->arch.apic_base, apic->base_address);
+		   vcpu, kvm_apic_id(lapic),
+		   vcpu->arch.apic_base, lapic->base_address);
 }
 
 /*
@@ -1463,43 +1470,43 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
  *----------------------------------------------------------------------
  */
 
-static bool lapic_is_periodic(struct kvm_lapic *apic)
+static bool lapic_is_periodic(struct kvm_lapic *lapic)
 {
-	return apic_lvtt_period(apic);
+	return apic_lvtt_period(lapic);
 }
 
 int apic_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
-	if (kvm_vcpu_has_lapic(vcpu) && apic_enabled(apic) &&
-			apic_lvt_enabled(apic, APIC_LVTT))
-		return atomic_read(&apic->lapic_timer.pending);
+	if (kvm_vcpu_has_lapic(vcpu) && apic_enabled(lapic) &&
+			apic_lvt_enabled(lapic, APIC_LVTT))
+		return atomic_read(&lapic->lapic_timer.pending);
 
 	return 0;
 }
 
-int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
+int kvm_apic_local_deliver(struct kvm_lapic *lapic, int lvt_type)
 {
-	u32 reg = kvm_apic_get_reg(apic, lvt_type);
+	u32 reg = kvm_apic_get_reg(lapic, lvt_type);
 	int vector, mode, trig_mode;
 
-	if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
+	if (kvm_apic_hw_enabled(lapic) && !(reg & APIC_LVT_MASKED)) {
 		vector = reg & APIC_VECTOR_MASK;
 		mode = reg & APIC_MODE_MASK;
 		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
-		return __apic_accept_irq(apic, mode, vector, 1, trig_mode,
-					NULL);
+		return __apic_accept_irq(lapic, mode, vector, 1, trig_mode,
+					 NULL);
 	}
 	return 0;
 }
 
 void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
-	if (apic)
-		kvm_apic_local_deliver(apic, APIC_LVT0);
+	if (lapic)
+		kvm_apic_local_deliver(lapic, APIC_LVT0);
 }
 
 static const struct kvm_io_device_ops apic_mmio_ops = {
@@ -1510,8 +1517,9 @@ static const struct kvm_io_device_ops apic_mmio_ops = {
 static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 {
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
-	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
-	struct kvm_vcpu *vcpu = apic->vcpu;
+	struct kvm_lapic *lapic = container_of(ktimer, struct kvm_lapic,
+					       lapic_timer);
+	struct kvm_vcpu *vcpu = lapic->vcpu;
 	wait_queue_head_t *q = &vcpu->wq;
 
 	/*
@@ -1529,7 +1537,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 	if (waitqueue_active(q))
 		wake_up_interruptible(q);
 
-	if (lapic_is_periodic(apic)) {
+	if (lapic_is_periodic(lapic)) {
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
 		return HRTIMER_RESTART;
 	} else
@@ -1538,28 +1546,28 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 
 int kvm_create_lapic(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic;
+	struct kvm_lapic *lapic;
 
 	ASSERT(vcpu != NULL);
 	apic_debug("apic_init %d\n", vcpu->vcpu_id);
 
-	apic = kzalloc(sizeof(*apic), GFP_KERNEL);
-	if (!apic)
+	lapic = kzalloc(sizeof(*lapic), GFP_KERNEL);
+	if (!lapic)
 		goto nomem;
 
-	vcpu->arch.apic = apic;
+	vcpu->arch.apic = lapic;
 
-	apic->regs = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!apic->regs) {
+	lapic->regs = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!lapic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
 		goto nomem_free_apic;
 	}
-	apic->vcpu = vcpu;
+	lapic->vcpu = vcpu;
 
-	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
+	hrtimer_init(&lapic->lapic_timer.timer, CLOCK_MONOTONIC,
 		     HRTIMER_MODE_ABS);
-	apic->lapic_timer.timer.function = apic_timer_fn;
+	lapic->lapic_timer.timer.function = apic_timer_fn;
 
 	/*
 	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
@@ -1571,27 +1579,27 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 
 	static_key_slow_inc(&apic_sw_disabled.key); /* sw disabled at reset */
 	kvm_lapic_reset(vcpu);
-	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
+	kvm_iodevice_init(&lapic->dev, &apic_mmio_ops);
 
 	return 0;
 nomem_free_apic:
-	kfree(apic);
+	kfree(lapic);
 nomem:
 	return -ENOMEM;
 }
 
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 	int highest_irr;
 
-	if (!kvm_vcpu_has_lapic(vcpu) || !apic_enabled(apic))
+	if (!kvm_vcpu_has_lapic(vcpu) || !apic_enabled(lapic))
 		return -1;
 
-	apic_update_ppr(apic);
-	highest_irr = apic_find_highest_irr(apic);
+	apic_update_ppr(lapic);
+	highest_irr = apic_find_highest_irr(lapic);
 	if ((highest_irr == -1) ||
-	    ((highest_irr & 0xF0) <= kvm_apic_get_reg(apic, APIC_PROCPRI)))
+	    ((highest_irr & 0xF0) <= kvm_apic_get_reg(lapic, APIC_PROCPRI)))
 		return -1;
 	return highest_irr;
 }
@@ -1611,55 +1619,55 @@ int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
 
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
 	if (!kvm_vcpu_has_lapic(vcpu))
 		return;
 
-	if (atomic_read(&apic->lapic_timer.pending) > 0) {
-		kvm_apic_local_deliver(apic, APIC_LVTT);
-		atomic_set(&apic->lapic_timer.pending, 0);
+	if (atomic_read(&lapic->lapic_timer.pending) > 0) {
+		kvm_apic_local_deliver(lapic, APIC_LVTT);
+		atomic_set(&lapic->lapic_timer.pending, 0);
 	}
 }
 
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 {
 	int vector = kvm_apic_has_interrupt(vcpu);
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
 	/* Note that we never get here with APIC virtualization enabled.  */
 
 	if (vector == -1)
 		return -1;
 
-	apic_set_isr(vector, apic);
-	apic_update_ppr(apic);
-	apic_clear_irr(vector, apic);
+	apic_set_isr(vector, lapic);
+	apic_update_ppr(lapic);
+	apic_clear_irr(vector, lapic);
 	return vector;
 }
 
 void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu,
 		struct kvm_lapic_state *s)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
 	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
 	/* set SPIV separately to get count of SW disabled APICs right */
-	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
+	apic_set_spiv(lapic, *((u32 *)(s->regs + APIC_SPIV)));
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof *s);
 	/* call kvm_apic_set_id() to put apic into apic_map */
-	kvm_apic_set_id(apic, kvm_apic_id(apic));
+	kvm_apic_set_id(lapic, kvm_apic_id(lapic));
 	kvm_apic_set_version(vcpu);
 
-	apic_update_ppr(apic);
-	hrtimer_cancel(&apic->lapic_timer.timer);
-	update_divide_count(apic);
-	start_apic_timer(apic);
-	apic->irr_pending = true;
-	apic->isr_count = kvm_apic_vid_enabled(vcpu->kvm) ?
-				1 : count_vectors(apic->regs + APIC_ISR);
-	apic->highest_isr_cache = -1;
-	kvm_x86_ops->hwapic_isr_update(vcpu->kvm, apic_find_highest_isr(apic));
+	apic_update_ppr(lapic);
+	hrtimer_cancel(&lapic->lapic_timer.timer);
+	update_divide_count(lapic);
+	start_apic_timer(lapic);
+	lapic->irr_pending = true;
+	lapic->isr_count = kvm_apic_vid_enabled(vcpu->kvm) ?
+				1 : count_vectors(lapic->regs + APIC_ISR);
+	lapic->highest_isr_cache = -1;
+	kvm_x86_ops->hwapic_isr_update(vcpu->kvm, apic_find_highest_isr(lapic));
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	kvm_rtc_eoi_tracking_restore_one(vcpu);
 }
@@ -1684,7 +1692,7 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
  * Clear PV EOI in guest memory in any case.
  */
 static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
-					struct kvm_lapic *apic)
+					struct kvm_lapic *lapic)
 {
 	bool pending;
 	int vector;
@@ -1709,8 +1717,8 @@ static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
 	pv_eoi_clr_pending(vcpu);
 	if (pending)
 		return;
-	vector = apic_set_eoi(apic);
-	trace_kvm_pv_eoi(apic, vector);
+	vector = apic_set_eoi(lapic);
+	trace_kvm_pv_eoi(lapic, vector);
 }
 
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
@@ -1736,15 +1744,15 @@ void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
  * if yes do so.
  */
 static void apic_sync_pv_eoi_to_guest(struct kvm_vcpu *vcpu,
-					struct kvm_lapic *apic)
+				      struct kvm_lapic *lapic)
 {
 	if (!pv_eoi_enabled(vcpu) ||
 	    /* IRR set or many bits in ISR: could be nested. */
-	    apic->irr_pending ||
+	    lapic->irr_pending ||
 	    /* Cache not set: could be safe but we don't bother. */
-	    apic->highest_isr_cache == -1 ||
+	    lapic->highest_isr_cache == -1 ||
 	    /* Need EOI to update ioapic. */
-	    kvm_ioapic_handles_vector(vcpu->kvm, apic->highest_isr_cache)) {
+	    kvm_ioapic_handles_vector(vcpu->kvm, lapic->highest_isr_cache)) {
 		/*
 		 * PV EOI was disabled by apic_sync_pv_eoi_from_guest
 		 * so we need not do anything here.
@@ -1752,25 +1760,25 @@ static void apic_sync_pv_eoi_to_guest(struct kvm_vcpu *vcpu,
 		return;
 	}
 
-	pv_eoi_set_pending(apic->vcpu);
+	pv_eoi_set_pending(lapic->vcpu);
 }
 
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 {
 	u32 data, tpr;
 	int max_irr, max_isr;
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
-	apic_sync_pv_eoi_to_guest(vcpu, apic);
+	apic_sync_pv_eoi_to_guest(vcpu, lapic);
 
 	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
 		return;
 
-	tpr = kvm_apic_get_reg(apic, APIC_TASKPRI) & 0xff;
-	max_irr = apic_find_highest_irr(apic);
+	tpr = kvm_apic_get_reg(lapic, APIC_TASKPRI) & 0xff;
+	max_irr = apic_find_highest_irr(lapic);
 	if (max_irr < 0)
 		max_irr = 0;
-	max_isr = apic_find_highest_isr(apic);
+	max_isr = apic_find_highest_isr(lapic);
 	if (max_isr < 0)
 		max_isr = 0;
 	data = (tpr & 0xff) | ((max_isr & 0xf0) << 8) | (max_irr << 24);
@@ -1797,30 +1805,30 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 
 int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 	u32 reg = (msr - APIC_BASE_MSR) << 4;
 
-	if (!irqchip_in_kernel(vcpu->kvm) || !apic_x2apic_mode(apic))
+	if (!irqchip_in_kernel(vcpu->kvm) || !apic_x2apic_mode(lapic))
 		return 1;
 
 	/* if this is ICR write vector before command */
 	if (msr == 0x830)
-		apic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
-	return apic_reg_write(apic, reg, (u32)data);
+		apic_reg_write(lapic, APIC_ICR2, (u32)(data >> 32));
+	return apic_reg_write(lapic, reg, (u32)data);
 }
 
 int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 	u32 reg = (msr - APIC_BASE_MSR) << 4, low, high = 0;
 
-	if (!irqchip_in_kernel(vcpu->kvm) || !apic_x2apic_mode(apic))
+	if (!irqchip_in_kernel(vcpu->kvm) || !apic_x2apic_mode(lapic))
 		return 1;
 
-	if (apic_reg_read(apic, reg, 4, &low))
+	if (apic_reg_read(lapic, reg, 4, &low))
 		return 1;
 	if (msr == 0x830)
-		apic_reg_read(apic, APIC_ICR2, 4, &high);
+		apic_reg_read(lapic, APIC_ICR2, 4, &high);
 
 	*data = (((u64)high) << 32) | low;
 
@@ -1829,29 +1837,29 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 
 int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 
 	if (!kvm_vcpu_has_lapic(vcpu))
 		return 1;
 
 	/* if this is ICR write vector before command */
 	if (reg == APIC_ICR)
-		apic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
-	return apic_reg_write(apic, reg, (u32)data);
+		apic_reg_write(lapic, APIC_ICR2, (u32)(data >> 32));
+	return apic_reg_write(lapic, reg, (u32)data);
 }
 
 int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 	u32 low, high = 0;
 
 	if (!kvm_vcpu_has_lapic(vcpu))
 		return 1;
 
-	if (apic_reg_read(apic, reg, 4, &low))
+	if (apic_reg_read(lapic, reg, 4, &low))
 		return 1;
 	if (reg == APIC_ICR)
-		apic_reg_read(apic, APIC_ICR2, 4, &high);
+		apic_reg_read(lapic, APIC_ICR2, 4, &high);
 
 	*data = (((u64)high) << 32) | low;
 
@@ -1873,19 +1881,19 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data)
 
 void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_lapic *lapic = vcpu->arch.apic;
 	unsigned int sipi_vector;
 	unsigned long pe;
 
-	if (!kvm_vcpu_has_lapic(vcpu) || !apic->pending_events)
+	if (!kvm_vcpu_has_lapic(vcpu) || !lapic->pending_events)
 		return;
 
-	pe = xchg(&apic->pending_events, 0);
+	pe = xchg(&lapic->pending_events, 0);
 
 	if (test_bit(KVM_APIC_INIT, &pe)) {
 		kvm_lapic_reset(vcpu);
 		kvm_vcpu_reset(vcpu);
-		if (kvm_vcpu_is_bsp(apic->vcpu))
+		if (kvm_vcpu_is_bsp(lapic->vcpu))
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		else
 			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
@@ -1894,7 +1902,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	    vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 		/* evaluate pending_events before reading the vector */
 		smp_rmb();
-		sipi_vector = apic->sipi_vector;
+		sipi_vector = lapic->sipi_vector;
 		pr_debug("vcpu %d received sipi with vector # %x\n",
 			 vcpu->vcpu_id, sipi_vector);
 		kvm_vcpu_deliver_sipi_vector(vcpu, sipi_vector);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 6a11845..b7595b1 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -55,11 +55,11 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 
 void kvm_apic_update_tmr(struct kvm_vcpu *vcpu, u32 *tmr);
 void kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir);
-int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
-int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
+int kvm_apic_match_physical_addr(struct kvm_lapic *lapic, u16 dest);
+int kvm_apic_match_logical_addr(struct kvm_lapic *lapic, u8 mda);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		unsigned long *dest_map);
-int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
+int kvm_apic_local_deliver(struct kvm_lapic *lapic, int lvt_type);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, unsigned long *dest_map);
@@ -94,9 +94,9 @@ static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
 int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data);
 void kvm_lapic_init(void);
 
-static inline u32 kvm_apic_get_reg(struct kvm_lapic *apic, int reg_off)
+static inline u32 kvm_apic_get_reg(struct kvm_lapic *lapic, int reg_off)
 {
-	        return *((u32 *) (apic->regs + reg_off));
+	return *((u32 *) (lapic->regs + reg_off));
 }
 
 extern struct static_key kvm_no_apic_vcpu;
@@ -110,19 +110,20 @@ static inline bool kvm_vcpu_has_lapic(struct kvm_vcpu *vcpu)
 
 extern struct static_key_deferred apic_hw_disabled;
 
-static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
+static inline int kvm_apic_hw_enabled(struct kvm_lapic *lapic)
 {
 	if (static_key_false(&apic_hw_disabled.key))
-		return apic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
+		return lapic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
 	return MSR_IA32_APICBASE_ENABLE;
 }
 
 extern struct static_key_deferred apic_sw_disabled;
 
-static inline int kvm_apic_sw_enabled(struct kvm_lapic *apic)
+static inline int kvm_apic_sw_enabled(struct kvm_lapic *lapic)
 {
 	if (static_key_false(&apic_sw_disabled.key))
-		return kvm_apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_APIC_ENABLED;
+		return kvm_apic_get_reg(lapic, APIC_SPIV) &
+					APIC_SPIV_APIC_ENABLED;
 	return APIC_SPIV_APIC_ENABLED;
 }
 
@@ -136,9 +137,9 @@ static inline int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
 	return kvm_apic_present(vcpu) && kvm_apic_sw_enabled(vcpu->arch.apic);
 }
 
-static inline int apic_x2apic_mode(struct kvm_lapic *apic)
+static inline int apic_x2apic_mode(struct kvm_lapic *lapic)
 {
-	return apic->vcpu->arch.apic_base & X2APIC_ENABLE;
+	return lapic->vcpu->arch.apic_base & X2APIC_ENABLE;
 }
 
 static inline bool kvm_apic_vid_enabled(struct kvm *kvm)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 33574c9..740039e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -442,8 +442,8 @@ TRACE_EVENT(kvm_apic_accept_irq,
 );
 
 TRACE_EVENT(kvm_eoi,
-	    TP_PROTO(struct kvm_lapic *apic, int vector),
-	    TP_ARGS(apic, vector),
+	    TP_PROTO(struct kvm_lapic *apicp, int vector),
+	    TP_ARGS(apicp, vector),
 
 	TP_STRUCT__entry(
 		__field(	__u32,		apicid		)
@@ -451,7 +451,7 @@ TRACE_EVENT(kvm_eoi,
 	),
 
 	TP_fast_assign(
-		__entry->apicid		= apic->vcpu->vcpu_id;
+		__entry->apicid		= apicp->vcpu->vcpu_id;
 		__entry->vector		= vector;
 	),
 
@@ -459,8 +459,8 @@ TRACE_EVENT(kvm_eoi,
 );
 
 TRACE_EVENT(kvm_pv_eoi,
-	    TP_PROTO(struct kvm_lapic *apic, int vector),
-	    TP_ARGS(apic, vector),
+	    TP_PROTO(struct kvm_lapic *apicp, int vector),
+	    TP_ARGS(apicp, vector),
 
 	TP_STRUCT__entry(
 		__field(	__u32,		apicid		)
@@ -468,7 +468,7 @@ TRACE_EVENT(kvm_pv_eoi,
 	),
 
 	TP_fast_assign(
-		__entry->apicid		= apic->vcpu->vcpu_id;
+		__entry->apicid		= apicp->vcpu->vcpu_id;
 		__entry->vector		= vector;
 	),
 
-- 
1.9.3

