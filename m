Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaGULjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:39:20 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:48127 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932194AbaGULjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:39:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCiGTBePSwcWhDAFil+oPGk
X-IPAS-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCiGTBePSwcWhDAFil+oPGk
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353346"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 6/7] KVM: x86: Clear rflags.rf on emulated instructions
Date: Mon, 21 Jul 2014 14:37:29 +0300
Message-Id: <1405942650-22589-7-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an instruction is emulated RFLAGS.RF should be cleared. KVM previously did
not do so. This patch clears RFLAGS.RF after interception is done.  If a fault
occurs during the instruction, RFLAGS.RF will be set by a previous patch.  This
patch does not handle the case of traps/interrupts during rep-strings. Traps
are only expected to occur on debug watchpoints, and those are anyhow not
handled by the emulator.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index cf117bf..189b8bd8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4640,6 +4640,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 			/* All REP prefixes have the same first termination condition */
 			if (address_mask(ctxt, reg_read(ctxt, VCPU_REGS_RCX)) == 0) {
 				ctxt->eip = ctxt->_eip;
+				ctxt->eflags &= ~EFLG_RF;
 				goto done;
 			}
 		}
@@ -4682,6 +4683,8 @@ special_insn:
 			goto done;
 	}
 
+	ctxt->eflags &= ~EFLG_RF;
+
 	if (ctxt->execute) {
 		if (ctxt->d & Fastop) {
 			void (*fop)(struct fastop *) = (void *)ctxt->execute;
-- 
1.9.1

