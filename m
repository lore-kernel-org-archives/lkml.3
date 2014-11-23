Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaKWSjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:39:51 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41140 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaKWShf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:37:35 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, agraf@suse.de
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: [PATCH v3 3/8] VFIO: platform: forwarded state tested when selecting IRQ handler
Date: Sun, 23 Nov 2014 19:35:55 +0100
Message-Id: <1416767760-14487-4-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the IRQ is forwarded, the VFIO platform IRQ handler does not
need to disable the IRQ anymore.

When setting the IRQ handler we now also test the forwarded state. In
case the IRQ is forwarded we select the edge handler (no automaske).

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- forwarded state was tested in the handler. Now the forwarded state
  is tested before setting the handler. This definitively limits
  the dynamics of forwarded state changes but I don't think there is
  a use case where we need to be able to change the state at any time.
---
 drivers/vfio/platform/vfio_platform_irq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 08d400e..61a2920 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -230,8 +230,13 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 {
 	struct vfio_platform_irq *irq = &vdev->irqs[index];
 	irq_handler_t handler;
+	struct irq_data *d;
+	bool is_forwarded;
 
-	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE)
+	d = irq_get_irq_data(irq->hwirq);
+	is_forwarded = irqd_irq_forwarded(d);
+
+	if ((vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE) && !is_forwarded)
 		handler = vfio_maskable_irq_handler;
 	else
 		handler = vfio_irq_handler;
-- 
1.9.1

