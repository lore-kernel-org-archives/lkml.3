Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbbATCS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:18:29 -0500
Received: from mga03.intel.com ([134.134.136.65]:52772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbbATCS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:18:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,431,1418112000"; 
   d="scan'208";a="514609189"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: [Bugfix 1/3] xen/pci: Kill function xen_setup_acpi_sci()
Date: Tue, 20 Jan 2015 10:21:05 +0800
Message-Id: <1421720467-7709-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421720467-7709-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421720467-7709-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently Xen Domain0 has special treatment for ACPI SCI interrupt,
that is initialize irq for ACPI SCI at early stage in a special way as:
xen_init_IRQ()
	->pci_xen_initial_domain()
		->xen_setup_acpi_sci()
			Allocate and initialize irq for ACPI SCI

Function xen_setup_acpi_sci() calls acpi_gsi_to_irq() to get an irq
number for ACPI SCI. But unfortunately acpi_gsi_to_irq() depends on
IOAPIC irqdomains through following path
acpi_gsi_to_irq()
	->mp_map_gsi_to_irq()
		->mp_map_pin_to_irq()
			->check IOAPIC irqdomain

For PV domains, it uses Xen event based interrupt manangement and
doesn't make uses of native IOAPIC, so no irqdomains created for IOAPIC.
This causes Xen domain0 fails to install interrupt handler for ACPI SCI
and all ACPI events will be lost. Please refer to:
https://lkml.org/lkml/2014/12/19/178

So the fix is to get rid of special treatment for ACPI SCI, just treat
ACPI SCI as normal GSI interrupt as:
acpi_gsi_to_irq()
	->acpi_register_gsi()
		->acpi_register_gsi_xen()
			->xen_register_gsi()

With above change, there's no need for xen_setup_acpi_sci() anymore.
The above change also works with bare metal kernel too.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
---
 arch/x86/kernel/acpi/boot.c |   26 ++++++++++++------------
 arch/x86/pci/xen.c          |   47 -------------------------------------------
 2 files changed, 13 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d1626364a28a..b9e30daa0881 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -611,20 +611,20 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	int irq;
-
-	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
-		*irqp = gsi;
-	} else {
-		mutex_lock(&acpi_ioapic_lock);
-		irq = mp_map_gsi_to_irq(gsi,
-					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
-		mutex_unlock(&acpi_ioapic_lock);
-		if (irq < 0)
-			return -1;
-		*irqp = irq;
+	int rc, irq, trigger, polarity;
+
+	rc = acpi_get_override_irq(gsi, &trigger, &polarity);
+	if (rc == 0) {
+		trigger = trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
+		polarity = polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
+		irq = acpi_register_gsi(NULL, gsi, trigger, polarity);
+		if (irq >= 0) {
+			*irqp = irq;
+			return 0;
+		}
 	}
-	return 0;
+
+	return -1;
 }
 EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index c489ef2c1a39..6e5e89c3c644 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -471,52 +471,6 @@ int __init pci_xen_hvm_init(void)
 }
 
 #ifdef CONFIG_XEN_DOM0
-static __init void xen_setup_acpi_sci(void)
-{
-	int rc;
-	int trigger, polarity;
-	int gsi = acpi_sci_override_gsi;
-	int irq = -1;
-	int gsi_override = -1;
-
-	if (!gsi)
-		return;
-
-	rc = acpi_get_override_irq(gsi, &trigger, &polarity);
-	if (rc) {
-		printk(KERN_WARNING "xen: acpi_get_override_irq failed for acpi"
-				" sci, rc=%d\n", rc);
-		return;
-	}
-	trigger = trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
-	polarity = polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
-
-	printk(KERN_INFO "xen: sci override: global_irq=%d trigger=%d "
-			"polarity=%d\n", gsi, trigger, polarity);
-
-	/* Before we bind the GSI to a Linux IRQ, check whether
-	 * we need to override it with bus_irq (IRQ) value. Usually for
-	 * IRQs below IRQ_LEGACY_IRQ this holds IRQ == GSI, as so:
-	 *  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
-	 * but there are oddballs where the IRQ != GSI:
-	 *  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
-	 * which ends up being: gsi_to_irq[9] == 20
-	 * (which is what acpi_gsi_to_irq ends up calling when starting the
-	 * the ACPI interpreter and keels over since IRQ 9 has not been
-	 * setup as we had setup IRQ 20 for it).
-	 */
-	if (acpi_gsi_to_irq(gsi, &irq) == 0) {
-		/* Use the provided value if it's valid. */
-		if (irq >= 0)
-			gsi_override = irq;
-	}
-
-	gsi = xen_register_gsi(gsi, gsi_override, trigger, polarity);
-	printk(KERN_INFO "xen: acpi sci %d\n", gsi);
-
-	return;
-}
-
 int __init pci_xen_initial_domain(void)
 {
 	int irq;
@@ -527,7 +481,6 @@ int __init pci_xen_initial_domain(void)
 	x86_msi.restore_msi_irqs = xen_initdom_restore_msi_irqs;
 	pci_msi_ignore_mask = 1;
 #endif
-	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
 	/* Pre-allocate legacy irqs */
 	for (irq = 0; irq < nr_legacy_irqs(); irq++) {
-- 
1.7.10.4

