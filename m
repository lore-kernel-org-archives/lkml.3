Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaLDNBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:01:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:38653 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbaLDNAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:00:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="493541772"
From: Teodora Baluta <teodora.baluta@intel.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Teodora Baluta <teodora.baluta@intel.com>
Subject: [RFC PATCH 3/3] iio: fingerprint: add fingerprint sensor via USB
Date: Thu,  4 Dec 2014 15:00:17 +0200
Message-Id: <1417698017-13835-4-git-send-email-teodora.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IIO implementation for the USB Fingerprint TouchChip Coprocessor
from UPEK.

Although there is an existing implementation in userspace for USB
fingerprint devices, this driver represents a proof of concept of how
fingerprint sensors could be integrated in the IIO framework regardless
of the used bus. For lower power requirements, the SPI bus is preferred
and a kernel driver implementation makes more sense.

Add dependency on IIO_SYSFS_TRIGGER that provides support for using
SYSFS as IIO triggers. The purpose of the sysfs trigger is to tell the
device to wait for a finger to scan. After the fingerprint is scanned,
an image is produced by the device (as with any scanner type device).

Unlike other sensors, the output isn't a simple value that changes quite
frequently. It is a one-time or on demand sensor that outputs a larger
amount of data. The approach is to use the character device to present
the scanned image to userspace - which is already available in the IIO
framework.

The USB protocol was derived from libfprint's implementation of this
driver (see upektc_img in [0]), as well as some helper functions.

[0]
http://cgit.freedesktop.org/libfprint/libfprint/tree/libfprint/drivers

Signed-off-by: Teodora Baluta <teodora.baluta@intel.com>
---
 drivers/iio/Kconfig                 |   1 +
 drivers/iio/Makefile                |   1 +
 drivers/iio/fingerprint/Kconfig     |  15 +
 drivers/iio/fingerprint/Makefile    |   5 +
 drivers/iio/fingerprint/fp_tc.c     | 162 ++++++++++
 drivers/iio/fingerprint/fp_tc.h     |  22 ++
 drivers/iio/fingerprint/fp_tc_usb.c | 618 ++++++++++++++++++++++++++++++++++++
 drivers/iio/fingerprint/fp_tc_usb.h | 144 +++++++++
 8 files changed, 968 insertions(+)
 create mode 100644 drivers/iio/fingerprint/Kconfig
 create mode 100644 drivers/iio/fingerprint/Makefile
 create mode 100644 drivers/iio/fingerprint/fp_tc.c
 create mode 100644 drivers/iio/fingerprint/fp_tc.h
 create mode 100644 drivers/iio/fingerprint/fp_tc_usb.c
 create mode 100644 drivers/iio/fingerprint/fp_tc_usb.h

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 345395e..33ce755 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -77,5 +77,6 @@ endif #IIO_TRIGGER
 source "drivers/iio/pressure/Kconfig"
 source "drivers/iio/proximity/Kconfig"
 source "drivers/iio/temperature/Kconfig"
+source "drivers/iio/fingerprint/Kconfig"
 
 endif # IIO
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index 698afc2..0db9c1f 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -27,3 +27,4 @@ obj-y += pressure/
 obj-y += proximity/
 obj-y += temperature/
 obj-y += trigger/
+obj-y += fingerprint/
diff --git a/drivers/iio/fingerprint/Kconfig b/drivers/iio/fingerprint/Kconfig
new file mode 100644
index 0000000..77e7fc6
--- /dev/null
+++ b/drivers/iio/fingerprint/Kconfig
@@ -0,0 +1,15 @@
+#
+# fingerprint USB sensors
+#
+
+menu "Fingerprint sensors"
+
+config FP_TC
+	tristate "Upek TouchChip Fingerprint Coprocessor USB"
+	select IIO_SYSFS_TRIGGER
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
+	help
+		A swipe-type sensor over USB that includes a biometric coprocessor.
+
+endmenu
diff --git a/drivers/iio/fingerprint/Makefile b/drivers/iio/fingerprint/Makefile
new file mode 100644
index 0000000..7b13302
--- /dev/null
+++ b/drivers/iio/fingerprint/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for IIO fingerprint sensors
+#
+
+obj-$(CONFIG_FP_TC)		+= fp_tc.o fp_tc_usb.o
diff --git a/drivers/iio/fingerprint/fp_tc.c b/drivers/iio/fingerprint/fp_tc.c
new file mode 100644
index 0000000..4496ce9
--- /dev/null
+++ b/drivers/iio/fingerprint/fp_tc.c
@@ -0,0 +1,162 @@
+/*
+ * UPEK TouchChip USB Fingerprint sensor driver
+ * Copyright (c) 2014, Intel Corporation.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/irq.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+#include <linux/iio/buffer.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/trigger_consumer.h>
+#include <linux/iio/triggered_buffer.h>
+#include <linux/crc-itu-t.h>
+#include "fp_tc.h"
+
+/*
+ * If the device had a biometric coprocessor (see UPEK TouchStrip)
+ * the channel has IIO_CHAN_INFO_PROCESSED enabled
+ */
+static const struct iio_chan_spec fp_tc_channels[] = {
+	{
+		.type = IIO_FINGERPRINT,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_SCAN_HEIGHT) |
+			BIT(IIO_CHAN_INFO_SCAN_WIDTH) |
+			BIT(IIO_CHAN_INFO_SCAN_BIT_DEPTH) |
+			BIT(IIO_CHAN_INFO_SCAN_ORIENTATION) |
+			BIT(IIO_CHAN_INFO_SCAN_COLOR_SCHEME),
+		.scan_index = 1,
+		.scan_type = {
+			.sign = 'u',
+			.realbits = FP_TC_SCAN_HEIGHT * FP_TC_SCAN_WIDTH *
+				FP_TC_SCAN_BIT_DEPTH,
+			.storagebits = FP_TC_SCAN_HEIGHT * FP_TC_SCAN_WIDTH *
+				FP_TC_SCAN_BIT_DEPTH,
+		},
+	},
+	{
+		.type = IIO_FINGERPRINT,
+		.modified = 1,
+		.scan_index = 0,
+		.channel2 = IIO_MOD_STATUS,
+		.scan_type = {
+			.sign = 'u',
+			.realbits = 8,
+			.storagebits = 8,
+		},
+	},
+	IIO_CHAN_SOFT_TIMESTAMP(2),
+};
+
+static int fp_tc_read_raw(struct iio_dev *indio_dev,
+			  const struct iio_chan_spec *chan,
+			  int *val, int *val2, long mask)
+{
+	*val2 = 0;
+	switch (chan->type) {
+	case IIO_FINGERPRINT:
+		switch (mask) {
+		case IIO_CHAN_INFO_SCAN_HEIGHT:
+			*val = FP_TC_SCAN_HEIGHT;
+			return IIO_VAL_INT;
+		case IIO_CHAN_INFO_SCAN_WIDTH:
+			*val = FP_TC_SCAN_WIDTH;
+			return IIO_VAL_INT;
+		case IIO_CHAN_INFO_SCAN_BIT_DEPTH:
+			*val = FP_TC_SCAN_BIT_DEPTH;
+			return IIO_VAL_INT;
+		case IIO_CHAN_INFO_SCAN_ORIENTATION:
+			*val = FP_TC_SCAN_ORIENTATION;
+			return IIO_VAL_INT;
+		case IIO_CHAN_INFO_SCAN_COLOR_SCHEME:
+			*val = FP_TC_SCAN_COLOR_SCHEME;
+			return IIO_VAL_INT;
+		default:
+			return -EINVAL;
+		}
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct iio_info fp_tc_info = {
+	.read_raw		= &fp_tc_read_raw,
+	.driver_module		= THIS_MODULE,
+};
+
+static irqreturn_t fp_tc_buffer_handler(int irq, void *p)
+{
+	struct iio_poll_func *pf = p;
+	struct iio_dev *indio_dev = pf->indio_dev;
+	struct fp_tc_data *data;
+	u8 *image;
+	int retval;
+
+	image = kzalloc(FP_TC_SCAN_HEIGHT * FP_TC_SCAN_WIDTH + 1, GFP_KERNEL);
+	if (!image)
+		return -ENOMEM;
+
+	data = iio_priv(indio_dev);
+
+	retval = data->fp_tc_get_data(indio_dev, image + 1);
+	memcpy(image, &data->scan_result, 1);
+
+	iio_push_to_buffers_with_timestamp(indio_dev, image,
+					   iio_get_time_ns());
+
+	iio_trigger_notify_done(indio_dev->trig);
+
+	kfree(image);
+
+	if (retval < 0)
+		return retval;
+	return IRQ_HANDLED;
+}
+
+int fp_tc_init_iio(struct iio_dev *indio_dev)
+{
+	int ret;
+
+	indio_dev->channels = fp_tc_channels;
+	indio_dev->num_channels = ARRAY_SIZE(fp_tc_channels);
+	indio_dev->info = &fp_tc_info;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+
+	/* no interrupts for this trigger */
+	ret = iio_triggered_buffer_setup(indio_dev,
+					 NULL,
+					 &fp_tc_buffer_handler,
+					 NULL);
+	if (ret < 0) {
+		dev_err(&indio_dev->dev, "Unable to setup triggered buffer\n");
+		return ret;
+	}
+
+	ret = iio_device_register(indio_dev);
+	if (ret < 0) {
+		dev_err(&indio_dev->dev, "Unable to register iio device\n");
+		iio_triggered_buffer_cleanup(indio_dev);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(fp_tc_init_iio);
+
+void fp_tc_remove_iio(struct iio_dev *indio_dev)
+{
+	iio_device_unregister(indio_dev);
+}
+EXPORT_SYMBOL(fp_tc_remove_iio);
diff --git a/drivers/iio/fingerprint/fp_tc.h b/drivers/iio/fingerprint/fp_tc.h
new file mode 100644
index 0000000..ba4901d
--- /dev/null
+++ b/drivers/iio/fingerprint/fp_tc.h
@@ -0,0 +1,22 @@
+#ifndef FP_TC_H
+#define FP_TC_H
+
+#define FP_TC_SCAN_HEIGHT	384
+#define FP_TC_SCAN_WIDTH	144
+#define FP_TC_SCAN_BIT_DEPTH	8
+/* horizontal orientation */
+#define FP_TC_SCAN_ORIENTATION	0
+/* color scheme is black on white */
+#define FP_TC_SCAN_COLOR_SCHEME	0
+
+struct usb_fp_tc;
+
+struct fp_tc_data {
+	struct usb_fp_tc *uft;
+	u8 scan_result;
+	int (*fp_tc_get_data)(struct iio_dev *indio_dev, u8 *data);
+};
+int fp_tc_init_iio(struct iio_dev *indio_dev);
+void fp_tc_remove_iio(struct iio_dev *indio_dev);
+
+#endif
diff --git a/drivers/iio/fingerprint/fp_tc_usb.c b/drivers/iio/fingerprint/fp_tc_usb.c
new file mode 100644
index 0000000..9768807
--- /dev/null
+++ b/drivers/iio/fingerprint/fp_tc_usb.c
@@ -0,0 +1,618 @@
+/*
+ * UPEK TouchChip USB Fingerprint sensor driver
+ * Copyright (c) 2014, Intel Corporation.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/irq.h>
+#include <linux/usb.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+#include <linux/iio/buffer.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/trigger_consumer.h>
+#include <linux/iio/triggered_buffer.h>
+#include <linux/crc-itu-t.h>
+#include "fp_tc.h"
+#include "fp_tc_usb.h"
+
+static const struct usb_device_id fp_table_id[] = {
+	{USB_DEVICE(USB_FP_TC_VENDOR_ID, USB_FP_TC_PRODUCT_ID)},
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, fp_table_id);
+
+static struct usb_driver fp_tc_usb_driver;
+
+/***************************** HELPERS *****************************/
+
+static const uint16_t crc_table[256] = {
+	0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7,
+	0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef,
+	0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6,
+	0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de,
+	0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485,
+	0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d,
+	0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4,
+	0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc,
+	0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823,
+	0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b,
+	0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12,
+	0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a,
+	0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41,
+	0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49,
+	0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70,
+	0xff9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78,
+	0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f,
+	0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067,
+	0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e,
+	0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256,
+	0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d,
+	0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
+	0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c,
+	0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634,
+	0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab,
+	0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3,
+	0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a,
+	0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92,
+	0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9,
+	0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1,
+	0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8,
+	0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0
+};
+
+
+static void fp_tc_img_cmd_fix_seq(unsigned char *cmd_buf, unsigned char seq)
+{
+	uint8_t byte;
+
+	byte = cmd_buf[5];
+	byte &= 0x0f;
+	byte |= (seq << 4);
+	cmd_buf[5] = byte;
+}
+
+static uint16_t udf_crc(unsigned char *buffer, size_t size)
+{
+	uint16_t crc = 0;
+
+	while (size--)
+		crc = (uint16_t) ((crc << 8) ^
+				  crc_table[((crc >> 8) & 0x00ff) ^ *buffer++]);
+	return crc;
+}
+
+static void fp_tc_img_cmd_update_crc(unsigned char *cmd_buf, size_t size)
+{
+	/*
+	 * CRC does not cover Ciao prefix (4 bytes) and CRC location (2 bytes)
+	 */
+	uint16_t crc = udf_crc(cmd_buf + 4, size - 6);
+
+	cmd_buf[size - 2] = (crc & 0x00ff);
+	cmd_buf[size - 1] = (crc & 0xff00) >> 8;
+}
+
+static int fp_tc_img_process_image_frame(unsigned char *image_buf,
+					 unsigned char *cmd_res)
+{
+	int offset = 8;
+	int len = ((cmd_res[5] & 0x0f) << 8) | (cmd_res[6]);
+
+	len -= 1;
+	if (cmd_res[7] == 0x2c) {
+		len -= 10;
+		offset += 10;
+	}
+	if (cmd_res[7] == 0x20)
+		len -= 4;
+	memcpy(image_buf, cmd_res + offset, len);
+
+	return len;
+}
+
+/*****************************************************************************/
+
+
+static int fp_tc_send_out_bulk(struct usb_fp_tc *dev, unsigned char *cmd,
+			       int cmd_size)
+{
+	unsigned int pipe;
+	int retval = 0;
+	int actual_len;
+
+	fp_tc_img_cmd_fix_seq(cmd, dev->seq);
+	fp_tc_img_cmd_update_crc(cmd, cmd_size);
+	pipe = usb_sndbulkpipe(dev->udev, dev->bulk_out_endpoint_addr);
+
+	retval = usb_bulk_msg(dev->udev, pipe, cmd, cmd_size,
+			      &actual_len, FP_TC_USB_BULK_TIMEOUT);
+	if (retval < 0)
+		dev_err(&dev->intf->dev, "%s - failed submitting URB_BULK urb, error %d\n",
+			__func__, retval);
+
+	return retval;
+}
+
+static int fp_tc_read_short_resp(struct usb_fp_tc *dev)
+{
+	unsigned int pipe;
+	int retval = 0;
+	unsigned char *buffer;
+	int actual_len;
+
+	pipe = usb_rcvbulkpipe(dev->udev, dev->bulk_in_endpoint_addr);
+
+	buffer = kzalloc(FP_TC_SHORT_RESP_SIZE, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	retval = usb_bulk_msg(dev->udev, pipe, buffer, FP_TC_SHORT_RESP_SIZE,
+			      &actual_len,
+			      FP_TC_USB_BULK_TIMEOUT);
+	if (retval < 0)
+		dev_err(&dev->intf->dev, "%s - failed reading URB_BULK urb, error %d\n",
+			__func__, retval);
+
+	kfree(buffer);
+	return retval;
+}
+
+static int fp_tc_send_ctrl_bulk(struct usb_fp_tc *dev)
+{
+	int retval = 0;
+	unsigned char *buffer;
+
+	/* send control msg */
+	buffer = kzalloc(FP_TC_CTRL_SIZE, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	retval = usb_control_msg(dev->udev,
+				 usb_sndctrlpipe(dev->udev, 0),
+				 FP_TC_CTRL_REQUEST,
+				 FP_TC_CTRL_REQUEST_TYPE,
+				 FP_TC_CTRL_VALUE,
+				 FP_TC_CTRL_INDEX,
+				 buffer,
+				 FP_TC_CTRL_SIZE,
+				 USB_CTRL_SET_TIMEOUT);
+	if (retval < 0)
+		dev_err(&dev->intf->dev, "%s - could not sent control msg, error %d\n",
+			__func__, retval);
+
+	kfree(buffer);
+	return retval;
+}
+
+static int prev_state;
+static int next_state;
+
+static int fp_tc_usb_activate(struct usb_fp_tc *dev)
+{
+	int retval = 0;
+
+	while (next_state != FP_TC_DONE) {
+		if (next_state != FP_TC_READ_SHORT_RESP)
+			prev_state = next_state;
+
+		switch (next_state) {
+		case FP_TC_CTRL_1:
+		case FP_TC_CTRL_2:
+			retval = fp_tc_send_ctrl_bulk(dev);
+			next_state = FP_TC_READ_SHORT_RESP;
+			break;
+		case FP_TC_INIT_1:
+			retval = fp_tc_send_out_bulk(dev, fp_tc_usb_init_1,
+						     sizeof(fp_tc_usb_init_1));
+			next_state = FP_TC_READ_SHORT_RESP;
+			break;
+		case FP_TC_INIT_2:
+			retval = fp_tc_send_out_bulk(dev, fp_tc_usb_init_2,
+						     sizeof(fp_tc_usb_init_2));
+			next_state = FP_TC_READ_SHORT_RESP;
+			break;
+		case FP_TC_INIT_3:
+			retval = fp_tc_send_out_bulk(dev, fp_tc_usb_init_3,
+						     sizeof(fp_tc_usb_init_3));
+			next_state = FP_TC_READ_SHORT_RESP;
+			break;
+		case FP_TC_INIT_4:
+			retval = fp_tc_send_out_bulk(dev, fp_tc_usb_init_4,
+						     sizeof(fp_tc_usb_init_4));
+			next_state = FP_TC_READ_SHORT_RESP;
+			dev->seq++;
+			break;
+		case FP_TC_READ_SHORT_RESP:
+			retval = fp_tc_read_short_resp(dev);
+			if (prev_state == FP_TC_INIT_4)
+				next_state = FP_TC_DONE;
+			else
+				next_state = ++prev_state;
+			break;
+		default:
+			dev_err(&dev->intf->dev, "%s - invalid state in activation sequence\n",
+				__func__);
+			return -EINVAL;
+		}
+
+		if (retval < 0)
+			goto exit;
+	}
+
+exit:
+	return retval;
+}
+
+static int fp_tc_deactivate(struct usb_fp_tc *dev)
+{
+	int retval = 0;
+
+	retval = fp_tc_send_out_bulk(dev, fp_tc_usb_deinit,
+				     sizeof(fp_tc_usb_deinit));
+	if (retval < 0)
+		return retval;
+	dev->seq++;
+	return fp_tc_read_short_resp(dev);
+}
+
+static int fp_tc_usb_process_capture(unsigned char *data, struct usb_fp_tc *dev,
+				     unsigned char *image,
+				     unsigned int *image_size,
+				     unsigned int *received_img)
+{
+	int retval;
+	unsigned int temp_seq;
+
+	switch (data[4]) {
+	case  FP_TC_FRAME_1:
+		switch (data[7]) {
+		case FP_TC_NO_FINGER:
+			retval =
+				fp_tc_send_out_bulk(dev, fp_tc_usb_ack_28,
+						    sizeof(fp_tc_usb_ack_28));
+			dev->seq++;
+			break;
+		case FP_TC_IMG_INFO_FRAME:
+			/* should we process the image information? */
+		case FP_TC_IMG_FRAME:
+			*image_size +=
+				fp_tc_img_process_image_frame(image +
+							      *image_size,
+							      data);
+
+			retval =
+				fp_tc_send_out_bulk(dev, fp_tc_usb_ack,
+						    sizeof(fp_tc_usb_ack));
+			dev->seq++;
+			break;
+		case FP_TC_LAST_IMG_FRAME:
+			*image_size +=
+				fp_tc_img_process_image_frame(image +
+							      *image_size,
+							      data);
+			*received_img = 1;
+			fp_tc_deactivate(dev);
+			break;
+		default:
+			dev_warn(&dev->intf->dev, "Unknown response %d\n",
+				 data[7]);
+			break;
+		}
+		break;
+	case FP_TC_FRAME_2:
+		temp_seq = dev->seq;
+		dev->seq = 0;
+		retval = fp_tc_send_out_bulk(dev, fp_tc_usb_ack_08,
+					     sizeof(fp_tc_usb_ack_08));
+		dev->seq = temp_seq;
+		break;
+	default:
+		dev_warn(&dev->intf->dev, "Unknown response%d\n",
+			 data[4]);
+	}
+
+	return retval;
+}
+
+static int fp_tc_usb_capture(struct usb_fp_tc *dev, unsigned char *image)
+{
+	unsigned int pipe;
+	int retval;
+	unsigned int actual_len;
+	unsigned int response_size;
+	unsigned int received_img;
+	/* buffer to hold the image */
+	unsigned char *data;
+	/* image size */
+	unsigned int image_size;
+	/* useful to know if we have any more data to read */
+	unsigned int response_rest;
+
+	retval		= 0;
+	received_img	= 0;
+	response_rest	= 0;
+	image_size	= 0;
+
+	retval = fp_tc_send_out_bulk(dev, fp_tc_usb_init_capture,
+				     sizeof(fp_tc_usb_init_capture));
+	if (retval < 0)
+		return retval;
+	dev->seq++;
+
+	data = kzalloc(FP_TC_MAX_RESP_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	while (!received_img) {
+		/*
+		 * Read out the response to an init_capture or
+		 * after capturing a frame
+		 */
+		pipe = usb_rcvbulkpipe(dev->udev, dev->bulk_in_endpoint_addr);
+		if (!response_rest) {
+			retval = usb_bulk_msg(dev->udev, pipe, data,
+					      FP_TC_SHORT_RESP_SIZE,
+					      &actual_len,
+					      FP_TC_USB_BULK_TIMEOUT);
+		} else {
+			retval = usb_bulk_msg(dev->udev, pipe,
+					      data + FP_TC_SHORT_RESP_SIZE,
+					      FP_TC_MAX_RESP_SIZE -
+					      FP_TC_SHORT_RESP_SIZE,
+					      &actual_len,
+					      FP_TC_USB_BULK_TIMEOUT);
+		}
+
+		if (retval < 0) {
+			dev_err(&dev->intf->dev, "%s - failed reading URB_BULK urb, error %d\n",
+				__func__, retval);
+			goto exit;
+		}
+
+		if (actual_len == 0)
+			continue;
+
+		if (!response_rest) {
+			response_size = ((data[5] & 0x0f) << 8) + data[6];
+			response_size += 9;
+			if (response_size > actual_len) {
+				response_rest = response_size - actual_len;
+				continue;
+			}
+		}
+		response_rest = 0;
+
+		fp_tc_usb_process_capture(data, dev, image, &image_size,
+					  &received_img);
+		if (retval < 0)
+			goto exit;
+	}
+
+	return 0;
+
+exit:
+	kfree(data);
+	return retval;
+}
+
+static int fp_tc_usb_get_data(struct iio_dev *indio_dev, u8 *image)
+{
+	struct usb_fp_tc *dev;
+	struct fp_tc_data *data;
+	int retval;
+	int nr_retries = 0;
+
+	data = iio_priv(indio_dev);
+	dev = data->uft;
+
+	do {
+		next_state = FP_TC_CTRL_1;
+		prev_state = FP_TC_CTRL_1;
+		retval = fp_tc_usb_activate(dev);
+	} while (nr_retries < FP_TC_USB_RETRIES && retval < 0);
+	if (retval < 0)
+		goto exit;
+
+	nr_retries = 0;
+	do {
+		retval = fp_tc_usb_capture(dev, image);
+	} while (nr_retries < FP_TC_USB_RETRIES && retval < 0);
+	if (retval < 0)
+		goto exit;
+
+	data->scan_result = STATUS_FINGERPRINT_GOOD;
+	return 0;
+exit:
+	data->scan_result = STATUS_FINGERPRINT_FAIL;
+	return retval;
+}
+
+static void fp_tc_usb_delete(struct kref *kref)
+{
+	struct usb_fp_tc *dev;
+
+	dev = container_of(kref, struct usb_fp_tc, kref);
+
+	usb_put_dev(dev->udev);
+	/* free the device and any allocated buffers */
+	kfree(dev);
+}
+
+static int fp_tc_usb_release(struct inode *inode, struct file *file)
+{
+	struct usb_fp_tc *dev;
+
+	dev = file->private_data;
+	if (!dev)
+		return -ENODEV;
+
+	if (dev->intf)
+		usb_autopm_put_interface(dev->intf);
+
+	/* decrement usage count for the device */
+	kref_put(&dev->kref, fp_tc_usb_delete);
+
+	return 0;
+}
+
+static const struct file_operations fp_tc_usb_fops = {
+	.owner =	THIS_MODULE,
+	.release =	fp_tc_usb_release,
+};
+
+/*
+ * usb class driver in order to register and get minor from usb core
+ */
+static struct usb_class_driver fp_tc_usb_class = {
+	.name =		"fp_tc%d",
+	.fops =		&fp_tc_usb_fops,
+	.minor_base =	USB_FP_TC_MINOR_BASE,
+};
+
+static int fp_tc_usb_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	struct usb_fp_tc *dev;
+	struct fp_tc_data *data;
+	struct usb_host_interface *intf_desc;
+	struct usb_endpoint_descriptor *endpoint;
+	struct iio_dev *indio_dev;
+	struct usb_device *udev;
+	int retval = -ENOMEM;
+	int i;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return retval;
+
+	dev->seq = 0;
+	dev->intf = intf;
+	dev->udev = interface_to_usbdev(intf);
+
+	intf_desc = intf->cur_altsetting;
+	for (i = 0; i < intf_desc->desc.bNumEndpoints; ++i) {
+		endpoint = &intf_desc->endpoint[i].desc;
+
+		if (!dev->bulk_in_endpoint_addr &&
+		    usb_endpoint_is_bulk_in(endpoint)) {
+			/* we found a bulk in endpoint */
+			dev->bulk_in_endpoint_addr = endpoint->bEndpointAddress;
+		}
+
+		if (!dev->bulk_out_endpoint_addr &&
+		    usb_endpoint_is_bulk_out(endpoint)) {
+			/* we found a bulk out endpoint */
+			dev->bulk_out_endpoint_addr =
+				endpoint->bEndpointAddress;
+		}
+	}
+
+	if (!(dev->bulk_in_endpoint_addr && dev->bulk_out_endpoint_addr)) {
+		dev_err(&intf->dev,
+			"Could not find both bulk-in and bulk-out endpoints\n");
+		retval = -ENODEV;
+		goto error;
+	}
+
+	/* save our data pointer in this interface device */
+	usb_set_intfdata(intf, dev);
+
+	/* Register device now */
+	retval = usb_register_dev(intf, &fp_tc_usb_class);
+	if (retval) {
+		dev_err(&intf->dev, "Unable to get a minor for this device.\n");
+		usb_set_intfdata(intf, NULL);
+		goto error;
+	}
+
+	dev_info(&intf->dev, "USB Fingerprint driver attached to %d\n",
+		 intf->minor);
+
+	udev = dev->udev;
+	indio_dev = devm_iio_device_alloc(&udev->dev, sizeof(*data));
+	if (!indio_dev)
+		goto error;
+
+	data = iio_priv(indio_dev);
+	dev_set_drvdata(&udev->dev, indio_dev);
+	data->uft = dev;
+
+	indio_dev->dev.parent = &udev->dev;
+	indio_dev->name = fp_tc_usb_driver.name;
+
+	data->fp_tc_get_data = fp_tc_usb_get_data;
+	data->scan_result = STATUS_UNKNOWN;
+
+	retval = fp_tc_init_iio(indio_dev);
+	if (retval < 0)
+		goto error;
+
+	return 0;
+
+error:
+	if (dev)
+		kref_put(&dev->kref, fp_tc_usb_delete);
+	return retval;
+}
+
+
+static void fp_tc_usb_disconnect(struct usb_interface *intf)
+{
+	struct usb_fp_tc *dev;
+	struct iio_dev *indio_dev;
+
+	dev = usb_get_intfdata(intf);
+	usb_set_intfdata(intf, NULL);
+
+	/* give back our minor */
+	usb_deregister_dev(intf, &fp_tc_usb_class);
+
+	/* decrement our usage count */
+	kref_put(&dev->kref, fp_tc_usb_delete);
+
+	dev_info(&intf->dev, "USB Fingerprint TouchChip #%d now disconnected",
+		 intf->minor);
+
+	indio_dev = dev_get_drvdata(&intf->dev);
+	if (!indio_dev)
+		dev_err(&intf->dev, "Could not get drvdata\n");
+		return;
+
+	fp_tc_remove_iio(indio_dev);
+}
+
+static struct usb_driver fp_tc_usb_driver = {
+	.name =		"fingerprint_tc",
+	.probe =	fp_tc_usb_probe,
+	.disconnect =	fp_tc_usb_disconnect,
+	.id_table =	fp_table_id,
+};
+
+static __init int fp_tc_init(void)
+{
+	usb_register(&fp_tc_usb_driver);
+	return 0;
+}
+
+static __exit void fp_tc_exit(void)
+{
+	usb_deregister(&fp_tc_usb_driver);
+}
+module_init(fp_tc_init);
+module_exit(fp_tc_exit);
+
+MODULE_AUTHOR("Teodora Baluta <teodora.baluta@intel.com");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("UPEK TouchChip Fingerprint driver");
diff --git a/drivers/iio/fingerprint/fp_tc_usb.h b/drivers/iio/fingerprint/fp_tc_usb.h
new file mode 100644
index 0000000..5f26e82
--- /dev/null
+++ b/drivers/iio/fingerprint/fp_tc_usb.h
@@ -0,0 +1,144 @@
+#ifndef FP_TC_USB_H
+#define FP_TC_USB_H
+
+#define USB_FP_TC_VENDOR_ID	0x147e
+#define USB_FP_TC_PRODUCT_ID	0x2020
+
+#define USB_FP_TC_MINOR_BASE	254
+
+/* Control message settings */
+#define FP_TC_CTRL_REQUEST	0x0c
+#define FP_TC_CTRL_REQUEST_TYPE	0x40
+#define FP_TC_CTRL_VALUE	0x0100
+#define FP_TC_CTRL_INDEX	0x0400
+#define FP_TC_CTRL_SIZE		1
+
+/* USB timeouts */
+#define FP_TC_USB_BULK_TIMEOUT	4000
+#define FP_TC_USB_CTRL_TIMEOUT	4000
+
+/* Capture frame sizes */
+#define FP_TC_SHORT_RESP_SIZE	64
+#define FP_TC_MAX_RESP_SIZE	2052
+
+/* Identify the type of frame sent out by the device */
+#define FP_TC_FRAME_1		0x00
+#define FP_TC_FRAME_2		0x08
+#define FP_TC_NO_FINGER		0x28
+#define FP_TC_IMG_INFO_FRAME	0x2c
+#define FP_TC_IMG_FRAME		0x24
+#define FP_TC_LAST_IMG_FRAME	0x20
+
+/* USB activate frames are done in a certain sequence */
+#define FP_TC_CTRL_1		1
+#define FP_TC_INIT_1		2
+#define FP_TC_INIT_2		3
+#define FP_TC_CTRL_2		4
+#define FP_TC_INIT_3		5
+#define FP_TC_INIT_4		6
+#define FP_TC_READ_SHORT_RESP	7
+#define FP_TC_DONE		8
+
+#define FP_TC_USB_RETRIES	5
+
+struct usb_fp_tc {
+	/* the usb device for this device */
+	struct usb_device	*udev;
+	/* the interface for this device */
+	struct usb_interface	*intf;
+	/* the address of the bulk in endpoint */
+	__u8			bulk_in_endpoint_addr;
+	/* the address of the bulk out endpoint */
+	__u8			bulk_out_endpoint_addr;
+	/* keep count */
+	struct kref		kref;
+	/* sequence number for communication with device */
+	unsigned char		seq;
+};
+
+static unsigned char fp_tc_usb_init_1[] = {
+'C', 'i', 'a', 'o',
+0x04,
+0x00, 0x0d,
+0x01, 0x00, 0x46, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
+0x01, 0x00, 0x00, 0x00,
+0xda, 0xc1
+};
+
+static unsigned char fp_tc_usb_init_2[] = {
+0x43, 0x69, 0x61, 0x6f,
+0x07,
+0x00, 0x01,
+0x01,
+0x3d, 0x72
+};
+
+static unsigned char fp_tc_usb_init_3[] = {
+'C', 'i', 'a', 'o',
+0x04,
+0x00, 0x0d,
+0x01, 0x00, 0xbc, 0x02, 0x00, 0x00, 0x00, 0x00, 0x01,
+0x01, 0x00, 0x00, 0x00,
+0x55, 0x2f
+};
+
+static unsigned char fp_tc_usb_init_4[] = {
+'C', 'i', 'a', 'o',
+0x00,
+0x00, 0x07,
+0x28, 0x04, 0x00, 0x00, 0x00, 0x06, 0x04,
+0xc0, 0xd6
+};
+
+static unsigned char fp_tc_usb_deinit[] = {
+'C', 'i', 'a', 'o',
+0x07,
+0x00, 0x01,
+0x01,
+0x3d,
+0x72
+};
+
+static unsigned char fp_tc_usb_init_capture[] = {
+'C', 'i', 'a', 'o',
+0x00,
+0x00, 0x0e, /* Seq = 7, len = 0x00e */
+0x28, /* CMD = 0x28 */
+0x0b, 0x00,  /* Inner len = 0x000b */
+0x00, 0x00,
+0x0e, /* SUBCMD = 0x0e */
+0x02,
+0xfe, 0xff, 0xff, 0xff, /* timeout = -2 = 0xfffffffe = infinite time */
+0x02,
+0x00, /* Wait for acceptable finger */
+0x02,
+0x14, 0x9a /* CRC */
+};
+
+static unsigned char fp_tc_usb_ack_28[] = {
+'C', 'i', 'a', 'o',
+0x00,
+0x80, 0x08, /* Seq = 8, len = 0x008 */
+0x28, /* CMD = 0x28 */
+0x05, 0x00, /* Inner len = 0x0005 */
+0x00, 0x00, 0x00, 0x30, 0x01,
+0x6a, 0xc4 /* CRC */
+};
+
+/* No seq should be put in there */
+static unsigned char fp_tc_usb_ack_08[] = {
+'C', 'i', 'a', 'o',
+0x09,
+0x00, 0x00, /* Seq = 0, len = 0x0 */
+0x91, 0x9e /* CRC */
+};
+
+static unsigned char fp_tc_usb_ack[] = {
+'C', 'i', 'a', 'o',
+0x00,
+0x50, 0x01, /* Seq = 5, len = 0x001 */
+0x30,
+0xac, 0x5b /* CRC */
+};
+
+#endif
-- 
1.9.1

