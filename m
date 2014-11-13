Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335AbaKMPLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:11:40 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35197 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaKMPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:04:06 -0500
Message-ID: <5464C865.90504@gmail.com>
Date: Thu, 13 Nov 2014 23:04:05 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, gleb@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] virt: kvm: arm: vgic: Process the failure case when kvm_register_device_ops()
 fails
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kvm_register_device_ops() fails, also need call free_percpu_irq()
just like others have down within kvm_vgic_hyp_init().

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 virt/kvm/arm/vgic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 3aaca49..b799f17 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2470,8 +2470,14 @@ int kvm_vgic_hyp_init(void)
 
 	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
 
-	return kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
-				       KVM_DEV_TYPE_ARM_VGIC_V2);
+	ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
+				      KVM_DEV_TYPE_ARM_VGIC_V2);
+	if (ret) {
+		kvm_err("Cannot register device ops\n");
+		goto out_free_irq;
+	}
+
+	return 0;
 
 out_free_irq:
 	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
-- 
1.9.3
