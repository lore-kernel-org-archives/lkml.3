Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3EQVhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:37:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3EQVhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [ 004/102] KVM: emulator: emulate SALC
Date: Fri, 17 May 2013 14:35:19 -0700
Message-Id: <20130517213244.790081620@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 326f578f7e1443bac2333712dd130a261ec15288 upstream.

This is an almost-undocumented instruction available in 32-bit mode.
I say "almost" undocumented because AMD documents it in their opcode
maps just to say that it is unavailable in 64-bit mode (sections
"A.2.1 One-Byte Opcodes" and "B.3 Invalid and Reassigned Instructions
in 64-Bit Mode").

It is roughly equivalent to "sbb %al, %al" except it does not
set the flags.  Use fastop to emulate it, but do not use the opcode
directly because it would fail if the host is 64-bit!

Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -534,6 +534,9 @@ FOP_SETCC(setle)
 FOP_SETCC(setnle)
 FOP_END;
 
+FOP_START(salc) "pushf; sbb %al, %al; popf \n\t" FOP_RET
+FOP_END;
+
 #define __emulate_1op_rax_rdx(ctxt, _op, _suffix, _ex)			\
 	do {								\
 		unsigned long _tmp;					\
@@ -3951,7 +3954,8 @@ static const struct opcode opcode_table[
 	G(Src2One | ByteOp, group2), G(Src2One, group2),
 	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
 	I(DstAcc | SrcImmUByte | No64, em_aam),
-	I(DstAcc | SrcImmUByte | No64, em_aad), N,
+	I(DstAcc | SrcImmUByte | No64, em_aad),
+	F(DstAcc | ByteOp | No64, em_salc),
 	I(DstAcc | SrcXLat | ByteOp, em_mov),
 	/* 0xD8 - 0xDF */
 	N, E(0, &escape_d9), N, E(0, &escape_db), N, E(0, &escape_dd), N, N,


