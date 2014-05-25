Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaEYUFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 16:05:55 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:11718 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaEYUFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 16:05:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnECAEdMglOERCABjGdsb2JhbABYsWiND4c/gQUWDgEBASc8glNSgVGIQtIAhUMXjlIdhCoEihumOg
X-IPAS-Result: AnECAEdMglOERCABjGdsb2JhbABYsWiND4c/gQUWDgEBASc8glNSgVGIQtIAhUMXjlIdhCoEihumOg
X-IronPort-AV: E=Sophos;i="4.98,907,1392156000"; 
   d="scan'208";a="108445966"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: MOV CR/DR emulation should ignore mod
Date: Sun, 25 May 2014 23:05:21 +0300
Message-Id: <1401048321-4917-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MOV CR/DR instructions ignore the mod field (in the ModR/M byte). As the SDM
states: "The 2 bits in the mod field are ignored".  Accordingly, the second
operand of these instructions is always a general purpose register.

The current emulator implementation does not do so. If the mod bits do not
equal 3, it expects the second operand to be in memory.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2fa7ab0..e4e833d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -161,6 +161,7 @@
 #define Fastop      ((u64)1 << 44)  /* Use opcode::u.fastop */
 #define NoWrite     ((u64)1 << 45)  /* No writeback */
 #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
+#define NoMod	    ((u64)1 << 47)  /* Mod field is ignored */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -1077,7 +1078,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 	ctxt->modrm_rm |= (ctxt->modrm & 0x07);
 	ctxt->modrm_seg = VCPU_SREG_DS;
 
-	if (ctxt->modrm_mod == 3) {
+	if (ctxt->modrm_mod == 3 || (ctxt->d & NoMod)) {
 		op->type = OP_REG;
 		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
@@ -3877,10 +3878,12 @@ static const struct opcode twobyte_table[256] = {
 	N, N, N, N, N, N, N, N,
 	D(ImplicitOps | ModRM), N, N, N, N, N, N, D(ImplicitOps | ModRM),
 	/* 0x20 - 0x2F */
-	DIP(ModRM | DstMem | Priv | Op3264, cr_read, check_cr_read),
-	DIP(ModRM | DstMem | Priv | Op3264, dr_read, check_dr_read),
-	IIP(ModRM | SrcMem | Priv | Op3264, em_cr_write, cr_write, check_cr_write),
-	IIP(ModRM | SrcMem | Priv | Op3264, em_dr_write, dr_write, check_dr_write),
+	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_read),
+	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, dr_read, check_dr_read),
+	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_cr_write, cr_write,
+						check_cr_write),
+	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_dr_write, dr_write,
+						check_dr_write),
 	N, N, N, N,
 	GP(ModRM | DstReg | SrcMem | Mov | Sse, &pfx_0f_28_0f_29),
 	GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_28_0f_29),
-- 
1.9.1

