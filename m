Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbaLBXdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:33:35 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14388 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449AbaLBXdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:33:08 -0500
From: Richard Weinberger <richard@nod.at>
To: jic23@kernel.org
Cc: harald@ccbib.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/4] iio: dht11: Logging updates
Date: Wed,  3 Dec 2014 00:32:55 +0100
Message-Id: <1417563176-31972-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417563176-31972-1-git-send-email-richard@nod.at>
References: <1417563176-31972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver uses pr_* and dev_* functions.
Change all logging functions to dev_* style to be consistent
and have the correct device prefix in all messages.
This change set also adds new messages to diagnose issues.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/iio/humidity/dht11.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
index 0023699..fbcd7cb 100644
--- a/drivers/iio/humidity/dht11.c
+++ b/drivers/iio/humidity/dht11.c
@@ -96,20 +96,22 @@ static int dht11_decode(struct dht11 *dht11, int offset)
 			timeres = t;
 	}
 	if (2*timeres > DHT11_DATA_BIT_HIGH) {
-		pr_err("dht11: timeresolution %d too bad for decoding\n",
+		dev_err(dht11->dev, "timeresolution %d too bad for decoding\n",
 			timeres);
 		return -EIO;
 	}
 	threshold = DHT11_DATA_BIT_HIGH / timeres;
 	if (DHT11_DATA_BIT_LOW/timeres + 1 >= threshold)
-		pr_err("dht11: WARNING: decoding ambiguous\n");
+		dev_err(dht11->dev, "decoding ambiguous\n");
 
 	/* scale down with timeres and check validity */
 	for (i = 0; i < DHT11_BITS_PER_READ; ++i) {
 		t = dht11->edges[offset + 2*i + 2].ts -
 			dht11->edges[offset + 2*i + 1].ts;
-		if (!dht11->edges[offset + 2*i + 1].value)
-			return -EIO;  /* lost synchronisation */
+		if (!dht11->edges[offset + 2*i + 1].value) {
+			dev_err(dht11->dev, "lost synchronisation\n");
+			return -EIO;
+		}
 		timing[i] = t / timeres;
 	}
 
@@ -119,8 +121,10 @@ static int dht11_decode(struct dht11 *dht11, int offset)
 	temp_dec = dht11_decode_byte(&timing[24], threshold);
 	checksum = dht11_decode_byte(&timing[32], threshold);
 
-	if (((hum_int + hum_dec + temp_int + temp_dec) & 0xff) != checksum)
+	if (((hum_int + hum_dec + temp_int + temp_dec) & 0xff) != checksum) {
+		dev_err(dht11->dev, "invalid checksum\n");
 		return -EIO;
+	}
 
 	dht11->timestamp = iio_get_time_ns();
 	if (hum_int < 20) {  /* DHT22 */
@@ -193,7 +197,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
 		free_irq(dht11->irq, iio_dev);
 
 		if (ret == 0 && dht11->num_edges < DHT11_EDGES_PER_READ - 1) {
-			dev_err(&iio_dev->dev,
+			dev_err(dht11->dev,
 					"Only %d signal edges detected\n",
 					dht11->num_edges);
 			ret = -ETIMEDOUT;
-- 
1.8.4.5

