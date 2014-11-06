Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaKFWm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:42:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58932 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaKFWmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nadav Amit <namit@cs.technion.ac.il>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 106/162] KVM: x86: Fix far-jump to non-canonical check
Date: Thu,  6 Nov 2014 14:36:10 -0800
Message-Id: <1415313426-9622-107-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.13-stable: omitted WARN_ON fixes (not in 3.13) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/emulate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a440bea..4ae37e7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -581,12 +581,14 @@ static inline int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst,
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
-- 
1.9.1

