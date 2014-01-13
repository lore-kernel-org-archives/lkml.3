Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaAMRY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:24:57 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60797 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbaAMRYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:24:55 -0500
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: jic23@kernel.org
Cc: pmeerw@pmeerw.net, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH] iio: tsl2563: Use the correct channel2 member
Date: Mon, 13 Jan 2014 19:24:19 +0200
Message-Id: <1389633859-5972-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
In-Reply-To: <52D30BF7.90107@kernel.org>
References: <52D30BF7.90107@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivaylo Dimitrov <freemangordon@abv.bg>

Use the correct channel2 member instead of channel when dealing with sysfs
reads/writes

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/iio/light/tsl2563.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
index 5e5d9de..2be6df3 100644
--- a/drivers/iio/light/tsl2563.c
+++ b/drivers/iio/light/tsl2563.c
@@ -460,10 +460,14 @@ static int tsl2563_write_raw(struct iio_dev *indio_dev,
 {
 	struct tsl2563_chip *chip = iio_priv(indio_dev);
 
-	if (chan->channel == IIO_MOD_LIGHT_BOTH)
+	if (mask != IIO_CHAN_INFO_CALIBSCALE)
+		return -EINVAL;
+	if (chan->channel2 == IIO_MOD_LIGHT_BOTH)
 		chip->calib0 = calib_from_sysfs(val);
-	else
+	else if (chan->channel2 == IIO_MOD_LIGHT_IR)
 		chip->calib1 = calib_from_sysfs(val);
+	else
+		return -EINVAL;
 
 	return 0;
 }
@@ -472,14 +476,14 @@ static int tsl2563_read_raw(struct iio_dev *indio_dev,
 			    struct iio_chan_spec const *chan,
 			    int *val,
 			    int *val2,
-			    long m)
+			    long mask)
 {
 	int ret = -EINVAL;
 	u32 calib0, calib1;
 	struct tsl2563_chip *chip = iio_priv(indio_dev);
 
 	mutex_lock(&chip->lock);
-	switch (m) {
+	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 	case IIO_CHAN_INFO_PROCESSED:
 		switch (chan->type) {
@@ -498,7 +502,7 @@ static int tsl2563_read_raw(struct iio_dev *indio_dev,
 			ret = tsl2563_get_adc(chip);
 			if (ret)
 				goto error_ret;
-			if (chan->channel == 0)
+			if (chan->channel2 == IIO_MOD_LIGHT_BOTH)
 				*val = chip->data0;
 			else
 				*val = chip->data1;
@@ -510,7 +514,7 @@ static int tsl2563_read_raw(struct iio_dev *indio_dev,
 		break;
 
 	case IIO_CHAN_INFO_CALIBSCALE:
-		if (chan->channel == 0)
+		if (chan->channel2 == IIO_MOD_LIGHT_BOTH)
 			*val = calib_to_sysfs(chip->calib0);
 		else
 			*val = calib_to_sysfs(chip->calib1);
-- 
1.5.6.1

