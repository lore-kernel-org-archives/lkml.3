Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaGULjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:39:19 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:54462 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932196AbaGULjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:39:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCiGTBePSwcWhDAFil+oPGk
X-IPAS-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCiGTBePSwcWhDAFil+oPGk
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353345"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 7/7] KVM: x86: Cleanup of rflags.rf cleaning
Date: Mon, 21 Jul 2014 14:37:30 +0300
Message-Id: <1405942650-22589-8-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFLAGS.RF was cleaned in several functions (e.g., syscall) in the x86 emulator.
Now that we clear it before the execution of an instruction in the emulator, we
can remove the specific cleanup of RFLAGS.RF.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 189b8bd8..8d41556 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2211,7 +2211,7 @@ static int em_syscall(struct x86_emulate_ctxt *ctxt)
 	*reg_write(ctxt, VCPU_REGS_RCX) = ctxt->_eip;
 	if (efer & EFER_LMA) {
 #ifdef CONFIG_X86_64
-		*reg_write(ctxt, VCPU_REGS_R11) = ctxt->eflags & ~EFLG_RF;
+		*reg_write(ctxt, VCPU_REGS_R11) = ctxt->eflags;
 
 		ops->get_msr(ctxt,
 			     ctxt->mode == X86EMUL_MODE_PROT64 ?
@@ -2219,14 +2219,14 @@ static int em_syscall(struct x86_emulate_ctxt *ctxt)
 		ctxt->_eip = msr_data;
 
 		ops->get_msr(ctxt, MSR_SYSCALL_MASK, &msr_data);
-		ctxt->eflags &= ~(msr_data | EFLG_RF);
+		ctxt->eflags &= ~msr_data;
 #endif
 	} else {
 		/* legacy mode */
 		ops->get_msr(ctxt, MSR_STAR, &msr_data);
 		ctxt->_eip = (u32)msr_data;
 
-		ctxt->eflags &= ~(EFLG_VM | EFLG_IF | EFLG_RF);
+		ctxt->eflags &= ~(EFLG_VM | EFLG_IF);
 	}
 
 	return X86EMUL_CONTINUE;
@@ -2275,7 +2275,7 @@ static int em_sysenter(struct x86_emulate_ctxt *ctxt)
 		break;
 	}
 
-	ctxt->eflags &= ~(EFLG_VM | EFLG_IF | EFLG_RF);
+	ctxt->eflags &= ~(EFLG_VM | EFLG_IF);
 	cs_sel = (u16)msr_data;
 	cs_sel &= ~SELECTOR_RPL_MASK;
 	ss_sel = cs_sel + 8;
-- 
1.9.1

