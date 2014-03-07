Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaCGLoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:44:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47389 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaCGLnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:43:12 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Subject: [PATCH 5/7] KVM: nVMX: Allow nested guests to run with dirty debug registers
Date: Fri,  7 Mar 2014 12:42:49 +0100
Message-Id: <1394192571-11056-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When preparing the VMCS02, the CPU-based execution controls is computed
by vmx_exec_control.  Turn off DR access exits there, too, if the
KVM_DEBUGREG_WONT_EXIT bit is set in switch_db_regs.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e377522408b1..73ced6efc93e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4234,6 +4234,10 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 {
 	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
+
+	if (vmx->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
+		exec_control &= ~CPU_BASED_MOV_DR_EXITING;
+
 	if (!vm_need_tpr_shadow(vmx->vcpu.kvm)) {
 		exec_control &= ~CPU_BASED_TPR_SHADOW;
 #ifdef CONFIG_X86_64
-- 
1.8.3.1


