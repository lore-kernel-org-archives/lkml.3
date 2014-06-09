Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841AbaFINC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:02:56 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56507 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437AbaFIM7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:41 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org, Bandan Das <bsd@redhat.com>
Subject: [PATCH 15/25] KVM: emulate: cleanup decode_modrm
Date: Mon,  9 Jun 2014 14:59:03 +0200
Message-Id: <1402318753-23362-16-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

Remove the if conditional - that will help us avoid
an "else initialize to 0" Also, rearrange operators
for slightly better code.

Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 75e26bd4a21b..c92b1cfbb430 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1065,19 +1065,17 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 			struct operand *op)
 {
 	u8 sib;
-	int index_reg = 0, base_reg = 0, scale;
+	int index_reg, base_reg, scale;
 	int rc = X86EMUL_CONTINUE;
 	ulong modrm_ea = 0;
 
-	if (ctxt->rex_prefix) {
-		ctxt->modrm_reg = (ctxt->rex_prefix & 4) << 1;	/* REX.R */
-		index_reg = (ctxt->rex_prefix & 2) << 2; /* REX.X */
-		ctxt->modrm_rm = base_reg = (ctxt->rex_prefix & 1) << 3; /* REG.B */
-	}
+	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
+	index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
+	base_reg = (ctxt->rex_prefix << 3) & 8; /* REX.B */
 
-	ctxt->modrm_mod |= (ctxt->modrm & 0xc0) >> 6;
+	ctxt->modrm_mod = (ctxt->modrm & 0xc0) >> 6;
 	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;
-	ctxt->modrm_rm |= (ctxt->modrm & 0x07);
+	ctxt->modrm_rm = base_reg | (ctxt->modrm & 0x07);
 	ctxt->modrm_seg = VCPU_SREG_DS;
 
 	if (ctxt->modrm_mod == 3 || (ctxt->d & NoMod)) {
-- 
1.8.3.1


