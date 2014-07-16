Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaGPWT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:19:56 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:55124 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaGPWTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:19:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AosBAED5xlOERCABjGdsb2JhbABahDewdZIzh1GBDBYPAQEBJz2EMVKBUYhCxA6GRReOZ2QdhC0Fil6oMmmBAw
X-IPAS-Result: AosBAED5xlOERCABjGdsb2JhbABahDewdZIzh1GBDBYPAQEBJz2EMVKBUYhCxA6GRReOZ2QdhC0Fil6oMmmBAw
X-IronPort-AV: E=Sophos;i="5.01,674,1400014800"; 
   d="scan'208";a="115866855"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: emulator injects #DB when RFLAGS.RF is set
Date: Thu, 17 Jul 2014 01:19:31 +0300
Message-Id: <1405549171-30909-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the RFLAGS.RF is set, then no #DB should occur on instruction breakpoints.
However, the KVM emulator injects #DB regardless to RFLAGS.RF. This patch fixes
this behavior. KVM, however, still appears not to update RFLAGS.RF correctly,
regardless of this patch.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fae064f..e341a81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5168,7 +5168,8 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 		}
 	}
 
-	if (unlikely(vcpu->arch.dr7 & DR7_BP_EN_MASK)) {
+	if (unlikely(vcpu->arch.dr7 & DR7_BP_EN_MASK) &&
+	    !(kvm_get_rflags(vcpu) & X86_EFLAGS_RF)) {
 		dr6 = kvm_vcpu_check_hw_bp(eip, 0,
 					   vcpu->arch.dr7,
 					   vcpu->arch.db);
-- 
1.9.1

