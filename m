Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaEPIHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:07:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:27152 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbaEPIHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:07:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1065,1389772800"; 
   d="scan'208";a="540107790"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <monstr@monstr.eu>, Tony Lindgren <tony@atomide.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org
Subject: [RFC Patch Part1 V1 23/30] x86, devicetree, irq: use common mechanism to support irqdomain
Date: Fri, 16 May 2014 16:05:43 +0800
Message-Id: <1400227550-5935-24-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the ioapic driver provides a common interface to create irqdomain,
so replace the private implementation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/prom.h  |    2 --
 arch/x86/kernel/devicetree.c |   80 ++++--------------------------------------
 arch/x86/kernel/irqinit.c    |    6 ----
 3 files changed, 7 insertions(+), 81 deletions(-)

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
index 1ab002c045c9..a44d45df49f5 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -164,6 +164,7 @@ static void __init dtb_lapic_setup(void)
 
 #ifdef CONFIG_X86_IO_APIC
 static unsigned int ioapic_id;
+static struct irq_domain *dt_add_ioapic_domain(int ioapic_num, void *arg);
 
 static void __init dtb_add_ioapic(struct device_node *dn)
 {
@@ -176,7 +177,8 @@ static void __init dtb_add_ioapic(struct device_node *dn)
 				dn->full_name);
 		return;
 	}
-	mp_register_ioapic(++ioapic_id, r.start, gsi_top, NULL, NULL);
+	mp_register_ioapic(++ioapic_id, r.start, gsi_top,
+			   dt_add_ioapic_domain, dn);
 }
 
 static void __init dtb_ioapic_setup(void)
@@ -293,7 +295,7 @@ static int ioapic_xlate(struct irq_domain *domain,
 
 	it = &of_ioapic_type[intspec[1]];
 
-	idx = (u32) domain->host_data;
+	idx = (u32)(long)domain->host_data;
 	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
 
 	rc = io_apic_setup_irq_pin_once(irq_find_mapping(domain, line),
@@ -310,78 +312,10 @@ const struct irq_domain_ops ioapic_irq_domain_ops = {
 	.xlate = ioapic_xlate,
 };
 
-static void dt_add_ioapic_domain(unsigned int ioapic_num,
-		struct device_node *np)
+static struct irq_domain *dt_add_ioapic_domain(int ioapic, void *arg)
 {
-	struct irq_domain *id;
-	struct mp_ioapic_gsi *gsi_cfg;
-	int ret;
-	int num;
-
-	gsi_cfg = mp_ioapic_gsi_routing(ioapic_num);
-	num = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
-
-	id = irq_domain_add_linear(np, num, &ioapic_irq_domain_ops,
-			(void *)ioapic_num);
-	BUG_ON(!id);
-	if (gsi_cfg->gsi_base == 0) {
-		/*
-		 * The first NR_IRQS_LEGACY irq descs are allocated in
-		 * early_irq_init() and need just a mapping. The
-		 * remaining irqs need both. All of them are preallocated
-		 * and assigned so we can keep the 1:1 mapping which the ioapic
-		 * is having.
-		 */
-		irq_domain_associate_many(id, 0, 0, NR_IRQS_LEGACY);
-
-		if (num > NR_IRQS_LEGACY) {
-			ret = irq_create_strict_mappings(id, NR_IRQS_LEGACY,
-					NR_IRQS_LEGACY, num - NR_IRQS_LEGACY);
-			if (ret)
-				pr_err("Error creating mapping for the "
-						"remaining IRQs: %d\n", ret);
-		}
-		irq_set_default_host(id);
-	} else {
-		ret = irq_create_strict_mappings(id, gsi_cfg->gsi_base, 0, num);
-		if (ret)
-			pr_err("Error creating IRQ mapping: %d\n", ret);
-	}
-}
-
-static void __init ioapic_add_ofnode(struct device_node *np)
-{
-	struct resource r;
-	int i, ret;
+	struct device_node *np = arg;
 
-	ret = of_address_to_resource(np, 0, &r);
-	if (ret) {
-		printk(KERN_ERR "Failed to obtain address for %s\n",
-				np->full_name);
-		return;
-	}
-
-	for (i = 0; i < nr_ioapics; i++) {
-		if (r.start == mpc_ioapic_addr(i)) {
-			dt_add_ioapic_domain(i, np);
-			return;
-		}
-	}
-	printk(KERN_ERR "IOxAPIC at %s is not registered.\n", np->full_name);
-}
-
-void __init x86_add_irq_domains(void)
-{
-	struct device_node *dp;
-
-	if (!of_have_populated_dt())
-		return;
-
-	for_each_node_with_property(dp, "interrupt-controller") {
-		if (of_device_is_compatible(dp, "intel,ce4100-ioapic"))
-			ioapic_add_ofnode(dp);
-	}
+	return mp_irqdomain_create(ioapic, np, &ioapic_irq_domain_ops);
 }
-#else
-void __init x86_add_irq_domains(void) { }
 #endif
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 7f50156542fb..a9c0066762e5 100644
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

