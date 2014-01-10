Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbaAJWJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:09:39 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:18103 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaAJWHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:07:45 -0500
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com
Subject: [PATCHv3 1/6] Crashdump-Accepting-Active-IOMMU-Flags-and-Prototype
Date: Fri, 10 Jan 2014 15:07:27 -0700
Message-Id: <1389391652-52422-2-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
References: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements a fix for:
A kdump problem about DMA that has been discussed for a long time. That is,
when a kernel panics and boots into the kdump kernel, DMA started by the
panicked kernel is not stopped before the kdump kernel is booted and the
kdump kernel disables the IOMMU while this DMA continues.  This causes the
IOMMU to stop translating the DMA addresses as IOVAs and begin to treat them
as physical memory addresses -- which causes the DMA to either:
(1) generate DMAR errors or (2) generate PCI SERR errors or (3) transfer
data to or from incorrect areas of memory. Often this causes the dump to fail.

This patch set modifies the behavior of the iommu in the (new) crashdump kernel:
1. to accept the iommu hardware in an active state,
2. to leave the current translations in-place so that legacy DMA will continue
   using its current buffers until the device drivers in the crashdump kernel
   initialize and initialize their devices,
3. to use different portions of the iova address ranges for the device drivers
   in the crashdump kernel than the iova ranges that were in-use at the time
   of the panic.
4. to mark as in-use each domain-id that an IOMMU was using at the
   time of the panic -- so that if the crashdump kernel contains a
   device that was not in the panicked kernel (and therefore needs
   a new domain-id) that device will be given an unused domain-id.

Advantages of this approach:
1. All manipulation of the IO-device is done by the Linux device-driver
   for that device.
2. This approach behaves in a manner very similar to operation without an
   active iommu.
3. Any activity between the IO-device and its RMRR areas is handled by the
   device-driver in the same manner as during a non-kdump boot.
4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
   This supports the practice of creating a special kdump kernel without
   drivers for any devices that are not required for taking a crashdump.

This patch contains global flags used by many sections of the code and
prototypes of the interface functions which are coded at the end of
the source file.

Static struct 'pr_dbg' contains bit-flags that control the amount of debug
print placed on the console.  Note that the amount of print increases greatly
(probably geometrically if not faster) as additional bits further down the
structure are enabled.  These flags and the pr_debug() lines scattered
throughout the code are only for the developer or analyst.  At this time,
no means is provided to modify the flags without a re-compile.

v1->v2:
Updated patch description

v2->v3:
No change

Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 75 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 43b9bfe..17c4537 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -48,6 +48,7 @@
 
 #include "irq_remapping.h"
 #include "pci.h"
+#include <linux/crash_dump.h>
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
@@ -164,6 +165,80 @@ static inline unsigned long virt_to_dma_pfn(void *p)
 	return page_to_dma_pfn(virt_to_page(p));
 }
 
+#ifdef CONFIG_CRASH_DUMP
+/* ===================================================================
+ * Crashdump Accepting Active IOMMU
+ * Enhances the crashdump kernel to deal with an active iommu
+ * and legacy DMA from the (old) panic'd kernel in a manner similar to how
+ * legacy DMA is handled when no hardware iommu was in use by the old kernel --
+ * allow the legacy DMA to continue into its current buffers.
+ *
+ * This code:
+ * 1. accepts the iommu hardware in an active state from the old kernel,
+ * 2. leaves the current translations in-place so that legacy DMA will
+ *    continue to use its current buffers,
+ * 3. allocates to the device drivers in the crashdump kernel
+ *    portions of the iova address ranges that are different
+ *    from the iova address ranges that were being used by the old kernel
+ *    at the time of the panic.
+ * -------------------------------------------------------------------
+ */
+
+/* Flags for Crashdump Accepting Active IOMMU */
+
+static int crashdump_accepting_active_iommu;	/* activate this feature */
+static int intel_iommu_translation_tables_are_mapped;	/* table copy done */
+
+static struct {				/* run-time pr_debug() flags */
+	unsigned in_crashdump:1;	/* if crashdump_accepting_active_iommu */
+	unsigned domain_get:1;		/* pr_debug in domain_get* functions */
+	unsigned copy_page_table:1;	/* enter/leave copy_page_table() */
+	unsigned copy_page_addr:1;	/* enter/leave copy_page_addr() */
+	unsigned addr_ranges:1;		/* accumulated addr ranges */
+	unsigned reserved_ranges:1;	/* accumulated addr ranges reserved */
+	unsigned page_addr:1;		/* adr(each page table) */
+	unsigned enter_oldcopy:1;	/* enter oldcopy() parameters */
+	unsigned leave_oldcopy:1;	/* leave oldcopy() parameters */
+} pr_dbg  = {				/* Enable flags below here */
+	.in_crashdump = 1,
+	.domain_get = 1,
+	.copy_page_table = 1,
+	.copy_page_addr = 0,
+	.addr_ranges = 0,
+	.reserved_ranges = 0,
+	.page_addr = 0,
+	.enter_oldcopy = 0,
+	.leave_oldcopy = 0,
+};
+
+/* Prototypes of interface functions for Crashdump Accepting Active IOMMU */
+
+static int
+copy_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd,
+	struct root_entry **root_old_p, struct root_entry **root_new_p);
+
+static int
+domain_get_did_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev);
+
+static int
+domain_get_gaw_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev);
+
+static u64
+domain_get_pgd_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev);
+
+static void
+domain_get_ranges_from_old_kernel(struct dmar_domain *domain,
+		  struct intel_iommu *iommu, struct pci_dev *pdev);
+static int
+intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu);
+
+/* Debug-print functions for  Crashdump Accepting Active IOMMU */
+
+static void
+print_intel_iommu_registers(struct dmar_drhd_unit *drhd);
+#endif	/* CONFIG_CRASH_DUMP */
+
+
 /* global iommu list, set NULL for ignored DMAR units */
 static struct intel_iommu **g_iommus;
 
-- 
Bill Sumner <bill.sumner@hp.com>

