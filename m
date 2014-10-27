Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaJ0Ob5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:31:57 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55944 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaJ0Obz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:31:55 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: namit@cs.technion.ac.il, bp@suse.de
Subject: [PATCH] KVM: emulator: fix error code for __linearize
Date: Mon, 27 Oct 2014 15:31:45 +0100
Message-Id: <1414420306-2771-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error code for #GP and #SS is zero when the segment is used to
access an operand or an instruction.  It is only non-zero when
a segment register is being loaded; for limit checks this means
cases such as:

* for #GP, when RIP is beyond the limit on a far call (before the first
instruction is executed).  We do not implement this check, but it
would be in em_jmp_far/em_call_far.

* for #SS, if the new stack overflows during an inter-privilege-level
call to a non-conforming code segment.  We do not implement stack
switching at all.

So use an error code of zero.

Cc: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 749f9fa38254..8aa66068712f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -711,9 +711,9 @@ static int __linearize(struct x86_emulate_ctxt *ctxt,
 	return X86EMUL_CONTINUE;
 bad:
 	if (addr.seg == VCPU_SREG_SS)
-		return emulate_ss(ctxt, sel);
+		return emulate_ss(ctxt, 0);
 	else
-		return emulate_gp(ctxt, sel);
+		return emulate_gp(ctxt, 0);
 }
 
 static int linearize(struct x86_emulate_ctxt *ctxt,
-- 
1.8.3.1

