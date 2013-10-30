Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3J3TFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:05:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46113 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3J3TFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:05:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: [PATCH] xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG areas.
Date: Wed, 30 Oct 2013 15:04:44 -0400
Message-Id: <1383159884-14170-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI MMCONFIG area is usually reserved via the E820 so the Xen hypervisor
is aware of these regions. But they can also be enumerated in the ACPI
DSDT which means the hypervisor won't know of them until the initial
domain informs it of via PHYSDEVOP_pci_mmcfg_reserved.

This is what this patch does for all of the MCFG regions that the
initial domain is aware of (E820 enumerated and ACPI).

Reported-by:  Santosh Jodh <Santosh.Jodh@citrix.com>
CC: Jan Beulich <JBeulich@suse.com>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>
CC: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v1: Redid it a bit]
[v2: Dropped the P2M 1-1 setting]
---
 drivers/xen/pci.c               | 42 +++++++++++++++++++++++++++++++++++++++++
 include/xen/interface/physdev.h | 11 +++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
index 18fff88..ef3256a 100644
--- a/drivers/xen/pci.c
+++ b/drivers/xen/pci.c
@@ -26,6 +26,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include "../pci/pci.h"
+#include <asm/pci_x86.h>
 
 static bool __read_mostly pci_seg_supported = true;
 
@@ -192,3 +193,44 @@ static int __init register_xen_pci_notifier(void)
 }
 
 arch_initcall(register_xen_pci_notifier);
+
+static int __init xen_mcfg_late(void)
+{
+	struct pci_mmcfg_region *cfg;
+	int rc;
+
+	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
+		return 0;
+
+	if (list_empty(&pci_mmcfg_list))
+		return 0;
+
+	/* Check whether they are in the right area. */
+	list_for_each_entry(cfg, &pci_mmcfg_list, list) {
+		struct physdev_pci_mmcfg_reserved r;
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
+	return 0;
+}
+/*
+ * Needs to be done after acpi_init which are subsys_initcall.
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

