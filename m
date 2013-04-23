Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3DWVwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:52:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab3DWVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mylene Josserand <Mylene.Josserand@navocap.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 06/42] can: mcp251x: add missing IRQF_ONESHOT to request_threaded_irq
Date: Tue, 23 Apr 2013 14:52:04 -0700
Message-Id: <20130423215206.203367324@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit db388d6460ffa53b3b38429da6f70a913f89b048 upstream.

Since commit:

    1c6c695 genirq: Reject bogus threaded irq requests

threaded irqs must provide a primary handler or set the IRQF_ONESHOT flag.
Since the mcp251x driver doesn't make use of a primary handler set the
IRQF_ONESHOT flag.

Reported-by: Mylene Josserand <Mylene.Josserand@navocap.com>
Tested-by: Mylene Josserand <Mylene.Josserand@navocap.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/mcp251x.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -922,6 +922,7 @@ static int mcp251x_open(struct net_devic
 	struct mcp251x_priv *priv = netdev_priv(net);
 	struct spi_device *spi = priv->spi;
 	struct mcp251x_platform_data *pdata = spi->dev.platform_data;
+	unsigned long flags;
 	int ret;
 
 	ret = open_candev(net);
@@ -938,9 +939,14 @@ static int mcp251x_open(struct net_devic
 	priv->tx_skb = NULL;
 	priv->tx_len = 0;
 
+	flags = IRQF_ONESHOT;
+	if (pdata->irq_flags)
+		flags |= pdata->irq_flags;
+	else
+		flags |= IRQF_TRIGGER_FALLING;
+
 	ret = request_threaded_irq(spi->irq, NULL, mcp251x_can_ist,
-		  pdata->irq_flags ? pdata->irq_flags : IRQF_TRIGGER_FALLING,
-		  DEVICE_NAME, priv);
+				   flags, DEVICE_NAME, priv);
 	if (ret) {
 		dev_err(&spi->dev, "failed to acquire irq %d\n", spi->irq);
 		if (pdata->transceiver_enable)


