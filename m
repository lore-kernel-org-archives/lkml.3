Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638Ab3IDJcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:32:05 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:59829 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934612Ab3IDJcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:32:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/11] iio: pressure-i2c: st: Simplify error checking in probe()
Date: Wed,  4 Sep 2013 10:31:36 +0100
Message-Id: <1378287103-21765-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strip out all the unnecessary gotos and check for NULL returns in the
usual manner.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/pressure/st_pressure_i2c.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/pressure/st_pressure_i2c.c b/drivers/iio/pressure/st_pressure_i2c.c
index 7cebcc7..2ace770 100644
--- a/drivers/iio/pressure/st_pressure_i2c.c
+++ b/drivers/iio/pressure/st_pressure_i2c.c
@@ -26,10 +26,8 @@ static int st_press_i2c_probe(struct i2c_client *client,
 	int err;
 
 	indio_dev = iio_device_alloc(sizeof(*pdata));
-	if (indio_dev == NULL) {
-		err = -ENOMEM;
-		goto iio_device_alloc_error;
-	}
+	if (!indio_dev)
+		return -ENOMEM;
 
 	pdata = iio_priv(indio_dev);
 	pdata->dev = &client->dev;
@@ -37,15 +35,12 @@ static int st_press_i2c_probe(struct i2c_client *client,
 	st_sensors_i2c_configure(indio_dev, client, pdata);
 
 	err = st_press_common_probe(indio_dev);
-	if (err < 0)
-		goto st_press_common_probe_error;
+	if (err < 0) {
+		iio_device_free(indio_dev);
+		return err;
+	}
 
 	return 0;
-
-st_press_common_probe_error:
-	iio_device_free(indio_dev);
-iio_device_alloc_error:
-	return err;
 }
 
 static int st_press_i2c_remove(struct i2c_client *client)
-- 
1.8.1.2

