Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaEBQGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:06:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaEBPnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 051/151] KVM: s390: Optimize ucontrol path
Date: Fri,  2 May 2014 08:37:19 -0700
Message-Id: <1399045139-4531-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 2955c83f72801245afd0fe5c560cc75b82bea9aa upstream.

Since commit 7c470539c95630c1f2a10f109e96f249730b75eb
(s390/kvm: avoid automatic sie reentry) we will run through the C code
of KVM on host interrupts instead of just reentering the guest. This
will result in additional ucontrol exits (at least HZ per second). Let
handle a 0 intercept in the kernel and dont return to userspace,
even if in ucontrol mode.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kvm/kvm-s390.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bb383df..bfe7726 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -746,7 +746,8 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 
 	if (rc == 0) {
 		if (kvm_is_ucontrol(vcpu->kvm))
-			rc = -EOPNOTSUPP;
+			/* Don't exit for host interrupts. */
+			rc = vcpu->arch.sie_block->icptcode ? -EOPNOTSUPP : 0;
 		else
 			rc = kvm_handle_sie_intercept(vcpu);
 	}
-- 
1.9.1

