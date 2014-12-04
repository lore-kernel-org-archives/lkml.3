Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaLDJuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:50:52 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50402 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaLDJty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:49:54 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com
Subject: [PATCH v2 3/4] KVM: arm/arm64: check vgic_initialized before VCPU creation
Date: Thu,  4 Dec 2014 10:48:03 +0100
Message-Id: <1417686484-20828-4-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
References: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that user-space can initiate VGIC initialization independently
on the first vcpu run, let's check the user-space does not attempt
to create a VCPU after this initialization.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 arch/arm/kvm/arm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index b5401f7..edcc66b 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -216,6 +216,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 	int err;
 	struct kvm_vcpu *vcpu;
 
+	if (unlikely(vgic_initialized(kvm))) {
+		err = -EBUSY;
+		goto out;
+	}
+
 	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
 	if (!vcpu) {
 		err = -ENOMEM;
-- 
1.9.1

