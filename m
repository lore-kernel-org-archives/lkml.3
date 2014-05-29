Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaE2ElV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:41:21 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55196 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbaE2ElQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:41:16 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, alex.aing@gmail.com,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next v1] mrf24j40: add managed API's provided by device layer
Date: Thu, 29 May 2014 10:10:21 +0530
Message-Id: <1401338421-15394-1-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	Previous patch having bug in using managed API's. I fixed that.

Regards,
Varka Bhadram.

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 drivers/net/ieee802154/mrf24j40.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index 78a6552..f701cdb 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -618,10 +618,10 @@ static int mrf24j40_probe(struct spi_device *spi)
 
 	printk(KERN_INFO "mrf24j40: probe(). IRQ: %d\n", spi->irq);
 
-	devrec = kzalloc(sizeof(struct mrf24j40), GFP_KERNEL);
+	devrec = devm_kzalloc(&spi->dev, sizeof(struct mrf24j40), GFP_KERNEL);
 	if (!devrec)
 		goto err_devrec;
-	devrec->buf = kzalloc(3, GFP_KERNEL);
+	devrec->buf = kzalloc(&spi->dev, 3, GFP_KERNEL);
 	if (!devrec->buf)
 		goto err_buf;
 
@@ -676,12 +676,13 @@ static int mrf24j40_probe(struct spi_device *spi)
 	val &= ~0x3; /* Clear RX mode (normal) */
 	write_short_reg(devrec, REG_RXMCR, val);
 
-	ret = request_threaded_irq(spi->irq,
-				   NULL,
-				   mrf24j40_isr,
-				   IRQF_TRIGGER_LOW|IRQF_ONESHOT,
-				   dev_name(&spi->dev),
-				   devrec);
+	ret = devm_request_threaded_irq(&spi->dev,
+					spi->irq,
+					NULL,
+					mrf24j40_isr,
+					IRQF_TRIGGER_LOW|IRQF_ONESHOT,
+					dev_name(&spi->dev),
+					devrec);
 
 	if (ret) {
 		dev_err(printdev(devrec), "Unable to get IRQ");
@@ -709,15 +710,11 @@ static int mrf24j40_remove(struct spi_device *spi)
 
 	dev_dbg(printdev(devrec), "remove\n");
 
-	free_irq(spi->irq, devrec);
 	ieee802154_unregister_device(devrec->dev);
 	ieee802154_free_device(devrec->dev);
 	/* TODO: Will ieee802154_free_device() wait until ->xmit() is
 	 * complete? */
 
-	/* Clean up the SPI stuff. */
-	kfree(devrec->buf);
-	kfree(devrec);
 	return 0;
 }
 
-- 
1.7.9.5

