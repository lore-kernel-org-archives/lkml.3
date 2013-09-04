Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709Ab3IDJd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:33:26 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:61346 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934623Ab3IDJcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:32:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/11] iio: sensors-core: st: Allow full-scale to be an optional feature
Date: Wed,  4 Sep 2013 10:31:39 +0100
Message-Id: <1378287103-21765-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chips either don't support it or fail to provide adequate documentation,
so sometimes it's impossible to enable the feature even if it is supported.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/common/st_sensors/st_sensors_core.c | 11 +++++++----
 drivers/iio/pressure/st_pressure_core.c         |  6 ++++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index 865b178..fc9acb7 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -209,10 +209,13 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev)
 	if (err < 0)
 		goto init_error;
 
-	err = st_sensors_set_fullscale(indio_dev,
-						sdata->current_fullscale->num);
-	if (err < 0)
-		goto init_error;
+	if (sdata->current_fullscale) {
+		err = st_sensors_set_fullscale(indio_dev,
+					       sdata->current_fullscale->num);
+		if (err < 0)
+			goto init_error;
+	} else
+		dev_info(&indio_dev->dev, "Full-scale not possible\n");
 
 	err = st_sensors_set_odr(indio_dev, sdata->odr);
 	if (err < 0)
diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index 7ba9299..423ed6a 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -239,8 +239,10 @@ int st_press_common_probe(struct iio_dev *indio_dev)
 	indio_dev->channels = pdata->sensor->ch;
 	indio_dev->num_channels = ARRAY_SIZE(st_press_lsp331ap_channels);
 
-	pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
-						&pdata->sensor->fs.fs_avl[0];
+	if (pdata->sensor->fs.addr != 0)
+		pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
+			&pdata->sensor->fs.fs_avl[0];
+
 	pdata->odr = pdata->sensor->odr.odr_avl[0].hz;
 
 	err = st_sensors_init_sensor(indio_dev);
-- 
1.8.1.2

