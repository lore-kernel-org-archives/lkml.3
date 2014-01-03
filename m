Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaACAOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:14:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23654 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbaACAHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v5 18/33] x86, irq: Add ioapic_gsi_to_irq
Date: Thu,  2 Jan 2014 16:05:50 -0800
Message-Id: <1388707565-16535-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For hot add ioapic, irq_base is not equal to gsi_base.
We need a way to do mapping between gsi and irq.

Also remove irq_to_gsi() that is confusing, just use that array
directly as we only have one caller and it already check
input irq before use it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/io_apic.h |  1 +
 arch/x86/kernel/acpi/boot.c    | 22 +++++-----------------
 arch/x86/kernel/apic/io_apic.c | 29 ++++++++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 8181fd8..02ac411 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -180,6 +180,7 @@ struct mp_ioapic_gsi{
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
 extern u32 gsi_top;
+int ioapic_gsi_to_irq(u32 gsi);
 int mp_find_ioapic(u32 gsi);
 int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6c0b43b..0f9c133 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -113,6 +113,10 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 		}
 	}
 
+#ifdef CONFIG_X86_IO_APIC
+	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
+		return ioapic_gsi_to_irq(gsi);
+#endif
 	/* Provide an identity mapping of gsi == irq
 	 * except on truly weird platforms that have
 	 * non isa irqs in the first 16 gsis.
@@ -125,22 +129,6 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 	return irq;
 }
 
-static u32 irq_to_gsi(int irq)
-{
-	unsigned int gsi;
-
-	if (irq < NR_IRQS_LEGACY)
-		gsi = isa_irq_to_gsi[irq];
-	else if (irq < gsi_top)
-		gsi = irq;
-	else if (irq < (gsi_top + NR_IRQS_LEGACY))
-		gsi = irq - gsi_top;
-	else
-		gsi = 0xffffffff;
-
-	return gsi;
-}
-
 /*
  * This is just a simple wrapper around early_ioremap(),
  * with sanity checks for phys == 0 and size == 0.
@@ -530,7 +518,7 @@ int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
 	if (isa_irq >= 16)
 		return -1;
-	*gsi = irq_to_gsi(isa_irq);
+	*gsi = isa_irq_to_gsi[isa_irq];
 	return 0;
 }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a1af837..066611f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1041,13 +1041,16 @@ static int pin_2_irq(int idx, int apic, int pin)
 
 	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
-	} else {
+	} else if (gsi_cfg->gsi_base == gsi_cfg->irq_base) {
 		u32 gsi = gsi_cfg->gsi_base + pin;
 
 		if (gsi >= NR_IRQS_LEGACY)
 			irq = gsi;
 		else
 			irq = gsi_top + gsi;
+	} else {
+		/* hotadd ioapic */
+		irq = gsi_cfg->irq_base + pin;
 	}
 
 #ifdef CONFIG_X86_32
@@ -1473,6 +1476,30 @@ static void __init setup_IO_APIC_irqs(void)
 		__io_apic_setup_irqs(ioapic_idx);
 }
 
+int ioapic_gsi_to_irq(u32 gsi)
+{
+	int ioapic_idx = 0, irq = gsi;
+	struct mp_ioapic_gsi *gsi_cfg;
+
+	ioapic_idx = mp_find_ioapic(gsi);
+	if (ioapic_idx < 0)
+		return -1;
+
+	gsi_cfg = mp_ioapic_gsi_routing(ioapic_idx);
+	if (gsi_cfg->gsi_base == gsi_cfg->irq_base) {
+		if (gsi < NR_IRQS_LEGACY)
+			irq = gsi_top + gsi;
+	} else {
+		int pin = mp_find_ioapic_pin(ioapic_idx, gsi);
+
+		if (pin < 0)
+			return -1;
+		/* hotadd ioapic */
+		irq = gsi_cfg->irq_base + pin;
+	}
+
+	return irq;
+}
 /*
  * for the gsit that is not in first ioapic
  * but could not use acpi_register_gsi()
-- 
1.8.4

