Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966846AbaFROZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:25:52 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:23258 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbaFROTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEAwEBAgMnUhAgMSE2GYguAxHGNg1YhV4XhWKGcIE/ZAcWhC0EijmOEY9RiUWBaw
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEAwEBAgMnUhAgMSE2GYguAxHGNg1YhV4XhWKGcIE/ZAcWhC0EijmOEY9RiUWBaw
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034542"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <nadav.amit@gmail.com>,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 6/9] KVM: x86: check DR6/7 high-bits are clear only on long-mode
Date: Wed, 18 Jun 2014 17:19:23 +0300
Message-Id: <1403101166-23616-7-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
References: <539F059F.8050501@redhat.com>
 <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

When the guest sets DR6 and DR7, KVM asserts the high 32-bits are clear, and
otherwise injects a #GP exception. This exception should only be injected only
if running in long-mode.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/vmx.c |  2 +-
 arch/x86/kvm/x86.h | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 801332e..c0f53a0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5165,7 +5165,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 			return 1;
 		kvm_register_write(vcpu, reg, val);
 	} else
-		if (kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg)))
+		if (kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg)))
 			return 1;
 
 	skip_emulated_instruction(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8c97bac..c5b61a7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -47,6 +47,16 @@ static inline int is_long_mode(struct kvm_vcpu *vcpu)
 #endif
 }
 
+static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
+{
+	int cs_db, cs_l;
+
+	if (!is_long_mode(vcpu))
+		return false;
+	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+	return cs_l;
+}
+
 static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.walk_mmu == &vcpu->arch.nested_mmu;
@@ -108,6 +118,14 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return false;
 }
 
+static inline unsigned long kvm_register_readl(struct kvm_vcpu *vcpu,
+					       enum kvm_reg reg)
+{
+	unsigned long val = kvm_register_read(vcpu, reg);
+
+	return is_64_bit_mode(vcpu) ? val : (u32)val;
+}
+
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
-- 
1.9.1

