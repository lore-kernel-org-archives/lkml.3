Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3EUDH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:07:57 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:43640 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3EUDHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:07:20 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
Date: Tue, 21 May 2013 13:06:46 +1000
Message-Id: <1369105607-20957-4-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369105607-20957-1-git-send-email-aik@ozlabs.ru>
References: <1369105607-20957-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the host kernel to handle H_PUT_TCE, H_PUT_TCE_INDIRECT
and H_STUFF_TCE requests without passing them to QEMU, which should
save time on switching to QEMU and back.

Both real and virtual modes are supported - whenever the kernel
fails to handle TCE request, it passes it to the virtual mode.
If it the virtual mode handlers fail, then the request is passed
to the user mode, for example, to QEMU.

This adds a new KVM_CAP_SPAPR_TCE_IOMMU ioctl to asssociate
a virtual PCI bus ID (LIOBN) with an IOMMU group, which enables
in-kernel handling of IOMMU map/unmap.

Tests show that this patch increases transmission speed from 220MB/s
to 750..1020MB/s on 10Gb network (Chelsea CXGB3 10Gb ethernet card).

Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Paul Mackerras <paulus@samba.org>

---

Changes:
2013-05-20:
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
 Documentation/virtual/kvm/api.txt   |   28 +++++
 arch/powerpc/include/asm/kvm_host.h |    3 +
 arch/powerpc/include/asm/kvm_ppc.h  |    2 +
 arch/powerpc/include/uapi/asm/kvm.h |    7 ++
 arch/powerpc/kvm/book3s_64_vio.c    |  198 ++++++++++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c |  193 +++++++++++++++++++++++++++++++++-
 arch/powerpc/kvm/powerpc.c          |   12 +++
 include/uapi/linux/kvm.h            |    4 +
 8 files changed, 441 insertions(+), 6 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 3c7c7ea..3c8e9fe 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2362,6 +2362,34 @@ calls by the guest for that service will be passed to userspace to be
 handled.
 
 
+4.79 KVM_CREATE_SPAPR_TCE_IOMMU
+
+Capability: KVM_CAP_SPAPR_TCE_IOMMU
+Architectures: powerpc
+Type: vm ioctl
+Parameters: struct kvm_create_spapr_tce_iommu (in)
+Returns: 0 on success, -1 on error
+
+This creates a link between IOMMU group and a hardware TCE (translation
+control entry) table. This link lets the host kernel know what IOMMU
+group (i.e. TCE table) to use for the LIOBN number passed with
+H_PUT_TCE, H_PUT_TCE_INDIRECT, H_STUFF_TCE hypercalls.
+
+/* for KVM_CAP_SPAPR_TCE_IOMMU */
+struct kvm_create_spapr_tce_iommu {
+	__u64 liobn;
+	__u32 iommu_id;
+	__u32 flags;
+};
+
+No flag is supported at the moment.
+
+When the guest issues TCE call on a liobn for which a TCE table has been
+registered, the kernel will handle it in real mode, updating the hardware
+TCE table. TCE table calls for other liobns will cause a vm exit and must
+be handled by userspace.
+
+
 5. The kvm_run structure
 ------------------------
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 85d8f26..ac0e2fe 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -180,6 +180,7 @@ struct kvmppc_spapr_tce_table {
 	struct kvm *kvm;
 	u64 liobn;
 	u32 window_size;
+	struct iommu_group *grp;    /* used for IOMMU groups */
 	struct page *pages[0];
 };
 
@@ -611,6 +612,8 @@ struct kvm_vcpu_arch {
 	u64 busy_preempt;
 
 	unsigned long *tce_tmp;    /* TCE cache for TCE_PUT_INDIRECT hall */
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
index 0fb1a6e..cf82af4 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -319,6 +319,13 @@ struct kvm_create_spapr_tce {
 	__u32 window_size;
 };
 
+/* for KVM_CAP_SPAPR_TCE_IOMMU */
+struct kvm_create_spapr_tce_iommu {
+	__u64 liobn;
+	__u32 iommu_id;
+	__u32 flags;
+};
+
 /* for KVM_ALLOCATE_RMA */
 struct kvm_allocate_rma {
 	__u64 rma_size;
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 06b7b20..ffb4698 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -27,6 +27,8 @@
 #include <linux/hugetlb.h>
 #include <linux/list.h>
 #include <linux/anon_inodes.h>
+#include <linux/pci.h>
+#include <linux/iommu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -56,8 +58,13 @@ static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
 
 	mutex_lock(&kvm->lock);
 	list_del(&stt->list);
-	for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
-		__free_page(stt->pages[i]);
+#ifdef CONFIG_IOMMU_API
+	if (stt->grp) {
+		iommu_group_put(stt->grp);
+	} else
+#endif
+		for (i = 0; i < kvmppc_stt_npages(stt->window_size); i++)
+			__free_page(stt->pages[i]);
 	kfree(stt);
 	mutex_unlock(&kvm->lock);
 
@@ -153,6 +160,62 @@ fail:
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
+
+	/* Find an IOMMU table for the given ID */
+	grp = iommu_group_get_by_id(args->iommu_id);
+	if (!grp)
+		return -ENXIO;
+
+	tbl = iommu_group_get_iommudata(grp);
+	if (!tbl)
+		return -ENXIO;
+
+	/* Check this LIOBN hasn't been previously allocated */
+	list_for_each_entry(tt, &kvm->arch.spapr_tce_tables, list) {
+		if (tt->liobn == args->liobn)
+			return -EBUSY;
+	}
+
+	tt = kzalloc(sizeof(*tt), GFP_KERNEL);
+	if (!tt)
+		return -ENOMEM;
+
+	tt->liobn = args->liobn;
+	tt->kvm = kvm;
+	tt->grp = grp;
+
+	kvm_get_kvm(kvm);
+
+	mutex_lock(&kvm->lock);
+	list_add(&tt->list, &kvm->arch.spapr_tce_tables);
+
+	mutex_unlock(&kvm->lock);
+
+	pr_debug("LIOBN=%llX hooked to IOMMU %d, flags=%u\n",
+			args->liobn, args->iommu_id, args->flags);
+
+	return anon_inode_getfd("kvm-spapr-tce-iommu",
+			&kvm_spapr_tce_iommu_fops, tt, O_RDWR);
+}
+#else
+long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
+		struct kvm_create_spapr_tce_iommu *args)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_IOMMU_API */
+
 /* Converts guest physical address into host virtual */
 static void __user *kvmppc_virtmode_gpa_to_hva(struct kvm_vcpu *vcpu,
 		unsigned long gpa)
@@ -180,6 +243,46 @@ long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
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
 	/* Emulated IO */
 	if (ioba >= tt->window_size)
 		return H_PARAMETER;
@@ -220,6 +323,70 @@ long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if (tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+		/* Return error if the group is being destroyed */
+		if (!tbl)
+			return H_RESCINDED;
+
+		/* Something bad happened, do cleanup and exit */
+		if (vcpu->arch.tce_reason == H_HARDWARE) {
+			i = vcpu->arch.tce_tmp_num;
+			goto fail_clear_tce;
+		} else if (vcpu->arch.tce_reason != H_TOO_HARD) {
+			/*
+			 * We get here only in PR KVM mode, otherwise
+			 * the real mode handler would have checked TCEs
+			 * already and failed on guest TCE translation.
+			 */
+			for (i = 0; i < npages; ++i) {
+				if (get_user(vcpu->arch.tce_tmp[i], tces + i))
+					return H_HARDWARE;
+
+				if (iommu_tce_put_param_check(tbl, ioba +
+						(i << IOMMU_PAGE_SHIFT),
+						vcpu->arch.tce_tmp[i]))
+					return H_PARAMETER;
+			}
+		} /* else: The real mode handler checked TCEs already */
+
+		/* Translate TCEs */
+		for (i = vcpu->arch.tce_tmp_num; i < npages; ++i) {
+			void *hva = kvmppc_virtmode_gpa_to_hva(vcpu,
+					vcpu->arch.tce_tmp[i]);
+
+			if (hva == ERROR_ADDR)
+				goto fail_clear_tce;
+
+			vcpu->arch.tce_tmp[i] = (unsigned long) hva;
+		}
+
+		/* Do get_page and put TCEs for all pages */
+		for (i = 0; i < npages; ++i) {
+			if (iommu_put_tce_user_mode(tbl,
+					(ioba >> IOMMU_PAGE_SHIFT) + i,
+					vcpu->arch.tce_tmp[i])) {
+				i = npages;
+				goto fail_clear_tce;
+			}
+		}
+
+		iommu_flush_tce(tbl);
+
+		return H_SUCCESS;
+
+fail_clear_tce:
+		/* Cannot complete the translation, clean up and exit */
+		iommu_clear_tces_and_put_pages(tbl,
+				ioba >> IOMMU_PAGE_SHIFT, i);
+
+		iommu_flush_tce(tbl);
+
+		return H_HARDWARE;
+	}
+#endif
 	/* Emulated IO */
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
@@ -253,6 +420,33 @@ long kvmppc_virtmode_h_stuff_tce(struct kvm_vcpu *vcpu,
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
 	/* Emulated IO */
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index c68d538..dc4ae32 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/hugetlb.h>
 #include <linux/list.h>
+#include <linux/iommu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -118,7 +119,7 @@ EXPORT_SYMBOL_GPL(kvmppc_emulated_put_tce);
 #ifdef CONFIG_KVM_BOOK3S_64_HV
 
 static pte_t kvmppc_lookup_pte(pgd_t *pgdir, unsigned long hva, bool writing,
-			unsigned long *pte_sizep)
+			unsigned long *pte_sizep, bool do_get_page)
 {
 	pte_t *ptep;
 	unsigned int shift = 0;
@@ -135,6 +136,14 @@ static pte_t kvmppc_lookup_pte(pgd_t *pgdir, unsigned long hva, bool writing,
 	if (!pte_present(*ptep))
 		return __pte(0);
 
+	/*
+	 * Put huge pages handling to the virtual mode.
+	 * The only exception is for TCE list pages which we
+	 * do need to call get_page() for.
+	 */
+	if ((*pte_sizep > PAGE_SIZE) && do_get_page)
+		return __pte(0);
+
 	/* wait until _PAGE_BUSY is clear then set it atomically */
 	__asm__ __volatile__ (
 		"1:	ldarx	%0,0,%3\n"
@@ -148,6 +157,18 @@ static pte_t kvmppc_lookup_pte(pgd_t *pgdir, unsigned long hva, bool writing,
 		: "cc");
 
 	ret = pte;
+	if (do_get_page && pte_present(pte) && (!writing || pte_write(pte))) {
+		struct page *pg = NULL;
+		pg = realmode_pfn_to_page(pte_pfn(pte));
+		if (realmode_get_page(pg)) {
+			ret = __pte(0);
+		} else {
+			pte = pte_mkyoung(pte);
+			if (writing)
+				pte = pte_mkdirty(pte);
+		}
+	}
+	*ptep = pte;	/* clears _PAGE_BUSY */
 
 	return ret;
 }
@@ -157,7 +178,7 @@ static pte_t kvmppc_lookup_pte(pgd_t *pgdir, unsigned long hva, bool writing,
  * Also returns pte and page size if the page is present in page table.
  */
 static unsigned long kvmppc_realmode_gpa_to_hpa(struct kvm_vcpu *vcpu,
-		unsigned long gpa)
+		unsigned long gpa, bool do_get_page)
 {
 	struct kvm_memory_slot *memslot;
 	pte_t pte;
@@ -175,7 +196,7 @@ static unsigned long kvmppc_realmode_gpa_to_hpa(struct kvm_vcpu *vcpu,
 
 	/* Find a PTE and determine the size */
 	pte = kvmppc_lookup_pte(vcpu->arch.pgdir, hva,
-			writing, &pg_size);
+			writing, &pg_size, do_get_page);
 	if (!pte)
 		return ERROR_ADDR;
 
@@ -188,6 +209,52 @@ static unsigned long kvmppc_realmode_gpa_to_hpa(struct kvm_vcpu *vcpu,
 	return hpa;
 }
 
+#ifdef CONFIG_IOMMU_API
+static long kvmppc_clear_tce_real_mode(struct kvm_vcpu *vcpu,
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
+		struct page *page;
+		unsigned long oldtce;
+
+		oldtce = iommu_clear_tce(tbl, entry + i);
+		if (!oldtce)
+			continue;
+
+		page = realmode_pfn_to_page(oldtce >> PAGE_SHIFT);
+		if (!page) {
+			ret = H_TOO_HARD;
+			break;
+		}
+
+		if (oldtce & TCE_PCI_WRITE)
+			SetPageDirty(page);
+
+		if (realmode_put_page(page)) {
+			ret = H_TOO_HARD;
+			break;
+		}
+	}
+
+	if (ret == H_TOO_HARD) {
+		vcpu->arch.tce_tmp_num = i;
+		vcpu->arch.tce_reason = H_TOO_HARD;
+	}
+	/* if (ret < 0)
+		pr_err("iommu_tce: %s failed ioba=%lx, tce_value=%lx ret=%d\n",
+				__func__, ioba, tce_value, ret); */
+
+	return ret;
+}
+#endif /* CONFIG_IOMMU_API */
+
 long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 		      unsigned long ioba, unsigned long tce)
 {
@@ -199,6 +266,52 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
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
+			hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tce, true);
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
+				struct page *pg = realmode_pfn_to_page(hpa);
+				BUG_ON(!pg);
+				if (realmode_put_page(pg)) {
+					vcpu->arch.tce_reason = H_HARDWARE;
+					return H_TOO_HARD;
+				}
+				return H_HARDWARE;
+			}
+		} else {
+			ret = kvmppc_clear_tce_real_mode(vcpu, tbl, ioba, 0, 1);
+			if (ret)
+				return ret;
+		}
+
+		iommu_flush_tce(tbl);
+
+		return H_SUCCESS;
+	}
+#endif
 	/* Emulated IO */
 	if (ioba >= tt->window_size)
 		return H_PARAMETER;
@@ -235,10 +348,62 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if (tce_list & ~IOMMU_PAGE_MASK)
 		return H_PARAMETER;
 
-	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu, tce_list);
+	vcpu->arch.tce_tmp_num = 0;
+	vcpu->arch.tce_reason = 0;
+
+	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu,
+			tce_list, false);
 	if ((unsigned long)tces == ERROR_ADDR)
 		return H_TOO_HARD;
 
+#ifdef CONFIG_IOMMU_API
+	if (tt->grp) {
+		struct iommu_table *tbl = iommu_group_get_iommudata(tt->grp);
+
+		/* Return error if the group is being destroyed */
+		if (!tbl)
+			return H_RESCINDED;
+
+		/* Check all TCEs */
+		for (i = 0; i < npages; ++i) {
+			if (iommu_tce_put_param_check(tbl, ioba +
+					(i << IOMMU_PAGE_SHIFT), tces[i]))
+				return H_PARAMETER;
+			vcpu->arch.tce_tmp[i] = tces[i];
+		}
+
+		/* Translate TCEs and go get_page */
+		for (i = 0; i < npages; ++i) {
+			unsigned long hpa = kvmppc_realmode_gpa_to_hpa(vcpu,
+					vcpu->arch.tce_tmp[i], true);
+			if (hpa == ERROR_ADDR) {
+				vcpu->arch.tce_tmp_num = i;
+				vcpu->arch.tce_reason = H_TOO_HARD;
+				return H_TOO_HARD;
+			}
+			vcpu->arch.tce_tmp[i] = hpa;
+		}
+
+		/* Put TCEs to the table */
+		for (i = 0; i < npages; ++i) {
+			unsigned long hva = (unsigned long)
+					__va(vcpu->arch.tce_tmp[i]);
+
+			ret = iommu_tce_build(tbl,
+					(ioba >> IOMMU_PAGE_SHIFT) + i,
+					hva, iommu_tce_direction(hva));
+			if (ret) {
+				/* All wrong, go virtmode and do cleanup */
+				vcpu->arch.tce_reason = H_HARDWARE;
+				return H_TOO_HARD;
+			}
+		}
+
+		iommu_flush_tce(tbl);
+
+		return H_SUCCESS;
+	}
+#endif
 	/* Emulated IO */
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
@@ -268,6 +433,26 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
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
+		ret = kvmppc_clear_tce_real_mode(vcpu, tbl, ioba,
+				tce_value, npages);
+		if (ret)
+			return ret;
+
+		iommu_flush_tce(tbl);
+
+		return H_SUCCESS;
+	}
+#endif
 	/* Emulated IO */
 	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
 		return H_PARAMETER;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 8465c2a..da6bf61 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -396,6 +396,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		break;
 #endif
 	case KVM_CAP_SPAPR_MULTITCE:
+	case KVM_CAP_SPAPR_TCE_IOMMU:
 		r = 1;
 		break;
 	default:
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
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5a2afda..450c82a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -667,6 +667,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_RTAS 91
 #define KVM_CAP_IRQ_XICS 92
 #define KVM_CAP_SPAPR_MULTITCE (0x110000 + 89)
+#define KVM_CAP_SPAPR_TCE_IOMMU (0x110000 + 90)
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -939,6 +940,9 @@ struct kvm_s390_ucas_mapping {
 #define KVM_GET_DEVICE_ATTR	  _IOW(KVMIO,  0xe2, struct kvm_device_attr)
 #define KVM_HAS_DEVICE_ATTR	  _IOW(KVMIO,  0xe3, struct kvm_device_attr)
 
+/* ioctl for SPAPR TCE IOMMU */
+#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xe4, struct kvm_create_spapr_tce_iommu)
+
 /*
  * ioctls for vcpu fds
  */
-- 
1.7.10.4

