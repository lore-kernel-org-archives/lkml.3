Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3EVCBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:01:48 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36781 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347Ab3EVCB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:01:26 -0400
X-Sasl-enc: VurAigXDlZGDtx84ikSkZgPnJaDaxHlvf2wBUPO2o5XA 1369188085
From: Alan Ott <alan@signal11.us>
To: david@hauweele.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net, Alan Ott <alan@signal11.us>
Subject: [PATCH beta 1] 2/3] mrf24j40: Use threaded IRQ handler
Date: Tue, 21 May 2013 22:01:19 -0400
Message-Id: <1369188080-8904-3-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1369188080-8904-1-git-send-email-alan@signal11.us>
References: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com>
 <1369188080-8904-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate all the workqueue and interrupt enable/disable.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/net/ieee802154/mrf24j40.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index 0ea2a5a..a55ab8d 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -83,7 +83,6 @@ struct mrf24j40 {
 
 	struct mutex buffer_mutex; /* only used to protect buf */
 	struct completion tx_complete;
-	struct work_struct irqwork;
 	u8 *buf; /* 3 bytes. Used for SPI single-register transfers. */
 };
 
@@ -591,17 +590,6 @@ static struct ieee802154_ops mrf24j40_ops = {
 static irqreturn_t mrf24j40_isr(int irq, void *data)
 {
 	struct mrf24j40 *devrec = data;
-
-	disable_irq_nosync(irq);
-
-	schedule_work(&devrec->irqwork);
-
-	return IRQ_HANDLED;
-}
-
-static void mrf24j40_isrwork(struct work_struct *work)
-{
-	struct mrf24j40 *devrec = container_of(work, struct mrf24j40, irqwork);
 	u8 intstat;
 	int ret;
 
@@ -619,7 +607,7 @@ static void mrf24j40_isrwork(struct work_struct *work)
 		mrf24j40_handle_rx(devrec);
 
 out:
-	enable_irq(devrec->spi->irq);
+	return IRQ_HANDLED;
 }
 
 static int mrf24j40_probe(struct spi_device *spi)
@@ -649,7 +637,6 @@ static int mrf24j40_probe(struct spi_device *spi)
 
 	mutex_init(&devrec->buffer_mutex);
 	init_completion(&devrec->tx_complete);
-	INIT_WORK(&devrec->irqwork, mrf24j40_isrwork);
 	devrec->spi = spi;
 	dev_set_drvdata(&spi->dev, devrec);
 
@@ -695,11 +682,12 @@ static int mrf24j40_probe(struct spi_device *spi)
 	val &= ~0x3; /* Clear RX mode (normal) */
 	write_short_reg(devrec, REG_RXMCR, val);
 
-	ret = request_irq(spi->irq,
-			  mrf24j40_isr,
-			  IRQF_TRIGGER_FALLING,
-			  dev_name(&spi->dev),
-			  devrec);
+	ret = request_threaded_irq(spi->irq,
+				   NULL,
+				   mrf24j40_isr,
+				   IRQF_TRIGGER_FALLING|IRQF_ONESHOT,
+				   dev_name(&spi->dev),
+				   devrec);
 
 	if (ret) {
 		dev_err(printdev(devrec), "Unable to get IRQ");
@@ -728,7 +716,6 @@ static int mrf24j40_remove(struct spi_device *spi)
 	dev_dbg(printdev(devrec), "remove\n");
 
 	free_irq(spi->irq, devrec);
-	flush_work(&devrec->irqwork); /* TODO: Is this the right call? */
 	ieee802154_unregister_device(devrec->dev);
 	ieee802154_free_device(devrec->dev);
 	/* TODO: Will ieee802154_free_device() wait until ->xmit() is
-- 
1.7.11.2

