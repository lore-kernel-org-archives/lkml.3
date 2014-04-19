Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034AbaDSWT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 18:19:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbaDSWSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 18:18:07 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] KVM: nVMX: Don't advertise single context invalidation for invept
Date: Sat, 19 Apr 2014 18:17:44 -0400
Message-Id: <1397945866-6961-2-git-send-email-bsd@redhat.com>
In-Reply-To: <1397945866-6961-1-git-send-email-bsd@redhat.com>
References: <1397945866-6961-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For single context invalidation, we fall through to global
invalidation in handle_invept() except for one case - when
the operand supplied by L1 is different from what we have in
vmcs12. However, typically hypervisors will only call invept
for the currently loaded eptp, so the condition will
never be true.

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/vmx.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1f68c58..ce8f6c4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2353,12 +2353,11 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 			 VMX_EPT_INVEPT_BIT;
 		nested_vmx_ept_caps &= vmx_capability.ept;
 		/*
-		 * Since invept is completely emulated we support both global
-		 * and context invalidation independent of what host cpu
-		 * supports
+		 * For nested guests, we don't do anything specific
+		 * for single context invalidation. Hence, only advertise
+		 * support for global context invalidation.
 		 */
-		nested_vmx_ept_caps |= VMX_EPT_EXTENT_GLOBAL_BIT |
-			VMX_EPT_EXTENT_CONTEXT_BIT;
+		nested_vmx_ept_caps |= VMX_EPT_EXTENT_GLOBAL_BIT;
 	} else
 		nested_vmx_ept_caps = 0;
 
@@ -6434,7 +6433,6 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	struct {
 		u64 eptp, gpa;
 	} operand;
-	u64 eptp_mask = ((1ull << 51) - 1) & PAGE_MASK;
 
 	if (!(nested_vmx_secondary_ctls_high & SECONDARY_EXEC_ENABLE_EPT) ||
 	    !(nested_vmx_ept_caps & VMX_EPT_INVEPT_BIT)) {
@@ -6474,16 +6472,13 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	}
 
 	switch (type) {
-	case VMX_EPT_EXTENT_CONTEXT:
-		if ((operand.eptp & eptp_mask) !=
-				(nested_ept_get_cr3(vcpu) & eptp_mask))
-			break;
 	case VMX_EPT_EXTENT_GLOBAL:
 		kvm_mmu_sync_roots(vcpu);
 		kvm_mmu_flush_tlb(vcpu);
 		nested_vmx_succeed(vcpu);
 		break;
 	default:
+		/* Trap single context invalidation invept calls */
 		BUG_ON(1);
 		break;
 	}
-- 
1.8.3.1

