Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaLCQJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:09:13 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34652 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaLCQJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:09:08 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, joel.schopp@amd.com,
        gleb@kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: [PATCH v5 3/5] KVM: arm/arm64: implement kvm_arch_is_virtual_intc_initialized
Date: Wed,  3 Dec 2014 17:07:10 +0100
Message-Id: <1417622832-5460-4-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
References: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on arm/arm64 the VGIC is dynamically instantiated and it is useful
to expose its state, especially for irqfd setup.

This patch defines __KVM_HAVE_ARCH_VIRTUAL_INTC_INITIALIZED
and implements kvm_arch_is_virtual_intc_initialized

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   | 6 ++++++
 arch/arm/kvm/arm.c                | 5 +++++
 arch/arm64/include/asm/kvm_host.h | 5 +++++
 3 files changed, 16 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 53036e2..fe2c89b 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -27,6 +27,8 @@
 #include <asm/fpstate.h>
 #include <kvm/arm_arch_timer.h>
 
+#define __KVM_HAVE_ARCH_VIRTUAL_INTC_INITIALIZED
+
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
 #else
@@ -242,4 +244,8 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
+/* returns true if the vgic dynamic initialization is done*/
+bool kvm_arch_is_virtual_intc_initialized(struct kvm *kvm);
+
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9e193c8..5309e4b 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -439,6 +439,11 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+bool kvm_arch_is_virtual_intc_initialized(struct kvm *kvm)
+{
+	return vgic_initialized(kvm);
+}
+
 static void vcpu_pause(struct kvm_vcpu *vcpu)
 {
 	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2012c4b..5badd30 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -28,6 +28,8 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
 
+#define __KVM_HAVE_ARCH_VIRTUAL_INTC_INITIALIZED
+
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
 #else
@@ -254,4 +256,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
+/* returns true if the vgic dynamic initialization is done*/
+bool kvm_arch_is_virtual_intc_initialized(struct kvm *kvm);
+
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
1.9.1

