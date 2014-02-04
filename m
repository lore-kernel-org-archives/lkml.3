Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935262AbaBDVc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:32:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934601AbaBDVMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Huth <thuth@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH 3.13 069/140] KVM: s390: Always store status during SIGP STOP_AND_STORE_STATUS
Date: Tue,  4 Feb 2014 13:10:56 -0800
Message-Id: <20140204211038.929687964@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@linux.vnet.ibm.com>

commit e879892c725217a4af1012f31ae56be762473216 upstream.

The SIGP order STOP_AND_STORE_STATUS is defined to stop a CPU and store
its status. However, we only stored the status if the CPU was still
running, so make sure that the status is now also stored if the CPU was
already stopped. This fixes the problem that the CPU information was
not stored correctly in kdump files, rendering them unreadable.

Signed-off-by: Thomas Huth <thuth@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/kvm-s390.c |   25 +++++++++++++++----------
 arch/s390/kvm/kvm-s390.h |    4 ++--
 arch/s390/kvm/sigp.c     |   15 ++++++++++++++-
 3 files changed, 31 insertions(+), 13 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -885,7 +885,7 @@ static int __guestcopy(struct kvm_vcpu *
  * KVM_S390_STORE_STATUS_NOADDR: -> 0x1200 on 64 bit
  * KVM_S390_STORE_STATUS_PREFIXED: -> prefix
  */
-int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
+int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr)
 {
 	unsigned char archmode = 1;
 	int prefix;
@@ -903,15 +903,6 @@ int kvm_s390_vcpu_store_status(struct kv
 	} else
 		prefix = 0;
 
-	/*
-	 * The guest FPRS and ACRS are in the host FPRS/ACRS due to the lazy
-	 * copying in vcpu load/put. Lets update our copies before we save
-	 * it into the save area
-	 */
-	save_fp_ctl(&vcpu->arch.guest_fpregs.fpc);
-	save_fp_regs(vcpu->arch.guest_fpregs.fprs);
-	save_access_regs(vcpu->run->s.regs.acrs);
-
 	if (__guestcopy(vcpu, addr + offsetof(struct save_area, fp_regs),
 			vcpu->arch.guest_fpregs.fprs, 128, prefix))
 		return -EFAULT;
@@ -956,6 +947,20 @@ int kvm_s390_vcpu_store_status(struct kv
 	return 0;
 }
 
+int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
+{
+	/*
+	 * The guest FPRS and ACRS are in the host FPRS/ACRS due to the lazy
+	 * copying in vcpu load/put. Lets update our copies before we save
+	 * it into the save area
+	 */
+	save_fp_ctl(&vcpu->arch.guest_fpregs.fpc);
+	save_fp_regs(vcpu->arch.guest_fpregs.fprs);
+	save_access_regs(vcpu->run->s.regs.acrs);
+
+	return kvm_s390_store_status_unloaded(vcpu, addr);
+}
+
 static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				     struct kvm_enable_cap *cap)
 {
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -150,8 +150,8 @@ int kvm_s390_handle_eb(struct kvm_vcpu *
 int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu,
-				 unsigned long addr);
+int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
+int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
 void s390_vcpu_block(struct kvm_vcpu *vcpu);
 void s390_vcpu_unblock(struct kvm_vcpu *vcpu);
 void exit_sie(struct kvm_vcpu *vcpu);
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -130,6 +130,7 @@ unlock:
 static int __inject_sigp_stop(struct kvm_s390_local_interrupt *li, int action)
 {
 	struct kvm_s390_interrupt_info *inti;
+	int rc = SIGP_CC_ORDER_CODE_ACCEPTED;
 
 	inti = kzalloc(sizeof(*inti), GFP_ATOMIC);
 	if (!inti)
@@ -139,6 +140,8 @@ static int __inject_sigp_stop(struct kvm
 	spin_lock_bh(&li->lock);
 	if ((atomic_read(li->cpuflags) & CPUSTAT_STOPPED)) {
 		kfree(inti);
+		if ((action & ACTION_STORE_ON_STOP) != 0)
+			rc = -ESHUTDOWN;
 		goto out;
 	}
 	list_add_tail(&inti->list, &li->list);
@@ -150,7 +153,7 @@ static int __inject_sigp_stop(struct kvm
 out:
 	spin_unlock_bh(&li->lock);
 
-	return SIGP_CC_ORDER_CODE_ACCEPTED;
+	return rc;
 }
 
 static int __sigp_stop(struct kvm_vcpu *vcpu, u16 cpu_addr, int action)
@@ -174,6 +177,16 @@ static int __sigp_stop(struct kvm_vcpu *
 unlock:
 	spin_unlock(&fi->lock);
 	VCPU_EVENT(vcpu, 4, "sent sigp stop to cpu %x", cpu_addr);
+
+	if ((action & ACTION_STORE_ON_STOP) != 0 && rc == -ESHUTDOWN) {
+		/* If the CPU has already been stopped, we still have
+		 * to save the status when doing stop-and-store. This
+		 * has to be done after unlocking all spinlocks. */
+		struct kvm_vcpu *dst_vcpu = kvm_get_vcpu(vcpu->kvm, cpu_addr);
+		rc = kvm_s390_store_status_unloaded(dst_vcpu,
+						KVM_S390_STORE_STATUS_NOADDR);
+	}
+
 	return rc;
 }
 


