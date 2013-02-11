Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3BKMNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:13:30 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:65110 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3BKMN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:13:26 -0500
From: aik@ozlabs.ru
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 2/4] powerpc kvm: added multiple TCEs requests support
Date: Mon, 11 Feb 2013 23:12:41 +1100
Message-Id: <5118e064.22ca320a.1f08.ffffe2ec@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360584763-21988-1-git-send-email-a>
References: <1360584763-21988-1-git-send-email-a>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

The patch adds real mode handlers for H_PUT_TCE_INDIRECT and
H_STUFF_TCE hypercalls for QEMU emulated devices such as virtio
devices or emulated PCI. These calls allow adding multiple entries
(up to 512) into the TCE table in one call which saves time on
transition to/from real mode.

The patch adds a guest physical to host real address converter
and calls the existing H_PUT_TCE handler. The converting function
is going to be fully utilized by upcoming VFIO supporting patches.

The patch also implements the KVM_CAP_PPC_MULTITCE capability,
so in order to support the functionality of this patch QEMU
needs to query for this capability and set the "hcall-multi-tce"
hypertas property if the capability is present.

Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/kvm_ppc.h      |   15 ++
 arch/powerpc/kvm/book3s_64_vio_hv.c     |  241 ++++++++++++++++++++++++++++---
 arch/powerpc/kvm/book3s_hv.c            |   23 +++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    6 +
 arch/powerpc/kvm/book3s_pr_papr.c       |   37 ++++-
 arch/powerpc/kvm/powerpc.c              |    3 +
 include/uapi/linux/kvm.h                |    1 +
 7 files changed, 301 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 572aa75..76d133b 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -136,6 +136,21 @@ extern long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 				struct kvm_create_spapr_tce *args);
 extern long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			     unsigned long ioba, unsigned long tce);
+extern long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_list, unsigned long npages);
+extern long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_value, unsigned long npages);
+extern long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce);
+extern long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_list, unsigned long npages);
+extern long kvmppc_virtmode_h_stuff_tce(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_value, unsigned long npages);
 extern long kvm_vm_ioctl_allocate_rma(struct kvm *kvm,
 				struct kvm_allocate_rma *rma);
 extern struct kvmppc_linear_info *kvm_alloc_rma(void);
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 30c2f3b..c38edcd 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -14,6 +14,7 @@
  *
  * Copyright 2010 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  * Copyright 2011 David Gibson, IBM Corporation <dwg@au1.ibm.com>
+ * Copyright 2013 Alexey Kardashevskiy, IBM Corporation <aik@au1.ibm.com>
  */
 
 #include <linux/types.h>
@@ -25,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/hugetlb.h>
 #include <linux/list.h>
+#include <linux/kvm_host.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -35,42 +37,233 @@
 #include <asm/ppc-opcode.h>
 #include <asm/kvm_host.h>
 #include <asm/udbg.h>
+#include <asm/iommu.h>
+#include <asm/tce.h>
 
 #define TCES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
 
-/* WARNING: This will be called in real-mode on HV KVM and virtual
- *          mode on PR KVM
+static struct kvmppc_spapr_tce_table *find_tce_table(struct kvm_vcpu *vcpu,
+		unsigned long liobn)
+{
+	struct kvmppc_spapr_tce_table *stt;
+
+	list_for_each_entry(stt, &vcpu->kvm->arch.spapr_tce_tables, list) {
+		if (stt->liobn == liobn)
+			return stt;
+	}
+
+	return NULL;
+}
+
+/*
+ * Converts guest physical address into host virtual
+ * which is to be used later in get_user_pages_fast().
+ */
+static unsigned long get_virt_address(struct kvm_vcpu *vcpu,
+		unsigned long gpa, bool writing,
+		pte_t *ptep, unsigned long *pg_sizep)
+{
+	unsigned long hva, gfn = gpa >> PAGE_SHIFT;
+	struct kvm_memory_slot *memslot;
+
+	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
+	if (!memslot)
+		return 0;
+
+	/*
+	 * Convert gfn to hva preserving flags and an offset
+	 * within a system page
+	 */
+	hva = __gfn_to_hva_memslot(memslot, gfn) + (gpa & ~PAGE_MASK);
+
+	/* Find out the page pte and size if requested */
+	if (ptep && pg_sizep) {
+		pte_t pte;
+		unsigned long pg_size = 0;
+
+		pte = lookup_linux_pte(vcpu->arch.pgdir, hva,
+				writing, &pg_size);
+		if (!pte_present(pte))
+			return 0;
+
+		*pg_sizep = pg_size;
+		*ptep = pte;
+	}
+
+	return hva;
+}
+
+/*
+ * Converts guest physical address into host real address.
+ * Also returns pte and page size if the page is present in page table.
+ */
+static unsigned long get_real_address(struct kvm_vcpu *vcpu,
+		unsigned long gpa, bool writing,
+		pte_t *ptep, unsigned long *pg_sizep)
+{
+	struct kvm_memory_slot *memslot;
+	pte_t pte;
+	unsigned long hva, pg_size = 0, hwaddr, offset;
+	unsigned long gfn = gpa >> PAGE_SHIFT;
+
+	/* Find a KVM memslot */
+	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
+	if (!memslot)
+		return 0;
+
+	/* Convert guest physical address to host virtual */
+	hva = __gfn_to_hva_memslot(memslot, gfn);
+
+	/* Find a PTE and determine the size */
+	pte = lookup_linux_pte(vcpu->arch.pgdir, hva,
+			writing, &pg_size);
+	if (!pte_present(pte))
+		return 0;
+
+	/* Calculate host phys address keeping flags and offset in the page */
+	offset = gpa & (pg_size - 1);
+
+	/* pte_pfn(pte) should return an address aligned to pg_size */
+	hwaddr = (pte_pfn(pte) << PAGE_SHIFT) + offset;
+
+	/* Copy outer values if required */
+	if (pg_sizep)
+		*pg_sizep = pg_size;
+	if (ptep)
+		*ptep = pte;
+
+	return hwaddr;
+}
+
+/*
+ * emulated_h_put_tce() handles TCE requests for devices emulated
+ * by QEMU. It puts guest TCE values into the table and expects
+ * the QEMU to convert them later in the QEMU device implementation.
+ * Works in both real and virtual modes.
+ */
+static long emulated_h_put_tce(struct kvmppc_spapr_tce_table *stt,
+		unsigned long ioba, unsigned long tce)
+{
+	unsigned long idx = ioba >> SPAPR_TCE_SHIFT;
+	struct page *page;
+	u64 *tbl;
+
+	/* udbg_printf("H_PUT_TCE: liobn 0x%lx => stt=%p  window_size=0x%x\n", */
+	/* 	    liobn, stt, stt->window_size); */
+	if (ioba >= stt->window_size) {
+		pr_err("%s failed on ioba=%lx\n", __func__, ioba);
+		return H_PARAMETER;
+	}
+
+	page = stt->pages[idx / TCES_PER_PAGE];
+	tbl = (u64 *)page_address(page);
+
+	/* FIXME: Need to validate the TCE itself */
+	/* udbg_printf("tce @ %p\n", &tbl[idx % TCES_PER_PAGE]); */
+	tbl[idx % TCES_PER_PAGE] = tce;
+
+	return H_SUCCESS;
+}
+
+/*
+ * Real mode handlers
  */
 long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 		      unsigned long ioba, unsigned long tce)
 {
-	struct kvm *kvm = vcpu->kvm;
 	struct kvmppc_spapr_tce_table *stt;
 
-	/* udbg_printf("H_PUT_TCE(): liobn=0x%lx ioba=0x%lx, tce=0x%lx\n", */
-	/* 	    liobn, ioba, tce); */
+	stt = find_tce_table(vcpu, liobn);
+	/* Didn't find the liobn, put it to userspace */
+	if (!stt)
+		return H_TOO_HARD;
+
+	/* Emulated IO */
+	return emulated_h_put_tce(stt, ioba, tce);
+}
+
+long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_list,	unsigned long npages)
+{
+	struct kvmppc_spapr_tce_table *stt;
+	long i, ret = 0;
+	unsigned long *tces;
+
+	stt = find_tce_table(vcpu, liobn);
+	/* Didn't find the liobn, put it to userspace */
+	if (!stt)
+		return H_TOO_HARD;
 
-	list_for_each_entry(stt, &kvm->arch.spapr_tce_tables, list) {
-		if (stt->liobn == liobn) {
-			unsigned long idx = ioba >> SPAPR_TCE_SHIFT;
-			struct page *page;
-			u64 *tbl;
+	tces = (void *) get_real_address(vcpu, tce_list, false, NULL, NULL);
+	if (!tces)
+		return H_TOO_HARD;
 
-			/* udbg_printf("H_PUT_TCE: liobn 0x%lx => stt=%p  window_size=0x%x\n", */
-			/* 	    liobn, stt, stt->window_size); */
-			if (ioba >= stt->window_size)
-				return H_PARAMETER;
+	/* Emulated IO */
+	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
+		ret = emulated_h_put_tce(stt, ioba, tces[i]);
 
-			page = stt->pages[idx / TCES_PER_PAGE];
-			tbl = (u64 *)page_address(page);
+	return ret;
+}
 
-			/* FIXME: Need to validate the TCE itself */
-			/* udbg_printf("tce @ %p\n", &tbl[idx % TCES_PER_PAGE]); */
-			tbl[idx % TCES_PER_PAGE] = tce;
-			return H_SUCCESS;
-		}
-	}
+long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_value, unsigned long npages)
+{
+	struct kvmppc_spapr_tce_table *stt;
+	long i, ret = 0;
+
+	stt = find_tce_table(vcpu, liobn);
+	/* Didn't find the liobn, put it to userspace */
+	if (!stt)
+		return H_TOO_HARD;
 
-	/* Didn't find the liobn, punt it to userspace */
-	return H_TOO_HARD;
+	/* Emulated IO */
+	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
+		ret = emulated_h_put_tce(stt, ioba, tce_value);
+
+	return ret;
+}
+
+/*
+ * Virtual mode handlers
+ */
+extern long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce)
+{
+	/* At the moment emulated IO is handled the same way */
+	return kvmppc_h_put_tce(vcpu, liobn, ioba, tce);
+}
+
+extern long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_list, unsigned long npages)
+{
+	struct kvmppc_spapr_tce_table *stt;
+	unsigned long *tces;
+	long ret = 0, i;
+
+	stt = find_tce_table(vcpu, liobn);
+	/* Didn't find the liobn, put it to userspace */
+	if (!stt)
+		return H_TOO_HARD;
+
+	tces = (void *) get_virt_address(vcpu, tce_list, false, NULL, NULL);
+	if (!tces)
+		return H_TOO_HARD;
+
+	/* Emulated IO */
+	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
+		ret = emulated_h_put_tce(stt, ioba, tces[i]);
+
+	return ret;
+}
+
+extern long kvmppc_virtmode_h_stuff_tce(struct kvm_vcpu *vcpu,
+		unsigned long liobn, unsigned long ioba,
+		unsigned long tce_value, unsigned long npages)
+{
+	/* At the moment emulated IO is handled the same way */
+	return kvmppc_h_stuff_tce(vcpu, liobn, ioba, tce_value, npages);
 }
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 71d0c90..13c8436 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -515,6 +515,29 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 					kvmppc_get_gpr(vcpu, 5),
 					kvmppc_get_gpr(vcpu, 6));
 		break;
+	case H_PUT_TCE:
+		ret = kvmppc_virtmode_h_put_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
+					        kvmppc_get_gpr(vcpu, 5),
+					        kvmppc_get_gpr(vcpu, 6));
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
+	case H_PUT_TCE_INDIRECT:
+		ret = kvmppc_virtmode_h_put_tce_indirect(vcpu, kvmppc_get_gpr(vcpu, 4),
+					        kvmppc_get_gpr(vcpu, 5),
+					        kvmppc_get_gpr(vcpu, 6),
+						kvmppc_get_gpr(vcpu, 7));
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
+	case H_STUFF_TCE:
+		ret = kvmppc_virtmode_h_stuff_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
+					        kvmppc_get_gpr(vcpu, 5),
+					        kvmppc_get_gpr(vcpu, 6),
+						kvmppc_get_gpr(vcpu, 7));
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
 	default:
 		return RESUME_HOST;
 	}
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 10b6c35..0826e8b 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1390,6 +1390,12 @@ hcall_real_table:
 	.long	0		/* 0x11c */
 	.long	0		/* 0x120 */
 	.long	.kvmppc_h_bulk_remove - hcall_real_table
+	.long	0		/* 0x128 */
+	.long	0		/* 0x12c */
+	.long	0		/* 0x130 */
+	.long	0		/* 0x134 */
+	.long	.kvmppc_h_stuff_tce - hcall_real_table
+	.long	.kvmppc_h_put_tce_indirect - hcall_real_table
 hcall_real_table_end:
 
 ignore_hdec:
diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
index ee02b30..270e88e 100644
--- a/arch/powerpc/kvm/book3s_pr_papr.c
+++ b/arch/powerpc/kvm/book3s_pr_papr.c
@@ -220,7 +220,38 @@ static int kvmppc_h_pr_put_tce(struct kvm_vcpu *vcpu)
 	unsigned long tce = kvmppc_get_gpr(vcpu, 6);
 	long rc;
 
-	rc = kvmppc_h_put_tce(vcpu, liobn, ioba, tce);
+	rc = kvmppc_virtmode_h_put_tce(vcpu, liobn, ioba, tce, 1);
+	if (rc == H_TOO_HARD)
+		return EMULATE_FAIL;
+	kvmppc_set_gpr(vcpu, 3, rc);
+	return EMULATE_DONE;
+}
+
+static int kvmppc_h_pr_put_tce_indirect(struct kvm_vcpu *vcpu)
+{
+	unsigned long liobn = kvmppc_get_gpr(vcpu, 4);
+	unsigned long ioba = kvmppc_get_gpr(vcpu, 5);
+	unsigned long tce = kvmppc_get_gpr(vcpu, 6);
+	unsigned long npages = kvmppc_get_gpr(vcpu, 7);
+	long rc;
+
+	rc = kvmppc_virtmode_h_put_tce_indirect(vcpu, liobn, ioba,
+			tce, npages);
+	if (rc == H_TOO_HARD)
+		return EMULATE_FAIL;
+	kvmppc_set_gpr(vcpu, 3, rc);
+	return EMULATE_DONE;
+}
+
+static int kvmppc_h_pr_stuff_tce(struct kvm_vcpu *vcpu)
+{
+	unsigned long liobn = kvmppc_get_gpr(vcpu, 4);
+	unsigned long ioba = kvmppc_get_gpr(vcpu, 5);
+	unsigned long tce_value = kvmppc_get_gpr(vcpu, 6);
+	unsigned long npages = kvmppc_get_gpr(vcpu, 7);
+	long rc;
+
+	rc = kvmppc_virtmode_h_stuff_tce(vcpu, liobn, ioba, tce_value, npages);
 	if (rc == H_TOO_HARD)
 		return EMULATE_FAIL;
 	kvmppc_set_gpr(vcpu, 3, rc);
@@ -240,6 +271,10 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
 		return kvmppc_h_pr_bulk_remove(vcpu);
 	case H_PUT_TCE:
 		return kvmppc_h_pr_put_tce(vcpu);
+	case H_PUT_TCE_INDIRECT:
+		return kvmppc_h_pr_put_tce_indirect(vcpu);
+	case H_STUFF_TCE:
+		return kvmppc_h_pr_stuff_tce(vcpu);
 	case H_CEDE:
 		vcpu->arch.shared->msr |= MSR_EE;
 		kvm_vcpu_block(vcpu);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 70739a0..95614c7 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -383,6 +383,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = 1;
 		break;
 #endif
+	case KVM_CAP_PPC_MULTITCE:
+		r = 1;
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e6e5d4b..26e2b271 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -635,6 +635,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_IRQFD_RESAMPLE 82
 #define KVM_CAP_PPC_BOOKE_WATCHDOG 83
 #define KVM_CAP_PPC_HTAB_FD 84
+#define KVM_CAP_PPC_MULTITCE 87
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.7.10.4

