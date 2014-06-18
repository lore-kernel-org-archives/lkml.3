Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaFROTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:19:46 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:38610 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaFROTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiRMHFoQtBIo5pyc
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiRMHFoQtBIo5pyc
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034541"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 9/9] KVM: vmx: vmx instructions handling does not consider cs.l
Date: Wed, 18 Jun 2014 17:19:26 +0300
Message-Id: <1403101166-23616-10-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
References: <539F059F.8050501@redhat.com>
 <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMX instructions use 32-bit operands in 32-bit mode, and 64-bit operands in
64-bit mode.  The current implementation is broken since it does not use the
register operands correctly, and always uses 64-bit for reads and writes.
Moreover, write to memory in vmwrite only considers long-mode, so it ignores
cs.l. This patch fixes this behavior.  The field of vmread/vmwrite is kept
intentionally as 64-bit read since if bits [63:32] are not cleared the
instruction should fail, according to Intel SDM.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/vmx.c | 8 ++++----
 arch/x86/kvm/x86.h | 9 +++++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index cbfbb8b..75dc888 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6397,7 +6397,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	 * on the guest's mode (32 or 64 bit), not on the given field's length.
 	 */
 	if (vmx_instruction_info & (1u << 10)) {
-		kvm_register_write(vcpu, (((vmx_instruction_info) >> 3) & 0xf),
+		kvm_register_writel(vcpu, (((vmx_instruction_info) >> 3) & 0xf),
 			field_value);
 	} else {
 		if (get_vmx_mem_address(vcpu, exit_qualification,
@@ -6434,14 +6434,14 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return 1;
 
 	if (vmx_instruction_info & (1u << 10))
-		field_value = kvm_register_read(vcpu,
+		field_value = kvm_register_readl(vcpu,
 			(((vmx_instruction_info) >> 3) & 0xf));
 	else {
 		if (get_vmx_mem_address(vcpu, exit_qualification,
 				vmx_instruction_info, &gva))
 			return 1;
 		if (kvm_read_guest_virt(&vcpu->arch.emulate_ctxt, gva,
-			   &field_value, (is_long_mode(vcpu) ? 8 : 4), &e)) {
+			   &field_value, (is_64_bit_mode(vcpu) ? 8 : 4), &e)) {
 			kvm_inject_page_fault(vcpu, &e);
 			return 1;
 		}
@@ -6571,7 +6571,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	}
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
 
 	types = (nested_vmx_ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c5b61a7..306a1b7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -126,6 +126,15 @@ static inline unsigned long kvm_register_readl(struct kvm_vcpu *vcpu,
 	return is_64_bit_mode(vcpu) ? val : (u32)val;
 }
 
+static inline void kvm_register_writel(struct kvm_vcpu *vcpu,
+				       enum kvm_reg reg,
+				       unsigned long val)
+{
+	if (!is_64_bit_mode(vcpu))
+		val = (u32)val;
+	return kvm_register_write(vcpu, reg, val);
+}
+
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
-- 
1.9.1

