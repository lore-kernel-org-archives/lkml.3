Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaLCQLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:11:37 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62461 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaLCQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:09:10 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, joel.schopp@amd.com,
        gleb@kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: [PATCH v5 4/5] KVM: irqfd: use kvm_arch_is_virtual_intc_initialized
Date: Wed,  3 Dec 2014 17:07:11 +0100
Message-Id: <1417622832-5460-5-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
References: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On arm/arm64, the interrupt controller is dynamically instantiated.
There is a risk the user-space assigns an irqfd before this latter
is initialized and ready to accept virtual irq injection. On such
attempt, the IRQFD setup is rejected and -EAGAIN is returned.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/eventfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index b0fb390..f837c83 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -314,6 +314,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	unsigned int events;
 	int idx;
 
+	if (!kvm_arch_is_virtual_intc_initialized(kvm))
+		return -EAGAIN;
+
 	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
 	if (!irqfd)
 		return -ENOMEM;
-- 
1.9.1

