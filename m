Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbaKTNmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:42:21 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52237 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaKTNmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:42:19 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com
Subject: [PATCH] kvm: x86: move ioapic.c and irq_comm.c back to arch/x86/
Date: Thu, 20 Nov 2014 14:42:11 +0100
Message-Id: <1416490931-21724-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 does not need them anymore.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h   | 16 ++++++++++++++++
 arch/x86/kvm/Makefile             |  5 ++---
 {virt => arch/x86}/kvm/ioapic.c   |  0
 {virt => arch/x86}/kvm/ioapic.h   |  1 -
 {virt => arch/x86}/kvm/irq_comm.c |  4 ++--
 arch/x86/kvm/x86.c                |  1 +
 include/linux/kvm_host.h          | 22 ++++++++--------------
 virt/kvm/eventfd.c                |  7 -------
 virt/kvm/kvm_main.c               |  3 ---
 9 files changed, 29 insertions(+), 30 deletions(-)
 rename {virt => arch/x86}/kvm/ioapic.c (100%)
 rename {virt => arch/x86}/kvm/ioapic.h (98%)
 rename {virt => arch/x86}/kvm/irq_comm.c (98%)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 769db36a3001..76ff3e2d8fd2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -603,6 +603,9 @@ struct kvm_arch {
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
+	/* reads protected by irq_srcu, writes by irq_lock */
+	struct hlist_head mask_notifier_list;
+
 	/* fields used by HYPER-V emulation */
 	u64 hv_guest_os_id;
 	u64 hv_hypercall;
@@ -819,6 +822,19 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
 u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
 
+struct kvm_irq_mask_notifier {
+	void (*func)(struct kvm_irq_mask_notifier *kimn, bool masked);
+	int irq;
+	struct hlist_node link;
+};
+
+void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				    struct kvm_irq_mask_notifier *kimn);
+void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn);
+void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
+			     bool mask);
+
 extern bool tdp_enabled;
 
 u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 25d22b2d6509..ee1cd92b03be 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,14 +7,13 @@ CFLAGS_vmx.o := -I.
 
 KVM := ../../../virt/kvm
 
-kvm-y			+= $(KVM)/kvm_main.o $(KVM)/ioapic.o \
-				$(KVM)/coalesced_mmio.o $(KVM)/irq_comm.o \
+kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_DEVICE_ASSIGNMENT)	+= $(KVM)/assigned-dev.o $(KVM)/iommu.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
-			   i8254.o cpuid.o pmu.o
+			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o
 kvm-intel-y		+= vmx.o
 kvm-amd-y		+= svm.o
 
diff --git a/virt/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
similarity index 100%
rename from virt/kvm/ioapic.c
rename to arch/x86/kvm/ioapic.c
diff --git a/virt/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
similarity index 98%
rename from virt/kvm/ioapic.h
rename to arch/x86/kvm/ioapic.h
index dc3baa3a538f..deac8d509f2a 100644
--- a/virt/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -96,7 +96,6 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, unsigned long *dest_map);
 int kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
-void kvm_vcpu_request_scan_ioapic(struct kvm *kvm);
 void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap,
 			u32 *tmr);
 
diff --git a/virt/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
similarity index 98%
rename from virt/kvm/irq_comm.c
rename to arch/x86/kvm/irq_comm.c
index 1345bde064f5..e9c135b639aa 100644
--- a/virt/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -234,7 +234,7 @@ void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
 {
 	mutex_lock(&kvm->irq_lock);
 	kimn->irq = irq;
-	hlist_add_head_rcu(&kimn->link, &kvm->mask_notifier_list);
+	hlist_add_head_rcu(&kimn->link, &kvm->arch.mask_notifier_list);
 	mutex_unlock(&kvm->irq_lock);
 }
 
@@ -256,7 +256,7 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
 	if (gsi != -1)
-		hlist_for_each_entry_rcu(kimn, &kvm->mask_notifier_list, link)
+		hlist_for_each_entry_rcu(kimn, &kvm->arch.mask_notifier_list, link)
 			if (kimn->irq == gsi)
 				kimn->func(kimn, mask);
 	srcu_read_unlock(&kvm->irq_srcu, idx);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a8f53a6960fd..5337039427c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7264,6 +7264,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		return -EINVAL;
 
+	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ea53b04993f2..d2d42709d6f4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -395,7 +395,6 @@ struct kvm {
 	 * Update side is protected by irq_lock.
 	 */
 	struct kvm_irq_routing_table __rcu *irq_routing;
-	struct hlist_head mask_notifier_list;
 #endif
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	struct hlist_head irq_ack_notifier_list;
@@ -447,6 +446,14 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 int __must_check vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
 
+#ifdef __KVM_HAVE_IOAPIC
+void kvm_vcpu_request_scan_ioapic(struct kvm *kvm);
+#else
+static inline void kvm_vcpu_request-scan_ioapic(struct kvm *kvm)
+{
+}
+#endif
+
 #ifdef CONFIG_HAVE_KVM_IRQFD
 int kvm_irqfd_init(void);
 void kvm_irqfd_exit(void);
@@ -736,19 +743,6 @@ struct kvm_assigned_dev_kernel {
 	struct pci_saved_state *pci_saved_state;
 };
 
-struct kvm_irq_mask_notifier {
-	void (*func)(struct kvm_irq_mask_notifier *kimn, bool masked);
-	int irq;
-	struct hlist_node link;
-};
-
-void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
-				    struct kvm_irq_mask_notifier *kimn);
-void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
-				      struct kvm_irq_mask_notifier *kimn);
-void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
-			     bool mask);
-
 int kvm_irq_map_gsi(struct kvm *kvm,
 		    struct kvm_kernel_irq_routing_entry *entries, int gsi);
 int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index b0fb390943c6..148b2392c762 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -36,9 +36,6 @@
 #include <linux/seqlock.h>
 #include <trace/events/kvm.h>
 
-#ifdef __KVM_HAVE_IOAPIC
-#include "ioapic.h"
-#endif
 #include "iodev.h"
 
 #ifdef CONFIG_HAVE_KVM_IRQFD
@@ -492,9 +489,7 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
 	mutex_lock(&kvm->irq_lock);
 	hlist_add_head_rcu(&kian->link, &kvm->irq_ack_notifier_list);
 	mutex_unlock(&kvm->irq_lock);
-#ifdef __KVM_HAVE_IOAPIC
 	kvm_vcpu_request_scan_ioapic(kvm);
-#endif
 }
 
 void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
@@ -504,9 +499,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 	hlist_del_init_rcu(&kian->link);
 	mutex_unlock(&kvm->irq_lock);
 	synchronize_srcu(&kvm->irq_srcu);
-#ifdef __KVM_HAVE_IOAPIC
 	kvm_vcpu_request_scan_ioapic(kvm);
-#endif
 }
 #endif
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 751ece6a595c..3be43424818b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -468,9 +468,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (r)
 		goto out_err_no_disable;
 
-#ifdef CONFIG_HAVE_KVM_IRQCHIP
-	INIT_HLIST_HEAD(&kvm->mask_notifier_list);
-#endif
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
-- 
1.8.3.1

