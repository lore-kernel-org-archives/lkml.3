Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbaDVHH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:07:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:2506 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaDVHHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:07:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,902,1389772800"; 
   d="scan'208";a="517082112"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part3 V1 18/22] iommu/vt-d: update proximity information when a new node with memory available
Date: Tue, 22 Apr 2014 15:07:29 +0800
Message-Id: <1398150453-28141-19-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398150453-28141-1-git-send-email-jiang.liu@linux.intel.com>
References: <1398150453-28141-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If node associated with a DMAR unit has no memory available, it uses -1
as default NUMA node id. So when memory hot-addition adds new memory to
an empty NUMA node, we should update the NUMA node id associated with
the DMAR unit. This will help to optomize memory allocation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c        |   50 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/intel-iommu.h |    1 +
 2 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 7a7383858c34..d607691a6a80 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -38,6 +38,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/memory.h>
 #include <asm/irq_remapping.h>
 #include <asm/iommu_table.h>
 
@@ -444,6 +445,7 @@ static int dmar_parse_one_rhsa(struct acpi_dmar_header *header, void *arg)
 			if (!node_online(node))
 				node = -1;
 			drhd->iommu->node = node;
+			drhd->iommu->proximity_domain = rhsa->proximity_domain;
 			return 0;
 		}
 	}
@@ -458,8 +460,48 @@ static int dmar_parse_one_rhsa(struct acpi_dmar_header *header, void *arg)
 
 	return 0;
 }
+
+static int dmar_memory_notifier(struct notifier_block *nb,
+				unsigned long val, void *v)
+{
+	struct memory_notify *mhp = v;
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	int nid;
+
+	if (val != MEM_ONLINE)
+		return NOTIFY_OK;
+
+	if (mhp->status_change_nid < 0)
+		return NOTIFY_OK;
+
+	down_read(&dmar_global_lock);
+	for_each_iommu(iommu, drhd) {
+		if (iommu->node != -1)
+			continue;
+		nid = acpi_map_pxm_to_node(iommu->proximity_domain);
+		if (nid == mhp->status_change_nid)
+			iommu->node = nid;
+	}
+	up_read(&dmar_global_lock);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block dmar_memory_nb = {
+	.notifier_call = dmar_memory_notifier,
+};
+
+static void dmar_register_memory_notifier(void)
+{
+	register_memory_notifier(&dmar_memory_nb);
+}
 #else
 #define	dmar_parse_one_rhsa		dmar_res_noop
+
+static void dmar_register_memory_notifier(void)
+{
+}
 #endif
 
 static void __init
@@ -1715,12 +1757,14 @@ static inline bool dmar_in_use(void)
 	return irq_remapping_enabled || intel_iommu_enabled;
 }
 
-static int __init dmar_free_unused_resources(void)
+static int __init dmar_late_init(void)
 {
 	struct dmar_drhd_unit *dmaru, *dmaru_n;
 
-	if (dmar_in_use())
+	if (dmar_in_use()) {
+		dmar_register_memory_notifier();
 		return 0;
+	}
 
 	if (dmar_dev_scope_status != 1 && !list_empty(&dmar_drhd_units))
 		bus_unregister_notifier(&pci_bus_type, &dmar_pci_bus_nb);
@@ -1735,7 +1779,7 @@ static int __init dmar_free_unused_resources(void)
 	return 0;
 }
 
-late_initcall(dmar_free_unused_resources);
+late_initcall(dmar_late_init);
 IOMMU_INIT_POST(detect_intel_iommu);
 
 /*
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 0a2da5188217..eea52ccdbd8e 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -337,6 +337,7 @@ struct intel_iommu {
 	struct ir_table *ir_table;	/* Interrupt remapping info */
 #endif
 	int		node;
+	int		proximity_domain;
 };
 
 static inline void __iommu_flush_cache(
-- 
1.7.10.4

