Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab3E3OgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:36:18 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:47467 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3E3OgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:36:09 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gnatapov@redhat.com, kvm@vger.kernel.org, <stable@vger.kernel.org>
Subject: [PATCH] KVM: fix sil/dil/bpl/spl in the mod/rm fields
Date: Thu, 30 May 2013 16:35:55 +0200
Message-Id: <1369924555-30216-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86-64 extended low-byte registers were fetched correctly from reg,
but not from mod/rm.

This fixes another bug in the boot of RHEL5.9 64-bit, but it is still
not enough.

Cc: gnatapov@redhat.com
Cc: kvm@vger.kernel.org
Cc: <stable@vger.kernel.org> # 3.9
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index aa68106..028b34f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1239,9 +1239,12 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
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
-- 
1.8.1.4

