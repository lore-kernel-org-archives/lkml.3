Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbaGSKdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 06:33:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63164 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760694AbaGSKdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 06:33:49 -0400
Date: Sat, 19 Jul 2014 16:03:41 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] staging:iio:ad7280a: Use managed interfaces
Message-ID: <20140719103341.GA18568@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using unmanaged interfaces to managed
interfaces like devm_kzalloc, devm_iio_device_register, devm_kasprintf,
devm_request_threaded_irq and does away with the calls to free the
allocated memory in the probe and remove functions. Some labels in the
probe function are also removed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
I am not very sure if devmifying request_irq is a good idea as it
leads to the freeing of the interrupt after the ad7280_write.
 drivers/staging/iio/adc/ad7280a.c | 57 ++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
index d215edf..3706b3e 100644
--- a/drivers/staging/iio/adc/ad7280a.c
+++ b/drivers/staging/iio/adc/ad7280a.c
@@ -486,8 +486,8 @@ static int ad7280_channel_init(struct ad7280_state *st)
 {
 	int dev, ch, cnt;
 
-	st->channels = kcalloc((st->slave_num + 1) * 12 + 2,
-			       sizeof(*st->channels), GFP_KERNEL);
+	st->channels = devm_kcalloc(&st->spi->dev, (st->slave_num + 1) * 12 + 2,
+				    sizeof(*st->channels), GFP_KERNEL);
 	if (st->channels == NULL)
 		return -ENOMEM;
 
@@ -547,8 +547,9 @@ static int ad7280_attr_init(struct ad7280_state *st)
 {
 	int dev, ch, cnt;
 
-	st->iio_attr = kzalloc(sizeof(*st->iio_attr) * (st->slave_num + 1) *
-				AD7280A_CELLS_PER_DEV * 2, GFP_KERNEL);
+	st->iio_attr = devm_kzalloc(&st->spi->dev, sizeof(*st->iio_attr) *
+				    (st->slave_num + 1) *
+				    AD7280A_CELLS_PER_DEV * 2, GFP_KERNEL);
 	if (st->iio_attr == NULL)
 		return -ENOMEM;
 
@@ -564,7 +565,7 @@ static int ad7280_attr_init(struct ad7280_state *st)
 			st->iio_attr[cnt].dev_attr.store =
 				ad7280_store_balance_sw;
 			st->iio_attr[cnt].dev_attr.attr.name =
-				kasprintf(GFP_KERNEL,
+				devm_kasprintf(&st->spi->dev, GFP_KERNEL,
 					"in%d-in%d_balance_switch_en",
 					(dev * AD7280A_CELLS_PER_DEV) + ch,
 					(dev * AD7280A_CELLS_PER_DEV) + ch + 1);
@@ -581,7 +582,8 @@ static int ad7280_attr_init(struct ad7280_state *st)
 			st->iio_attr[cnt].dev_attr.store =
 				ad7280_store_balance_timer;
 			st->iio_attr[cnt].dev_attr.attr.name =
-				kasprintf(GFP_KERNEL, "in%d-in%d_balance_timer",
+				devm_kasprintf(&st->spi->dev, GFP_KERNEL,
+					"in%d-in%d_balance_timer",
 					(dev * AD7280A_CELLS_PER_DEV) + ch,
 					(dev * AD7280A_CELLS_PER_DEV) + ch + 1);
 			ad7280_attributes[cnt] =
@@ -900,48 +902,36 @@ static int ad7280_probe(struct spi_device *spi)
 
 	ret = ad7280_attr_init(st);
 	if (ret < 0)
-		goto error_free_channels;
+		return ret;
 
-	ret = iio_device_register(indio_dev);
+	ret = devm_iio_device_register(&spi->dev, indio_dev);
 	if (ret)
-		goto error_free_attr;
+		return ret;
 
 	if (spi->irq > 0) {
 		ret = ad7280_write(st, AD7280A_DEVADDR_MASTER,
 				   AD7280A_ALERT, 1,
 				   AD7280A_ALERT_RELAY_SIG_CHAIN_DOWN);
 		if (ret)
-			goto error_unregister;
+			return ret;
 
 		ret = ad7280_write(st, AD7280A_DEVADDR(st->slave_num),
 				   AD7280A_ALERT, 0,
 				   AD7280A_ALERT_GEN_STATIC_HIGH |
 				   (pdata->chain_last_alert_ignore & 0xF));
 		if (ret)
-			goto error_unregister;
-
-		ret = request_threaded_irq(spi->irq,
-					   NULL,
-					   ad7280_event_handler,
-					   IRQF_TRIGGER_FALLING |
-					   IRQF_ONESHOT,
-					   indio_dev->name,
-					   indio_dev);
+			return ret;
+
+		ret = devm_request_threaded_irq(&spi->dev, spi->irq, NULL,
+						ad7280_event_handler,
+						IRQF_TRIGGER_FALLING |
+						IRQF_ONESHOT, indio_dev->name,
+						indio_dev);
 		if (ret)
-			goto error_unregister;
+			return ret;
 	}
 
 	return 0;
-error_unregister:
-	iio_device_unregister(indio_dev);
-
-error_free_attr:
-	kfree(st->iio_attr);
-
-error_free_channels:
-	kfree(st->channels);
-
-	return ret;
 }
 
 static int ad7280_remove(struct spi_device *spi)
@@ -949,16 +939,9 @@ static int ad7280_remove(struct spi_device *spi)
 	struct iio_dev *indio_dev = spi_get_drvdata(spi);
 	struct ad7280_state *st = iio_priv(indio_dev);
 
-	if (spi->irq > 0)
-		free_irq(spi->irq, indio_dev);
-	iio_device_unregister(indio_dev);
-
 	ad7280_write(st, AD7280A_DEVADDR_MASTER, AD7280A_CONTROL_HB, 1,
 			AD7280A_CTRL_HB_PWRDN_SW | st->ctrl_hb);
 
-	kfree(st->channels);
-	kfree(st->iio_attr);
-
 	return 0;
 }
 
-- 
1.9.1

