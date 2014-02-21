Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbaBUNaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:30:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47177 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbaBUMvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Beomho Seo <beomho.seo@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 090/121] iio: ak8975: Fix calculation formula for convert micro tesla to gauss unit
Date: Fri, 21 Feb 2014 12:48:34 +0000
Message-Id: <1392986945-9693-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beomho Seo <beomho.seo@samsung.com>

commit bef44abccb2677e8d16e50b75316d4fd1061be81 upstream.

This effects the reported scale of the raw values, and thus userspace
applications that use this value.

One micro tesla equal 0.01 gauss. So I have fixed calculation formula And add RAW_TO_GAUSS macro.
ASA is in the range of 0 to 255. If multiply 0.003, calculation result(in_magn_[*]_scale) is
always 0. So multiply 3000 and return and IIO_VAL_INT_PLUS_MICRO.
As a result, read_raw call back function return accurate scale value.

Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/magnetometer/ak8975.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 7105f22..9edf4c9 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -85,6 +85,7 @@
 #define AK8975_MAX_CONVERSION_TIMEOUT	500
 #define AK8975_CONVERSION_DONE_POLL_TIME 10
 #define AK8975_DATA_READY_TIMEOUT	((100*HZ)/1000)
+#define RAW_TO_GAUSS(asa) ((((asa) + 128) * 3000) / 256)
 
 /*
  * Per-instance context data for the device.
@@ -265,15 +266,15 @@ static int ak8975_setup(struct i2c_client *client)
  *
  * Since 1uT = 100 gauss, our final scale factor becomes:
  *
- * Hadj = H * ((ASA + 128) / 256) * 3/10 * 100
- * Hadj = H * ((ASA + 128) * 30 / 256
+ * Hadj = H * ((ASA + 128) / 256) * 3/10 * 1/100
+ * Hadj = H * ((ASA + 128) * 0.003) / 256
  *
  * Since ASA doesn't change, we cache the resultant scale factor into the
  * device context in ak8975_setup().
  */
-	data->raw_to_gauss[0] = ((data->asa[0] + 128) * 30) >> 8;
-	data->raw_to_gauss[1] = ((data->asa[1] + 128) * 30) >> 8;
-	data->raw_to_gauss[2] = ((data->asa[2] + 128) * 30) >> 8;
+	data->raw_to_gauss[0] = RAW_TO_GAUSS(data->asa[0]);
+	data->raw_to_gauss[1] = RAW_TO_GAUSS(data->asa[1]);
+	data->raw_to_gauss[2] = RAW_TO_GAUSS(data->asa[2]);
 
 	return 0;
 }
@@ -428,8 +429,9 @@ static int ak8975_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_RAW:
 		return ak8975_read_axis(indio_dev, chan->address, val);
 	case IIO_CHAN_INFO_SCALE:
-		*val = data->raw_to_gauss[chan->address];
-		return IIO_VAL_INT;
+		*val = 0;
+		*val2 = data->raw_to_gauss[chan->address];
+		return IIO_VAL_INT_PLUS_MICRO;
 	}
 	return -EINVAL;
 }
-- 
1.9.0

