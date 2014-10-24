Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaJXPHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbaJXPHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:07:44 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Nadav Amit <namit@cs.technion.ac.il>, stable@vger.kernel.org
Subject: [PATCH 04/14] KVM: x86: Fix wrong masking on relative jump/call
Date: Fri, 24 Oct 2014 17:07:15 +0200
Message-Id: <1414163245-18555-5-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

Relative jumps and calls do the masking according to the operand size, and not
according to the address size as the KVM emulator does today.

This patch fixes KVM behavior.

Cc: stable@vger.kernel.org
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a46207a05835..047698974799 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -504,11 +504,6 @@ static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
 	masked_increment(reg_rmw(ctxt, VCPU_REGS_RSP), stack_mask(ctxt), inc);
 }
 
-static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
-{
-	register_address_increment(ctxt, &ctxt->_eip, rel);
-}
-
 static u32 desc_limit_scaled(struct desc_struct *desc)
 {
 	u32 limit = get_desc_limit(desc);
@@ -569,6 +564,28 @@ static int emulate_nm(struct x86_emulate_ctxt *ctxt)
 	return emulate_exception(ctxt, NM_VECTOR, 0, false);
 }
 
+static inline void assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong dst)
+{
+	switch (ctxt->op_bytes) {
+	case 2:
+		ctxt->_eip = (u16)dst;
+		break;
+	case 4:
+		ctxt->_eip = (u32)dst;
+		break;
+	case 8:
+		ctxt->_eip = dst;
+		break;
+	default:
+		WARN(1, "unsupported eip assignment size\n");
+	}
+}
+
+static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
+{
+	assign_eip_near(ctxt, ctxt->_eip + rel);
+}
+
 static u16 get_segment_selector(struct x86_emulate_ctxt *ctxt, unsigned seg)
 {
 	u16 selector;
-- 
1.8.3.1


