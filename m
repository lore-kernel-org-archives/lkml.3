Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3F0FDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:03:54 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49942 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3F0FDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:03:51 -0400
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
Subject: [PATCH 7/8] KVM: PPC: Add support for IOMMU in-kernel handling
Date: Thu, 27 Jun 2013 15:02:35 +1000
Message-Id: <1372309356-28320-8-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
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
---
 Documentation/virtual/kvm/api.txt   |   26 ++++
 arch/powerpc/include/asm/kvm_host.h |    4 +
 arch/powerpc/include/asm/kvm_ppc.h  |    2 +
 arch/powerpc/include/uapi/asm/kvm.h |    8 +
 arch/powerpc/kvm/book3s_64_vio.c    |  294 ++++++++++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c |  165 ++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c          |   12 ++
 7 files changed, 509 insertions(+), 2 deletions(-)

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
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 3bf407b..716ab18 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -180,6 +180,8 @@ struct kvmppc_spapr_tce_table {
 	struct kvm *kvm;
 	u64 liobn;
 	u32 window_size;
+	struct iommu_group *grp;		/* used for IOMMU groups */
+	struct file *vfio_filp;			/* used for IOMMU groups */
 	struct page *pages[0];
 };
 
@@ -611,6 +613,8 @@ struct kvm_vcpu_arch {
 	u64 busy_preempt;
 
 	unsigned long *tce_tmp;    /* TCE cache for TCE_PUT_INDIRECT hcall */
+	unsigned long tce_tmp_num; /* Number of handled TCEs in the cache */
+	unsigned long tce_reason;  /* The reason of switching to the virtmode */
 #endif
 };
 
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index e852921b..934e01d 100644
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
index 0fb1a6e..7d0fc02 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -319,6 +319,14 @@ struct kvm_create_spapr_tce {
 	__u32 window_size;
 };
 
+/* for KVM_CAP_SPAPR_TCE_IOMMU */
+struct kvm_create_spapr_tce_iommu {
+	__u64 liobn;
+	__u32 fd;
+	__u32 iommu_id;
+	__u32 flags;
+};
+
 /* for KVM_ALLOCATE_RMA */
 struct kvm_allocate_rma {
 	__u64 rma_size;
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 45ee05a..a5d0195 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -27,6 +27,10 @@
 #include <linux/hugetlb.h>
 #include <linux/list.h>
 #include <linux/anon_inodes.h>
+#include <linux/pci.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/file.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -49,6 +53,47 @@ static long kvmppc_stt_npages(unsigned long window_size)
 		     * sizeof(u64), PAGE_SIZE) / PAGE_SIZE;
 }
 
+extern int vfio_group_add_external_user(struct file *filep);
+static int kvmppc_vfio_group_add_external_user(struct file *filep)
+{
+	int ret;
+	int (*proc)(struct file *) = symbol_get(vfio_group_add_external_user);
+
+	if (!proc)
+		return -EINVAL;
+
+	ret = proc(filep);
+	symbol_put(vfio_group_add_external_user);
+
+	return ret;
+}
+
+extern void vfio_group_del_external_user(struct file *filep);
+static void kvmppc_vfio_group_del_external_user(struct file *filep)
+{
+	void (*proc)(struct file *) = symbol_get(vfio_group_del_external_user);
+
+	if (!proc)
+		return;
+
+	proc(filep);
+	symbol_put(vfio_group_del_external_user);
+}
+
+extern int vfio_group_iommu_id_from_file(struct file *filep);
+static int kvmppc_vfio_group_iommu_id_from_file(struct file *filep)
+{
+	int ret;
+	int (*proc)(struct file *) = symbol_get(vfio_group_iommu_id_from_file);
+
+	if (!proc)
+		return -EINVAL;
+
+	ret = proc(filep);
+	symbol_put(vfio_group_iommu_id_from_file);
+
+	return ret;
+}
 static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 {
 	struct kvm *kvm = stt->kvm;
@@ -56,8 +101,17 @@ static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 
 	mutex_lock(&kvm->lock);
 	list_del(&stt->list);
-	for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
-		__free_page(stt->pages[i]);
+#ifdef CONFIG_IOMMU_API
+	if (stt->grp) {
+		if (stt->vfio_filp) {
+			kvmppc_vfio_group_del_external_user(stt->vfio_filp);
+			fput(stt->vfio_filp);
+		}
+		iommu_group_put(stt->grp);
+	} else
+#endif
+		for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
+			__free_page(stt->pages[i]);
 	kfree(stt);
 	mutex_unlock(&kvm->lock);
 
@@ -153,6 +207,99 @@ fail:
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
+	int ret;
+
+	/* Check this LIOBN hasn't been previously allocated */
+	list_for_each_entry(tt, &kvm->arch.spapr_tce_tables, list) {
+		if (tt->liobn == args->liobn)
+			return -EBUSY;
+	}
+
+        vfio_filp = fget(args->fd);
+	if (!vfio_filp)
+		return -ENXIO;
+
+	/* Lock the group */
+	ret = kvmppc_vfio_group_add_external_user(vfio_filp);
+	if (ret)
+		goto fput_exit;
+
+	/* Get IOMMU ID. Fails if group is not attached to IOMMU */
+	ret = kvmppc_vfio_group_iommu_id_from_file(vfio_filp);
+	if (ret < 0)
+		goto del_fput_exit;
+
+	if (ret != args->iommu_id) {
+		ret = -EINVAL;
+		goto del_fput_exit;
+	}
+
+	ret = -ENXIO;
+	/* Find an IOMMU table for the given ID */
+	grp = iommu_group_get_by_id(args->iommu_id);
+	if (!grp)
+		goto del_fput_exit;
+
+	tbl = iommu_group_get_iommudata(grp);
+	if (!tbl)
+		goto del_fput_exit;
+
+	tt = kzalloc(sizeof(*tt), GFP_KERNEL);
+	if (!tt)
+		goto del_fput_exit;
+
+	tt->liobn = args->liobn;
+	tt->kvm = kvm;
+	tt->grp = grp;
+	tt->window_size = tbl->it_size << IOMMU_PAGE_SHIFT;
+	tt->vfio_filp = vfio_filp;
+
+	pr_debug("LIOBN=%llX fd=%d hooked to IOMMU %d, flags=%u\n",
+			args->liobn, args->fd, args->iommu_id, args->flags);
+
+	ret = anon_inode_getfd("kvm-spapr-tce-iommu",
+			&kvm_spapr_tce_iommu_fops, tt, O_RDWR);
+	if (ret < 0)
+		goto free_del_fput_exit;
+
+	kvm_get_kvm(kvm);
+
+	mutex_lock(&kvm->lock);
+	list_add(&tt->list, &kvm->arch.spapr_tce_tables);
+
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+
+free_del_fput_exit:
+	kfree(tt);
+del_fput_exit:
+	kvmppc_vfio_group_del_external_user(vfio_filp);
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
 static void __user *kvmppc_virtmode_gpa_to_hva(struct kvm_vcpu *vcpu,
 		unsigned long gpa)
@@ -180,6 +327,47 @@ long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
 	if (!tt)
 		return H_TOO_HARD;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
+		struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+		/* Return error if the group is being destroyed */
+		if (!tbl)
+			return H_RESCINDED;
+
+		if (vcpu->arch.tce_reason == H_HARDWARE) {
+			iommu_clear_tces_and_put_pages(tbl, entry, 1);
+			return H_HARDWARE;
+
+		} else if (!(tce & (TCE_PCI_READ | TCE_PCI_WRITE))) {
+			if (iommu_tce_clear_param_check(tbl, ioba, 0, 1))
+				return H_PARAMETER;
+
+			ret = iommu_clear_tces_and_put_pages(tbl, entry, 1);
+		} else {
+			void *hva;
+
+			if (iommu_tce_put_param_check(tbl, ioba, tce))
+				return H_PARAMETER;
+
+			hva = kvmppc_virtmode_gpa_to_hva(vcpu, tce);
+			if (hva == ERROR_ADDR)
+				return H_HARDWARE;
+
+			ret = iommu_put_tce_user_mode(tbl,
+					ioba >> IOMMU_PAGE_SHIFT,
+					(unsigned long) hva);
+		}
+		iommu_flush_tce(tbl);
+
+		if (ret)
+			return H_HARDWARE;
+
+		return H_SUCCESS;
+	}
+#endif
+	/* Emulated IO */
 	if (ioba >= tt->window_size)
 		return H_PARAMETER;
 
@@ -192,6 +380,72 @@ long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
 	return H_SUCCESS;
 }
 
+static long kvmppc_virtmode_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt, unsigned long ioba,
+		unsigned long *tces, unsigned long npages)
+{
+	int i;
+	struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+	/* Return error if the group is being destroyed */
+	if (!tbl)
+		return H_RESCINDED;
+
+	/* Something bad happened, do cleanup and exit */
+	if (vcpu->arch.tce_reason == H_HARDWARE) {
+		i = vcpu->arch.tce_tmp_num;
+		goto fail_clear_tce;
+	} else if (vcpu->arch.tce_reason != H_TOO_HARD) {
+		/*
+		 * We get here in PR KVM mode or
+		 * when realmode_get_page() failed on tce_list.
+		 */
+		for (i = 0; i < npages; ++i) {
+			if (get_user(vcpu->arch.tce_tmp[i], tces + i))
+				return H_HARDWARE;
+
+			if (iommu_tce_put_param_check(tbl, ioba +
+						(i << IOMMU_PAGE_SHIFT),
+						vcpu->arch.tce_tmp[i]))
+				return H_PARAMETER;
+		}
+	} /* else: The real mode handler checked TCEs already */
+
+	/* Translate TCEs */
+	for (i = vcpu->arch.tce_tmp_num; i < npages; ++i) {
+		void *hva = kvmppc_virtmode_gpa_to_hva(vcpu,
+				vcpu->arch.tce_tmp[i]);
+
+		if (hva == ERROR_ADDR)
+			goto fail_clear_tce;
+
+		vcpu->arch.tce_tmp[i] = (unsigned long) hva;
+	}
+
+	/* Do get_page and put TCEs for all pages */
+	for (i = 0; i < npages; ++i) {
+		if (iommu_put_tce_user_mode(tbl,
+					(ioba >> IOMMU_PAGE_SHIFT) + i,
+					vcpu->arch.tce_tmp[i])) {
+			i = npages;
+			goto fail_clear_tce;
+		}
+	}
+
+	iommu_flush_tce(tbl);
+
+	return H_SUCCESS;
+
+fail_clear_tce:
+	/* Cannot complete the translation, clean up and exit */
+	iommu_clear_tces_and_put_pages(tbl, ioba >> IOMMU_PAGE_SHIFT, i);
+
+	iommu_flush_tce(tbl);
+
+	return H_HARDWARE;
+
+}
+
 long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		unsigned long liobn, unsigned long ioba,
 		unsigned long tce_list, unsigned long npages)
@@ -227,6 +481,14 @@ long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 			1, 0, &pg) != 1)
 		return H_TOO_HARD;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		ret = kvmppc_virtmode_h_put_tce_indirect_iommu(vcpu,
+			tt, ioba, tces, npages);
+		goto put_list_page_exit;
+	}
+#endif
+	/* Emulated IO */
 	for (i = 0; i < npages; ++i) {
 		if (get_user(vcpu->arch.tce_tmp[i], tces + i)) {
 			ret = H_PARAMETER;
@@ -259,6 +521,34 @@ long kvmppc_virtmode_h_stuff_tce(struct kvm_vcpu *vcpu,
 	if (!tt)
 		return H_TOO_HARD;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+		unsigned long tmp, entry = ioba >> IOMMU_PAGE_SHIFT;
+
+		vcpu->arch.tce_tmp_num = 0;
+
+		/* Return error if the group is being destroyed */
+		if (!tbl)
+			return H_RESCINDED;
+
+		/* PR KVM? */
+		if (!vcpu->arch.tce_tmp_num &&
+				(vcpu->arch.tce_reason != H_TOO_HARD) &&
+				iommu_tce_clear_param_check(tbl, ioba,
+						tce_value, npages))
+			return H_PARAMETER;
+
+		/* Do actual cleanup */
+		tmp = vcpu->arch.tce_tmp_num;
+		if (iommu_clear_tces_and_put_pages(tbl, entry + tmp,
+				npages - tmp))
+			return H_PARAMETER;
+
+		return H_SUCCESS;
+	}
+#endif
+	/* Emulated IO */
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 108cc08..497daaf 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/hugetlb.h>
 #include <linux/list.h>
+#include <linux/iommu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -189,6 +190,41 @@ static long kvmppc_realmode_put_hpa(unsigned long hpa, bool dirty)
 	return H_SUCCESS;
 }
 
+#ifdef CONFIG_IOMMU_API
+static long kvmppc_realmode_clear_tce(struct kvm_vcpu *vcpu,
+		struct iommu_table *tbl, unsigned long ioba,
+		unsigned long tce_value, unsigned long npages)
+{
+	long ret = 0, i;
+	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
+
+	if (iommu_tce_clear_param_check(tbl, ioba, tce_value, npages))
+		return H_PARAMETER;
+
+	for (i = 0; i < npages; ++i) {
+		unsigned long oldtce;
+
+		oldtce = iommu_clear_tce(tbl, entry + i);
+		if (!oldtce)
+			continue;
+
+		ret = kvmppc_realmode_put_hpa(oldtce, oldtce & TCE_PCI_WRITE);
+		if (ret)
+			break;
+	}
+
+	if (ret == H_TOO_HARD) {
+		vcpu->arch.tce_tmp_num = i;
+		vcpu->arch.tce_reason = H_TOO_HARD;
+	}
+	/* if (ret < 0)
+		pr_err("iommu_tce: %s failed ioba=%lx, tce_value=%lx ret=%ld\n",
+				__func__, ioba, tce_value, ret); */
+
+	return ret;
+}
+#endif /* CONFIG_IOMMU_API */
+
 long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 		      unsigned long ioba, unsigned long tce)
 {
@@ -200,6 +236,53 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	if (!tt)
 		return H_TOO_HARD;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+		/* Return error if the group is being destroyed */
+		if (!tbl)
+			return H_RESCINDED;
+
+		vcpu->arch.tce_reason = 0;
+
+		if (tce & (TCE_PCI_READ | TCE_PCI_WRITE)) {
+			unsigned long hpa, hva;
+
+			if (iommu_tce_put_param_check(tbl, ioba, tce))
+				return H_PARAMETER;
+
+			hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tce);
+			if (hpa == ERROR_ADDR) {
+				vcpu->arch.tce_reason = H_TOO_HARD;
+				return H_TOO_HARD;
+			}
+
+			hva = (unsigned long) __va(hpa);
+			ret = iommu_tce_build(tbl,
+					ioba >> IOMMU_PAGE_SHIFT,
+					hva, iommu_tce_direction(hva));
+			if (unlikely(ret)) {
+				ret = kvmppc_realmode_put_hpa(hpa,
+						tce & TCE_PCI_WRITE);
+				if (ret) {
+					vcpu->arch.tce_reason = H_HARDWARE;
+					return H_TOO_HARD;
+				}
+				return H_HARDWARE;
+			}
+		} else {
+			ret = kvmppc_realmode_clear_tce(vcpu, tbl, ioba, 0, 1);
+			if (ret)
+				return ret;
+		}
+
+		iommu_flush_tce(tbl);
+
+		return H_SUCCESS;
+	}
+#endif
+	/* Emulated IO */
 	if (ioba >= tt->window_size)
 		return H_PARAMETER;
 
@@ -212,6 +295,56 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	return H_SUCCESS;
 }
 
+static long kvmppc_h_put_tce_indirect_iommu(struct kvm_vcpu *vcpu,
+		struct kvmppc_spapr_tce_table *tt, unsigned long ioba,
+		unsigned long *tces, unsigned long npages)
+{
+	int i;
+	struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+	/* Return error if the group is being destroyed */
+	if (!tbl)
+		return H_RESCINDED;
+
+	/* Check all TCEs */
+	for (i = 0; i < npages; ++i) {
+		if (iommu_tce_put_param_check(tbl, ioba +
+				(i << IOMMU_PAGE_SHIFT), tces[i]))
+			return H_PARAMETER;
+
+		vcpu->arch.tce_tmp[i] = tces[i];
+	}
+
+	/* Translate TCEs and go get_page */
+	for (i = 0; i < npages; ++i) {
+		unsigned long hpa = kvmppc_realmode_gpa_to_hpa(vcpu,
+				vcpu->arch.tce_tmp[i]);
+		if (hpa == ERROR_ADDR) {
+			vcpu->arch.tce_tmp_num = i;
+			vcpu->arch.tce_reason = H_TOO_HARD;
+			return H_TOO_HARD;
+		}
+		vcpu->arch.tce_tmp[i] = hpa;
+	}
+
+	/* Put TCEs to the table */
+	for (i = 0; i < npages; ++i) {
+		unsigned long hva = (unsigned long)
+			__va(vcpu->arch.tce_tmp[i]);
+		if (iommu_tce_build(tbl,
+				(ioba >> IOMMU_PAGE_SHIFT) + i,
+				hva, iommu_tce_direction(hva))) {
+			/* All wrong, go virtmode and do cleanup */
+			vcpu->arch.tce_reason = H_HARDWARE;
+			return H_TOO_HARD;
+		}
+	}
+
+	iommu_flush_tce(tbl);
+
+	return H_SUCCESS;
+}
+
 long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		unsigned long liobn, unsigned long ioba,
 		unsigned long tce_list,	unsigned long npages)
@@ -238,10 +371,21 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
 
+	vcpu->arch.tce_tmp_num = 0;
+	vcpu->arch.tce_reason = 0;
+
 	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu, tce_list);
 	if ((unsigned long)tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		ret = kvmppc_h_put_tce_indirect_iommu(vcpu,
+			tt, ioba, tces, npages);
+		goto put_list_page_exit;
+	}
+#endif
+	/* Emulated IO */
 	for (i = 0; i < npages; ++i) {
 		ret = kvmppc_emulated_validate_tce(tces[i]);
 		if (ret)
@@ -273,6 +417,27 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 	if (!tt)
 		return H_TOO_HARD;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+		/* Return error if the group is being destroyed */
+		if (!tbl)
+			return H_RESCINDED;
+
+		vcpu->arch.tce_reason = 0;
+
+		ret = kvmppc_realmode_clear_tce(vcpu, tbl, ioba,
+				tce_value, npages);
+		if (ret)
+			return ret;
+
+		iommu_flush_tce(tbl);
+
+		return H_SUCCESS;
+	}
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
1.7.10.4

