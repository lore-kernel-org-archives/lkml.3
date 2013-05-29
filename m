Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966099Ab3E2NHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:07:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53499 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966084Ab3E2NHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:07:14 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v1 3/3] usb: musb: dsps: handle babble condition for dsps platform
Date: Wed, 29 May 2013 18:37:04 +0530
Message-ID: <1369832824-29071-4-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
References: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding babble recovery mechanism for dsps platform and as part
of babble recovery the controller will be restarted.

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_dsps.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 958c6b6..efe95e1 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -294,9 +294,17 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
 	 * value but DEVCTL.BDEVICE is invalid without DEVCTL.SESSION set.
 	 * Also, DRVVBUS pulses for SRP (but not at 5V) ...
 	 */
-	if (is_host_active(musb) && usbintr & MUSB_INTR_BABBLE)
+	if (is_host_active(musb) && usbintr & MUSB_INTR_BABBLE) {
 		pr_info("CAUTION: musb: Babble Interrupt Occurred\n");
 
+		/* during babble condition the musb controller removes
+		 * session (or stops) and no longer in host mode. Hence
+		 * all the devices connected to root hub gets disconnected
+		 */
+		musb->int_usb = MUSB_INTR_BABBLE | MUSB_INTR_DISCONNECT;
+		musb->int_tx = musb->int_rx = 0;
+	}
+
 	if (usbintr & ((1 << wrp->drvvbus) << wrp->usb_shift)) {
 		int drvvbus = dsps_readl(reg_base, wrp->status);
 		void __iomem *mregs = musb->mregs;
@@ -428,6 +436,29 @@ static int dsps_musb_exit(struct musb *musb)
 	return 0;
 }
 
+static void dsps_musb_restart(struct musb *musb)
+{
+	struct device *dev = musb->controller;
+	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
+	const struct dsps_musb_wrapper *wrp = glue->wrp;
+	void __iomem *reg_base = musb->ctrl_base;
+
+	/* Reset the musb */
+	dsps_writel(reg_base, wrp->control, (1 << wrp->reset));
+	udelay(100);
+
+	/* Stop the on-chip PHY and its PLL. */
+	usb_phy_vbus_off(musb->xceiv);
+	udelay(100);
+
+	/* Start the on-chip PHY and its PLL. */
+	usb_phy_vbus_on(musb->xceiv);
+	udelay(100);
+
+	/* reinit the endpoint fifo table and restart musb */
+	musb_restart(musb);
+}
+
 static struct musb_platform_ops dsps_ops = {
 	.init		= dsps_musb_init,
 	.exit		= dsps_musb_exit,
@@ -436,6 +467,7 @@ static struct musb_platform_ops dsps_ops = {
 	.disable	= dsps_musb_disable,
 
 	.try_idle	= dsps_musb_try_idle,
+	.babble_recovery = dsps_musb_restart,
 };
 
 static u64 musb_dmamask = DMA_BIT_MASK(32);
-- 
1.7.0.4

