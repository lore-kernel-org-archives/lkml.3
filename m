Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3JaWFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 18:05:36 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:59239 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3JaWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 18:05:34 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Michele Baldessari <michele@redhat.com>, stable@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: [PATCH] KVM: x86: fix emulation of "movzbl %bpl, %eax"
Date: Thu, 31 Oct 2013 23:05:24 +0100
Message-Id: <1383257124-8241-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I was looking at RHEL5.9's failure to start with
unrestricted_guest=0/emulate_invalid_guest_state=1, I got it working with a
slightly older tree than kvm.git.  I now debugged the remaining failure,
which was introduced by commit 660696d1 (KVM: X86 emulator: fix
source operand decoding for 8bit mov[zs]x instructions, 2013-04-24)
introduced a similar mis-emulation to the one in commit 8acb4207 (KVM:
fix sil/dil/bpl/spl in the mod/rm fields, 2013-05-30).  The incorrect
decoding occurs in 8-bit movzx/movsx instructions whose 8-bit operand
is sil/dil/bpl/spl.

Needless to say, "movzbl %bpl, %eax" does occur in RHEL5.9's decompression
prolog, just a handful of instructions before finally giving control to
the decompressed vmlinux and getting out of the invalid guest state.

Because OpMem8 bypasses decode_modrm, the same handling of the REX prefix
must be applied to OpMem8.

Reported-by: Michele Baldessari <michele@redhat.com>
Cc: stable@vger.kernel.org
Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 16c037e7db7d..282d28cb9931 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4117,7 +4117,10 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 	case OpMem8:
 		ctxt->memop.bytes = 1;
 		if (ctxt->memop.type == OP_REG) {
-			ctxt->memop.addr.reg = decode_register(ctxt, ctxt->modrm_rm, 1);
+			int highbyte_regs = ctxt->rex_prefix == 0;
+
+			ctxt->memop.addr.reg = decode_register(ctxt, ctxt->modrm_rm,
+					       highbyte_regs);
 			fetch_register_operand(&ctxt->memop);
 		}
 		goto mem_common;
-- 
1.8.3.1

