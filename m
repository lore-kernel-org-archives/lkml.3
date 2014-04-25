Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaDYAiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:38:11 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:59665 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaDYAhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:37:50 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com, jerry.hoemann@hp.com
Subject: [PATCH 7/8] iommu/vt-d: Add domain-id functions to intel-iommu-kdump.c
Date: Thu, 24 Apr 2014 18:36:37 -0600
Message-Id: <1398386198-19304-8-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interfaces for when a new domain in the crashdump kernel needs some
values from the panicked kernel's context entries.

Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu-kdump.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/iommu/intel-iommu-kdump.c b/drivers/iommu/intel-iommu-kdump.c
index 4e653e048..f3c777e 100644
--- a/drivers/iommu/intel-iommu-kdump.c
+++ b/drivers/iommu/intel-iommu-kdump.c
@@ -53,6 +53,45 @@ static struct list_head *domain_values_list;
 
 
 /* ========================================================================
+ * Interfaces for when a new domain in the crashdump kernel needs some
+ * values from the panicked kernel's context entries
+ * ------------------------------------------------------------------------
+ */
+
+
+struct domain_values_entry *intel_iommu_did_to_domain_values_entry(int did,
+		struct intel_iommu *iommu)
+{
+	struct domain_values_entry *dve;	/* iterator */
+
+	list_for_each_entry(dve, &domain_values_list[iommu->seq_id], link)
+		if (dve->did == did)
+			return dve;
+	return NULL;
+}
+
+
+/* Mark domain-id's from old kernel as in-use on this iommu so that a new
+ * domain-id is allocated in the case where there is a device in the new kernel
+ * that was not in the old kernel -- and therefore a new domain-id is needed.
+ */
+int intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu)
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
+
+/* ========================================================================
  * Copy iommu translation tables from old kernel into new  kernel.
  * Entry to this set of functions is: intel_iommu_copy_translation_tables()
  * ------------------------------------------------------------------------
-- 
Bill Sumner <bill.sumner@hp.com>

