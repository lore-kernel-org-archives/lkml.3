Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3EQVhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:37:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab3EQVhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [ 002/102] KVM: emulator: emulate AAM
Date: Fri, 17 May 2013 14:35:17 -0700
Message-Id: <20130517213244.571808824@linuxfoundation.org>
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

commit a035d5c64d08a8ac12d81b596e7fa6d95a73c347 upstream.

This is used by SGABIOS, KVM breaks with emulate_invalid_guest_state=1.

AAM needs the source operand to be unsigned; do the same in AAD as well
for consistency, even though it does not affect the result.

Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2986,6 +2986,28 @@ static int em_das(struct x86_emulate_ctx
 	return X86EMUL_CONTINUE;
 }
 
+static int em_aam(struct x86_emulate_ctxt *ctxt)
+{
+	u8 al, ah;
+
+	if (ctxt->src.val == 0)
+		return emulate_de(ctxt);
+
+	al = ctxt->dst.val & 0xff;
+	ah = al / ctxt->src.val;
+	al %= ctxt->src.val;
+
+	ctxt->dst.val = (ctxt->dst.val & 0xffff0000) | al | (ah << 8);
+
+	/* Set PF, ZF, SF */
+	ctxt->src.type = OP_IMM;
+	ctxt->src.val = 0;
+	ctxt->src.bytes = 1;
+	fastop(ctxt, em_or);
+
+	return X86EMUL_CONTINUE;
+}
+
 static int em_aad(struct x86_emulate_ctxt *ctxt)
 {
 	u8 al = ctxt->dst.val & 0xff;
@@ -3926,7 +3948,8 @@ static const struct opcode opcode_table[
 	/* 0xD0 - 0xD7 */
 	G(Src2One | ByteOp, group2), G(Src2One, group2),
 	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
-	N, I(DstAcc | SrcImmByte | No64, em_aad), N, N,
+	I(DstAcc | SrcImmUByte | No64, em_aam),
+	I(DstAcc | SrcImmUByte | No64, em_aad), N, N,
 	/* 0xD8 - 0xDF */
 	N, E(0, &escape_d9), N, E(0, &escape_db), N, E(0, &escape_dd), N, N,
 	/* 0xE0 - 0xE7 */


