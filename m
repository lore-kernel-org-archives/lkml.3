Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbbATKvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:51:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbbATKuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:50:15 -0500
Date: Tue, 20 Jan 2015 02:49:25 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-b568b8601f05a591a7ff09d8ee1cedb5b2e815fe@git.kernel.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, bhelgaas@google.com,
        len.brown@intel.com, mingo@kernel.org, tony.luck@intel.com,
        linux@eikelenboom.it, david.vrabel@citrix.com, pavel@ucw.cz,
        rjw@rjwysocki.net, konrad.wilk@oracle.com, jiang.liu@linux.intel.com,
        hpa@zytor.com
Reply-To: david.vrabel@citrix.com, pavel@ucw.cz, rjw@rjwysocki.net,
        konrad.wilk@oracle.com, hpa@zytor.com, jiang.liu@linux.intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, bhelgaas@google.com,
        len.brown@intel.com, mingo@kernel.org, tony.luck@intel.com,
        linux@eikelenboom.it
In-Reply-To: <1421720467-7709-2-git-send-email-jiang.liu@linux.intel.com>
References: <1421720467-7709-2-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/xen:
  Treat SCI interrupt as normal GSI interrupt
Git-Commit-ID: b568b8601f05a591a7ff09d8ee1cedb5b2e815fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b568b8601f05a591a7ff09d8ee1cedb5b2e815fe
Gitweb:     http://git.kernel.org/tip/b568b8601f05a591a7ff09d8ee1cedb5b2e815fe
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 20 Jan 2015 10:21:05 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 11:44:40 +0100

x86/xen: Treat SCI interrupt as normal GSI interrupt

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
This causes Xen domain0 fail to install interrupt handler for ACPI SCI
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
Cc: Tony Luck <tony.luck@intel.com>
Cc: xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: http://lkml.kernel.org/r/1421720467-7709-2-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 26 ++++++++++++-------------
 arch/x86/pci/xen.c          | 47 ---------------------------------------------
 2 files changed, 13 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d162636..b9e30da 100644
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
index c489ef2..6e5e89c 100644
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
