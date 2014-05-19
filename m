Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbaESQXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:23:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:2873 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbaESQXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:23:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,868,1392192000"; 
   d="scan'208";a="534295947"
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
Subject: [Patch Part1 V2 16/29] x86, irq: introduce some helper utilities to improve readability
Date: Tue, 20 May 2014 00:23:00 +0800
Message-Id: <1400516594-11544-17-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400516594-11544-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400516594-11544-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index bb013e4126c3..3b6e29d29903 100644
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
+static inline u32 mp_pin_2_gsi(int ioapic, int pin)
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
@@ -1368,8 +1386,7 @@ static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
 			continue;
 
 		irq = pin_2_irq(idx, ioapic_idx, pin);
-
-		if ((ioapic_idx > 0) && (irq > NR_IRQS_LEGACY))
+		if (!mp_init_irq_at_boot(ioapic_idx, irq))
 			continue;
 
 		/*
@@ -1420,9 +1437,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, ioapic_idx, pin);
-
-	/* Only handle the non legacy irqs on secondary ioapics */
-	if (ioapic_idx == 0 || irq < NR_IRQS_LEGACY)
+	if (mp_init_irq_at_boot(ioapic_idx, irq))
 		return;
 
 	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
@@ -3536,9 +3551,9 @@ void __init setup_ioapic_dest(void)
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

