Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaHMNu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:50:26 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:48172 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaHMNuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:50:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIBAJxs61OERCABjGdsb2JhbABahDayPppeh1eBFBYQAQEBJz2EMVKBUYhCwVmEbBePTB2ENgWLGKl+aQ
X-IPAS-Result: AsIBAJxs61OERCABjGdsb2JhbABahDayPppeh1eBFBYQAQEBJz2EMVKBUYhCwVmEbBePTB2ENgWLGKl+aQ
X-IronPort-AV: E=Sophos;i="5.01,857,1400014800"; 
   d="scan'208";a="118818054"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: Avoid emulating instructions on #UD mistakenly
Date: Wed, 13 Aug 2014 16:50:13 +0300
Message-Id: <1407937813-1461-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d40a6898e5 mistakenly caused instructions which are not marked as
EmulateOnUD to be emulated upon #UD exception. The commit caused the check of
whether the instruction flags include EmulateOnUD to never be evaluated. As a
result instructions whose emulation is broken may be emulated.  This fix moves
the evaluation of EmulateOnUD so it would be evaluated.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 56657b0..37a83b2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4394,6 +4394,9 @@ done_prefixes:
 
 	ctxt->execute = opcode.u.execute;
 
+	if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
+		return EMULATION_FAILED;
+
 	if (unlikely(ctxt->d &
 		     (NotImpl|EmulateOnUD|Stack|Op3264|Sse|Mmx|Intercept|CheckPerm))) {
 		/*
@@ -4406,9 +4409,6 @@ done_prefixes:
 		if (ctxt->d & NotImpl)
 			return EMULATION_FAILED;
 
-		if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
-			return EMULATION_FAILED;
-
 		if (mode == X86EMUL_MODE_PROT64 && (ctxt->d & Stack))
 			ctxt->op_bytes = 8;
 
-- 
1.9.1

