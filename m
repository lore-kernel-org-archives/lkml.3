Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776AbaICXkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:40:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933371AbaICWGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:06:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.10 28/55] KVM: x86: Inter-privilege level ret emulation is not implemeneted
Date: Wed,  3 Sep 2014 15:05:18 -0700
Message-Id: <20140903220458.523922305@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 9e8919ae793f4edfaa29694a70f71a515ae9942a upstream.

Return unhandlable error on inter-privilege level ret instruction.  This is
since the current emulation does not check the privilege level correctly when
loading the CS, and does not pop RSP/SS as needed.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2209,6 +2209,7 @@ static int em_ret_far(struct x86_emulate
 {
 	int rc;
 	unsigned long cs;
+	int cpl = ctxt->ops->cpl(ctxt);
 
 	rc = emulate_pop(ctxt, &ctxt->_eip, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
@@ -2218,6 +2219,9 @@ static int em_ret_far(struct x86_emulate
 	rc = emulate_pop(ctxt, &cs, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
+	/* Outer-privilege level return is not implemented */
+	if (ctxt->mode >= X86EMUL_MODE_PROT16 && (cs & 3) > cpl)
+		return X86EMUL_UNHANDLEABLE;
 	rc = load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS);
 	return rc;
 }


