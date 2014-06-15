Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaFONNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:13:21 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:22664 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaFONNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:13:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgECAPuanVOERCABjGdsb2JhbABariIBAQaZJAGBABYPAQEBJzyEBAEFJ1IQUVcZiELJWIUmF4VjiRMHFoQtBIo5pyU
X-IPAS-Result: AgECAPuanVOERCABjGdsb2JhbABariIBAQaZJAGBABYPAQEBJzyEBAEFJ1IQUVcZiELJWIUmF4VjiRMHFoQtBIo5pyU
X-IronPort-AV: E=Sophos;i="5.01,481,1400014800"; 
   d="scan'208";a="111523993"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 5/6] KVM: x86: NOP emulation clears (incorrectly) the high 32-bits of RAX
Date: Sun, 15 Jun 2014 16:13:01 +0300
Message-Id: <1402837982-24959-6-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On long-mode the current NOP (0x90) emulation still writes back to RAX.  As a
result, EAX is zero-extended and the high 32-bits of RAX are cleared.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b354531..eb93eb4 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4663,8 +4663,9 @@ special_insn:
 		break;
 	case 0x90 ... 0x97: /* nop / xchg reg, rax */
 		if (ctxt->dst.addr.reg == reg_rmw(ctxt, VCPU_REGS_RAX))
-			break;
-		rc = em_xchg(ctxt);
+			ctxt->dst.type = OP_NONE;
+		else
+			rc = em_xchg(ctxt);
 		break;
 	case 0x98: /* cbw/cwde/cdqe */
 		switch (ctxt->op_bytes) {
-- 
1.9.1

