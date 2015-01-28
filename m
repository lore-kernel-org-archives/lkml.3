Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbbA1CDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:03:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773AbbA1B22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.18 42/61] KVM: x86: SYSENTER emulation is broken
Date: Tue, 27 Jan 2015 17:26:54 -0800
Message-Id: <20150128012641.484192014@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit f3747379accba8e95d70cec0eae0582c8c182050 upstream.

SYSENTER emulation is broken in several ways:
1. It misses the case of 16-bit code segments completely (CVE-2015-0239).
2. MSR_IA32_SYSENTER_CS is checked in 64-bit mode incorrectly (bits 0 and 1 can
   still be set without causing #GP).
3. MSR_IA32_SYSENTER_EIP and MSR_IA32_SYSENTER_ESP are not masked in
   legacy-mode.
4. There is some unneeded code.

Fix it.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2345,7 +2345,7 @@ static int em_sysenter(struct x86_emulat
 	 * Not recognized on AMD in compat mode (but is recognized in legacy
 	 * mode).
 	 */
-	if ((ctxt->mode == X86EMUL_MODE_PROT32) && (efer & EFER_LMA)
+	if ((ctxt->mode != X86EMUL_MODE_PROT64) && (efer & EFER_LMA)
 	    && !vendor_intel(ctxt))
 		return emulate_ud(ctxt);
 
@@ -2358,25 +2358,13 @@ static int em_sysenter(struct x86_emulat
 	setup_syscalls_segments(ctxt, &cs, &ss);
 
 	ops->get_msr(ctxt, MSR_IA32_SYSENTER_CS, &msr_data);
-	switch (ctxt->mode) {
-	case X86EMUL_MODE_PROT32:
-		if ((msr_data & 0xfffc) == 0x0)
-			return emulate_gp(ctxt, 0);
-		break;
-	case X86EMUL_MODE_PROT64:
-		if (msr_data == 0x0)
-			return emulate_gp(ctxt, 0);
-		break;
-	default:
-		break;
-	}
+	if ((msr_data & 0xfffc) == 0x0)
+		return emulate_gp(ctxt, 0);
 
 	ctxt->eflags &= ~(EFLG_VM | EFLG_IF);
-	cs_sel = (u16)msr_data;
-	cs_sel &= ~SELECTOR_RPL_MASK;
+	cs_sel = (u16)msr_data & ~SELECTOR_RPL_MASK;
 	ss_sel = cs_sel + 8;
-	ss_sel &= ~SELECTOR_RPL_MASK;
-	if (ctxt->mode == X86EMUL_MODE_PROT64 || (efer & EFER_LMA)) {
+	if (efer & EFER_LMA) {
 		cs.d = 0;
 		cs.l = 1;
 	}
@@ -2385,10 +2373,11 @@ static int em_sysenter(struct x86_emulat
 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
 
 	ops->get_msr(ctxt, MSR_IA32_SYSENTER_EIP, &msr_data);
-	ctxt->_eip = msr_data;
+	ctxt->_eip = (efer & EFER_LMA) ? msr_data : (u32)msr_data;
 
 	ops->get_msr(ctxt, MSR_IA32_SYSENTER_ESP, &msr_data);
-	*reg_write(ctxt, VCPU_REGS_RSP) = msr_data;
+	*reg_write(ctxt, VCPU_REGS_RSP) = (efer & EFER_LMA) ? msr_data :
+							      (u32)msr_data;
 
 	return X86EMUL_CONTINUE;
 }


