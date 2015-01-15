Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbbAOWMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:12:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50495 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbbAOWKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nadav Amit <namit@cs.technion.ac.il>, Paolo Bonzini <pbonzini@redhat.com>,
        Vinson Lee <vlee@twopensource.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 04/19] [3.13-stable only] KVM: x86: Fix far-jump to non-canonical check
Date: Thu, 15 Jan 2015 14:09:40 -0800
Message-Id: <1421359795-11155-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 7e46dddd6f6cd5dbf3c7bd04a7e75d19475ac9f2 upstream.

[3.13-stable's first backport (f9bffe0) of this commit accidentally omitted
part of the upstream patch (the WARN_ON fixes), supplied here.]

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
Cc: Vinson Lee <vlee@twopensource.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 97e766b..4919b95 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1994,7 +1994,7 @@ static int em_jmp_far(struct x86_emulate_ctxt *ctxt)
 
 	rc = assign_eip_far(ctxt, ctxt->src.val, new_desc.l);
 	if (rc != X86EMUL_CONTINUE) {
-		WARN_ON(!ctxt->mode != X86EMUL_MODE_PROT64);
+		WARN_ON(ctxt->mode != X86EMUL_MODE_PROT64);
 		/* assigning eip failed; restore the old cs */
 		ops->set_segment(ctxt, old_sel, &old_desc, 0, VCPU_SREG_CS);
 		return rc;
@@ -2088,7 +2088,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 		return rc;
 	rc = assign_eip_far(ctxt, eip, new_desc.l);
 	if (rc != X86EMUL_CONTINUE) {
-		WARN_ON(!ctxt->mode != X86EMUL_MODE_PROT64);
+		WARN_ON(ctxt->mode != X86EMUL_MODE_PROT64);
 		ops->set_segment(ctxt, old_cs, &old_desc, 0, VCPU_SREG_CS);
 	}
 	return rc;
-- 
1.9.1

