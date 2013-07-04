Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3GDI6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:58:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3GDI6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:58:39 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Avi Kivity <avi.kivity@gmail.com>
Subject: [PATCH] x86/kvm/emulate.c: simplify NOP (opcode 0x90) check
Date: Thu,  4 Jul 2013 10:58:29 +0200
Message-Id: <1372928309-16488-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check sits in switch() statement which itself can check
for opcode 0x90 far more efficiently.

On assembler level, this change simply eliminates the following
bit of code:

4c 8b a3 d8 00 00 00    mov    0xd8(%rbx),%r12
31 f6                   xor    %esi,%esi
48 89 df                mov    %rbx,%rdi
e8 32 8c ff ff          callq  490 <reg_read>
48 8d 83 78 01 00 00    lea    0x178(%rbx),%rax
83 8b 70 01 00 00 01    orl    $0x1,0x170(%rbx)
83 8b 74 01 00 00 01    orl    $0x1,0x174(%rbx)
49 39 c4                cmp    %rax,%r12
0f 84 88 fa ff ff       je     7304 <x86_emulate_insn+0x204>

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>
---
 arch/x86/kvm/emulate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2bc1e81..7e6e74a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4544,9 +4544,9 @@ special_insn:
 	case 0x8d: /* lea r16/r32, m */
 		ctxt->dst.val = ctxt->src.addr.mem.ea;
 		break;
-	case 0x90 ... 0x97: /* nop / xchg reg, rax */
-		if (ctxt->dst.addr.reg == reg_rmw(ctxt, VCPU_REGS_RAX))
-			break;
+	case 0x90: /* nop */
+		break;
+	case 0x91 ... 0x97: /* xchg reg, rax */
 		rc = em_xchg(ctxt);
 		break;
 	case 0x98: /* cbw/cwde/cdqe */
-- 
1.8.1.4

