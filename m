Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965715AbaKNPTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:19:04 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:48340 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341AbaKNPS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:18:59 -0500
Message-ID: <54661D5F.3060304@gmail.com>
Date: Fri, 14 Nov 2014 23:18:55 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "gleb@kernel.org" <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] virt: kvm: arm: vgic: Process the failure case when kvm_register_device_ops()
 fails
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kvm_register_device_ops() fails, need disable_percpu_irq(), need
vgic_arch_unsetup(), need __unregister_cpu_notifier(), and also need
free_percpu_irq().

At present, there is no vgic_arch_unsetup(), so add it for resetting
'__vgic_sr_vectors'.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/arm/include/asm/kvm_host.h   |  1 +
 arch/arm64/include/asm/kvm_host.h |  8 ++++++++
 virt/kvm/arm/vgic.c               | 19 +++++++++++++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 53036e2..f68e302 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -232,6 +232,7 @@ static inline void vgic_arch_setup(const struct vgic_params *vgic)
 {
 	BUG_ON(vgic->type != VGIC_V2);
 }
+static inline void vgic_arch_unsetup(void) {}
 
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2012c4b..597500c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -248,6 +248,14 @@ static inline void vgic_arch_setup(const struct vgic_params *vgic)
 	}
 }
 
+static inline void vgic_arch_unsetup(void)
+{
+	extern struct vgic_sr_vectors __vgic_sr_vectors;
+
+	__vgic_sr_vectors.save_vgic	= 0;
+	__vgic_sr_vectors.restore_vgic	= 0;
+}
+
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 3aaca49..bab81f7 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2405,6 +2405,11 @@ static void vgic_init_maintenance_interrupt(void *info)
 	enable_percpu_irq(vgic->maint_irq, 0);
 }
 
+static void vgic_uninit_maintenance_interrupt(void *info)
+{
+	disable_percpu_irq(vgic->maint_irq);
+}
+
 static int vgic_cpu_notify(struct notifier_block *self,
 			   unsigned long action, void *cpu)
 {
@@ -2470,9 +2475,19 @@ int kvm_vgic_hyp_init(void)
 
 	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
 
-	return kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
-				       KVM_DEV_TYPE_ARM_VGIC_V2);
+	ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
+				      KVM_DEV_TYPE_ARM_VGIC_V2);
+	if (ret) {
+		kvm_err("Cannot register device ops\n");
+		goto out_disable_irq;
+	}
+
+	return 0;
 
+out_disable_irq:
+	on_each_cpu(vgic_uninit_maintenance_interrupt, NULL, 1);
+	vgic_arch_unsetup();
+	__unregister_cpu_notifier(&vgic_cpu_nb);
 out_free_irq:
 	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
 	return ret;
-- 
1.9.3
