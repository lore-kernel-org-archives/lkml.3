Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaEDQyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:54:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaEDPlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH 3.14 033/158] KVM: s390: Optimize ucontrol path
Date: Sun,  4 May 2014 11:39:02 -0400
Message-Id: <20140504154034.459258843@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/kvm-s390.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -753,7 +753,8 @@ static int vcpu_post_run(struct kvm_vcpu
 
 	if (rc == 0) {
 		if (kvm_is_ucontrol(vcpu->kvm))
-			rc = -EOPNOTSUPP;
+			/* Don't exit for host interrupts. */
+			rc = vcpu->arch.sie_block->icptcode ? -EOPNOTSUPP : 0;
 		else
 			rc = kvm_handle_sie_intercept(vcpu);
 	}


