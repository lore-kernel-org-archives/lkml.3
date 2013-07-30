Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3G3PMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:12:16 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53878 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab3G3PLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:11:47 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gnatapov@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: handle hardware breakpoints during emulation
Date: Tue, 30 Jul 2013 17:11:35 +0200
Message-Id: <1375197096-2454-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375197096-2454-1-git-send-email-pbonzini@redhat.com>
References: <1375197096-2454-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets debugging work better during emulation of invalid
guest state.

The check is done before emulating the instruction, and (in the case
of guest debugging) reuses EMULATE_DO_MMIO to exit with KVM_EXIT_DEBUG.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c2a0674..1368cf5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4956,6 +4956,62 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
 static int complete_emulated_pio(struct kvm_vcpu *vcpu);
 
+static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
+				unsigned long *db)
+{
+	u32 dr6 = 0;
+	int i;
+	u32 enable, rwlen;
+
+	enable = dr7;
+	rwlen = dr7 >> 16;
+	for (i = 0; i < 4; i++, enable >>= 2, rwlen >>= 4)
+		if ((enable & 3) && (rwlen & 15) == type && db[i] == addr)
+			dr6 |= (1 << i);
+	return dr6;
+}
+
+static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
+{
+	struct kvm_run *kvm_run = vcpu->run;
+	unsigned long eip = vcpu->arch.emulate_ctxt.eip;
+	u32 dr6 = 0;
+
+	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
+	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
+		dr6 = kvm_vcpu_check_hw_bp(eip, 0,
+					   vcpu->arch.guest_debug_dr7,
+					   vcpu->arch.eff_db);
+
+		if (dr6 != 0) {
+			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
+			kvm_run->debug.arch.pc = kvm_rip_read(vcpu) +
+				get_segment_base(vcpu, VCPU_SREG_CS);
+
+			kvm_run->debug.arch.exception = DB_VECTOR;
+			kvm_run->exit_reason = KVM_EXIT_DEBUG;
+			*r = EMULATE_USER_EXIT;
+			return true;
+		}
+	}
+
+	if (unlikely(vcpu->arch.dr7 & DR7_BP_EN_MASK)) {
+		dr6 = kvm_vcpu_check_hw_bp(eip, 0,
+					   vcpu->arch.dr7,
+					   vcpu->arch.db);
+
+		if (dr6 != 0) {
+			vcpu->arch.dr6 &= ~15;
+			vcpu->arch.dr6 |= dr6;
+			kvm_queue_exception(vcpu, DB_VECTOR);
+			*r = EMULATE_DONE;
+			return true;
+		}
+	}
+
+	return false;
+}
+
 int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			    unsigned long cr2,
 			    int emulation_type,
@@ -4976,6 +5032,16 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		init_emulate_ctxt(vcpu);
+
+		/*
+		 * We will reenter on the same instruction since
+		 * we do not set complete_userspace_io.  This does not
+		 * handle watchpoints yet, those would be handled in
+		 * the emulate_ops.
+		 */
+		if (kvm_vcpu_check_breakpoint(vcpu, &r))
+			return r;
+
 		ctxt->interruptibility = 0;
 		ctxt->have_exception = false;
 		ctxt->perm_ok = false;
-- 
1.8.1.4


