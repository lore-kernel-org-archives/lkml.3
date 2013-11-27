Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3K0BUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:20:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab3K0A7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michele Baldessari <michele@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.12 076/116] KVM: x86: fix emulation of "movzbl %bpl, %eax"
Date: Tue, 26 Nov 2013 16:57:29 -0800
Message-Id: <20131127005742.177402779@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4040,7 +4040,10 @@ static int decode_operand(struct x86_emu
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


