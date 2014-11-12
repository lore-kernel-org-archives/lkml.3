Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934983AbaKLD44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:56:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaKLB0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:26:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.17 133/319] KVM: x86: Fix wrong masking on relative jump/call
Date: Wed, 12 Nov 2014 10:14:31 +0900
Message-Id: <20141112011014.540138217@linuxfoundation.org>
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

commit 05c83ec9b73c8124555b706f6af777b10adf0862 upstream.

Relative jumps and calls do the masking according to the operand size, and not
according to the address size as the KVM emulator does today.

This patch fixes KVM behavior.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -504,11 +504,6 @@ static void rsp_increment(struct x86_emu
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
@@ -568,6 +563,28 @@ static int emulate_nm(struct x86_emulate
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


