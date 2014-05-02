Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaEBPm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:42:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43925 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaEBPmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sanjay Lal <sanjayl@kymasys.com>, linux-mips@linux-mips.org,
        kvm@vger.kernel.org, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 077/151] MIPS: KVM: Pass reserved instruction exceptions to guest
Date: Fri,  2 May 2014 08:37:45 -0700
Message-Id: <1399045139-4531-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/mips/kvm/kvm_mips_emul.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kvm/kvm_mips_emul.c b/arch/mips/kvm/kvm_mips_emul.c
index 4b6274b..e75ef82 100644
--- a/arch/mips/kvm/kvm_mips_emul.c
+++ b/arch/mips/kvm/kvm_mips_emul.c
@@ -1571,17 +1571,17 @@ kvm_mips_handle_ri(unsigned long cause, uint32_t *opc,
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
 
@@ -1590,6 +1590,7 @@ kvm_mips_handle_ri(unsigned long cause, uint32_t *opc,
 	 */
 	if (er == EMULATE_FAIL) {
 		vcpu->arch.pc = curr_pc;
+		er = kvm_mips_emulate_ri_exc(cause, opc, run, vcpu);
 	}
 	return er;
 }
-- 
1.9.1

