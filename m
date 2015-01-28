Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048AbbA1EVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:21:21 -0500
Received: from mail.kernel.org ([198.145.29.136]:39523 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964841AbbA1EVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:18 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 080/177] KVM: x86: Fix wrong masking on relative jump/call
Date: Wed, 28 Jan 2015 12:08:46 +0800
Message-Id: <1422418236-12852-159-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 05c83ec9b73c8124555b706f6af777b10adf0862 upstream.

Relative jumps and calls do the masking according to the operand size, and not
according to the address size as the KVM emulator does today.

This patch fixes KVM behavior.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/kvm/emulate.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8375622..fa23346 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -459,11 +459,6 @@ register_address_increment(struct x86_emulate_ctxt *ctxt, unsigned long *reg, in
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
@@ -537,6 +532,28 @@ static int emulate_nm(struct x86_emulate_ctxt *ctxt)
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
1.9.1

