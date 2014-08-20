Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaHTLVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:21:45 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:46559 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaHTLVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:21:43 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com
Subject: [PATCH] KVM: emulate: do not return X86EMUL_PROPAGATE_FAULT explicitly
Date: Wed, 20 Aug 2014 13:21:35 +0200
Message-Id: <1408533695-17826-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always get it through emulate_exception or emulate_ts.  This
ensures that the ctxt->exception fields have been populated.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ef297919a691..4fbf4b598f92 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1549,8 +1549,7 @@ load:
 	ctxt->ops->set_segment(ctxt, selector, &seg_desc, base3, seg);
 	return X86EMUL_CONTINUE;
 exception:
-	emulate_exception(ctxt, err_vec, err_code, true);
-	return X86EMUL_PROPAGATE_FAULT;
+	return emulate_exception(ctxt, err_vec, err_code, true);
 }
 
 static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
@@ -2723,8 +2722,7 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
 	if (!next_tss_desc.p ||
 	    ((desc_limit < 0x67 && (next_tss_desc.type & 8)) ||
 	     desc_limit < 0x2b)) {
-		emulate_ts(ctxt, tss_selector & 0xfffc);
-		return X86EMUL_PROPAGATE_FAULT;
+		return emulate_ts(ctxt, tss_selector & 0xfffc);
 	}
 
 	if (reason == TASK_SWITCH_IRET || reason == TASK_SWITCH_JMP) {
@@ -3016,7 +3014,7 @@ static int em_movbe(struct x86_emulate_ctxt *ctxt)
 		ctxt->dst.val = swab64(ctxt->src.val);
 		break;
 	default:
-		return X86EMUL_PROPAGATE_FAULT;
+		BUG();
 	}
 	return X86EMUL_CONTINUE;
 }
-- 
1.8.3.1

