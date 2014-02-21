Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaBUNKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:10:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47821 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbaBUNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Beomho Seo <beomho.seo@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 49/60] iio: ak8975: Fix calculation formula for convert micro tesla to gauss unit
Date: Fri, 21 Feb 2014 13:01:16 +0000
Message-Id: <1392987687-15367-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: ak8975 driver is in staging, adjusted file name ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/iio/magnetometer/ak8975.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index 5834e4a..575256b 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -82,6 +82,7 @@
  */
 #define AK8975_MAX_CONVERSION_TIMEOUT	500
 #define AK8975_CONVERSION_DONE_POLL_TIME 10
+#define RAW_TO_GAUSS(asa) ((((asa) + 128) * 3000) / 256)
 
 /*
  * Per-instance context data for the device.
@@ -223,15 +224,15 @@ static int ak8975_setup(struct i2c_client *client)
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
@@ -434,8 +435,9 @@ static int ak8975_read_raw(struct iio_dev *indio_dev,
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

