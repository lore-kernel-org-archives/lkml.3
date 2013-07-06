Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3GFPIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 11:08:18 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:42665 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3GFPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:08:10 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 7/8] KVM: PPC: Add support for IOMMU in-kernel handling
Date: Sun,  7 Jul 2013 01:07:06 +1000
Message-Id: <1373123227-22969-8-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the host kernel to handle H_PUT_TCE, H_PUT_TCE_INDIRECT
and H_STUFF_TCE requests without passing them to QEMU, which saves time
on switching to QEMU and back.

Both real and virtual modes are supported. First the kernel tries to
handle a TCE request in the real mode, if failed it passes it to
the virtual mode to complete the operation. If it a virtual mode
handler fails, a request is passed to the user mode.

This adds a new KVM_CAP_SPAPR_TCE_IOMMU ioctl to associate
a virtual PCI bus ID (LIOBN) with an IOMMU group which enables
in-kernel handling of IOMMU map/unmap. The external user API support
in VFIO is required.

Tests show that this patch increases transmission speed from 220MB/s
to 750..1020MB/s on 10Gb network (Chelsea CXGB3 10Gb ethernet card).

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

---

Changes:
2013/07/06:
* added realmode arch_spin_lock to protect TCE table from races
in real and virtual modes
* POWERPC IOMMU API is changed to support real mode
* iommu_take_ownership and iommu_release_ownership are protected by
iommu_table's locks
* VFIO external user API use rewritten
* multiple small fixes

2013/06/27:
* tce_list page is referenced now in order to protect it from accident
invalidation during H_PUT_TCE_INDIRECT execution
* added use of the external user VFIO API

2013/06/05:
* changed capability number
* changed ioctl number
* update the doc article number

2013/05/20:
* removed get_user() from real mode handlers
* kvm_vcpu_arch::tce_tmp usage extended. Now real mode handler puts there
translated TCEs, tries realmode_get_page() on those and if it fails, it
passes control over the virtual mode handler which tries to finish
the request handling
* kvmppc_lookup_pte() now does realmode_get_page() protected by BUSY bit
on a page
* The only reason to pass the request to user mode now is when the user mode
did not register TCE table in the kernel, in all other cases the virtual mode
handler is expected to do the job

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 Documentation/virtual/kvm/api.txt   |  26 ++++
 arch/powerpc/include/asm/iommu.h    |   9 +-
 arch/powerpc/include/asm/kvm_host.h |   3 +
 arch/powerpc/include/asm/kvm_ppc.h  |   2 +
 arch/powerpc/include/uapi/asm/kvm.h |   7 +
 arch/powerpc/kernel/iommu.c         | 196 +++++++++++++++--------
 arch/powerpc/kvm/book3s_64_vio.c    | 299 +++++++++++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c | 129 ++++++++++++++++
 arch/powerpc/kvm/powerpc.c          |  12 ++
 9 files changed, 609 insertions(+), 74 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 762c703..01b0dc2 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2387,6 +2387,32 @@ slows operations a lot.
 Unlike other capabilities of this section, this one is always enabled.
 
 
+4.87 KVM_CREATE_SPAPR_TCE_IOMMU
+
+Capability: KVM_CAP_SPAPR_TCE_IOMMU
+Architectures: powerpc
+Type: vm ioctl
+Parameters: struct kvm_create_spapr_tce_iommu (in)
+Returns: 0 on success, -1 on error
+
+struct kvm_create_spapr_tce_iommu {
+	__u64 liobn;
+	__u32 iommu_id;
+	__u32 flags;
+};
+
+This creates a link between IOMMU group and a hardware TCE (translation
+control entry) table. This link lets the host kernel know what IOMMU
+group (i.e. TCE table) to use for the LIOBN number passed with
+H_PUT_TCE, H_PUT_TCE_INDIRECT, H_STUFF_TCE hypercalls.
+
+In response to a TCE hypercall, the kernel looks for a TCE table descriptor
+in the list and handles the hypercall in real or virtual modes if
+the descriptor is found. Otherwise the hypercall is passed to the user mode.
+
+No flag is supported at the moment.
+
+
 5. The kvm_run structure
 ------------------------
 
diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 98d1422..0845505 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -78,6 +78,7 @@ struct iommu_table {
 	unsigned long *it_map;       /* A simple allocation bitmap for now */
 #ifdef CONFIG_IOMMU_API
 	struct iommu_group *it_group;
+	arch_spinlock_t it_rm_lock;
 #endif
 };
 
@@ -159,9 +160,9 @@ extern int iommu_tce_clear_param_check(struct iommu_table *tbl,
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
@@ -171,7 +172,5 @@ extern void iommu_flush_tce(struct iommu_table *tbl);
 extern int iommu_take_ownership(struct iommu_table *tbl);
 extern void iommu_release_ownership(struct iommu_table *tbl);
 
-extern enum dma_data_direction iommu_tce_direction(unsigned long tce);
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_IOMMU_H */
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 20d04bd..53e61b2 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -180,6 +180,8 @@ struct kvmppc_spapr_tce_table {
 	struct kvm *kvm;
 	u64 liobn;
 	u32 window_size;
+	struct iommu_group *grp;		/* used for IOMMU groups */
+	struct vfio_group *vfio_grp;		/* used for IOMMU groups */
 	struct { struct { unsigned long put, indir, stuff; } rm, vm; } stat;
 	struct page *pages[0];
 };
@@ -612,6 +614,7 @@ struct kvm_vcpu_arch {
 	u64 busy_preempt;
 
 	unsigned long *tce_tmp_hpas;	/* TCE cache for TCE_PUT_INDIRECT hcall */
+	unsigned long tce_tmp_num;	/* Number of handled TCEs in the cache */
 	enum {
 		TCERM_NONE,
 		TCERM_GETPAGE,
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index fa722a0..1476538 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -133,6 +133,8 @@ extern int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu);
 
 extern long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 				struct kvm_create_spapr_tce *args);
+extern long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
+				struct kvm_create_spapr_tce_iommu *args);
 extern struct kvmppc_spapr_tce_table *kvmppc_find_tce_table(
 		struct kvm_vcpu *vcpu, unsigned long liobn);
 extern long kvmppc_emulated_validate_tce(unsigned long tce);
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index 0fb1a6e..3da4aa3 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -319,6 +319,13 @@ struct kvm_create_spapr_tce {
 	__u32 window_size;
 };
 
+/* for KVM_CAP_SPAPR_TCE_IOMMU */
+struct kvm_create_spapr_tce_iommu {
+	__u64 liobn;
+	__u32 fd;
+	__u32 flags;
+};
+
 /* for KVM_ALLOCATE_RMA */
 struct kvm_allocate_rma {
 	__u64 rma_size;
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index b20ff17..51678ec 100644
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
@@ -972,73 +971,117 @@ int iommu_tce_put_param_check(struct iommu_table *tbl,
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
+	int i, ret = 0, clear_num = 0;
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
+		clear_num = i + 1;
+	}
+
+	if (clear_num) {
+		if (rm)
+			ppc_md.tce_free_rm(tbl, entry, clear_num);
+		else
+			ppc_md.tce_free(tbl, entry, clear_num);
+
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
@@ -1059,9 +1102,9 @@ int iommu_put_tce_user_mode(struct iommu_table *tbl, unsigned long entry,
 				tce, entry << IOMMU_PAGE_SHIFT, ret); */
 		return -EFAULT;
 	}
-	hwaddr = (unsigned long) page_address(page) + offset;
+	hwaddr = __pa((unsigned long) page_address(page)) + offset;
 
-	ret = iommu_tce_build(tbl, entry, hwaddr, direction);
+	ret = iommu_tce_build(tbl, entry, &hwaddr, 1, false);
 	if (ret)
 		put_page(page);
 
@@ -1075,18 +1118,32 @@ EXPORT_SYMBOL_GPL(iommu_put_tce_user_mode);
 
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
@@ -1094,14 +1151,23 @@ EXPORT_SYMBOL_GPL(iommu_take_ownership);
 
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
 
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 99bf4e5..2b51f4a 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -27,6 +27,10 @@
 #include <linux/hugetlb.h>
 #include <linux/list.h>
 #include <linux/anon_inodes.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/file.h>
+#include <linux/vfio.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -48,6 +52,45 @@ static long kvmppc_stt_npages(unsigned long window_size)
 		     * sizeof(u64), PAGE_SIZE) / PAGE_SIZE;
 }
 
+struct vfio_group *kvmppc_vfio_group_get_external_user(struct file *filep)
+{
+	struct vfio_group *ret;
+	struct vfio_group * (*proc)(struct file *) =
+			symbol_get(vfio_group_get_external_user);
+	if (!proc)
+		return NULL;
+
+	ret = proc(filep);
+	symbol_put(vfio_group_get_external_user);
+
+	return ret;
+}
+
+void kvmppc_vfio_group_put_external_user(struct vfio_group *group)
+{
+	void (*proc)(struct vfio_group *) =
+			symbol_get(vfio_group_put_external_user);
+	if (!proc)
+		return;
+
+	proc(group);
+	symbol_put(vfio_group_put_external_user);
+}
+
+int kvmppc_vfio_external_user_iommu_id(struct vfio_group *group)
+{
+	int ret;
+	int (*proc)(struct vfio_group *) =
+			symbol_get(vfio_external_user_iommu_id);
+	if (!proc)
+		return -EINVAL;
+
+	ret = proc(group);
+	symbol_put(vfio_external_user_iommu_id);
+
+	return ret;
+}
+
 static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 {
 	struct kvm *kvm = stt->kvm;
@@ -69,8 +112,17 @@ static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 
 	mutex_lock(&kvm->lock);
 	list_del(&stt->list);
-	for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
-		__free_page(stt->pages[i]);
+
+#ifdef CONFIG_IOMMU_API
+	if (stt->grp) {
+		if (stt->vfio_grp)
+			kvmppc_vfio_group_put_external_user(stt->vfio_grp);
+		iommu_group_put(stt->grp);
+	} else
+#endif
+		for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
+			__free_page(stt->pages[i]);
+
 	kfree(stt);
 	mutex_unlock(&kvm->lock);
 
@@ -166,9 +218,96 @@ fail:
 	return ret;
 }
 
+#ifdef CONFIG_IOMMU_API
+static const struct file_operations kvm_spapr_tce_iommu_fops = {
+	.release	= kvm_spapr_tce_release,
+};
+
+long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
+		struct kvm_create_spapr_tce_iommu *args)
+{
+	struct kvmppc_spapr_tce_table *tt = NULL;
+	struct iommu_group *grp;
+	struct iommu_table *tbl;
+	struct file *vfio_filp;
+	struct vfio_group *vfio_grp;
+	int ret = 0, iommu_id;
+
+	/* Check this LIOBN hasn't been previously allocated */
+	list_for_each_entry(tt, &kvm->arch.spapr_tce_tables, list) {
+		if (tt->liobn == args->liobn)
+			return -EBUSY;
+	}
+
+	vfio_filp = fget(args->fd);
+	if (!vfio_filp)
+		return -ENXIO;
+
+	/* Lock the group */
+	vfio_grp = kvmppc_vfio_group_get_external_user(vfio_filp);
+	if (!vfio_grp)
+		goto fput_exit;
+
+	/* Get IOMMU ID. Fails if group is not attached to IOMMU */
+	iommu_id = kvmppc_vfio_external_user_iommu_id(vfio_grp);
+	if (iommu_id < 0)
+		goto grpput_fput_exit;
+
+	ret = -ENXIO;
+	/* Find an IOMMU table for the given ID */
+	grp = iommu_group_get_by_id(iommu_id);
+	if (!grp)
+		goto grpput_fput_exit;
+
+	tbl = iommu_group_get_iommudata(grp);
+	if (!tbl)
+		goto grpput_fput_exit;
+
+	tt = kzalloc(sizeof(*tt), GFP_KERNEL);
+	if (!tt)
+		goto grpput_fput_exit;
+
+	tt->liobn = args->liobn;
+	tt->kvm = kvm;
+	tt->grp = grp;
+	tt->window_size = tbl->it_size << IOMMU_PAGE_SHIFT;
+	tt->vfio_grp = vfio_grp;
+
+	pr_debug("LIOBN=%llX fd=%d hooked to IOMMU %d, flags=%u\n",
+			args->liobn, args->fd, iommu_id, args->flags);
+
+	ret = anon_inode_getfd("kvm-spapr-tce-iommu",
+			&kvm_spapr_tce_iommu_fops, tt, O_RDWR);
+	if (ret < 0)
+		goto free_grpput_fput_exit;
+
+	kvm_get_kvm(kvm);
+	mutex_lock(&kvm->lock);
+	list_add(&tt->list, &kvm->arch.spapr_tce_tables);
+	mutex_unlock(&kvm->lock);
+
+	goto fput_exit;
+
+free_grpput_fput_exit:
+	kfree(tt);
+grpput_fput_exit:
+	kvmppc_vfio_group_put_external_user(vfio_grp);
+fput_exit:
+	fput(vfio_filp);
+
+	return ret;
+}
+#else
+long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
+		struct kvm_create_spapr_tce_iommu *args)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_IOMMU_API */
+
 /* Converts guest physical address to host virtual address */
 static void __user *kvmppc_vm_gpa_to_hva_and_get(struct kvm_vcpu *vcpu,
-		unsigned long gpa, struct page **pg)
+		unsigned long gpa, struct page **pg, unsigned long *hpa)
 {
 	unsigned long hva, gfn = gpa >> PAGE_SHIFT;
 	struct kvm_memory_slot *memslot;
@@ -182,9 +321,142 @@ static void __user *kvmppc_vm_gpa_to_hva_and_get(struct kvm_vcpu *vcpu,
 	if (get_user_pages_fast(hva & PAGE_MASK, 1, 0, pg) != 1)
 		return ERROR_ADDR;
 
+	if (hpa)
+		*hpa = __pa((unsigned long) page_address(*pg)) +
+				(hva & ~PAGE_MASK);
+
 	return (void *) hva;
 }
 
+#ifdef CONFIG_IOMMU_API
+long kvmppc_vm_h_put_tce_iommu(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce)
+{
+	struct page *pg = NULL;
+	unsigned long hpa;
+	void __user *hva;
+	struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+	if (!tbl)
+		return H_RESCINDED;
+
+	/* Clear TCE */
+	if (!(tce & (TCE_PCI_READ | TCE_PCI_WRITE))) {
+		if (iommu_tce_clear_param_check(tbl, ioba, 0, 1))
+			return H_PARAMETER;
+
+		if (iommu_free_tces(tbl, ioba >> IOMMU_PAGE_SHIFT,
+				1, false))
+			return H_HARDWARE;
+
+		return H_SUCCESS;
+	}
+
+	/* Put TCE */
+	if (vcpu->arch.tce_rm_fail != TCERM_NONE) {
+		/* Try put_tce if failed in real mode */
+		vcpu->arch.tce_rm_fail = TCERM_NONE;
+		hpa = vcpu->arch.tce_tmp_hpas[0];
+	} else {
+		if (iommu_tce_put_param_check(tbl, ioba, tce))
+			return H_PARAMETER;
+
+		hva = kvmppc_vm_gpa_to_hva_and_get(vcpu, tce, &pg, &hpa);
+		if (hva == ERROR_ADDR)
+			return H_HARDWARE;
+	}
+
+	if (!iommu_tce_build(tbl, ioba >> IOMMU_PAGE_SHIFT, &hpa, 1, false))
+		return H_SUCCESS;
+
+	pg = pfn_to_page(hpa >> PAGE_SHIFT);
+	if (pg)
+		put_page(pg);
+
+	return H_HARDWARE;
+}
+
+static long kvmppc_vm_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt, unsigned long ioba,
+		unsigned long __user *tces, unsigned long npages)
+{
+	long i = 0, start = 0;
+	struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+	if (!tbl)
+		return H_RESCINDED;
+
+	switch (vcpu->arch.tce_rm_fail) {
+	case TCERM_NONE:
+		break;
+	case TCERM_GETPAGE:
+		start = vcpu->arch.tce_tmp_num;
+		break;
+	case TCERM_PUTTCE:
+		goto put_tces;
+	case TCERM_PUTLIST:
+	default:
+		WARN_ON(1);
+		return H_HARDWARE;
+	}
+
+	for (i = start; i < npages; ++i) {
+		struct page *pg = NULL;
+		unsigned long gpa;
+		void __user *hva;
+
+		if (get_user(gpa, tces + i))
+			return H_HARDWARE;
+
+		if (iommu_tce_put_param_check(tbl, ioba +
+					(i << IOMMU_PAGE_SHIFT), gpa))
+			return H_PARAMETER;
+
+		hva = kvmppc_vm_gpa_to_hva_and_get(vcpu, gpa, &pg,
+				&vcpu->arch.tce_tmp_hpas[i]);
+		if (hva == ERROR_ADDR)
+			goto putpages_flush_exit;
+	}
+
+put_tces:
+	if (!iommu_tce_build(tbl, ioba >> IOMMU_PAGE_SHIFT,
+			vcpu->arch.tce_tmp_hpas, npages, false))
+		return H_SUCCESS;
+
+putpages_flush_exit:
+	for ( --i; i >= 0; --i) {
+		struct page *pg;
+		pg = pfn_to_page(vcpu->arch.tce_tmp_hpas[i] >> PAGE_SHIFT);
+		if (pg)
+			put_page(pg);
+	}
+
+	return H_HARDWARE;
+}
+
+long kvmppc_vm_h_stuff_tce_iommu(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_value, unsigned long npages)
+{
+	struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
+
+	if (!tbl)
+		return H_RESCINDED;
+
+	if (iommu_tce_clear_param_check(tbl, ioba, tce_value, npages))
+		return H_PARAMETER;
+
+	if (iommu_free_tces(tbl, entry, npages, false))
+		return H_HARDWARE;
+
+	return H_SUCCESS;
+}
+#endif /* CONFIG_IOMMU_API */
+
 long kvmppc_vm_h_put_tce(struct kvm_vcpu *vcpu,
 		unsigned long liobn, unsigned long ioba,
 		unsigned long tce)
@@ -199,6 +471,11 @@ long kvmppc_vm_h_put_tce(struct kvm_vcpu *vcpu,
 
 	++tt->stat.vm.put;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp)
+		return kvmppc_vm_h_put_tce_iommu(vcpu, tt, liobn, ioba, tce);
+#endif
+	/* Emulated IO */
 	if (ioba >= tt->window_size)
 		return H_PARAMETER;
 
@@ -240,13 +517,21 @@ long kvmppc_vm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
-	tces = kvmppc_vm_gpa_to_hva_and_get(vcpu, tce_list, &pg);
+	tces = kvmppc_vm_gpa_to_hva_and_get(vcpu, tce_list, &pg, NULL);
 	if (tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
 	if (vcpu->arch.tce_rm_fail == TCERM_PUTLIST)
 		goto put_list_page_exit;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		ret = kvmppc_vm_h_put_tce_indirect_iommu(vcpu,
+			tt, ioba, tces, npages);
+		goto put_list_page_exit;
+	}
+#endif
+	/* Emulated IO */
 	for (i = 0; i < npages; ++i) {
 		if (get_user(vcpu->arch.tce_tmp_hpas[i], tces + i)) {
 			ret = H_PARAMETER;
@@ -288,6 +573,12 @@ long kvmppc_vm_h_stuff_tce(struct kvm_vcpu *vcpu,
 
 	++tt->stat.vm.stuff;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp)
+		return kvmppc_vm_h_stuff_tce_iommu(vcpu, tt, liobn, ioba,
+				tce_value, npages);
+#endif
+	/* Emulated IO */
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index cd3e6f9..f8103c6 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/hugetlb.h>
 #include <linux/list.h>
+#include <linux/iommu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -179,6 +180,115 @@ static unsigned long kvmppc_rm_gpa_to_hpa_and_get(struct kvm_vcpu *vcpu,
 	return hpa;
 }
 
+#ifdef CONFIG_IOMMU_API
+static long kvmppc_h_put_tce_iommu(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt, unsigned long liobn,
+		unsigned long ioba, unsigned long tce)
+{
+	int ret;
+	struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+	unsigned long hpa;
+	struct page *pg = NULL;
+
+	if (!tbl)
+		return H_RESCINDED;
+
+	/* Clear TCE */
+	if (!(tce & (TCE_PCI_READ | TCE_PCI_WRITE))) {
+		if (iommu_tce_clear_param_check(tbl, ioba, 0, 1))
+			return H_PARAMETER;
+
+		if (iommu_free_tces(tbl, ioba >> IOMMU_PAGE_SHIFT, 1, true))
+			return H_TOO_HARD;
+
+		return H_SUCCESS;
+	}
+
+	/* Put TCE */
+	if (iommu_tce_put_param_check(tbl, ioba, tce))
+		return H_PARAMETER;
+
+	hpa = kvmppc_rm_gpa_to_hpa_and_get(vcpu, tce, &pg);
+	if (hpa == ERROR_ADDR)
+		return H_TOO_HARD;
+
+	ret = iommu_tce_build(tbl, ioba >> IOMMU_PAGE_SHIFT, &hpa, 1, true);
+	if (unlikely(ret)) {
+		if (ret == -EBUSY)
+			return H_PARAMETER;
+
+		vcpu->arch.tce_tmp_hpas[0] = hpa;
+		vcpu->arch.tce_tmp_num = 0;
+		vcpu->arch.tce_rm_fail = TCERM_PUTTCE;
+		return H_TOO_HARD;
+	}
+
+	return H_SUCCESS;
+}
+
+static long kvmppc_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt, unsigned long ioba,
+		unsigned long *tces, unsigned long npages)
+{
+	int i, ret;
+	unsigned long hpa;
+	struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+	struct page *pg = NULL;
+
+	if (!tbl)
+		return H_RESCINDED;
+
+	/* Check all TCEs */
+	for (i = 0; i < npages; ++i) {
+		if (iommu_tce_put_param_check(tbl, ioba +
+				(i << IOMMU_PAGE_SHIFT), tces[i]))
+			return H_PARAMETER;
+	}
+
+	/* Translate TCEs and go get_page() */
+	for (i = 0; i < npages; ++i) {
+		hpa = kvmppc_rm_gpa_to_hpa_and_get(vcpu, tces[i], &pg);
+		if (hpa == ERROR_ADDR) {
+			vcpu->arch.tce_tmp_num = i;
+			vcpu->arch.tce_rm_fail = TCERM_GETPAGE;
+			return H_TOO_HARD;
+		}
+		vcpu->arch.tce_tmp_hpas[i] = hpa;
+	}
+
+	/* Put TCEs to the table */
+	ret = iommu_tce_build(tbl, (ioba >> IOMMU_PAGE_SHIFT),
+			vcpu->arch.tce_tmp_hpas, npages, true);
+	if (ret == -EAGAIN) {
+		vcpu->arch.tce_rm_fail = TCERM_PUTTCE;
+		return H_TOO_HARD;
+	} else if (ret) {
+		return H_HARDWARE;
+	}
+
+	return H_SUCCESS;
+}
+
+static long kvmppc_h_stuff_tce_iommu(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_value, unsigned long npages)
+{
+	struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+	if (!tbl)
+		return H_RESCINDED;
+
+	if (iommu_tce_clear_param_check(tbl, ioba, tce_value, npages))
+		return H_PARAMETER;
+
+	if (iommu_free_tces(tbl, ioba >> IOMMU_PAGE_SHIFT, npages, true))
+		return H_TOO_HARD;
+
+	return H_SUCCESS;
+}
+#endif /* CONFIG_IOMMU_API */
+
 long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 		      unsigned long ioba, unsigned long tce)
 {
@@ -190,6 +300,11 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 
 	++tt->stat.rm.put;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp)
+		return kvmppc_h_put_tce_iommu(vcpu, tt, liobn, ioba, tce);
+#endif
+	/* Emulated IO */
 	if (ioba >= tt->window_size)
 		return H_PARAMETER;
 
@@ -231,6 +346,14 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if (tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		ret = kvmppc_h_put_tce_indirect_iommu(vcpu,
+			tt, ioba, (unsigned long *)tces, npages);
+		goto put_unlock_exit;
+	}
+#endif
+	/* Emulated IO */
 	for (i = 0; i < npages; ++i) {
 		ret = kvmppc_emulated_validate_tce(((unsigned long *)tces)[i]);
 		if (ret)
@@ -263,6 +386,12 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 
 	++tt->stat.rm.stuff;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp)
+		return kvmppc_h_stuff_tce_iommu(vcpu, tt, liobn, ioba,
+				tce_value, npages);
+#endif
+	/* Emulated IO */
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index ccb578b..2909cfa 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -395,6 +395,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = 1;
 		break;
 	case KVM_CAP_SPAPR_MULTITCE:
+	case KVM_CAP_SPAPR_TCE_IOMMU:
 		r = 1;
 		break;
 #endif
@@ -1025,6 +1026,17 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
-- 
1.8.3.2

