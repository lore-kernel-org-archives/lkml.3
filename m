Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbbA2J2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:28:17 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42897 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbbA2JWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:34 -0500
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
Subject: [PATCH v3 12/24] powerpc/iommu/powernv: Release replaced TCE
Date: Thu, 29 Jan 2015 20:21:53 +1100
Message-Id: <1422523325-1389-13-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0005-0000-0000-000001436286
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment writing new TCE value to the IOMMU table fails with EBUSY
if there is a valid entry already. However PAPR specification allows
the guest to write new TCE value without clearing it first.

Another problem this patch is addressing is the use of pool locks for
external IOMMU users such as VFIO. The pool locks are to protect
DMA page allocator rather than entries and since the host kernel does
not control what pages are in use, there is no point in pool locks and
exchange()+put_page(oldtce) is sufficient to avoid possible races.

This adds an exchange() callback to iommu_table_ops which does the same
thing as set() plus it returns replaced TCE(s) so the caller can release
the pages afterwards.

This implements exchange() for IODA2 only. This adds a requirement
for a platform to have exchange() implemented so from now on IODA2 is
the only supported PHB for VFIO-SPAPR.

This replaces iommu_tce_build() and iommu_clear_tce() with
a single iommu_tce_xchg().

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h          | 13 +++++---
 arch/powerpc/kernel/iommu.c               | 50 +++++++++++--------------------
 arch/powerpc/platforms/powernv/pci-ioda.c | 16 ++++++++++
 arch/powerpc/platforms/powernv/pci.c      | 22 ++++++++++++++
 arch/powerpc/platforms/powernv/pci.h      |  4 +++
 drivers/vfio/vfio_iommu_spapr_tce.c       | 36 ++++++++++++++--------
 6 files changed, 92 insertions(+), 49 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index ba16aa0..bf26d47 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -49,6 +49,12 @@ struct iommu_table_ops {
 			unsigned long uaddr,
 			enum dma_data_direction direction,
 			struct dma_attrs *attrs);
+	int (*exchange)(struct iommu_table *tbl,
+			long index, long npages,
+			unsigned long uaddr,
+			unsigned long *old_tces,
+			enum dma_data_direction direction,
+			struct dma_attrs *attrs);
 	void (*clear)(struct iommu_table *tbl,
 			long index, long npages);
 	unsigned long (*get)(struct iommu_table *tbl, long index);
@@ -225,10 +231,9 @@ extern int iommu_tce_clear_param_check(struct iommu_table *tbl,
 		unsigned long npages);
 extern int iommu_tce_put_param_check(struct iommu_table *tbl,
 		unsigned long ioba, unsigned long tce);
-extern int iommu_tce_build(struct iommu_table *tbl, unsigned long entry,
-		unsigned long hwaddr, enum dma_data_direction direction);
-extern unsigned long iommu_clear_tce(struct iommu_table *tbl,
-		unsigned long entry);
+extern long iommu_tce_xchg(struct iommu_table *tbl, unsigned long entry,
+		unsigned long hwaddr, unsigned long *oldtce,
+		enum dma_data_direction direction);
 
 extern void iommu_flush_tce(struct iommu_table *tbl);
 extern int iommu_take_ownership(struct powerpc_iommu *iommu);
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 9d06425..26feaff 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -974,44 +974,18 @@ int iommu_tce_put_param_check(struct iommu_table *tbl,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_put_param_check);
 
-unsigned long iommu_clear_tce(struct iommu_table *tbl, unsigned long entry)
-{
-	unsigned long oldtce;
-	struct iommu_pool *pool = get_pool(tbl, entry);
-
-	spin_lock(&(pool->lock));
-
-	oldtce = tbl->it_ops->get(tbl, entry);
-	if (oldtce & (TCE_PCI_WRITE | TCE_PCI_READ))
-		tbl->it_ops->clear(tbl, entry, 1);
-	else
-		oldtce = 0;
-
-	spin_unlock(&(pool->lock));
-
-	return oldtce;
-}
-EXPORT_SYMBOL_GPL(iommu_clear_tce);
-
 /*
  * hwaddr is a kernel virtual address here (0xc... bazillion),
  * tce_build converts it to a physical address.
  */
-int iommu_tce_build(struct iommu_table *tbl, unsigned long entry,
-		unsigned long hwaddr, enum dma_data_direction direction)
+long iommu_tce_xchg(struct iommu_table *tbl, unsigned long entry,
+		unsigned long hwaddr, unsigned long *oldtce,
+		enum dma_data_direction direction)
 {
-	int ret = -EBUSY;
-	unsigned long oldtce;
-	struct iommu_pool *pool = get_pool(tbl, entry);
+	long ret;
 
-	spin_lock(&(pool->lock));
-
-	oldtce = tbl->it_ops->get(tbl, entry);
-	/* Add new entry if it is not busy */
-	if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
-		ret = tbl->it_ops->set(tbl, entry, 1, hwaddr, direction, NULL);
-
-	spin_unlock(&(pool->lock));
+	ret = tbl->it_ops->exchange(tbl, entry, 1, hwaddr, oldtce,
+			direction, NULL);
 
 	/* if (unlikely(ret))
 		pr_err("iommu_tce: %s failed on hwaddr=%lx ioba=%lx kva=%lx ret=%d\n",
@@ -1020,13 +994,23 @@ int iommu_tce_build(struct iommu_table *tbl, unsigned long entry,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(iommu_tce_build);
+EXPORT_SYMBOL_GPL(iommu_tce_xchg);
 
 static int iommu_table_take_ownership(struct iommu_table *tbl)
 {
 	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
 	int ret = 0;
 
+	/*
+	 * VFIO does not control TCE entries allocation and the guest
+	 * can write new TCEs on top of existing ones so iommu_tce_build()
+	 * must be able to release old pages. This functionality
+	 * requires exchange() callback defined so if it is not
+	 * implemented, we disallow taking ownership over the table.
+	 */
+	if (!tbl->it_ops->exchange)
+		return -EINVAL;
+
 	spin_lock_irqsave(&tbl->large_pool.lock, flags);
 	for (i = 0; i < tbl->nr_pools; i++)
 		spin_lock(&tbl->pools[i].lock);
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index dfc56fc..6d279d5 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1166,6 +1166,21 @@ static int pnv_ioda2_tce_build_vm(struct iommu_table *tbl, long index,
 	return ret;
 }
 
+static int pnv_ioda2_tce_xchg_vm(struct iommu_table *tbl, long index,
+		long npages, unsigned long uaddr, unsigned long *old_tces,
+		enum dma_data_direction direction,
+		struct dma_attrs *attrs)
+{
+	long ret = pnv_tce_xchg(tbl, index, npages, uaddr, old_tces, direction,
+			attrs);
+
+	if (!ret && (tbl->it_type &
+			(TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE)))
+		pnv_pci_ioda2_tce_invalidate(tbl, index, npages, false);
+
+	return ret;
+}
+
 static void pnv_ioda2_tce_free_vm(struct iommu_table *tbl, long index,
 		long npages)
 {
@@ -1177,6 +1192,7 @@ static void pnv_ioda2_tce_free_vm(struct iommu_table *tbl, long index,
 
 static struct iommu_table_ops pnv_ioda2_iommu_ops = {
 	.set = pnv_ioda2_tce_build_vm,
+	.exchange = pnv_ioda2_tce_xchg_vm,
 	.clear = pnv_ioda2_tce_free_vm,
 	.get = pnv_tce_get,
 };
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 3ab69e2..cf8206b 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -628,6 +628,28 @@ int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 	return 0;
 }
 
+int pnv_tce_xchg(struct iommu_table *tbl, long index,
+		long npages, unsigned long uaddr, unsigned long *old_tces,
+		enum dma_data_direction direction,
+		struct dma_attrs *attrs)
+{
+	u64 proto_tce = pnv_dmadir_to_flags(direction);
+	u64 rpn = __pa(uaddr) >> tbl->it_page_shift;
+	long i;
+
+	for (i = 0; i < npages; i++) {
+		unsigned long newtce = proto_tce |
+				((rpn + i) << tbl->it_page_shift);
+		unsigned long idx = index - tbl->it_offset + i;
+		unsigned long oldtce = xchg(pnv_tce(tbl, idx),
+				cpu_to_be64(newtce));
+
+		old_tces[i] = (unsigned long) __va(be64_to_cpu(oldtce));
+	}
+
+	return 0;
+}
+
 void pnv_tce_free(struct iommu_table *tbl, long index, long npages)
 {
 	long i;
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index 724bce9..6491581 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -220,6 +220,10 @@ extern int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 		unsigned long uaddr, enum dma_data_direction direction,
 		struct dma_attrs *attrs);
 extern void pnv_tce_free(struct iommu_table *tbl, long index, long npages);
+extern int pnv_tce_xchg(struct iommu_table *tbl, long index,
+		long npages, unsigned long uaddr, unsigned long *old_tces,
+		enum dma_data_direction direction,
+		struct dma_attrs *attrs);
 extern unsigned long pnv_tce_get(struct iommu_table *tbl, long index);
 extern struct iommu_table_ops pnv_ioda1_iommu_ops;
 
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index bcde2ef..8256275 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -234,25 +234,34 @@ static void tce_iommu_release(void *iommu_data)
 	kfree(container);
 }
 
+static void tce_iommu_unuse_page(unsigned long oldtce)
+{
+	struct page *page;
+
+	if (!(oldtce & (TCE_PCI_READ | TCE_PCI_WRITE)))
+		return;
+
+	page = pfn_to_page(__pa(oldtce) >> PAGE_SHIFT);
+	if (oldtce & TCE_PCI_WRITE)
+		SetPageDirty(page);
+
+	put_page(page);
+}
+
 static int tce_iommu_clear(struct tce_container *container,
 		struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages)
 {
+	long ret;
 	unsigned long oldtce;
-	struct page *page;
 
 	for ( ; pages; --pages, ++entry) {
-		oldtce = iommu_clear_tce(tbl, entry);
-		if (!oldtce)
+		oldtce = 0;
+		ret = iommu_tce_xchg(tbl, entry, 0, &oldtce, DMA_NONE);
+		if (ret)
 			continue;
 
-		page = pfn_to_page(oldtce >> PAGE_SHIFT);
-		WARN_ON(!page);
-		if (page) {
-			if (oldtce & TCE_PCI_WRITE)
-				SetPageDirty(page);
-			put_page(page);
-		}
+		tce_iommu_unuse_page(oldtce);
 	}
 
 	return 0;
@@ -276,7 +285,7 @@ static long tce_iommu_build(struct tce_container *container,
 {
 	long i, ret = 0;
 	struct page *page = NULL;
-	unsigned long hva;
+	unsigned long hva, oldtce;
 	enum dma_data_direction direction = tce_iommu_direction(tce);
 
 	for (i = 0; i < pages; ++i) {
@@ -294,8 +303,9 @@ static long tce_iommu_build(struct tce_container *container,
 
 		hva = (unsigned long) page_address(page) +
 			(tce & IOMMU_PAGE_MASK(tbl) & ~PAGE_MASK);
+		oldtce = 0;
 
-		ret = iommu_tce_build(tbl, entry + 1, hva, direction);
+		ret = iommu_tce_xchg(tbl, entry + i, hva, &oldtce, direction);
 		if (ret) {
 			put_page(page);
 			pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%ld\n",
@@ -303,6 +313,8 @@ static long tce_iommu_build(struct tce_container *container,
 					tce, ret);
 			break;
 		}
+
+		tce_iommu_unuse_page(oldtce);
 		tce += IOMMU_PAGE_SIZE(tbl);
 	}
 
-- 
2.0.0

