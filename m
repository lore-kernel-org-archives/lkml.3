Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbbAONE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:04:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:3394 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbbAONCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:02:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,403,1418112000"; 
   d="scan'208";a="637718414"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-pci@vger.kernel.org
Subject: [Bugfix v4 2/2] xen/pci: Simplify x86/pci/xen.c by killing gsi_override related code
Date: Thu, 15 Jan 2015 21:04:36 +0800
Message-Id: <1421327077-19894-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421327077-19894-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421204979-30619-1-git-send-email-jiang.liu@linux.intel.com>
 <1421327077-19894-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no use of gsi_override related logic anymore, so kill code
related to gsi_override.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/pci/xen.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 6e5e89c3c644..a73c3bd71243 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -59,8 +59,7 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 }
 
 #ifdef CONFIG_ACPI
-static int xen_register_pirq(u32 gsi, int gsi_override, int triggering,
-			     bool set_pirq)
+static int xen_register_pirq(u32 gsi, int triggering, bool set_pirq)
 {
 	int rc, pirq = -1, irq = -1;
 	struct physdev_map_pirq map_irq;
@@ -93,9 +92,6 @@ static int xen_register_pirq(u32 gsi, int gsi_override, int triggering,
 		name = "ioapic-level";
 	}
 
-	if (gsi_override >= 0)
-		gsi = gsi_override;
-
 	irq = xen_bind_pirq_gsi_to_irq(gsi, map_irq.pirq, shareable, name);
 	if (irq < 0)
 		goto out;
@@ -111,12 +107,13 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 	if (!xen_hvm_domain())
 		return -1;
 
-	return xen_register_pirq(gsi, -1 /* no GSI override */, trigger,
+	return xen_register_pirq(gsi, trigger,
 				 false /* no mapping of GSI to PIRQ */);
 }
 
 #ifdef CONFIG_XEN_DOM0
-static int xen_register_gsi(u32 gsi, int gsi_override, int triggering, int polarity)
+static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
+				 int triggering, int polarity)
 {
 	int rc, irq;
 	struct physdev_setup_gsi setup_gsi;
@@ -127,7 +124,7 @@ static int xen_register_gsi(u32 gsi, int gsi_override, int triggering, int polar
 	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
 			gsi, triggering, polarity);
 
-	irq = xen_register_pirq(gsi, gsi_override, triggering, true);
+	irq = xen_register_pirq(gsi, triggering, true);
 
 	setup_gsi.gsi = gsi;
 	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
@@ -143,12 +140,6 @@ static int xen_register_gsi(u32 gsi, int gsi_override, int triggering, int polar
 
 	return irq;
 }
-
-static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
-				 int trigger, int polarity)
-{
-	return xen_register_gsi(gsi, -1 /* no GSI override */, trigger, polarity);
-}
 #endif
 #endif
 
@@ -489,7 +480,7 @@ int __init pci_xen_initial_domain(void)
 		if (acpi_get_override_irq(irq, &trigger, &polarity) == -1)
 			continue;
 
-		xen_register_pirq(irq, -1 /* no GSI override */,
+		xen_register_pirq(irq,
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE,
 			true /* Map GSI to PIRQ */);
 	}
-- 
1.7.10.4

