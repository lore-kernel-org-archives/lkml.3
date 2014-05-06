Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000AbaEFGTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:19:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135AbaEFGTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:19:33 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: nVMX: rearrange get_vmx_mem_address
Date: Tue,  6 May 2014 02:19:15 -0400
Message-Id: <1399357158-8305-2-git-send-email-bsd@redhat.com>
In-Reply-To: <1399357158-8305-1-git-send-email-bsd@redhat.com>
References: <1399357158-8305-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our common function for vmptr checks (in 2/4) needs to fetch
the memory address

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/vmx.c | 106 ++++++++++++++++++++++++++---------------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1f68c58..c18fe9a4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5775,6 +5775,59 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
 }
 
 /*
+ * Decode the memory-address operand of a vmx instruction, as recorded on an
+ * exit caused by such an instruction (run by a guest hypervisor).
+ * On success, returns 0. When the operand is invalid, returns 1 and throws
+ * #UD or #GP.
+ */
+static int get_vmx_mem_address(struct kvm_vcpu *vcpu,
+				 unsigned long exit_qualification,
+				 u32 vmx_instruction_info, gva_t *ret)
+{
+	/*
+	 * According to Vol. 3B, "Information for VM Exits Due to Instruction
+	 * Execution", on an exit, vmx_instruction_info holds most of the
+	 * addressing components of the operand. Only the displacement part
+	 * is put in exit_qualification (see 3B, "Basic VM-Exit Information").
+	 * For how an actual address is calculated from all these components,
+	 * refer to Vol. 1, "Operand Addressing".
+	 */
+	int  scaling = vmx_instruction_info & 3;
+	int  addr_size = (vmx_instruction_info >> 7) & 7;
+	bool is_reg = vmx_instruction_info & (1u << 10);
+	int  seg_reg = (vmx_instruction_info >> 15) & 7;
+	int  index_reg = (vmx_instruction_info >> 18) & 0xf;
+	bool index_is_valid = !(vmx_instruction_info & (1u << 22));
+	int  base_reg       = (vmx_instruction_info >> 23) & 0xf;
+	bool base_is_valid  = !(vmx_instruction_info & (1u << 27));
+
+	if (is_reg) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	/* Addr = segment_base + offset */
+	/* offset = base + [index * scale] + displacement */
+	*ret = vmx_get_segment_base(vcpu, seg_reg);
+	if (base_is_valid)
+		*ret += kvm_register_read(vcpu, base_reg);
+	if (index_is_valid)
+		*ret += kvm_register_read(vcpu, index_reg)<<scaling;
+	*ret += exit_qualification; /* holds the displacement */
+
+	if (addr_size == 1) /* 32 bit */
+		*ret &= 0xffffffff;
+
+	/*
+	 * TODO: throw #GP (and return 1) in various cases that the VM*
+	 * instructions require it - e.g., offset beyond segment limit,
+	 * unusable or unreadable/unwritable segment, non-canonical 64-bit
+	 * address, and so on. Currently these are not checked.
+	 */
+	return 0;
+}
+
+/*
  * Emulate the VMXON instruction.
  * Currently, we just remember that VMX is active, and do not save or even
  * inspect the argument to VMXON (the so-called "VMXON pointer") because we
@@ -5934,59 +5987,6 @@ static int handle_vmoff(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-/*
- * Decode the memory-address operand of a vmx instruction, as recorded on an
- * exit caused by such an instruction (run by a guest hypervisor).
- * On success, returns 0. When the operand is invalid, returns 1 and throws
- * #UD or #GP.
- */
-static int get_vmx_mem_address(struct kvm_vcpu *vcpu,
-				 unsigned long exit_qualification,
-				 u32 vmx_instruction_info, gva_t *ret)
-{
-	/*
-	 * According to Vol. 3B, "Information for VM Exits Due to Instruction
-	 * Execution", on an exit, vmx_instruction_info holds most of the
-	 * addressing components of the operand. Only the displacement part
-	 * is put in exit_qualification (see 3B, "Basic VM-Exit Information").
-	 * For how an actual address is calculated from all these components,
-	 * refer to Vol. 1, "Operand Addressing".
-	 */
-	int  scaling = vmx_instruction_info & 3;
-	int  addr_size = (vmx_instruction_info >> 7) & 7;
-	bool is_reg = vmx_instruction_info & (1u << 10);
-	int  seg_reg = (vmx_instruction_info >> 15) & 7;
-	int  index_reg = (vmx_instruction_info >> 18) & 0xf;
-	bool index_is_valid = !(vmx_instruction_info & (1u << 22));
-	int  base_reg       = (vmx_instruction_info >> 23) & 0xf;
-	bool base_is_valid  = !(vmx_instruction_info & (1u << 27));
-
-	if (is_reg) {
-		kvm_queue_exception(vcpu, UD_VECTOR);
-		return 1;
-	}
-
-	/* Addr = segment_base + offset */
-	/* offset = base + [index * scale] + displacement */
-	*ret = vmx_get_segment_base(vcpu, seg_reg);
-	if (base_is_valid)
-		*ret += kvm_register_read(vcpu, base_reg);
-	if (index_is_valid)
-		*ret += kvm_register_read(vcpu, index_reg)<<scaling;
-	*ret += exit_qualification; /* holds the displacement */
-
-	if (addr_size == 1) /* 32 bit */
-		*ret &= 0xffffffff;
-
-	/*
-	 * TODO: throw #GP (and return 1) in various cases that the VM*
-	 * instructions require it - e.g., offset beyond segment limit,
-	 * unusable or unreadable/unwritable segment, non-canonical 64-bit
-	 * address, and so on. Currently these are not checked.
-	 */
-	return 0;
-}
-
 /* Emulate the VMCLEAR instruction */
 static int handle_vmclear(struct kvm_vcpu *vcpu)
 {
-- 
1.8.3.1

