Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaJBMcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:32:09 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47242 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbaJBMcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:32:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>, linux-iio@vger.kernel.org,
        svarbanov@mm-sol.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] iio: inkern: Add of_xlate function to struct iio_dev
Date: Thu,  2 Oct 2014 15:32:08 +0300
Message-Id: <1412253128-32165-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When #iio-cells is greater than '0', the driver could provide
a custom of_xlate function that reads the *args* and returns
the appropriate index in registered IIO channels array.

Add simple translation function, suitable for the most 1:1
mapped channels in IIO chips, and use it when driver did not
provide custom implementation.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/iio/inkern.c    | 32 +++++++++++++++++++++++++++-----
 include/linux/iio/iio.h |  8 ++++++++
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index f084610..6c3e478 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -100,6 +100,28 @@ static int iio_dev_node_match(struct device *dev, void *data)
 	return dev->of_node == data && dev->type == &iio_device_type;
 }
 
+/**
+ * __of_iio_simple_xlate - translate iiospec to the IIO channel index
+ * @indio_dev:	pointer to the iio_dev structure
+ * @iiospec:	IIO specifier as found in the device tree
+ *
+ * This is simple translation function, suitable for the most 1:1 mapped
+ * channels in IIO chips. This function performs only one sanity check:
+ * whether IIO index is less than num_channels (that is specified in the
+ * iio_dev).
+ */
+static int __of_iio_simple_xlate(struct iio_dev *indio_dev,
+				const struct of_phandle_args *iiospec)
+{
+	if (!iiospec->args_count)
+		return 0;
+
+	if (iiospec->args[0] >= indio_dev->num_channels)
+		return -EINVAL;
+
+	return iiospec->args[0];
+}
+
 static int __of_iio_channel_get(struct iio_channel *channel,
 				struct device_node *np, int index)
 {
@@ -122,18 +144,18 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 
 	indio_dev = dev_to_iio_dev(idev);
 	channel->indio_dev = indio_dev;
-	index = iiospec.args_count ? iiospec.args[0] : 0;
-	if (index >= indio_dev->num_channels) {
-		err = -EINVAL;
+	if (!indio_dev->of_xlate)
+		indio_dev->of_xlate = __of_iio_simple_xlate;
+	index = indio_dev->of_xlate(indio_dev, &iiospec);
+	if (index < 0)
 		goto err_put;
-	}
 	channel->channel = &indio_dev->channels[index];
 
 	return 0;
 
 err_put:
 	iio_device_put(indio_dev);
-	return err;
+	return index;
 }
 
 static struct iio_channel *of_iio_channel_get(struct device_node *np, int index)
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 15dc6bc..d5bb219 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/iio/types.h>
+#include <linux/of.h>
 /* IIO TODO LIST */
 /*
  * Provide means of adjusting timer accuracy.
@@ -413,6 +414,11 @@ struct iio_buffer_setup_ops {
  * @currentmode:	[DRIVER] current operating mode
  * @dev:		[DRIVER] device structure, should be assigned a parent
  *			and owner
+ * @of_xlate:		[DRIVER] function pointer to obtain channel specifier
+ *			index. When #iio-cells is greater than '0', the driver
+ *			could provide a custom of_xlate function that reads
+ *			the *args* and returns the appropriate index in
+ *			registered IIO channels array.
  * @event_interface:	[INTERN] event chrdevs associated with interrupt lines
  * @buffer:		[DRIVER] any buffer present
  * @buffer_list:	[INTERN] list of all buffers currently attached
@@ -451,6 +457,8 @@ struct iio_dev {
 	int				currentmode;
 	struct device			dev;
 
+	int (*of_xlate)(struct iio_dev *indio_dev,
+			const struct of_phandle_args *iiospec);
 	struct iio_event_interface	*event_interface;
 
 	struct iio_buffer		*buffer;
-- 
1.9.1

