Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab3ILR1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:27:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab3ILR0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 19/19] KVM: s390: move kvm_guest_enter,exit closer to sie
Date: Thu, 12 Sep 2013 10:26:28 -0700
Message-Id: <20130912172526.236273607@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
References: <20130912172524.135620246@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Dingel <dingel@linux.vnet.ibm.com>

commit 2b29a9fdcb92bfc6b6f4c412d71505869de61a56 upstream.

Any uaccess between guest_enter and guest_exit could trigger a page fault,
the page fault handler would handle it as a guest fault and translate a
user address as guest address.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.2: adjust context and add the rc variable]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Reviewed-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/kvm-s390.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -445,6 +445,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(stru
 
 static void __vcpu_run(struct kvm_vcpu *vcpu)
 {
+	int rc;
+
 	memcpy(&vcpu->arch.sie_block->gg14, &vcpu->arch.guest_gprs[14], 16);
 
 	if (need_resched())
@@ -455,21 +457,24 @@ static void __vcpu_run(struct kvm_vcpu *
 
 	kvm_s390_deliver_pending_interrupts(vcpu);
 
+	VCPU_EVENT(vcpu, 6, "entering sie flags %x",
+		   atomic_read(&vcpu->arch.sie_block->cpuflags));
+
 	vcpu->arch.sie_block->icptcode = 0;
 	local_irq_disable();
 	kvm_guest_enter();
 	local_irq_enable();
-	VCPU_EVENT(vcpu, 6, "entering sie flags %x",
-		   atomic_read(&vcpu->arch.sie_block->cpuflags));
-	if (sie64a(vcpu->arch.sie_block, vcpu->arch.guest_gprs)) {
+	rc = sie64a(vcpu->arch.sie_block, vcpu->arch.guest_gprs);
+	local_irq_disable();
+	kvm_guest_exit();
+	local_irq_enable();
+
+	if (rc) {
 		VCPU_EVENT(vcpu, 3, "%s", "fault in sie instruction");
 		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 	}
 	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
 		   vcpu->arch.sie_block->icptcode);
-	local_irq_disable();
-	kvm_guest_exit();
-	local_irq_enable();
 
 	memcpy(&vcpu->arch.guest_gprs[14], &vcpu->arch.sie_block->gg14, 16);
 }


