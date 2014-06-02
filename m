Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaFBPey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:34:54 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:37075 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaFBPei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHhEAEih+mSYFq
X-IPAS-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHhEAEih+mSYFq
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853177"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 7/9] KVM: x86: rdpmc emulation checks the counter incorrectly
Date: Mon,  2 Jun 2014 18:34:09 +0300
Message-Id: <1401723251-8034-8-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rdpmc emulation checks that the counter (ECX) is not higher than 2, without
taking into considerations bits 30:31 role (e.g., bit 30 marks whether the
counter is fixed). The fix uses the pmu information for checking the validity
of the pmu counter.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/include/asm/kvm_emulate.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/emulate.c             | 2 +-
 arch/x86/kvm/pmu.c                 | 9 +++++++++
 arch/x86/kvm/x86.c                 | 7 +++++++
 5 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index a04fe4e..ffa2671 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -194,6 +194,7 @@ struct x86_emulate_ops {
 	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
 	int (*set_msr)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
 	int (*get_msr)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
+	int (*check_pmc)(struct x86_emulate_ctxt *ctxt, u32 pmc);
 	int (*read_pmc)(struct x86_emulate_ctxt *ctxt, u32 pmc, u64 *pdata);
 	void (*halt)(struct x86_emulate_ctxt *ctxt);
 	void (*wbinvd)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4931415..63e020b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1070,6 +1070,7 @@ void kvm_pmu_cpuid_update(struct kvm_vcpu *vcpu);
 bool kvm_pmu_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+int kvm_pmu_check_pmc(struct kvm_vcpu *vcpu, unsigned pmc);
 int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 void kvm_handle_pmu_event(struct kvm_vcpu *vcpu);
 void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index be3f764..3da8d82 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3507,7 +3507,7 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 	u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
 
 	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
-	    (rcx > 3))
+	    ctxt->ops->check_pmc(ctxt, rcx))
 		return emulate_gp(ctxt, 0);
 
 	return X86EMUL_CONTINUE;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cbecaa9..3dd6acc 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -428,6 +428,15 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+int kvm_pmu_check_pmc(struct kvm_vcpu *vcpu, unsigned pmc)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	bool fixed = pmc & (1u << 30);
+	pmc &= ~(3u << 30);
+	return (!fixed && pmc >= pmu->nr_arch_gp_counters) ||
+		(fixed && pmc >= pmu->nr_arch_fixed_counters);
+}
+
 int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 57eac30..2c6fccd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4759,6 +4759,12 @@ static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
 	return kvm_set_msr(emul_to_vcpu(ctxt), &msr);
 }
 
+static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,
+			      u32 pmc)
+{
+	return kvm_pmu_check_pmc(emul_to_vcpu(ctxt), pmc);
+}
+
 static int emulator_read_pmc(struct x86_emulate_ctxt *ctxt,
 			     u32 pmc, u64 *pdata)
 {
@@ -4835,6 +4841,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.set_dr              = emulator_set_dr,
 	.set_msr             = emulator_set_msr,
 	.get_msr             = emulator_get_msr,
+	.check_pmc	     = emulator_check_pmc,
 	.read_pmc            = emulator_read_pmc,
 	.halt                = emulator_halt,
 	.wbinvd              = emulator_wbinvd,
-- 
1.9.1

