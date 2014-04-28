Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaD1FBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 01:01:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbaD1FA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 01:00:58 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: nVMX: fail on invalid vmclear/vmptrld pointer
Date: Mon, 28 Apr 2014 01:00:04 -0400
Message-Id: <1398661204-4822-4-git-send-email-bsd@redhat.com>
In-Reply-To: <1398661204-4822-1-git-send-email-bsd@redhat.com>
References: <1398661204-4822-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spec mandates that if the vmptrld or vmclear
address is equal to the vmxon region pointer, the
instruction should fail with error "VMPTRLD with
VMXON pointer" or "VMCLEAR with VMXON pointer"

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/vmx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d5342c7..8864fa1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6069,6 +6069,12 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	if (vmptr == vmx->nested.vmxon_ptr) {
+		nested_vmx_failValid(vcpu, VMXERR_VMCLEAR_VMXON_POINTER);
+		skip_emulated_instruction(vcpu);
+		return 1;
+	}
+
 	if (vmptr == vmx->nested.current_vmptr) {
 		nested_release_vmcs12(vmx);
 		vmx->nested.current_vmptr = -1ull;
@@ -6412,6 +6418,12 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	if (vmptr == vmx->nested.vmxon_ptr) {
+		nested_vmx_failValid(vcpu, VMXERR_VMPTRLD_VMXON_POINTER);
+		skip_emulated_instruction(vcpu);
+		return 1;
+	}
+
 	if (vmx->nested.current_vmptr != vmptr) {
 		struct vmcs12 *new_vmcs12;
 		struct page *page;
-- 
1.8.3.1

