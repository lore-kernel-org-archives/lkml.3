Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3HQAPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:15:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51592 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab3HPWjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 093/133] KVM: s390: move kvm_guest_enter,exit closer to sie
Date: Fri, 16 Aug 2013 15:33:55 -0700
Message-Id: <1376692475-28413-94-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Dingel <dingel@linux.vnet.ibm.com>

commit 2b29a9fdcb92bfc6b6f4c412d71505869de61a56 upstream.

Any uaccess between guest_enter and guest_exit could trigger a page fault,
the page fault handler would handle it as a guest fault and translate a
user address as guest address.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kvm/kvm-s390.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8bafa4f..74e64f8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -613,14 +613,25 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		kvm_s390_deliver_pending_interrupts(vcpu);
 
 	vcpu->arch.sie_block->icptcode = 0;
-	preempt_disable();
-	kvm_guest_enter();
-	preempt_enable();
 	VCPU_EVENT(vcpu, 6, "entering sie flags %x",
 		   atomic_read(&vcpu->arch.sie_block->cpuflags));
 	trace_kvm_s390_sie_enter(vcpu,
 				 atomic_read(&vcpu->arch.sie_block->cpuflags));
+
+	/*
+	 * As PF_VCPU will be used in fault handler, between guest_enter
+	 * and guest_exit should be no uaccess.
+	 */
+	preempt_disable();
+	kvm_guest_enter();
+	preempt_enable();
 	rc = sie64a(vcpu->arch.sie_block, vcpu->run->s.regs.gprs);
+	kvm_guest_exit();
+
+	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
+		   vcpu->arch.sie_block->icptcode);
+	trace_kvm_s390_sie_exit(vcpu, vcpu->arch.sie_block->icptcode);
+
 	if (rc) {
 		if (kvm_is_ucontrol(vcpu->kvm)) {
 			rc = SIE_INTERCEPT_UCONTROL;
@@ -631,10 +642,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 			rc = 0;
 		}
 	}
-	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
-		   vcpu->arch.sie_block->icptcode);
-	trace_kvm_s390_sie_exit(vcpu, vcpu->arch.sie_block->icptcode);
-	kvm_guest_exit();
 
 	memcpy(&vcpu->run->s.regs.gprs[14], &vcpu->arch.sie_block->gg14, 16);
 	return rc;
-- 
1.8.1.2

