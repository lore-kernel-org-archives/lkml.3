Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbbAENwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:52:11 -0500
Received: from h1.radempa.de ([176.9.142.194]:43923 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbbAENwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:52:09 -0500
From: Harald Geyer <harald@ccbib.org>
To: Jonathan Cameron <jic23@kernel.org>
cc: Richard Weinberger <richard@nod.at>, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, sanjeev_sharma@mentor.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] iio: dht11: Add locking
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4834.1420465912.1@stardust.g4.wien.funkfeuer.at>
Date: Mon, 05 Jan 2015 14:51:52 +0100
Message-Id: <E1Y884W-0001G0-7b@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that the read function is not interrupted...

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Harald Geyer <harald@ccbib.org>
---
Resending for Richard Weinberger.
No changes since v1 except reordering.

 drivers/iio/humidity/dht11.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
index f546eca..7717f5c 100644
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
1.7.2.5

