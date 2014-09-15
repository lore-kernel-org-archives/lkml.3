Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbaIOXRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:17:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbaIOWK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 103/187] KVM: PPC: Book3S PR: Take SRCU read lock around RTAS kvm_read_guest() call
Date: Mon, 15 Sep 2014 15:08:33 -0700
Message-Id: <1410818997-9432-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit ef1af2e29622ff3403926ae801a2b10da075a2de upstream.

This does for PR KVM what c9438092cae4 ("KVM: PPC: Book3S HV: Take SRCU
read lock around kvm_read_guest() call") did for HV KVM, that is,
eliminate a "suspicious rcu_dereference_check() usage!" warning by
taking the SRCU lock around the call to kvmppc_rtas_hcall().

It also fixes a return of RESUME_HOST to return EMULATE_FAIL instead,
since kvmppc_h_pr() is supposed to return EMULATE_* values.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kvm/book3s_pr_papr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
index 5efa97b..7a801b5 100644
--- a/arch/powerpc/kvm/book3s_pr_papr.c
+++ b/arch/powerpc/kvm/book3s_pr_papr.c
@@ -258,6 +258,8 @@ static int kvmppc_h_pr_xics_hcall(struct kvm_vcpu *vcpu, u32 cmd)
 
 int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
 {
+	int rc, idx;
+
 	switch (cmd) {
 	case H_ENTER:
 		return kvmppc_h_pr_enter(vcpu);
@@ -286,8 +288,11 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
 		break;
 	case H_RTAS:
 		if (list_empty(&vcpu->kvm->arch.rtas_tokens))
-			return RESUME_HOST;
-		if (kvmppc_rtas_hcall(vcpu))
+			break;
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		rc = kvmppc_rtas_hcall(vcpu);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		if (rc)
 			break;
 		kvmppc_set_gpr(vcpu, 3, 0);
 		return EMULATE_DONE;
-- 
1.9.1

