Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaEKTVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:21:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbaEKTVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Sanjay Lal <sanjayl@kymasys.com>,
        linux-mips@linux-mips.org, kvm@vger.kernel.org
Subject: [PATCH 3.14 11/83] MIPS: KVM: Pass reserved instruction exceptions to guest
Date: Sun, 11 May 2014 21:19:12 +0200
Message-Id: <20140511191908.617982032@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hogan <james.hogan@imgtec.com>

commit 15505679362270d02c449626385cb74af8905514 upstream.

Previously a reserved instruction exception while in guest code would
cause a KVM internal error if kvm_mips_handle_ri() didn't recognise the
instruction (including a RDHWR from an unrecognised hardware register).

However the guest OS should really have the opportunity to catch the
exception so that it can take the appropriate actions such as sending a
SIGILL to the guest user process or emulating the instruction itself.

Therefore in these cases emulate a guest RI exception and only return
EMULATE_FAIL if that fails, being careful to revert the PC first in case
the exception occurred in a branch delay slot in which case the PC will
already point to the branch target.

Also turn the printk messages relating to these cases into kvm_debug
messages so that they aren't usually visible.

This allows crashme to run in the guest without killing the entire VM.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-mips@linux-mips.org
Cc: kvm@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kvm/kvm_mips_emul.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/mips/kvm/kvm_mips_emul.c
+++ b/arch/mips/kvm/kvm_mips_emul.c
@@ -1571,17 +1571,17 @@ kvm_mips_handle_ri(unsigned long cause,
 			arch->gprs[rt] = kvm_read_c0_guest_userlocal(cop0);
 #else
 			/* UserLocal not implemented */
-			er = kvm_mips_emulate_ri_exc(cause, opc, run, vcpu);
+			er = EMULATE_FAIL;
 #endif
 			break;
 
 		default:
-			printk("RDHWR not supported\n");
+			kvm_debug("RDHWR %#x not supported @ %p\n", rd, opc);
 			er = EMULATE_FAIL;
 			break;
 		}
 	} else {
-		printk("Emulate RI not supported @ %p: %#x\n", opc, inst);
+		kvm_debug("Emulate RI not supported @ %p: %#x\n", opc, inst);
 		er = EMULATE_FAIL;
 	}
 
@@ -1590,6 +1590,7 @@ kvm_mips_handle_ri(unsigned long cause,
 	 */
 	if (er == EMULATE_FAIL) {
 		vcpu->arch.pc = curr_pc;
+		er = kvm_mips_emulate_ri_exc(cause, opc, run, vcpu);
 	}
 	return er;
 }


