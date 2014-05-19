Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985AbaESQZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:25:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:6495 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576AbaESQZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:25:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,868,1392192000"; 
   d="scan'208";a="534297114"
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
Subject: [Patch Part1 V2 25/29] x86, irq, ACPI: use common irqdomain map interface to program IOAPIC pins
Date: Tue, 20 May 2014 00:23:09 +0800
Message-Id: <1400516594-11544-26-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400516594-11544-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400516594-11544-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine ACPI to use common irqdomain map interface to program IOAPIC pins,
so we can unify the callsite to progam IOAPIC pins.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   48 ++++++++++++++++---------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4e8566b071c1..68baa34b8346 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -332,7 +332,9 @@ static void  mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			   int polarity);
 
-static struct irq_domain_ops acpi_irqdomain_ops;
+static struct irq_domain_ops acpi_irqdomain_ops = {
+	.map = mp_irqdomain_map,
+};
 
 static struct irq_domain *acpi_create_irqdomain(int idx, void *arg)
 {
@@ -512,10 +514,6 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 	int irq = map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
 
 	if (irq >= 0) {
-#ifdef CONFIG_X86_IO_APIC
-		if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
-			setup_IO_APIC_irq_extra(gsi);
-#endif
 		*irqp = irq;
 		return 0;
 	}
@@ -1047,11 +1045,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			   int polarity)
 {
-	int irq;
-	int ioapic;
-	int ioapic_pin;
-	struct io_apic_irq_attr irq_attr;
-	int ret;
+	int irq, ioapic, pin, node;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -1060,35 +1054,29 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
 		return gsi;
 
-	irq = map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
-	if (irq < 0)
-		return ACPI_INVALID_GSI;
-
 	ioapic = mp_find_ioapic(gsi);
 	if (ioapic < 0) {
-		printk(KERN_WARNING "No IOAPIC for GSI %u\n", gsi);
-		return gsi;
+		pr_warn("No IOAPIC for GSI %u\n", gsi);
+		return ACPI_INVALID_GSI;
 	}
 
-	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
-
-	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
-		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mpc_ioapic_id(ioapic),
-		       ioapic_pin);
-		return gsi;
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
+	if (mp_set_pin_attr(ioapic, pin,
+			    trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
+			    polarity == ACPI_ACTIVE_HIGH ? 0 : 1,
+			    node)) {
+		pr_warn("Failed to set pin attr for GSI%d\n", gsi);
+		return ACPI_INVALID_GSI;
 	}
 
+	irq = map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
+	if (irq < 0)
+		return ACPI_INVALID_GSI;
+
 	if (enable_update_mptable)
 		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
-	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
-			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
-			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	ret = io_apic_set_pci_routing(dev, irq, &irq_attr);
-	if (ret < 0)
-		gsi = ACPI_INVALID_GSI;
-
 	return gsi;
 }
 
-- 
1.7.10.4

