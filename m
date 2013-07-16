Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab3GPAzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:55:41 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60061 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321Ab3GPAzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:55:35 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 10/10] KVM: PPC: Add hugepage support for IOMMU in-kernel handling
Date: Tue, 16 Jul 2013 10:54:05 +1000
Message-Id: <1373936045-22653-11-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
References: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds special support for huge pages (16MB) in real mode.

The reference counting cannot be easily done for such pages in real
mode (when MMU is off) so we added a hash table of huge pages.
It is populated in virtual mode and get_page is called just once
per a huge page. Real mode handlers check if the requested page is
in the hash table, then no reference counting is done, otherwise
an exit to virtual mode happens. The hash table is released at KVM
exit.

At the moment the fastest card available for tests uses up to 9 huge
pages so walking through this hash table does not cost much.
However this can change and we may want to optimize this.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

---

Changes:
2013/07/12:
* removed multiple #ifdef IOMMU_API as IOMMU_API is always enabled
for KVM_BOOK3S_64

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

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/kvm_host.h |  25 ++++++++
 arch/powerpc/kernel/iommu.c         |   6 +-
 arch/powerpc/kvm/book3s_64_vio.c    | 123 ++++++++++++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_64_vio_hv.c |  32 +++++++++-
 4 files changed, 176 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 4eeaf7d..c57b25a 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -31,6 +31,7 @@
 #include <linux/list.h>
 #include <linux/atomic.h>
 #include <linux/tracepoint.h>
+#include <linux/hashtable.h>
 #include <asm/kvm_asm.h>
 #include <asm/processor.h>
 #include <asm/page.h>
@@ -183,9 +184,33 @@ struct kvmppc_spapr_tce_table {
 	u32 window_size;
 	struct iommu_group *grp;		/* used for IOMMU groups */
 	struct vfio_group *vfio_grp;		/* used for IOMMU groups */
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
+#define KVMPPC_SPAPR_HUGEPAGE_HASH(gpa)	hash_32(gpa >> 24, 32)
+
+struct kvmppc_spapr_iommu_hugepage {
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
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 0f56cac..bb54cc2 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -999,7 +999,8 @@ int iommu_free_tces(struct iommu_table *tbl, unsigned long entry,
 			if (!pg) {
 				ret = -EAGAIN;
 			} else if (PageCompound(pg)) {
-				ret = -EAGAIN;
+				/* Hugepages will be released at KVM exit */
+				ret = 0;
 			} else {
 				if (oldtce & TCE_PCI_WRITE)
 					SetPageDirty(pg);
@@ -1009,6 +1010,9 @@ int iommu_free_tces(struct iommu_table *tbl, unsigned long entry,
 			struct page *pg = pfn_to_page(oldtce >> PAGE_SHIFT);
 			if (!pg) {
 				ret = -EAGAIN;
+			} else if (PageCompound(pg)) {
+				/* Hugepages will be released at KVM exit */
+				ret = 0;
 			} else {
 				if (oldtce & TCE_PCI_WRITE)
 					SetPageDirty(pg);
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 125fc23..a74a319 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -93,6 +93,102 @@ int kvmppc_vfio_external_user_iommu_id(struct vfio_group *group)
 	return ret;
 }
 
+/*
+ * API to support huge pages in real mode
+ */
+static void kvmppc_iommu_hugepages_init(struct kvmppc_spapr_tce_table *tt)
+{
+	spin_lock_init(&tt->hugepages_write_lock);
+	hash_init(tt->hash_tab);
+}
+
+static void kvmppc_iommu_hugepages_cleanup(struct kvmppc_spapr_tce_table *tt)
+{
+	int bkt;
+	struct kvmppc_spapr_iommu_hugepage *hp;
+	struct hlist_node *tmp;
+
+	spin_lock(&tt->hugepages_write_lock);
+	hash_for_each_safe(tt->hash_tab, bkt, tmp, hp, hash_node) {
+		pr_debug("Release HP liobn=%llx #%u gpa=%lx hpa=%lx size=%ld\n",
+				tt->liobn, bkt, hp->gpa, hp->hpa, hp->size);
+		hlist_del_rcu(&hp->hash_node);
+
+		put_page(hp->page);
+		kfree(hp);
+	}
+	spin_unlock(&tt->hugepages_write_lock);
+}
+
+/* Returns true if a page with GPA is already in the hash table */
+static bool kvmppc_iommu_hugepage_lookup_gpa(struct kvmppc_spapr_tce_table *tt,
+		unsigned long gpa)
+{
+	struct kvmppc_spapr_iommu_hugepage *hp;
+	const unsigned key = KVMPPC_SPAPR_HUGEPAGE_HASH(gpa);
+
+	hash_for_each_possible_rcu(tt->hash_tab, hp, hash_node, key) {
+		if ((gpa < hp->gpa) || (gpa >= hp->gpa + hp->size))
+			continue;
+
+		return true;
+	}
+
+	return false;
+}
+
+/* Returns true if a page with GPA has been added to the hash table */
+static bool kvmppc_iommu_hugepage_add(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
+		unsigned long hva, unsigned long gpa)
+{
+	struct kvmppc_spapr_iommu_hugepage *hp;
+	const unsigned key = KVMPPC_SPAPR_HUGEPAGE_HASH(gpa);
+	pte_t *ptep;
+	unsigned int shift = 0;
+	static const int is_write = 1;
+
+	ptep = find_linux_pte_or_hugepte(vcpu->arch.pgdir, hva, &shift);
+	WARN_ON(!ptep);
+
+	if (!ptep || (shift <= PAGE_SHIFT))
+		return false;
+
+	hp = kzalloc(sizeof(*hp), GFP_KERNEL);
+	if (!hp)
+		return false;
+
+	hp->gpa = gpa & ~((1 << shift) - 1);
+	hp->hpa = (pte_pfn(*ptep) << PAGE_SHIFT);
+	hp->size = 1 << shift;
+
+	if (get_user_pages_fast(hva & ~(hp->size - 1), 1,
+			is_write, &hp->page) != 1) {
+		kfree(hp);
+		return false;
+	}
+	hash_add_rcu(tt->hash_tab, &hp->hash_node, key);
+
+	return true;
+}
+
+/** Returns true if a page with GPA is in the hash table or
+ *  has just been added.
+ */
+static bool kvmppc_iommu_hugepage_try_add(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
+		unsigned long hva, unsigned long gpa)
+{
+	bool ret;
+
+	spin_lock(&tt->hugepages_write_lock);
+	ret = kvmppc_iommu_hugepage_lookup_gpa(tt, gpa) ||
+			kvmppc_iommu_hugepage_add(vcpu, tt, hva, gpa);
+	spin_unlock(&tt->hugepages_write_lock);
+
+	return ret;
+}
+
 static long kvmppc_stt_npages(unsigned long window_size)
 {
 	return ALIGN((window_size >> SPAPR_TCE_SHIFT)
@@ -106,6 +202,7 @@ static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 
 	mutex_lock(&kvm->lock);
 	list_del(&stt->list);
+	kvmppc_iommu_hugepages_cleanup(stt);
 
 	if (stt->grp) {
 		if (stt->vfio_grp)
@@ -192,6 +289,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 	kvm_get_kvm(kvm);
 
 	mutex_lock(&kvm->lock);
+	kvmppc_iommu_hugepages_init(stt);
 	list_add(&stt->list, &kvm->arch.spapr_tce_tables);
 
 	mutex_unlock(&kvm->lock);
@@ -273,6 +371,7 @@ long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
 
 	/* Add the TCE table descriptor to the descriptor list */
 	mutex_lock(&kvm->lock);
+	kvmppc_iommu_hugepages_init(tt);
 	list_add(&tt->list, &kvm->arch.spapr_tce_tables);
 	mutex_unlock(&kvm->lock);
 
@@ -293,6 +392,7 @@ fput_exit:
  * Also returns host physical address which is to put to TCE table.
  */
 static void __user *kvmppc_gpa_to_hva_and_get(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
 		unsigned long gpa, struct page **pg, unsigned long *phpa)
 {
 	unsigned long hva, gfn = gpa >> PAGE_SHIFT;
@@ -312,6 +412,17 @@ static void __user *kvmppc_gpa_to_hva_and_get(struct kvm_vcpu *vcpu,
 		*phpa = __pa((unsigned long) page_address(*pg)) |
 				(hva & ~PAGE_MASK);
 
+	if (PageCompound(*pg)) {
+		/** Check if this GPA is taken care of by the hash table.
+		 *  If this is the case, do not show the caller page struct
+		 *  address as huge pages will be released at KVM exit.
+		 */
+		if (kvmppc_iommu_hugepage_try_add(vcpu, tt, hva, gpa)) {
+			put_page(*pg);
+			*pg = NULL;
+		}
+	}
+
 	return (void *) hva;
 }
 
@@ -349,7 +460,7 @@ long kvmppc_h_put_tce_iommu(struct kvm_vcpu *vcpu,
 		if (iommu_tce_put_param_check(tbl, ioba, tce))
 			return H_PARAMETER;
 
-		hva = kvmppc_gpa_to_hva_and_get(vcpu, tce, &pg, &hpa);
+		hva = kvmppc_gpa_to_hva_and_get(vcpu, tt, tce, &pg, &hpa);
 		if (hva == ERROR_ADDR)
 			return H_HARDWARE;
 	}
@@ -358,7 +469,7 @@ long kvmppc_h_put_tce_iommu(struct kvm_vcpu *vcpu,
 		return H_SUCCESS;
 
 	pg = pfn_to_page(hpa >> PAGE_SHIFT);
-	if (pg)
+	if (pg && !PageCompound(pg))
 		put_page(pg);
 
 	return H_HARDWARE;
@@ -400,7 +511,7 @@ static long kvmppc_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
 					(i << IOMMU_PAGE_SHIFT), gpa))
 			return H_PARAMETER;
 
-		hva = kvmppc_gpa_to_hva_and_get(vcpu, gpa, &pg,
+		hva = kvmppc_gpa_to_hva_and_get(vcpu, tt, gpa, &pg,
 				&vcpu->arch.tce_tmp_hpas[i]);
 		if (hva == ERROR_ADDR)
 			goto putpages_flush_exit;
@@ -415,7 +526,7 @@ putpages_flush_exit:
 	for ( --i; i >= 0; --i) {
 		struct page *pg;
 		pg = pfn_to_page(vcpu->arch.tce_tmp_hpas[i] >> PAGE_SHIFT);
-		if (pg)
+		if (pg && !PageCompound(pg))
 			put_page(pg);
 	}
 
@@ -495,7 +606,7 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
-	tces = kvmppc_gpa_to_hva_and_get(vcpu, tce_list, &pg, NULL);
+	tces = kvmppc_gpa_to_hva_and_get(vcpu, tt, tce_list, &pg, NULL);
 	if (tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
@@ -524,7 +635,7 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		kvmppc_tce_put(tt, ioba + (i << IOMMU_PAGE_SHIFT),
 				vcpu->arch.tce_tmp_hpas[i]);
 put_list_page_exit:
-	if (pg)
+	if (pg && !PageCompound(pg))
 		put_page(pg);
 
 	if (vcpu->arch.tce_rm_fail != TCERM_NONE) {
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index d898c14..81ea15c 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -133,12 +133,30 @@ void kvmppc_tce_put(struct kvmppc_spapr_tce_table *tt,
 EXPORT_SYMBOL_GPL(kvmppc_tce_put);
 
 #ifdef CONFIG_KVM_BOOK3S_64_HV
+
+static unsigned long kvmppc_rm_hugepage_gpa_to_hpa(
+		struct kvmppc_spapr_tce_table *tt,
+		unsigned long gpa)
+{
+	struct kvmppc_spapr_iommu_hugepage *hp;
+	const unsigned key = KVMPPC_SPAPR_HUGEPAGE_HASH(gpa);
+
+	hash_for_each_possible_rcu_notrace(tt->hash_tab, hp, hash_node, key) {
+		if ((gpa < hp->gpa) || (gpa >= hp->gpa + hp->size))
+			continue;
+		return hp->hpa + (gpa & (hp->size - 1));
+	}
+
+	return ERROR_ADDR;
+}
+
 /*
  * Converts guest physical address to host physical address.
  * Tries to increase page counter via realmode_get_page() and
  * returns ERROR_ADDR if failed.
  */
 static unsigned long kvmppc_rm_gpa_to_hpa_and_get(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt,
 		unsigned long gpa, struct page **pg)
 {
 	struct kvm_memory_slot *memslot;
@@ -147,6 +165,14 @@ static unsigned long kvmppc_rm_gpa_to_hpa_and_get(struct kvm_vcpu *vcpu,
 	unsigned long gfn = gpa >> PAGE_SHIFT;
 	unsigned shift = 0;
 
+	/* Check if it is a hugepage */
+	hpa = kvmppc_rm_hugepage_gpa_to_hpa(tt, gpa);
+	if (hpa != ERROR_ADDR) {
+		*pg = NULL; /* Tell the caller not to put page */
+		return hpa;
+	}
+
+	/* System page size case */
 	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
 	if (!memslot)
 		return ERROR_ADDR;
@@ -215,7 +241,7 @@ static long kvmppc_rm_h_put_tce_iommu(struct kvm_vcpu *vcpu,
 	if (iommu_tce_put_param_check(tbl, ioba, tce))
 		return H_PARAMETER;
 
-	hpa = kvmppc_rm_gpa_to_hpa_and_get(vcpu, tce, &pg);
+	hpa = kvmppc_rm_gpa_to_hpa_and_get(vcpu, tt, tce, &pg);
 	if (hpa == ERROR_ADDR)
 		return H_TOO_HARD;
 
@@ -254,7 +280,7 @@ static long kvmppc_rm_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
 
 	/* Translate TCEs and go get_page() */
 	for (i = 0; i < npages; ++i) {
-		hpa = kvmppc_rm_gpa_to_hpa_and_get(vcpu, tces[i], &pg);
+		hpa = kvmppc_rm_gpa_to_hpa_and_get(vcpu, tt, tces[i], &pg);
 		if (hpa == ERROR_ADDR) {
 			vcpu->arch.tce_tmp_num = i;
 			vcpu->arch.tce_rm_fail = TCERM_GETPAGE;
@@ -345,7 +371,7 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
-	tces = kvmppc_rm_gpa_to_hpa_and_get(vcpu, tce_list, &pg);
+	tces = kvmppc_rm_gpa_to_hpa_and_get(vcpu, tt, tce_list, &pg);
 	if (tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
-- 
1.8.3.2

