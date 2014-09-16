Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaIPKlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:41:20 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:58727 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753630AbaIPKkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:40:46 -0400
X-IronPort-AV: E=Sophos;i="5.04,534,1406563200"; 
   d="scan'208";a="36022253"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v6 5/6] kvm, mem-hotplug: Reload L1's apic access page on migration when L2 is running.
Date: Tue, 16 Sep 2014 18:42:01 +0800
Message-ID: <1410864122-12434-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410864122-12434-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1410864122-12434-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only handle "L1 and L2 vm share one apic access page" situation.

When L1 vm is running, if the shared apic access page is migrated, mmu_notifier will
request all vcpus to exit to L0, and reload apic access page physical address for
all the vcpus' vmcs (which is done by patch 5/6). And when it enters L2 vm, L2's vmcs
will be updated in prepare_vmcs02() called by nested_vm_run(). So we need to do
nothing.

When L2 vm is running, if the shared apic access page is migrated, mmu_notifier will
request all vcpus to exit to L0, and reload apic access page physical address for
all L2 vmcs. And this patch requests apic access page reload in L2->L1 vmexit.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx.c              | 6 ++++++
 arch/x86/kvm/x86.c              | 3 ++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 514183e..92b3e72 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1046,6 +1046,7 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
+void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu);
 
 void kvm_define_shared_msr(unsigned index, u32 msr);
 void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a1a9797..d0d5981 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8795,6 +8795,12 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
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
index 27c3d30..3f458b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5989,7 +5989,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	kvm_apic_update_tmr(vcpu, tmr);
 }
 
-static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
+void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * apic access page could be migrated. When the page is being migrated,
@@ -6001,6 +6001,7 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
 				page_to_phys(vcpu->kvm->arch.apic_access_page));
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
 
 /*
  * Returns 1 to let __vcpu_run() continue the guest execution loop without
-- 
1.8.3.1

