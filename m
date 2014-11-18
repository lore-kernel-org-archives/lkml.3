Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaKROy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:54:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148AbaKROJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 107/206] KVM: x86: Fix wrong masking on relative jump/call
Date: Tue, 18 Nov 2014 15:07:42 +0100
Message-Id: <4b4290c052b7180700de7257793a31f4c0ae75df.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 05c83ec9b73c8124555b706f6af777b10adf0862 upstream.

Relative jumps and calls do the masking according to the operand size, and not
according to the address size as the KVM emulator does today.

This patch fixes KVM behavior.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kvm/emulate.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3ee4472cef19..981ba30e00e5 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -498,11 +498,6 @@ static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
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
@@ -576,6 +571,28 @@ static int emulate_nm(struct x86_emulate_ctxt *ctxt)
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
2.1.3

