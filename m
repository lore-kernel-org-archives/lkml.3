Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaBJUTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:19:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaBJTli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:41:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Huth <thuth@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 002/124] KVM: s390: Always store status during SIGP STOP_AND_STORE_STATUS
Date: Mon, 10 Feb 2014 11:39:02 -0800
Message-Id: <1392061264-28124-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (older save_fp_regs) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kvm/kvm-s390.c | 23 ++++++++++++++---------
 arch/s390/kvm/kvm-s390.h |  4 ++--
 arch/s390/kvm/sigp.c     | 15 ++++++++++++++-
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 74e64f8..e1fc2aa 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -755,7 +755,7 @@ static int __guestcopy(struct kvm_vcpu *vcpu, u64 guestdest, void *from,
  * KVM_S390_STORE_STATUS_NOADDR: -> 0x1200 on 64 bit
  * KVM_S390_STORE_STATUS_PREFIXED: -> prefix
  */
-int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
+int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr)
 {
 	unsigned char archmode = 1;
 	int prefix;
@@ -773,14 +773,6 @@ int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
 	} else
 		prefix = 0;
 
-	/*
-	 * The guest FPRS and ACRS are in the host FPRS/ACRS due to the lazy
-	 * copying in vcpu load/put. Lets update our copies before we save
-	 * it into the save area
-	 */
-	save_fp_regs(&vcpu->arch.guest_fpregs);
-	save_access_regs(vcpu->run->s.regs.acrs);
-
 	if (__guestcopy(vcpu, addr + offsetof(struct save_area, fp_regs),
 			vcpu->arch.guest_fpregs.fprs, 128, prefix))
 		return -EFAULT;
@@ -825,6 +817,19 @@ int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
 	return 0;
 }
 
+int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
+{
+	/*
+	 * The guest FPRS and ACRS are in the host FPRS/ACRS due to the lazy
+	 * copying in vcpu load/put. Lets update our copies before we save
+	 * it into the save area
+	 */
+	save_fp_regs(&vcpu->arch.guest_fpregs);
+	save_access_regs(vcpu->run->s.regs.acrs);
+
+	return kvm_s390_store_status_unloaded(vcpu, addr);
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index d75bc5e..59a03d5 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -85,8 +85,8 @@ int kvm_s390_handle_01(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu,
-				 unsigned long addr);
+int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
+int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
 
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 1278873..7b35c77 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -130,6 +130,7 @@ unlock:
 static int __inject_sigp_stop(struct kvm_s390_local_interrupt *li, int action)
 {
 	struct kvm_s390_interrupt_info *inti;
+	int rc = SIGP_CC_ORDER_CODE_ACCEPTED;
 
 	inti = kzalloc(sizeof(*inti), GFP_ATOMIC);
 	if (!inti)
@@ -139,6 +140,8 @@ static int __inject_sigp_stop(struct kvm_s390_local_interrupt *li, int action)
 	spin_lock_bh(&li->lock);
 	if ((atomic_read(li->cpuflags) & CPUSTAT_STOPPED)) {
 		kfree(inti);
+		if ((action & ACTION_STORE_ON_STOP) != 0)
+			rc = -ESHUTDOWN;
 		goto out;
 	}
 	list_add_tail(&inti->list, &li->list);
@@ -150,7 +153,7 @@ static int __inject_sigp_stop(struct kvm_s390_local_interrupt *li, int action)
 out:
 	spin_unlock_bh(&li->lock);
 
-	return SIGP_CC_ORDER_CODE_ACCEPTED;
+	return rc;
 }
 
 static int __sigp_stop(struct kvm_vcpu *vcpu, u16 cpu_addr, int action)
@@ -174,6 +177,16 @@ static int __sigp_stop(struct kvm_vcpu *vcpu, u16 cpu_addr, int action)
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
 
-- 
1.8.3.2

