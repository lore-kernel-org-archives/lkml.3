Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaCGLnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:43:43 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53625 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaCGLnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:43:17 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Subject: [PATCH 7/7] KVM: svm: Allow the guest to run with dirty debug registers
Date: Fri,  7 Mar 2014 12:42:51 +0100
Message-Id: <1394192571-11056-8-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When not running in guest-debug mode (i.e. the guest controls the debug
registers, having to take an exit for each DR access is a waste of time.
If the guest gets into a state where each context switch causes DR to be
saved and restored, this can take away as much as 40% of the execution
time from the guest.

If the guest is running with vcpu->arch.db == vcpu->arch.eff_db, we
can let it write freely to the debug registers and reload them on the
next exit.  We still need to exit on the first access, so that the
KVM_DEBUGREG_WONT_EXIT flag is set in switch_db_regs; after that, further
accesses to the debug registers will not cause a vmexit.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5ed67e9739f6..ac68edccc57c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1683,6 +1683,21 @@ static void svm_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
 	mark_dirty(svm->vmcb, VMCB_DR);
 }
 
+static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	get_debugreg(vcpu->arch.db[0], 0);
+	get_debugreg(vcpu->arch.db[1], 1);
+	get_debugreg(vcpu->arch.db[2], 2);
+	get_debugreg(vcpu->arch.db[3], 3);
+	vcpu->arch.dr6 = svm_get_dr6(vcpu);
+	vcpu->arch.dr7 = svm->vmcb->save.dr7;
+
+	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
+	set_dr_intercepts(svm);
+}
+
 static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2974,6 +2989,17 @@ static int dr_interception(struct vcpu_svm *svm)
 	unsigned long val;
 	int err;
 
+	if (svm->vcpu.guest_debug == 0) {
+		/*
+		 * No more DR vmexits; force a reload of the debug registers
+		 * and reenter on this instruction.  The next vmexit will
+		 * retrieve the full state of the debug registers.
+		 */
+		clr_dr_intercepts(svm);
+		svm->vcpu.arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
+		return 1;
+	}
+
 	if (!boot_cpu_has(X86_FEATURE_DECODEASSISTS))
 		return emulate_on_interception(svm);
 
@@ -4302,6 +4328,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.get_dr6 = svm_get_dr6,
 	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
+	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
 	.get_rflags = svm_get_rflags,
 	.set_rflags = svm_set_rflags,
-- 
1.8.3.1

