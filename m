Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbbAIPic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:38:32 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:57149 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894AbbAIPib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:38:31 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iio: Simplify IIO provider access locking mechanism
Date: Fri,  9 Jan 2015 17:38:13 +0200
Message-Id: <1420817893-5858-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of checking whether provider module is still
loaded on every access to device just lock module to
memory when client get reference to provider device.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/iio/industrialio-buffer.c | 18 +-------
 drivers/iio/industrialio-core.c   | 10 -----
 drivers/iio/industrialio-event.c  | 11 +----
 drivers/iio/inkern.c              | 93 +++++----------------------------------
 include/linux/iio/iio.h           | 15 +++++--
 5 files changed, 23 insertions(+), 124 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 403b728..34e6c3d 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -55,9 +55,6 @@ ssize_t iio_buffer_read_first_n_outer(struct file *filp, char __user *buf,
 	struct iio_buffer *rb = indio_dev->buffer;
 	int ret;

-	if (!indio_dev->info)
-		return -ENODEV;
-
 	if (!rb || !rb->access->read_first_n)
 		return -EINVAL;

@@ -67,12 +64,9 @@ ssize_t iio_buffer_read_first_n_outer(struct file *filp, char __user *buf,
 				return -EAGAIN;

 			ret = wait_event_interruptible(rb->pollq,
-					iio_buffer_data_available(rb) ||
-					indio_dev->info == NULL);
+					iio_buffer_data_available(rb));
 			if (ret)
 				return ret;
-			if (indio_dev->info == NULL)
-				return -ENODEV;
 		}

 		ret = rb->access->read_first_n(rb, n, buf);
@@ -92,9 +86,6 @@ unsigned int iio_buffer_poll(struct file *filp,
 	struct iio_dev *indio_dev = filp->private_data;
 	struct iio_buffer *rb = indio_dev->buffer;

-	if (!indio_dev->info)
-		return -ENODEV;
-
 	poll_wait(filp, &rb->pollq, wait);
 	if (iio_buffer_data_available(rb))
 		return POLLIN | POLLRDNORM;
@@ -685,7 +676,6 @@ int iio_update_buffers(struct iio_dev *indio_dev,
 	if (insert_buffer == remove_buffer)
 		return 0;

-	mutex_lock(&indio_dev->info_exist_lock);
 	mutex_lock(&indio_dev->mlock);

 	if (insert_buffer && iio_buffer_is_active(insert_buffer))
@@ -699,16 +689,10 @@ int iio_update_buffers(struct iio_dev *indio_dev,
 		goto out_unlock;
 	}

-	if (indio_dev->info == NULL) {
-		ret = -ENODEV;
-		goto out_unlock;
-	}
-
 	ret = __iio_update_buffers(indio_dev, insert_buffer, remove_buffer);

 out_unlock:
 	mutex_unlock(&indio_dev->mlock);
-	mutex_unlock(&indio_dev->info_exist_lock);

 	return ret;
 }
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 69feb91..b4105be 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -976,7 +976,6 @@ struct iio_dev *iio_device_alloc(int sizeof_priv)
 		device_initialize(&dev->dev);
 		dev_set_drvdata(&dev->dev, (void *)dev);
 		mutex_init(&dev->mlock);
-		mutex_init(&dev->info_exist_lock);
 		INIT_LIST_HEAD(&dev->channel_attr_list);

 		dev->id = ida_simple_get(&iio_ida, 0, 0, GFP_KERNEL);
@@ -1111,9 +1110,6 @@ static long iio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int __user *ip = (int __user *)arg;
 	int fd;

-	if (!indio_dev->info)
-		return -ENODEV;
-
 	if (cmd == IIO_GET_EVENT_FD_IOCTL) {
 		fd = iio_event_getfd(indio_dev);
 		if (copy_to_user(ip, &fd, sizeof(fd)))
@@ -1243,8 +1239,6 @@ EXPORT_SYMBOL(iio_device_register);
  **/
 void iio_device_unregister(struct iio_dev *indio_dev)
 {
-	mutex_lock(&indio_dev->info_exist_lock);
-
 	device_del(&indio_dev->dev);

 	if (indio_dev->chrdev.dev)
@@ -1253,13 +1247,9 @@ void iio_device_unregister(struct iio_dev *indio_dev)

 	iio_disable_all_buffers(indio_dev);

-	indio_dev->info = NULL;
-
 	iio_device_wakeup_eventset(indio_dev);
 	iio_buffer_wakeup_poll(indio_dev);

-	mutex_unlock(&indio_dev->info_exist_lock);
-
 	iio_buffer_free_sysfs_and_mask(indio_dev);
 }
 EXPORT_SYMBOL(iio_device_unregister);
diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index 3f5cee0..f20868e 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -83,9 +83,6 @@ static unsigned int iio_event_poll(struct file *filep,
 	struct iio_event_interface *ev_int = indio_dev->event_interface;
 	unsigned int events = 0;

-	if (!indio_dev->info)
-		return -ENODEV;
-
 	poll_wait(filep, &ev_int->wait, wait);

 	if (!kfifo_is_empty(&ev_int->det_events))
@@ -104,9 +101,6 @@ static ssize_t iio_event_chrdev_read(struct file *filep,
 	unsigned int copied;
 	int ret;

-	if (!indio_dev->info)
-		return -ENODEV;
-
 	if (count < sizeof(struct iio_event_data))
 		return -EINVAL;

@@ -116,12 +110,9 @@ static ssize_t iio_event_chrdev_read(struct file *filep,
 				return -EAGAIN;

 			ret = wait_event_interruptible(ev_int->wait,
-					!kfifo_is_empty(&ev_int->det_events) ||
-					indio_dev->info == NULL);
+					!kfifo_is_empty(&ev_int->det_events));
 			if (ret)
 				return ret;
-			if (indio_dev->info == NULL)
-				return -ENODEV;
 		}

 		if (mutex_lock_interruptible(&ev_int->read_lock))
diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 2800b80..0c077b7 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -146,6 +146,9 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 		return -EPROBE_DEFER;

 	indio_dev = dev_to_iio_dev(idev);
+	iio_device_get(indio_dev);
+	/* and put the reference of the find */
+	put_device(idev);
 	channel->indio_dev = indio_dev;
 	if (indio_dev->info->of_xlate)
 		index = indio_dev->info->of_xlate(indio_dev, &iiospec);
@@ -467,41 +470,17 @@ static int iio_channel_read(struct iio_channel *chan, int *val, int *val2,

 int iio_read_channel_raw(struct iio_channel *chan, int *val)
 {
-	int ret;
-
-	mutex_lock(&chan->indio_dev->info_exist_lock);
-	if (chan->indio_dev->info == NULL) {
-		ret = -ENODEV;
-		goto err_unlock;
-	}
-
-	ret = iio_channel_read(chan, val, NULL, IIO_CHAN_INFO_RAW);
-err_unlock:
-	mutex_unlock(&chan->indio_dev->info_exist_lock);
-
-	return ret;
+	return iio_channel_read(chan, val, NULL, IIO_CHAN_INFO_RAW);
 }
 EXPORT_SYMBOL_GPL(iio_read_channel_raw);

 int iio_read_channel_average_raw(struct iio_channel *chan, int *val)
 {
-	int ret;
-
-	mutex_lock(&chan->indio_dev->info_exist_lock);
-	if (chan->indio_dev->info == NULL) {
-		ret = -ENODEV;
-		goto err_unlock;
-	}
-
-	ret = iio_channel_read(chan, val, NULL, IIO_CHAN_INFO_AVERAGE_RAW);
-err_unlock:
-	mutex_unlock(&chan->indio_dev->info_exist_lock);
-
-	return ret;
+	return iio_channel_read(chan, val, NULL, IIO_CHAN_INFO_AVERAGE_RAW);
 }
 EXPORT_SYMBOL_GPL(iio_read_channel_average_raw);

-static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
+int iio_convert_raw_to_processed(struct iio_channel *chan,
 	int raw, int *processed, unsigned int scale)
 {
 	int scale_type, scale_val, scale_val2, offset;
@@ -550,88 +529,36 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,

 	return 0;
 }
-
-int iio_convert_raw_to_processed(struct iio_channel *chan, int raw,
-	int *processed, unsigned int scale)
-{
-	int ret;
-
-	mutex_lock(&chan->indio_dev->info_exist_lock);
-	if (chan->indio_dev->info == NULL) {
-		ret = -ENODEV;
-		goto err_unlock;
-	}
-
-	ret = iio_convert_raw_to_processed_unlocked(chan, raw, processed,
-							scale);
-err_unlock:
-	mutex_unlock(&chan->indio_dev->info_exist_lock);
-
-	return ret;
-}
 EXPORT_SYMBOL_GPL(iio_convert_raw_to_processed);

 int iio_read_channel_processed(struct iio_channel *chan, int *val)
 {
 	int ret;

-	mutex_lock(&chan->indio_dev->info_exist_lock);
-	if (chan->indio_dev->info == NULL) {
-		ret = -ENODEV;
-		goto err_unlock;
-	}
-
 	if (iio_channel_has_info(chan->channel, IIO_CHAN_INFO_PROCESSED)) {
 		ret = iio_channel_read(chan, val, NULL,
 				       IIO_CHAN_INFO_PROCESSED);
 	} else {
 		ret = iio_channel_read(chan, val, NULL, IIO_CHAN_INFO_RAW);
-		if (ret < 0)
-			goto err_unlock;
-		ret = iio_convert_raw_to_processed_unlocked(chan, *val, val, 1);
+		if (ret >= 0)
+			ret = iio_convert_raw_to_processed(chan, *val, val, 1);
 	}

-err_unlock:
-	mutex_unlock(&chan->indio_dev->info_exist_lock);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iio_read_channel_processed);

 int iio_read_channel_scale(struct iio_channel *chan, int *val, int *val2)
 {
-	int ret;
-
-	mutex_lock(&chan->indio_dev->info_exist_lock);
-	if (chan->indio_dev->info == NULL) {
-		ret = -ENODEV;
-		goto err_unlock;
-	}
-
-	ret = iio_channel_read(chan, val, val2, IIO_CHAN_INFO_SCALE);
-err_unlock:
-	mutex_unlock(&chan->indio_dev->info_exist_lock);
-
-	return ret;
+	return iio_channel_read(chan, val, val2, IIO_CHAN_INFO_SCALE);
 }
 EXPORT_SYMBOL_GPL(iio_read_channel_scale);

 int iio_get_channel_type(struct iio_channel *chan, enum iio_chan_type *type)
 {
-	int ret = 0;
-	/* Need to verify underlying driver has not gone away */
-
-	mutex_lock(&chan->indio_dev->info_exist_lock);
-	if (chan->indio_dev->info == NULL) {
-		ret = -ENODEV;
-		goto err_unlock;
-	}
-
 	*type = chan->channel->type;
-err_unlock:
-	mutex_unlock(&chan->indio_dev->info_exist_lock);

-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iio_get_channel_type);

diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 878d861..ab410c5 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/iio/types.h>
+#include <linux/module.h>
 #include <linux/of.h>
 /* IIO TODO LIST */
 /*
@@ -444,7 +445,6 @@ struct iio_buffer_setup_ops {
  * @chan_attr_group:	[INTERN] group for all attrs in base directory
  * @name:		[DRIVER] name of the device.
  * @info:		[DRIVER] callbacks and constant info from driver
- * @info_exist_lock:	[INTERN] lock to prevent use during removal
  * @setup_ops:		[DRIVER] callbacks to call before and after buffer
  *			enable/disable
  * @chrdev:		[INTERN] associated character device
@@ -483,7 +483,6 @@ struct iio_dev {
 	struct attribute_group		chan_attr_group;
 	const char			*name;
 	const struct iio_info		*info;
-	struct mutex			info_exist_lock;
 	const struct iio_buffer_setup_ops	*setup_ops;
 	struct cdev			chrdev;
 #define IIO_MAX_GROUPS 6
@@ -513,8 +512,10 @@ extern struct bus_type iio_bus_type;
  **/
 static inline void iio_device_put(struct iio_dev *indio_dev)
 {
-	if (indio_dev)
+	if (indio_dev) {
 		put_device(&indio_dev->dev);
+		module_put(indio_dev->info->driver_module);
+	}
 }

 /**
@@ -536,7 +537,13 @@ static inline struct iio_dev *dev_to_iio_dev(struct device *dev)
  **/
 static inline struct iio_dev *iio_device_get(struct iio_dev *indio_dev)
 {
-	return indio_dev ? dev_to_iio_dev(get_device(&indio_dev->dev)) : NULL;
+	if (!indio_dev)
+		return NULL;
+
+	if (!try_module_get(indio_dev->info->driver_module))
+		return ERR_PTR(-ENODEV);
+
+	return dev_to_iio_dev(get_device(&indio_dev->dev));
 }


--
1.9.1

