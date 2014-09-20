Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbaITKqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 06:46:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20742 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756166AbaITKqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 06:46:40 -0400
X-IronPort-AV: E=Sophos;i="5.04,559,1406563200"; 
   d="scan'208";a="36212247"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v7 9/9] kvm, mem-hotplug: Unpin and remove kvm_arch->apic_access_page.
Date: Sat, 20 Sep 2014 18:47:51 +0800
Message-ID: <1411210071-14727-10-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make apic access page migratable, we do not pin it in memory now.
When it is migrated, we should reload its physical address for all
vmcses. But when we tried to do this, all vcpu will access
kvm_arch->apic_access_page without any locking. This is not safe.

Actually, we do not need kvm_arch->apic_access_page anymore. Since
apic access page is not pinned in memory now, we can remove
kvm_arch->apic_access_page. When we need to write its physical address
into vmcs, use gfn_to_page() to get its page struct, which will also
pin it. And unpin it after then.

Suggested-by: Gleb Natapov <gleb@kernel.org>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx.c              | 15 +++++++++------
 arch/x86/kvm/x86.c              | 16 +++++++++++-----
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a8317e..9fb3d4c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -576,7 +576,7 @@ struct kvm_arch {
 	struct kvm_apic_map *apic_map;
 
 	unsigned int tss_addr;
-	struct page *apic_access_page;
+	bool apic_access_page_done;
 
 	gpa_t wall_clock;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index baac78a..12f0715 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4002,7 +4002,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	int r = 0;
 
 	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.apic_access_page)
+	if (kvm->arch.apic_access_page_done)
 		goto out;
 	kvm_userspace_mem.slot = APIC_ACCESS_PAGE_PRIVATE_MEMSLOT;
 	kvm_userspace_mem.flags = 0;
@@ -4018,7 +4018,12 @@ static int alloc_apic_access_page(struct kvm *kvm)
 		goto out;
 	}
 
-	kvm->arch.apic_access_page = page;
+	/*
+	 * Do not pin apic access page in memory so that memory hotplug
+	 * process is able to migrate it.
+	 */
+	put_page(page);
+	kvm->arch.apic_access_page_done = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return r;
@@ -4534,8 +4539,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	}
 
 	if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm))
-		vmcs_write64(APIC_ACCESS_ADDR,
-			     page_to_phys(vmx->vcpu.kvm->arch.apic_access_page));
+		kvm_vcpu_reload_apic_access_page(vcpu);
 
 	if (vmx_vm_has_apicv(vcpu->kvm))
 		memset(&vmx->pi_desc, 0, sizeof(struct pi_desc));
@@ -8003,8 +8007,7 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		} else if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
 			exec_control |=
 				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
-			vmcs_write64(APIC_ACCESS_ADDR,
-				page_to_phys(vcpu->kvm->arch.apic_access_page));
+			kvm_vcpu_reload_apic_access_page(vcpu);
 		}
 
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7dd4179..996af6e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5991,6 +5991,8 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
+	struct page *page = NULL;
+
 	/*
 	 * Only APIC access page shared by L1 and L2 vm is handled. The APIC
 	 * access page prepared by L1 for L2's execution is still pinned in
@@ -6003,10 +6005,16 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 		 * migrated, GUP will wait till the migrate entry is replaced
 		 * with the new pte entry pointing to the new page.
 		 */
-		vcpu->kvm->arch.apic_access_page = gfn_to_page(vcpu->kvm,
-				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+		page = gfn_to_page(vcpu->kvm,
+				   APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 		kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
-				page_to_phys(vcpu->kvm->arch.apic_access_page));
+						       page_to_phys(page));
+
+		/*
+		 * Do not pin apic access page in memory so that memory hotplug
+		 * process is able to migrate it.
+		 */
+		put_page(page);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
@@ -7272,8 +7280,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
 	kvm_free_vcpus(kvm);
-	if (kvm->arch.apic_access_page)
-		put_page(kvm->arch.apic_access_page);
 	kfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 }
 
-- 
1.8.3.1

