Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbaGORMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:12:30 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46152 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbaGORCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:15 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Meerwald <p.meerwald@bct-electronic.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Jonathan Cameron <jic23@kernel.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 39/94] iio:tcs3472: Check for buffer enabled and locking
Date: Tue, 15 Jul 2014 20:00:54 +0300
Message-Id: <1405443709-15288-39-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <p.meerwald@bct-electronic.com>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/iio/light/tcs3472.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/tcs3472.c b/drivers/iio/light/tcs3472.c
index fe063a0..7525699 100644
--- a/drivers/iio/light/tcs3472.c
+++ b/drivers/iio/light/tcs3472.c
@@ -52,6 +52,7 @@
 
 struct tcs3472_data {
 	struct i2c_client *client;
+	struct mutex lock;
 	u8 enable;
 	u8 control;
 	u8 atime;
@@ -116,10 +117,17 @@ static int tcs3472_read_raw(struct iio_dev *indio_dev,
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
+		if (iio_buffer_enabled(indio_dev))
+			return -EBUSY;
+
+		mutex_lock(&data->lock);
 		ret = tcs3472_req_data(data);
-		if (ret < 0)
+		if (ret < 0) {
+			mutex_unlock(&data->lock);
 			return ret;
+		}
 		ret = i2c_smbus_read_word_data(data->client, chan->address);
+		mutex_unlock(&data->lock);
 		if (ret < 0)
 			return ret;
 		*val = ret;
@@ -255,6 +263,7 @@ static int tcs3472_probe(struct i2c_client *client,
 	data = iio_priv(indio_dev);
 	i2c_set_clientdata(client, indio_dev);
 	data->client = client;
+	mutex_init(&data->lock);
 
 	indio_dev->dev.parent = &client->dev;
 	indio_dev->info = &tcs3472_info;
-- 
1.7.10.4

