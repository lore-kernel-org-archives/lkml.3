Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072AbaEFGUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:20:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933954AbaEFGTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:19:35 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: nVMX: fail on invalid vmclear/vmptrld pointer
Date: Tue,  6 May 2014 02:19:17 -0400
Message-Id: <1399357158-8305-4-git-send-email-bsd@redhat.com>
In-Reply-To: <1399357158-8305-1-git-send-email-bsd@redhat.com>
References: <1399357158-8305-1-git-send-email-bsd@redhat.com>
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
index 059906a..6c125ff 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6083,6 +6083,12 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
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
@@ -6426,6 +6432,12 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	if (vmptr == vmx->nested.vmxon_ptr) {
+		nested_vmx_failValid(vcpu, VMXERR_VMCLEAR_VMXON_POINTER);
+		skip_emulated_instruction(vcpu);
+		return 1;
+	}
+
 	if (vmx->nested.current_vmptr != vmptr) {
 		struct vmcs12 *new_vmcs12;
 		struct page *page;
-- 
1.8.3.1

