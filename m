Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbaFXQFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:05:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbaFXP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@linux.vnet.ibm.com>
Subject: [PATCH 3.15 24/61] KVM: s390: Drop pending interrupts on guest exit
Date: Tue, 24 Jun 2014 11:51:07 -0400
Message-Id: <20140624154953.873301308@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 67335e63c9ef59e97b45a08b4a6a93767762031d upstream.

On hard exits (abort, sigkill) we have have some kvm_s390_interrupt_info
structures hanging around. Delete those on exit to avoid memory leaks.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/interrupt.c |    4 ++--
 arch/s390/kvm/kvm-s390.c  |    2 ++
 arch/s390/kvm/kvm-s390.h  |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -900,7 +900,7 @@ int kvm_s390_inject_vcpu(struct kvm_vcpu
 	return 0;
 }
 
-static void clear_floating_interrupts(struct kvm *kvm)
+void kvm_s390_clear_float_irqs(struct kvm *kvm)
 {
 	struct kvm_s390_float_interrupt *fi;
 	struct kvm_s390_interrupt_info	*n, *inti = NULL;
@@ -1246,7 +1246,7 @@ static int flic_set_attr(struct kvm_devi
 		break;
 	case KVM_DEV_FLIC_CLEAR_IRQS:
 		r = 0;
-		clear_floating_interrupts(dev->kvm);
+		kvm_s390_clear_float_irqs(dev->kvm);
 		break;
 	case KVM_DEV_FLIC_APF_ENABLE:
 		dev->kvm->arch.gmap->pfault_enabled = 1;
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -322,6 +322,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vc
 {
 	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
 	trace_kvm_s390_destroy_vcpu(vcpu->vcpu_id);
+	kvm_s390_clear_local_irqs(vcpu);
 	kvm_clear_async_pf_completion_queue(vcpu);
 	if (!kvm_is_ucontrol(vcpu->kvm)) {
 		clear_bit(63 - vcpu->vcpu_id,
@@ -372,6 +373,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm
 	if (!kvm_is_ucontrol(kvm))
 		gmap_free(kvm->arch.gmap);
 	kvm_s390_destroy_adapters(kvm);
+	kvm_s390_clear_float_irqs(kvm);
 }
 
 /* Section: vcpu related */
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -130,6 +130,7 @@ void kvm_s390_tasklet(unsigned long parm
 void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu);
 void kvm_s390_deliver_pending_machine_checks(struct kvm_vcpu *vcpu);
 void kvm_s390_clear_local_irqs(struct kvm_vcpu *vcpu);
+void kvm_s390_clear_float_irqs(struct kvm *kvm);
 int __must_check kvm_s390_inject_vm(struct kvm *kvm,
 				    struct kvm_s390_interrupt *s390int);
 int __must_check kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,


