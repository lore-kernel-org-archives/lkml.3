Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaDREMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 00:12:10 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:27050 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaDREMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 00:12:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYCAO6kUFOERM5ejGdsb2JhbABZyAGBIRYOAQEBJzyCJgEFJ1IQUVcHEod8xg+GFBeOYgeEOASJXKUVOg
X-IPAS-Result: AoYCAO6kUFOERM5ejGdsb2JhbABZyAGBIRYOAQEBJzyCJgEFJ1IQUVcHEod8xg+GFBeOYgeEOASJXKUVOg
X-IronPort-AV: E=Sophos;i="4.97,882,1389736800"; 
   d="scan'208";a="102894990"
From: Nadav Amit <namit@cs.technion.ac.il>
To: gleb@kernel.org, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 4/5] KVM: x86: RSI/RDI/RCX are zero-extended when affected by string ops
Date: Fri, 18 Apr 2014 07:11:33 +0300
Message-Id: <1397794294-8414-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using address-size override prefix with string instructions in long-mode,
ESI/EDI/ECX are zero extended if they are affected by the instruction
(incremented/decremented).  Currently, the KVM emulator does not do so.

In addition, although it is not well-documented, when address override prefix
is used with REP-string instruction, RCX high half is zeroed even if ECX was
zero on the first iteration. Therefore, the emulator should clear the upper
part of RCX in this case, as x86 CPUs do.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
:100644 100644 69e2636... a69ed67... M	arch/x86/kvm/emulate.c
 arch/x86/kvm/emulate.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 69e2636..a69ed67 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -491,6 +491,8 @@ register_address_increment(struct x86_emulate_ctxt *ctxt, unsigned long *reg, in
 	else
 		mask = ad_mask(ctxt);
 	masked_increment(reg, mask, inc);
+	if (ctxt->ad_bytes == 4)
+		*reg &= 0xffffffff;
 }
 
 static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
@@ -4567,6 +4569,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	if (ctxt->rep_prefix && (ctxt->d & String)) {
 		/* All REP prefixes have the same first termination condition */
 		if (address_mask(ctxt, reg_read(ctxt, VCPU_REGS_RCX)) == 0) {
+			if (ctxt->ad_bytes == 4)
+				*reg_write(ctxt, VCPU_REGS_RCX) = 0;
 			ctxt->eip = ctxt->_eip;
 			goto done;
 		}
-- 
1.7.10.4

