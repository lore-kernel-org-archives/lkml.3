Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbbAGEGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 23:06:21 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:51015 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbbAGEGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 23:06:18 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>
Cc: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        <billsumnerlinux@gmail.com>, <zhen-hual@hp.com>, <rwright@hp.com>
Subject: [PATCH v7 05/10] iommu/vt-d: Add functions to load and save old re
Date: Wed,  7 Jan 2015 12:04:29 +0800
Message-Id: <1420603474-4235-6-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1420603474-4235-1-git-send-email-zhen-hual@hp.com>
References: <1420603474-4235-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to load root entry table from old kernel, and to save updated
root entry table.
Add two member in struct intel_iommu, to store the RTA in old kernel, and
the mapped virt address of it.

We use the old RTA in dump kernel, and when the iommu->root_entry is used as
a cache in kdump kernel, its phys address will not be save to RTA register,
but when its data is changed, we will save the new data to old root entry table.

Li, Zhen-hua:
    The functions and logics.

Takao Indoh:
    Add __iommu_flush_cache.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 drivers/iommu/intel-iommu.c | 53 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/intel-iommu.h |  5 +++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 8a7ad72..f3059b8 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -388,6 +388,10 @@ static int intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu);
 
 static int device_to_domain_id(struct intel_iommu *iommu, u8 bus, u8 devfn);
 
+static void __iommu_load_old_root_entry(struct intel_iommu *iommu);
+
+static void __iommu_update_old_root_entry(struct intel_iommu *iommu, int index);
+
 struct iommu_remapped_entry {
 	struct list_head list;
 	void __iomem *mem;
@@ -4990,4 +4994,53 @@ static int device_to_domain_id(struct intel_iommu *iommu, u8 bus, u8 devfn)
 	return did;
 }
 
+/*
+ * Load the old root entry table to new root entry table.
+ */
+static void __iommu_load_old_root_entry(struct intel_iommu *iommu)
+{
+	if ((!iommu)
+		|| (!iommu->root_entry)
+		|| (!iommu->root_entry_old_virt)
+		|| (!iommu->root_entry_old_phys))
+		return;
+	memcpy(iommu->root_entry, iommu->root_entry_old_virt, PAGE_SIZE);
+
+	__iommu_flush_cache(iommu, iommu->root_entry, PAGE_SIZE);
+}
+
+/*
+ * When the data in new root entry table is changed, this function
+ * must be called to save the updated data to old root entry table.
+ */
+static void __iommu_update_old_root_entry(struct intel_iommu *iommu, int index)
+{
+	u8 start;
+	unsigned long size;
+	void __iomem *to;
+	void *from;
+
+	if ((!iommu)
+		|| (!iommu->root_entry)
+		|| (!iommu->root_entry_old_virt)
+		|| (!iommu->root_entry_old_phys))
+		return;
+
+	if (index < -1 || index >= ROOT_ENTRY_NR)
+		return;
+
+	if (index == -1) {
+		start = 0;
+		size = ROOT_ENTRY_NR * sizeof(struct root_entry);
+	} else {
+		start = index * sizeof(struct root_entry);
+		size = sizeof(struct root_entry);
+	}
+	to = iommu->root_entry_old_virt;
+	from = iommu->root_entry;
+	memcpy(to + start, from + start, size);
+
+	__iommu_flush_cache(iommu, to + start, size);
+}
+
 #endif /* CONFIG_CRASH_DUMP */
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 8ffa523..8e29b97 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -329,6 +329,11 @@ struct intel_iommu {
 	spinlock_t	lock; /* protect context, domain ids */
 	struct root_entry *root_entry; /* virtual address */
 
+#ifdef CONFIG_CRASH_DUMP
+	void __iomem *root_entry_old_virt; /* mapped from old root entry */
+	unsigned long root_entry_old_phys; /* root entry in old kernel */
+#endif
+
 	struct iommu_flush flush;
 #endif
 	struct q_inval  *qi;            /* Queued invalidation info */
-- 
2.0.0-rc0

