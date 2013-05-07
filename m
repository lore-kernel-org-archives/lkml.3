Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab3EGE2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:28:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab3EGEZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:59 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LFsx1OVaSBAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=rc0wpBUqkYsA:10 a=VwQbUJbxAAAA:8 a=98i6H4MSAAAA:8 a=kkBcT8pFGxiLsp0amqIA:9 a=XNN-oNMjSfgA:10 a=mUj28jBQh04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035851.267786130@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mylene Josserand <Mylene.Josserand@navocap.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [062/126] can: mcp251x: add missing IRQF_ONESHOT to request_threaded_irq
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0062-can-mcp251x-add-missing-IRQF_ONESHOT-to-request_thre.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit db388d6460ffa53b3b38429da6f70a913f89b048 ]

Since commit:

    1c6c695 genirq: Reject bogus threaded irq requests

threaded irqs must provide a primary handler or set the IRQF_ONESHOT flag.
Since the mcp251x driver doesn't make use of a primary handler set the
IRQF_ONESHOT flag.

Cc: linux-stable <stable@vger.kernel.org> # >= v3.5
Reported-by: Mylene Josserand <Mylene.Josserand@navocap.com>
Tested-by: Mylene Josserand <Mylene.Josserand@navocap.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/can/mcp251x.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
index 26e7129..108d3ef 100644
--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -922,6 +922,7 @@ static int mcp251x_open(struct net_device *net)
 	struct mcp251x_priv *priv = netdev_priv(net);
 	struct spi_device *spi = priv->spi;
 	struct mcp251x_platform_data *pdata = spi->dev.platform_data;
+	unsigned long flags;
 	int ret;
 
 	ret = open_candev(net);
@@ -938,9 +939,14 @@ static int mcp251x_open(struct net_device *net)
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
-- 
1.7.10.4


