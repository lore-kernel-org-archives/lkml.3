Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780Ab3IHDV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56051 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756241Ab3IHDS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dominik Dingel" <dingel@linux.vnet.ibm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.248353977@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [120/121] KVM: s390: move kvm_guest_enter,exit closer to sie
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 arch/s390/kvm/kvm-s390.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -469,6 +469,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(stru
 
 static void __vcpu_run(struct kvm_vcpu *vcpu)
 {
+	int rc;
+
 	memcpy(&vcpu->arch.sie_block->gg14, &vcpu->arch.guest_gprs[14], 16);
 
 	if (need_resched())
@@ -479,21 +481,24 @@ static void __vcpu_run(struct kvm_vcpu *
 
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

