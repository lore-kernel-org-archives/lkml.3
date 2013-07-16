Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab3GPAzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:55:22 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42788 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab3GPAzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:55:13 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 08/10] powerpc/iommu: rework to support realmode
Date: Tue, 16 Jul 2013 10:54:03 +1000
Message-Id: <1373936045-22653-9-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
References: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TCE tables handling may differ for real and virtual modes so
additional ppc_md.tce_build_rm/ppc_md.tce_free_rm/ppc_md.tce_flush_rm
handlers were introduced earlier.

So this adds the following:
1. support for the new ppc_md calls;
2. ability to iommu_tce_build to process mupltiple entries per
call;
3. arch_spin_lock to protect TCE table from races in both real and virtual
modes;
4. proper TCE table protection from races with the existing IOMMU code
in iommu_take_ownership/iommu_release_ownership;
5. hwaddr variable renamed to hpa as it better describes what it
actually represents;
6. iommu_tce_direction is static now as it is not called from anywhere else.

This will be used by upcoming real mode support of VFIO on POWER.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h |   9 +-
 arch/powerpc/kernel/iommu.c      | 197 ++++++++++++++++++++++++++-------------
 2 files changed, 135 insertions(+), 71 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index c34656a..b01bde1 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -78,6 +78,7 @@ struct iommu_table {
 	unsigned long *it_map;       /* A simple allocation bitmap for now */
 #ifdef CONFIG_IOMMU_API
 	struct iommu_group *it_group;
+	arch_spinlock_t it_rm_lock;
 #endif
 };
 
@@ -152,9 +153,9 @@ extern int iommu_tce_clear_param_check(struct iommu_table *tbl,
 extern int iommu_tce_put_param_check(struct iommu_table *tbl,
 		unsigned long ioba, unsigned long tce);
 extern int iommu_tce_build(struct iommu_table *tbl, unsigned long entry,
-		unsigned long hwaddr, enum dma_data_direction direction);
-extern unsigned long iommu_clear_tce(struct iommu_table *tbl,
-		unsigned long entry);
+		unsigned long *hpas, unsigned long npages, bool rm);
+extern int iommu_free_tces(struct iommu_table *tbl, unsigned long entry,
+		unsigned long npages, bool rm);
 extern int iommu_clear_tces_and_put_pages(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages);
 extern int iommu_put_tce_user_mode(struct iommu_table *tbl,
@@ -164,7 +165,5 @@ extern void iommu_flush_tce(struct iommu_table *tbl);
 extern int iommu_take_ownership(struct iommu_table *tbl);
 extern void iommu_release_ownership(struct iommu_table *tbl);
 
-extern enum dma_data_direction iommu_tce_direction(unsigned long tce);
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_IOMMU_H */
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index b20ff17..0f56cac 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -903,7 +903,7 @@ void iommu_register_group(struct iommu_table *tbl,
 	kfree(name);
 }
 
-enum dma_data_direction iommu_tce_direction(unsigned long tce)
+static enum dma_data_direction iommu_tce_direction(unsigned long tce)
 {
 	if ((tce & TCE_PCI_READ) && (tce & TCE_PCI_WRITE))
 		return DMA_BIDIRECTIONAL;
@@ -914,7 +914,6 @@ enum dma_data_direction iommu_tce_direction(unsigned long tce)
 	else
 		return DMA_NONE;
 }
-EXPORT_SYMBOL_GPL(iommu_tce_direction);
 
 void iommu_flush_tce(struct iommu_table *tbl)
 {
@@ -972,73 +971,116 @@ int iommu_tce_put_param_check(struct iommu_table *tbl,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_put_param_check);
 
-unsigned long iommu_clear_tce(struct iommu_table *tbl, unsigned long entry)
-{
-	unsigned long oldtce;
-	struct iommu_pool *pool = get_pool(tbl, entry);
-
-	spin_lock(&(pool->lock));
-
-	oldtce = ppc_md.tce_get(tbl, entry);
-	if (oldtce & (TCE_PCI_WRITE | TCE_PCI_READ))
-		ppc_md.tce_free(tbl, entry, 1);
-	else
-		oldtce = 0;
-
-	spin_unlock(&(pool->lock));
-
-	return oldtce;
-}
-EXPORT_SYMBOL_GPL(iommu_clear_tce);
-
 int iommu_clear_tces_and_put_pages(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages)
 {
-	unsigned long oldtce;
-	struct page *page;
-
-	for ( ; pages; --pages, ++entry) {
-		oldtce = iommu_clear_tce(tbl, entry);
-		if (!oldtce)
-			continue;
-
-		page = pfn_to_page(oldtce >> PAGE_SHIFT);
-		WARN_ON(!page);
-		if (page) {
-			if (oldtce & TCE_PCI_WRITE)
-				SetPageDirty(page);
-			put_page(page);
-		}
-	}
-
-	return 0;
+	return iommu_free_tces(tbl, entry, pages, false);
 }
 EXPORT_SYMBOL_GPL(iommu_clear_tces_and_put_pages);
 
-/*
- * hwaddr is a kernel virtual address here (0xc... bazillion),
- * tce_build converts it to a physical address.
- */
+int iommu_free_tces(struct iommu_table *tbl, unsigned long entry,
+		unsigned long npages, bool rm)
+{
+	int i, ret = 0, to_free = 0;
+
+	if (rm && !ppc_md.tce_free_rm)
+		return -EAGAIN;
+
+	arch_spin_lock(&tbl->it_rm_lock);
+
+	for (i = 0; i < npages; ++i) {
+		unsigned long oldtce = ppc_md.tce_get(tbl, entry + i);
+		if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
+			continue;
+
+		if (rm) {
+			struct page *pg = realmode_pfn_to_page(
+					oldtce >> PAGE_SHIFT);
+			if (!pg) {
+				ret = -EAGAIN;
+			} else if (PageCompound(pg)) {
+				ret = -EAGAIN;
+			} else {
+				if (oldtce & TCE_PCI_WRITE)
+					SetPageDirty(pg);
+				ret = realmode_put_page(pg);
+			}
+		} else {
+			struct page *pg = pfn_to_page(oldtce >> PAGE_SHIFT);
+			if (!pg) {
+				ret = -EAGAIN;
+			} else {
+				if (oldtce & TCE_PCI_WRITE)
+					SetPageDirty(pg);
+				put_page(pg);
+			}
+		}
+		if (ret)
+			break;
+		to_free = i + 1;
+	}
+
+	if (to_free) {
+		if (rm)
+			ppc_md.tce_free_rm(tbl, entry, to_free);
+		else
+			ppc_md.tce_free(tbl, entry, to_free);
+
+		if (rm && ppc_md.tce_flush_rm)
+			ppc_md.tce_flush_rm(tbl);
+		else if (!rm && ppc_md.tce_flush)
+			ppc_md.tce_flush(tbl);
+	}
+	arch_spin_unlock(&tbl->it_rm_lock);
+
+	/* Make sure updates are seen by hardware */
+	mb();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_free_tces);
+
 int iommu_tce_build(struct iommu_table *tbl, unsigned long entry,
-		unsigned long hwaddr, enum dma_data_direction direction)
+		unsigned long *hpas, unsigned long npages, bool rm)
 {
-	int ret = -EBUSY;
-	unsigned long oldtce;
-	struct iommu_pool *pool = get_pool(tbl, entry);
+	int i, ret = 0;
 
-	spin_lock(&(pool->lock));
+	if (rm && !ppc_md.tce_build_rm)
+		return -EAGAIN;
 
-	oldtce = ppc_md.tce_get(tbl, entry);
-	/* Add new entry if it is not busy */
-	if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
-		ret = ppc_md.tce_build(tbl, entry, 1, hwaddr, direction, NULL);
+	arch_spin_lock(&tbl->it_rm_lock);
 
-	spin_unlock(&(pool->lock));
+	for (i = 0; i < npages; ++i) {
+		if (ppc_md.tce_get(tbl, entry + i) &
+				(TCE_PCI_WRITE | TCE_PCI_READ)) {
+			arch_spin_unlock(&tbl->it_rm_lock);
+			return -EBUSY;
+		}
+	}
 
-	/* if (unlikely(ret))
-		pr_err("iommu_tce: %s failed on hwaddr=%lx ioba=%lx kva=%lx ret=%d\n",
-				__func__, hwaddr, entry << IOMMU_PAGE_SHIFT,
-				hwaddr, ret); */
+	for (i = 0; i < npages; ++i) {
+		unsigned long volatile hva = (unsigned long) __va(hpas[i]);
+		enum dma_data_direction dir = iommu_tce_direction(hva);
+
+		if (rm)
+			ret = ppc_md.tce_build_rm(tbl, entry + i, 1,
+					hva, dir, NULL);
+		else
+			ret = ppc_md.tce_build(tbl, entry + i, 1,
+					hva, dir, NULL);
+		if (ret)
+			break;
+	}
+
+	if (rm && ppc_md.tce_flush_rm)
+		ppc_md.tce_flush_rm(tbl);
+	else if (!rm && ppc_md.tce_flush)
+		ppc_md.tce_flush(tbl);
+
+	arch_spin_unlock(&tbl->it_rm_lock);
+
+	/* Make sure updates are seen by hardware */
+	mb();
 
 	return ret;
 }
@@ -1049,7 +1091,7 @@ int iommu_put_tce_user_mode(struct iommu_table *tbl, unsigned long entry,
 {
 	int ret;
 	struct page *page = NULL;
-	unsigned long hwaddr, offset = tce & IOMMU_PAGE_MASK & ~PAGE_MASK;
+	unsigned long hpa, offset = tce & IOMMU_PAGE_MASK & ~PAGE_MASK;
 	enum dma_data_direction direction = iommu_tce_direction(tce);
 
 	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
@@ -1059,9 +1101,9 @@ int iommu_put_tce_user_mode(struct iommu_table *tbl, unsigned long entry,
 				tce, entry << IOMMU_PAGE_SHIFT, ret); */
 		return -EFAULT;
 	}
-	hwaddr = (unsigned long) page_address(page) + offset;
+	hpa = __pa((unsigned long) page_address(page)) + offset;
 
-	ret = iommu_tce_build(tbl, entry, hwaddr, direction);
+	ret = iommu_tce_build(tbl, entry, &hpa, 1, false);
 	if (ret)
 		put_page(page);
 
@@ -1075,18 +1117,32 @@ EXPORT_SYMBOL_GPL(iommu_put_tce_user_mode);
 
 int iommu_take_ownership(struct iommu_table *tbl)
 {
-	unsigned long sz = (tbl->it_size + 7) >> 3;
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
+	int ret = 0;
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock(&tbl->pools[i].lock);
 
 	if (tbl->it_offset == 0)
 		clear_bit(0, tbl->it_map);
 
 	if (!bitmap_empty(tbl->it_map, tbl->it_size)) {
 		pr_err("iommu_tce: it_map is not empty");
-		return -EBUSY;
+		ret = -EBUSY;
+		if (tbl->it_offset == 0)
+			clear_bit(1, tbl->it_map);
+
+	} else {
+		memset(tbl->it_map, 0xff, sz);
 	}
 
-	memset(tbl->it_map, 0xff, sz);
-	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
+
+	if (!ret)
+		iommu_free_tces(tbl, tbl->it_offset, tbl->it_size, false);
 
 	return 0;
 }
@@ -1094,14 +1150,23 @@ EXPORT_SYMBOL_GPL(iommu_take_ownership);
 
 void iommu_release_ownership(struct iommu_table *tbl)
 {
-	unsigned long sz = (tbl->it_size + 7) >> 3;
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
+
+	iommu_free_tces(tbl, tbl->it_offset, tbl->it_size, false);
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock(&tbl->pools[i].lock);
 
-	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
 	memset(tbl->it_map, 0, sz);
 
 	/* Restore bit#0 set by iommu_init_table() */
 	if (tbl->it_offset == 0)
 		set_bit(0, tbl->it_map);
+
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
 }
 EXPORT_SYMBOL_GPL(iommu_release_ownership);
 
-- 
1.8.3.2

