Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaJUIFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:05:31 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:11300 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaJUIFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:05:13 -0400
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
Subject: [PATCH 4/5] iommu/vt-d: Add domain-id functions
Date: Tue, 21 Oct 2014 16:04:18 +0800
Message-Id: <1413878659-1383-5-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interfaces for when a new domain in the crashdump kernel needs some
values from the panicked kernel's context entries.

Signed-off-by: Bill Sumner 
---
 drivers/iommu/intel-iommu.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 73afed4..bde8f22 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -348,6 +348,7 @@ static inline int first_pte_in_page(struct dma_pte *pte)
 
 
 #ifdef CONFIG_CRASH_DUMP
+
 /*
  * Fix Crashdump failure caused by leftover DMA through a hardware IOMMU
  *
@@ -437,6 +438,16 @@ static int intel_iommu_copy_translation_tables(struct dmar_drhd_unit *drhd,
 		struct root_entry **root_new_virt_p,
 		int g_num_of_iommus);
 
+static struct domain_values_entry *intel_iommu_did_to_domain_values_entry(
+		int did, struct intel_iommu *iommu);
+
+static int intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu);
+
+static struct domain_values_entry *intel_iommu_did_to_domain_values_entry(
+		int did, struct intel_iommu *iommu);
+
+static int intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu);
+
 #endif /* CONFIG_CRASH_DUMP */
 
 /*
@@ -5230,4 +5241,39 @@ static int intel_iommu_copy_translation_tables(struct dmar_drhd_unit *drhd,
 	return 0;
 }
 
+/*
+ * Interfaces for when a new domain in the crashdump kernel needs some
+ * values from the panicked kernel's context entries
+ *
+ */
+static struct domain_values_entry *intel_iommu_did_to_domain_values_entry(
+		int did, struct intel_iommu *iommu)
+{
+	struct domain_values_entry *dve;	/* iterator */
+
+	list_for_each_entry(dve, &domain_values_list[iommu->seq_id], link)
+		if (dve->did == did)
+			return dve;
+	return NULL;
+}
+
+/* Mark domain-id's from old kernel as in-use on this iommu so that a new
+ * domain-id is allocated in the case where there is a device in the new kernel
+ * that was not in the old kernel -- and therefore a new domain-id is needed.
+ */
+static int intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu)
+{
+	struct domain_values_entry *dve;	/* iterator */
+
+	pr_info("IOMMU:%d Domain ids from panicked kernel:\n", iommu->seq_id);
+
+	list_for_each_entry(dve, &domain_values_list[iommu->seq_id], link) {
+		set_bit(dve->did, iommu->domain_ids);
+		pr_info("DID did:%d(0x%4.4x)\n", dve->did, dve->did);
+	}
+
+	pr_info("----------------------------------------\n");
+	return 0;
+}
+
 #endif /* CONFIG_CRASH_DUMP */
-- 
2.0.0-rc0

