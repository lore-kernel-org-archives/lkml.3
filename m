Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbbAENz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:55:29 -0500
Received: from h1.radempa.de ([176.9.142.194]:44425 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbbAENz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:55:27 -0500
From: Harald Geyer <harald@ccbib.org>
To: Jonathan Cameron <jic23@kernel.org>
cc: Richard Weinberger <richard@nod.at>, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, sanjeev_sharma@mentor.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/3] iio: dht11: IRQ fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4845.1420466106.1@stardust.g4.wien.funkfeuer.at>
Date: Mon, 05 Jan 2015 14:55:06 +0100
Message-Id: <E1Y887e-0001GB-G5@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since setting irq-enabled GPIOs into output state is not supported
by all GPIO controllers, we need to disable the irq while requesting
sensor data. As side effect we lose a tiny bit of functionality:
Some wiring problems can't be concluded from log messages anymore.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Harald Geyer <harald@ccbib.org>
---
changes since v1:
Reduce the expected number of edges per data transmission, since we
won't see the edges we generate ourselves.

 drivers/iio/humidity/dht11.c |   62 +++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
index 7717f5c..7d79a1a 100644
--- a/drivers/iio/humidity/dht11.c
+++ b/drivers/iio/humidity/dht11.c
@@ -40,8 +40,12 @@
 
 #define DHT11_DATA_VALID_TIME	2000000000  /* 2s in ns */
 
-#define DHT11_EDGES_PREAMBLE 4
+#define DHT11_EDGES_PREAMBLE 2
 #define DHT11_BITS_PER_READ 40
+/*
+ * Note that when reading the sensor actually 84 edges are detected, but
+ * since the last edge is not significant, we only store 83:
+ */
 #define DHT11_EDGES_PER_READ (2*DHT11_BITS_PER_READ + DHT11_EDGES_PREAMBLE + 1)
 
 /* Data transmission timing (nano seconds) */
@@ -140,6 +144,27 @@ static int dht11_decode(struct dht11 *dht11, int offset)
 	return 0;
 }
 
+/*
+ * IRQ handler called on GPIO edges
+ */
+static irqreturn_t dht11_handle_irq(int irq, void *data)
+{
+	struct iio_dev *iio = data;
+	struct dht11 *dht11 = iio_priv(iio);
+
+	/* TODO: Consider making the handler safe for IRQ sharing */
+	if (dht11->num_edges < DHT11_EDGES_PER_READ && dht11->num_edges >= 0) {
+		dht11->edges[dht11->num_edges].ts = iio_get_time_ns();
+		dht11->edges[dht11->num_edges++].value =
+						gpio_get_value(dht11->gpio);
+
+		if (dht11->num_edges >= DHT11_EDGES_PER_READ)
+			complete(&dht11->completion);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static int dht11_read_raw(struct iio_dev *iio_dev,
 			const struct iio_chan_spec *chan,
 			int *val, int *val2, long m)
@@ -160,8 +185,17 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
 		if (ret)
 			goto err;
 
+		ret = request_irq(dht11->irq, dht11_handle_irq,
+				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				  iio_dev->name, iio_dev);
+		if (ret)
+			goto err;
+
 		ret = wait_for_completion_killable_timeout(&dht11->completion,
 								 HZ);
+
+		free_irq(dht11->irq, iio_dev);
+
 		if (ret == 0 && dht11->num_edges < DHT11_EDGES_PER_READ - 1) {
 			dev_err(&iio_dev->dev,
 					"Only %d signal edges detected\n",
@@ -197,27 +231,6 @@ static const struct iio_info dht11_iio_info = {
 	.read_raw		= dht11_read_raw,
 };
 
-/*
- * IRQ handler called on GPIO edges
-*/
-static irqreturn_t dht11_handle_irq(int irq, void *data)
-{
-	struct iio_dev *iio = data;
-	struct dht11 *dht11 = iio_priv(iio);
-
-	/* TODO: Consider making the handler safe for IRQ sharing */
-	if (dht11->num_edges < DHT11_EDGES_PER_READ && dht11->num_edges >= 0) {
-		dht11->edges[dht11->num_edges].ts = iio_get_time_ns();
-		dht11->edges[dht11->num_edges++].value =
-						gpio_get_value(dht11->gpio);
-
-		if (dht11->num_edges >= DHT11_EDGES_PER_READ)
-			complete(&dht11->completion);
-	}
-
-	return IRQ_HANDLED;
-}
-
 static const struct iio_chan_spec dht11_chan_spec[] = {
 	{ .type = IIO_TEMP,
 		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED), },
@@ -260,11 +273,6 @@ static int dht11_probe(struct platform_device *pdev)
 		dev_err(dev, "GPIO %d has no interrupt\n", dht11->gpio);
 		return -EINVAL;
 	}
-	ret = devm_request_irq(dev, dht11->irq, dht11_handle_irq,
-				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-				pdev->name, iio);
-	if (ret)
-		return ret;
 
 	dht11->timestamp = iio_get_time_ns() - DHT11_DATA_VALID_TIME - 1;
 	dht11->num_edges = -1;
-- 
1.7.2.5

