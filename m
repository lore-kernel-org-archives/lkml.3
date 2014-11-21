Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaKUVW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:22:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaKUVW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:22:26 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] kvm: x86: move assigned-dev.c and iommu.c to arch/x86/
Date: Fri, 21 Nov 2014 22:21:50 +0100
Message-Id: <1416604910-13978-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ia64 is gone, we can hide deprecated device assignment in x86.

Notable changes:
 - kvm_vm_ioctl_assigned_device() was moved to x86/kvm_arch_vm_ioctl()

The easy parts were removed from generic kvm code, remaining
 - kvm_iommu_(un)map_pages() would require new code to be moved
 - struct kvm_assigned_dev_kernel depends on struct kvm_irq_ack_notifier

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 Or are we going to remove it instead? ;)

 arch/x86/include/asm/kvm_host.h       | 23 +++++++++++++++++++++++
 arch/x86/kvm/Makefile                 |  2 +-
 {virt => arch/x86}/kvm/assigned-dev.c |  0
 {virt => arch/x86}/kvm/iommu.c        |  0
 arch/x86/kvm/x86.c                    |  2 +-
 include/linux/kvm_host.h              | 26 --------------------------
 virt/kvm/kvm_main.c                   |  2 --
 7 files changed, 25 insertions(+), 30 deletions(-)
 rename {virt => arch/x86}/kvm/assigned-dev.c (100%)
 rename {virt => arch/x86}/kvm/iommu.c (100%)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 76ff3e2..d549cf8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1112,4 +1112,27 @@ int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 void kvm_handle_pmu_event(struct kvm_vcpu *vcpu);
 void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
+int kvm_iommu_map_guest(struct kvm *kvm);
+int kvm_iommu_unmap_guest(struct kvm *kvm);
+
+long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
+				  unsigned long arg);
+
+void kvm_free_all_assigned_devices(struct kvm *kvm);
+#else
+static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
+{
+	return 0;
+}
+
+static inline long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
+						unsigned long arg)
+{
+	return -ENOTTY;
+}
+
+static inline void kvm_free_all_assigned_devices(struct kvm *kvm) {}
+#endif
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index ee1cd92..08f790d 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -9,11 +9,11 @@ KVM := ../../../virt/kvm
 
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
-kvm-$(CONFIG_KVM_DEVICE_ASSIGNMENT)	+= $(KVM)/assigned-dev.o $(KVM)/iommu.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o
+kvm-$(CONFIG_KVM_DEVICE_ASSIGNMENT)	+= assigned-dev.o iommu.o
 kvm-intel-y		+= vmx.o
 kvm-amd-y		+= svm.o
 
diff --git a/virt/kvm/assigned-dev.c b/arch/x86/kvm/assigned-dev.c
similarity index 100%
rename from virt/kvm/assigned-dev.c
rename to arch/x86/kvm/assigned-dev.c
diff --git a/virt/kvm/iommu.c b/arch/x86/kvm/iommu.c
similarity index 100%
rename from virt/kvm/iommu.c
rename to arch/x86/kvm/iommu.c
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5337039..782e4ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4007,7 +4007,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 
 	default:
-		;
+		r = kvm_vm_ioctl_assigned_device(kvm, ioctl, arg);
 	}
 out:
 	return r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d2d4270..746e3ef 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -764,8 +764,6 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
-int kvm_iommu_map_guest(struct kvm *kvm);
-int kvm_iommu_unmap_guest(struct kvm *kvm);
 int kvm_assign_device(struct kvm *kvm,
 		      struct kvm_assigned_dev_kernel *assigned_dev);
 int kvm_deassign_device(struct kvm *kvm,
@@ -781,11 +779,6 @@ static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
 					 struct kvm_memory_slot *slot)
 {
 }
-
-static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
-{
-	return 0;
-}
 #endif
 
 static inline void kvm_guest_enter(void)
@@ -1005,25 +998,6 @@ static inline bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu) { return true; }
 
 #endif
 
-#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
-
-long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
-				  unsigned long arg);
-
-void kvm_free_all_assigned_devices(struct kvm *kvm);
-
-#else
-
-static inline long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
-						unsigned long arg)
-{
-	return -ENOTTY;
-}
-
-static inline void kvm_free_all_assigned_devices(struct kvm *kvm) {}
-
-#endif
-
 static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
 {
 	set_bit(req, &vcpu->requests);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3be4342..5b45330 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2582,8 +2582,6 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
-		if (r == -ENOTTY)
-			r = kvm_vm_ioctl_assigned_device(kvm, ioctl, arg);
 	}
 out:
 	return r;
-- 
2.1.0

