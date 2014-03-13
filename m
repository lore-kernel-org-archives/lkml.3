Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaCMP6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:58:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59859 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaCMP6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:58:00 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu
Cc: tech@virtualopensystems.com, n.nikolaev@virtualopensystems.com,
        agraf@suse.de, christoffer.dall@linaro.org, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MA...),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 1/4] ARM: KVM: on unhandled IO mem abort, route the call to the KVM MMIO bus
Date: Thu, 13 Mar 2014 16:57:26 +0100
Message-Id: <1394726249-1547-2-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394726249-1547-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1394726249-1547-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an unhandled IO memory abort, use the kvm_io_bus_* API in order to
handle the MMIO access through any registered read/write callbacks. This
is a dependency for eventfd support (ioeventfd and irqfd).

However, accesses to the VGIC are still left implemented independently,
since the kvm_io_bus_* API doesn't pass the VCPU pointer doing the access.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
---
 arch/arm/kvm/mmio.c | 32 ++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic.c |  5 ++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 4cb5a93..1d17831 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -162,6 +162,35 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	return 0;
 }
 
+/**
+ * kvm_handle_mmio - handle an in-kernel MMIO access
+ * @vcpu:	pointer to the vcpu performing the access
+ * @run:	pointer to the kvm_run structure
+ * @mmio:	pointer to the data describing the access
+ *
+ * returns true if the MMIO access has been performed in kernel space,
+ * and false if it needs to be emulated in user space.
+ */
+static bool handle_kernel_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
+		struct kvm_exit_mmio *mmio)
+{
+	int ret;
+	if (mmio->is_write) {
+		ret = kvm_io_bus_write(vcpu->kvm, KVM_MMIO_BUS, mmio->phys_addr,
+				mmio->len, &mmio->data);
+
+	} else {
+		ret = kvm_io_bus_read(vcpu->kvm, KVM_MMIO_BUS, mmio->phys_addr,
+				mmio->len, &mmio->data);
+	}
+	if (!ret) {
+		kvm_prepare_mmio(run, mmio);
+		kvm_handle_mmio_return(vcpu, run);
+	}
+
+	return !ret;
+}
+
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 phys_addr_t fault_ipa)
 {
@@ -200,6 +229,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	if (vgic_handle_mmio(vcpu, run, &mmio))
 		return 1;
 
+	if (handle_kernel_mmio(vcpu, run, &mmio))
+		return 1;
+
 	kvm_prepare_mmio(run, &mmio);
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 8ca405c..afdecc3 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -849,13 +849,16 @@ struct mmio_range *find_matching_range(const struct mmio_range *ranges,
 }
 
 /**
- * vgic_handle_mmio - handle an in-kernel MMIO access
+ * vgic_handle_mmio - handle an in-kernel vgic MMIO access
  * @vcpu:	pointer to the vcpu performing the access
  * @run:	pointer to the kvm_run structure
  * @mmio:	pointer to the data describing the access
  *
  * returns true if the MMIO access has been performed in kernel space,
  * and false if it needs to be emulated in user space.
+ *
+ * This is handled outside of kvm_handle_mmio because the kvm_io_bus only
+ * passes the VM pointer, while we need the VCPU performing the access.
  */
 bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		      struct kvm_exit_mmio *mmio)
-- 
1.8.3.2

