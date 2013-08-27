Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3H0BYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:24:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3H0BHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [ 01/74] KVM: s390: move kvm_guest_enter,exit closer to sie
Date: Mon, 26 Aug 2013 18:07:59 -0700
Message-Id: <20130827010425.079132653@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Dingel <dingel@linux.vnet.ibm.com>

commit 2b29a9fdcb92bfc6b6f4c412d71505869de61a56 upstream.

Any uaccess between guest_enter and guest_exit could trigger a page fault,
the page fault handler would handle it as a guest fault and translate a
user address as guest address.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/s390/kvm/kvm-s390.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -622,14 +622,25 @@ static int __vcpu_run(struct kvm_vcpu *v
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
@@ -639,10 +650,6 @@ static int __vcpu_run(struct kvm_vcpu *v
 			rc = kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 		}
 	}
-	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
-		   vcpu->arch.sie_block->icptcode);
-	trace_kvm_s390_sie_exit(vcpu, vcpu->arch.sie_block->icptcode);
-	kvm_guest_exit();
 
 	memcpy(&vcpu->run->s.regs.gprs[14], &vcpu->arch.sie_block->gg14, 16);
 	return rc;


