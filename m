Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbaEPIIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:08:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:60368 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbaEPIIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:08:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1065,1389772800"; 
   d="scan'208";a="540108225"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC Patch Part1 V1 30/30] x86, irq: clean up unused IOAPIC interface
Date: Fri, 16 May 2014 16:05:50 +0800
Message-Id: <1400227550-5935-31-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have converted all x86 platforms to use the common irqdomain map
interface, and there are only two callers of io_apic_setup_irq_pin():
mp_irqdomain_map() and pre_init_apic_IRQ0().

There's no caller of io_apic_set_pci_routing(), setup_IO_APIC_irq_extra()
and io_apic_setup_irq_pin_once(), so kill them.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    9 ---
 arch/x86/kernel/apic/io_apic.c |  145 +++++-----------------------------------
 2 files changed, 16 insertions(+), 138 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 2f37df00d6f8..0fc54499f21a 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -142,9 +142,6 @@ extern int ioapic_dynirq_base;
 
 struct io_apic_irq_attr;
 struct irq_cfg;
-extern int io_apic_set_pci_routing(struct device *dev, int irq,
-		 struct io_apic_irq_attr *irq_attr);
-extern void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_insert_resources(void);
 
 extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
@@ -156,8 +153,6 @@ extern void native_compose_msi_msg(struct pci_dev *pdev,
 				   unsigned int irq, unsigned int dest,
 				   struct msi_msg *msg, u8 hpet_id);
 extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
-extern int io_apic_setup_irq_pin_once(unsigned int irq, int node,
-				      struct io_apic_irq_attr *attr);
 
 extern int save_ioapic_entries(void);
 extern void mask_ioapic_entries(void);
@@ -231,10 +226,6 @@ static inline int mp_map_pin_to_irq(int idx, int ioapic, int pin, int alloc)
 	return -1;
 }
 
-struct io_apic_irq_attr;
-static inline int io_apic_set_pci_routing(struct device *dev, int irq,
-		 struct io_apic_irq_attr *irq_attr) { return 0; }
-
 static inline int save_ioapic_entries(void)
 {
 	return -ENOMEM;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0489fb2393ec..3d168a720f56 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -111,7 +111,6 @@ static struct ioapic {
 	struct irq_domain *irqdomain;
 	ioapic_create_domain_fn irqdomain_cb;
 	void *irqdomain_arg;
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
 #define mpc_ioapic_ver(ioapic_idx)	ioapics[ioapic_idx].mp_config.apicver
@@ -209,9 +208,6 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
-static int io_apic_setup_irq_pin(unsigned int irq, int node,
-				 struct io_apic_irq_attr *attr);
-
 /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
 void mp_save_irq(struct mpc_intsrc *m)
 {
@@ -1082,9 +1078,6 @@ int mp_map_pin_to_irq(int idx, int ioapic, int pin, int alloc)
 
 static int pin_2_irq(int idx, int apic, int pin, int alloc)
 {
-	int irq;
-	int bus = mp_irqs[idx].srcbus;
-
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
 	 */
@@ -1096,6 +1089,8 @@ static int pin_2_irq(int idx, int apic, int pin, int alloc)
 	 * PCI IRQ command line redirection. Yes, limits are hardcoded.
 	 */
 	if ((pin >= 16) && (pin <= 23)) {
+		int irq;
+
 		if (pirq_entries[pin-16] != -1) {
 			if (!pirq_entries[pin-16]) {
 				apic_printk(APIC_VERBOSE, KERN_DEBUG
@@ -1111,12 +1106,7 @@ static int pin_2_irq(int idx, int apic, int pin, int alloc)
 	}
 #endif
 
-	if (test_bit(bus, mp_bus_not_pci))
-		irq = mp_irqs[idx].srcbusirq;
-	else
-		irq = mp_map_pin_to_irq(idx, apic, pin, alloc);
-
-	return irq;
+	return mp_map_pin_to_irq(idx, apic, pin, alloc);
 }
 
 /*
@@ -1482,90 +1472,24 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	ioapic_write_entry(attr->ioapic, attr->ioapic_pin, entry);
 }
 
-static bool __init io_apic_pin_not_connected(int idx, int ioapic_idx, int pin)
-{
-	if (idx != -1)
-		return false;
-
-	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
-		    mpc_ioapic_id(ioapic_idx), pin);
-	return true;
-}
-
-static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
-{
-	int idx, node = cpu_to_node(0);
-	struct io_apic_irq_attr attr;
-	unsigned int pin, irq;
-
-	for_each_pin(ioapic_idx, pin) {
-		if (!mp_init_pin_at_boot(ioapic_idx, pin))
-			continue;
-
-		idx = find_irq_entry(ioapic_idx, pin, mp_INT);
-		if (io_apic_pin_not_connected(idx, ioapic_idx, pin))
-			continue;
-
-		irq = pin_2_irq(idx, ioapic_idx, pin, 1);
-		if (irq < 0)
-			continue;
-
-		/*
-		 * Skip the timer IRQ if there's a quirk handler
-		 * installed and if it returns 1:
-		 */
-		if (apic->multi_timer_check &&
-		    apic->multi_timer_check(ioapic_idx, irq))
-			continue;
-
-		set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
-				     irq_polarity(idx));
-
-		io_apic_setup_irq_pin(irq, node, &attr);
-	}
-}
-
 static void __init setup_IO_APIC_irqs(void)
 {
-	unsigned int ioapic_idx;
+	int idx;
+	unsigned int ioapic, pin;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for_each_ioapic(ioapic_idx)
-		__io_apic_setup_irqs(ioapic_idx);
-}
-
-/*
- * for the gsi that is not in first ioapic
- * but could not use acpi_register_gsi()
- * like some special sci in IBM x3330
- */
-void setup_IO_APIC_irq_extra(u32 gsi)
-{
-	int ioapic_idx = 0, pin, idx, irq, node = cpu_to_node(0);
-	struct io_apic_irq_attr attr;
-
-	/*
-	 * Convert 'gsi' to 'ioapic.pin'.
-	 */
-	ioapic_idx = mp_find_ioapic(gsi);
-	if (ioapic_idx < 0)
-		return;
-
-	pin = mp_find_ioapic_pin(ioapic_idx, gsi);
-	if (mp_init_pin_at_boot(ioapic_idx, pin))
-		return;
-
-	idx = find_irq_entry(ioapic_idx, pin, mp_INT);
-	if (idx == -1)
-		return;
-
-	irq = pin_2_irq(idx, ioapic_idx, pin, 1);
-
-	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
-			     irq_polarity(idx));
+	for_each_ioapic_pin(ioapic, pin) {
+		if (!mp_init_pin_at_boot(ioapic, pin))
+			continue;
 
-	io_apic_setup_irq_pin_once(irq, node, &attr);
+		idx = find_irq_entry(ioapic, pin, mp_INT);
+		if (idx < 0)
+			apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
+				    mpc_ioapic_id(ioapic), pin);
+		else
+			pin_2_irq(idx, ioapic, pin, 1);
+	}
 }
 
 /*
@@ -3512,27 +3436,6 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 	return ret;
 }
 
-int io_apic_setup_irq_pin_once(unsigned int irq, int node,
-			       struct io_apic_irq_attr *attr)
-{
-	unsigned int ioapic_idx = attr->ioapic, pin = attr->ioapic_pin;
-	int ret;
-	struct IO_APIC_route_entry orig_entry;
-
-	/* Avoid redundant programming */
-	if (test_bit(pin, ioapics[ioapic_idx].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n", mpc_ioapic_id(ioapic_idx), pin);
-		orig_entry = ioapic_read_entry(attr->ioapic, pin);
-		if (attr->trigger == orig_entry.trigger && attr->polarity == orig_entry.polarity)
-			return 0;
-		return -EBUSY;
-	}
-	ret = io_apic_setup_irq_pin(irq, node, attr);
-	if (!ret)
-		set_bit(pin, ioapics[ioapic_idx].pin_programmed);
-	return ret;
-}
-
 static int __init io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
@@ -3579,22 +3482,6 @@ int __init arch_probe_nr_irqs(void)
 	return NR_IRQS_LEGACY;
 }
 
-int io_apic_set_pci_routing(struct device *dev, int irq,
-			    struct io_apic_irq_attr *irq_attr)
-{
-	int node;
-
-	if (!IO_APIC_IRQ(irq)) {
-		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
-			    irq_attr->ioapic);
-		return -EINVAL;
-	}
-
-	node = dev ? dev_to_node(dev) : cpu_to_node(0);
-
-	return io_apic_setup_irq_pin_once(irq, node, irq_attr);
-}
-
 #ifdef CONFIG_X86_32
 static int __init io_apic_get_unique_id(int ioapic, int apic_id)
 {
@@ -4015,7 +3902,7 @@ int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 	 * returns 1:
 	 */
 	if (apic->multi_timer_check &&
-	    apic->multi_timer_check(ioapic, hwirq))
+	    apic->multi_timer_check(ioapic, virq))
 		return 0;
 
 	/* Get default attribute if not set by caller yet */
-- 
1.7.10.4

