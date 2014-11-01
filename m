Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaKAW4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:56:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60115 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paolo Bonzini" <pbonzini@redhat.com>,
        "Nadav Amit" <namit@cs.technion.ac.il>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.278300289@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 090/102] KVM: x86: Fix wrong masking on relative jump/call
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 05c83ec9b73c8124555b706f6af777b10adf0862 upstream.

Relative jumps and calls do the masking according to the operand size, and not
according to the address size as the KVM emulator does today.

This patch fixes KVM behavior.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/emulate.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -456,11 +456,6 @@ register_address_increment(struct x86_em
 		*reg = (*reg & ~ad_mask(ctxt)) | ((*reg + inc) & ad_mask(ctxt));
 }
 
-static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
-{
-	register_address_increment(ctxt, &ctxt->_eip, rel);
-}
-
 static u32 desc_limit_scaled(struct desc_struct *desc)
 {
 	u32 limit = get_desc_limit(desc);
@@ -534,6 +529,28 @@ static int emulate_nm(struct x86_emulate
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

