Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaE0IMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:12:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:62983 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaE0ILo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:11:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="538018965"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
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
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch V3 30/37] x86, irq: clean up unused IOAPIC interface
Date: Tue, 27 May 2014 16:08:05 +0800
Message-Id: <1401178092-1228-31-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have converted all x86 platforms to use the common irqdomain map
interface. There's no caller of io_apic_set_pci_routing(),
setup_IO_APIC_irq_extra() and io_apic_setup_irq_pin_once() any more,
so kill them.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    9 ------
 arch/x86/kernel/apic/io_apic.c |   70 ----------------------------------------
 2 files changed, 79 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 6d7a856ae045..073358c12d90 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -147,9 +147,6 @@ extern int ioapic_dynirq_base;
 
 struct io_apic_irq_attr;
 struct irq_cfg;
-extern int io_apic_set_pci_routing(struct device *dev, int irq,
-		 struct io_apic_irq_attr *irq_attr);
-extern void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_insert_resources(void);
 
 extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
@@ -161,8 +158,6 @@ extern void native_compose_msi_msg(struct pci_dev *pdev,
 				   unsigned int irq, unsigned int dest,
 				   struct msi_msg *msg, u8 hpet_id);
 extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
-extern int io_apic_setup_irq_pin_once(unsigned int irq, int node,
-				      struct io_apic_irq_attr *attr);
 
 extern int save_ioapic_entries(void);
 extern void mask_ioapic_entries(void);
@@ -235,10 +230,6 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
 
-struct io_apic_irq_attr;
-static inline int io_apic_set_pci_routing(struct device *dev, int irq,
-		 struct io_apic_irq_attr *irq_attr) { return 0; }
-
 static inline int save_ioapic_entries(void)
 {
 	return -ENOMEM;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6bb3485693dc..25a2877a5788 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -111,7 +111,6 @@ static struct ioapic {
 	struct irq_domain *irqdomain;
 	ioapic_create_domain_fn irqdomain_cb;
 	void *irqdomain_arg;
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
 #define mpc_ioapic_ver(ioapic_idx)	ioapics[ioapic_idx].mp_config.apicver
@@ -1518,38 +1517,6 @@ static void __init setup_IO_APIC_irqs(void)
 }
 
 /*
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
-	idx = find_irq_entry(ioapic_idx, pin, mp_INT);
-	if (idx == -1)
-		return;
-
-	irq = pin_2_irq(idx, ioapic_idx, pin, IOAPIC_MAP_ALLOC);
-	if (irq < 0 || mp_init_irq_at_boot(ioapic_idx, irq))
-		return;
-
-	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
-			     irq_polarity(idx));
-
-	io_apic_setup_irq_pin_once(irq, node, &attr);
-}
-
-/*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
 static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
@@ -3436,27 +3403,6 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
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
@@ -3503,22 +3449,6 @@ int __init arch_probe_nr_irqs(void)
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
-- 
1.7.10.4

