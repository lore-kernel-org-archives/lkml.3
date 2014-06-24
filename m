Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaFXQDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:03:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965079AbaFXP4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.15 46/61] iio: Fix endianness issue in ak8975_read_axis()
Date: Tue, 24 Jun 2014 11:51:29 -0400
Message-Id: <20140624154954.882984018@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Meerwald <pmeerw@pmeerw.net>

commit 8ba42fb7b17649c9ab5b5e79d4e90370a0b4645e upstream.

i2c_smbus_read_word_data() does host endian conversion already,
no need for le16_to_cpu()

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/magnetometer/ak8975.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -352,8 +352,6 @@ static int ak8975_read_axis(struct iio_d
 {
 	struct ak8975_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
-	u16 meas_reg;
-	s16 raw;
 	int ret;
 
 	mutex_lock(&data->lock);
@@ -401,16 +399,11 @@ static int ak8975_read_axis(struct iio_d
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


