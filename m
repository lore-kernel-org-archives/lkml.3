Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaFEHZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:25:59 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47275 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaFEHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:25:57 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 3/3] PPC: KVM: Add support for 64bit TCE windows
Date: Thu,  5 Jun 2014 17:25:44 +1000
Message-Id: <1401953144-19186-4-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060507-0260-0000-0000-00000514943E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing KVM_CREATE_SPAPR_TCE only supports 32bit windows which is not
enough for directly mapped windows as the guest can get more than 4GB.

This adds KVM_CREATE_SPAPR_TCE_64 ioctl and advertises it
via KVM_CAP_SPAPR_TCE_64 capability.

Since 64bit windows are to support Dynamic DMA windows (DDW), let's add
@bus_offset and @page_shift which are also required by DDW.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 Documentation/virtual/kvm/api.txt   | 46 +++++++++++++++++++++++++++++++++++++
 arch/powerpc/include/asm/kvm_host.h |  4 +++-
 arch/powerpc/include/asm/kvm_ppc.h  |  2 +-
 arch/powerpc/include/uapi/asm/kvm.h |  9 ++++++++
 arch/powerpc/kvm/book3s_64_vio.c    |  4 +++-
 arch/powerpc/kvm/powerpc.c          | 24 ++++++++++++++++++-
 include/uapi/linux/kvm.h            |  2 ++
 7 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index b4f5365..8a2a2da 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2484,6 +2484,52 @@ calls by the guest for that service will be passed to userspace to be
 handled.
 
 
+4.87 KVM_CREATE_SPAPR_TCE_64
+
+Capability: KVM_CAP_SPAPR_TCE_64
+Architectures: powerpc
+Type: vm ioctl
+Parameters: struct kvm_create_spapr_tce_64 (in)
+Returns: file descriptor for manipulating the created TCE table
+
+This is an extension for KVM_CAP_SPAPR_TCE which only supports 32bit
+windows.
+
+This creates a virtual TCE (translation control entry) table, which
+is an IOMMU for PAPR-style virtual I/O.  It is used to translate
+logical addresses used in virtual I/O into guest physical addresses,
+and provides a scatter/gather capability for PAPR virtual I/O.
+
+/* for KVM_CAP_SPAPR_TCE_64 */
+struct kvm_create_spapr_tce_64 {
+	__u64 liobn;
+	__u64 window_size;
+	__u64 bus_offset;
+	__u32 page_shift;
+	__u32 flags;
+};
+
+The liobn field gives the logical IO bus number for which to create a
+TCE table. The window_size field specifies the size of the DMA window
+which this TCE table will translate - the table will contain one 64
+bit TCE entry for every IOMMU page. The bus_offset field tells where
+this window is mapped on the IO bus. The page_size field tells a size
+of the pages in this window, can be 4K, 64K, 16MB, etc. The flags field
+is not used at the moment but provides the room for extensions.
+
+When the guest issues an H_PUT_TCE/H_PUT_TCE_INDIRECT/H_STUFF_TCE hcall
+on a liobn for which a TCE table has been created using this ioctl(),
+the kernel will handle it in real or virtual mode, updating the TCE table.
+If liobn has not been registered with this ioctl, H_PUT_TCE/etc calls
+will cause a vm exit and must be handled by userspace.
+
+The return value is a file descriptor which can be passed to mmap(2)
+to map the created TCE table into userspace.  This lets userspace read
+the entries written by kernel-handled H_PUT_TCE calls, and also lets
+userspace update the TCE table directly which is useful in some
+circumstances.
+
+
 5. The kvm_run structure
 ------------------------
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1eaea2d..260a810 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -179,7 +179,9 @@ struct kvmppc_spapr_tce_table {
 	struct list_head list;
 	struct kvm *kvm;
 	u64 liobn;
-	u32 window_size;
+	u64 window_size;
+	u64 bus_offset;
+	u32 page_shift;
 	struct page *pages[0];
 };
 
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 4096f16..b472fd3 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -126,7 +126,7 @@ extern void kvmppc_map_vrma(struct kvm_vcpu *vcpu,
 extern int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu);
 
 extern long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
-				struct kvm_create_spapr_tce *args);
+				struct kvm_create_spapr_tce_64 *args);
 extern long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			     unsigned long ioba, unsigned long tce);
 extern long kvmppc_h_get_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index a6665be..0ada7b4 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -333,6 +333,15 @@ struct kvm_create_spapr_tce {
 	__u32 window_size;
 };
 
+/* for KVM_CAP_SPAPR_TCE_64 */
+struct kvm_create_spapr_tce_64 {
+	__u64 liobn;
+	__u64 window_size;
+	__u64 bus_offset;
+	__u32 page_shift;
+	__u32 flags;
+};
+
 /* for KVM_ALLOCATE_RMA */
 struct kvm_allocate_rma {
 	__u64 rma_size;
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 54cf9bc..230fa5f 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -98,7 +98,7 @@ static const struct file_operations kvm_spapr_tce_fops = {
 };
 
 long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
-				   struct kvm_create_spapr_tce *args)
+				   struct kvm_create_spapr_tce_64 *args)
 {
 	struct kvmppc_spapr_tce_table *stt = NULL;
 	long npages;
@@ -120,6 +120,8 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 
 	stt->liobn = args->liobn;
 	stt->window_size = args->window_size;
+	stt->bus_offset = args->bus_offset;
+	stt->page_shift = args->page_shift;
 	stt->kvm = kvm;
 
 	for (i = 0; i < npages; i++) {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 3cf541a..3b78b8d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -33,6 +33,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cputhreads.h>
 #include <asm/irqflags.h>
+#include <asm/iommu.h>
 #include "timing.h"
 #include "irq.h"
 #include "../mm/mmu_decl.h"
@@ -373,6 +374,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 
 #ifdef CONFIG_PPC_BOOK3S_64
 	case KVM_CAP_SPAPR_TCE:
+	case KVM_CAP_SPAPR_TCE_64:
 	case KVM_CAP_PPC_ALLOC_HTAB:
 	case KVM_CAP_PPC_RTAS:
 #ifdef CONFIG_KVM_XICS
@@ -1077,13 +1079,33 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		break;
 	}
 #ifdef CONFIG_PPC_BOOK3S_64
+	case KVM_CREATE_SPAPR_TCE_64: {
+		struct kvm_create_spapr_tce_64 create_tce_64;
+
+		r = -EFAULT;
+		if (copy_from_user(&create_tce_64, argp, sizeof(create_tce_64)))
+			goto out;
+		if (create_tce_64.flags) {
+			r = -EINVAL;
+			goto out;
+		}
+		r = kvm_vm_ioctl_create_spapr_tce(kvm, &create_tce_64);
+		goto out;
+	}
 	case KVM_CREATE_SPAPR_TCE: {
 		struct kvm_create_spapr_tce create_tce;
+		struct kvm_create_spapr_tce_64 create_tce_64;
 
 		r = -EFAULT;
 		if (copy_from_user(&create_tce, argp, sizeof(create_tce)))
 			goto out;
-		r = kvm_vm_ioctl_create_spapr_tce(kvm, &create_tce);
+
+		create_tce_64.liobn = create_tce.liobn;
+		create_tce_64.window_size = create_tce.window_size;
+		create_tce_64.bus_offset = 0;
+		create_tce_64.page_shift = IOMMU_PAGE_SHIFT_4K;
+		create_tce_64.flags = 0;
+		r = kvm_vm_ioctl_create_spapr_tce(kvm, &create_tce_64);
 		goto out;
 	}
 	case KVM_PPC_GET_SMMU_INFO: {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e6972bf..c435cbb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1018,6 +1018,8 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_PPC_ALLOC_HTAB */
 #define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
 #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
+#define KVM_CREATE_SPAPR_TCE_64	  _IOW(KVMIO,  0xa8, \
+				       struct kvm_create_spapr_tce_64)
 /* Available with KVM_CAP_RMA */
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
 /* Available with KVM_CAP_PPC_HTAB_FD */
-- 
2.0.0

