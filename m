Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaGWHmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:42:42 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:48515 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932081AbaGWHmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:42:39 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33671757"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v3 2/6] kvm: Use APIC_DEFAULT_PHYS_BASE macro as the apic access page address.
Date: Wed, 23 Jul 2014 15:42:06 -0400
Message-ID: <1406144530-23002-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have APIC_DEFAULT_PHYS_BASE defined as 0xfee00000, which is also the address of
apic access page. So use this macro.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kvm/svm.c | 3 ++-
 arch/x86/kvm/vmx.c | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ec8366c..576b525 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1257,7 +1257,8 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->asid_generation = 0;
 	init_vmcb(svm);
 
-	svm->vcpu.arch.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	svm->vcpu.arch.apic_base = APIC_DEFAULT_PHYS_BASE |
+				   MSR_IA32_APICBASE_ENABLE;
 	if (kvm_vcpu_is_bsp(&svm->vcpu))
 		svm->vcpu.arch.apic_base |= MSR_IA32_APICBASE_BSP;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 801332e..0e1117c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3982,13 +3982,13 @@ static int alloc_apic_access_page(struct kvm *kvm)
 		goto out;
 	kvm_userspace_mem.slot = APIC_ACCESS_PAGE_PRIVATE_MEMSLOT;
 	kvm_userspace_mem.flags = 0;
-	kvm_userspace_mem.guest_phys_addr = 0xfee00000ULL;
+	kvm_userspace_mem.guest_phys_addr = APIC_DEFAULT_PHYS_BASE;
 	kvm_userspace_mem.memory_size = PAGE_SIZE;
 	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem);
 	if (r)
 		goto out;
 
-	page = gfn_to_page(kvm, 0xfee00);
+	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (is_error_page(page)) {
 		r = -EFAULT;
 		goto out;
@@ -4460,7 +4460,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	kvm_set_cr8(&vmx->vcpu, 0);
-	apic_base_msr.data = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
 	if (kvm_vcpu_is_bsp(&vmx->vcpu))
 		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
 	apic_base_msr.host_initiated = true;
-- 
1.8.3.1

