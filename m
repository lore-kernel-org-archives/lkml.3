Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3LCTot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:44:49 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37905 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LCTmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:42:45 -0500
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com
Subject: [PATCH 3/6] Crashdump-Accepting-Active-IOMMU-Domain-Interfaces
Date: Tue,  3 Dec 2013 12:41:31 -0700
Message-Id: <1386099694-4190-4-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1386099694-4190-1-git-send-email-bill.sumner@hp.com>
References: <Crashdump-Accepting-Active-IOMMU>
 <1386099694-4190-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 266 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 266 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index b68b962..ee68f42 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4527,3 +4527,269 @@ static int oldcopy(void *to, void *from, int size)
 	return (int) ret;
 }
 #endif /* CONFIG_CRASH_DUMP */
+#ifdef CONFIG_CRASH_DUMP
+
+
+
+/* ------------------------------------------------------------------------
+ * Interfaces for when a new domain in the new kernel needs some values
+ * from the old kernel's context entries
+ * ------------------------------------------------------------------------
+ */
+
+/* List to hold domain values found during the copy operation */
+static struct list_head *device_domain_values_list;
+
+
+/* Utility function for interface functions that follow. */
+static int
+context_get_entry(struct context_entry *context_addr,
+			struct intel_iommu *iommu, u32 bus, int devfn)
+{
+	unsigned long long q;		/* quadword scratch */
+	struct root_entry *root_phys;	/* Phys adr (root table entry) */
+	struct root_entry  root_temp;	/* Local copy of root_entry */
+	struct context_entry *context_phys;	/* Phys adr */
+
+	if (pr_dbg.domain_get)
+		pr_debug("ENTER %s B:D:F=%2.2x:%2.2x:%1.1x &context_entry:0x%llx &intel_iommu:0x%llx\n",
+			__func__, bus, devfn>>3, devfn&7,
+			(u64)context_addr, (u64)iommu);
+
+	if (bus > 255)				/* Sanity check */
+		return -5;
+	if (devfn > 255 || devfn < 0)		/* Sanity check */
+		return -6;
+
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_debug("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
+	if (!q)
+		return -1;
+
+	root_phys = (struct root_entry *) q;	/* Adr(base of vector) */
+	root_phys += bus;			/* Adr(entry we want) */
+
+	oldcopy(&root_temp, root_phys, sizeof(root_temp));
+
+	pr_debug("root_temp.val:0x%llx .rsvd1:0x%llx root_phys:0x%llx\n",
+		root_temp.val, root_temp.rsvd1, (u64)root_phys);
+
+	if (!root_present(&root_temp))
+		return -2;
+
+	pr_debug("B:D:F=%2.2x:%2.2x:%1.1x root_temp.val: %llx .rsvd1: %llx\n",
+		bus, devfn >> 3, devfn & 7, root_temp.val, root_temp.rsvd1);
+
+	if (root_temp.rsvd1)			/* If (root_entry is bad) */
+		return -3;
+
+	context_phys = get_context_phys_from_root(&root_temp);
+	if (!context_phys)
+		return -4;
+
+	context_phys += devfn;			/* Adr(context_entry we want) */
+
+
+	oldcopy(context_addr, context_phys, sizeof(*context_addr));
+
+	if (pr_dbg.domain_get)
+		pr_debug("LEAVE %s returning: phys:0x%12.12llx hi:0x%16.16llx lo:0x%16.16llx\n",
+			__func__, (u64) context_phys,
+			context_addr->hi, context_addr->lo);
+	return 0;
+}
+
+
+/* Get address_width of iova for a device from old kernel (if device existed) */
+static int
+domain_get_gaw_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev)
+{
+	int ret;
+	struct context_entry context_temp;
+
+	if (pr_dbg.domain_get)
+		pr_debug("ENTER %s B:D:F=%2.2x:%2.2x:%1.1x iommu:%d\n",
+			__func__, pdev->bus->number,
+			pdev->devfn >> 3, pdev->devfn & 7,
+			iommu->seq_id);
+
+	ret = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (ret < 0)
+		return ret;
+
+	return (int) agaw_to_width(context_get_aw(&context_temp));
+}
+
+
+/* Get domain_id for a device from old kernel (if device existed) */
+static int
+domain_get_did_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev)
+{
+	int ret;
+	struct context_entry context_temp;
+
+	if (pr_dbg.domain_get)
+		pr_debug("ENTER %s B:D:F=%2.2x:%2.2x:%1.1x iommu:%d\n",
+			__func__, pdev->bus->number,
+			pdev->devfn >> 3, pdev->devfn & 7,
+			iommu->seq_id);
+
+	ret = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (ret < 0)
+		return ret;
+
+	return (int) context_get_did(&context_temp);
+}
+
+
+/* Get adr(top page_table) for a device from old kernel (if device exists) */
+static u64
+domain_get_pgd_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev)
+{
+	int ret;
+	struct context_entry context_temp;
+	u64 phys;
+	u64 virt;
+
+	if (pr_dbg.domain_get)
+		pr_debug("ENTER %s B:D:F=%2.2x:%2.2x:%1.1x iommu:%d\n",
+			__func__, pdev->bus->number,
+			pdev->devfn >> 3, pdev->devfn & 7,
+			iommu->seq_id);
+
+	ret = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (ret < 0)
+		return 0;
+	if (!context_get_p(&context_temp))
+		return 0;
+
+	phys = context_get_asr(&context_temp) << VTD_PAGE_SHIFT;
+	if (pr_dbg.domain_get)
+		pr_debug("%s, phys: 0x%16.16llx\n", __func__, (u64) phys);
+
+	if (!phys)
+		return 0;
+
+	virt = (u64) phys_to_virt(phys);
+	if (pr_dbg.domain_get)
+		pr_debug("%s, virt: 0x%16.16llx\n", __func__, (u64) virt);
+
+	return virt;
+}
+
+
+/* Mark IOVAs that are in-use at time of panic by a device of the old kernel.
+ * Mark IOVAs in the domain for that device in the new kernel
+ * so that all new requests from the device driver for an IOVA will avoid
+ * re-using any IOVA that was in-use by the old kernel.
+ */
+static void
+domain_get_ranges_from_old_kernel(struct dmar_domain *domain,
+				  struct intel_iommu *iommu,
+				  struct pci_dev *pdev)
+{
+	u32 bus = pdev->bus->number;
+	int devfn = pdev->devfn;
+	struct device_domain_info *i = NULL;    /* iterator for foreach */
+
+	pr_debug("ENTER %s, iommu=%d, B:D:F=%2.2x:%2.2x:%1.1x\n",
+			__func__, iommu->seq_id,
+			bus, devfn >> 3, devfn & 0x3);
+
+	list_for_each_entry(i, &device_domain_values_list[iommu->seq_id],
+				global) {
+		if (i->bus == bus && i->devfn == devfn) {
+			if (i->domain == NULL) {
+				pr_err("ERROR %s, iommu=%d, B:D:F=%2.2x:%2.2x:%1.1x\n",
+					__func__, iommu->seq_id,
+					bus, devfn >> 3, devfn & 0x3);
+
+				pr_err("FOUND B:D:F=%2.2x:%2.2x:%1.1x INFO domain-pointer is NULL\n",
+					bus, devfn >> 3, devfn & 0x3);
+				break;
+			}
+			pr_debug("FOUND B:D:F=%2.2x:%2.2x:%1.1x did:%4.4x\n",
+				bus, devfn >> 3, devfn & 0x3, i->domain->id);
+
+			copy_reserved_iova(&i->domain->iovad, &domain->iovad);
+			break;
+		}
+	}
+
+	pr_debug("LEAVE %s\n", __func__);
+}
+
+
+/* Mark domain-id's from old kernel as in-use on this iommu so that a new
+ * domain-id is allocated in the case where there is a device in the new kernel
+ * that was not in the old kernel -- and therefore a new domain-id is needed.
+ */
+static int intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu)
+{
+	unsigned long long q;		/* quadword scratch */
+	struct root_entry *root_phys;	/* Phys(in old kernel) */
+	struct root_entry *root_temp;	/* Virt(Local copy) */
+	struct root_entry *re;		/* Loop index */
+	struct context_entry *context_phys;	/* Phys(in old kernel) */
+	struct context_entry *context_temp;	/* Virt(Local copy) */
+	struct context_entry *ce;	/* Loop index */
+	int did;			/* Each domain-id found */
+	u32 bus;			/* Index into root-entry-table */
+	u32 devfn;			/* Index into context-entry-table */
+
+	pr_debug("ENTER %s iommu:%d\n", __func__, iommu->seq_id);
+
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_debug("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
+	if (!q)
+		return -ENOMEM;
+
+	root_phys = (void *)q;
+	root_temp = (struct root_entry *)alloc_pgtable_page(iommu->node);
+	if (!root_temp)
+		return -ENOMEM;
+	oldcopy(root_temp, root_phys, PAGE_SIZE);
+
+	context_temp = (struct context_entry *)alloc_pgtable_page(iommu->node);
+	if (!context_temp) {
+		free_pgtable_page(root_temp);
+		return -ENOMEM;
+	}
+
+	for (bus = 0, re = root_temp; bus < 256; bus += 1, re += 1) {
+
+		if (!root_present(re))
+			continue;
+
+		pr_debug("ROOT B:%2.2x val: %16.16llx rsvd1: %16.16llx\n",
+			bus, re->val, re->rsvd1);
+
+		if (re->rsvd1)			/* If (root_entry is bad) */
+			continue;
+
+		context_phys = get_context_phys_from_root(re);
+		if (!context_phys)
+			continue;
+
+		oldcopy(context_temp, context_phys, PAGE_SIZE);
+
+		for (devfn = 0, ce = context_temp; devfn < 512; devfn++, ce++) {
+			if (!context_get_p(ce))
+				continue;
+
+			did = context_get_did(ce);
+			set_bit(did, iommu->domain_ids);
+			pr_debug("DID B:D:F:%2.2x:%2.2x:%1.1x did:%d(0x%4.4x)\n",
+				bus, devfn >> 3, devfn & 0x7, did, did);
+		}
+
+	}
+	free_pgtable_page(root_temp);
+	free_pgtable_page(context_temp);
+	pr_debug("LEAVE %s iommu:%d\n", __func__, iommu->seq_id);
+	return 0;
+}
+#endif /* CONFIG_CRASH_DUMP */
-- 
Bill Sumner <bill.sumner@hp.com>

