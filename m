Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaG1Ind (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:43:33 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54768 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaG1In3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:43:29 -0400
From: pramod.gurav.etc@gmail.com
X-Google-Original-From: pramod.gurav@smartplayin.com
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Brown <broonie@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] input: ads7846: Switch to managed version of kzalloc and cleanups
Date: Mon, 28 Jul 2014 14:16:55 +0530
Message-Id: <1406537216-25936-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav@smartplayin.com>

This switches memory allocations from kzalloc to devm_kzalloc.
This also changes the way return checks were done on failure cases
of three allocations. The checks were clubbed together and hence
must be done seperately to avoid calling kfree on unallocated memory.

Moreover in case of input_allocate_device failure, we were calling
input_free_device which is not needed.

input device must be released(input_free_device) when ads7846_probe_dt
fails hence adds a fix there as well.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Guenter Roeck <linux@roeck-us.net>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Mark Brown <broonie@linaro.org>
CC: Fabio Estevam <fabio.estevam@freescale.com>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
Earlier when kzalloc was used to allocate, the error check for all three
resources (ts, packet, input_dev) was done together. This I felt might
cause a problem in case any of these allocations fails and we may end up
calling kfree on unallocated memory. Moving to managed resource solves this
anyway as we remove references of kfree in probe fail path.



Moving to managed resources solves this anyway.
 drivers/input/touchscreen/ads7846.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index da201b8..d229b8d 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1282,13 +1282,17 @@ static int ads7846_probe(struct spi_device *spi)
 	if (err < 0)
 		return err;
 
-	ts = kzalloc(sizeof(struct ads7846), GFP_KERNEL);
-	packet = kzalloc(sizeof(struct ads7846_packet), GFP_KERNEL);
+	ts = devm_kzalloc(&spi->dev, sizeof(*ts), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	packet = devm_kzalloc(&spi->dev, sizeof(*packet), GFP_KERNEL);
+	if (!packet)
+		return -ENOMEM;
+
 	input_dev = input_allocate_device();
-	if (!ts || !packet || !input_dev) {
-		err = -ENOMEM;
-		goto err_free_mem;
-	}
+	if (!input_dev)
+		return -ENOMEM;
 
 	spi_set_drvdata(spi, ts);
 
@@ -1302,8 +1306,10 @@ static int ads7846_probe(struct spi_device *spi)
 	pdata = dev_get_platdata(&spi->dev);
 	if (!pdata) {
 		pdata = ads7846_probe_dt(&spi->dev);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
+		if (IS_ERR(pdata)) {
+			err = PTR_ERR(pdata);
+			goto err_free_mem;
+		}
 	}
 
 	ts->model = pdata->model ? : 7846;
@@ -1450,8 +1456,6 @@ static int ads7846_probe(struct spi_device *spi)
 		ts->filter_cleanup(ts->filter_data);
  err_free_mem:
 	input_free_device(input_dev);
-	kfree(packet);
-	kfree(ts);
 	return err;
 }
 
@@ -1484,9 +1488,6 @@ static int ads7846_remove(struct spi_device *spi)
 	if (ts->filter_cleanup)
 		ts->filter_cleanup(ts->filter_data);
 
-	kfree(ts->packet);
-	kfree(ts);
-
 	dev_dbg(&spi->dev, "unregistered touchscreen\n");
 
 	return 0;
-- 
1.7.9.5

