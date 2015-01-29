Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbbA2JYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:24:38 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57982 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761428AbbA2JWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:41 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 23/24] vfio/spapr: Enable multiple groups in a container
Date: Thu, 29 Jan 2015 20:22:04 +1100
Message-Id: <1422523325-1389-24-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0033-0000-0000-000000FE0B77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 243 +++++++++++++++++++++++-------------
 1 file changed, 155 insertions(+), 88 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index d0987ae..8bcafb7 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -84,9 +84,15 @@ static void decrement_locked_vm(long npages)
  */
 struct tce_container {
 	struct mutex lock;
-	struct iommu_group *grp;
 	bool enabled;
 	struct list_head mem_list;
+	struct iommu_table tables[POWERPC_IOMMU_MAX_TABLES];
+	struct list_head group_list;
+};
+
+struct tce_iommu_group {
+	struct list_head next;
+	struct iommu_group *grp;
 };
 
 struct tce_memory {
@@ -265,17 +271,21 @@ static bool tce_check_page_size(struct page *page, unsigned page_shift)
 	return false;
 }
 
+static inline bool tce_groups_attached(struct tce_container *container)
+{
+	return !list_empty(&container->group_list);
+}
+
 static struct iommu_table *spapr_tce_find_table(
 		struct tce_container *container,
 		phys_addr_t ioba)
 {
 	long i;
 	struct iommu_table *ret = NULL;
-	struct powerpc_iommu *iommu = iommu_group_get_iommudata(container->grp);
 
 	mutex_lock(&container->lock);
 	for (i = 0; i < POWERPC_IOMMU_MAX_TABLES; ++i) {
-		struct iommu_table *tbl = &iommu->tables[i];
+		struct iommu_table *tbl = &container->tables[i];
 		unsigned long entry = ioba >> tbl->it_page_shift;
 		unsigned long start = tbl->it_offset;
 		unsigned long end = start + tbl->it_size;
@@ -290,13 +300,31 @@ static struct iommu_table *spapr_tce_find_table(
 	return ret;
 }
 
+static unsigned long tce_default_winsize(struct tce_container *container)
+{
+	struct tce_iommu_group *tcegrp;
+	struct powerpc_iommu *iommu;
+
+	if (!tce_groups_attached(container))
+		return 0;
+
+	tcegrp = list_first_entry(&container->group_list,
+			struct tce_iommu_group, next);
+	if (!tcegrp)
+		return 0;
+
+	iommu = iommu_group_get_iommudata(tcegrp->grp);
+	if (!iommu)
+		return 0;
+
+	return iommu->tce32_size;
+}
+
 static int tce_iommu_enable(struct tce_container *container)
 {
 	int ret = 0;
-	struct powerpc_iommu *iommu;
-	struct iommu_table *tbl;
 
-	if (!container->grp)
+	if (!tce_groups_attached(container))
 		return -ENXIO;
 
 	if (container->enabled)
@@ -328,12 +356,8 @@ static int tce_iommu_enable(struct tce_container *container)
 	 * KVM agnostic.
 	 */
 	if (!tce_preregistered(container)) {
-		iommu = iommu_group_get_iommudata(container->grp);
-		if (!iommu)
-			return -EFAULT;
-
-		tbl = &iommu->tables[0];
-		ret = try_increment_locked_vm(IOMMU_TABLE_PAGES(tbl));
+		ret = try_increment_locked_vm(
+				tce_default_winsize(container) >> PAGE_SHIFT);
 		if (ret)
 			return ret;
 	}
@@ -343,27 +367,23 @@ static int tce_iommu_enable(struct tce_container *container)
 	return ret;
 }
 
+static int tce_iommu_clear(struct tce_container *container,
+		struct iommu_table *tbl,
+		unsigned long entry, unsigned long pages);
+
 static void tce_iommu_disable(struct tce_container *container)
 {
-	struct powerpc_iommu *iommu;
-	struct iommu_table *tbl;
-
 	if (!container->enabled)
 		return;
 
 	container->enabled = false;
 
-	if (!container->grp || !current->mm)
+	if (!current->mm)
 		return;
 
-	if (!tce_preregistered(container)) {
-		iommu = iommu_group_get_iommudata(container->grp);
-		if (!iommu)
-			return;
-
-		tbl = &iommu->tables[0];
-		decrement_locked_vm(IOMMU_TABLE_PAGES(tbl));
-	}
+	if (!tce_preregistered(container))
+		decrement_locked_vm(
+				tce_default_winsize(container) >> PAGE_SHIFT);
 }
 
 static void *tce_iommu_open(unsigned long arg)
@@ -381,20 +401,44 @@ static void *tce_iommu_open(unsigned long arg)
 
 	mutex_init(&container->lock);
 	INIT_LIST_HEAD_RCU(&container->mem_list);
+	INIT_LIST_HEAD_RCU(&container->group_list);
 
 	return container;
 }
 
 static void tce_iommu_release(void *iommu_data)
 {
+	int i;
+	struct powerpc_iommu *iommu;
+	struct tce_iommu_group *tcegrp;
 	struct tce_container *container = iommu_data;
 	struct tce_memory *mem, *memtmp;
+	struct powerpc_iommu_ops *iommuops = NULL;
 
-	WARN_ON(container->grp);
 	tce_iommu_disable(container);
 
-	if (container->grp)
-		tce_iommu_detach_group(iommu_data, container->grp);
+	while (tce_groups_attached(container)) {
+		tcegrp = list_first_entry(&container->group_list,
+				struct tce_iommu_group, next);
+		iommu = iommu_group_get_iommudata(tcegrp->grp);
+		iommuops = iommu->ops;
+		tce_iommu_detach_group(iommu_data, tcegrp->grp);
+	}
+
+	/* Free tables */
+	if (iommuops) {
+		for (i = 0; i < POWERPC_IOMMU_MAX_TABLES; ++i) {
+			struct iommu_table *tbl = &container->tables[i];
+
+			tce_iommu_clear(container, tbl,
+					tbl->it_offset, tbl->it_size);
+
+			if (!tce_preregistered(container))
+				decrement_locked_vm(IOMMU_TABLE_PAGES(tbl));
+
+			iommuops->free_table(tbl);
+		}
+	}
 
 	list_for_each_entry_safe(mem, memtmp, &container->mem_list, next)
 		tce_do_unregister_pages(container, mem);
@@ -568,16 +612,17 @@ static long tce_iommu_ioctl(void *iommu_data,
 
 	case VFIO_IOMMU_SPAPR_TCE_GET_INFO: {
 		struct vfio_iommu_spapr_tce_info info;
-		struct iommu_table *tbl;
+		struct tce_iommu_group *tcegrp;
 		struct powerpc_iommu *iommu;
 
-		if (WARN_ON(!container->grp))
+		if (!tce_groups_attached(container))
 			return -ENXIO;
 
-		iommu = iommu_group_get_iommudata(container->grp);
+		tcegrp = list_first_entry(&container->group_list,
+				struct tce_iommu_group, next);
+		iommu = iommu_group_get_iommudata(tcegrp->grp);
 
-		tbl = &iommu->tables[0];
-		if (WARN_ON_ONCE(!tbl))
+		if (!iommu)
 			return -ENXIO;
 
 		minsz = offsetofend(struct vfio_iommu_spapr_tce_info,
@@ -589,9 +634,8 @@ static long tce_iommu_ioctl(void *iommu_data,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		info.dma32_window_start = tbl->it_offset << tbl->it_page_shift;
-		info.dma32_window_size = tbl->it_size << tbl->it_page_shift;
-		info.flags = 0;
+		info.dma32_window_start = iommu->tce32_start;
+		info.dma32_window_size = iommu->tce32_size;
 
 		if (copy_to_user((void __user *)arg, &info, minsz))
 			return -EFAULT;
@@ -603,9 +647,8 @@ static long tce_iommu_ioctl(void *iommu_data,
 		struct iommu_table *tbl;
 		unsigned long tce;
 
-		if (WARN_ON(!container->grp ||
-				!iommu_group_get_iommudata(container->grp)))
-			return -ENXIO;
+		if (!container->enabled)
+			return -EPERM;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
@@ -655,10 +698,6 @@ static long tce_iommu_ioctl(void *iommu_data,
 		struct vfio_iommu_type1_dma_unmap param;
 		struct iommu_table *tbl;
 
-		if (WARN_ON(!container->grp ||
-				!iommu_group_get_iommudata(container->grp)))
-			return -ENXIO;
-
 		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap,
 				size);
 
@@ -747,12 +786,20 @@ static long tce_iommu_ioctl(void *iommu_data,
 		tce_iommu_disable(container);
 		mutex_unlock(&container->lock);
 		return 0;
-	case VFIO_EEH_PE_OP:
-		if (!container->grp)
-			return -ENODEV;
 
-		return vfio_spapr_iommu_eeh_ioctl(container->grp,
-						  cmd, arg);
+	case VFIO_EEH_PE_OP: {
+		struct tce_iommu_group *tcegrp;
+
+		ret = 0;
+		list_for_each_entry(tcegrp, &container->group_list, next) {
+			ret = vfio_spapr_iommu_eeh_ioctl(tcegrp->grp,
+					cmd, arg);
+			if (ret)
+				return ret;
+		}
+		return ret;
+	}
+
 	}
 
 	return -ENOTTY;
@@ -761,40 +808,63 @@ static long tce_iommu_ioctl(void *iommu_data,
 static int tce_iommu_attach_group(void *iommu_data,
 		struct iommu_group *iommu_group)
 {
-	int ret = 0;
+	int ret = 0, i;
 	struct tce_container *container = iommu_data;
-	struct powerpc_iommu *iommu;
+	struct powerpc_iommu *iommu = iommu_group_get_iommudata(iommu_group);
+	struct tce_iommu_group *tcegrp;
 
 	mutex_lock(&container->lock);
 
 	/* pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
 			iommu_group_id(iommu_group), iommu_group); */
-	if (container->grp) {
-		pr_warn("tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
-				iommu_group_id(container->grp),
-				iommu_group_id(iommu_group));
-		ret = -EBUSY;
-	} else if (container->enabled) {
-		pr_err("tce_vfio: attaching group #%u to enabled container\n",
-				iommu_group_id(iommu_group));
-		ret = -EBUSY;
+
+	list_for_each_entry(tcegrp, &container->group_list, next) {
+		struct powerpc_iommu *iommutmp;
+
+		if (tcegrp->grp == iommu_group) {
+			pr_warn("tce_vfio: Group %d is already attached\n",
+					iommu_group_id(iommu_group));
+			ret = -EBUSY;
+			goto unlock_exit;
+		}
+		iommutmp = iommu_group_get_iommudata(tcegrp->grp);
+		if (iommutmp->ops != iommu->ops) {
+			pr_warn("tce_vfio: Group %d is incompatible with group %d\n",
+					iommu_group_id(iommu_group),
+					iommu_group_id(tcegrp->grp));
+			ret = -EBUSY;
+			goto unlock_exit;
+		}
+	}
+
+	/*
+	 * Disable iommu bypass, otherwise the user can DMA to all of
+	 * our physical memory via the bypass window instead of just
+	 * the pages that has been explicitly mapped into the iommu
+	 */
+	if (iommu->ops && iommu->ops->set_ownership) {
+		iommu->ops->set_ownership(iommu, true);
 	} else {
-		iommu = iommu_group_get_iommudata(iommu_group);
-		if (WARN_ON_ONCE(!iommu))
-			return -ENXIO;
-		/*
-		 * Disable iommu bypass, otherwise the user can DMA to all of
-		 * our physical memory via the bypass window instead of just
-		 * the pages that has been explicitly mapped into the iommu
-		 */
-		if (iommu->ops && iommu->ops->set_ownership) {
-			iommu->ops->set_ownership(iommu, true);
-			container->grp = iommu_group;
-		} else {
-			return -ENODEV;
-		}
+		ret = -ENODEV;
+		goto unlock_exit;
 	}
 
+	tcegrp = kzalloc(sizeof(*tcegrp), GFP_KERNEL);
+	tcegrp->grp = iommu_group;
+	list_add(&tcegrp->next, &container->group_list);
+	for (i = 0; i < POWERPC_IOMMU_MAX_TABLES; ++i) {
+		struct iommu_table *tbl = &container->tables[i];
+
+		if (!tbl->it_size)
+			continue;
+
+		/* Set the default window to a new group */
+		ret = iommu->ops->set_window(iommu, i, tbl);
+		if (ret)
+			goto unlock_exit;
+	}
+
+unlock_exit:
 	mutex_unlock(&container->lock);
 
 	return ret;
@@ -805,33 +875,30 @@ static void tce_iommu_detach_group(void *iommu_data,
 {
 	struct tce_container *container = iommu_data;
 	struct powerpc_iommu *iommu;
+	struct tce_iommu_group *tcegrp, *tcegrptmp;
+	long i;
 
 	mutex_lock(&container->lock);
-	if (iommu_group != container->grp) {
-		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
-				iommu_group_id(iommu_group),
-				iommu_group_id(container->grp));
-	} else {
-		if (container->enabled) {
-			pr_warn("tce_vfio: detaching group #%u from enabled container, forcing disable\n",
-					iommu_group_id(container->grp));
-			tce_iommu_disable(container);
-		}
 
-		/* pr_debug("tce_vfio: detaching group #%u from iommu %p\n",
-				iommu_group_id(iommu_group), iommu_group); */
-		container->grp = NULL;
+	/* Detach windows from IOMMUs */
+	list_for_each_entry_safe(tcegrp, tcegrptmp, &container->group_list,
+			next) {
+		if (tcegrp->grp != iommu_group)
+			continue;
 
+		list_del(&tcegrp->next);
 		iommu = iommu_group_get_iommudata(iommu_group);
 		BUG_ON(!iommu);
 
-		tce_iommu_clear(container, &iommu->tables[0],
-				iommu->tables[0].it_offset,
-				iommu->tables[0].it_size);
+		for (i = 0; i < POWERPC_IOMMU_MAX_TABLES; ++i)
+			iommu->ops->unset_window(iommu, i);
 
 		/* Kernel owns the device now, we can restore bypass */
 		if (iommu->ops && iommu->ops->set_ownership)
 			iommu->ops->set_ownership(iommu, false);
+
+		kfree(tcegrp);
+		break;
 	}
 	mutex_unlock(&container->lock);
 }
-- 
2.0.0

