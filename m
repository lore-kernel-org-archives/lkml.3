Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBZPti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:49:38 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:41621 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaBZPte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:49:34 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Subject: [PATCH 3/4] KVM: x86: Allow the guest to run with dirty debug registers
Date: Wed, 26 Feb 2014 16:49:12 +0100
Message-Id: <1393429753-20857-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393429753-20857-1-git-send-email-pbonzini@redhat.com>
References: <1393429753-20857-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When not running in guest-debug mode, the guest controls the debug
registers and having to take an exit for each DR access is a waste
of time.  If the guest gets into a state where each context switch
causes DR to be saved and restored, this can take away as much as 40%
of the execution time from the guest.

After this patch, VMX- and SVM-specific code can set a flag in
switch_db_regs, telling vcpu_enter_guest that on the next exit the debug
registers might be dirty and need to be reloaded.  This flag can be set
on the first access to a debug registers, so that multiple accesses to
the debug registers only cause one vmexit.

Note that since the guest will be able to read debug registers and
enable breakpoints in DR7, we need to ensure that they are synchronized
on entry to the guest---including DR6 that was not synced before.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 25 ++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6b3b067f4780..f4b34e071d14 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -339,6 +339,7 @@ struct kvm_pmu {
 
 enum {
 	KVM_DEBUGREG_BP_ENABLED = 1,
+	KVM_DEBUGREG_WONT_EXIT = 2,
 };
 
 struct kvm_vcpu_arch {
@@ -705,6 +706,7 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	u64 (*get_dr6)(struct kvm_vcpu *vcpu);
 	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
+	u64 (*get_dr7)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c01dddce6df0..b4b802cad8fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5998,12 +5998,35 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[1], 1);
 		set_debugreg(vcpu->arch.eff_db[2], 2);
 		set_debugreg(vcpu->arch.eff_db[3], 3);
+		set_debugreg(vcpu->arch.dr6, 6);
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
 	kvm_x86_ops->run(vcpu);
 
 	/*
+	 * Do this here before restoring debug registers on the host.  And
+	 * since we do this before handling the vmexit, a DR access vmexit
+	 * can (a) read the correct value of the debug registers, (b) set
+	 * KVM_DEBUGREG_WONT_EXIT again.
+	 */
+	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
+		int i;
+
+		get_debugreg(vcpu->arch.db[0], 0);
+		get_debugreg(vcpu->arch.db[1], 1);
+		get_debugreg(vcpu->arch.db[2], 2);
+		get_debugreg(vcpu->arch.db[3], 3);
+		get_debugreg(vcpu->arch.dr6, 6);
+		vcpu->arch.dr7 = kvm_x86_ops->get_dr7(vcpu);
+		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
+
+		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		for (i = 0; i < KVM_NR_DB_REGS; i++)
+			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
+	}
+
+	/*
 	 * If the guest has used debug registers, at least dr7
 	 * will be disabled while returning to the host.
 	 * If we don't have active breakpoints in the host, we don't
-- 
1.8.3.1


