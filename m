Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbbASQqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:46:31 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:61785 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbbASQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:45:32 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH v8 3/5] KVM: arm/arm64: implement kvm_arch_intc_initialized
Date: Mon, 19 Jan 2015 17:43:11 +0100
Message-Id: <1421685793-3547-4-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421685793-3547-1-git-send-email-eric.auger@linaro.org>
References: <1421685793-3547-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On arm/arm64 the VGIC is dynamically instantiated and it is useful
to expose its state, especially for irqfd setup.

This patch defines __KVM_HAVE_ARCH_INTC_INITIALIZED and
implements kvm_arch_intc_initialized.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>

---

v7 -> v8:
- add Andre's Reviewed-by

v6 -> v7:
- usage of the new function in irqfd is introduced in previous patch
  file.
- Changed the title and the commit message accordingly

v5 -> v6:
- remove kvm_arch_intc_initialized declaration from
  architecture specific kvm_host.h since it is now in
  generic kvm_host.h
- squash v5 patch files 3 & 4
---
 arch/arm/include/asm/kvm_host.h   | 2 ++
 arch/arm/kvm/arm.c                | 5 +++++
 arch/arm64/include/asm/kvm_host.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 254e065..8f87259 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -27,6 +27,8 @@
 #include <asm/fpstate.h>
 #include <kvm/arm_arch_timer.h>
 
+#define __KVM_HAVE_ARCH_INTC_INITIALIZED
+
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
 #else
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 2d6d910..9c905b4 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -454,6 +454,11 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+bool kvm_arch_intc_initialized(struct kvm *kvm)
+{
+	return vgic_initialized(kvm);
+}
+
 static void vcpu_pause(struct kvm_vcpu *vcpu)
 {
 	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0b7dfdb..dfb6135 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -28,6 +28,8 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
 
+#define __KVM_HAVE_ARCH_INTC_INITIALIZED
+
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
 #else
-- 
1.9.1

