Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaCHBHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:07:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaCHBHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 45/99] KVM: s390: move kvm_guest_enter,exit closer to sie
Date: Fri,  7 Mar 2014 17:07:41 -0800
Message-Id: <20140308010613.051031519@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Dingel <dingel@linux.vnet.ibm.com>

commit 2b29a9fdcb92bfc6b6f4c412d71505869de61a56 upstream.

Any uaccess between guest_enter and guest_exit could trigger a page fault,
the page fault handler would handle it as a guest fault and translate a
user address as guest address.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[hq: Backported to 3.4: adjust context]
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/kvm-s390.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -525,13 +525,18 @@ static int __vcpu_run(struct kvm_vcpu *v
 	if (!kvm_is_ucontrol(vcpu->kvm))
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
 	rc = sie64a(vcpu->arch.sie_block, vcpu->run->s.regs.gprs);
+	local_irq_disable();
+	kvm_guest_exit();
+	local_irq_enable();
+
 	if (rc) {
 		if (kvm_is_ucontrol(vcpu->kvm)) {
 			rc = SIE_INTERCEPT_UCONTROL;
@@ -543,9 +548,6 @@ static int __vcpu_run(struct kvm_vcpu *v
 	}
 	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
 		   vcpu->arch.sie_block->icptcode);
-	local_irq_disable();
-	kvm_guest_exit();
-	local_irq_enable();
 
 	memcpy(&vcpu->run->s.regs.gprs[14], &vcpu->arch.sie_block->gg14, 16);
 	return rc;


