Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaFONNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:13:42 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:22664 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaFONNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:13:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgECAPuanVOERCABjGdsb2JhbABariIBAQaZJAGBABYPAQEBJzyEAwEBAgMnUhAgMSE2GYguAxHIcw1YhSYXhWOGcIIjBxaELQSKOY4Rj1GJQw
X-IPAS-Result: AgECAPuanVOERCABjGdsb2JhbABariIBAQaZJAGBABYPAQEBJzyEAwEBAgMnUhAgMSE2GYguAxHIcw1YhSYXhWOGcIIjBxaELQSKOY4Rj1GJQw
X-IronPort-AV: E=Sophos;i="5.01,481,1400014800"; 
   d="scan'208";a="111524003"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <nadav.amit@gmail.com>,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 6/6] KVM: x86: check DR6/7 high-bits are clear only on long-mode
Date: Sun, 15 Jun 2014 16:13:02 +0300
Message-Id: <1402837982-24959-7-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

When the guest sets DR6 and DR7, KVM asserts the high 32-bits are clear, and
otherwise injects a #GP exception. This exception should only be injected only
if running in long-mode.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/x86.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 57eac30..71fe841 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -756,6 +756,15 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
 }
 
+static bool is_64_bit_mode(struct kvm_vcpu *vcpu)
+{
+	int cs_db, cs_l;
+	if (!is_long_mode(vcpu))
+		return false;
+	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+	return cs_l;
+}
+
 static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 {
 	switch (dr) {
@@ -769,7 +778,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 			return 1; /* #UD */
 		/* fall through */
 	case 6:
-		if (val & 0xffffffff00000000ULL)
+		if ((val & 0xffffffff00000000ULL) && is_64_bit_mode(vcpu))
 			return -1; /* #GP */
 		vcpu->arch.dr6 = (val & DR6_VOLATILE) | DR6_FIXED_1;
 		kvm_update_dr6(vcpu);
@@ -779,7 +788,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 			return 1; /* #UD */
 		/* fall through */
 	default: /* 7 */
-		if (val & 0xffffffff00000000ULL)
+		if ((val & 0xffffffff00000000ULL) && is_64_bit_mode(vcpu))
 			return -1; /* #GP */
 		vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
 		kvm_update_dr7(vcpu);
-- 
1.9.1

