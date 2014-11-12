Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaKLB0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:26:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaKLB0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:26:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.17 127/319] KVM: x86: Emulator does not decode clflush well
Date: Wed, 12 Nov 2014 10:14:25 +0900
Message-Id: <20141112011013.643474103@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 13e457e0eebf0a0c82c38ceb890d93eb826d62a6 upstream.

Currently, all group15 instructions are decoded as clflush (e.g., mfence,
xsave).  In addition, the clflush instruction requires no prefix (66/f2/f3)
would exist. If prefix exists it may encode a different instruction (e.g.,
clflushopt).

Creating a group for clflush, and different group for each prefix.

This has been the case forever, but the next patch needs the cflush group
in order to fix a bug introduced in 3.17.

Fixes: 41061cdb98a0bec464278b4db8e894a3121671f5
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3376,6 +3376,12 @@ static int em_bswap(struct x86_emulate_c
 	return X86EMUL_CONTINUE;
 }
 
+static int em_clflush(struct x86_emulate_ctxt *ctxt)
+{
+	/* emulating clflush regardless of cpuid */
+	return X86EMUL_CONTINUE;
+}
+
 static bool valid_cr(int nr)
 {
 	switch (nr) {
@@ -3708,6 +3714,16 @@ static const struct opcode group11[] = {
 	X7(D(Undefined)),
 };
 
+static const struct gprefix pfx_0f_ae_7 = {
+	I(0, em_clflush), N, N, N,
+};
+
+static const struct group_dual group15 = { {
+	N, N, N, N, N, N, N, GP(0, &pfx_0f_ae_7),
+}, {
+	N, N, N, N, N, N, N, N,
+} };
+
 static const struct gprefix pfx_0f_6f_0f_7f = {
 	I(Mmx, em_mov), I(Sse | Aligned, em_mov), N, I(Sse | Unaligned, em_mov),
 };
@@ -3967,7 +3983,7 @@ static const struct opcode twobyte_table
 	F(DstMem | SrcReg | ModRM | BitOp | Lock | PageTable, em_bts),
 	F(DstMem | SrcReg | Src2ImmByte | ModRM, em_shrd),
 	F(DstMem | SrcReg | Src2CL | ModRM, em_shrd),
-	D(ModRM), F(DstReg | SrcMem | ModRM, em_imul),
+	GD(0, &group15), F(DstReg | SrcMem | ModRM, em_imul),
 	/* 0xB0 - 0xB7 */
 	I2bv(DstMem | SrcReg | ModRM | Lock | PageTable, em_cmpxchg),
 	I(DstReg | SrcMemFAddr | ModRM | Src2SS, em_lseg),
@@ -4894,8 +4910,6 @@ twobyte_insn:
 	case 0x90 ... 0x9f:     /* setcc r/m8 */
 		ctxt->dst.val = test_cc(ctxt->b, ctxt->eflags);
 		break;
-	case 0xae:              /* clflush */
-		break;
 	case 0xb6 ... 0xb7:	/* movzx */
 		ctxt->dst.bytes = ctxt->op_bytes;
 		ctxt->dst.val = (ctxt->src.bytes == 1) ? (u8) ctxt->src.val


