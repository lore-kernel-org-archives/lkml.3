Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbaEMOz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:55:56 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37619 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933981AbaEMOzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:55:54 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH 1/5] KVM: x86: support KVM_ENABLE_CAP on vm file descriptors
Date: Tue, 13 May 2014 16:55:37 +0200
Message-Id: <1399992941-11600-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
References: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use it for CPL save/restore; making it an enabled capability
lets us reuse a padding field in kvm_segment instead of inventing a
new ioctl.  This is also simpler because KVM_SET_SREGS already mucks
with the CPL.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e8c74e6a4c1..8e0532fc4d96 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2655,6 +2655,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_HYPERV_TIME:
 	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
+	case KVM_CAP_ENABLE_CAP_VM:
 #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
 	case KVM_CAP_ASSIGN_DEV_IRQ:
 	case KVM_CAP_PCI_2_3:
@@ -3673,6 +3674,21 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
 	return 0;
 }
 
+static int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	int r;
+
+	if (cap->flags)
+		return -EINVAL;
+
+	switch (cap->cap) {
+	default:
+		r = -EINVAL;
+		break;
+	}
+	return r;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -3709,6 +3725,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_GET_NR_MMU_PAGES:
 		r = kvm_vm_ioctl_get_nr_mmu_pages(kvm);
 		break;
+	case KVM_ENABLE_CAP: {
+		struct kvm_enable_cap cap;
+		r = -EFAULT;
+		if (copy_from_user(&cap, argp, sizeof(cap)))
+			break;
+		r = kvm_vm_ioctl_enable_cap(kvm, &cap);
+		break;
+	}
 	case KVM_CREATE_IRQCHIP: {
 		struct kvm_pic *vpic;
 
-- 
1.8.3.1


