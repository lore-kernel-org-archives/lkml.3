Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaEGMdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:33:09 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:24967 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaEGMdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:33:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisCAKsmalOERCABjGdsb2JhbABayUUBgRoWDgEBASc8giYBBSdSEFFXBxKIQclKhXEXjlIHhD8EigKlZw
X-IPAS-Result: AisCAKsmalOERCABjGdsb2JhbABayUUBgRoWDgEBASc8giYBBSdSEFFXBxKIQclKhXEXjlIHhD8EigKlZw
X-IronPort-AV: E=Sophos;i="4.97,1003,1389736800"; 
   d="scan'208";a="105236342"
From: Nadav Amit <namit@cs.technion.ac.il>
To: mtosatti@redhat.com, pbonzini@redhat.com, hpa@zytor.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 1/5] KVM: x86: Emulator does not calculate address correctly
Date: Wed,  7 May 2014 15:32:48 +0300
Message-Id: <1399465972-4026-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In long-mode, when the address size is 4 bytes, the linear address is not
truncated as the emulator mistakenly does.  Instead, the offset within the
segment (the ea field) should be truncated according to the address size.

As Intel SDM says: "In 64-bit mode, the effective address components are added
and the effective address is truncated ... before adding the full 64-bit
segment base."

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e8a5840..743e8e3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -631,7 +631,8 @@ static int __linearize(struct x86_emulate_ctxt *ctxt,
 	u16 sel;
 	unsigned cpl;
 
-	la = seg_base(ctxt, addr.seg) + addr.ea;
+	la = seg_base(ctxt, addr.seg) +
+	    (ctxt->ad_bytes == 8 ? addr.ea : (u32)addr.ea);
 	switch (ctxt->mode) {
 	case X86EMUL_MODE_PROT64:
 		if (((signed long)la << 16) >> 16 != la)
@@ -678,7 +679,7 @@ static int __linearize(struct x86_emulate_ctxt *ctxt,
 		}
 		break;
 	}
-	if (fetch ? ctxt->mode != X86EMUL_MODE_PROT64 : ctxt->ad_bytes != 8)
+	if (ctxt->mode != X86EMUL_MODE_PROT64)
 		la &= (u32)-1;
 	if (insn_aligned(ctxt, size) && ((la & (size - 1)) != 0))
 		return emulate_gp(ctxt, 0);
-- 
1.9.1

