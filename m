Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbbATFzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:55:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:28706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbbATFzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:55:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664448366"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [Patch Part2 v4 28/33] x86/irq, ACPI: Kill private function mp_register_gsi()/ mp_unregister_gsi()
Date: Tue, 20 Jan 2015 13:51:48 +0800
Message-Id: <1421733113-15704-29-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function mp_register_gsi() is only called once, so fold it into caller
acpi_register_gsi_ioapic(). Do the same for mp_unregister_gsi().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Link: http://lkml.kernel.org/r/1416901802-24211-37-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/acpi/boot.c |   57 ++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index dac090468f75..5d91ceb248f0 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -400,42 +400,6 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 	return 0;
 }
 
-static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
-			   int polarity)
-{
-	int irq, node;
-	struct irq_alloc_info info;
-
-	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
-		return gsi;
-
-	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
-	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
-	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
-	ioapic_set_alloc_attr(&info, node, trigger, polarity);
-	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC, &info);
-	if (irq < 0)
-		return irq;
-
-	/* Don't set up the ACPI SCI because it's already set up */
-	if (enable_update_mptable && acpi_gbl_FADT.sci_interrupt != gsi)
-		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
-
-	return irq;
-}
-
-static void mp_unregister_gsi(u32 gsi)
-{
-	int irq;
-
-	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
-		return;
-
-	irq = mp_map_gsi_to_irq(gsi, 0, NULL);
-	if (irq > 0)
-		mp_unmap_irq(irq);
-}
-
 static struct irq_domain_ops acpi_irqdomain_ops = {
 	.alloc = mp_irqdomain_alloc,
 	.free = mp_irqdomain_free,
@@ -657,10 +621,21 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 				    int trigger, int polarity)
 {
 	int irq = gsi;
-
 #ifdef CONFIG_X86_IO_APIC
+	int node;
+	struct irq_alloc_info info;
+
+	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
+	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
+	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
+	ioapic_set_alloc_attr(&info, node, trigger, polarity);
+
 	mutex_lock(&acpi_ioapic_lock);
-	irq = mp_register_gsi(dev, gsi, trigger, polarity);
+	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC, &info);
+	/* Don't set up the ACPI SCI because it's already set up */
+	if (irq >= 0 && enable_update_mptable &&
+	    acpi_gbl_FADT.sci_interrupt != gsi)
+		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 	mutex_unlock(&acpi_ioapic_lock);
 #endif
 
@@ -670,8 +645,12 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 static void acpi_unregister_gsi_ioapic(u32 gsi)
 {
 #ifdef CONFIG_X86_IO_APIC
+	int irq;
+
 	mutex_lock(&acpi_ioapic_lock);
-	mp_unregister_gsi(gsi);
+	irq = mp_map_gsi_to_irq(gsi, 0, NULL);
+	if (irq > 0)
+		mp_unmap_irq(irq);
 	mutex_unlock(&acpi_ioapic_lock);
 #endif
 }
-- 
1.7.10.4

