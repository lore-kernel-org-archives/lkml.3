Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbbATDSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:18:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:36496 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbbATDSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:18:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/3] x86: drop support for 1995 era EISA based platforms
Date: Mon, 19 Jan 2015 22:18:21 -0500
Message-ID: <1421723901-32303-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com>
References: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig text says it all, with "The EISA bus saw limited use
between 1988 and 1995 when it was made obsolete by the PCI bus."

That means typically 486/586 CPUs in the 33-166MHz range, and
8-64MB of installed RAM in typical EISA machines of that era.
With the additional cost, they were also typically rare, and not
getting widescale deployment.

Given that it is 20 years on since its demise, and the above specs
might seem just barely acceptable for a wireless router today, lets
stop forcing everyone to build EISA infrastructure and assoc. drivers
during their routine build coverage testing for no value whatsoever.

We'd already removed some obsolete 10Mbit EISA network drivers in
commit bca94cffabf5c9f2399da34eab00bd534bf3735b ("drivers/net: delete
8390 based EISA drivers") over two years ago for the same reason.

If we don't immediately expire EISA completely, we can at least limit
its impact and support/testing overhead to the arch like alpha and
parisc that are essentially frozen in time from a hardware perspective.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/Kconfig               | 18 --------------
 arch/x86/include/asm/mpspec.h  |  4 ----
 arch/x86/kernel/acpi/boot.c    |  6 -----
 arch/x86/kernel/apic/io_apic.c | 54 ------------------------------------------
 arch/x86/kernel/mpparse.c      | 11 +--------
 arch/x86/kernel/traps.c        | 13 ----------
 drivers/acpi/pci_irq.c         |  2 +-
 7 files changed, 2 insertions(+), 106 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba397bd..25ead19 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2291,24 +2291,6 @@ config ISA
 	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
 	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
 
-config EISA
-	bool "EISA support"
-	depends on ISA
-	---help---
-	  The Extended Industry Standard Architecture (EISA) bus was
-	  developed as an open alternative to the IBM MicroChannel bus.
-
-	  The EISA bus provided some of the features of the IBM MicroChannel
-	  bus while maintaining backward compatibility with cards made for
-	  the older ISA bus.  The EISA bus saw limited use between 1988 and
-	  1995 when it was made obsolete by the PCI bus.
-
-	  Say Y here if you are building a kernel for an EISA-based machine.
-
-	  Otherwise, say N.
-
-source "drivers/eisa/Kconfig"
-
 config SCx200
 	tristate "NatSemi SCx200 support"
 	---help---
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index b07233b..16926bb 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -33,10 +33,6 @@ extern unsigned int def_to_bigsmp;
 
 #endif /* CONFIG_X86_64 */
 
-#ifdef CONFIG_EISA
-extern int mp_bus_id_to_type[MAX_MP_BUSSES];
-#endif
-
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 extern unsigned int boot_cpu_physical_apicid;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 9b3ce03..c26aa13 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1072,12 +1072,6 @@ static void __init mp_config_acpi_legacy_irqs(void)
 	int i;
 	struct mpc_intsrc mp_irq;
 
-#ifdef CONFIG_EISA
-	/*
-	 * Fabricate the legacy ISA bus (bus #31).
-	 */
-	mp_bus_id_to_type[MP_ISA_BUS] = MP_BUS_ISA;
-#endif
 	set_bit(MP_ISA_BUS, mp_bus_not_pci);
 	pr_debug("Bus #%d is ISA\n", MP_ISA_BUS);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3f5f604..c28faff 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -168,10 +168,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
-#ifdef CONFIG_EISA
-int mp_bus_id_to_type[MAX_MP_BUSSES];
-#endif
-
 DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 int skip_ioapic_setup;
@@ -792,37 +788,12 @@ static int __init find_isa_irq_apic(int irq, int type)
 	return -1;
 }
 
-#ifdef CONFIG_EISA
-/*
- * EISA Edge/Level control register, ELCR
- */
-static int EISA_ELCR(unsigned int irq)
-{
-	if (irq < nr_legacy_irqs()) {
-		unsigned int port = 0x4d0 + (irq >> 3);
-		return (inb(port) >> (irq & 7)) & 1;
-	}
-	apic_printk(APIC_VERBOSE, KERN_INFO
-			"Broken MPtable reports ISA irq %d\n", irq);
-	return 0;
-}
-
-#endif
-
 /* ISA interrupts are always polarity zero edge triggered,
  * when listed as conforming in the MP table. */
 
 #define default_ISA_trigger(idx)	(0)
 #define default_ISA_polarity(idx)	(0)
 
-/* EISA interrupts are always polarity zero and can be edge or level
- * trigger depending on the ELCR value.  If an interrupt is listed as
- * EISA conforming in the MP table, that means its trigger type must
- * be read in from the ELCR */
-
-#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].srcbusirq))
-#define default_EISA_polarity(idx)	default_ISA_polarity(idx)
-
 /* PCI interrupts are always polarity one level triggered,
  * when listed as conforming in the MP table. */
 
@@ -886,31 +857,6 @@ static int irq_trigger(int idx)
 				trigger = default_ISA_trigger(idx);
 			else
 				trigger = default_PCI_trigger(idx);
-#ifdef CONFIG_EISA
-			switch (mp_bus_id_to_type[bus]) {
-				case MP_BUS_ISA: /* ISA pin */
-				{
-					/* set before the switch */
-					break;
-				}
-				case MP_BUS_EISA: /* EISA pin */
-				{
-					trigger = default_EISA_trigger(idx);
-					break;
-				}
-				case MP_BUS_PCI: /* PCI pin */
-				{
-					/* set before the switch */
-					break;
-				}
-				default:
-				{
-					pr_warn("broken BIOS!!\n");
-					trigger = 1;
-					break;
-				}
-			}
-#endif
 			break;
 		case 1: /* edge */
 		{
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 2d2a237..cb4cfac 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -95,20 +95,11 @@ static void __init MP_bus_info(struct mpc_bus *m)
 #endif
 
 	set_bit(m->busid, mp_bus_not_pci);
-	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-#ifdef CONFIG_EISA
-		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
-#endif
-	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
+	if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
 		if (x86_init.mpparse.mpc_oem_pci_bus)
 			x86_init.mpparse.mpc_oem_pci_bus(m);
 
 		clear_bit(m->busid, mp_bus_not_pci);
-#ifdef CONFIG_EISA
-		mp_bus_id_to_type[m->busid] = MP_BUS_PCI;
-	} else if (strncmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
-		mp_bus_id_to_type[m->busid] = MP_BUS_EISA;
-#endif
 	} else
 		pr_warn("Unknown bustype %s - ignoring\n", str);
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 88900e2..9c6c078 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -37,11 +37,6 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 
-#ifdef CONFIG_EISA
-#include <linux/ioport.h>
-#include <linux/eisa.h>
-#endif
-
 #if defined(CONFIG_EDAC)
 #include <linux/edac.h>
 #endif
@@ -876,14 +871,6 @@ void __init trap_init(void)
 {
 	int i;
 
-#ifdef CONFIG_EISA
-	void __iomem *p = early_ioremap(0x0FFFD9, 4);
-
-	if (readl(p) == 'E' + ('I'<<8) + ('S'<<16) + ('A'<<24))
-		EISA_bus = 1;
-	early_iounmap(p, 4);
-#endif
-
 	set_intr_gate(X86_TRAP_DE, divide_error);
 	set_intr_gate_ist(X86_TRAP_NMI, &nmi, NMI_STACK);
 	/* int4 can be called from all */
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 5277a0e..930beaa 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -370,7 +370,7 @@ static struct acpi_prt_entry *acpi_pci_irq_lookup(struct pci_dev *dev, int pin)
 	return NULL;
 }
 
-#if IS_ENABLED(CONFIG_ISA) || IS_ENABLED(CONFIG_EISA)
+#if IS_ENABLED(CONFIG_ISA)
 static int acpi_isa_register_gsi(struct pci_dev *dev)
 {
 	u32 dev_gsi;
-- 
2.2.1

