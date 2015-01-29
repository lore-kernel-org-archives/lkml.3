Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbbA2NQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:16:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:20358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbbA2NQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:16:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,486,1418112000"; 
   d="scan'208";a="644466631"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH] iio: gyro: bmg160: optimize i2c transfers in trigger handler
Date: Thu, 29 Jan 2015 15:15:52 +0200
Message-Id: <1422537352-1374-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some i2c busses (e.g.: Synopsys DesignWare I2C adapter) need to
enable/disable the bus at each i2c transfer and must wait for
the enable/disable to happen before sending the data.

When reading data in the trigger handler, the bmg160 driver does
one i2c transfer for each axis. This has an impact on the frequency
of the gyroscope at high sample rates due to additional delays
introduced by the i2c bus at each transfer.

Reading all axis values in one i2c transfer reduces the delays
introduced by the i2c bus.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/gyro/bmg160.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/gyro/bmg160.c b/drivers/iio/gyro/bmg160.c
index 60451b3..814eb20 100644
--- a/drivers/iio/gyro/bmg160.c
+++ b/drivers/iio/gyro/bmg160.c
@@ -115,6 +115,7 @@ enum bmg160_axis {
 	AXIS_X,
 	AXIS_Y,
 	AXIS_Z,
+	AXIS_MAX,
 };
 
 static const struct {
@@ -820,20 +821,21 @@ static irqreturn_t bmg160_trigger_handler(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmg160_data *data = iio_priv(indio_dev);
 	int bit, ret, i = 0;
+	s16 values[AXIS_MAX];
 
 	mutex_lock(&data->mutex);
-	for_each_set_bit(bit, indio_dev->buffer->scan_mask,
-			 indio_dev->masklength) {
-		ret = i2c_smbus_read_word_data(data->client,
-					       BMG160_AXIS_TO_REG(bit));
-		if (ret < 0) {
-			mutex_unlock(&data->mutex);
-			goto err;
-		}
-		data->buffer[i++] = ret;
+	ret = i2c_smbus_read_i2c_block_data(data->client, BMG160_REG_XOUT_L,
+					    sizeof(values), (u8 *) values);
+	if (ret < 0) {
+		mutex_unlock(&data->mutex);
+		goto err;
 	}
 	mutex_unlock(&data->mutex);
 
+	for_each_set_bit(bit, indio_dev->buffer->scan_mask,
+			 indio_dev->masklength)
+		data->buffer[i++] = values[bit];
+
 	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
 					   data->timestamp);
 err:
-- 
1.9.1

