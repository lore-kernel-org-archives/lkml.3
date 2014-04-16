Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaDPQqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbaDPQq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:46:29 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 2/6] KVM: emulate: Remove ctxt->intercept and ctxt->check_perm checks
Date: Wed, 16 Apr 2014 12:46:10 -0400
Message-Id: <1397666774-24713-3-git-send-email-bsd@redhat.com>
In-Reply-To: <1397666774-24713-1-git-send-email-bsd@redhat.com>
References: <1397666774-24713-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same information can be gleaned from ctxt->d and avoids having
to zero/NULL initialize intercept and check_perm

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/emulate.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8e2b866..a6d9892 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4615,7 +4615,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 				fetch_possible_mmx_operand(ctxt, &ctxt->dst);
 		}
 
-		if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
+		if (unlikely(ctxt->guest_mode) && (ctxt->d & Intercept)) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_PRE_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -4635,13 +4635,13 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		}
 
 		/* Do instruction specific permission checks */
-		if (ctxt->check_perm) {
+		if (ctxt->d & CheckPerm) {
 			rc = ctxt->check_perm(ctxt);
 			if (rc != X86EMUL_CONTINUE)
 				goto done;
 		}
 
-		if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
+		if (unlikely(ctxt->guest_mode) && (ctxt->d & Intercept)) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_POST_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -4685,7 +4685,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 special_insn:
 
-	if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
+	if (unlikely(ctxt->guest_mode) && (ctxt->d & Intercept)) {
 		rc = emulator_check_intercept(ctxt, ctxt->intercept,
 					      X86_ICPT_POST_MEMACCESS);
 		if (rc != X86EMUL_CONTINUE)
-- 
1.8.3.1

