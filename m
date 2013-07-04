Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab3GDL1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3GDL1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:27:11 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Avi Kivity <avi.kivity@gmail.com>
Subject: [PATCH v2] x86/kvm/emulate.c: simplify NOP (opcode 0x90) check
Date: Thu,  4 Jul 2013 13:27:00 +0200
Message-Id: <1372937220-27856-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need to check for reg == RAX for opcodes 0x91...0x97.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>
---
 arch/x86/kvm/emulate.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2bc1e81..2dc48a1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4544,9 +4544,14 @@ special_insn:
 	case 0x8d: /* lea r16/r32, m */
 		ctxt->dst.val = ctxt->src.addr.mem.ea;
 		break;
-	case 0x90 ... 0x97: /* nop / xchg reg, rax */
+	case 0x90: /* nop / xchg reg, rax */
+		/* Not all opcodes 90 are NOPs, only ones which refer to RAX */
+		/* For example, 49 90 is xchg %rax,%r8 */
+		/* Bare 90 and 40 90 (redundant REX prefix) are nop */
 		if (ctxt->dst.addr.reg == reg_rmw(ctxt, VCPU_REGS_RAX))
 			break;
+		/* Fall through */
+	case 0x91 ... 0x97: /* xchg reg, rax */
 		rc = em_xchg(ctxt);
 		break;
 	case 0x98: /* cbw/cwde/cdqe */
-- 
1.8.1.4
