Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab3GPAzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:55:32 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52969 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139Ab3GPAzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:55:21 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 09/10] KVM: PPC: Add support for IOMMU in-kernel handling
Date: Tue, 16 Jul 2013 10:54:04 +1000
Message-Id: <1373936045-22653-10-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
References: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the host kernel to handle H_PUT_TCE, H_PUT_TCE_INDIRECT
and H_STUFF_TCE requests targeted an IOMMU TCE table without passing
them to user space which saves time on switching to user space and back.

Both real and virtual modes are supported. The kernel tries to
handle a TCE request in the real mode, if fails it passes the request
to the virtual mode to complete the operation. If it a virtual mode
handler fails, the request is passed to user space.

The first user of this is VFIO on POWER. The external user API in VFIO
is required for this patch. The patch adds a new KVM_CAP_SPAPR_TCE_IOMMU
ioctl to associate a virtual PCI bus number (LIOBN) with an VFIO IOMMU
group fd and enable in-kernel handling of map/unmap requests.

Tests show that this patch increases transmission speed from 220MB/s
to 750..1020MB/s on 10Gb network (Chelsea CXGB3 10Gb ethernet card).

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

---

Changes:
2013/07/11:
* removed multiple #ifdef IOMMU_API as IOMMU_API is always enabled
for KVM_BOOK3S_64
* kvmppc_gpa_to_hva_and_get also returns host phys address. Not much sense
for this here but the next patch for hugepages support will use it more.

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
 arch/powerpc/include/asm/kvm_host.h |   3 +
 arch/powerpc/include/asm/kvm_ppc.h  |   2 +
 arch/powerpc/include/uapi/asm/kvm.h |   7 +
 arch/powerpc/kvm/book3s_64_vio.c    | 296 +++++++++++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c | 124 +++++++++++++++
 arch/powerpc/kvm/powerpc.c          |  12 ++
 7 files changed, 465 insertions(+), 5 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 1c8942a..6ae65bd 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2408,6 +2408,32 @@ an implementation for these despite the in kernel acceleration.
 This capability is always enabled.
 
 
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
+	__u32 fd;
+	__u32 flags;
+};
+
+This creates a link between IOMMU group and a hardware TCE (translation
+control entry) table. This link lets the host kernel know what IOMMU
+group (i.e. TCE table) to use for the LIOBN number passed with
+H_PUT_TCE, H_PUT_TCE_INDIRECT, H_STUFF_TCE hypercalls.
+
+User space passes VFIO group fd. Using the external user VFIO API,
+KVM tries gets IOMMU id from passed fd. If succeeded, acceleration
+turns on. If failed, map/unmap requests are passed to user space.
+
+No flag is supported at the moment.
+
+
 5. The kvm_run structure
 ------------------------
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index b8fe3de..4eeaf7d 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -181,6 +181,8 @@ struct kvmppc_spapr_tce_table {
 	struct kvm *kvm;
 	u64 liobn;
 	u32 window_size;
+	struct iommu_group *grp;		/* used for IOMMU groups */
+	struct vfio_group *vfio_grp;		/* used for IOMMU groups */
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
index 0ce4691..297cab5 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -133,6 +133,8 @@ extern int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu);
 
 extern long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 				struct kvm_create_spapr_tce *args);
+extern long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
+				struct kvm_create_spapr_tce_iommu *args);
 extern struct kvmppc_spapr_tce_table *kvmppc_find_tce_table(
 		struct kvm_vcpu *vcpu, unsigned long liobn);
 extern long kvmppc_tce_validate(unsigned long tce);
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
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 0131bf9..125fc23 100644
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
@@ -42,6 +46,53 @@
 
 #define ERROR_ADDR      ((void *)~(unsigned long)0x0)
 
+/*
+ * Dynamically linked version of the external user VFIO API.
+ *
+ * As a IOMMU group access control is implemented by VFIO,
+ * there is some API to vefiry that specific process can own
+ * a group. As KVM may run when VFIO is not loaded, KVM is not
+ * linked statically to VFIO, instead wrappers are used.
+ */
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
 static long kvmppc_stt_npages(unsigned long window_size)
 {
 	return ALIGN((window_size >> SPAPR_TCE_SHIFT)
@@ -55,8 +106,15 @@ static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 
 	mutex_lock(&kvm->lock);
 	list_del(&stt->list);
-	for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
-		__free_page(stt->pages[i]);
+
+	if (stt->grp) {
+		if (stt->vfio_grp)
+			kvmppc_vfio_group_put_external_user(stt->vfio_grp);
+		iommu_group_put(stt->grp);
+	} else
+		for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
+			__free_page(stt->pages[i]);
+
 	kfree(stt);
 	mutex_unlock(&kvm->lock);
 
@@ -152,9 +210,90 @@ fail:
 	return ret;
 }
 
-/* Converts guest physical address to host virtual address */
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
+	/* Check this LIOBN hasn't been previously registered */
+	list_for_each_entry(tt, &kvm->arch.spapr_tce_tables, list) {
+		if (tt->liobn == args->liobn)
+			return -EBUSY;
+	}
+
+	vfio_filp = fget(args->fd);
+	if (!vfio_filp)
+		return -ENXIO;
+
+	/* Lock the group. Fails if group is not viable or does not have IOMMU set */
+	vfio_grp = kvmppc_vfio_group_get_external_user(vfio_filp);
+	if (IS_ERR_VALUE((unsigned long)vfio_grp))
+		goto fput_exit;
+
+	/* Get IOMMU ID, find iommu_group and iommu_table*/
+	iommu_id = kvmppc_vfio_external_user_iommu_id(vfio_grp);
+	if (iommu_id < 0)
+		goto grpput_fput_exit;
+
+	ret = -ENXIO;
+	grp = iommu_group_get_by_id(iommu_id);
+	if (!grp)
+		goto grpput_fput_exit;
+
+	tbl = iommu_group_get_iommudata(grp);
+	if (!tbl)
+		goto grpput_fput_exit;
+
+	/* Create a TCE table descriptor and add into the descriptor list */
+	tt = kzalloc(sizeof(*tt), GFP_KERNEL);
+	if (!tt)
+		goto grpput_fput_exit;
+
+	tt->liobn = args->liobn;
+	kvm_get_kvm(kvm);
+	tt->kvm = kvm;
+	tt->grp = grp;
+	tt->window_size = tbl->it_size << IOMMU_PAGE_SHIFT;
+	tt->vfio_grp = vfio_grp;
+
+	/* Create an inode to provide automatic cleanup upon exit */
+	ret = anon_inode_getfd("kvm-spapr-tce-iommu",
+			&kvm_spapr_tce_iommu_fops, tt, O_RDWR);
+	if (ret < 0)
+		goto free_grpput_fput_exit;
+
+	/* Add the TCE table descriptor to the descriptor list */
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
+
+/*
+ * Converts guest physical address to host virtual address.
+ * Also returns host physical address which is to put to TCE table.
+ */
 static void __user *kvmppc_gpa_to_hva_and_get(struct kvm_vcpu *vcpu,
-		unsigned long gpa, struct page **pg)
+		unsigned long gpa, struct page **pg, unsigned long *phpa)
 {
 	unsigned long hva, gfn = gpa >> PAGE_SHIFT;
 	struct kvm_memory_slot *memslot;
@@ -169,9 +308,140 @@ static void __user *kvmppc_gpa_to_hva_and_get(struct kvm_vcpu *vcpu,
 	if (get_user_pages_fast(hva & PAGE_MASK, 1, is_write, pg) != 1)
 		return ERROR_ADDR;
 
+	if (phpa)
+		*phpa = __pa((unsigned long) page_address(*pg)) |
+				(hva & ~PAGE_MASK);
+
 	return (void *) hva;
 }
 
+long kvmppc_h_put_tce_iommu(struct kvm_vcpu *vcpu,
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
+		/* Retry iommu_tce_build if it failed in real mode */
+		vcpu->arch.tce_rm_fail = TCERM_NONE;
+		hpa = vcpu->arch.tce_tmp_hpas[0];
+	} else {
+		if (iommu_tce_put_param_check(tbl, ioba, tce))
+			return H_PARAMETER;
+
+		hva = kvmppc_gpa_to_hva_and_get(vcpu, tce, &pg, &hpa);
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
+static long kvmppc_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
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
+		hva = kvmppc_gpa_to_hva_and_get(vcpu, gpa, &pg,
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
+long kvmppc_h_stuff_tce_iommu(struct kvm_vcpu *vcpu,
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
+
 long kvmppc_h_put_tce(struct kvm_vcpu *vcpu,
 		unsigned long liobn, unsigned long ioba,
 		unsigned long tce)
@@ -183,6 +453,10 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu,
 	if (!tt)
 		return H_TOO_HARD;
 
+	if (tt->grp)
+		return kvmppc_h_put_tce_iommu(vcpu, tt, liobn, ioba, tce);
+
+	/* Emulated IO */
 	if (ioba >= tt->window_size)
 		return H_PARAMETER;
 
@@ -221,13 +495,20 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
-	tces = kvmppc_gpa_to_hva_and_get(vcpu, tce_list, &pg);
+	tces = kvmppc_gpa_to_hva_and_get(vcpu, tce_list, &pg, NULL);
 	if (tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
 	if (vcpu->arch.tce_rm_fail == TCERM_PUTLIST)
 		goto put_list_page_exit;
 
+	if (tt->grp) {
+		ret = kvmppc_h_put_tce_indirect_iommu(vcpu,
+			tt, ioba, tces, npages);
+		goto put_list_page_exit;
+	}
+
+	/* Emulated IO */
 	for (i = 0; i < npages; ++i) {
 		if (get_user(vcpu->arch.tce_tmp_hpas[i], tces + i)) {
 			ret = H_PARAMETER;
@@ -266,6 +547,11 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 	if (!tt)
 		return H_TOO_HARD;
 
+	if (tt->grp)
+		return kvmppc_h_stuff_tce_iommu(vcpu, tt, liobn, ioba,
+				tce_value, npages);
+
+	/* Emulated IO */
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 9b0372f..d898c14 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/hugetlb.h>
 #include <linux/list.h>
+#include <linux/iommu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -187,6 +188,113 @@ static unsigned long kvmppc_rm_gpa_to_hpa_and_get(struct kvm_vcpu *vcpu,
 	return hpa;
 }
 
+static long kvmppc_rm_h_put_tce_iommu(struct kvm_vcpu *vcpu,
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
+static long kvmppc_rm_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
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
+static long kvmppc_rm_h_stuff_tce_iommu(struct kvm_vcpu *vcpu,
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
+
 long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 		      unsigned long ioba, unsigned long tce)
 {
@@ -197,6 +305,10 @@ long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	if (!tt)
 		return H_TOO_HARD;
 
+	if (tt->grp)
+		return kvmppc_rm_h_put_tce_iommu(vcpu, tt, liobn, ioba, tce);
+
+	/* Emulated IO */
 	if (ioba >= tt->window_size)
 		return H_PARAMETER;
 
@@ -237,6 +349,13 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if (tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
+	if (tt->grp) {
+		ret = kvmppc_rm_h_put_tce_indirect_iommu(vcpu,
+			tt, ioba, (unsigned long *)tces, npages);
+		goto put_unlock_exit;
+	}
+
+	/* Emulated IO */
 	for (i = 0; i < npages; ++i) {
 		ret = kvmppc_tce_validate(((unsigned long *)tces)[i]);
 		if (ret)
@@ -267,6 +386,11 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 	if (!tt)
 		return H_TOO_HARD;
 
+	if (tt->grp)
+		return kvmppc_rm_h_stuff_tce_iommu(vcpu, tt, liobn, ioba,
+				tce_value, npages);
+
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

