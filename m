Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbaKUQUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:20:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbaKUQUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:20:00 -0500
Date: Fri, 21 Nov 2014 17:19:57 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: move ioapic.c and irq_comm.c back to arch/x86/
Message-ID: <20141121161956.GA16941@potion.brq.redhat.com>
References: <1416490931-21724-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416490931-21724-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-20 14:42+0100, Paolo Bonzini:
> ia64 does not need them anymore.

(Similar for device assignment and iommu, should I prepare patches?)

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

At least one compile-breaker on arches without IOAPIC,

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ea53b04993f2..d2d42709d6f4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> +#ifdef __KVM_HAVE_IOAPIC
> +void kvm_vcpu_request_scan_ioapic(struct kvm *kvm);
> +#else
> +static inline void kvm_vcpu_request-scan_ioapic(struct kvm *kvm)
                                      ^_-
> +{
> +}
> +#endif
> +

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

And we could clean them up as well:
---8<---
KVM: x86: remove IA64 from ioapic.c and irq_comm.c

They won't get compiled in x86 tree.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/ioapic.c   | 12 ------------
 arch/x86/kvm/irq_comm.c | 41 ++---------------------------------------
 2 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 0ba4057..b1947e0 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -270,7 +270,6 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap,
 	spin_unlock(&ioapic->lock);
 }
 
-#ifdef CONFIG_X86
 void kvm_vcpu_request_scan_ioapic(struct kvm *kvm)
 {
 	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
@@ -279,12 +278,6 @@ void kvm_vcpu_request_scan_ioapic(struct kvm *kvm)
 		return;
 	kvm_make_scan_ioapic_request(kvm);
 }
-#else
-void kvm_vcpu_request_scan_ioapic(struct kvm *kvm)
-{
-	return;
-}
-#endif
 
 static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 {
@@ -586,11 +579,6 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 	case IOAPIC_REG_WINDOW:
 		ioapic_write_indirect(ioapic, data);
 		break;
-#ifdef	CONFIG_IA64
-	case IOAPIC_REG_EOI:
-		__kvm_ioapic_update_eoi(NULL, ioapic, data, IOAPIC_LEVEL_TRIG);
-		break;
-#endif
 
 	default:
 		break;
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index a8f988c..72298b3 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -26,9 +26,6 @@
 #include <trace/events/kvm.h>
 
 #include <asm/msidef.h>
-#ifdef CONFIG_IA64
-#include <asm/iosapic.h>
-#endif
 
 #include "irq.h"
 
@@ -38,12 +35,8 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 			   struct kvm *kvm, int irq_source_id, int level,
 			   bool line_status)
 {
-#ifdef CONFIG_X86
 	struct kvm_pic *pic = pic_irqchip(kvm);
 	return kvm_pic_set_irq(pic, e->irqchip.pin, irq_source_id, level);
-#else
-	return -1;
-#endif
 }
 
 static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
@@ -57,12 +50,7 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 
 inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
 {
-#ifdef CONFIG_IA64
-	return irq->delivery_mode ==
-		(IOSAPIC_LOWEST_PRIORITY << IOSAPIC_DELIVERY_SHIFT);
-#else
 	return irq->delivery_mode == APIC_DM_LOWEST;
-#endif
 }
 
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
@@ -202,9 +190,7 @@ int kvm_request_irq_source_id(struct kvm *kvm)
 	}
 
 	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
-#ifdef CONFIG_X86
 	ASSERT(irq_source_id != KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID);
-#endif
 	set_bit(irq_source_id, bitmap);
 unlock:
 	mutex_unlock(&kvm->irq_lock);
@@ -215,9 +201,7 @@ unlock:
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 {
 	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
-#ifdef CONFIG_X86
 	ASSERT(irq_source_id != KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID);
-#endif
 
 	mutex_lock(&kvm->irq_lock);
 	if (irq_source_id < 0 ||
@@ -230,9 +214,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 		goto unlock;
 
 	kvm_ioapic_clear_all(kvm->arch.vioapic, irq_source_id);
-#ifdef CONFIG_X86
 	kvm_pic_clear_all(pic_irqchip(kvm), irq_source_id);
-#endif
 unlock:
 	mutex_unlock(&kvm->irq_lock);
 }
@@ -322,16 +304,11 @@ out:
 	  .u.irqchip = { .irqchip = KVM_IRQCHIP_IOAPIC, .pin = (irq) } }
 #define ROUTING_ENTRY1(irq) IOAPIC_ROUTING_ENTRY(irq)
 
-#ifdef CONFIG_X86
-#  define PIC_ROUTING_ENTRY(irq) \
+#define PIC_ROUTING_ENTRY(irq) \
 	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
 	  .u.irqchip = { .irqchip = SELECT_PIC(irq), .pin = (irq) % 8 } }
-#  define ROUTING_ENTRY2(irq) \
+#define ROUTING_ENTRY2(irq) \
 	IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)
-#else
-#  define ROUTING_ENTRY2(irq) \
-	IOAPIC_ROUTING_ENTRY(irq)
-#endif
 
 static const struct kvm_irq_routing_entry default_routing[] = {
 	ROUTING_ENTRY2(0), ROUTING_ENTRY2(1),
@@ -346,20 +323,6 @@ static const struct kvm_irq_routing_entry default_routing[] = {
 	ROUTING_ENTRY1(18), ROUTING_ENTRY1(19),
 	ROUTING_ENTRY1(20), ROUTING_ENTRY1(21),
 	ROUTING_ENTRY1(22), ROUTING_ENTRY1(23),
-#ifdef CONFIG_IA64
-	ROUTING_ENTRY1(24), ROUTING_ENTRY1(25),
-	ROUTING_ENTRY1(26), ROUTING_ENTRY1(27),
-	ROUTING_ENTRY1(28), ROUTING_ENTRY1(29),
-	ROUTING_ENTRY1(30), ROUTING_ENTRY1(31),
-	ROUTING_ENTRY1(32), ROUTING_ENTRY1(33),
-	ROUTING_ENTRY1(34), ROUTING_ENTRY1(35),
-	ROUTING_ENTRY1(36), ROUTING_ENTRY1(37),
-	ROUTING_ENTRY1(38), ROUTING_ENTRY1(39),
-	ROUTING_ENTRY1(40), ROUTING_ENTRY1(41),
-	ROUTING_ENTRY1(42), ROUTING_ENTRY1(43),
-	ROUTING_ENTRY1(44), ROUTING_ENTRY1(45),
-	ROUTING_ENTRY1(46), ROUTING_ENTRY1(47),
-#endif
 };
 
 int kvm_setup_default_irq_routing(struct kvm *kvm)
-- 
2.1.0

