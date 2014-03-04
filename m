Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbaCDWGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:06:50 -0500
Received: from ring0.de ([5.45.105.125]:38928 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbaCDWGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:06:47 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv2 9/9] iio: inkern: add iio_read_channel_average_raw
Date: Tue,  4 Mar 2014 23:05:51 +0100
Message-Id: <1393970751-18157-10-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393970751-18157-1-git-send-email-sre@debian.org>
References: <1393702365-26429-1-git-send-email-sre@debian.org>
 <1393970751-18157-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add iio_read_channel_average_raw to support reading
averaged raw values in consumer drivers.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/iio/inkern.c         | 18 ++++++++++++++++++
 include/linux/iio/consumer.h | 13 +++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 0cf5f8e..adeba5a 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -443,6 +443,24 @@ err_unlock:
 }
 EXPORT_SYMBOL_GPL(iio_read_channel_raw);
 
+int iio_read_channel_average_raw(struct iio_channel *chan, int *val)
+{
+	int ret;
+
+	mutex_lock(&chan->indio_dev->info_exist_lock);
+	if (chan->indio_dev->info == NULL) {
+		ret = -ENODEV;
+		goto err_unlock;
+	}
+
+	ret = iio_channel_read(chan, val, NULL, IIO_CHAN_INFO_AVERAGE_RAW);
+err_unlock:
+	mutex_unlock(&chan->indio_dev->info_exist_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iio_read_channel_average_raw);
+
 static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 	int raw, int *processed, unsigned int scale)
 {
diff --git a/include/linux/iio/consumer.h b/include/linux/iio/consumer.h
index 2752b1f..651f9a0 100644
--- a/include/linux/iio/consumer.h
+++ b/include/linux/iio/consumer.h
@@ -123,6 +123,19 @@ int iio_read_channel_raw(struct iio_channel *chan,
 			 int *val);
 
 /**
+ * iio_read_channel_average_raw() - read from a given channel
+ * @chan:		The channel being queried.
+ * @val:		Value read back.
+ *
+ * Note raw reads from iio channels are in adc counts and hence
+ * scale will need to be applied if standard units required.
+ *
+ * In opposit to the normal iio_read_channel_raw this function
+ * returns the average of multiple reads.
+ */
+int iio_read_channel_average_raw(struct iio_channel *chan, int *val);
+
+/**
  * iio_read_channel_processed() - read processed value from a given channel
  * @chan:		The channel being queried.
  * @val:		Value read back.
-- 
1.9.0

