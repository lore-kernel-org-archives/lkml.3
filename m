Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaDPQt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbaDPQqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:46:30 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 3/6] KVM: emulate: cleanup decode_modrm
Date: Wed, 16 Apr 2014 12:46:11 -0400
Message-Id: <1397666774-24713-4-git-send-email-bsd@redhat.com>
In-Reply-To: <1397666774-24713-1-git-send-email-bsd@redhat.com>
References: <1397666774-24713-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the if conditional - that will help us avoid
an "else initialize to 0" Also, rearrange operators
for slightly better code.

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/emulate.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a6d9892..e12ac87 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1064,19 +1064,17 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
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
 
 	if (ctxt->modrm_mod == 3) {
-- 
1.8.3.1

