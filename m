Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaC0Lci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:32:38 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51128 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaC0Lar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:30:47 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [RFC PATCH 1/5] KVM: vmx: speed up emulation of invalid guest state
Date: Thu, 27 Mar 2014 12:30:34 +0100
Message-Id: <1395919838-18466-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
References: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About 25% of the time spent in emulation of invalid guest state
is wasted in checking whether emulation is required for the next
instruction.  However, this almost never changes except when a
segment register (or TR or LDTR) changes, or when there is a mode
transition (i.e. CR0 changes).

In fact, vmx_set_segment and vmx_set_cr0 already modify
vmx->emulation_required (except that the former for some reason
uses |= instead of just an assignment).  So there is no need to
call guest_state_valid in the emulation loop.

Emulation performance test results indicate 530-870 cycles
for common instructions, versus 740-1110 before this patch.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1320e0f8e611..73aa522db47b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3629,7 +3629,7 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu,
 	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
 
 out:
-	vmx->emulation_required |= emulation_required(vcpu);
+	vmx->emulation_required = emulation_required(vcpu);
 }
 
 static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
@@ -5580,7 +5580,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	cpu_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	intr_window_requested = cpu_exec_ctrl & CPU_BASED_VIRTUAL_INTR_PENDING;
 
-	while (!guest_state_valid(vcpu) && count-- != 0) {
+	while (vmx->emulation_required && count-- != 0) {
 		if (intr_window_requested && vmx_interrupt_allowed(vcpu))
 			return handle_interrupt_window(&vmx->vcpu);
 
@@ -5614,7 +5614,6 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 			schedule();
 	}
 
-	vmx->emulation_required = emulation_required(vcpu);
 out:
 	return ret;
 }
-- 
1.8.3.1


