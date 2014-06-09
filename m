Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaFIIVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:21:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:36510 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbaFIIV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:21:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352321092"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jiang Liu <jiang.liu@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Michal Simek <monstr@monstr.eu>,
        Tony Lindgren <tony@atomide.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org, sfi-devel@simplefirmware.org
Subject: [Patch V4 24/42] x86, irq: enhance mp_register_ioapic() to support irqdomain
Date: Mon,  9 Jun 2014 16:19:53 +0800
Message-Id: <1402302011-23642-25-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance function mp_register_ioapic() to support irqdomain.
When registering IOAPIC, caller may provide callbacks and parameters
for creating irqdomain. The IOAPIC core will create irqdomain later
if caller has passed in corresponding parameters.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    3 ++-
 arch/x86/kernel/acpi/boot.c    |    2 +-
 arch/x86/kernel/apic/io_apic.c |   42 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/devicetree.c   |    2 +-
 arch/x86/kernel/mpparse.c      |    2 +-
 arch/x86/platform/sfi/sfi.c    |    2 +-
 6 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 64c6e344399b..3e4bea3a52b1 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -190,7 +190,8 @@ extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
-extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
+extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
+				      struct ioapic_domain_cfg *cfg);
 extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 96d8da83ed8b..15d988cfa335 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -462,7 +462,7 @@ acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 	acpi_table_print_madt_entry(header);
 
 	mp_register_ioapic(ioapic->id,
-			   ioapic->address, ioapic->global_irq_base);
+			   ioapic->address, ioapic->global_irq_base, NULL);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9e5ca8edfccf..9c5f70699a80 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -85,6 +85,7 @@ int sis_apic_bug = -1;
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
 static DEFINE_MUTEX(ioapic_mutex);
+static unsigned int ioapic_dynirq_base;
 
 static struct ioapic {
 	/*
@@ -2920,8 +2921,35 @@ out:
  */
 #define PIC_IRQS	(1UL << PIC_CASCADE_IR)
 
+static int mp_irqdomain_create(int ioapic)
+{
+	int hwirqs = mp_ioapic_pin_count(ioapic);
+	struct ioapic *ip = &ioapics[ioapic];
+	struct ioapic_domain_cfg *cfg = &ip->irqdomain_cfg;
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+
+	if (cfg->type == IOAPIC_DOMAIN_INVALID)
+		return 0;
+
+	ip->irqdomain = irq_domain_add_linear(cfg->dev, hwirqs, cfg->ops,
+					      (void *)(long)ioapic);
+	if(!ip->irqdomain)
+		return -ENOMEM;
+
+	if (cfg->type == IOAPIC_DOMAIN_LEGACY ||
+	    cfg->type == IOAPIC_DOMAIN_STRICT)
+		ioapic_dynirq_base = max(ioapic_dynirq_base,
+					 gsi_cfg->gsi_end + 1);
+
+	if (gsi_cfg->gsi_base == 0)
+		irq_set_default_host(ip->irqdomain);
+
+	return 0;
+}
+
 void __init setup_IO_APIC(void)
 {
+	int ioapic;
 
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
@@ -2929,6 +2957,9 @@ void __init setup_IO_APIC(void)
 	io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
+	for_each_ioapic(ioapic)
+		BUG_ON(mp_irqdomain_create(ioapic));
+
 	/*
          * Set up IO-APIC IRQ routing.
          */
@@ -3433,6 +3464,9 @@ unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
 	unsigned int min = gsi_top + nr_legacy_irqs();
 
+	if (ioapic_dynirq_base)
+		return ioapic_dynirq_base;
+
 	return from < min ? min : from;
 }
 
@@ -3808,7 +3842,8 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
+void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			       struct ioapic_domain_cfg *cfg)
 {
 	int idx = 0;
 	int entries;
@@ -3822,6 +3857,11 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
 	ioapics[idx].mp_config.apicaddr = address;
+	ioapics[idx].irqdomain = NULL;
+	if (cfg)
+		ioapics[idx].irqdomain_cfg = *cfg;
+	else
+		ioapics[idx].irqdomain_cfg.type = IOAPIC_DOMAIN_INVALID;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index e08a007bdacf..dd6936818330 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -177,7 +177,7 @@ static void __init dtb_add_ioapic(struct device_node *dn)
 				dn->full_name);
 		return;
 	}
-	mp_register_ioapic(++ioapic_id, r.start, gsi_top);
+	mp_register_ioapic(++ioapic_id, r.start, gsi_top, NULL);
 }
 
 static void __init dtb_ioapic_setup(void)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index b10e1132f316..ea8595e4cbd5 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -115,7 +115,7 @@ static void __init MP_bus_info(struct mpc_bus *m)
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
 	if (m->flags & MPC_APIC_USABLE)
-		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top);
+		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top, NULL);
 }
 
 static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index bcd1a703e3e6..8f2f789c6f04 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -82,7 +82,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_top);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_top, NULL);
 		pentry++;
 	}
 
-- 
1.7.10.4

