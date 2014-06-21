Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbaFUVQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:16:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35975 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbaFUVQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:16:27 -0400
Date: Sat, 21 Jun 2014 14:15:23 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-facd8fdb25fc4d041a283446cfb040cbfe2c3723@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, monstr@monstr.eu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, tony@atomide.com, rob.herring@calxeda.com,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, monstr@monstr.eu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, tony@atomide.com, rob.herring@calxeda.com,
        bhelgaas@google.com, benh@kernel.crashing.org, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-29-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-29-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, devicetree, irq:
  Use common mechanism to support irqdomain
Git-Commit-ID: facd8fdb25fc4d041a283446cfb040cbfe2c3723
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

Commit-ID:  facd8fdb25fc4d041a283446cfb040cbfe2c3723
Gitweb:     http://git.kernel.org/tip/facd8fdb25fc4d041a283446cfb040cbfe2c3723
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:57 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:43 +0200

x86, devicetree, irq: Use common mechanism to support irqdomain

Now the ioapic driver provides a common interface to create irqdomain,
so replace the private implementation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Tony Lindgren <tony@atomide.com>
Link: http://lkml.kernel.org/r/1402302011-23642-29-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/prom.h  |   2 -
 arch/x86/kernel/devicetree.c | 191 +++++++++++++------------------------------
 arch/x86/kernel/irqinit.c    |   6 --
 3 files changed, 59 insertions(+), 140 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index fbeb06e..1d081ac 100644
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
index d2c53fe..ee26fec 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -166,82 +166,6 @@ static void __init dtb_lapic_setup(void)
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
-	void *dt;
-
-	if (!initial_dtb)
-		return;
-
-	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK), (u64)128);
-
-	initial_boot_params = dt = early_memremap(initial_dtb, map_len);
-	size = of_get_flat_dt_size();
-	if (map_len < size) {
-		early_iounmap(dt, map_len);
-		initial_boot_params = dt = early_memremap(initial_dtb, size);
-		map_len = size;
-	}
-
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
@@ -292,7 +216,7 @@ static int ioapic_xlate(struct irq_domain *domain,
 
 	it = &of_ioapic_type[intspec[1]];
 
-	idx = (u32) domain->host_data;
+	idx = (u32)(long)domain->host_data;
 	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
 
 	rc = io_apic_setup_irq_pin_once(irq_find_mapping(domain, line),
@@ -309,78 +233,81 @@ const struct irq_domain_ops ioapic_irq_domain_ops = {
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
+	void *dt;
 
-	if (!of_have_populated_dt())
+	if (!initial_dtb)
 		return;
 
-	for_each_node_with_property(dp, "interrupt-controller") {
-		if (of_device_is_compatible(dp, "intel,ce4100-ioapic"))
-			ioapic_add_ofnode(dp);
+	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK), (u64)128);
+
+	initial_boot_params = dt = early_memremap(initial_dtb, map_len);
+	size = of_get_flat_dt_size();
+	if (map_len < size) {
+		early_iounmap(dt, map_len);
+		initial_boot_params = dt = early_memremap(initial_dtb, size);
+		map_len = size;
 	}
+
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
index a0111e9..1e6cff5 100644
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
