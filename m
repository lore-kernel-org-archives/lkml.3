Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaC0LbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:31:05 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:55717 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbaC0Lav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:30:51 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [RFC PATCH 3/5] KVM: x86: move around some checks
Date: Thu, 27 Mar 2014 12:30:36 +0100
Message-Id: <1395919838-18466-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
References: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only purpose of this patch is to make the next patch simpler
to review.  No semantic change.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c9f8f61df46c..9e40fbf94dcd 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4347,12 +4347,15 @@ done_prefixes:
 		ctxt->d |= opcode.flags;
 	}
 
+	/* Unrecognised? */
+	if (ctxt->d == 0)
+		return EMULATION_FAILED;
+
 	ctxt->execute = opcode.u.execute;
 	ctxt->check_perm = opcode.check_perm;
 	ctxt->intercept = opcode.intercept;
 
-	/* Unrecognised? */
-	if (ctxt->d == 0 || (ctxt->d & NotImpl))
+	if (ctxt->d & NotImpl)
 		return EMULATION_FAILED;
 
 	if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
@@ -4494,19 +4497,19 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 	ctxt->mem_read.pos = 0;
 
-	if ((ctxt->mode == X86EMUL_MODE_PROT64 && (ctxt->d & No64)) ||
-			(ctxt->d & Undefined)) {
+	/* LOCK prefix is allowed only with some instructions */
+	if (ctxt->lock_prefix && (!(ctxt->d & Lock) || ctxt->dst.type != OP_MEM)) {
 		rc = emulate_ud(ctxt);
 		goto done;
 	}
 
-	/* LOCK prefix is allowed only with some instructions */
-	if (ctxt->lock_prefix && (!(ctxt->d & Lock) || ctxt->dst.type != OP_MEM)) {
+	if ((ctxt->d & SrcMask) == SrcMemFAddr && ctxt->src.type != OP_MEM) {
 		rc = emulate_ud(ctxt);
 		goto done;
 	}
 
-	if ((ctxt->d & SrcMask) == SrcMemFAddr && ctxt->src.type != OP_MEM) {
+	if ((ctxt->mode == X86EMUL_MODE_PROT64 && (ctxt->d & No64)) ||
+			(ctxt->d & Undefined)) {
 		rc = emulate_ud(ctxt);
 		goto done;
 	}
-- 
1.8.3.1


