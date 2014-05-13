Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938AbaEMO4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:56:47 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:42133 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874AbaEMO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:56:02 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH 5/5] KVM: x86: add capability to get/set CPL
Date: Tue, 13 May 2014 16:55:41 +0200
Message-Id: <1399992941-11600-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
References: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, KVM used to assume that CS.RPL could always be used as the CPL
value when KVM_SET_SREGS is called.  Unfortunately this is not the case.
If userspace decides to call KVM_GET_SREGS/KVM_SET_SREGS exactly after
CR0.PE has been set to 1, but before the long jump that reloads CS, the
CPL will be reset to bits 0-1 of CS (aka CS.RPL).  This can work or not,
depending on the placement of the code that transitions to protected
mode.  If CS.RPL != 0 the emulator will see CS.RPL != CS.DPL (the DPL
will always be zero) and fail to fetch the next instruction of the
transition code.

To trigger this using QEMU, it is enough to send "info cpus" continuously
while running iPXE (which places its code for real->protected mode in
the EBDA).  iPXE does a lot of transitions, and the guest will crash
very quickly.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/x86.c              | 7 ++++++-
 include/uapi/linux/kvm.h        | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0bc2d91c8a97..5a85423f4e65 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -574,6 +574,8 @@ struct kvm_arch {
 	struct mutex apic_map_lock;
 	struct kvm_apic_map *apic_map;
 
+	bool set_cpl;
+
 	unsigned int tss_addr;
 	struct page *apic_access_page;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca0a1d38fa51..94c6c77e7a9f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2656,6 +2656,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_HYPERV_TIME:
 	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
 	case KVM_CAP_ENABLE_CAP_VM:
+	case KVM_CAP_X86_CPL:
 #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
 	case KVM_CAP_ASSIGN_DEV_IRQ:
 	case KVM_CAP_PCI_2_3:
@@ -3682,6 +3683,10 @@ static int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		return -EINVAL;
 
 	switch (cap->cap) {
+	case KVM_CAP_X86_CPL:
+		kvm->arch.set_cpl = 1;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -6678,7 +6683,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		pr_debug("Set back pending irq %d\n", pending_vec);
 	}
 
-	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS, false);
+	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS, vcpu->kvm->arch.set_cpl);
 	kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS, false);
 	kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES, false);
 	kvm_set_segment(vcpu, &sregs->fs, VCPU_SREG_FS, false);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2b83cf35437a..4bcf34aa1b3b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -748,6 +748,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_S390_IRQCHIP 99
 #define KVM_CAP_IOEVENTFD_NO_LENGTH 100
 #define KVM_CAP_VM_ATTRIBUTES 101
+#define KVM_CAP_X86_CPL 102
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.8.3.1

