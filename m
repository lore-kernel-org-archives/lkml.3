Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbaEGNPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:15:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45697 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483AbaEGNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:15:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 70/70] KVM: s390: Optimize ucontrol path
Date: Wed,  7 May 2014 14:13:13 +0100
Message-Id: <1399468393-10140-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kvm/kvm-s390.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 34c1c9a..e13e7af 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -781,7 +781,8 @@ rerun_vcpu:
 		if (rc)
 			break;
 		if (kvm_is_ucontrol(vcpu->kvm))
-			rc = -EOPNOTSUPP;
+			/* Don't exit for host interrupts. */
+			rc = vcpu->arch.sie_block->icptcode ? -EOPNOTSUPP : 0;
 		else
 			rc = kvm_handle_sie_intercept(vcpu);
 	} while (!signal_pending(current) && !rc);
-- 
1.9.1

