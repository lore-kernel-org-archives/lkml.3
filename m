Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966802AbaFROT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:19:58 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:22233 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbaFROTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiC9kBxaELQSKOYt7myyBaw
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFJ1IQUVcZiELHG4VeF4ViiC9kBxaELQSKOYt7myyBaw
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034610"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joro@8bytes.org, Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 2/3] KVM: x86: Emulator support for #UD on CPL>0
Date: Wed, 18 Jun 2014 17:19:35 +0300
Message-Id: <1403101176-23664-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>
References: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain instructions (e.g., mwait and monitor) cause a #UD exception when they
are executed in privilaged mode. This is in contrast to the regular privilaged
instructions which cause #GP. In order not to mess with SVM interception of
mwait and monitor which assumes privilage level assertions take place before
interception, a flag has been added.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f90194d..ef7a5a0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -163,6 +163,7 @@
 #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
 #define NoMod	    ((u64)1 << 47)  /* Mod field is ignored */
 #define NoBigReal   ((u64)1 << 48)  /* No big real mode */
+#define UDOnPriv    ((u64)1 << 49)  /* #UD instead of #GP on CPL > 0 */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -4560,7 +4561,10 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 	/* Privileged instruction can be executed only in CPL=0 */
 	if ((ctxt->d & Priv) && ops->cpl(ctxt)) {
-		rc = emulate_gp(ctxt, 0);
+		if (ctxt->d & UDOnPriv)
+			rc = emulate_ud(ctxt);
+		else
+			rc = emulate_gp(ctxt, 0);
 		goto done;
 	}
 
-- 
1.9.1

