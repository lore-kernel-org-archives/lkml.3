Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbaIOXFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:05:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbaIOWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nadav Amit <namit@cs.technion.ac.il>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/187] KVM: x86: Inter-privilege level ret emulation is not implemeneted
Date: Mon, 15 Sep 2014 15:07:43 -0700
Message-Id: <1410818997-9432-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 9e8919ae793f4edfaa29694a70f71a515ae9942a upstream.

Return unhandlable error on inter-privilege level ret instruction.  This is
since the current emulation does not check the privilege level correctly when
loading the CS, and does not pop RSP/SS as needed.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/emulate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 07ffca0..7bff3e2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2006,6 +2006,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	unsigned long cs;
+	int cpl = ctxt->ops->cpl(ctxt);
 
 	rc = emulate_pop(ctxt, &ctxt->_eip, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
@@ -2015,6 +2016,9 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 	rc = emulate_pop(ctxt, &cs, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
+	/* Outer-privilege level return is not implemented */
+	if (ctxt->mode >= X86EMUL_MODE_PROT16 && (cs & 3) > cpl)
+		return X86EMUL_UNHANDLEABLE;
 	rc = load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS);
 	return rc;
 }
-- 
1.9.1

