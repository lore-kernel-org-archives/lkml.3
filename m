Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaITKqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 06:46:37 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20742 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755961AbaITKqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 06:46:35 -0400
X-IronPort-AV: E=Sophos;i="5.04,559,1406563200"; 
   d="scan'208";a="36212245"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v7 7/9] kvm, mem-hotplug: Reload L1's apic access page on migration when L2 is running.
Date: Sat, 20 Sep 2014 18:47:49 +0800
Message-ID: <1411210071-14727-8-git-send-email-tangchen@cn.fujitsu.com>
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

This patch handles 3).

In L0->L2 entry, L2's vmcs will be updated in prepare_vmcs02() called by
nested_vm_run(). So we need to do nothing.

In L2->L1 exit, this patch requests apic access page reload in L2->L1 vmexit.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx.c              | 6 ++++++
 arch/x86/kvm/x86.c              | 3 ++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 56156eb..1a8317e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1047,6 +1047,7 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
+void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu);
 
 void kvm_define_shared_msr(unsigned index, u32 msr);
 void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c8e90ec..baac78a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8803,6 +8803,12 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	}
 
 	/*
+	 * We are now running in L2, mmu_notifier will force to reload the
+	 * page's hpa for L2 vmcs. Need to reload it for L1 before entering L1.
+	 */
+	kvm_vcpu_reload_apic_access_page(vcpu);
+
+	/*
 	 * Exiting from L2 to L1, we're now back to L1 which thinks it just
 	 * finished a VMLAUNCH or VMRESUME instruction, so we need to set the
 	 * success or failure flag accordingly.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc54fa6..2ae2dc7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5989,7 +5989,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	kvm_apic_update_tmr(vcpu, tmr);
 }
 
-static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
+void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Only APIC access page shared by L1 and L2 vm is handled. The APIC
@@ -6009,6 +6009,7 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 				page_to_phys(vcpu->kvm->arch.apic_access_page));
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
 
 /*
  * Returns 1 to let __vcpu_run() continue the guest execution loop without
-- 
1.8.3.1

