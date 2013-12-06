Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162379Ab3LFNNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:13:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162070Ab3LFNFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 244/272] KVM: x86: fix emulation of "movzbl %bpl, %eax"
Date: Fri,  6 Dec 2013 12:58:53 +0000
Message-Id: <1386334761-25517-245-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit daf727225b8abfdfe424716abac3d15a3ac5626a upstream.

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
Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/emulate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2bc1e81..7210ee3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4028,7 +4028,10 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
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
1.8.3.2

