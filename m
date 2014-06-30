Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbaF3Mbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127AbaF3Mbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 071/181] iio: Fix endianness issue in ak8975_read_axis()
Date: Mon, 30 Jun 2014 13:51:32 +0200
Message-Id: <19e0dc1edc5e235b298d793a5fd136d154f354c8.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <pmeerw@pmeerw.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8ba42fb7b17649c9ab5b5e79d4e90370a0b4645e upstream.

i2c_smbus_read_word_data() does host endian conversion already,
no need for le16_to_cpu()

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

