Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaE0IWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:22:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:23007 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaE0IWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:22:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="545380576"
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
Subject: [RFC Patch V1 1/4] x86, irq: refine mp_register_ioapic() to prepare for IOAPIC hotplug
Date: Tue, 27 May 2014 16:24:34 +0800
Message-Id: <1401179077-2020-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401179077-2020-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401179077-2020-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    4 +-
 arch/x86/kernel/apic/io_apic.c |  143 ++++++++++++++++++++++++++--------------
 2 files changed, 94 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 6b40122bec0c..64379c285435 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -181,8 +181,8 @@ extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
 extern void mp_unmap_irq(int irq);
-extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
-				      ioapic_create_domain_fn cb, void *arg);
+extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			      ioapic_create_domain_fn cb, void *arg);
 extern struct irq_domain *mp_irqdomain_create(int ioapic,
 		struct device_node *np, const struct irq_domain_ops *ops);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c7c84d5c0e57..f70fa239f34b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -85,6 +85,7 @@ int sis_apic_bug = -1;
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
 static DEFINE_MUTEX(ioapic_mutex);
+static int ioapic_initialized;
 
 struct mp_pin_info {
 	int trigger;
@@ -2920,19 +2921,40 @@ out:
  */
 #define PIC_IRQS	(1UL << PIC_CASCADE_IR)
 
-static void ioapic_create_irqdomains(void)
+static int ioapic_create_irqdomain(int idx)
 {
-	int i, size;
-	struct ioapic *ip;
+	int size;
+	struct ioapic *ip = &ioapics[idx];
 
-	for_each_ioapic(i) {
-		ip = &ioapics[i];
-		size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(i);
-		ip->pin_info = kzalloc(size, GFP_KERNEL);
-		BUG_ON(!ip->pin_info);
-		if (ip->irqdomain_cb)
-			ip->irqdomain = ip->irqdomain_cb(i, ip->irqdomain_arg);
+	size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(idx);
+	ip->pin_info = kzalloc(size, GFP_KERNEL);
+	if (ip->pin_info == NULL && ioapic_initialized) {
+		pr_warn("failed to allocate memory IOAPIC pin_info.\n");
+		return -ENOMEM;
 	}
+	BUG_ON(!ip->pin_info);
+
+	if (ip->irqdomain_cb) {
+		ip->irqdomain = ip->irqdomain_cb(idx, ip->irqdomain_arg);
+		if (ip->irqdomain == NULL && ioapic_initialized) {
+			pr_warn("failed to create irqdomain for IOAPIC%d\n",
+				idx);
+			kfree(ip->pin_info);
+			ip->pin_info = NULL;
+			return -ENOMEM;
+		}
+		BUG_ON(!ip->irqdomain);
+	}
+
+	return 0;
+}
+
+static void ioapic_create_irqdomains(void)
+{
+	int idx;
+
+	for_each_ioapic(idx)
+		ioapic_create_irqdomain(idx);
 }
 
 void __init setup_IO_APIC(void)
@@ -2955,6 +2977,8 @@ void __init setup_IO_APIC(void)
 	init_IO_APIC_traps();
 	if (legacy_pic->nr_legacy_irqs)
 		check_timer();
+
+	ioapic_initialized = 1;
 }
 
 /*
@@ -3408,7 +3432,7 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 	return ret;
 }
 
-static int __init io_apic_get_redir_entries(int ioapic)
+static int io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3455,7 +3479,7 @@ int __init arch_probe_nr_irqs(void)
 }
 
 #ifdef CONFIG_X86_32
-static int __init io_apic_get_unique_id(int ioapic, int apic_id)
+static int io_apic_get_unique_id(int ioapic, int apic_id)
 {
 	union IO_APIC_reg_00 reg_00;
 	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
@@ -3530,7 +3554,7 @@ static int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	return apic_id;
 }
 
-static u8 __init io_apic_unique_id(u8 id)
+static u8 io_apic_unique_id(u8 id)
 {
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
 	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
@@ -3539,7 +3563,7 @@ static u8 __init io_apic_unique_id(u8 id)
 		return id;
 }
 #else
-static u8 __init io_apic_unique_id(u8 id)
+static u8 io_apic_unique_id(u8 id)
 {
 	int i;
 	DECLARE_BITMAP(used, 256);
@@ -3553,7 +3577,7 @@ static u8 __init io_apic_unique_id(u8 id)
 }
 #endif
 
-static int __init io_apic_get_version(int ioapic)
+static int io_apic_get_version(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3757,21 +3781,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 	return gsi - gsi_cfg->gsi_base;
 }
 
-static __init int bad_ioapic(unsigned long address)
-{
-	if (nr_ioapics >= MAX_IO_APICS) {
-		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
-			MAX_IO_APICS, nr_ioapics);
-		return 1;
-	}
-	if (!address) {
-		pr_warn("WARNING: Bogus (zero) I/O APIC address found in table, skipping!\n");
-		return 1;
-	}
-	return 0;
-}
-
-static __init int bad_ioapic_register(int idx)
+static int bad_ioapic_register(int idx)
 {
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
@@ -3790,30 +3800,43 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
-			       ioapic_create_domain_fn cb, void *arg)
+static int find_free_ioapic_entry(void)
+{
+	return nr_ioapics;
+}
+
+int mp_register_ioapic(int id, u32 address, u32 gsi_base,
+		       ioapic_create_domain_fn cb, void *arg)
 {
-	int idx = 0;
-	int entries;
+	u32 gsi_end;
+	int idx, ioapic, entries;
 	struct mp_ioapic_gsi *gsi_cfg;
 
-	if (bad_ioapic(address))
-		return;
+	if (!address) {
+		pr_warn("WARNING: Bogus (zero) I/O APIC address found in table, skipping!\n");
+		return -EINVAL;
+	}
+	for_each_ioapic(ioapic)
+		if (ioapics[ioapic].mp_config.apicaddr == address) {
+			pr_warn("address 0x%x conflicts with IOAPIC%d\n",
+				address, ioapic);
+			return -EEXIST;
+		}
 
-	idx = nr_ioapics;
+	idx = find_free_ioapic_entry();
+	if (idx >= MAX_IO_APICS) {
+		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
+			MAX_IO_APICS, idx);
+		return -ENOSPC;
+	}
 
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
 	ioapics[idx].mp_config.apicaddr = address;
-	ioapics[idx].irqdomain_cb = cb;
-	ioapics[idx].irqdomain_arg = arg;
-	ioapics[idx].irqdomain = NULL;
-
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-
 	if (bad_ioapic_register(idx)) {
 		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		return;
+		return -ENODEV;
 	}
 
 	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
@@ -3824,24 +3847,43 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
 	entries = io_apic_get_redir_entries(idx);
+	gsi_end = gsi_base + entries - 1;
+	for_each_ioapic(ioapic) {
+		gsi_cfg = mp_ioapic_gsi_routing(idx);
+		if ((gsi_base >= gsi_cfg->gsi_base &&
+		     gsi_base <= gsi_cfg->gsi_end) ||
+		    (gsi_end >= gsi_cfg->gsi_base &&
+		     gsi_end <= gsi_cfg->gsi_end)) {
+			pr_warn("GSI range [%u-%u] for new IOAPIC conflicts with GSI[%u-%u]\n",
+				gsi_base, gsi_end,
+				gsi_cfg->gsi_base, gsi_cfg->gsi_end);
+			clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+			return -EEXIST;
+		}
+	}
 	gsi_cfg = mp_ioapic_gsi_routing(idx);
 	gsi_cfg->gsi_base = gsi_base;
-	gsi_cfg->gsi_end = gsi_base + entries - 1;
+	gsi_cfg->gsi_end = gsi_end;
 
-	/*
-	 * The number of IO-APIC IRQ registers (== #pins):
-	 */
-	ioapics[idx].nr_registers = entries;
+	ioapics[idx].irqdomain_cb = cb;
+	ioapics[idx].irqdomain_arg = arg;
+	ioapics[idx].irqdomain = NULL;
 
 	if (gsi_cfg->gsi_end >= gsi_top)
 		gsi_top = gsi_cfg->gsi_end + 1;
 
+	if (nr_ioapics <= idx)
+		nr_ioapics = idx + 1;
+
+	/* Set nr_registers to mark entry present */
+	ioapics[idx].nr_registers = entries;
+
 	pr_info("IOAPIC[%d]: apic_id %d, version %d, address 0x%x, GSI %d-%d\n",
 		idx, mpc_ioapic_id(idx),
 		mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
 		gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
-	nr_ioapics++;
+	return 0;
 }
 
 struct irq_domain *mp_irqdomain_create(int ioapic, struct device_node *np,
@@ -3852,8 +3894,7 @@ struct irq_domain *mp_irqdomain_create(int ioapic, struct device_node *np,
 	int hwirqs = mp_ioapic_pin_count(ioapic);
 
 	domain = irq_domain_add_linear(np, hwirqs, ops, (void *)(long)ioapic);
-	BUG_ON(!domain);
-	if (gsi_cfg->gsi_base == 0)
+	if (domain && gsi_cfg->gsi_base == 0)
 		irq_set_default_host(domain);
 
 	return domain;
-- 
1.7.10.4

