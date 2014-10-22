Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaJVP3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:29:38 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47390 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbaJVP3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:29:35 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2] iio: inkern: Add of_xlate function to struct iio_info
Date: Wed, 22 Oct 2014 18:29:43 +0300
Message-Id: <1413991783-24562-1-git-send-email-iivanov@mm-sol.com>
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

Changes:
- Move of_xlate function from iio_dev to iio_info structure,
  where all the other callbacks are. 

 drivers/iio/inkern.c    | 33 ++++++++++++++++++++++++++++-----
 include/linux/iio/iio.h |  8 ++++++++
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index f084610..866fe90 100644
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
@@ -122,18 +144,19 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 
 	indio_dev = dev_to_iio_dev(idev);
 	channel->indio_dev = indio_dev;
-	index = iiospec.args_count ? iiospec.args[0] : 0;
-	if (index >= indio_dev->num_channels) {
-		err = -EINVAL;
+	if (indio_dev->info->of_xlate)
+		index = indio_dev->info->of_xlate(indio_dev, &iiospec);
+	else
+		index = __of_iio_simple_xlate(indio_dev, &iiospec);
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
index 15dc6bc..3642ce7 100644
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
@@ -326,6 +327,11 @@ struct iio_dev;
  * @update_scan_mode:	function to configure device and scan buffer when
  *			channels have changed
  * @debugfs_reg_access:	function to read or write register value of device
+ * @of_xlate:		function pointer to obtain channel specifier index.
+ *			When #iio-cells is greater than '0', the driver could
+ *			provide a custom of_xlate function that reads the
+ *			*args* and returns the appropriate index in registered
+ *			IIO channels array.
  **/
 struct iio_info {
 	struct module			*driver_module;
@@ -385,6 +391,8 @@ struct iio_info {
 	int (*debugfs_reg_access)(struct iio_dev *indio_dev,
 				  unsigned reg, unsigned writeval,
 				  unsigned *readval);
+	int (*of_xlate)(struct iio_dev *indio_dev,
+			const struct of_phandle_args *iiospec);
 };
 
 /**
-- 
1.9.1

