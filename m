Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaFUVUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:20:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaFUVUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:20:36 -0400
Date: Sat, 21 Jun 2014 14:14:29 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-44767bfaaed782d6d635ecbb13f3980041e6f33e@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, monstr@monstr.eu,
        tglx@linutronix.de, len.brown@intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        yinghai@kernel.org, joro@8bytes.org, pavel@ucw.cz, tony@atomide.com,
        rob.herring@calxeda.com, benh@kernel.crashing.org, bhelgaas@google.com,
        rjw@rjwysocki.net, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, monstr@monstr.eu,
        tglx@linutronix.de, len.brown@intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        yinghai@kernel.org, joro@8bytes.org, pavel@ucw.cz,
        rob.herring@calxeda.com, tony@atomide.com, bhelgaas@google.com,
        benh@kernel.crashing.org, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-25-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-25-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Enhance mp_register_ioapic()
  to support irqdomain
Git-Commit-ID: 44767bfaaed782d6d635ecbb13f3980041e6f33e
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

Commit-ID:  44767bfaaed782d6d635ecbb13f3980041e6f33e
Gitweb:     http://git.kernel.org/tip/44767bfaaed782d6d635ecbb13f3980041e6f33e
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:53 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:42 +0200

x86, irq: Enhance mp_register_ioapic() to support irqdomain

Enhance function mp_register_ioapic() to support irqdomain.
When registering IOAPIC, caller may provide callbacks and parameters
for creating irqdomain. The IOAPIC core will create irqdomain later
if caller has passed in corresponding parameters.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sfi-devel@simplefirmware.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Tony Lindgren <tony@atomide.com>
Link: http://lkml.kernel.org/r/1402302011-23642-25-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  3 ++-
 arch/x86/kernel/acpi/boot.c    |  2 +-
 arch/x86/kernel/apic/io_apic.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/devicetree.c   |  2 +-
 arch/x86/kernel/mpparse.c      |  2 +-
 arch/x86/platform/sfi/sfi.c    |  2 +-
 6 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 64c6e34..3e4bea3 100644
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
index d6635ba..f86b4ba 100644
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
index 51ce80004..563f450 100644
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
@@ -3437,6 +3468,9 @@ unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
 	unsigned int min = gsi_top + nr_legacy_irqs();
 
+	if (ioapic_dynirq_base)
+		return ioapic_dynirq_base;
+
 	return from < min ? min : from;
 }
 
@@ -3812,7 +3846,8 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
+void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			       struct ioapic_domain_cfg *cfg)
 {
 	int idx = 0;
 	int entries;
@@ -3826,6 +3861,11 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
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
index b468005..d2c53fe 100644
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
index b10e113..ea8595e 100644
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
index bcd1a70..8f2f789 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -82,7 +82,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_top);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_top, NULL);
 		pentry++;
 	}
 
