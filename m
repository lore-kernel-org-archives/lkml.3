Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaITKqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 06:46:40 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20742 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756072AbaITKqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 06:46:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,559,1406563200"; 
   d="scan'208";a="36212246"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v7 8/9] kvm, mem-hotplug: Add arch specific mmu notifier to handle apic access migration.
Date: Sat, 20 Sep 2014 18:47:50 +0800
Message-ID: <1411210071-14727-9-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are handling "L1 and L2 share one apic access page" situation when migrating
apic access page. We should do some handling when migration happens in the
following situations:

   1) when L0 is running: Update L1's vmcs in the next L0->L1 entry and L2's
      vmcs in the next L1->L2 entry.

   2) when L1 is running: Force a L1->L0 exit, update L1's vmcs in the next
      L0->L1 entry and L2's vmcs in the next L1->L2 entry.

   3) when L2 is running: Force a L2->L0 exit, update L2's vmcs in the next
      L0->L2 entry and L1's vmcs in the next L2->L1 exit.

This patch force a L1->L0 exit or L2->L0 exit when shared apic access page is
migrated using mmu notifier. Since apic access page is only used on intel x86,
this is arch specific code.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c       | 11 +++++++++++
 include/linux/kvm_host.h | 14 +++++++++++++-
 virt/kvm/kvm_main.c      |  3 +++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2ae2dc7..7dd4179 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6011,6 +6011,17 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
 
+void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
+					   unsigned long address)
+{
+	/*
+	 * The physical address of apic access page is stored in VMCS.
+	 * Update it when it becomes invalid.
+	 */
+	if (address == gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT))
+		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
+}
+
 /*
  * Returns 1 to let __vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 73de13c..b6e4d38 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -917,7 +917,19 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 		return 1;
 	return 0;
 }
-#endif
+
+#ifdef _ASM_X86_KVM_HOST_H
+void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
+					   unsigned long address);
+#else /* _ASM_X86_KVM_HOST_H */
+inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
+						  unsigned long address)
+{
+	return;
+}
+#endif /* _ASM_X86_KVM_HOST_H */
+
+#endif /* CONFIG_MMU_NOTIFIER & KVM_ARCH_WANT_MMU_NOTIFIER */
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0f8b6f6..5427973d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -295,6 +295,9 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
+
+	kvm_arch_mmu_notifier_invalidate_page(kvm, address);
+
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-- 
1.8.3.1

