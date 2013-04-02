Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab3DBW5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:57:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335Ab3DBWut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>, Avi Kivity <avi@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 27/56] KVM: Ensure all vcpus are consistent with in-kernel irqchip settings
Date: Tue,  2 Apr 2013 15:49:54 -0700
Message-Id: <20130402224715.037040056@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Avi Kivity <avi@redhat.com>

commit 3e515705a1f46beb1c942bb8043c16f8ac7b1e9e upstream.

If some vcpus are created before KVM_CREATE_IRQCHIP, then
irqchip_in_kernel() and vcpu->arch.apic will be inconsistent, leading
to potential NULL pointer dereferences.

Fix by:
- ensuring that no vcpus are installed when KVM_CREATE_IRQCHIP is called
- ensuring that a vcpu has an apic if it is installed after KVM_CREATE_IRQCHIP

This is somewhat long winded because vcpu->arch.apic is created without
kvm->lock held.

Based on earlier patch by Michael Ellerman.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/kvm/kvm-ia64.c |    5 +++++
 arch/x86/kvm/x86.c       |    8 ++++++++
 include/linux/kvm_host.h |    7 +++++++
 virt/kvm/kvm_main.c      |    4 ++++
 4 files changed, 24 insertions(+)

--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1168,6 +1168,11 @@ out:
 
 #define PALE_RESET_ENTRY    0x80000000ffffffb0UL
 
+bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu)
+{
+	return irqchip_in_kernel(vcpu->kcm) == (vcpu->arch.apic != NULL);
+}
+
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu *v;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3410,6 +3410,9 @@ long kvm_arch_vm_ioctl(struct file *filp
 		r = -EEXIST;
 		if (kvm->arch.vpic)
 			goto create_irqchip_unlock;
+		r = -EINVAL;
+		if (atomic_read(&kvm->online_vcpus))
+			goto create_irqchip_unlock;
 		r = -ENOMEM;
 		vpic = kvm_create_pic(kvm);
 		if (vpic) {
@@ -6189,6 +6192,11 @@ void kvm_arch_check_processor_compat(voi
 	kvm_x86_ops->check_processor_compatibility(rtn);
 }
 
+bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu)
+{
+	return irqchip_in_kernel(vcpu->kvm) == (vcpu->arch.apic != NULL);
+}
+
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -736,6 +736,13 @@ static inline bool kvm_vcpu_is_bsp(struc
 {
 	return vcpu->kvm->bsp_vcpu_id == vcpu->vcpu_id;
 }
+
+bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu);
+
+#else
+
+static inline bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu) { return true; }
+
 #endif
 
 #ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1619,6 +1619,10 @@ static int kvm_vm_ioctl_create_vcpu(stru
 		goto vcpu_destroy;
 
 	mutex_lock(&kvm->lock);
+	if (!kvm_vcpu_compatible(vcpu)) {
+		r = -EINVAL;
+		goto unlock_vcpu_destroy;
+	}
 	if (atomic_read(&kvm->online_vcpus) == KVM_MAX_VCPUS) {
 		r = -EINVAL;
 		goto unlock_vcpu_destroy;


