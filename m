Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab3JCFR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:17:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab3JCESs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:18:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Solomon Peachy <pizza@shaftnet.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/57] Revert "cw1200: Dont perform SPI transfers in interrupt context"
Date: Wed,  2 Oct 2013 21:08:53 -0700
Message-Id: <20131003040638.462892808@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Solomon Peachy <pizza@shaftnet.org>

commit c4fb19d21b003ec99ec490ba2cb60baffabc73f3 upstream.

This reverts commit aec8e88c947b7017e2b4bbcb68a4bfc4a1f8ad35.

This solution turned out to cause interrupt delivery problems, and
rather than trying to fix this approach, it has been scrapped in favor
of an alternative (and far simpler) implementation.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/cw1200/cw1200_spi.c |   19 +++----------------
 drivers/net/wireless/cw1200/fwio.c       |    2 +-
 drivers/net/wireless/cw1200/hwbus.h      |    1 -
 drivers/net/wireless/cw1200/hwio.c       |   15 ---------------
 4 files changed, 4 insertions(+), 33 deletions(-)

--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -42,7 +42,6 @@ struct hwbus_priv {
 	spinlock_t		lock; /* Serialize all bus operations */
 	wait_queue_head_t       wq;
 	int claimed;
-	int irq_disabled;
 };
 
 #define SDIO_TO_SPI_ADDR(addr) ((addr & 0x1f)>>2)
@@ -238,8 +237,6 @@ static irqreturn_t cw1200_spi_irq_handle
 	struct hwbus_priv *self = dev_id;
 
 	if (self->core) {
-		disable_irq_nosync(self->func->irq);
-		self->irq_disabled = 1;
 		cw1200_irq_handler(self->core);
 		return IRQ_HANDLED;
 	} else {
@@ -273,22 +270,13 @@ exit:
 
 static int cw1200_spi_irq_unsubscribe(struct hwbus_priv *self)
 {
+	int ret = 0;
+
 	pr_debug("SW IRQ unsubscribe\n");
 	disable_irq_wake(self->func->irq);
 	free_irq(self->func->irq, self);
 
-	return 0;
-}
-
-static int cw1200_spi_irq_enable(struct hwbus_priv *self, int enable)
-{
-	/* Disables are handled by the interrupt handler */
-	if (enable && self->irq_disabled) {
-		enable_irq(self->func->irq);
-		self->irq_disabled = 0;
-	}
-
-	return 0;
+	return ret;
 }
 
 static int cw1200_spi_off(const struct cw1200_platform_data_spi *pdata)
@@ -368,7 +356,6 @@ static struct hwbus_ops cw1200_spi_hwbus
 	.unlock			= cw1200_spi_unlock,
 	.align_size		= cw1200_spi_align_size,
 	.power_mgmt		= cw1200_spi_pm,
-	.irq_enable             = cw1200_spi_irq_enable,
 };
 
 /* Probe Function to be called by SPI stack when device is discovered */
--- a/drivers/net/wireless/cw1200/fwio.c
+++ b/drivers/net/wireless/cw1200/fwio.c
@@ -485,7 +485,7 @@ int cw1200_load_firmware(struct cw1200_c
 
 	/* Enable interrupt signalling */
 	priv->hwbus_ops->lock(priv->hwbus_priv);
-	ret = __cw1200_irq_enable(priv, 2);
+	ret = __cw1200_irq_enable(priv, 1);
 	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	if (ret < 0)
 		goto unsubscribe;
--- a/drivers/net/wireless/cw1200/hwbus.h
+++ b/drivers/net/wireless/cw1200/hwbus.h
@@ -28,7 +28,6 @@ struct hwbus_ops {
 	void (*unlock)(struct hwbus_priv *self);
 	size_t (*align_size)(struct hwbus_priv *self, size_t size);
 	int (*power_mgmt)(struct hwbus_priv *self, bool suspend);
-	int (*irq_enable)(struct hwbus_priv *self, int enable);
 };
 
 #endif /* CW1200_HWBUS_H */
--- a/drivers/net/wireless/cw1200/hwio.c
+++ b/drivers/net/wireless/cw1200/hwio.c
@@ -273,21 +273,6 @@ int __cw1200_irq_enable(struct cw1200_co
 	u16 val16;
 	int ret;
 
-	/* We need to do this hack because the SPI layer can sleep on I/O
-	   and the general path involves I/O to the device in interrupt
-	   context.
-
-	   However, the initial enable call needs to go to the hardware.
-
-	   We don't worry about shutdown because we do a full reset which
-	   clears the interrupt enabled bits.
-	*/
-	if (priv->hwbus_ops->irq_enable) {
-		ret = priv->hwbus_ops->irq_enable(priv->hwbus_priv, enable);
-		if (ret || enable < 2)
-			return ret;
-	}
-
 	if (HIF_8601_SILICON == priv->hw_type) {
 		ret = __cw1200_reg_read_32(priv, ST90TDS_CONFIG_REG_ID, &val32);
 		if (ret < 0) {


