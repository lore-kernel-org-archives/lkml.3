Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaLAUL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:11:57 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46490 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAULy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:11:54 -0500
Message-ID: <547CCBFF.5070605@gmail.com>
Date: Tue, 02 Dec 2014 04:13:51 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "gleb@kernel.org" <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] virt: kvm: arm: vgic: Process the failure case when kvm_register_device_ops()
 fails
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_register_device_ops() may fail, so need process the related failure
case.

Since it is related with neither vgic_arch_setup() nor on_each_cpu(),
can move it before them, then simplify the related failure processing
code.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 virt/kvm/arm/vgic.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index cf23c13..814cae2 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2471,13 +2471,20 @@ int kvm_vgic_hyp_init(void)
 		goto out_free_irq;
 	}
 
+	ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
+				      KVM_DEV_TYPE_ARM_VGIC_V2);
+	if (ret) {
+		__unregister_cpu_notifier(&vgic_cpu_nb);
+		kvm_err("Cannot register vgic device ops\n");
+		goto out_free_irq;
+	}
+
 	/* Callback into for arch code for setup */
 	vgic_arch_setup(vgic);
 
 	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
 
-	return kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
-				       KVM_DEV_TYPE_ARM_VGIC_V2);
+	return 0;
 
 out_free_irq:
 	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
-- 
1.9.3
