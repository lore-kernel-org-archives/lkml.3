Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaE0IIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:08:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:37577 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbaE0II3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:08:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="538017723"
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
Subject: [Patch V3 16/37] x86, irq: introduce some helper utilities to improve readability
Date: Tue, 27 May 2014 16:07:51 +0800
Message-Id: <1401178092-1228-17-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It also fixes an off by one bug in
	if ((ioapic_idx > 0) && (irq > NR_IRQS_LEGACY))
It should be
	if ((ioapic_idx > 0) && (irq >= NR_IRQS_LEGACY))

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    2 ++
 arch/x86/kernel/apic/io_apic.c |   29 ++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index de3d8b04cf64..b775cf3622c3 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -171,6 +171,7 @@ extern u32 gsi_top;
 
 extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
+extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
@@ -212,6 +213,7 @@ extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 static inline void ioapic_insert_resources(void) { }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
+static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b14241915262..99acd633287b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -117,6 +117,24 @@ struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
 	return &ioapics[ioapic_idx].gsi_config;
 }
 
+static inline int mp_ioapic_pin_count(int ioapic)
+{
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+
+	return gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
+}
+
+u32 mp_pin_to_gsi(int ioapic, int pin)
+{
+	return mp_ioapic_gsi_routing(ioapic)->gsi_base + pin;
+}
+
+/* Initialize all legacy IRQs and all pins on the first IOAPIC at boot */
+static inline int mp_init_irq_at_boot(int ioapic, int irq)
+{
+	return ioapic == 0 || (irq >= 0 && irq < NR_IRQS_LEGACY);
+}
+
 int nr_ioapics;
 
 /* The one past the highest gsi number used */
@@ -1367,8 +1385,7 @@ static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
 			continue;
 
 		irq = pin_2_irq(idx, ioapic_idx, pin);
-
-		if ((ioapic_idx > 0) && (irq > NR_IRQS_LEGACY))
+		if (!mp_init_irq_at_boot(ioapic_idx, irq))
 			continue;
 
 		/*
@@ -1419,9 +1436,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, ioapic_idx, pin);
-
-	/* Only handle the non legacy irqs on secondary ioapics */
-	if (ioapic_idx == 0 || irq < NR_IRQS_LEGACY)
+	if (mp_init_irq_at_boot(ioapic_idx, irq))
 		return;
 
 	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
@@ -3535,9 +3550,9 @@ void __init setup_ioapic_dest(void)
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
-		irq = pin_2_irq(irq_entry, ioapic, pin);
 
-		if ((ioapic > 0) && (irq > NR_IRQS_LEGACY))
+		irq = pin_2_irq(irq_entry, ioapic, pin);
+		if (!mp_init_irq_at_boot(ioapic, irq))
 			continue;
 
 		idata = irq_get_irq_data(irq);
-- 
1.7.10.4

