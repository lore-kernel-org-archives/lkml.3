Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaFIIRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:17:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:52842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbaFIIRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:17:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352319615"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Weinberger <richard@nod.at>, Andi Kleen <ak@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-pm@vger.kernel.org
Subject: [Patch V4 03/42] x86, mpparse: simplify arch/x86/include/asm/mpspec.h
Date: Mon,  9 Jun 2014 16:19:32 +0800
Message-Id: <1402302011-23642-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify arch/x86/include/asm/mpspec.h by
1) Change max_physical_apicid to static as it's only used in apic.c.
2) Kill declaration of mpc_default_type, it's never defined.
3) Delete default_acpi_madt_oem_check(), it has already been declared
   in apic.h.
4) Make default_acpi_madt_oem_check() depends on CONFIG_X86_LOCAL_APIC
   instead of CONFIG_X86_64 to support i386.
5) Change mp_override_legacy_irq(), mp_config_acpi_legacy_irqs() and
   mp_register_gsi() as static because they are only used in acpi/boot.c.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/apic.h    |    4 ++--
 arch/x86/include/asm/io_apic.h |    3 ---
 arch/x86/include/asm/mpspec.h  |   13 -------------
 arch/x86/kernel/acpi/boot.c    |   12 +++++++++---
 arch/x86/kernel/apic/apic.c    |    2 +-
 5 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 19b0ebafcd3e..69ed79aa9085 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -502,8 +502,6 @@ static inline unsigned default_get_apic_id(unsigned long x)
 #define DEFAULT_TRAMPOLINE_PHYS_HIGH		0x469
 
 #ifdef CONFIG_X86_64
-extern int default_acpi_madt_oem_check(char *, char *);
-
 extern void apic_send_IPI_self(int vector);
 
 DECLARE_PER_CPU(int, x2apic_extra_bits);
@@ -552,6 +550,8 @@ static inline int default_apic_id_valid(int apicid)
 	return (apicid < 255);
 }
 
+extern int default_acpi_madt_oem_check(char *, char *);
+
 extern void default_setup_apic_routing(void);
 
 extern struct apic apic_noop;
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 90f97b4b9347..9121abbc8c8f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -118,9 +118,6 @@ extern int mp_irq_entries;
 /* MP IRQ source entries */
 extern struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
-/* non-0 if default (table-less) MP configuration */
-extern int mpc_default_type;
-
 /* Older SiS APIC requires we rewrite the index register */
 extern int sis_apic_bug;
 
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index f5a617956735..7bef40a01a1d 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -40,8 +40,6 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 extern unsigned int boot_cpu_physical_apicid;
-extern unsigned int max_physical_apicid;
-extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -88,15 +86,6 @@ static inline void early_reserve_e820_mpc_new(void) { }
 #endif
 
 int generic_processor_info(int apicid, int version);
-#ifdef CONFIG_ACPI
-extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
-extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
-				   u32 gsi);
-extern void mp_config_acpi_legacy_irqs(void);
-struct device;
-extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
-				 int active_high_low);
-#endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_LOCAL_APIC)
 
@@ -163,6 +152,4 @@ extern physid_mask_t phys_cpu_present_map;
 
 extern int generic_mps_oem_check(struct mpc_table *, char *, char *);
 
-extern int default_acpi_madt_oem_check(char *, char *);
-
 #endif /* _ASM_X86_MPSPEC_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 86281ffb96d6..b41b47021f53 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -345,6 +345,10 @@ acpi_parse_lapic_nmi(struct acpi_subtable_header * header, const unsigned long e
 #endif				/*CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
+static void  mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
+				    u32 gsi);
+static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
+			   int polarity);
 
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
@@ -903,7 +907,8 @@ static int __init acpi_parse_madt_lapic_entries(void)
 #ifdef	CONFIG_X86_IO_APIC
 #define MP_ISA_BUS		0
 
-void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
+static void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
+					  u32 gsi)
 {
 	int ioapic;
 	int pin;
@@ -938,7 +943,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	isa_irq_to_gsi[bus_irq] = gsi;
 }
 
-void __init mp_config_acpi_legacy_irqs(void)
+static void __init mp_config_acpi_legacy_irqs(void)
 {
 	int i;
 	struct mpc_intsrc mp_irq;
@@ -1040,7 +1045,8 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 	return 0;
 }
 
-int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
+static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
+			   int polarity)
 {
 	int ioapic;
 	int ioapic_pin;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ad28db7e6bde..ca1bd75e3de2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -67,7 +67,7 @@ EXPORT_SYMBOL_GPL(boot_cpu_physical_apicid);
 /*
  * The highest APIC ID seen during enumeration.
  */
-unsigned int max_physical_apicid;
+static unsigned int max_physical_apicid;
 
 /*
  * Bitmask of physically existing CPUs:
-- 
1.7.10.4

