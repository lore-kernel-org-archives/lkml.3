Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbaHYN2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:28:46 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:52473 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaHYN2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:28:42 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: [RFC 3/9] VFIO: platform: handler tests whether the IRQ is forwarded
Date: Mon, 25 Aug 2014 15:27:38 +0200
Message-Id: <1408973264-30384-4-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>
References: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the IRQ is forwarded, the VFIO platform IRQ handler does not
need to disable the IRQ anymore. In that mode, when the handler completes
the IRQ is not deactivated but only its priority is lowered.

Some other actor (typically a guest) is supposed to deactivate the IRQ,
allowing at that time a new physical IRQ to hit.

In virtualization use case, the physical IRQ is automatically completed
by the interrupt controller when the guest completes the corresponding
virtual IRQ.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/vfio_platform_irq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 6768508..1f851b2 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -88,13 +88,18 @@ static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
 	struct vfio_platform_irq *irq_ctx = dev_id;
 	unsigned long flags;
 	int ret = IRQ_NONE;
+	struct irq_data *d;
+	bool is_forwarded;
 
 	spin_lock_irqsave(&irq_ctx->lock, flags);
 
 	if (!irq_ctx->masked) {
 		ret = IRQ_HANDLED;
+		d = irq_get_irq_data(irq_ctx->hwirq);
+		is_forwarded = irqd_irq_forwarded(d);
 
-		if (irq_ctx->flags & VFIO_IRQ_INFO_AUTOMASKED) {
+		if (irq_ctx->flags & VFIO_IRQ_INFO_AUTOMASKED &&
+						!is_forwarded) {
 			disable_irq_nosync(irq_ctx->hwirq);
 			irq_ctx->masked = true;
 		}
-- 
1.9.1

