Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaFONPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:15:09 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:22664 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaFONNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:13:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgECAPuanVOERCABjGdsb2JhbABariIBAQaZJAGBABYPAQEBJzyEBAEFJ1IQUVcZiELJWIUmF4VjiRMHFoQtBIo5pyU
X-IPAS-Result: AgECAPuanVOERCABjGdsb2JhbABariIBAQaZJAGBABYPAQEBJzyEBAEFJ1IQUVcZiELJWIUmF4VjiRMHFoQtBIo5pyU
X-IronPort-AV: E=Sophos;i="5.01,481,1400014800"; 
   d="scan'208";a="111523995"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 3/6] KVM: x86: Inter privilage level ret emulation is not implemeneted
Date: Sun, 15 Jun 2014 16:12:59 +0300
Message-Id: <1402837982-24959-4-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return unhandlable error on inter-privilage level ret instruction.  This is
since the current emulation does not check the privilage level correctly when
loading the CS, and does not pop RSP/SS as needed.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3c8d867..0183350 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2019,6 +2019,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	unsigned long cs;
+	int cpl = ctxt->ops->cpl(ctxt);
 
 	rc = emulate_pop(ctxt, &ctxt->_eip, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
@@ -2028,6 +2029,9 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 	rc = emulate_pop(ctxt, &cs, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
+	/* Outer-privilage level return is not implemented */
+	if (ctxt->mode >= X86EMUL_MODE_PROT16 && (cs & 3) > cpl)
+		return X86EMUL_UNHANDLEABLE;
 	rc = load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS);
 	return rc;
 }
-- 
1.9.1

