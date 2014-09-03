Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaICJ5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:57:14 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57392 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932172AbaICJ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 44/56] KVM: x86: Inter-privilege level ret emulation is not implemeneted
Date: Wed,  3 Sep 2014 11:27:03 +0200
Message-Id: <3c2e9670a3510b716a4d6758fccb0d65965a4765.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9e8919ae793f4edfaa29694a70f71a515ae9942a upstream.

Return unhandlable error on inter-privilege level ret instruction.  This is
since the current emulation does not check the privilege level correctly when
loading the CS, and does not pop RSP/SS as needed.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kvm/emulate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 92e6f4a8ba0e..3ee4472cef19 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2012,6 +2012,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	unsigned long cs;
+	int cpl = ctxt->ops->cpl(ctxt);
 
 	rc = emulate_pop(ctxt, &ctxt->_eip, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
@@ -2021,6 +2022,9 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
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
2.1.0

