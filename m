Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaDREMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 00:12:25 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:27050 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaDREMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 00:12:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYCAO6kUFOERM5ejGdsb2JhbABZyAGBIRYOAQEBJzyCJgEFJ1IQUVcHEod8xg+GFBeNfmQHhDgEiVylFTqBLA
X-IPAS-Result: AoYCAO6kUFOERM5ejGdsb2JhbABZyAGBIRYOAQEBJzyCJgEFJ1IQUVcHEod8xg+GFBeNfmQHhDgEiVylFTqBLA
X-IronPort-AV: E=Sophos;i="4.97,882,1389736800"; 
   d="scan'208";a="102894997"
From: Nadav Amit <namit@cs.technion.ac.il>
To: gleb@kernel.org, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 5/5] KVM: x86: Processor mode may be determined incorrectly
Date: Fri, 18 Apr 2014 07:11:34 +0300
Message-Id: <1397794294-8414-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397794294-8414-1-git-send-email-namit@cs.technion.ac.il>
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
 <1397794294-8414-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If EFER.LMA is off, cs.l does not determine execution mode.
Currently, the emulation engine assumes differently.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
:100644 100644 f4d9839... c99f7eb... M	arch/x86/kvm/x86.c
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f4d9839..c99f7eb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4887,7 +4887,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	ctxt->eip = kvm_rip_read(vcpu);
 	ctxt->mode = (!is_protmode(vcpu))		? X86EMUL_MODE_REAL :
 		     (ctxt->eflags & X86_EFLAGS_VM)	? X86EMUL_MODE_VM86 :
-		     cs_l				? X86EMUL_MODE_PROT64 :
+		     (cs_l && is_long_mode(vcpu))	? X86EMUL_MODE_PROT64 :
 		     cs_db				? X86EMUL_MODE_PROT32 :
 							  X86EMUL_MODE_PROT16;
 	ctxt->guest_mode = is_guest_mode(vcpu);
-- 
1.7.10.4

