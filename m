Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3F0FEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:04:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43997 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3F0FD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:03:58 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel handling
Date: Thu, 27 Jun 2013 15:02:36 +1000
Message-Id: <1372309356-28320-9-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
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

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

---

Changes:
2013/06/27:
* list of huge pages replaces with hashtable for better performance
* spinlock removed from real mode and only protects insertion of new
huge [ages descriptors into the hashtable

2013/06/05:
* fixed compile error when CONFIG_IOMMU_API=n

2013/05/20:
* the real mode handler now searches for a huge page by gpa (used to be pte)
* the virtual mode handler prints warning if it is called twice for the same
huge page as the real mode handler is expected to fail just once - when a huge
page is not in the list yet.
* the huge page is refcounted twice - when added to the hugepage list and
when used in the virtual mode hcall handler (can be optimized but it will
make the patch less nice).
---
 arch/powerpc/include/asm/kvm_host.h |   25 +++++++++
 arch/powerpc/kvm/book3s_64_vio.c    |   95 +++++++++++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_64_vio_hv.c |   24 +++++++--
 3 files changed, 138 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 716ab18..0ad6189 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -30,6 +30,7 @@
 #include <linux/kvm_para.h>
 #include <linux/list.h>
 #include <linux/atomic.h>
+#include <linux/hashtable.h>
 #include <asm/kvm_asm.h>
 #include <asm/processor.h>
 #include <asm/page.h>
@@ -182,9 +183,33 @@ struct kvmppc_spapr_tce_table {
 	u32 window_size;
 	struct iommu_group *grp;		/* used for IOMMU groups */
 	struct file *vfio_filp;			/* used for IOMMU groups */
+	DECLARE_HASHTABLE(hash_tab, ilog2(64));	/* used for IOMMU groups */
+	spinlock_t hugepages_write_lock;	/* used for IOMMU groups */
 	struct page *pages[0];
 };
 
+/*
+ * The KVM guest can be backed with 16MB pages.
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
+#define KVMPPC_HUGEPAGE_HASH(gpa)	hash_32(gpa >> 24, 32)
+
+struct kvmppc_iommu_hugepage {
+	struct hlist_node hash_node;
+	unsigned long gpa;	/* Guest physical address */
+	unsigned long hpa;	/* Host physical address */
+	struct page *page;	/* page struct of the very first subpage */
+	unsigned long size;	/* Huge page size (always 16MB at the moment) */
+};
+
 struct kvmppc_linear_info {
 	void		*base_virt;
 	unsigned long	 base_pfn;
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index a5d0195..6cedfe9 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -47,6 +47,78 @@
 #define TCES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
 #define ERROR_ADDR      ((void *)~(unsigned long)0x0)
 
+#ifdef CONFIG_IOMMU_API
+/* Adds a new huge page descriptor to the hashtable */
+static long kvmppc_iommu_hugepage_try_add(
+		struct kvmppc_spapr_tce_table *tt,
+		pte_t pte, unsigned long hva, unsigned long gpa,
+		unsigned long pg_size)
+{
+	long ret = 0;
+	struct kvmppc_iommu_hugepage *hp;
+	struct page *pg;
+	unsigned key = KVMPPC_HUGEPAGE_HASH(gpa);
+
+	spin_lock(&tt->hugepages_write_lock);
+	hash_for_each_possible_rcu(tt->hash_tab, hp, hash_node, key) {
+		if (KVMPPC_HUGEPAGE_HASH(hp->gpa) != key)
+			continue;
+		if ((gpa < hp->gpa) || (gpa >= hp->gpa + hp->size))
+			continue;
+		goto unlock_exit;
+	}
+
+	hva = hva & ~(pg_size - 1);
+	ret = get_user_pages_fast(hva, 1, true/*write*/, &pg);
+	if ((ret != 1) || !pg) {
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
+	hp->page = pg;
+	hp->gpa = gpa & ~(pg_size - 1);
+	hp->hpa = (pte_pfn(pte) << PAGE_SHIFT);
+	hp->size = pg_size;
+
+	hash_add_rcu(tt->hash_tab, &hp->hash_node, key);
+
+unlock_exit:
+	spin_unlock(&tt->hugepages_write_lock);
+
+	return ret;
+}
+
+static void kvmppc_iommu_hugepages_init(struct kvmppc_spapr_tce_table *tt)
+{
+	spin_lock_init(&tt->hugepages_write_lock);
+	hash_init(tt->hash_tab);
+}
+
+static void kvmppc_iommu_hugepages_cleanup(struct kvmppc_spapr_tce_table *tt)
+{
+	int bkt;
+	struct kvmppc_iommu_hugepage *hp;
+	struct hlist_node *tmp;
+
+	spin_lock(&tt->hugepages_write_lock);
+	hash_for_each_safe(tt->hash_tab, bkt, tmp, hp, hash_node) {
+		hlist_del_rcu(&hp->hash_node);
+
+		put_page(hp->page); /* one for iommu_put_tce_user_mode */
+		put_page(hp->page); /* one for kvmppc_iommu_hugepage_try_add */
+		kfree(hp);
+	}
+	spin_unlock(&tt->hugepages_write_lock);
+}
+#endif /* CONFIG_IOMMU_API */
+
 static long kvmppc_stt_npages(unsigned long window_size)
 {
 	return ALIGN((window_size >> SPAPR_TCE_SHIFT)
@@ -108,6 +180,7 @@ static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 			fput(stt->vfio_filp);
 		}
 		iommu_group_put(stt->grp);
+		kvmppc_iommu_hugepages_cleanup(stt);
 	} else
 #endif
 		for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
@@ -277,6 +350,7 @@ long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
 	kvm_get_kvm(kvm);
 
 	mutex_lock(&kvm->lock);
+	kvmppc_iommu_hugepages_init(tt);
 	list_add(&tt->list, &kvm->arch.spapr_tce_tables);
 
 	mutex_unlock(&kvm->lock);
@@ -302,16 +376,31 @@ long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
 
 /* Converts guest physical address to host virtual address */
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
+#ifdef CONFIG_IOMMU_API
+	if (tt && (shift > PAGE_SHIFT)) {
+		if (kvmppc_iommu_hugepage_try_add(tt, *ptep,
+				hva, gpa, 1 << shift))
+			return ERROR_ADDR;
+	}
+#endif
 	return (void *) hva;
 }
 
@@ -351,7 +440,7 @@ long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
 			if (iommu_tce_put_param_check(tbl, ioba, tce))
 				return H_PARAMETER;
 
-			hva = kvmppc_virtmode_gpa_to_hva(vcpu, tce);
+			hva = kvmppc_virtmode_gpa_to_hva(vcpu, tt, tce);
 			if (hva == ERROR_ADDR)
 				return H_HARDWARE;
 
@@ -414,7 +503,7 @@ static long kvmppc_virtmode_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
 	/* Translate TCEs */
 	for (i = vcpu->arch.tce_tmp_num; i < npages; ++i) {
 		void *hva = kvmppc_virtmode_gpa_to_hva(vcpu,
-				vcpu->arch.tce_tmp[i]);
+				tt, vcpu->arch.tce_tmp[i]);
 
 		if (hva == ERROR_ADDR)
 			goto fail_clear_tce;
@@ -473,7 +562,7 @@ long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
-	tces = kvmppc_virtmode_gpa_to_hva(vcpu, tce_list);
+	tces = kvmppc_virtmode_gpa_to_hva(vcpu, NULL, tce_list);
 	if (tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 497daaf..c1db019 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -121,6 +121,7 @@ EXPORT_SYMBOL_GPL(kvmppc_emulated_put_tce);
  * returns ERROR_ADDR if failed.
  */
 static unsigned long kvmppc_realmode_gpa_to_hpa(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
 		unsigned long gpa)
 {
 	struct kvm_memory_slot *memslot;
@@ -129,6 +130,23 @@ static unsigned long kvmppc_realmode_gpa_to_hpa(struct kvm_vcpu *vcpu,
 	unsigned long gfn = gpa >> PAGE_SHIFT;
 	unsigned shift = 0;
 	struct page *pg;
+	struct kvmppc_iommu_hugepage *hp;
+
+	/* Try to find an already used hugepage */
+	if (tt) {
+		unsigned key = KVMPPC_HUGEPAGE_HASH(gpa);
+
+		hash_for_each_possible_rcu_notrace(tt->hash_tab, hp,
+				hash_node, key) {
+			if (KVMPPC_HUGEPAGE_HASH(hp->gpa) != key)
+				continue;
+
+			if ((gpa < hp->gpa) || (gpa >= hp->gpa + hp->size))
+				continue;
+
+			return hp->hpa + (gpa & (hp->size - 1));
+		}
+	}
 
 	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
 	if (!memslot)
@@ -252,7 +270,7 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			if (iommu_tce_put_param_check(tbl, ioba, tce))
 				return H_PARAMETER;
 
-			hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tce);
+			hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tt, tce);
 			if (hpa == ERROR_ADDR) {
 				vcpu->arch.tce_reason = H_TOO_HARD;
 				return H_TOO_HARD;
@@ -318,7 +336,7 @@ static long kvmppc_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
 	/* Translate TCEs and go get_page */
 	for (i = 0; i < npages; ++i) {
 		unsigned long hpa = kvmppc_realmode_gpa_to_hpa(vcpu,
-				vcpu->arch.tce_tmp[i]);
+				tt, vcpu->arch.tce_tmp[i]);
 		if (hpa == ERROR_ADDR) {
 			vcpu->arch.tce_tmp_num = i;
 			vcpu->arch.tce_reason = H_TOO_HARD;
@@ -374,7 +392,7 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	vcpu->arch.tce_tmp_num = 0;
 	vcpu->arch.tce_reason = 0;
 
-	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu, tce_list);
+	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu, tt, tce_list);
 	if ((unsigned long)tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
-- 
1.7.10.4

