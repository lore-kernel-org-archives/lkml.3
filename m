Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbaGCJdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:33:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030507AbaGCJYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Meerwald <pmeerw@pmeerw.net>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 169/198] iio: Fix endianness issue in ak8975_read_axis()
Date: Thu,  3 Jul 2014 10:20:12 +0100
Message-Id: <1404379241-8590-170-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Meerwald <pmeerw@pmeerw.net>

commit 8ba42fb7b17649c9ab5b5e79d4e90370a0b4645e upstream.

i2c_smbus_read_word_data() does host endian conversion already,
no need for le16_to_cpu()

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/magnetometer/ak8975.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 9edf4c935fd7..aeba3bbdadb0 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -352,8 +352,6 @@ static int ak8975_read_axis(struct iio_dev *indio_dev, int index, int *val)
 {
 	struct ak8975_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
-	u16 meas_reg;
-	s16 raw;
 	int ret;
 
 	mutex_lock(&data->lock);
@@ -401,16 +399,11 @@ static int ak8975_read_axis(struct iio_dev *indio_dev, int index, int *val)
 		dev_err(&client->dev, "Read axis data fails\n");
 		goto exit;
 	}
-	meas_reg = ret;
 
 	mutex_unlock(&data->lock);
 
-	/* Endian conversion of the measured values. */
-	raw = (s16) (le16_to_cpu(meas_reg));
-
 	/* Clamp to valid range. */
-	raw = clamp_t(s16, raw, -4096, 4095);
-	*val = raw;
+	*val = clamp_t(s16, ret, -4096, 4095);
 	return IIO_VAL_INT;
 
 exit:
-- 
1.9.1

