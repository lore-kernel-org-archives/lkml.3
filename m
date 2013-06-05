Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab3FEVqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:46:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab3FEVgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [ 092/127] KVM: fix sil/dil/bpl/spl in the mod/rm fields
Date: Wed,  5 Jun 2013 14:34:19 -0700
Message-Id: <20130605213228.385910585@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 8acb42070ec4c87a9baab5c7bac626030d5bef28 upstream.

The x86-64 extended low-byte registers were fetched correctly from reg,
but not from mod/rm.

This fixes another bug in the boot of RHEL5.9 64-bit, but it is still
not enough.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1239,9 +1239,12 @@ static int decode_modrm(struct x86_emula
 	ctxt->modrm_seg = VCPU_SREG_DS;
 
 	if (ctxt->modrm_mod == 3) {
+		int highbyte_regs = ctxt->rex_prefix == 0;
+
 		op->type = OP_REG;
 		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
-		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm, ctxt->d & ByteOp);
+		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
+					       highbyte_regs && (ctxt->d & ByteOp));
 		if (ctxt->d & Sse) {
 			op->type = OP_XMM;
 			op->bytes = 16;


