Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbaLAU1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:27:48 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaLAU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:27:46 -0500
From: Richard Weinberger <richard@nod.at>
To: jic23@kernel.org
Cc: harald@ccbib.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] iio: dht11: Add locking
Date: Mon,  1 Dec 2014 21:27:30 +0100
Message-Id: <1417465651-16036-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect the read function from concurrent reads.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/iio/humidity/dht11.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
index 623c145..7636e66 100644
--- a/drivers/iio/humidity/dht11.c
+++ b/drivers/iio/humidity/dht11.c
@@ -57,6 +57,7 @@ struct dht11 {
 	int				irq;
 
 	struct completion		completion;
+	struct mutex			lock;
 
 	s64				timestamp;
 	int				temperature;
@@ -146,16 +147,17 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
 	int ret;
 
 	if (dht11->timestamp + DHT11_DATA_VALID_TIME < iio_get_time_ns()) {
+		mutex_lock(&dht11->lock);
 		reinit_completion(&dht11->completion);
 
 		dht11->num_edges = 0;
 		ret = gpio_direction_output(dht11->gpio, 0);
 		if (ret)
-			goto err;
+			goto err_unlock;
 		msleep(DHT11_START_TRANSMISSION);
 		ret = gpio_direction_input(dht11->gpio);
 		if (ret)
-			goto err;
+			goto err_unlock;
 
 		ret = wait_for_completion_killable_timeout(&dht11->completion,
 								 HZ);
@@ -166,14 +168,16 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
 			ret = -ETIMEDOUT;
 		}
 		if (ret < 0)
-			goto err;
+			goto err_unlock;
 
 		ret = dht11_decode(dht11,
 				dht11->num_edges == DHT11_EDGES_PER_READ ?
 					DHT11_EDGES_PREAMBLE :
 					DHT11_EDGES_PREAMBLE - 2);
+
+		mutex_unlock(&dht11->lock);
 		if (ret)
-			goto err;
+			goto out;
 	}
 
 	ret = IIO_VAL_INT;
@@ -183,9 +187,13 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
 		*val = dht11->humidity;
 	else
 		ret = -EINVAL;
-err:
+out:
 	dht11->num_edges = -1;
 	return ret;
+
+err_unlock:
+	mutex_unlock(&dht11->lock);
+	goto out;
 }
 
 static const struct iio_info dht11_iio_info = {
@@ -268,6 +276,7 @@ static int dht11_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, iio);
 
 	init_completion(&dht11->completion);
+	mutex_init(&dht11->lock);
 	iio->name = pdev->name;
 	iio->dev.parent = &pdev->dev;
 	iio->info = &dht11_iio_info;
-- 
2.1.0

