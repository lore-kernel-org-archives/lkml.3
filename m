Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645AbbA2J1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:27:17 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37604 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761335AbbA2JWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:37 -0500
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
Subject: [PATCH v3 14/24] vfio: powerpc/spapr: Register memory
Date: Thu, 29 Jan 2015 20:21:55 +1100
Message-Id: <1422523325-1389-15-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0013-0000-0000-000000BF16CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing implementation accounts the whole DMA window in
the locked_vm counter which is going to be even worse with multiple
containers and huge DMA windows.

This introduces 2 ioctls to register/unregister DMA memory which
receive user space address and size of the memory region which
needs to be pinned/unpinned and counted in locked_vm.

If any memory region was registered, all subsequent DMA map requests
should address already pinned memory. If no memory was registered,
then the amount of memory required for a single default memory will be
accounted when the container is enabled and every map/unmap will pin/unpin
a page.

Dynamic DMA window and in-kernel acceleration will require memory to
be registered in order to work.

The accounting is done per VFIO container. When the support of
multiple groups per container is added, we will have accurate locked_vm
accounting.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 333 ++++++++++++++++++++++++++++++++----
 include/uapi/linux/vfio.h           |  29 ++++
 2 files changed, 331 insertions(+), 31 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 8256275..d0987ae 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -86,8 +86,169 @@ struct tce_container {
 	struct mutex lock;
 	struct iommu_group *grp;
 	bool enabled;
+	struct list_head mem_list;
 };
 
+struct tce_memory {
+	struct list_head next;
+	struct rcu_head rcu;
+	__u64 vaddr;
+	__u64 size;
+	__u64 pfns[];
+};
+
+static void tce_unpin_pages(struct tce_container *container,
+		struct tce_memory *mem, __u64 vaddr, __u64 size)
+{
+	__u64 off;
+	struct page *page = NULL;
+
+
+	for (off = 0; off < size; off += PAGE_SIZE) {
+		if (!mem->pfns[off >> PAGE_SHIFT])
+			continue;
+
+		page = pfn_to_page(mem->pfns[off >> PAGE_SHIFT]);
+		if (!page)
+			continue;
+
+		put_page(page);
+		mem->pfns[off >> PAGE_SHIFT] = 0;
+	}
+}
+
+static void release_tce_memory(struct rcu_head *head)
+{
+	struct tce_memory *mem = container_of(head, struct tce_memory, rcu);
+
+	kfree(mem);
+}
+
+static void tce_do_unregister_pages(struct tce_container *container,
+		struct tce_memory *mem)
+{
+	tce_unpin_pages(container, mem, mem->vaddr, mem->size);
+	decrement_locked_vm(mem->size);
+	list_del_rcu(&mem->next);
+	call_rcu_sched(&mem->rcu, release_tce_memory);
+}
+
+static long tce_unregister_pages(struct tce_container *container,
+		__u64 vaddr, __u64 size)
+{
+	struct tce_memory *mem, *memtmp;
+
+	if (container->enabled)
+		return -EBUSY;
+
+	if ((vaddr & ~PAGE_MASK) || (size & ~PAGE_MASK))
+		return -EINVAL;
+
+	list_for_each_entry_safe(mem, memtmp, &container->mem_list, next) {
+		if ((mem->vaddr == vaddr) && (mem->size == size)) {
+			tce_do_unregister_pages(container, mem);
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static long tce_pin_pages(struct tce_container *container,
+		struct tce_memory *mem, __u64 vaddr, __u64 size)
+{
+	__u64 off;
+	struct page *page = NULL;
+
+	for (off = 0; off < size; off += PAGE_SIZE) {
+		if (1 != get_user_pages_fast(vaddr + off,
+					1/* pages */, 1/* iswrite */, &page)) {
+			tce_unpin_pages(container, mem, vaddr, off);
+			return -EFAULT;
+		}
+
+		mem->pfns[off >> PAGE_SHIFT] = page_to_pfn(page);
+	}
+
+	return 0;
+}
+
+static long tce_register_pages(struct tce_container *container,
+		__u64 vaddr, __u64 size)
+{
+	long ret;
+	struct tce_memory *mem;
+
+	if (container->enabled)
+		return -EBUSY;
+
+	if ((vaddr & ~PAGE_MASK) || (size & ~PAGE_MASK) ||
+			((vaddr + size) < vaddr))
+		return -EINVAL;
+
+	/* Any overlap with registered chunks? */
+	rcu_read_lock();
+	list_for_each_entry_rcu(mem, &container->mem_list, next) {
+		if ((mem->vaddr < (vaddr + size)) &&
+				(vaddr < (mem->vaddr + mem->size))) {
+			ret = -EBUSY;
+			goto unlock_exit;
+		}
+	}
+
+	ret = try_increment_locked_vm(size >> PAGE_SHIFT);
+	if (ret)
+		goto unlock_exit;
+
+	mem = kzalloc(sizeof(*mem) + (size >> (PAGE_SHIFT - 3)), GFP_KERNEL);
+	if (!mem)
+		goto unlock_exit;
+
+	if (tce_pin_pages(container, mem, vaddr, size))
+		goto free_exit;
+
+	mem->vaddr = vaddr;
+	mem->size = size;
+
+	list_add_rcu(&mem->next, &container->mem_list);
+	rcu_read_unlock();
+
+	return 0;
+
+free_exit:
+	kfree(mem);
+
+unlock_exit:
+	decrement_locked_vm(size >> PAGE_SHIFT);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static inline bool tce_preregistered(struct tce_container *container)
+{
+	return !list_empty(&container->mem_list);
+}
+
+static bool tce_pinned(struct tce_container *container,
+		__u64 vaddr, __u64 size)
+{
+	struct tce_memory *mem;
+	bool ret = false;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(mem, &container->mem_list, next) {
+		if ((mem->vaddr <= vaddr) &&
+				(vaddr + size <= mem->vaddr + mem->size)) {
+			ret = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static bool tce_check_page_size(struct page *page, unsigned page_shift)
 {
 	unsigned shift;
@@ -166,14 +327,16 @@ static int tce_iommu_enable(struct tce_container *container)
 	 * as this information is only available from KVM and VFIO is
 	 * KVM agnostic.
 	 */
-	iommu = iommu_group_get_iommudata(container->grp);
-	if (!iommu)
-		return -EFAULT;
+	if (!tce_preregistered(container)) {
+		iommu = iommu_group_get_iommudata(container->grp);
+		if (!iommu)
+			return -EFAULT;
 
-	tbl = &iommu->tables[0];
-	ret = try_increment_locked_vm(IOMMU_TABLE_PAGES(tbl));
-	if (ret)
-		return ret;
+		tbl = &iommu->tables[0];
+		ret = try_increment_locked_vm(IOMMU_TABLE_PAGES(tbl));
+		if (ret)
+			return ret;
+	}
 
 	container->enabled = true;
 
@@ -193,12 +356,14 @@ static void tce_iommu_disable(struct tce_container *container)
 	if (!container->grp || !current->mm)
 		return;
 
-	iommu = iommu_group_get_iommudata(container->grp);
-	if (!iommu)
-		return;
+	if (!tce_preregistered(container)) {
+		iommu = iommu_group_get_iommudata(container->grp);
+		if (!iommu)
+			return;
 
-	tbl = &iommu->tables[0];
-	decrement_locked_vm(IOMMU_TABLE_PAGES(tbl));
+		tbl = &iommu->tables[0];
+		decrement_locked_vm(IOMMU_TABLE_PAGES(tbl));
+	}
 }
 
 static void *tce_iommu_open(unsigned long arg)
@@ -215,6 +380,7 @@ static void *tce_iommu_open(unsigned long arg)
 		return ERR_PTR(-ENOMEM);
 
 	mutex_init(&container->lock);
+	INIT_LIST_HEAD_RCU(&container->mem_list);
 
 	return container;
 }
@@ -222,6 +388,7 @@ static void *tce_iommu_open(unsigned long arg)
 static void tce_iommu_release(void *iommu_data)
 {
 	struct tce_container *container = iommu_data;
+	struct tce_memory *mem, *memtmp;
 
 	WARN_ON(container->grp);
 	tce_iommu_disable(container);
@@ -229,14 +396,19 @@ static void tce_iommu_release(void *iommu_data)
 	if (container->grp)
 		tce_iommu_detach_group(iommu_data, container->grp);
 
+	list_for_each_entry_safe(mem, memtmp, &container->mem_list, next)
+		tce_do_unregister_pages(container, mem);
+
 	mutex_destroy(&container->lock);
 
 	kfree(container);
 }
 
-static void tce_iommu_unuse_page(unsigned long oldtce)
+static void tce_iommu_unuse_page(struct tce_container *container,
+		unsigned long oldtce)
 {
 	struct page *page;
+	bool do_put = !tce_preregistered(container);
 
 	if (!(oldtce & (TCE_PCI_READ | TCE_PCI_WRITE)))
 		return;
@@ -245,7 +417,8 @@ static void tce_iommu_unuse_page(unsigned long oldtce)
 	if (oldtce & TCE_PCI_WRITE)
 		SetPageDirty(page);
 
-	put_page(page);
+	if (do_put)
+		put_page(page);
 }
 
 static int tce_iommu_clear(struct tce_container *container,
@@ -261,7 +434,7 @@ static int tce_iommu_clear(struct tce_container *container,
 		if (ret)
 			continue;
 
-		tce_iommu_unuse_page(oldtce);
+		tce_iommu_unuse_page(container, oldtce);
 	}
 
 	return 0;
@@ -279,42 +452,91 @@ static enum dma_data_direction tce_iommu_direction(unsigned long tce)
 		return DMA_NONE;
 }
 
+static unsigned long tce_get_hva_cached(struct tce_container *container,
+		unsigned page_shift, unsigned long tce)
+{
+	struct tce_memory *mem;
+	struct page *page = NULL;
+	unsigned long hva = -1;
+
+	tce &= ~(TCE_PCI_READ | TCE_PCI_WRITE);
+	rcu_read_lock();
+	list_for_each_entry_rcu(mem, &container->mem_list, next) {
+		if ((mem->vaddr <= tce) && (tce < (mem->vaddr + mem->size))) {
+			unsigned long gfn = (tce - mem->vaddr) >> PAGE_SHIFT;
+			unsigned long hpa = mem->pfns[gfn] << PAGE_SHIFT;
+
+			page = pfn_to_page(mem->pfns[gfn]);
+
+			if (!tce_check_page_size(page, page_shift))
+				break;
+
+			hva = (unsigned long) __va(hpa);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return hva;
+}
+
+static unsigned long tce_get_hva(struct tce_container *container,
+		unsigned page_shift, unsigned long tce)
+{
+	long ret = 0;
+	struct page *page = NULL;
+	unsigned long hva = -1;
+	enum dma_data_direction direction = tce_iommu_direction(tce);
+
+	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
+			direction != DMA_TO_DEVICE, &page);
+	if (unlikely(ret != 1))
+		return -1;
+
+	if (!tce_check_page_size(page, page_shift)) {
+		put_page(page);
+		return -1;
+	}
+
+	hva = (unsigned long) page_address(page) +
+		(tce & ~((1ULL << page_shift) - 1) & ~PAGE_MASK);
+
+	return hva;
+}
+
 static long tce_iommu_build(struct tce_container *container,
 		struct iommu_table *tbl,
 		unsigned long entry, unsigned long tce, unsigned long pages)
 {
 	long i, ret = 0;
-	struct page *page = NULL;
 	unsigned long hva, oldtce;
 	enum dma_data_direction direction = tce_iommu_direction(tce);
+	bool do_put = false;
 
 	for (i = 0; i < pages; ++i) {
-		ret = get_user_pages_fast(tce & PAGE_MASK, 1,
-				direction != DMA_TO_DEVICE, &page);
-		if (unlikely(ret != 1)) {
-			ret = -EFAULT;
-			break;
+		hva = tce_get_hva_cached(container, tbl->it_page_shift, tce);
+		if (hva == -1) {
+			do_put = true;
+			WARN_ON_ONCE(1);
+			hva = tce_get_hva(container, tbl->it_page_shift, tce);
 		}
 
-		if (!tce_check_page_size(page, tbl->it_page_shift)) {
-			ret = -EFAULT;
-			break;
-		}
-
-		hva = (unsigned long) page_address(page) +
-			(tce & IOMMU_PAGE_MASK(tbl) & ~PAGE_MASK);
 		oldtce = 0;
-
 		ret = iommu_tce_xchg(tbl, entry + i, hva, &oldtce, direction);
 		if (ret) {
-			put_page(page);
+			if (do_put)
+				put_page(pfn_to_page(__pa(hva) >> PAGE_SHIFT));
 			pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%ld\n",
 					__func__, entry << tbl->it_page_shift,
 					tce, ret);
 			break;
 		}
 
-		tce_iommu_unuse_page(oldtce);
+		if (do_put)
+			put_page(pfn_to_page(__pa(hva) >> PAGE_SHIFT));
+
+		tce_iommu_unuse_page(container, oldtce);
+
 		tce += IOMMU_PAGE_SIZE(tbl);
 	}
 
@@ -416,6 +638,11 @@ static long tce_iommu_ioctl(void *iommu_data,
 		if (ret)
 			return ret;
 
+		/* If any memory is pinned, only allow pages from that region */
+		if (tce_preregistered(container) &&
+				!tce_pinned(container, param.vaddr, param.size))
+			return -EPERM;
+
 		ret = tce_iommu_build(container, tbl,
 				param.iova >> tbl->it_page_shift,
 				tce, param.size >> tbl->it_page_shift);
@@ -464,6 +691,50 @@ static long tce_iommu_ioctl(void *iommu_data,
 
 		return ret;
 	}
+	case VFIO_IOMMU_REGISTER_MEMORY: {
+		struct vfio_iommu_type1_register_memory param;
+
+		minsz = offsetofend(struct vfio_iommu_type1_register_memory,
+				size);
+
+		if (copy_from_user(&param, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (param.argsz < minsz)
+			return -EINVAL;
+
+		/* No flag is supported now */
+		if (param.flags)
+			return -EINVAL;
+
+		mutex_lock(&container->lock);
+		ret = tce_register_pages(container, param.vaddr, param.size);
+		mutex_unlock(&container->lock);
+
+		return ret;
+	}
+	case VFIO_IOMMU_UNREGISTER_MEMORY: {
+		struct vfio_iommu_type1_unregister_memory param;
+
+		minsz = offsetofend(struct vfio_iommu_type1_unregister_memory,
+				size);
+
+		if (copy_from_user(&param, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (param.argsz < minsz)
+			return -EINVAL;
+
+		/* No flag is supported now */
+		if (param.flags)
+			return -EINVAL;
+
+		mutex_lock(&container->lock);
+		tce_unregister_pages(container, param.vaddr, param.size);
+		mutex_unlock(&container->lock);
+
+		return 0;
+	}
 	case VFIO_IOMMU_ENABLE:
 		mutex_lock(&container->lock);
 		ret = tce_iommu_enable(container);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 29715d2..2bb0c9b 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -437,6 +437,35 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_IOMMU_REGISTER_MEMORY - _IOW(VFIO_TYPE, VFIO_BASE + 17, struct vfio_iommu_type1_register_memory)
+ *
+ * Registers user space memory where DMA is allowed. It pins
+ * user pages and does the locked memory accounting so
+ * subsequent VFIO_IOMMU_MAP_DMA/VFIO_IOMMU_UNMAP_DMA calls
+ * get simpler.
+ */
+struct vfio_iommu_type1_register_memory {
+	__u32	argsz;
+	__u32	flags;
+	__u64	vaddr;				/* Process virtual address */
+	__u64	size;				/* Size of mapping (bytes) */
+};
+#define VFIO_IOMMU_REGISTER_MEMORY	_IO(VFIO_TYPE, VFIO_BASE + 17)
+
+/**
+ * VFIO_IOMMU_UNREGISTER_MEMORY - _IOW(VFIO_TYPE, VFIO_BASE + 18, struct vfio_iommu_type1_unregister_memory)
+ *
+ * Unregisters user space memory registered with VFIO_IOMMU_REGISTER_MEMORY.
+ */
+struct vfio_iommu_type1_unregister_memory {
+	__u32	argsz;
+	__u32	flags;
+	__u64	vaddr;				/* Process virtual address */
+	__u64	size;				/* Size of mapping (bytes) */
+};
+#define VFIO_IOMMU_UNREGISTER_MEMORY	_IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.0.0

