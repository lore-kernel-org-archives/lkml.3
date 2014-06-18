Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbaFROTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:19:54 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:15269 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbaFROTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiC9kBxaELQSKOacngWs
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiC9kBxaELQSKOacngWs
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034607"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joro@8bytes.org, Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 1/3] KVM: x86: Emulator flag for instruction with no big real mode
Date: Wed, 18 Jun 2014 17:19:34 +0300
Message-Id: <1403101176-23664-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>
References: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain instructions, such as monitor and xsave do not support big real mode
and cause a #GP exception if any of the accessed bytes effective address are
not within [0, 0xffff].  This patch introduces a flag to mark these
instructions, including the necassary checks.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e4e833d..f90194d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -162,6 +162,7 @@
 #define NoWrite     ((u64)1 << 45)  /* No writeback */
 #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
 #define NoMod	    ((u64)1 << 47)  /* Mod field is ignored */
+#define NoBigReal   ((u64)1 << 48)  /* No big real mode */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -651,7 +652,12 @@ static int __linearize(struct x86_emulate_ctxt *ctxt,
 		if (!fetch && (desc.type & 8) && !(desc.type & 2))
 			goto bad;
 		lim = desc_limit_scaled(&desc);
-		if ((desc.type & 8) || !(desc.type & 4)) {
+		if ((ctxt->mode == X86EMUL_MODE_REAL) && !fetch &&
+		    (ctxt->d & NoBigReal)) {
+			/* la is between zero and 0xffff */
+			if (la > 0xffff || (u32)(la + size - 1) > 0xffff)
+				goto bad;
+		} else if ((desc.type & 8) || !(desc.type & 4)) {
 			/* expand-up segment */
 			if (addr.ea > lim || (u32)(addr.ea + size - 1) > lim)
 				goto bad;
-- 
1.9.1

