Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaFIIWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:22:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:58894 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbaFIIWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:22:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352321403"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, Michal Simek <monstr@monstr.eu>,
        Tony Lindgren <tony@atomide.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch V4 28/42] x86, devicetree, irq: use common mechanism to support irqdomain
Date: Mon,  9 Jun 2014 16:19:57 +0800
Message-Id: <1402302011-23642-29-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the ioapic driver provides a common interface to create irqdomain,
so replace the private implementation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/prom.h  |    2 -
 arch/x86/kernel/devicetree.c |  195 +++++++++++++-----------------------------
 arch/x86/kernel/irqinit.c    |    6 --
 3 files changed, 61 insertions(+), 142 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index fbeb06ed0eaa..1d081ac1cd69 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -26,12 +26,10 @@
 extern int of_ioapic;
 extern u64 initial_dtb;
 extern void add_dtb(u64 data);
-extern void x86_add_irq_domains(void);
 void x86_of_pci_init(void);
 void x86_dtb_init(void);
 #else
 static inline void add_dtb(u64 data) { }
-static inline void x86_add_irq_domains(void) { }
 static inline void x86_of_pci_init(void) { }
 static inline void x86_dtb_init(void) { }
 #define of_ioapic 0
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index dd6936818330..ee4737f4a1af 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -166,84 +166,6 @@ static void __init dtb_lapic_setup(void)
 #ifdef CONFIG_X86_IO_APIC
 static unsigned int ioapic_id;
 
-static void __init dtb_add_ioapic(struct device_node *dn)
-{
-	struct resource r;
-	int ret;
-
-	ret = of_address_to_resource(dn, 0, &r);
-	if (ret) {
-		printk(KERN_ERR "Can't obtain address from node %s.\n",
-				dn->full_name);
-		return;
-	}
-	mp_register_ioapic(++ioapic_id, r.start, gsi_top, NULL);
-}
-
-static void __init dtb_ioapic_setup(void)
-{
-	struct device_node *dn;
-
-	for_each_compatible_node(dn, NULL, "intel,ce4100-ioapic")
-		dtb_add_ioapic(dn);
-
-	if (nr_ioapics) {
-		of_ioapic = 1;
-		return;
-	}
-	printk(KERN_ERR "Error: No information about IO-APIC in OF.\n");
-}
-#else
-static void __init dtb_ioapic_setup(void) {}
-#endif
-
-static void __init dtb_apic_setup(void)
-{
-	dtb_lapic_setup();
-	dtb_ioapic_setup();
-}
-
-#ifdef CONFIG_OF_FLATTREE
-static void __init x86_flattree_get_config(void)
-{
-	u32 size, map_len;
-	struct boot_param_header *dt;
-
-	if (!initial_dtb)
-		return;
-
-	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK),
-			(u64)sizeof(struct boot_param_header));
-
-	dt = early_memremap(initial_dtb, map_len);
-	size = be32_to_cpu(dt->totalsize);
-	if (map_len < size) {
-		early_iounmap(dt, map_len);
-		dt = early_memremap(initial_dtb, size);
-		map_len = size;
-	}
-
-	initial_boot_params = dt;
-	unflatten_and_copy_device_tree();
-	early_iounmap(dt, map_len);
-}
-#else
-static inline void x86_flattree_get_config(void) { }
-#endif
-
-void __init x86_dtb_init(void)
-{
-	x86_flattree_get_config();
-
-	if (!of_have_populated_dt())
-		return;
-
-	dtb_setup_hpet();
-	dtb_apic_setup();
-}
-
-#ifdef CONFIG_X86_IO_APIC
-
 struct of_ioapic_type {
 	u32 out_type;
 	u32 trigger;
@@ -294,7 +216,7 @@ static int ioapic_xlate(struct irq_domain *domain,
 
 	it = &of_ioapic_type[intspec[1]];
 
-	idx = (u32) domain->host_data;
+	idx = (u32)(long)domain->host_data;
 	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
 
 	rc = io_apic_setup_irq_pin_once(irq_find_mapping(domain, line),
@@ -311,78 +233,83 @@ const struct irq_domain_ops ioapic_irq_domain_ops = {
 	.xlate = ioapic_xlate,
 };
 
-static void dt_add_ioapic_domain(unsigned int ioapic_num,
-		struct device_node *np)
+static void __init dtb_add_ioapic(struct device_node *dn)
 {
-	struct irq_domain *id;
-	struct mp_ioapic_gsi *gsi_cfg;
+	struct resource r;
 	int ret;
-	int num, legacy_irqs = nr_legacy_irqs();
-
-	gsi_cfg = mp_ioapic_gsi_routing(ioapic_num);
-	num = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
-
-	id = irq_domain_add_linear(np, num, &ioapic_irq_domain_ops,
-			(void *)ioapic_num);
-	BUG_ON(!id);
-	if (gsi_cfg->gsi_base == 0) {
-		/*
-		 * The first nr_legacy_irqs() irq descs are allocated in
-		 * early_irq_init() and need just a mapping. The
-		 * remaining irqs need both. All of them are preallocated
-		 * and assigned so we can keep the 1:1 mapping which the ioapic
-		 * is having.
-		 */
-		irq_domain_associate_many(id, 0, 0, legacy_irqs);
-
-		if (num > legacy_irqs) {
-			ret = irq_create_strict_mappings(id, legacy_irqs,
-					legacy_irqs, num - legacy_irqs);
-			if (ret)
-				pr_err("Error creating mapping for the "
-						"remaining IRQs: %d\n", ret);
-		}
-		irq_set_default_host(id);
-	} else {
-		ret = irq_create_strict_mappings(id, gsi_cfg->gsi_base, 0, num);
-		if (ret)
-			pr_err("Error creating IRQ mapping: %d\n", ret);
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_DYNAMIC,
+		.ops = &ioapic_irq_domain_ops,
+		.dev = dn,
+	};
+
+	ret = of_address_to_resource(dn, 0, &r);
+	if (ret) {
+		printk(KERN_ERR "Can't obtain address from node %s.\n",
+				dn->full_name);
+		return;
 	}
+	mp_register_ioapic(++ioapic_id, r.start, gsi_top, &cfg);
 }
 
-static void __init ioapic_add_ofnode(struct device_node *np)
+static void __init dtb_ioapic_setup(void)
 {
-	struct resource r;
-	int i, ret;
+	struct device_node *dn;
 
-	ret = of_address_to_resource(np, 0, &r);
-	if (ret) {
-		printk(KERN_ERR "Failed to obtain address for %s\n",
-				np->full_name);
+	for_each_compatible_node(dn, NULL, "intel,ce4100-ioapic")
+		dtb_add_ioapic(dn);
+
+	if (nr_ioapics) {
+		of_ioapic = 1;
 		return;
 	}
+	printk(KERN_ERR "Error: No information about IO-APIC in OF.\n");
+}
+#else
+static void __init dtb_ioapic_setup(void) {}
+#endif
 
-	for (i = 0; i < nr_ioapics; i++) {
-		if (r.start == mpc_ioapic_addr(i)) {
-			dt_add_ioapic_domain(i, np);
-			return;
-		}
-	}
-	printk(KERN_ERR "IOxAPIC at %s is not registered.\n", np->full_name);
+static void __init dtb_apic_setup(void)
+{
+	dtb_lapic_setup();
+	dtb_ioapic_setup();
 }
 
-void __init x86_add_irq_domains(void)
+#ifdef CONFIG_OF_FLATTREE
+static void __init x86_flattree_get_config(void)
 {
-	struct device_node *dp;
+	u32 size, map_len;
+	struct boot_param_header *dt;
 
-	if (!of_have_populated_dt())
+	if (!initial_dtb)
 		return;
 
-	for_each_node_with_property(dp, "interrupt-controller") {
-		if (of_device_is_compatible(dp, "intel,ce4100-ioapic"))
-			ioapic_add_ofnode(dp);
+	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK),
+			(u64)sizeof(struct boot_param_header));
+
+	dt = early_memremap(initial_dtb, map_len);
+	size = be32_to_cpu(dt->totalsize);
+	if (map_len < size) {
+		early_iounmap(dt, map_len);
+		dt = early_memremap(initial_dtb, size);
+		map_len = size;
 	}
+
+	initial_boot_params = dt;
+	unflatten_and_copy_device_tree();
+	early_iounmap(dt, map_len);
 }
 #else
-void __init x86_add_irq_domains(void) { }
+static inline void x86_flattree_get_config(void) { }
 #endif
+
+void __init x86_dtb_init(void)
+{
+	x86_flattree_get_config();
+
+	if (!of_have_populated_dt())
+		return;
+
+	dtb_setup_hpet();
+	dtb_apic_setup();
+}
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index a0111e91eb4b..1e6cff5814fa 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -87,12 +87,6 @@ void __init init_IRQ(void)
 	int i;
 
 	/*
-	 * We probably need a better place for this, but it works for
-	 * now ...
-	 */
-	x86_add_irq_domains();
-
-	/*
 	 * On cpu 0, Assign IRQ0_VECTOR..IRQ15_VECTOR's to IRQ 0..15.
 	 * If these IRQ's are handled by legacy interrupt-controllers like PIC,
 	 * then this configuration will likely be static after the boot. If
-- 
1.7.10.4

