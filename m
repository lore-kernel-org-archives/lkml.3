Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaJUIFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:05:14 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:7265 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaJUIFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:05:01 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>
Cc: <iommu@lists.linux-foundation.org>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 2/5] iommu/vt-d: Items required for kdump
Date: Tue, 21 Oct 2014 16:04:16 +0800
Message-Id: <1413878659-1383-3-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add structure type domain_values_entry used for kdump;
Add context functions needed for kdump.

Bill Sumner:
    Original version;

Li, Zhenhua:
    Changed the name of new functions, make them consistent with current
    context get/set functions.

Signed-off-by: Bill Sumner
Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel-iommu.c | 69 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 1c7350d..99fe408 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -207,6 +207,15 @@ get_context_addr_from_root(struct root_entry *root)
 		NULL);
 }
 
+static inline struct context_entry *
+get_context_phys_from_root(struct root_entry *root)
+{
+	return (struct context_entry *)
+		(root_present(root) ? (void *) (root->val & VTD_PAGE_MASK)
+		: NULL);
+}
+
+
 /*
  * low 64 bits:
  * 0: present
@@ -227,6 +236,32 @@ static inline bool context_present(struct context_entry *context)
 {
 	return (context->lo & 1);
 }
+
+static inline int context_fault_enable(struct context_entry *c)
+{
+	return((c->lo >> 1) & 0x1);
+}
+
+static inline int context_translation_type(struct context_entry *c)
+{
+	return((c->lo >> 2) & 0x3);
+}
+
+static inline u64 context_address_root(struct context_entry *c)
+{
+	return((c->lo >> VTD_PAGE_SHIFT));
+}
+
+static inline int context_address_width(struct context_entry *c)
+{
+	return((c->hi >> 0) & 0x7);
+}
+
+static inline int context_domain_id(struct context_entry *c)
+{
+	return((c->hi >> 8) & 0xffff);
+}
+
 static inline void context_set_present(struct context_entry *context)
 {
 	context->lo |= 1;
@@ -311,6 +346,40 @@ static inline int first_pte_in_page(struct dma_pte *pte)
 	return !((unsigned long)pte & ~VTD_PAGE_MASK);
 }
 
+
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
+#endif /* CONFIG_CRASH_DUMP */
+
 /*
  * This domain is a statically identity mapping domain.
  *	1. This domain creats a static 1:1 mapping to all usable memory.
-- 
2.0.0-rc0

