Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaEPIGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:06:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:9298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbaEPIFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1065,1389772800"; 
   d="scan'208";a="540107298"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
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
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC Patch Part1 V1 17/30] x86, irq: introduce some helper utilities to improve readability
Date: Fri, 16 May 2014 16:05:37 +0800
Message-Id: <1400227550-5935-18-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   41 +++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index dd81b58cce95..faed9b62977d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -117,6 +117,26 @@ struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
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
+static inline int mp_init_pin_at_boot(int ioapic, int pin)
+{
+	u32 gsi = mp_pin_2_gsi(ioapic, pin);
+
+	return ioapic == 0 || gsi < NR_IRQS_LEGACY;
+}
+
 int nr_ioapics;
 
 /* The one past the highest gsi number used */
@@ -1378,15 +1398,15 @@ static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
 	unsigned int pin, irq;
 
 	for_each_pin(ioapic_idx, pin) {
+		if (!mp_init_pin_at_boot(ioapic_idx, pin))
+			continue;
+
 		idx = find_irq_entry(ioapic_idx, pin, mp_INT);
 		if (io_apic_pin_not_connected(idx, ioapic_idx, pin))
 			continue;
 
 		irq = pin_2_irq(idx, ioapic_idx, pin);
 
-		if ((ioapic_idx > 0) && (irq > NR_IRQS_LEGACY))
-			continue;
-
 		/*
 		 * Skip the timer IRQ if there's a quirk handler
 		 * installed and if it returns 1:
@@ -1430,16 +1450,15 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	pin = mp_find_ioapic_pin(ioapic_idx, gsi);
+	if (mp_init_pin_at_boot(ioapic_idx, pin))
+		return;
+
 	idx = find_irq_entry(ioapic_idx, pin, mp_INT);
 	if (idx == -1)
 		return;
 
 	irq = pin_2_irq(idx, ioapic_idx, pin);
 
-	/* Only handle the non legacy irqs on secondary ioapics */
-	if (ioapic_idx == 0 || irq < NR_IRQS_LEGACY)
-		return;
-
 	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
 			     irq_polarity(idx));
 
@@ -3605,14 +3624,14 @@ void __init setup_ioapic_dest(void)
 		return;
 
 	for_each_ioapic_pin(ioapic, pin) {
-		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
-		if (irq_entry == -1)
+		if (!mp_init_pin_at_boot(ioapic, pin))
 			continue;
-		irq = pin_2_irq(irq_entry, ioapic, pin);
 
-		if ((ioapic > 0) && (irq > NR_IRQS_LEGACY))
+		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
+		if (irq_entry == -1)
 			continue;
 
+		irq = pin_2_irq(irq_entry, ioapic, pin);
 		idata = irq_get_irq_data(irq);
 
 		/*
-- 
1.7.10.4

