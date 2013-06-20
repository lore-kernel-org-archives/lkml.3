Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308Ab3FTQSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:18:23 -0400
Received: from mx3.cyfra.ua ([62.80.160.182]:39019 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965122Ab3FTQSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:18:22 -0400
X-Greylist: delayed 9735 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2013 12:18:22 EDT
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
Subject: [PATCH char-misc-next] UIO: Fix concurrency issue
Date: Thu, 20 Jun 2013 16:36:00 +0300
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Pavel Machek <pavel@denx.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201636.00535.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a SMP case there was a race condition issue between 
uio_pdrv_genirq_irqcontrol() running on one CPU and irq handler on another 
CPU. Fix it by spin_locking shared resources access inside irq handler.
Also:
  - Change disable_irq to disable_irq_nosync to avoid deadlock, because 
disable_irq waits for the completion of the irq handler;
  - Change atomic bit-manipulation routines to their non-atomic counterparts 
as we already are guarding the code by spinlock.

Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
---
 drivers/uio/uio_pdrv_genirq.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 9741549..bcd72f3 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -37,6 +37,11 @@ struct uio_pdrv_genirq_platdata {
 	struct platform_device *pdev;
 };
 
+/* Bits in uio_pdrv_genirq_platdata.flags */
+enum {
+	UIO_IRQ_DISABLED = 0,
+};
+
 static int uio_pdrv_genirq_open(struct uio_info *info, struct inode *inode)
 {
 	struct uio_pdrv_genirq_platdata *priv = info->priv;
@@ -63,8 +68,10 @@ static irqreturn_t uio_pdrv_genirq_handler(int irq, struct uio_info *dev_info)
 	 * remember the state so we can allow user space to enable it later.
 	 */
 
-	if (!test_and_set_bit(0, &priv->flags))
+	spin_lock(&priv->lock);
+	if (!__test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
 		disable_irq_nosync(irq);
+	spin_unlock(&priv->lock);
 
 	return IRQ_HANDLED;
 }
@@ -78,16 +85,17 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 	 * in the interrupt controller, but keep track of the
 	 * state to prevent per-irq depth damage.
 	 *
-	 * Serialize this operation to support multiple tasks.
+	 * Serialize this operation to support multiple tasks and concurrency
+	 * with irq handler on SMP systems.
 	 */
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (irq_on) {
-		if (test_and_clear_bit(0, &priv->flags))
+		if (__test_and_clear_bit(UIO_IRQ_DISABLED, &priv->flags))
 			enable_irq(dev_info->irq);
 	} else {
-		if (!test_and_set_bit(0, &priv->flags))
-			disable_irq(dev_info->irq);
+		if (!__test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
+			disable_irq_nosync(dev_info->irq);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-- 
1.7.12.4
-- 
With Best Regards,
Vitalii Demianets
