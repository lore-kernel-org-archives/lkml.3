Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaLVJQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:16:54 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:36788 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaLVJQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:16:51 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>
Cc: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        <billsumnerlinux@gmail.com>, <zhen-hual@hp.com>
Subject: [PATCH 04/10] iommu/vt-d: functions to copy data from old mem
Date: Mon, 22 Dec 2014 17:15:23 +0800
Message-Id: <1419239729-26529-5-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1419239729-26529-1-git-send-email-zhen-hual@hp.com>
References: <1419239729-26529-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some functions to copy the data from old kernel.
These functions are used to copy context tables and page tables.

To avoid calling iounmap between spin_lock_irqsave and spin_unlock_irqrestore,
use a link here, store the pointers , and then use iounmap to free them in
another place.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel-iommu.c | 97 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/intel-iommu.h |  9 +++++
 2 files changed, 106 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c0bebd6..8a7ad72 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -388,6 +388,13 @@ static int intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu);
 
 static int device_to_domain_id(struct intel_iommu *iommu, u8 bus, u8 devfn);
 
+struct iommu_remapped_entry {
+	struct list_head list;
+	void __iomem *mem;
+};
+static LIST_HEAD(__iommu_remapped_mem);
+static DEFINE_MUTEX(__iommu_mem_list_lock);
+
 #endif /* CONFIG_CRASH_DUMP */
 
 /*
@@ -4843,6 +4850,96 @@ static void __init check_tylersburg_isoch(void)
 #ifdef CONFIG_CRASH_DUMP
 
 /*
+ * Copy memory from a physically-addressed area into a virtually-addressed area
+ */
+int __iommu_load_from_oldmem(void *to, unsigned long from, unsigned long size)
+{
+	unsigned long pfn;		/* Page Frame Number */
+	size_t csize = (size_t)size;	/* Num(bytes to copy) */
+	unsigned long offset;		/* Lower 12 bits of to */
+	void __iomem *virt_mem;
+	struct iommu_remapped_entry *mapped;
+
+	pfn = from >> VTD_PAGE_SHIFT;
+	offset = from & (~VTD_PAGE_MASK);
+
+	if (page_is_ram(pfn)) {
+		memcpy(to, pfn_to_kaddr(pfn) + offset, csize);
+	} else{
+
+		mapped = kzalloc(sizeof(struct iommu_remapped_entry),
+				GFP_KERNEL);
+		if (!mapped)
+			return -ENOMEM;
+
+		virt_mem = ioremap_cache((unsigned long)from, size);
+		if (!virt_mem) {
+			kfree(mapped);
+			return -ENOMEM;
+		}
+		memcpy(to, virt_mem, size);
+
+		mutex_lock(&__iommu_mem_list_lock);
+		mapped->mem = virt_mem;
+		list_add_tail(&mapped->list, &__iommu_remapped_mem);
+		mutex_unlock(&__iommu_mem_list_lock);
+	}
+	return size;
+}
+
+/*
+ * Copy memory from a virtually-addressed area into a physically-addressed area
+ */
+int __iommu_save_to_oldmem(unsigned long to, void *from, unsigned long size)
+{
+	unsigned long pfn;		/* Page Frame Number */
+	size_t csize = (size_t)size;	/* Num(bytes to copy) */
+	unsigned long offset;		/* Lower 12 bits of to */
+	void __iomem *virt_mem;
+	struct iommu_remapped_entry *mapped;
+
+	pfn = to >> VTD_PAGE_SHIFT;
+	offset = to & (~VTD_PAGE_MASK);
+
+	if (page_is_ram(pfn)) {
+		memcpy(pfn_to_kaddr(pfn) + offset, from, csize);
+	} else{
+		mapped = kzalloc(sizeof(struct iommu_remapped_entry),
+				GFP_KERNEL);
+		if (!mapped)
+			return -ENOMEM;
+
+		virt_mem = ioremap_cache((unsigned long)to, size);
+		if (!virt_mem) {
+			kfree(mapped);
+			return -ENOMEM;
+		}
+		memcpy(virt_mem, from, size);
+		mutex_lock(&__iommu_mem_list_lock);
+		mapped->mem = virt_mem;
+		list_add_tail(&mapped->list, &__iommu_remapped_mem);
+		mutex_unlock(&__iommu_mem_list_lock);
+	}
+	return size;
+}
+
+/*
+ * Free the mapped memory for ioremap;
+ */
+int __iommu_free_mapped_mem(void)
+{
+	struct iommu_remapped_entry *mem_entry, *tmp;
+
+	mutex_lock(&__iommu_mem_list_lock);
+	list_for_each_entry_safe(mem_entry, tmp, &__iommu_remapped_mem, list) {
+		iounmap(mem_entry->mem);
+		list_del(&mem_entry->list);
+		kfree(mem_entry);
+	}
+	mutex_unlock(&__iommu_mem_list_lock);
+	return 0;
+}
+/*
  * Interfaces for when a new domain in the crashdump kernel needs some
  * values from the panicked kernel's context entries
  *
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index a65208a..8ffa523 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -26,6 +26,7 @@
 #include <linux/iova.h>
 #include <linux/io.h>
 #include <linux/dma_remapping.h>
+#include <linux/crash_dump.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
@@ -368,4 +369,12 @@ extern int dmar_ir_support(void);
 
 extern const struct attribute_group *intel_iommu_groups[];
 
+#ifdef CONFIG_CRASH_DUMP
+extern int __iommu_load_from_oldmem(void *to, unsigned long from,
+					unsigned long size);
+extern int __iommu_save_to_oldmem(unsigned long to, void *from,
+					unsigned long size);
+extern int __iommu_free_mapped_mem(void);
+#endif /* CONFIG_CRASH_DUMP */
+
 #endif
-- 
2.0.0-rc0

