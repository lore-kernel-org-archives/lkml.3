Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaGWHnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:43:16 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:57612 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932293AbaGWHnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:43:12 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33671761"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v3 3/6] kvm: Remove ept_identity_pagetable from struct kvm_arch.
Date: Wed, 23 Jul 2014 15:42:07 -0400
Message-ID: <1406144530-23002-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_arch->ept_identity_pagetable holds the ept identity pagetable page. But
it is never used to refer to the page at all.

In vcpu initialization, it indicates two things:
1. indicates if ept page is allocated
2. indicates if a memory slot for identity page is initialized

Actually, kvm_arch->ept_identity_pagetable_done is enough to tell if the ept
identity pagetable is initialized. So we can remove ept_identity_pagetable.

NOTE: In the original code, ept identity pagetable page is pinned in memroy.
      As a result, it cannot be migrated/hot-removed. After this patch, since
      kvm_arch->ept_identity_pagetable is removed, ept identity pagetable page
      is no longer pinned in memory. And it can be migrated/hot-removed.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/vmx.c              | 50 ++++++++++++++++++++---------------------
 arch/x86/kvm/x86.c              |  2 --
 3 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4931415..62f973e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -578,7 +578,6 @@ struct kvm_arch {
 
 	gpa_t wall_clock;
 
-	struct page *ept_identity_pagetable;
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0e1117c..b8bf47d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -741,6 +741,7 @@ static void vmx_sync_pir_to_irr_dummy(struct kvm_vcpu *vcpu);
 static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx);
 static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx);
 static bool vmx_mpx_supported(void);
+static int alloc_identity_pagetable(struct kvm *kvm);
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
@@ -3921,21 +3922,27 @@ out:
 
 static int init_rmode_identity_map(struct kvm *kvm)
 {
-	int i, idx, r, ret;
+	int i, idx, r, ret = 0;
 	pfn_t identity_map_pfn;
 	u32 tmp;
 
 	if (!enable_ept)
 		return 1;
-	if (unlikely(!kvm->arch.ept_identity_pagetable)) {
-		printk(KERN_ERR "EPT: identity-mapping pagetable "
-			"haven't been allocated!\n");
-		return 0;
+
+	/* Protect kvm->arch.ept_identity_pagetable_done. */
+	mutex_lock(&kvm->slots_lock);
+
+	if (likely(kvm->arch.ept_identity_pagetable_done)) {
+		ret = 1;
+		goto out2;
 	}
-	if (likely(kvm->arch.ept_identity_pagetable_done))
-		return 1;
-	ret = 0;
+
 	identity_map_pfn = kvm->arch.ept_identity_map_addr >> PAGE_SHIFT;
+
+	r = alloc_identity_pagetable(kvm);
+	if (r)
+		goto out2;
+
 	idx = srcu_read_lock(&kvm->srcu);
 	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
 	if (r < 0)
@@ -3953,6 +3960,9 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	ret = 1;
 out:
 	srcu_read_unlock(&kvm->srcu, idx);
+
+out2:
+	mutex_unlock(&kvm->slots_lock);
 	return ret;
 }
 
@@ -4002,31 +4012,23 @@ out:
 
 static int alloc_identity_pagetable(struct kvm *kvm)
 {
-	struct page *page;
+	/*
+	 * In init_rmode_identity_map(), kvm->arch.ept_identity_pagetable_done
+	 * is checked before calling this function and set to true after the
+	 * calling. The access to kvm->arch.ept_identity_pagetable_done should
+	 * be protected by kvm->slots_lock.
+	 */
+
 	struct kvm_userspace_memory_region kvm_userspace_mem;
 	int r = 0;
 
-	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.ept_identity_pagetable)
-		goto out;
 	kvm_userspace_mem.slot = IDENTITY_PAGETABLE_PRIVATE_MEMSLOT;
 	kvm_userspace_mem.flags = 0;
 	kvm_userspace_mem.guest_phys_addr =
 		kvm->arch.ept_identity_map_addr;
 	kvm_userspace_mem.memory_size = PAGE_SIZE;
 	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem);
-	if (r)
-		goto out;
 
-	page = gfn_to_page(kvm, kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
-	if (is_error_page(page)) {
-		r = -EFAULT;
-		goto out;
-	}
-
-	kvm->arch.ept_identity_pagetable = page;
-out:
-	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
 
@@ -7582,8 +7584,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 			kvm->arch.ept_identity_map_addr =
 				VMX_EPT_IDENTITY_PAGETABLE_ADDR;
 		err = -ENOMEM;
-		if (alloc_identity_pagetable(kvm) != 0)
-			goto free_vmcs;
 		if (!init_rmode_identity_map(kvm))
 			goto free_vmcs;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..ffbe557 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7177,8 +7177,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_free_vcpus(kvm);
 	if (kvm->arch.apic_access_page)
 		put_page(kvm->arch.apic_access_page);
-	if (kvm->arch.ept_identity_pagetable)
-		put_page(kvm->arch.ept_identity_pagetable);
 	kfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 }
 
-- 
1.8.3.1

