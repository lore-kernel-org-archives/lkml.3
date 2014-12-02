Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbaLBXdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:33:08 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbaLBXdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:33:05 -0500
From: Richard Weinberger <richard@nod.at>
To: jic23@kernel.org
Cc: harald@ccbib.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/4] iio: dht11: Add locking
Date: Wed,  3 Dec 2014 00:32:53 +0100
Message-Id: <1417563176-31972-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417563176-31972-1-git-send-email-richard@nod.at>
References: <1417563176-31972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that the read function is not interrupted...

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/iio/humidity/dht11.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
index d8771f5..168ebc4 100644
--- a/drivers/iio/humidity/dht11.c
+++ b/drivers/iio/humidity/dht11.c
@@ -29,6 +29,7 @@
 #include <linux/wait.h>
 #include <linux/bitops.h>
 #include <linux/completion.h>
+#include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
@@ -57,6 +58,7 @@ struct dht11 {
 	int				irq;
 
 	struct completion		completion;
+	struct mutex			lock;
 
 	s64				timestamp;
 	int				temperature;
@@ -145,6 +147,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
 	struct dht11 *dht11 = iio_priv(iio_dev);
 	int ret;
 
+	mutex_lock(&dht11->lock);
 	if (dht11->timestamp + DHT11_DATA_VALID_TIME < iio_get_time_ns()) {
 		reinit_completion(&dht11->completion);
 
@@ -185,6 +188,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
 		ret = -EINVAL;
 err:
 	dht11->num_edges = -1;
+	mutex_unlock(&dht11->lock);
 	return ret;
 }
 
@@ -268,6 +272,7 @@ static int dht11_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, iio);
 
 	init_completion(&dht11->completion);
+	mutex_init(&dht11->lock);
 	iio->name = pdev->name;
 	iio->dev.parent = &pdev->dev;
 	iio->info = &dht11_iio_info;
-- 
1.8.4.5

