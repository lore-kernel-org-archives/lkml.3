Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628Ab3BHTc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:32:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34139 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760396Ab3BHTaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:30:22 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 17/26] x86, irq: Add ioapic_gsi_to_irq
Date: Fri,  8 Feb 2013 11:28:14 -0800
Message-Id: <1360351703-20571-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For hot add ioapic, irq_base is not equal to gsi_base.

So we need a way to do mapping between gsi and irq.

Also remove irq_to_gsi that is causing confusing, just use that array
directly as only caller already check input irq before.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/acpi/boot.c    |   22 +++++-----------------
 arch/x86/kernel/apic/io_apic.c |   29 ++++++++++++++++++++++++++++-
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
index bacf4b0..350879f 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -112,6 +112,10 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 		}
 	}
 
+#ifdef CONFIG_X86_IO_APIC
+	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
+		return ioapic_gsi_to_irq(gsi);
+#endif
 	/* Provide an identity mapping of gsi == irq
 	 * except on truly weird platforms that have
 	 * non isa irqs in the first 16 gsis.
@@ -124,22 +128,6 @@ static unsigned int gsi_to_irq(unsigned int gsi)
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
  * Temporarily use the virtual area starting from FIX_IO_APIC_BASE_END,
  * to map the target physical address. The problem is that set_fixmap()
@@ -529,7 +517,7 @@ int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
 	if (isa_irq >= 16)
 		return -1;
-	*gsi = irq_to_gsi(isa_irq);
+	*gsi = isa_irq_to_gsi[isa_irq];
 	return 0;
 }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c499c88..9514728 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1044,13 +1044,16 @@ static int pin_2_irq(int idx, int apic, int pin)
 
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
@@ -1476,6 +1479,30 @@ static void __init setup_IO_APIC_irqs(void)
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
1.7.10.4

