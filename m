Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412Ab3E3QBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:01:03 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39621 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934275Ab3E3QAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:00:43 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gnatapov@redhat.com, jan.kiszka@siemens.com
Subject: [PATCH 1/2] KVM: x86: handle hardware breakpoints during emulation
Date: Thu, 30 May 2013 18:00:30 +0200
Message-Id: <1369929631-2101-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929631-2101-1-git-send-email-pbonzini@redhat.com>
References: <1369929631-2101-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets debugging work better during emulation of invalid
guest state.

The check is done before emulating the instruction, and (in the case
of guest debugging) reuses EMULATE_DO_MMIO to exit with KVM_EXIT_DEBUG.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/x86.c              | 65 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e2e09f3..aefd8c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -788,9 +788,10 @@ extern u32  kvm_min_guest_tsc_khz;
 extern u32  kvm_max_guest_tsc_khz;
 
 enum emulation_result {
-	EMULATE_DONE,       /* no further processing */
-	EMULATE_DO_MMIO,      /* kvm_run filled with mmio request */
+	EMULATE_DONE,         /* no further processing */
+	EMULATE_DO_MMIO,      /* kvm_run ready for userspace exit */
 	EMULATE_FAIL,         /* can't emulate this instruction */
+	EMULATE_PROCEED,      /* proceed with rest of emulation */
 };
 
 #define EMULTYPE_NO_DECODE	    (1 << 0)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d928af..33b51bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4872,6 +4872,60 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
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
+static int kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu)
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
+			return EMULATE_DO_MMIO;
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
+			return EMULATE_DONE;
+		}
+	}
+
+	return EMULATE_PROCEED;
+}
+
 int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			    unsigned long cr2,
 			    int emulation_type,
@@ -4892,6 +4946,17 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		init_emulate_ctxt(vcpu);
+
+		/*
+		 * We will reenter on the same instruction since
+		 * we do not set complete_userspace_io.  This does not
+		 * handle watchpoints yet, those would be handled in
+		 * the emulate_ops.
+		 */
+		r = kvm_vcpu_check_breakpoint(vcpu);
+		if (r != EMULATE_PROCEED)
+			return r;
+
 		ctxt->interruptibility = 0;
 		ctxt->have_exception = false;
 		ctxt->perm_ok = false;
-- 
1.8.1.4


