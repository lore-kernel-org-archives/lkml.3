Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaKHSSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:18:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:30726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaKHSSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:18:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413534403"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [Patch Part3 v3 36/38] ACPI, irq, x86: Kill private function mp_register_gsi()/ mp_unregister_gsi()
Date: Sun,  9 Nov 2014 02:13:36 +0800
Message-Id: <1415470418-10874-37-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function mp_register_gsi() is only called once, so fold it into caller
acpi_register_gsi_ioapic(). Do the same for mp_unregister_gsi().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   57 ++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 509a48f49fc7..e54a8d72ae6e 100644
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

