Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaCGLnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:43:13 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64271 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaCGLnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:43:10 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Subject: [PATCH 4/7] KVM: vmx: Allow the guest to run with dirty debug registers
Date: Fri,  7 Mar 2014 12:42:48 +0100
Message-Id: <1394192571-11056-5-git-send-email-pbonzini@redhat.com>
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
 arch/x86/kvm/vmx.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 06e4ec877a1c..e377522408b1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2843,7 +2843,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		      vmx_capability.ept, vmx_capability.vpid);
 	}
 
-	min = 0;
+	min = VM_EXIT_SAVE_DEBUG_CONTROLS;
 #ifdef CONFIG_X86_64
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
 #endif
@@ -5113,6 +5113,22 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (vcpu->guest_debug == 0) {
+		u32 cpu_based_vm_exec_control;
+
+		cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+		cpu_based_vm_exec_control &= ~CPU_BASED_MOV_DR_EXITING;
+		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
+
+		/*
+		 * No more DR vmexits; force a reload of the debug registers
+		 * and reenter on this instruction.  The next vmexit will
+		 * retrieve the full state of the debug registers.
+		 */
+		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
+		return 1;
+	}
+
 	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	dr = exit_qualification & DEBUG_REG_ACCESS_NUM;
 	reg = DEBUG_REG_ACCESS_REG(exit_qualification);
@@ -5139,6 +5155,24 @@ static void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
 {
 }
 
+static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
+{
+	u32 cpu_based_vm_exec_control;
+
+	get_debugreg(vcpu->arch.db[0], 0);
+	get_debugreg(vcpu->arch.db[1], 1);
+	get_debugreg(vcpu->arch.db[2], 2);
+	get_debugreg(vcpu->arch.db[3], 3);
+	get_debugreg(vcpu->arch.dr6, 6);
+	vcpu->arch.dr7 = vmcs_readl(GUEST_DR7);
+
+	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
+
+	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+	cpu_based_vm_exec_control |= CPU_BASED_MOV_DR_EXITING;
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
+}
+
 static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vmcs_writel(GUEST_DR7, val);
@@ -8590,6 +8624,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.get_dr6 = vmx_get_dr6,
 	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
+	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
 	.get_rflags = vmx_get_rflags,
 	.set_rflags = vmx_set_rflags,
-- 
1.8.3.1


