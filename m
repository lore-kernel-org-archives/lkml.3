Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaIAMxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:53:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40870 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaIAMxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:53:43 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: [RFC v2 4/9] VFIO: platform: handler tests whether the IRQ is forwarded
Date: Mon,  1 Sep 2014 14:52:43 +0200
Message-Id: <1409575968-5329-5-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
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

