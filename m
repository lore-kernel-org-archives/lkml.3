Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3DPGdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:33:13 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57398 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3DPGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:33:08 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 02/15] KVM: fold kvm_arch_create_memslot into kvm_arch_prepare_memory_region
Date: Tue, 16 Apr 2013 14:32:40 +0800
Message-Id: <1366093973-2617-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-5564-0000-0000-00000784CF8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It removes a arch-specified interface and also removes unnecessary
empty functions on some architectures

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/arm/kvm/arm.c         |    5 -----
 arch/ia64/kvm/kvm-ia64.c   |    5 -----
 arch/powerpc/kvm/powerpc.c |    8 ++++++--
 arch/s390/kvm/kvm-s390.c   |    5 -----
 arch/x86/kvm/x86.c         |    7 ++++++-
 include/linux/kvm_host.h   |    1 -
 virt/kvm/kvm_main.c        |    8 ++------
 7 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e4ad0bb..c76e63e 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -159,11 +159,6 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 {
 }
 
-int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
-{
-	return 0;
-}
-
 /**
  * kvm_arch_destroy_vm - destroy the VM data structure
  * @kvm:	pointer to the KVM struct
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 7a54455..fcfb03b 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1553,11 +1553,6 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 {
 }
 
-int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
-{
-	return 0;
-}
-
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		struct kvm_memory_slot *memslot,
 		struct kvm_userspace_memory_region *mem,
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 16b4595..aab8039 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -405,9 +405,9 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 	kvmppc_core_free_memslot(free, dont);
 }
 
-int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
+static int kvm_arch_create_memslot(struct kvm_memory_slot *slot)
 {
-	return kvmppc_core_create_memslot(slot, npages);
+	return kvmppc_core_create_memslot(slot, slot->npages);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -415,6 +415,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_userspace_memory_region *mem,
 				   enum kvm_mr_change change)
 {
+	if (change == KVM_MR_CREATE)
+		if (kvm_arch_create_memslot(memslot))
+			return -ENOMEM;
+
 	return kvmppc_core_prepare_memory_region(kvm, memslot, mem);
 }
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 33161b4..7bfd6f6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -967,11 +967,6 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 {
 }
 
-int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
-{
-	return 0;
-}
-
 /* Section: memory related */
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0be7ec..447789c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6875,8 +6875,9 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 	}
 }
 
-int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
+static int kvm_arch_create_memslot(struct kvm_memory_slot *slot)
 {
+	unsigned long npages = slot->npages;
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
@@ -6938,6 +6939,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
+	if (change == KVM_MR_CREATE)
+		if (kvm_arch_create_memslot(memslot))
+			return -ENOMEM;
+
 	/*
 	 * Only private memory slots need to be mapped here since
 	 * KVM_SET_MEMORY_REGION ioctl is no longer supported.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1c0be23..f39ec18 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -493,7 +493,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem);
 void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont);
-int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
 				struct kvm_userspace_memory_region *mem,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d21694a..acc9f30 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -825,13 +825,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		new.dirty_bitmap = NULL;
 
-	r = -ENOMEM;
-	if (change == KVM_MR_CREATE) {
-		new.userspace_addr = mem->userspace_addr;
+	new.userspace_addr = mem->userspace_addr;
 
-		if (kvm_arch_create_memslot(&new, npages))
-			goto out_free;
-	}
+	r = -ENOMEM;
 
 	/* Allocate page dirty bitmap if needed */
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
-- 
1.7.7.6

