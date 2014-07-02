Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaGBI76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:59:58 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:28751 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752913AbaGBI7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:59:53 -0400
X-IronPort-AV: E=Sophos;i="5.00,818,1396972800"; 
   d="scan'208";a="32730465"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH 2/4] kvm: Add macro VMX_APIC_ACCESS_PAGE_ADDR
Date: Wed, 2 Jul 2014 17:00:35 +0800
Message-ID: <1404291637-15048-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define guest phys_addr of apic access page.
---
 arch/x86/include/asm/vmx.h | 2 +-
 arch/x86/kvm/svm.c         | 3 ++-
 arch/x86/kvm/vmx.c         | 7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 7004d21..c4672d1 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -422,7 +422,7 @@ enum vmcs_field {
 #define VMX_EPT_DIRTY_BIT				(1ull << 9)
 
 #define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
-
+#define VMX_APIC_ACCESS_PAGE_ADDR		0xfee00000ull
 
 #define ASM_VMX_VMCLEAR_RAX       ".byte 0x66, 0x0f, 0xc7, 0x30"
 #define ASM_VMX_VMLAUNCH          ".byte 0x0f, 0x01, 0xc2"
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ec8366c..22aa2ae 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1257,7 +1257,8 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->asid_generation = 0;
 	init_vmcb(svm);
 
-	svm->vcpu.arch.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	svm->vcpu.arch.apic_base = VMX_APIC_ACCESS_PAGE_ADDR |
+				   MSR_IA32_APICBASE_ENABLE;
 	if (kvm_vcpu_is_bsp(&svm->vcpu))
 		svm->vcpu.arch.apic_base |= MSR_IA32_APICBASE_BSP;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 801332e..366b5b3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3982,13 +3982,13 @@ static int alloc_apic_access_page(struct kvm *kvm)
 		goto out;
 	kvm_userspace_mem.slot = APIC_ACCESS_PAGE_PRIVATE_MEMSLOT;
 	kvm_userspace_mem.flags = 0;
-	kvm_userspace_mem.guest_phys_addr = 0xfee00000ULL;
+	kvm_userspace_mem.guest_phys_addr = VMX_APIC_ACCESS_PAGE_ADDR;
 	kvm_userspace_mem.memory_size = PAGE_SIZE;
 	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem);
 	if (r)
 		goto out;
 
-	page = gfn_to_page(kvm, 0xfee00);
+	page = gfn_to_page(kvm, VMX_APIC_ACCESS_PAGE_ADDR >> PAGE_SHIFT);
 	if (is_error_page(page)) {
 		r = -EFAULT;
 		goto out;
@@ -4460,7 +4460,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	kvm_set_cr8(&vmx->vcpu, 0);
-	apic_base_msr.data = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	apic_base_msr.data = VMX_APIC_ACCESS_PAGE_ADDR |
+			     MSR_IA32_APICBASE_ENABLE;
 	if (kvm_vcpu_is_bsp(&vmx->vcpu))
 		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
 	apic_base_msr.host_initiated = true;
-- 
1.8.3.1

