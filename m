Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbbAGMSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:18:35 -0500
Received: from h1.radempa.de ([176.9.142.194]:53118 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbbAGMSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:18:33 -0500
From: Harald Geyer <harald@ccbib.org>
To: Jonathan Cameron <jic23@kernel.org>
cc: Richard Weinberger <richard@nod.at>, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, sanjeev_sharma@mentor.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 2/3,RESEND] iio: dht11: Add locking
In-reply-to: <54AA97B9.7040703@nod.at>
References: <1417563176-31972-1-git-send-email-richard@nod.at> <54A53FBF.5000003@kernel.org> <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net> <54A680F8.30209@nod.at> <54A91DA1.6080107@kernel.org> <E1Y881p-0001Fp-NX@stardust.g4.wien.funkfeuer.at> <54AA97B9.7040703@nod.at>
Comments: In-reply-to Richard Weinberger <richard@nod.at>
   message dated "Mon, 05 Jan 2015 14:55:05 +0100."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4031.1420633103.1@stardust.g4.wien.funkfeuer.at>
Date: Wed, 07 Jan 2015 13:18:23 +0100
Message-Id: <E1Y8pZ9-000133-AF@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that the read function is not interrupted...

From: Richard Weinberger <richard@nod.at>
Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Harald Geyer <harald@ccbib.org>
Reviewed-by: Sanjeev Sharma <sanjeev_sharma@mentor.com>
---
Resending again to get the metadata right.
No Signed-off-by from me, because I didn't contribute anything.
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

