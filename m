Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaKXOLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:11:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbaKXOLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:11:31 -0500
Date: Mon, 24 Nov 2014 15:11:26 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] kvm: x86: move assigned-dev.c and iommu.c to arch/x86/
Message-ID: <20141124141126.GA6795@potion.brq.redhat.com>
References: <1416604910-13978-1-git-send-email-rkrcmar@redhat.com>
 <5470B859.3000104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5470B859.3000104@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-22 17:22+0100, Paolo Bonzini:
> On 21/11/2014 22:21, Radim Krčmář wrote:
> >  - struct kvm_assigned_dev_kernel depends on struct kvm_irq_ack_notifier
> 
> kvm_assign_device and kvm_deassign_device can also be moved to arch/x86,
> in a new assigned-dev.h header.  The header could include struct
> kvm_assigned_dev_kernel too but, if you change the argument of
> kvm_assign_device and kvm_deassign_device to struct pci_dev, the struct
> can move directly to assigned-dev.c and remain hidden there.

Thanks!

> It's fine to do this as a follow up.

With assigned-dev.h, we could remove everything from x86/kvm_host.h too,
which would be better as a replacement to the original

---8<---
kvm: x86: move assigned-dev.c and iommu.c to arch/x86/

Now that ia64 is gone, we can hide deprecated device assignment in x86.

kvm_vm_ioctl_assigned_device() is newly called from kvm_arch_vm_ioctl().
Definitions and declarations have been consolidated into assigned-dev.h.

Remaining kvm_iommu_(un)map_pages() would require new code to be moved.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/Makefile                 |  2 +-
 {virt => arch/x86}/kvm/assigned-dev.c |  1 +
 arch/x86/kvm/assigned-dev.h           | 59 +++++++++++++++++++++++++++++++++++
 {virt => arch/x86}/kvm/iommu.c        |  1 +
 arch/x86/kvm/x86.c                    |  3 +-
 include/linux/kvm_host.h              | 55 --------------------------------
 virt/kvm/kvm_main.c                   |  2 --
 7 files changed, 64 insertions(+), 59 deletions(-)
 rename {virt => arch/x86}/kvm/assigned-dev.c (99%)
 create mode 100644 arch/x86/kvm/assigned-dev.h
 rename {virt => arch/x86}/kvm/iommu.c (99%)

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
similarity index 99%
rename from virt/kvm/assigned-dev.c
rename to arch/x86/kvm/assigned-dev.c
index e05000e..0cfd54f5f 100644
--- a/virt/kvm/assigned-dev.c
+++ b/arch/x86/kvm/assigned-dev.c
@@ -20,6 +20,7 @@
 #include <linux/namei.h>
 #include <linux/fs.h>
 #include "irq.h"
+#include "assigned-dev.h"
 
 static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
 						      int assigned_dev_id)
diff --git a/arch/x86/kvm/assigned-dev.h b/arch/x86/kvm/assigned-dev.h
new file mode 100644
index 0000000..4caabc5
--- /dev/null
+++ b/arch/x86/kvm/assigned-dev.h
@@ -0,0 +1,59 @@
+#ifndef ARCH_X86_KVM_ASSIGNED_DEV_H
+#define ARCH_X86_KVM_ASSIGNED_DEV_H
+
+#include <linux/kvm_host.h>
+
+#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
+struct kvm_assigned_dev_kernel {
+	struct kvm_irq_ack_notifier ack_notifier;
+	struct list_head list;
+	int assigned_dev_id;
+	int host_segnr;
+	int host_busnr;
+	int host_devfn;
+	unsigned int entries_nr;
+	int host_irq;
+	bool host_irq_disabled;
+	bool pci_2_3;
+	struct msix_entry *host_msix_entries;
+	int guest_irq;
+	struct msix_entry *guest_msix_entries;
+	unsigned long irq_requested_type;
+	int irq_source_id;
+	int flags;
+	struct pci_dev *dev;
+	struct kvm *kvm;
+	spinlock_t intx_lock;
+	spinlock_t intx_mask_lock;
+	char irq_name[32];
+	struct pci_saved_state *pci_saved_state;
+};
+
+int kvm_assign_device(struct kvm *kvm,
+		      struct kvm_assigned_dev_kernel *assigned_dev);
+int kvm_deassign_device(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *assigned_dev);
+
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
+#endif /* CONFIG_KVM_DEVICE_ASSIGNMENT */
+
+#endif /* ARCH_X86_KVM_ASSIGNED_DEV_H */
diff --git a/virt/kvm/iommu.c b/arch/x86/kvm/iommu.c
similarity index 99%
rename from virt/kvm/iommu.c
rename to arch/x86/kvm/iommu.c
index c1e6ae9..91b0f48 100644
--- a/virt/kvm/iommu.c
+++ b/arch/x86/kvm/iommu.c
@@ -31,6 +31,7 @@
 #include <linux/dmar.h>
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
+#include "assigned-dev.h"
 
 static bool allow_unsafe_assigned_interrupts;
 module_param_named(allow_unsafe_assigned_interrupts,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5337039..c42bca4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -27,6 +27,7 @@
 #include "kvm_cache_regs.h"
 #include "x86.h"
 #include "cpuid.h"
+#include "assigned-dev.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -4007,7 +4008,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 
 	default:
-		;
+		r = kvm_vm_ioctl_assigned_device(kvm, ioctl, arg);
 	}
 out:
 	return r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d2d4270..6dcd820 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -718,31 +718,6 @@ struct kvm_irq_ack_notifier {
 	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
 };
 
-struct kvm_assigned_dev_kernel {
-	struct kvm_irq_ack_notifier ack_notifier;
-	struct list_head list;
-	int assigned_dev_id;
-	int host_segnr;
-	int host_busnr;
-	int host_devfn;
-	unsigned int entries_nr;
-	int host_irq;
-	bool host_irq_disabled;
-	bool pci_2_3;
-	struct msix_entry *host_msix_entries;
-	int guest_irq;
-	struct msix_entry *guest_msix_entries;
-	unsigned long irq_requested_type;
-	int irq_source_id;
-	int flags;
-	struct pci_dev *dev;
-	struct kvm *kvm;
-	spinlock_t intx_lock;
-	spinlock_t intx_mask_lock;
-	char irq_name[32];
-	struct pci_saved_state *pci_saved_state;
-};
-
 int kvm_irq_map_gsi(struct kvm *kvm,
 		    struct kvm_kernel_irq_routing_entry *entries, int gsi);
 int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin);
@@ -764,12 +739,6 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
-int kvm_iommu_map_guest(struct kvm *kvm);
-int kvm_iommu_unmap_guest(struct kvm *kvm);
-int kvm_assign_device(struct kvm *kvm,
-		      struct kvm_assigned_dev_kernel *assigned_dev);
-int kvm_deassign_device(struct kvm *kvm,
-			struct kvm_assigned_dev_kernel *assigned_dev);
 #else
 static inline int kvm_iommu_map_pages(struct kvm *kvm,
 				      struct kvm_memory_slot *slot)
@@ -781,11 +750,6 @@ static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
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
@@ -1005,25 +969,6 @@ static inline bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu) { return true; }
 
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

