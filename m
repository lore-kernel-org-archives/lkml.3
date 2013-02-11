Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3BKMNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:13:43 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:50163 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3BKMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:13:40 -0500
From: aik@ozlabs.ru
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 4/4] vfio powerpc: added real mode support
Date: Mon, 11 Feb 2013 23:12:43 +1100
Message-Id: <5118e071.22ca320a.1f08.ffffe2f4@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360584763-21988-1-git-send-email-a>
References: <1360584763-21988-1-git-send-email-a>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

The patch allows the host kernel to handle H_PUT_TCE request
without involving QEMU in it what should save time on switching
from the kernel to QEMU and back.

The patch adds an IOMMU ID parameter into the KVM_CAP_SPAPR_TCE ioctl,
QEMU needs to be fixed to support that.

At the moment H_PUT_TCE is processed in the virtual mode as the page
to be mapped may not be present in the RAM so paging may be involved as
it can be done from the virtual mode only.

Tests show that this patch increases tranmission speed from 220MB/s
to 750..1020MB/s on 10Gb network (Chelsea CXGB3 10Gb ethernet card).

Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h    |   10 ++
 arch/powerpc/include/asm/kvm_host.h |    2 +
 arch/powerpc/include/asm/kvm_ppc.h  |    2 +
 arch/powerpc/include/uapi/asm/kvm.h |    8 ++
 arch/powerpc/kernel/iommu.c         |  253 +++++++++++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_64_vio.c    |   55 +++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c |  186 +++++++++++++++++++++++--
 arch/powerpc/kvm/powerpc.c          |   11 ++
 include/uapi/linux/kvm.h            |    1 +
 9 files changed, 503 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 900294b..4a479e6 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -78,6 +78,7 @@ struct iommu_table {
 	unsigned long *it_map;       /* A simple allocation bitmap for now */
 #ifdef CONFIG_IOMMU_API
 	struct iommu_group *it_group;
+	struct list_head it_hugepages;
 #endif
 };
 
@@ -158,6 +159,15 @@ extern long iommu_clear_tce_user_mode(struct iommu_table *tbl,
 		unsigned long npages);
 extern long iommu_put_tce_user_mode(struct iommu_table *tbl,
 		unsigned long ioba, unsigned long tce);
+extern long iommu_put_tce_real_mode(struct iommu_table *tbl,
+		unsigned long ioba, unsigned long tce,
+		pte_t pte, unsigned long pg_size);
+extern long iommu_clear_tce_real_mode(struct iommu_table *tbl,
+		unsigned long ioba, unsigned long tce_value,
+		unsigned long npages);
+extern long iommu_put_tce_virt_mode(struct iommu_table *tbl,
+		unsigned long ioba, unsigned long tce,
+		pte_t pte, unsigned long pg_size);
 
 extern void iommu_flush_tce(struct iommu_table *tbl);
 extern long iommu_lock_table(struct iommu_table *tbl, bool lock);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index ca9bf45..6fb22f8 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -178,6 +178,8 @@ struct kvmppc_spapr_tce_table {
 	struct kvm *kvm;
 	u64 liobn;
 	u32 window_size;
+	bool virtmode_only;
+	struct iommu_table *tbl;
 	struct page *pages[0];
 };
 
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 76d133b..45c2a6c 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -134,6 +134,8 @@ extern void kvmppc_map_vrma(struct kvm_vcpu *vcpu,
 extern int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu);
 extern long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 				struct kvm_create_spapr_tce *args);
+extern long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
+				struct kvm_create_spapr_tce_iommu *args);
 extern long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			     unsigned long ioba, unsigned long tce);
 extern long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index 2fba8a6..9578696 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -291,6 +291,14 @@ struct kvm_create_spapr_tce {
 	__u32 window_size;
 };
 
+/* for KVM_CAP_SPAPR_TCE_IOMMU */
+struct kvm_create_spapr_tce_iommu {
+	__u64 liobn;
+	__u32 iommu_id;
+#define SPAPR_TCE_PUT_TCE_VIRTMODE_ONLY	1 /* for debug purposes */
+	__u32 flags;
+};
+
 /* for KVM_ALLOCATE_RMA */
 struct kvm_allocate_rma {
 	__u64 rma_size;
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index b4fdabc..acb9cdc 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -47,6 +47,8 @@
 #include <asm/fadump.h>
 #include <asm/vio.h>
 #include <asm/tce.h>
+#include <asm/kvm_book3s_64.h>
+#include <asm/page.h>
 
 #define DBG(...)
 
@@ -727,6 +729,7 @@ void iommu_register_group(struct iommu_table * tbl,
 		return;
 	}
 	tbl->it_group = grp;
+	INIT_LIST_HEAD(&tbl->it_hugepages);
 	iommu_group_set_iommudata(grp, tbl, group_release);
 	iommu_group_set_name(grp, kasprintf(GFP_KERNEL, "domain%d-pe%lx",
 			domain_number, pe_num));
@@ -906,6 +909,83 @@ void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 }
 
+/*
+ * The KVM guest can be backed with 16MB pages (qemu switch
+ * -mem-path /var/lib/hugetlbfs/global/pagesize-16MB/).
+ * In this case, we cannot do page counting from the real mode
+ * as the compound pages are used - they are linked in a list
+ * with pointers as virtual addresses which are inaccessible
+ * in real mode.
+ *
+ * The code below keeps a 16MB pages list and uses page struct
+ * in real mode if it is already locked in RAM and inserted into
+ * the list or switches to the virtual mode where it can be
+ * handled in a usual manner.
+ */
+struct iommu_kvmppc_hugepages {
+	struct list_head list;
+	pte_t pte;		/* Huge page PTE */
+	unsigned long pa;	/* Base phys address used as a real TCE */
+	struct page *page;	/* page struct of the very first subpage */
+	unsigned long size;	/* Huge page size (always 16MB at the moment) */
+	bool dirty;		/* Dirty bit */
+};
+
+static struct iommu_kvmppc_hugepages *find_hp_by_pte(struct iommu_table *tbl,
+		pte_t pte)
+{
+	struct iommu_kvmppc_hugepages *hp;
+
+	list_for_each_entry(hp, &tbl->it_hugepages, list) {
+		if (hp->pte == pte)
+			return hp;
+	}
+
+	return NULL;
+}
+
+static struct iommu_kvmppc_hugepages *find_hp_by_pa(struct iommu_table *tbl,
+		unsigned long pa)
+{
+	struct iommu_kvmppc_hugepages *hp;
+
+	list_for_each_entry(hp, &tbl->it_hugepages, list) {
+		if ((hp->pa <= pa) && (pa < hp->pa + hp->size))
+			return hp;
+	}
+
+	return NULL;
+}
+
+static struct iommu_kvmppc_hugepages *add_hp(struct iommu_table *tbl,
+		pte_t pte, unsigned long va, unsigned long pg_size)
+{
+	int ret;
+	struct iommu_kvmppc_hugepages *hp;
+
+	hp = kzalloc(sizeof(*hp), GFP_KERNEL);
+	if (!hp)
+		return NULL;
+
+	hp->pte = pte;
+	va = va & ~(pg_size - 1);
+	ret = get_user_pages_fast(va, 1, true/*write*/, &hp->page);
+	if ((ret != 1) || !hp->page) {
+		kfree(hp);
+		return NULL;
+	}
+#if defined(HASHED_PAGE_VIRTUAL) || defined(WANT_PAGE_VIRTUAL)
+#error TODO: fix to avoid page_address() here
+#endif
+	hp->pa = __pa((unsigned long) page_address(hp->page));
+
+	hp->size = pg_size;
+
+	list_add(&hp->list, &tbl->it_hugepages);
+
+	return hp;
+}
+
 static enum dma_data_direction tce_direction(unsigned long tce)
 {
 	if ((tce & TCE_PCI_READ) && (tce & TCE_PCI_WRITE))
@@ -974,14 +1054,16 @@ static long tce_put_param_check(struct iommu_table *tbl,
 	return 0;
 }
 
-static long clear_tce(struct iommu_table *tbl,
+static long clear_tce(struct iommu_table *tbl, bool realmode,
 		unsigned long entry, unsigned long pages)
 {
+	long ret = 0;
 	unsigned long oldtce;
 	struct page *page;
 	struct iommu_pool *pool;
+	struct iommu_kvmppc_hugepages *hp;
 
-	for ( ; pages; --pages, ++entry) {
+	for ( ; pages && !ret; --pages, ++entry) {
 		pool = get_pool(tbl, entry);
 		spin_lock(&(pool->lock));
 
@@ -989,12 +1071,32 @@ static long clear_tce(struct iommu_table *tbl,
 		if (oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)) {
 			ppc_md.tce_free(tbl, entry, 1);
 
-			page = pfn_to_page(oldtce >> PAGE_SHIFT);
-			WARN_ON(!page);
-			if (page) {
+			/* Release of huge pages is postponed till KVM's exit */
+			hp = find_hp_by_pa(tbl, oldtce);
+			if (hp) {
 				if (oldtce & TCE_PCI_WRITE)
-					SetPageDirty(page);
-				put_page(page);
+					hp->dirty = true;
+			} else if (realmode) {
+				/* Release a small page in real mode */
+				page = vmemmap_pfn_to_page(
+						oldtce >> PAGE_SHIFT);
+				if (page) {
+					if (oldtce & TCE_PCI_WRITE)
+						SetPageDirty(page);
+					ret = vmemmap_put_page(page);
+				} else {
+					/* Retry in virtual mode */
+					ret = -EAGAIN;
+				}
+			} else {
+				/* Release a small page in virtual mode */
+				page = pfn_to_page(oldtce >> PAGE_SHIFT);
+				WARN_ON(!page);
+				if (page) {
+					if (oldtce & TCE_PCI_WRITE)
+						SetPageDirty(page);
+					put_page(page);
+				}
 			}
 		}
 		spin_unlock(&(pool->lock));
@@ -1011,7 +1113,7 @@ long iommu_clear_tce_user_mode(struct iommu_table *tbl, unsigned long ioba,
 
 	ret = tce_clear_param_check(tbl, ioba, tce_value, npages);
 	if (!ret)
-		ret = clear_tce(tbl, entry, npages);
+		ret = clear_tce(tbl, false, entry, npages);
 
 	if (ret < 0)
 		pr_err("iommu_tce: %s failed ioba=%lx, tce_value=%lx ret=%ld\n",
@@ -1021,6 +1123,24 @@ long iommu_clear_tce_user_mode(struct iommu_table *tbl, unsigned long ioba,
 }
 EXPORT_SYMBOL_GPL(iommu_clear_tce_user_mode);
 
+long iommu_clear_tce_real_mode(struct iommu_table *tbl, unsigned long ioba,
+		unsigned long tce_value, unsigned long npages)
+{
+	long ret;
+	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
+
+	ret = tce_clear_param_check(tbl, ioba, tce_value, npages);
+	if (!ret)
+		ret = clear_tce(tbl, true, entry, npages);
+
+	if (ret < 0)
+		pr_err("iommu_tce: %s failed ioba=%lx, tce_value=%lx ret=%ld\n",
+				__func__, ioba, tce_value, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_clear_tce_real_mode);
+
 /* hwaddr is a virtual address here, tce_build converts it to physical */
 static long do_tce_build(struct iommu_table *tbl, unsigned long entry,
 		unsigned long hwaddr, enum dma_data_direction direction)
@@ -1088,6 +1208,112 @@ long iommu_put_tce_user_mode(struct iommu_table *tbl, unsigned long ioba,
 }
 EXPORT_SYMBOL_GPL(iommu_put_tce_user_mode);
 
+static long put_tce_virt_mode(struct iommu_table *tbl,
+		unsigned long entry, unsigned long tce,
+		pte_t pte, unsigned long pg_size)
+{
+	struct iommu_kvmppc_hugepages *hp;
+	enum dma_data_direction direction = tce_direction(tce);
+
+	/* Small page size case, easy to handle... */
+	if (pg_size <= PAGE_SIZE)
+		return put_tce_user_mode(tbl, entry, tce);
+
+	/*
+	 * Hugepages case - manage the hugepage list.
+	 * find_hp_by_pte() may find a huge page if called
+	 * from h_put_tce_indirect call.
+	 */
+	hp = find_hp_by_pte(tbl, pte);
+	if (!hp) {
+		/* This is the first time usage of this huge page */
+		hp = add_hp(tbl, pte, tce, pg_size);
+		if (!hp)
+			return -EFAULT;
+	}
+
+	tce = (unsigned long) __va(hp->pa) + (tce & (pg_size - 1));
+
+	return do_tce_build(tbl, entry, tce, direction);
+}
+
+long iommu_put_tce_virt_mode(struct iommu_table *tbl,
+		unsigned long ioba, unsigned long tce,
+		pte_t pte, unsigned long pg_size)
+{
+	long ret;
+	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
+
+	ret = tce_put_param_check(tbl, ioba, tce);
+	if (!ret)
+		ret = put_tce_virt_mode(tbl, entry, tce, pte, pg_size);
+
+	if (ret < 0)
+		pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%ld\n",
+				__func__, ioba, tce, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_put_tce_virt_mode);
+
+static long put_tce_real_mode(struct iommu_table *tbl,
+		unsigned long entry, unsigned long tce,
+		pte_t pte, unsigned long pg_size)
+{
+	long ret;
+	struct page *page = NULL;
+	struct iommu_kvmppc_hugepages *hp = NULL;
+	enum dma_data_direction direction = tce_direction(tce);
+
+	/* This is a huge page. we continue only if it is already in the list */
+	if (pg_size > PAGE_SIZE) {
+		hp = find_hp_by_pte(tbl, pte);
+
+		/* Go to virt mode to add a hugepage to the list if not found */
+		if (!hp)
+			return -EAGAIN;
+
+		/* tce_build accepts virtual addresses */
+		return do_tce_build(tbl, entry, (unsigned long) __va(tce),
+				direction);
+	}
+
+	/* Small page case, find page struct to increment a counter */
+	page = vmemmap_pfn_to_page(tce >> PAGE_SHIFT);
+	if (!page)
+		return -EAGAIN;
+
+	ret = vmemmap_get_page(page);
+	if (ret)
+		return ret;
+
+	/* tce_build accepts virtual addresses */
+	ret = do_tce_build(tbl, entry, (unsigned long) __va(tce), direction);
+	if (ret)
+		vmemmap_put_page(page);
+
+	return ret;
+}
+
+long iommu_put_tce_real_mode(struct iommu_table *tbl,
+		unsigned long ioba, unsigned long tce,
+		pte_t pte, unsigned long pg_size)
+{
+	long ret;
+	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
+
+	ret = tce_put_param_check(tbl, ioba, tce);
+	if (!ret)
+		ret = put_tce_real_mode(tbl, entry, tce, pte, pg_size);
+
+	if (ret < 0)
+		pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%ld\n",
+				__func__, ioba, tce, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_put_tce_real_mode);
+
 /*
  * Helpers to do locked pages accounting.
  * Called from ioctl so down_write_trylock is not necessary.
@@ -1111,6 +1337,7 @@ long iommu_lock_table(struct iommu_table *tbl, bool lock)
 {
 	unsigned long sz = (tbl->it_size + 7) >> 3;
 	unsigned long locked, lock_limit;
+	struct iommu_kvmppc_hugepages *hp, *tmp;
 
 	if (lock) {
 		/*
@@ -1139,9 +1366,17 @@ long iommu_lock_table(struct iommu_table *tbl, bool lock)
 	}
 
 	/* Clear TCE table */
-	clear_tce(tbl, tbl->it_offset, tbl->it_size);
+	clear_tce(tbl, false, tbl->it_offset, tbl->it_size);
 
 	if (!lock) {
+		list_for_each_entry_safe(hp, tmp, &tbl->it_hugepages, list) {
+			list_del(&hp->list);
+			if (hp->dirty)
+				SetPageDirty(hp->page);
+			put_page(hp->page);
+			kfree(hp);
+		}
+
 		lock_acct(-tbl->it_size);
 		memset(tbl->it_map, 0, sz);
 
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 72ffc89..c3c29a0 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -26,6 +26,8 @@
 #include <linux/hugetlb.h>
 #include <linux/list.h>
 #include <linux/anon_inodes.h>
+#include <linux/pci.h>
+#include <linux/iommu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -36,6 +38,7 @@
 #include <asm/ppc-opcode.h>
 #include <asm/kvm_host.h>
 #include <asm/udbg.h>
+#include <asm/iommu.h>
 
 #define TCES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
 
@@ -52,8 +55,10 @@ static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 
 	mutex_lock(&kvm->lock);
 	list_del(&stt->list);
-	for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
-		__free_page(stt->pages[i]);
+	if (!stt->tbl) {
+		for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
+			__free_page(stt->pages[i]);
+	}
 	kfree(stt);
 	mutex_unlock(&kvm->lock);
 
@@ -148,3 +153,49 @@ fail:
 	}
 	return ret;
 }
+
+long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
+		struct kvm_create_spapr_tce_iommu *args)
+{
+	struct kvmppc_spapr_tce_table *stt = NULL;
+	struct pci_dev *pdev = NULL;
+
+	/* Check this LIOBN hasn't been previously allocated */
+	list_for_each_entry(stt, &kvm->arch.spapr_tce_tables, list) {
+		if (stt->liobn == args->liobn)
+			return -EBUSY;
+	}
+
+	stt = kzalloc(sizeof(*stt), GFP_KERNEL);
+	if (!stt)
+		return -ENOMEM;
+
+	stt->liobn = args->liobn;
+	stt->kvm = kvm;
+	stt->virtmode_only = !!(args->flags & SPAPR_TCE_PUT_TCE_VIRTMODE_ONLY);
+
+	/* Find an IOMMU table for the given ID */
+	for_each_pci_dev(pdev) {
+		struct iommu_table *tbl;
+
+		tbl = get_iommu_table_base(&pdev->dev);
+		if (!tbl)
+			continue;
+		if (iommu_group_id(tbl->it_group) != args->iommu_id)
+			continue;
+
+		stt->tbl = tbl;
+		pr_info("LIOBN=%llX hooked to IOMMU %d, virtmode_only=%u\n",
+				stt->liobn, args->iommu_id, stt->virtmode_only);
+		break;
+	}
+
+	kvm_get_kvm(kvm);
+
+	mutex_lock(&kvm->lock);
+	list_add(&stt->list, &kvm->arch.spapr_tce_tables);
+
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+}
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index c38edcd..b2aa957 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -171,6 +171,7 @@ static long emulated_h_put_tce(struct kvmppc_spapr_tce_table *stt,
 long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 		      unsigned long ioba, unsigned long tce)
 {
+	long ret;
 	struct kvmppc_spapr_tce_table *stt;
 
 	stt = find_tce_table(vcpu, liobn);
@@ -178,8 +179,37 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	if (!stt)
 		return H_TOO_HARD;
 
+	if (stt->virtmode_only)
+		return H_TOO_HARD;
+
 	/* Emulated IO */
-	return emulated_h_put_tce(stt, ioba, tce);
+	if (!stt->tbl)
+		return emulated_h_put_tce(stt, ioba, tce);
+
+	/* VFIO IOMMU */
+	if (tce & (TCE_PCI_READ | TCE_PCI_WRITE)) {
+		unsigned long hpa, pg_size = 0;
+		pte_t pte = 0;
+
+		hpa = get_real_address(vcpu, tce, tce & TCE_PCI_WRITE,
+				&pte, &pg_size);
+		if (!hpa)
+			return H_TOO_HARD;
+
+		ret = iommu_put_tce_real_mode(stt->tbl, ioba, hpa,
+				pte, pg_size);
+	} else {
+		ret = iommu_clear_tce_real_mode(stt->tbl, ioba, 0, 1);
+	}
+	iommu_flush_tce(stt->tbl);
+
+	if (ret == -EAGAIN)
+		return H_TOO_HARD;
+
+	if (ret < 0)
+		return H_PARAMETER;
+
+	return H_SUCCESS;
 }
 
 long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
@@ -195,15 +225,43 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if (!stt)
 		return H_TOO_HARD;
 
+	if (stt->virtmode_only)
+		return H_TOO_HARD;
+
 	tces = (void *) get_real_address(vcpu, tce_list, false, NULL, NULL);
 	if (!tces)
 		return H_TOO_HARD;
 
 	/* Emulated IO */
-	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
-		ret = emulated_h_put_tce(stt, ioba, tces[i]);
+	if (!stt->tbl) {
+		for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
+			ret = emulated_h_put_tce(stt, ioba, tces[i]);
+
+		return ret;
+	}
+
+	/* VFIO IOMMU */
+	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE) {
+		unsigned long hpa, pg_size = 0;
+		pte_t pte = 0;
+
+		hpa = get_real_address(vcpu, tces[i], tces[i] & TCE_PCI_WRITE,
+				&pte, &pg_size);
+		if (!hpa)
+			return H_TOO_HARD;
+
+		ret = iommu_put_tce_real_mode(stt->tbl,
+				ioba, hpa, pte, pg_size);
+	}
+	iommu_flush_tce(stt->tbl);
+
+	if (ret == -EAGAIN)
+		return H_TOO_HARD;
+
+	if (ret < 0)
+		return H_PARAMETER;
 
-	return ret;
+	return H_SUCCESS;
 }
 
 long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
@@ -218,11 +276,28 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 	if (!stt)
 		return H_TOO_HARD;
 
+	if (stt->virtmode_only)
+		return H_TOO_HARD;
+
 	/* Emulated IO */
-	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
-		ret = emulated_h_put_tce(stt, ioba, tce_value);
+	if (!stt->tbl) {
+		for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
+			ret = emulated_h_put_tce(stt, ioba, tce_value);
+
+		return ret;
+	}
+
+	/* VFIO IOMMU */
+	ret = iommu_clear_tce_real_mode(stt->tbl, ioba, tce_value, npages);
+ 	iommu_flush_tce(stt->tbl);
+
+	if (ret == -EAGAIN)
+		return H_TOO_HARD;
+
+	if (ret < 0)
+		return H_PARAMETER;
 
-	return ret;
+	return H_SUCCESS;
 }
 
 /*
@@ -232,8 +307,42 @@ extern long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
 		unsigned long liobn, unsigned long ioba,
 		unsigned long tce)
 {
-	/* At the moment emulated IO is handled the same way */
-	return kvmppc_h_put_tce(vcpu, liobn, ioba, tce);
+	long ret;
+	struct kvmppc_spapr_tce_table *stt;
+
+	stt = find_tce_table(vcpu, liobn);
+	/* Didn't find the liobn, put it to userspace */
+	if (!stt)
+		return H_TOO_HARD;
+
+	/* Emulated IO is not supported in virt mode */
+	if (!stt->tbl)
+		return emulated_h_put_tce(stt, ioba, tce);
+
+	/* VFIO IOMMU */
+	if (tce & (TCE_PCI_READ | TCE_PCI_WRITE)) {
+		unsigned long hpa, pg_size = 0;
+		pte_t pte;
+
+		hpa = get_virt_address(vcpu, tce, tce & TCE_PCI_WRITE,
+				&pte, &pg_size);
+		if (!tce)
+			return -EFAULT;
+
+		ret = iommu_put_tce_virt_mode(stt->tbl, ioba, hpa,
+				pte, pg_size);
+	} else {
+		ret = iommu_clear_tce_user_mode(stt->tbl, ioba, 0, 1);
+	}
+ 	iommu_flush_tce(stt->tbl);
+
+	if (ret == -EAGAIN)
+		return H_TOO_HARD;
+
+	if (ret < 0)
+		return H_PARAMETER;
+
+	return H_SUCCESS;
 }
 
 extern long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
@@ -254,16 +363,65 @@ extern long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		return H_TOO_HARD;
 
 	/* Emulated IO */
-	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
-		ret = emulated_h_put_tce(stt, ioba, tces[i]);
+	if (!stt->tbl) {
+		for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
+			ret = emulated_h_put_tce(stt, ioba, tces[i]);
+
+		return ret;
+	}
+
+	/* VFIO IOMMU */
+	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE) {
+		unsigned long hpa, pg_size = 0;
+		pte_t pte;
+
+		hpa = get_virt_address(vcpu, tces[i], tces[i] & TCE_PCI_WRITE,
+				&pte, &pg_size);
+		if (!hpa)
+			return H_TOO_HARD;
+
+		ret = iommu_put_tce_virt_mode(stt->tbl,
+				ioba, hpa, pte, pg_size);
+	}
+	iommu_flush_tce(stt->tbl);
+
+	if (ret == -EAGAIN)
+		return H_TOO_HARD;
+
+	if (ret < 0)
+		return H_PARAMETER;
 
-	return ret;
+	return H_SUCCESS;
 }
 
 extern long kvmppc_virtmode_h_stuff_tce(struct kvm_vcpu *vcpu,
 		unsigned long liobn, unsigned long ioba,
 		unsigned long tce_value, unsigned long npages)
 {
-	/* At the moment emulated IO is handled the same way */
-	return kvmppc_h_stuff_tce(vcpu, liobn, ioba, tce_value, npages);
+	struct kvmppc_spapr_tce_table *stt;
+	long ret = 0, i;
+
+	stt = find_tce_table(vcpu, liobn);
+	/* Didn't find the liobn, put it to userspace */
+	if (!stt)
+		return H_TOO_HARD;
+
+	/* Emulated IO */
+	if (!stt->tbl) {
+		for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
+			ret = emulated_h_put_tce(stt, ioba, tce_value);
+
+		return ret;
+	}
+
+	/* VFIO IOMMU */
+	ret = iommu_clear_tce_user_mode(stt->tbl, ioba, tce_value, npages);
+
+	if (ret == -EAGAIN)
+		return H_TOO_HARD;
+
+	if (ret < 0)
+		return H_PARAMETER;
+
+	return H_SUCCESS;
 }
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 95614c7..beceb90 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -934,6 +934,17 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_create_spapr_tce(kvm, &create_tce);
 		goto out;
 	}
+	case KVM_CREATE_SPAPR_TCE_IOMMU: {
+		struct kvm_create_spapr_tce_iommu create_tce_iommu;
+		struct kvm *kvm = filp->private_data;
+
+		r = -EFAULT;
+		if (copy_from_user(&create_tce_iommu, argp,
+				sizeof(create_tce_iommu)))
+			goto out;
+		r = kvm_vm_ioctl_create_spapr_tce_iommu(kvm, &create_tce_iommu);
+		goto out;
+	}
 #endif /* CONFIG_PPC_BOOK3S_64 */
 
 #ifdef CONFIG_KVM_BOOK3S_64_HV
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 26e2b271..3727ea6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -863,6 +863,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
 /* Available with KVM_CAP_PPC_HTAB_FD */
 #define KVM_PPC_GET_HTAB_FD	  _IOW(KVMIO,  0xaa, struct kvm_get_htab_fd)
+#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, struct kvm_create_spapr_tce_iommu)
 
 /*
  * ioctls for vcpu fds
-- 
1.7.10.4

