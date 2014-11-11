Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaKKLzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:55:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57381 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaKKLJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nadav Amit <namit@cs.technion.ac.il>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 057/170] KVM: x86: Fix far-jump to non-canonical check
Date: Tue, 11 Nov 2014 11:06:56 +0000
Message-Id: <1415704129-12709-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 7e46dddd6f6cd5dbf3c7bd04a7e75d19475ac9f2 upstream.

Commit d1442d85cc30 ("KVM: x86: Handle errors when RIP is set during far
jumps") introduced a bug that caused the fix to be incomplete.  Due to
incorrect evaluation, far jump to segment with L bit cleared (i.e., 32-bit
segment) and RIP with any of the high bits set (i.e, RIP[63:32] != 0) set may
not trigger #GP.  As we know, this imposes a security problem.

In addition, the condition for two warnings was incorrect.

Fixes: d1442d85cc30ea75f7d399474ca738e0bc96f715
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
[Add #ifdef CONFIG_X86_64 to avoid complaints of undefined behavior. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/emulate.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9a1946cb43c8..bcb3134a8d4c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -582,12 +582,14 @@ static inline int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst,
 	case 4:
 		ctxt->_eip = (u32)dst;
 		break;
+#ifdef CONFIG_X86_64
 	case 8:
 		if ((cs_l && is_noncanonical_address(dst)) ||
-		    (!cs_l && (dst & ~(u32)-1)))
+		    (!cs_l && (dst >> 32) != 0))
 			return emulate_gp(ctxt, 0);
 		ctxt->_eip = dst;
 		break;
+#endif
 	default:
 		WARN(1, "unsupported eip assignment size\n");
 	}
@@ -1998,7 +2000,7 @@ static int em_jmp_far(struct x86_emulate_ctxt *ctxt)
 
 	rc = assign_eip_far(ctxt, ctxt->src.val, new_desc.l);
 	if (rc != X86EMUL_CONTINUE) {
-		WARN_ON(!ctxt->mode != X86EMUL_MODE_PROT64);
+		WARN_ON(ctxt->mode != X86EMUL_MODE_PROT64);
 		/* assigning eip failed; restore the old cs */
 		ops->set_segment(ctxt, old_sel, &old_desc, 0, VCPU_SREG_CS);
 		return rc;
@@ -2092,7 +2094,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 		return rc;
 	rc = assign_eip_far(ctxt, eip, new_desc.l);
 	if (rc != X86EMUL_CONTINUE) {
-		WARN_ON(!ctxt->mode != X86EMUL_MODE_PROT64);
+		WARN_ON(ctxt->mode != X86EMUL_MODE_PROT64);
 		ops->set_segment(ctxt, old_cs, &old_desc, 0, VCPU_SREG_CS);
 	}
 	return rc;
-- 
2.1.0

