Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaCGLou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:44:50 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:62040 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaCGLnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:43:08 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Subject: [PATCH 3/7] KVM: x86: Allow the guest to run with dirty debug registers
Date: Fri,  7 Mar 2014 12:42:47 +0100
Message-Id: <1394192571-11056-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
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
registers might be dirty and need to be reloaded (syncing will be taken
care of by a new callback in kvm_x86_ops).  This flag can be set on the
first access to a debug registers, so that multiple accesses to the
debug registers only cause one vmexit.

Note that since the guest will be able to read debug registers and
enable breakpoints in DR7, we need to ensure that they are synchronized
on entry to the guest---including DR6 that was not synced before.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ef59d3b6c63..74eb361eaa8f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -339,6 +339,7 @@ struct kvm_pmu {
 
 enum {
 	KVM_DEBUGREG_BP_ENABLED = 1,
+	KVM_DEBUGREG_WONT_EXIT = 2,
 };
 
 struct kvm_vcpu_arch {
@@ -707,6 +708,7 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	u64 (*get_dr6)(struct kvm_vcpu *vcpu);
 	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
+	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 252b47e85c69..c48818aa04c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6033,12 +6033,28 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
+		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		kvm_x86_ops->sync_dirty_debug_regs(vcpu);
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


