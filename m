Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaFII1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:27:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:58946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351AbaFIIWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:22:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352321512"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [Patch V4 30/42] x86, irq, ACPI: use common irqdomain map interface to program IOAPIC pins
Date: Mon,  9 Jun 2014 16:19:59 +0800
Message-Id: <1402302011-23642-31-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine ACPI to use common irqdomain map interface to program IOAPIC pins,
so we can unify the callsite to progam IOAPIC pins.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   44 ++++++++++++-------------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 82ec56a4c6f4..edb48a8e0a0d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -405,11 +405,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			   int polarity)
 {
-	int irq;
-	int ioapic;
-	int ioapic_pin;
-	struct io_apic_irq_attr irq_attr;
-	int ret;
+	int irq, node;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -418,39 +414,27 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
 		return gsi;
 
+	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
+	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
+	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
+	if (mp_set_gsi_attr(gsi, trigger, polarity, node)) {
+		pr_warn("Failed to set pin attr for GSI%d\n", gsi);
+		return -1;
+	}
+
 	irq = map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
 	if (irq < 0)
 		return irq;
 
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0) {
-		printk(KERN_WARNING "No IOAPIC for GSI %u\n", gsi);
-		return gsi;
-	}
-
-	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
-
-	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
-		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mpc_ioapic_id(ioapic),
-		       ioapic_pin);
-		return gsi;
-	}
-
 	if (enable_update_mptable)
 		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
-	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
-			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
-			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	ret = io_apic_set_pci_routing(dev, irq, &irq_attr);
-	if (ret < 0)
-		irq = -1;
-
 	return irq;
 }
 
-static struct irq_domain_ops acpi_irqdomain_ops;
+static struct irq_domain_ops acpi_irqdomain_ops = {
+	.map = mp_irqdomain_map,
+};
 
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
@@ -622,10 +606,6 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 	int irq = map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
 
 	if (irq >= 0) {
-#ifdef CONFIG_X86_IO_APIC
-		if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
-			setup_IO_APIC_irq_extra(gsi);
-#endif
 		*irqp = irq;
 		return 0;
 	}
-- 
1.7.10.4

