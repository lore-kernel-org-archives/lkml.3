Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbaFROZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:25:10 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:38610 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966655AbaFROTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiRMHFoQtBIo5pyc
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiRMHFoQtBIo5pyc
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034544"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 7/9] KVM: x86: Hypercall handling does not considers opsize correctly
Date: Wed, 18 Jun 2014 17:19:24 +0300
Message-Id: <1403101166-23616-8-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
References: <539F059F.8050501@redhat.com>
 <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the hypercall handling routine only considers LME as an indication
to whether the guest uses 32/64-bit mode. This is incosistent with hyperv
hypercalls handling and against the common sense of considering cs.l as well.
This patch uses is_64_bit_mode instead of is_long_mode for that matter. In
addition, the result is masked in respect to the guest execution mode. Last, it
changes kvm_hv_hypercall to use is_64_bit_mode as well to simplify the code.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/x86.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..c6dfe47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5662,7 +5662,6 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	u64 param, ingpa, outgpa, ret;
 	uint16_t code, rep_idx, rep_cnt, res = HV_STATUS_SUCCESS, rep_done = 0;
 	bool fast, longmode;
-	int cs_db, cs_l;
 
 	/*
 	 * hypercall generates UD from non zero cpl and real mode
@@ -5673,8 +5672,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
-	longmode = is_long_mode(vcpu) && cs_l == 1;
+	longmode = is_64_bit_mode(vcpu);
 
 	if (!longmode) {
 		param = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
@@ -5739,7 +5737,7 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
-	int r = 1;
+	int op_64_bit, r = 1;
 
 	if (kvm_hv_hypercall_enabled(vcpu->kvm))
 		return kvm_hv_hypercall(vcpu);
@@ -5752,7 +5750,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
-	if (!is_long_mode(vcpu)) {
+	op_64_bit = is_64_bit_mode(vcpu);
+	if (!op_64_bit) {
 		nr &= 0xFFFFFFFF;
 		a0 &= 0xFFFFFFFF;
 		a1 &= 0xFFFFFFFF;
@@ -5778,6 +5777,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		break;
 	}
 out:
+	if (!op_64_bit)
+		ret = (u32)ret;
 	kvm_register_write(vcpu, VCPU_REGS_RAX, ret);
 	++vcpu->stat.hypercalls;
 	return r;
-- 
1.9.1

