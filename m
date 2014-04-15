Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaDOXM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:12:29 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:49995 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaDOXJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:09:33 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com
Subject: [PATCH 5/8] Add new definitions & prototypes to intel-iommu-private.h
Date: Tue, 15 Apr 2014 17:09:06 -0600
Message-Id: <1397603349-30930-6-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
References: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Items needed for fixing crashdump.


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu-private.h | 92 +++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/drivers/iommu/intel-iommu-private.h b/drivers/iommu/intel-iommu-private.h
index 73dabec..b436cd8 100644
--- a/drivers/iommu/intel-iommu-private.h
+++ b/drivers/iommu/intel-iommu-private.h
@@ -349,3 +349,95 @@ static inline void free_pgtable_page(void *vaddr)
 	free_page((unsigned long)vaddr);
 }
 
+#ifdef CONFIG_CRASH_DUMP
+/*
+ * Fix Crashdump failure caused by leftover DMA through a hardware IOMMU
+ *
+ * Fixes the crashdump kernel to deal with an active iommu and legacy
+ * DMA from the (old) panicked kernel in a manner similar to how legacy
+ * DMA is handled when no hardware iommu was in use by the old kernel --
+ * allow the legacy DMA to continue into its current buffers.
+ *
+ * In the crashdump kernel, this code:
+ * 1. skips disabling the IOMMU's translating of IO Virtual Addresses (IOVA)
+ * 2. leaves the current translations in-place so that legacy DMA will
+ *    continue to use its current buffers,
+ * 3. allocates to the device drivers in the crashdump kernel
+ *    portions of the iova address ranges that are different
+ *    from the iova address ranges that were being used by the old kernel
+ *    at the time of the panic.
+ *
+ */
+
+struct domain_values_entry {
+	struct list_head link;		/* link entries into a list */
+	struct iova_domain iovad;	/* iova's that belong to this domain */
+	struct dma_pte	*pgd;		/* virtual address */
+	int    did;			/* domain id */
+	int    gaw;			/* max guest address width */
+	int    iommu_superpage;		/* Level of superpages supported:
+					   0 == 4KiB (no superpages), 1 == 2MiB,
+					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
+};
+
+
+
+/* ------------------------------------------------------------------------
+ * Prototypes of interface functions
+ * ------------------------------------------------------------------------
+ */
+
+extern int
+intel_iommu_copy_translation_tables(struct dmar_drhd_unit *drhd,
+	struct root_entry **root_old_p, struct root_entry **root_new_p,
+	int g_num_of_iommus);
+
+extern int
+intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu);
+
+extern struct domain_values_entry *
+intel_iommu_did_to_domain_values_entry(int did, struct intel_iommu *iommu);
+
+
+/* ------------------------------------------------------------------------
+ * Utility functions for accessing the iommu Translation Tables
+ * ------------------------------------------------------------------------
+ */
+
+static inline struct context_entry *
+get_context_phys_from_root(struct root_entry *root)
+{
+	return (struct context_entry *)
+		(root_present(root) ? (void *) (root->val & VTD_PAGE_MASK)
+				    : NULL);
+}
+
+static inline int
+context_get_p(struct context_entry *c)    {return((c->lo >> 0) & 0x1); }
+
+static inline int
+context_get_fpdi(struct context_entry *c) {return((c->lo >> 1) & 0x1); }
+
+static inline int
+context_get_t(struct context_entry *c)    {return((c->lo >> 2) & 0x3); }
+
+static inline u64
+context_get_asr(struct context_entry *c)  {return((c->lo >> 12));      }
+
+static inline int
+context_get_aw(struct context_entry *c)   {return((c->hi >> 0) & 0x7); }
+
+static inline int
+context_get_aval(struct context_entry *c) {return((c->hi >> 3) & 0xf); }
+
+static inline int
+context_get_did(struct context_entry *c)  {return((c->hi >> 8) & 0xffff); }
+
+static inline void
+context_put_asr(struct context_entry *c, unsigned long asr)
+{
+	c->lo &= (~VTD_PAGE_MASK);
+	c->lo |= (asr << VTD_PAGE_SHIFT);
+}
+
+#endif	/* CONFIG_CRASH_DUMP */
-- 
Bill Sumner <bill.sumner@hp.com>

