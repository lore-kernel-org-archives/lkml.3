Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbaEGMdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:33:32 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:17184 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaEGMdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:33:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisCAKsmalOERCABjGdsb2JhbABayUUBgRoWDgEBASc8giYBBSdSEFFXBxKIQclKhXEXjW5kB4Q/BIoCpWeBag
X-IPAS-Result: AisCAKsmalOERCABjGdsb2JhbABayUUBgRoWDgEBASc8giYBBSdSEFFXBxKIQclKhXEXjW5kB4Q/BIoCpWeBag
X-IronPort-AV: E=Sophos;i="4.97,1003,1389736800"; 
   d="scan'208";a="105236377"
From: Nadav Amit <namit@cs.technion.ac.il>
To: mtosatti@redhat.com, pbonzini@redhat.com, hpa@zytor.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 5/5] KVM: x86: Fix wrong masking on relative jump/call
Date: Wed,  7 May 2014 15:32:52 +0300
Message-Id: <1399465972-4026-6-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relative jumps and calls do the masking according to the operand size, and not
according to the address size as the KVM emulator does today.  In 64-bit mode,
the resulting RIP is always 64-bit. Otherwise it is masked according to the
instruction operand-size. Note that when 16-bit address size is used, bits
63:32 are unmodified.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 6833b41..e406705 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -506,7 +506,9 @@ static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
 
 static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
 {
-	register_address_increment(ctxt, &ctxt->_eip, rel);
+	/* 64-bit mode relative jumps are always 64-bit; otherwise mask */
+	int op_bytes = ctxt->mode == X86EMUL_MODE_PROT64 ? 8 : ctxt->op_bytes;
+	masked_increment(&ctxt->eip, op_bytes, rel);
 }
 
 static u32 desc_limit_scaled(struct desc_struct *desc)
-- 
1.9.1

