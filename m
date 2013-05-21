Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3EUDH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:07:58 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:39227 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab3EUDHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:07:25 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 4/4] KVM: PPC: Add hugepage support for IOMMU in-kernel handling
Date: Tue, 21 May 2013 13:06:47 +1000
Message-Id: <1369105607-20957-5-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369105607-20957-1-git-send-email-aik@ozlabs.ru>
References: <1369105607-20957-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds special support for huge pages (16MB).  The reference
counting cannot be easily done for such pages in real mode (when
MMU is off) so we added a list of huge pages.  It is populated in
virtual mode and get_page is called just once per a huge page.
Real mode handlers check if the requested page is huge and in the list,
then no reference counting is done, otherwise an exit to virtual mode
happens.  The list is released at KVM exit.  At the moment the fastest
card available for tests uses up to 9 huge pages so walking through this
list is not very expensive.  However this can change and we may want
to optimize this.

Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Paul Mackerras <paulus@samba.org>

---

Changes:
* the real mode handler now searches for a huge page by gpa (used to be pte)
* the virtual mode handler prints warning if it is called twice for the same
huge page as the real mode handler is expected to fail just once - when a huge
page is not in the list yet.
* the huge page is refcounted twice - when added to the hugepage list and
when used in the virtual mode hcall handler (can be optimized but it will
make the patch less nice).
---
 arch/powerpc/include/asm/kvm_host.h |    2 +
 arch/powerpc/include/asm/kvm_ppc.h  |   22 +++++++++
 arch/powerpc/kvm/book3s_64_vio.c    |   88 +++++++++++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_64_vio_hv.c |   40 ++++++++++++++--
 4 files changed, 146 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index ac0e2fe..4fc0865 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -181,6 +181,8 @@ struct kvmppc_spapr_tce_table {
 	u64 liobn;
 	u32 window_size;
 	struct iommu_group *grp;    /* used for IOMMU groups */
+	struct list_head hugepages; /* used for IOMMU groups */
+	spinlock_t hugepages_lock;  /* used for IOMMU groups */
 	struct page *pages[0];
 };
 
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 934e01d..9054df0 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -149,6 +149,28 @@ extern long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 extern long kvmppc_virtmode_h_stuff_tce(struct kvm_vcpu *vcpu,
 		unsigned long liobn, unsigned long ioba,
 		unsigned long tce_value, unsigned long npages);
+
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
+struct kvmppc_iommu_hugepage {
+	struct list_head list;
+	pte_t pte;		/* Huge page PTE */
+	unsigned long gpa;	/* Guest physical address */
+	struct page *page;	/* page struct of the very first subpage */
+	unsigned long size;	/* Huge page size (always 16MB at the moment) */
+};
+
 extern long kvm_vm_ioctl_allocate_rma(struct kvm *kvm,
 				struct kvm_allocate_rma *rma);
 extern struct kvmppc_linear_info *kvm_alloc_rma(void);
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index ffb4698..c34d63a 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -45,6 +45,71 @@
 #define TCES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
 #define ERROR_ADDR      ((void *)~(unsigned long)0x0)
 
+#ifdef CONFIG_IOMMU_API
+/* Adds a new huge page descriptor to the list  */
+static long kvmppc_iommu_hugepage_try_add(
+		struct kvmppc_spapr_tce_table *tt,
+		pte_t pte, unsigned long hva, unsigned long gpa,
+		unsigned long pg_size)
+{
+	long ret = 0;
+	struct kvmppc_iommu_hugepage *hp;
+	struct page *p;
+
+	spin_lock(&tt->hugepages_lock);
+	list_for_each_entry(hp, &tt->hugepages, list) {
+		if (hp->pte == pte)
+			goto unlock_exit;
+	}
+
+	hva = hva & ~(pg_size - 1);
+	ret = get_user_pages_fast(hva, 1, true/*write*/, &p);
+	if ((ret != 1) || !p) {
+		ret = -EFAULT;
+		goto unlock_exit;
+	}
+	ret = 0;
+
+	hp = kzalloc(sizeof(*hp), GFP_KERNEL);
+	if (!hp) {
+		ret = -ENOMEM;
+		goto unlock_exit;
+	}
+
+	hp->page = p;
+	hp->pte = pte;
+	hp->gpa = gpa & ~(pg_size - 1);
+	hp->size = pg_size;
+
+	list_add(&hp->list, &tt->hugepages);
+
+unlock_exit:
+	spin_unlock(&tt->hugepages_lock);
+
+	return ret;
+}
+
+static void kvmppc_iommu_hugepages_init(struct kvmppc_spapr_tce_table *tt)
+{
+	INIT_LIST_HEAD(&tt->hugepages);
+	spin_lock_init(&tt->hugepages_lock);
+}
+
+static void kvmppc_iommu_hugepages_cleanup(struct kvmppc_spapr_tce_table *tt)
+{
+	struct kvmppc_iommu_hugepage *hp, *tmp;
+
+	spin_lock(&tt->hugepages_lock);
+	list_for_each_entry_safe(hp, tmp, &tt->hugepages, list) {
+		list_del(&hp->list);
+		put_page(hp->page); /* one for iommu_put_tce_user_mode */
+		put_page(hp->page); /* one for kvmppc_iommu_hugepage_try_add */
+		kfree(hp);
+	}
+	spin_unlock(&tt->hugepages_lock);
+}
+#endif /* CONFIG_IOMMU_API */
+
 static long kvmppc_stt_npages(unsigned long window_size)
 {
 	return ALIGN((window_size >> SPAPR_TCE_SHIFT)
@@ -61,6 +126,7 @@ static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 #ifdef CONFIG_IOMMU_API
 	if (stt->grp) {
 		iommu_group_put(stt->grp);
+		kvmppc_iommu_hugepages_cleanup(stt);
 	} else
 #endif
 		for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
@@ -198,6 +264,7 @@ long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
 	kvm_get_kvm(kvm);
 
 	mutex_lock(&kvm->lock);
+	kvmppc_iommu_hugepages_init(tt);
 	list_add(&tt->list, &kvm->arch.spapr_tce_tables);
 
 	mutex_unlock(&kvm->lock);
@@ -218,16 +285,31 @@ long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
 
 /* Converts guest physical address into host virtual */
 static void __user *kvmppc_virtmode_gpa_to_hva(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
 		unsigned long gpa)
 {
 	unsigned long hva, gfn = gpa >> PAGE_SHIFT;
 	struct kvm_memory_slot *memslot;
+	pte_t *ptep;
+	unsigned int shift = 0;
 
 	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
 	if (!memslot)
 		return ERROR_ADDR;
 
 	hva = __gfn_to_hva_memslot(memslot, gfn) + (gpa & ~PAGE_MASK);
+
+	ptep = find_linux_pte_or_hugepte(vcpu->arch.pgdir, hva, &shift);
+	WARN_ON(!ptep);
+	if (!ptep)
+		return ERROR_ADDR;
+
+	if (tt && (shift > PAGE_SHIFT)) {
+		if (kvmppc_iommu_hugepage_try_add(tt, *ptep,
+				hva, gpa, 1 << shift))
+			return ERROR_ADDR;
+	}
+
 	return (void *) hva;
 }
 
@@ -267,7 +349,7 @@ long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
 			if (iommu_tce_put_param_check(tbl, ioba, tce))
 				return H_PARAMETER;
 
-			hva = kvmppc_virtmode_gpa_to_hva(vcpu, tce);
+			hva = kvmppc_virtmode_gpa_to_hva(vcpu, tt, tce);
 			if (hva == ERROR_ADDR)
 				return H_HARDWARE;
 
@@ -319,7 +401,7 @@ long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if (tce_list & ~IOMMU_PAGE_MASK)
 		return H_PARAMETER;
 
-	tces = kvmppc_virtmode_gpa_to_hva(vcpu, tce_list);
+	tces = kvmppc_virtmode_gpa_to_hva(vcpu, NULL, tce_list);
 	if (tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
@@ -354,7 +436,7 @@ long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 
 		/* Translate TCEs */
 		for (i = vcpu->arch.tce_tmp_num; i < npages; ++i) {
-			void *hva = kvmppc_virtmode_gpa_to_hva(vcpu,
+			void *hva = kvmppc_virtmode_gpa_to_hva(vcpu, tt,
 					vcpu->arch.tce_tmp[i]);
 
 			if (hva == ERROR_ADDR)
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index dc4ae32..6245365 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -178,6 +178,7 @@ static pte_t kvmppc_lookup_pte(pgd_t *pgdir, unsigned long hva, bool writing,
  * Also returns pte and page size if the page is present in page table.
  */
 static unsigned long kvmppc_realmode_gpa_to_hpa(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
 		unsigned long gpa, bool do_get_page)
 {
 	struct kvm_memory_slot *memslot;
@@ -185,7 +186,31 @@ static unsigned long kvmppc_realmode_gpa_to_hpa(struct kvm_vcpu *vcpu,
 	unsigned long hva, hpa, pg_size = 0, offset;
 	unsigned long gfn = gpa >> PAGE_SHIFT;
 	bool writing = gpa & TCE_PCI_WRITE;
+	struct kvmppc_iommu_hugepage *hp;
 
+	/*
+	 * Try to find an already used hugepage.
+	 * If it is not there, the kvmppc_lookup_pte() will return zero
+	 * as it won't do get_page() on a huge page in real mode
+	 * and therefore the request will be passed to the virtual mode.
+	 */
+	if (tt) {
+		spin_lock(&tt->hugepages_lock);
+		list_for_each_entry(hp, &tt->hugepages, list) {
+			if ((gpa < hp->gpa) || (gpa >= hp->gpa + hp->size))
+				continue;
+
+			/* Calculate host phys address keeping flags and offset in the page */
+			offset = gpa & (hp->size - 1);
+
+			/* pte_pfn(pte) should return an address aligned to pg_size */
+			hpa = (pte_pfn(hp->pte) << PAGE_SHIFT) + offset;
+			spin_unlock(&tt->hugepages_lock);
+
+			return hpa;
+		}
+		spin_unlock(&tt->hugepages_lock);
+	}
 	/* Find a KVM memslot */
 	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
 	if (!memslot)
@@ -237,6 +262,10 @@ static long kvmppc_clear_tce_real_mode(struct kvm_vcpu *vcpu,
 		if (oldtce & TCE_PCI_WRITE)
 			SetPageDirty(page);
 
+		/* Do not put a huge page and continue without error */
+		if (PageCompound(page))
+			continue;
+
 		if (realmode_put_page(page)) {
 			ret = H_TOO_HARD;
 			break;
@@ -282,7 +311,7 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			if (iommu_tce_put_param_check(tbl, ioba, tce))
 				return H_PARAMETER;
 
-			hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tce, true);
+			hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tt, tce, true);
 			if (hpa == ERROR_ADDR) {
 				vcpu->arch.tce_reason = H_TOO_HARD;
 				return H_TOO_HARD;
@@ -295,6 +324,11 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			if (unlikely(ret)) {
 				struct page *pg = realmode_pfn_to_page(hpa);
 				BUG_ON(!pg);
+
+				/* Do not put a huge page and return an error */
+				if (!PageCompound(pg))
+					return H_HARDWARE;
+
 				if (realmode_put_page(pg)) {
 					vcpu->arch.tce_reason = H_HARDWARE;
 					return H_TOO_HARD;
@@ -351,7 +385,7 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	vcpu->arch.tce_tmp_num = 0;
 	vcpu->arch.tce_reason = 0;
 
-	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu,
+	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu, NULL,
 			tce_list, false);
 	if ((unsigned long)tces == ERROR_ADDR)
 		return H_TOO_HARD;
@@ -374,7 +408,7 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 
 		/* Translate TCEs and go get_page */
 		for (i = 0; i < npages; ++i) {
-			unsigned long hpa = kvmppc_realmode_gpa_to_hpa(vcpu,
+			unsigned long hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tt,
 					vcpu->arch.tce_tmp[i], true);
 			if (hpa == ERROR_ADDR) {
 				vcpu->arch.tce_tmp_num = i;
-- 
1.7.10.4

