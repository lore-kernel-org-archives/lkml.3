Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaIKMgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:36:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51708 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755478AbaIKMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nadav Amit" <namit@cs.technion.ac.il>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.656967915@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 001/131] KVM: x86: Inter-privilege level ret emulation
 is not implemeneted
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 9e8919ae793f4edfaa29694a70f71a515ae9942a upstream.

Return unhandlable error on inter-privilege level ret instruction.  This is
since the current emulation does not check the privilege level correctly when
loading the CS, and does not pop RSP/SS as needed.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/emulate.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1818,6 +1818,7 @@ static int em_ret_far(struct x86_emulate
 {
 	int rc;
 	unsigned long cs;
+	int cpl = ctxt->ops->cpl(ctxt);
 
 	rc = emulate_pop(ctxt, &ctxt->_eip, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
@@ -1827,6 +1828,9 @@ static int em_ret_far(struct x86_emulate
 	rc = emulate_pop(ctxt, &cs, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
+	/* Outer-privilege level return is not implemented */
+	if (ctxt->mode >= X86EMUL_MODE_PROT16 && (cs & 3) > cpl)
+		return X86EMUL_UNHANDLEABLE;
 	rc = load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS);
 	return rc;
 }

