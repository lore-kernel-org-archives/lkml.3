Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaLDJuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:50:06 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54837 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaLDJt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:49:59 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com
Subject: [PATCH v2 4/4] KVM: arm/arm64: vgic: check vgic_initialized in KVM_DEV_ARM_VGIC_GRP_ADDR
Date: Thu,  4 Dec 2014 10:48:04 +0100
Message-Id: <1417686484-20828-5-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
References: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents user-space from changing VGIC base addresses
if the vgic already is initialized.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt | 2 ++
 virt/kvm/arm/vgic.c                            | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 30f5427..8492715 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -19,6 +19,8 @@ Groups:
     KVM_VGIC_V2_ADDR_TYPE_CPU (rw, 64-bit)
       Base address in the guest physical address space of the GIC virtual cpu
       interface register mappings.
+  Errors:
+    -EBUSY: VGIC already is initialized
 
   KVM_DEV_ARM_VGIC_GRP_DIST_REGS
   Attributes:
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 89dca86..652e0bb 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2427,6 +2427,9 @@ static int vgic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		u64 addr;
 		unsigned long type = (unsigned long)attr->attr;
 
+		if (vgic_initialized(dev->kvm))
+			return -EBUSY;
+
 		if (copy_from_user(&addr, uaddr, sizeof(addr)))
 			return -EFAULT;
 
-- 
1.9.1

