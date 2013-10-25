Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3JYPDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:03:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46392 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3JYPDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:03:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Santosh.Jodh@citrix.com, JBeulich@suse.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, mukesh.rathor@oracle.com,
        xhejtman@ics.muni.cz, yuval.shaia@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [v1 2/2] xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG areas and setup 1-1 P2M
Date: Fri, 25 Oct 2013 11:03:21 -0400
Message-Id: <1382713401-4882-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382713401-4882-1-git-send-email-konrad.wilk@oracle.com>
References: <1382713401-4882-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if they aren't there.

The PCI MMCONFIG area is usually reserved via the E820 so the Xen hypervisor
is aware of these regions. But they can also be enumerated in the ACPI
DSDT which means the hypervisor won't know of them until the initial
domain informs it of via PHYSDEVOP_pci_mmcfg_reserved.

This is what this patch does for all of the MCFG regions that the
initial domain is aware of (E820 enumerated and ACPI). Furtheremore
it also makes sure that the P2M area in the guest for the MCFG region
is marked as 1-1 so that any read/writes to it will work.

This setup is done right after the ACPI routines have called and had
mapped alread the MCFG region so we have to potentially tear them down
and recreate them - fortunatly for us the MCFG API provides a mechanism
for us to do that.

Lastly we also make the appropiate hypercall to inform Xen
of the MCFG regions.

Reported-by:  Santosh Jodh <Santosh.Jodh@citrix.com>
CC: Jan Beulich <JBeulich@suse.com>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>
CC: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/pci.c               | 153 +++++++++++++++++++++++++++++++---------
 include/xen/interface/physdev.h |  11 +++
 2 files changed, 130 insertions(+), 34 deletions(-)

diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
index 6b86eda..749abf3 100644
--- a/drivers/xen/pci.c
+++ b/drivers/xen/pci.c
@@ -29,6 +29,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include "../pci/pci.h"
+#include <asm/pci_x86.h>
 
 static bool __read_mostly pci_seg_supported = true;
 
@@ -129,6 +130,49 @@ static int xen_add_device(struct device *dev)
 
 	return r;
 }
+static long xen_p2m_add_pfn(struct device *dev, char *prefix,
+			    unsigned long start, unsigned long end)
+{
+	unsigned long pfn, ok_pfns;
+
+	if (balloon_pfn(start, end - start)) {
+		pr_warn("%s%s is within balloon pages!\n",
+			dev ? dev_name(dev) : "", prefix);
+		return -ENOMEM;
+	}
+
+	for (ok_pfns = 0, pfn = start; pfn < end; pfn++) {
+		unsigned long mfn = pfn_to_mfn(pfn);
+
+		if (mfn == pfn) {
+			ok_pfns++;
+			continue;
+		}
+		if (mfn != INVALID_P2M_ENTRY) { /* RAM */
+			pr_warn("%s%s is within RAM [%lx] region!\n",
+				dev ? dev_name(dev) : "", prefix, pfn);
+			break;
+		}
+	}
+	if (ok_pfns == end - start) /* All good. */
+		return 0;
+
+	if (pfn != end - 1) /* We broke out of the loop above. */
+		return -ENOMEM;
+
+	/* This BAR was not detected during E820 parsing. */
+	for (pfn = start; pfn < end; pfn++) {
+		if (!set_phys_to_machine(pfn, pfn))
+			break;
+	}
+	WARN(pfn != end - 1, "Only set %ld instead of %ld PFNs!\n",
+	     end - pfn, end - start);
+
+	pr_info("%s%s set %ld page(s) to 1-1 mapping.\n",
+		dev ? dev_name(dev) : "", prefix, end - pfn);
+
+	return end - pfn;
+}
 
 static void xen_p2m_add_device(struct device *dev)
 {
@@ -137,7 +181,7 @@ static void xen_p2m_add_device(struct device *dev)
 
 	/* Verify whether the MMIO BARs are 1-1 in the P2M. */
 	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		unsigned long pfn, start, end, ok_pfns;
+		unsigned long start, end;
 		char bus_addr[64];
 		char *fmt;
 
@@ -160,39 +204,7 @@ static void xen_p2m_add_device(struct device *dev)
 		 * We don't worry about the balloon scratch page as it has a
 		 * valid PFN - which means we will catch in the loop below.
 		 */
-		if (balloon_pfn(start, end - start)) {
-			dev_warn(dev, "%s is within balloon pages!\n", bus_addr);
-			continue;
-		}
-
-		for (ok_pfns = 0, pfn = start; pfn < end; pfn++) {
-			unsigned long mfn = pfn_to_mfn(pfn);
-
-			if (mfn == pfn) {
-				ok_pfns++;
-				continue;
-			}
-			if (mfn != INVALID_P2M_ENTRY) { /* RAM */
-				dev_warn(dev, "%s is within RAM [%lx] region!\n", bus_addr, pfn);
-				break;
-			}
-		}
-		if (ok_pfns == end - start) /* All good. */
-			continue;
-
-		if (pfn != end - 1) /* We broke out of the loop above. */
-			continue;
-
-		/* This BAR was not detected during E820 parsing. */
-		for (pfn = start; pfn < end; pfn++) {
-			if (!set_phys_to_machine(pfn, pfn))
-				break;
-		}
-		WARN(pfn != end - 1, "Only set %ld instead of %ld PFNs!\n",
-		     end - pfn, end - start);
-
-		dev_info(dev, "%s set %ld page(s) to 1-1 mapping.\n",
-			 bus_addr, end - pfn);
+		(void)xen_p2m_add_pfn(dev, bus_addr, start, end);
 	}
 }
 
@@ -265,3 +277,76 @@ static int __init register_xen_pci_notifier(void)
 }
 
 arch_initcall(register_xen_pci_notifier);
+
+static int __init xen_mcfg_late(void)
+{
+	struct pci_mmcfg_region *cfg;
+	int rc;
+	bool remap = false;
+
+	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
+		return 0;
+
+	if (list_empty(&pci_mmcfg_list))
+		return 0;
+
+	/* Check whether they are in the right area. */
+	list_for_each_entry(cfg, &pci_mmcfg_list, list) {
+		unsigned long start, end;
+		long pfns;
+		struct physdev_pci_mmcfg_reserved r;
+
+		start = cfg->address + PCI_MMCFG_BUS_OFFSET(cfg->start_bus);
+		end = cfg->address + PCI_MMCFG_BUS_OFFSET(cfg->end_bus + 1) - 1;
+
+		start = PFN_DOWN(start);
+		end = PFN_DOWN(end);
+
+		pfns = xen_p2m_add_pfn(NULL, cfg->name, start, end);
+
+		pr_debug("%s: [%lx->%lx] PFNs: %ld\n", cfg->name, start, end, pfns);
+
+		if (pfns < 0)
+			continue;
+
+		if (pfns > 0)
+			remap = true;
+
+		r.address = cfg->address;
+		r.segment = cfg->segment;
+		r.start_bus = cfg->start_bus;
+		r.end_bus = cfg->end_bus;
+		r.flags = XEN_PCI_MMCFG_RESERVED;
+
+		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pci_mmcfg_reserved, &r);
+		switch (rc) {
+		case 0:
+		case -ENOSYS:
+			continue;
+
+		default:
+			pr_warn("Failed to report MMCONFIG reservation"
+				" state for %s to hypervisor"
+				" (%d)\n",
+				cfg->name, rc);
+		}
+	}
+	/*
+	 * Unmap the PTEs and remap them. The P2M will now have the
+	 * correct PFN values.
+	 */
+	if (remap) {
+		/*
+		 * For 32-bit we end up using fixmap which for FIX_PCIE_MCFG
+		 * in xen_set_fixmap ends up using the _PAGE_IOMAP so
+		 * 1-1 mapping. The calls below are nops.
+		 */
+		pci_mmcfg_arch_free();
+		pci_mmcfg_arch_init();
+	}
+	return 0;
+}
+/*
+ * Needs to be done after balloon_init and acpi_init which are subsys_initcall.
+ */
+subsys_initcall_sync(xen_mcfg_late);
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 7000bb1..42721d1 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -231,6 +231,17 @@ struct physdev_get_free_pirq {
 #define XEN_PCI_DEV_VIRTFN             0x2
 #define XEN_PCI_DEV_PXM                0x4
 
+#define XEN_PCI_MMCFG_RESERVED         0x1
+
+#define PHYSDEVOP_pci_mmcfg_reserved    24
+struct physdev_pci_mmcfg_reserved {
+    uint64_t address;
+    uint16_t segment;
+    uint8_t start_bus;
+    uint8_t end_bus;
+    uint32_t flags;
+};
+
 #define PHYSDEVOP_pci_device_add        25
 struct physdev_pci_device_add {
     /* IN */
-- 
1.8.3.1

