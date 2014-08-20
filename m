Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaHTLUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:20:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:5030 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbaHTLUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:20:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="374704780"
From: Daniel Baluta <daniel.baluta@intel.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, wsa@the-dreams.de,
        linux-i2c@vger.kernel.org, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org
Cc: pratyush.anand@st.com, pebolle@tiscali.nl, stern@rowland.harvard.edu,
        octavian.purdila@intel.com, matthew@mjdsystems.ca,
        linux-kernel@vger.kernel.org, laurentiu.palcu@intel.com,
        daniel.baluta@intel.com, jdelvare@suse.de, arnd@arndb.de,
        sjg@chromium.org
Subject: [PATCH 1/3] usb: add support for Diolan DLN-2 devices
Date: Wed, 20 Aug 2014 14:24:45 +0300
Message-Id: <1408533887-22727-2-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408533887-22727-1-git-send-email-daniel.baluta@intel.com>
References: <1408533887-22727-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Octavian Purdila <octavian.purdila@intel.com>

This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
Master Adapter DLN-2. Details about the device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

Information about the USB protocol can be found in the Programmer's
Reference Manual [1], see section 1.7.

Because the hardware has a single transmit endpoint and a single
receive endpoint the communication between the various DLN2 drivers
and the hardware will be muxed/demuxed by this driver.

The functional DLN2 drivers (i2c, GPIO, etc.) will have to register
themselves as DLN2 modules in order to send or receive data.

Each DLN2 module will be identified by the handle field within the DLN2
message header. If a DLN2 module issues multiple commands in parallel
they will be identified by the echo counter field in the message header.

The DLN2 modules can use the dln2_transfer() function to issue a
command and wait for its response. They can also use an asynchronous
mode of operation, in which case a receive callback function is going
to be notified when messages for a specific handle are received.

Because the hardware reserves handle 0 for GPIO events, the driver
also reserves handle 0. It will be allocated to a DLN2 module only if
it is explicitly requested.

[1] https://www.diolan.com/downloads/dln-api-manual.pdf

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/usb/misc/Kconfig  |   6 +
 drivers/usb/misc/Makefile |   1 +
 drivers/usb/misc/dln2.c   | 719 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/dln2.h  | 146 ++++++++++
 4 files changed, 872 insertions(+)
 create mode 100644 drivers/usb/misc/dln2.c
 create mode 100644 include/linux/usb/dln2.h

diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 76d7720..953f521 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -255,3 +255,9 @@ config USB_LINK_LAYER_TEST
 	  This driver is for generating specific traffic for Super Speed Link
 	  Layer Test Device. Say Y only when you want to conduct USB Super Speed
 	  Link Layer Test for host controllers.
+
+config USB_DLN2
+	tristate "Diolan DLN2 USB Driver"
+	help
+	  This adds USB support for Diolan  USB-I2C/SPI/GPIO
+	  Master Adapter DLN-2.
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index 65b0402..767264e 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_USB_USS720)		+= uss720.o
 obj-$(CONFIG_USB_SEVSEG)		+= usbsevseg.o
 obj-$(CONFIG_USB_YUREX)			+= yurex.o
 obj-$(CONFIG_USB_HSIC_USB3503)		+= usb3503.o
+obj-$(CONFIG_USB_DLN2)			+= dln2.o
 
 obj-$(CONFIG_USB_SISUSBVGA)		+= sisusbvga/
 obj-$(CONFIG_USB_LINK_LAYER_TEST)	+= lvstest.o
diff --git a/drivers/usb/misc/dln2.c b/drivers/usb/misc/dln2.c
new file mode 100644
index 0000000..5bfa850
--- /dev/null
+++ b/drivers/usb/misc/dln2.c
@@ -0,0 +1,719 @@
+/*
+ * Driver for the Diolan DLN-2 USB adapter
+ *
+ * Copyright (c) 2014 Intel Corporation
+ *
+ * Derived from:
+ *  i2c-diolan-u2c.c
+ *  Copyright (c) 2010-2011 Ericsson AB
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+
+#define DRIVER_NAME			"usb-dln2"
+
+#define DLN2_GENERIC_MODULE_ID		0x00
+#define DLN2_GENERIC_CMD(cmd)		DLN2_CMD(cmd, DLN2_GENERIC_MODULE_ID)
+
+/* generic commands */
+#define CMD_GET_DEVICE_VER		DLN2_GENERIC_CMD(0x30)
+#define CMD_GET_DEVICE_SN		DLN2_GENERIC_CMD(0x31)
+
+#define DLN2_HW_ID			0x200
+
+#define DLN2_USB_TIMEOUT		100	/* in ms */
+
+#define DLN2_MAX_RX_SLOTS 16
+
+#include <linux/usb/dln2.h>
+
+struct dln2_rx_context {
+	struct completion done;
+	struct urb *urb;
+	bool connected;
+};
+
+struct dln2_rx_slots {
+	/* RX slots bitmap */
+	DECLARE_BITMAP(bmap, DLN2_MAX_RX_SLOTS);
+
+	/* used to wait for a free RX slot */
+	wait_queue_head_t wq;
+
+	/* used to wait for an RX operation to complete */
+	struct dln2_rx_context slots[DLN2_MAX_RX_SLOTS];
+
+	/* avoid races between free_rx_slot and dln2_transfer_rx_cb */
+	spinlock_t lock;
+};
+
+static int find_free_slot(struct dln2_rx_slots *rxs, int *slot)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rxs->lock, flags);
+
+	*slot = bitmap_find_free_region(rxs->bmap, DLN2_MAX_RX_SLOTS, 0) - 1;
+
+	if (*slot >= 0) {
+		struct dln2_rx_context *rxc = &rxs->slots[*slot];
+
+		init_completion(&rxc->done);
+		rxc->connected = true;
+	}
+
+	spin_unlock_irqrestore(&rxs->lock, flags);
+
+	return *slot >= 0;
+}
+
+static int alloc_rx_slot(struct dln2_rx_slots *rxs)
+{
+	int slot, ret;
+
+	ret = wait_event_interruptible(rxs->wq, find_free_slot(rxs, &slot));
+	if (ret < 0)
+		return ret;
+
+	return slot;
+}
+
+static void free_rx_slot(struct dln2_rx_slots *rxs, int slot)
+{
+	unsigned long flags;
+	struct dln2_rx_context *rxc;
+
+	spin_lock_irqsave(&rxs->lock, flags);
+
+	bitmap_clear(rxs->bmap, slot + 1, 1);
+
+	rxc = &rxs->slots[slot];
+	rxc->connected = false;
+
+	if (rxc->urb) {
+		usb_submit_urb(rxc->urb, GFP_KERNEL);
+		rxc->urb = NULL;
+	}
+
+	spin_unlock_irqrestore(&rxs->lock, flags);
+
+	wake_up_interruptible(&rxs->wq);
+}
+
+
+#define DLN2_MAX_MODULES	5
+#define DLN2_MAX_URBS		16
+
+struct dln2_dev {
+	struct urb *rx_urb[DLN2_MAX_URBS];
+	void *rx_buf[DLN2_MAX_URBS];
+	int ep_in, ep_out;              /* Endpoints    */
+	struct usb_device *usb_dev;	/* the usb device for this device */
+	struct usb_interface *interface;/* the interface for this device */
+
+	struct dln2_rx_slots mod_rx_slots[DLN2_MAX_MODULES];
+	void *context[DLN2_MAX_MODULES];
+	bool mod_initialized[DLN2_MAX_MODULES];
+
+	struct list_head list;
+};
+
+struct dln2_mod {
+	struct dln2_mod_ops *ops;
+	void *context;
+};
+
+/* registered modules (e.g i2c, GPIO, GPIO interrupts, etc.) */
+static struct dln2_mod dln2_modules[DLN2_MAX_MODULES];
+static DEFINE_MUTEX(dln2_modules_mutex);
+/* module used internally for control messages */
+static struct dln2_mod *dln2_ctrl_mod;
+
+static inline int dln2_get_handle(struct dln2_mod *mod)
+{
+	int handle = mod - dln2_modules;
+
+	BUG_ON(handle < 0 || handle > DLN2_MAX_MODULES);
+
+	return handle;
+}
+
+static void dln2_connect_do_work(struct work_struct *w);
+static DECLARE_DELAYED_WORK(dln2_connect_work, dln2_connect_do_work);
+
+struct dln2_mod *dln2_register_module(int handle, struct dln2_mod_ops *mod_ops)
+{
+	int i;
+
+	if (!mod_ops)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&dln2_modules_mutex);
+
+	if (handle < 0) {
+		for (i = 0; i < DLN2_MAX_MODULES; i++) {
+			/* reserve handle 0 for GPIO interrupts */
+			if (!dln2_modules[i].ops && i > 0) {
+				handle = i;
+				break;
+			}
+		}
+	}
+
+	if (handle >= DLN2_MAX_MODULES) {
+		mutex_unlock(&dln2_modules_mutex);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (dln2_modules[handle].ops) {
+		mutex_unlock(&dln2_modules_mutex);
+		return ERR_PTR(-EBUSY);
+	}
+
+	dln2_modules[handle].ops = mod_ops;
+
+	mutex_unlock(&dln2_modules_mutex);
+
+	schedule_delayed_work(&dln2_connect_work, HZ/10);
+
+	return &dln2_modules[handle];
+}
+EXPORT_SYMBOL(dln2_register_module);
+
+void dln2_unregister_module(struct dln2_mod *mod)
+{
+	mutex_lock(&dln2_modules_mutex);
+	mod->ops = NULL;
+	mutex_unlock(&dln2_modules_mutex);
+}
+EXPORT_SYMBOL(dln2_unregister_module);
+
+static void dln2_transfer_rx_cb(struct dln2_dev *dev, struct urb *urb,
+				struct dln2_response *rsp, void *data, int len)
+{
+	int handle = le16_to_cpu(rsp->hdr.handle);
+	int rx_slot = le16_to_cpu(rsp->hdr.echo);
+	struct dln2_rx_slots *rxs = &dev->mod_rx_slots[handle];
+	struct dln2_rx_context *rxc;
+
+	spin_lock(&rxs->lock);
+	rxc = &rxs->slots[rx_slot];
+	if (rxc->connected) {
+		rxc->urb = urb;
+		complete(&rxc->done);
+	} else {
+		dev_dbg(&dev->interface->dev, "drop response for handle/slot %d/%d",
+			 handle, rx_slot);
+		usb_submit_urb(urb, GFP_ATOMIC);
+	}
+	spin_unlock(&rxs->lock);
+}
+
+static void dln2_rx(struct urb *urb)
+{
+	struct dln2_dev *dev = urb->context;
+	struct dln2_response *rsp = urb->transfer_buffer;
+	struct dln2_mod *mod;
+	u16 id, echo, handle, size;
+	u8 *user_data;
+	int user_len;
+
+	handle = le16_to_cpu(rsp->hdr.handle);
+	id = le16_to_cpu(rsp->hdr.id);
+	echo = le16_to_cpu(rsp->hdr.echo);
+	size = le16_to_cpu(rsp->hdr.size);
+
+	if (handle > DLN2_MAX_MODULES)
+		goto out_invalid_handle;
+	mod = &dln2_modules[handle];
+	if (!mod->ops)
+		goto out_invalid_handle;
+
+	if (size != urb->actual_length)
+		dev_warn(&dev->interface->dev, "RX len mismatch: handle %x cmd %x echo %x size %d actual %d\n",
+			 handle, id, echo, size, urb->actual_length);
+
+	user_data = urb->transfer_buffer + sizeof(struct dln2_header);
+	user_len = urb->actual_length - sizeof(struct dln2_header);
+
+	if (mod->ops->receive)
+		mod->ops->receive(dev, urb, rsp, user_data, user_len);
+	else
+		dln2_transfer_rx_cb(dev, urb, rsp, user_data, user_len);
+
+	return;
+
+out_invalid_handle:
+	dev_warn(&dev->interface->dev, "RX: invalid handle %d\n", handle);
+	usb_submit_urb(urb, GFP_ATOMIC);
+}
+
+static void *dln2_prep_buf(struct dln2_dev *dev, struct dln2_mod *mod, u16 cmd,
+			   u16 echo, void *obuf, int *obuf_len, gfp_t gfp)
+{
+	void *buf;
+	int len;
+	struct dln2_header *hdr;
+	u16 handle = dln2_get_handle(mod);
+
+	len = *obuf_len + sizeof(*hdr);
+	buf = kmalloc(len, gfp);
+	if (!buf)
+		return NULL;
+
+	hdr = (struct dln2_header *)buf;
+	hdr->id = cpu_to_le16(cmd);
+	hdr->size = cpu_to_le16(len);
+	hdr->echo = cpu_to_le16(echo);
+	hdr->handle = cpu_to_le16(handle);
+
+	memcpy(buf + sizeof(*hdr), obuf, *obuf_len);
+	*obuf_len = len;
+
+	return buf;
+}
+
+static int dln2_send_wait(struct dln2_dev *dev, struct dln2_mod *mod, u16 cmd,
+			  u16 echo, void *obuf, int obuf_len)
+{
+	int len = obuf_len, ret = 0, actual;
+	void *buf;
+
+	if (!dev)
+		return -ENODEV;
+
+	buf = dln2_prep_buf(dev, mod, cmd, echo, obuf, &len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = usb_bulk_msg(dev->usb_dev,
+			   usb_sndbulkpipe(dev->usb_dev, dev->ep_out),
+			   buf, len, &actual, DLN2_USB_TIMEOUT);
+
+	kfree(buf);
+
+	return ret;
+}
+
+static void dln2_send_complete(struct urb *urb)
+{
+	kfree(urb->context);
+	usb_free_urb(urb);
+}
+
+int dln2_send(struct dln2_dev *dev, struct dln2_mod *mod, u16 cmd,
+	      u16 echo, void *obuf, int obuf_len)
+{
+	int len = obuf_len, ret;
+	struct urb *urb;
+	void *buf;
+
+	if (!dev)
+		return -ENODEV;
+
+	buf = dln2_prep_buf(dev, mod, cmd, echo, obuf, &len, GFP_ATOMIC);
+	if (!buf)
+		return -ENOMEM;
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb) {
+		kfree(buf);
+		return -ENOMEM;
+	}
+
+	usb_fill_bulk_urb(urb, dev->usb_dev,
+			  usb_sndbulkpipe(dev->usb_dev, dev->ep_out),
+			  buf, len, dln2_send_complete, buf);
+
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret < 0) {
+		usb_free_urb(urb);
+		kfree(buf);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(dln2_send);
+
+int dln2_transfer(struct dln2_dev *dev, struct dln2_mod *mod, u16 cmd,
+		  void *obuf, int obuf_len, void *ibuf, int *ibuf_len)
+{
+	u16 result, rx_slot;
+	struct dln2_response *rsp;
+	int ret = 0, handle = dln2_get_handle(mod);
+	const int timeout = DLN2_USB_TIMEOUT * HZ / 1000;
+	struct dln2_rx_slots *rxs;
+	struct dln2_rx_context *rxc;
+	struct device *d;
+
+	if (!dev)
+		return -ENODEV;
+
+	d = &dev->interface->dev;
+
+	if (mod->ops->receive) {
+		dev_warn(&dev->interface->dev,
+			 "module %s calls dln2_transfer w/ rx_callback set\n",
+			 mod->ops->name);
+		return -EINVAL;
+	}
+
+	rxs = &dev->mod_rx_slots[handle];
+
+	rx_slot = alloc_rx_slot(rxs);
+	if (rx_slot < 0) {
+		dev_err(d, "alloc_rx_slot failed: %d", ret);
+		return rx_slot;
+	}
+
+	ret = dln2_send_wait(dev, mod, cmd, rx_slot, obuf, obuf_len);
+	if (ret < 0) {
+		free_rx_slot(rxs, rx_slot);
+		dev_err(d, "USB write failed: %d", ret);
+		return ret;
+	}
+
+	rxc = &rxs->slots[rx_slot];
+
+	ret = wait_for_completion_interruptible_timeout(&rxc->done, timeout);
+	if (ret <= 0) {
+		ret = !ret ? -ETIMEDOUT : ret;
+		goto out_free_rx_slot;
+	}
+
+	rsp = rxc->urb->transfer_buffer;
+	result = le16_to_cpu(rsp->result);
+
+	if (result) {
+		dev_warn(d, "%d received response with error %d\n",
+			 handle, result);
+		ret = -EREMOTEIO;
+		goto out_free_rx_slot;
+	}
+
+	if (!ibuf) {
+		ret = 0;
+		goto out_free_rx_slot;
+	}
+
+	if (*ibuf_len > rxc->urb->actual_length - sizeof(*rsp))
+		*ibuf_len = rxc->urb->actual_length - sizeof(*rsp);
+
+	memcpy(ibuf, rsp + 1, *ibuf_len);
+
+out_free_rx_slot:
+	free_rx_slot(rxs, rx_slot);
+
+	return ret;
+}
+EXPORT_SYMBOL(dln2_transfer);
+
+static int dln2_check_hw(struct dln2_dev *dev)
+{
+	__le32 hw_type;
+	int ret, len = sizeof(hw_type);
+
+
+	ret = dln2_transfer(dev, dln2_ctrl_mod, CMD_GET_DEVICE_VER, NULL, 0,
+			    &hw_type, &len);
+	if (ret < 0)
+		return ret;
+
+	if (le32_to_cpu(hw_type) != DLN2_HW_ID) {
+		dev_err(&dev->interface->dev, "Device ID 0x%x not supported!",
+			le32_to_cpu(hw_type));
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int dln2_print_serialno(struct dln2_dev *dev)
+{
+	__le32 serial_no;
+	int ret, len = sizeof(serial_no);
+
+
+	ret = dln2_transfer(dev, dln2_ctrl_mod, CMD_GET_DEVICE_SN, NULL, 0,
+			    &serial_no, &len);
+	if (ret < 0)
+		return ret;
+
+	dev_info(&dev->interface->dev,
+		 "Diolan DLN2 device serial number is: 0x%x\n",
+		 le32_to_cpu(serial_no));
+
+	return 0;
+}
+
+static int dln2_hw_init(struct dln2_dev *dev)
+{
+	int ret;
+
+	dev_info(&dev->interface->dev,
+		 "Diolan DLN2 at USB bus %03d address %03d\n",
+		 dev->usb_dev->bus->busnum, dev->usb_dev->devnum);
+
+	ret = dln2_check_hw(dev);
+	if (ret < 0)
+		return ret;
+
+	dln2_print_serialno(dev);
+
+	return ret;
+}
+
+/* device layer */
+
+
+static LIST_HEAD(dln2_dev_list);
+
+static void dln2_connect_modules(struct dln2_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < DLN2_MAX_MODULES; i++)
+		if (dln2_modules[i].ops && dln2_modules[i].ops->connect &&
+		    !dev->mod_initialized[i] &&
+		    !dln2_modules[i].ops->connect(dev))
+			dev->mod_initialized[i] = true;
+}
+
+static void dln2_connect_do_work(struct work_struct *w)
+{
+	struct dln2_dev *dev;
+
+	mutex_lock(&dln2_modules_mutex);
+	list_for_each_entry(dev, &dln2_dev_list, list)
+		dln2_connect_modules(dev);
+	mutex_unlock(&dln2_modules_mutex);
+}
+
+static void dln2_free_rx_urbs(struct dln2_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < DLN2_MAX_URBS; i++) {
+		usb_unlink_urb(dev->rx_urb[i]);
+		usb_free_urb(dev->rx_urb[i]);
+		kfree(dev->rx_buf[i]);
+	}
+}
+
+static void dln2_free(struct dln2_dev *dev)
+{
+	dln2_free_rx_urbs(dev);
+	usb_put_dev(dev->usb_dev);
+	kfree(dev);
+}
+
+static int dln2_setup_rx_urbs(struct dln2_dev *dev,
+			      struct usb_host_interface *hostif)
+{
+	int i, ret;
+	int rx_max_size = le16_to_cpu(hostif->endpoint[1].desc.wMaxPacketSize);
+	struct device *d = &dev->interface->dev;
+
+	for (i = 0; i < DLN2_MAX_URBS; i++) {
+		dev->rx_buf[i] = kmalloc(rx_max_size, GFP_KERNEL);
+		if (!dev->rx_buf[i]) {
+			dev_err(d, "no memory for RX buffers\n");
+			return -ENOMEM;
+		}
+
+		dev->rx_urb[i] = usb_alloc_urb(0, GFP_KERNEL);
+		if (!dev->rx_urb[i]) {
+			dev_err(d, "no memory for RX URBs\n");
+			return -ENOMEM;
+		}
+
+		usb_fill_bulk_urb(dev->rx_urb[i], dev->usb_dev,
+				  usb_rcvbulkpipe(dev->usb_dev, dev->ep_in),
+				  dev->rx_buf[i], rx_max_size, dln2_rx, dev);
+
+		ret = usb_submit_urb(dev->rx_urb[i], GFP_KERNEL);
+		if (ret < 0) {
+			dev_err(d, "failed to submit RX URB: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void dln2_disconnect(struct usb_interface *interface)
+{
+	struct dln2_dev *dev = usb_get_intfdata(interface);
+	int i;
+
+	mutex_lock(&dln2_modules_mutex);
+	list_del(&dev->list);
+	for (i = 0; i < DLN2_MAX_MODULES; i++)
+		if (dln2_modules[i].ops && dln2_modules[i].ops->disconnect &&
+		    dev->mod_initialized[i])
+			dln2_modules[i].ops->disconnect(dev);
+	mutex_unlock(&dln2_modules_mutex);
+
+	usb_set_intfdata(interface, NULL);
+	dln2_free(dev);
+
+	dev_dbg(&interface->dev, "disconnected\n");
+}
+
+static int dln2_probe(struct usb_interface *interface,
+		      const struct usb_device_id *id)
+{
+	struct usb_host_interface *hostif = interface->cur_altsetting;
+	struct dln2_dev *dev;
+	int ret, i;
+
+	if (hostif->desc.bInterfaceNumber != 0 ||
+	    hostif->desc.bNumEndpoints < 2)
+		return -ENODEV;
+
+	/* allocate memory for our device state and initialize it */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		dev_err(&interface->dev, "no memory for device state\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	dev->ep_out = hostif->endpoint[0].desc.bEndpointAddress;
+	dev->ep_in = hostif->endpoint[1].desc.bEndpointAddress;
+
+	dev->usb_dev = usb_get_dev(interface_to_usbdev(interface));
+	dev->interface = interface;
+
+	/* save our data pointer in this interface device */
+	usb_set_intfdata(interface, dev);
+
+	for (i = 0; i < DLN2_MAX_MODULES; i++) {
+		init_waitqueue_head(&dev->mod_rx_slots[i].wq);
+		spin_lock_init(&dev->mod_rx_slots[i].lock);
+	}
+
+	ret = dln2_setup_rx_urbs(dev, hostif);
+	if (ret) {
+		dln2_disconnect(interface);
+		return ret;
+	}
+
+	ret = dln2_hw_init(dev);
+	if (ret < 0) {
+		dev_err(&interface->dev, "failed to initialize hardware\n");
+		goto out_cleanup;
+	}
+
+	dev_dbg(&interface->dev, "connected " DRIVER_NAME "\n");
+
+	mutex_lock(&dln2_modules_mutex);
+	dln2_connect_modules(dev);
+	list_add(&dev->list, &dln2_dev_list);
+	mutex_unlock(&dln2_modules_mutex);
+
+	return 0;
+
+out_cleanup:
+	usb_set_intfdata(interface, NULL);
+	dln2_free(dev);
+out:
+	return ret;
+}
+
+void dln2_set_mod_context(struct dln2_mod *mod, void *context)
+{
+	mod->context = context;
+}
+EXPORT_SYMBOL(dln2_set_mod_context);
+
+void *dln2_get_mod_context(struct dln2_mod *mod)
+{
+	return mod->context;
+}
+EXPORT_SYMBOL(dln2_get_mod_context);
+
+void dln2_set_dev_context(struct dln2_dev *dev, struct dln2_mod *mod,
+			  void *context)
+{
+	int handle = dln2_get_handle(mod);
+
+	dev->context[handle] = context;
+}
+EXPORT_SYMBOL(dln2_set_dev_context);
+
+void *dln2_get_dev_context(struct dln2_dev *dev, struct dln2_mod *mod)
+{
+	int handle = dln2_get_handle(mod);
+
+	return dev->context[handle];
+}
+EXPORT_SYMBOL(dln2_get_dev_context);
+
+struct device *dln2_get_device(struct dln2_dev *dev)
+{
+	return &dev->interface->dev;
+}
+EXPORT_SYMBOL(dln2_get_device);
+
+static const struct usb_device_id dln2_table[] = {
+	{ USB_DEVICE(0xa257, 0x2013) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(usb, dln2_table);
+
+static struct usb_driver dln2_driver = {
+	.name = DRIVER_NAME,
+	.probe = dln2_probe,
+	.disconnect = dln2_disconnect,
+	.id_table = dln2_table,
+};
+
+static struct dln2_mod_ops dln2_ctrl_mod_ops = {
+	.name = "dln2-ctrl",
+	.receive = NULL,
+	.connect = NULL,
+	.disconnect = NULL,
+};
+
+static int __init dln2_init(void)
+{
+	int err = 0;
+
+	dln2_ctrl_mod = dln2_register_module(-1, &dln2_ctrl_mod_ops);
+
+	if (IS_ERR(dln2_ctrl_mod)) {
+		err = PTR_ERR(dln2_ctrl_mod);
+		pr_err(DRIVER_NAME "dln2_register_module failed: %d\n", err);
+		return err;
+	}
+
+	err = usb_register_driver(&dln2_driver, THIS_MODULE, KBUILD_MODNAME);
+	if (err < 0)
+		pr_err(DRIVER_NAME "failed to register usb driver: %d\n", err);
+
+	return err;
+}
+module_init(dln2_init);
+
+static void __exit dln2_exit(void)
+{
+	usb_deregister(&dln2_driver);
+}
+module_exit(dln2_exit);
+
+MODULE_AUTHOR("Octavian Purdila <octavian.purdila@intel.com>");
+MODULE_DESCRIPTION(DRIVER_NAME " driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/usb/dln2.h b/include/linux/usb/dln2.h
new file mode 100644
index 0000000..3f7f8c6
--- /dev/null
+++ b/include/linux/usb/dln2.h
@@ -0,0 +1,146 @@
+#ifndef __LINUX_USB_DLN2_H
+#define __LINUX_USB_DLN2_H
+
+#include <linux/usb.h>
+
+struct dln2_header {
+	__le16 size;
+	__le16 id;
+	__le16 echo;
+	__le16 handle;
+} __packed;
+
+struct dln2_response {
+	struct dln2_header hdr;
+	__le16 result;
+} __packed;
+
+
+struct dln2_mod;
+struct dln2_dev;
+
+#define DLN2_CMD(cmd, id)		((cmd) | ((id) << 8))
+
+/**
+ * dln2_mod_ops - DLN2 module callbacks
+ *
+ * @name - name of the module
+ *
+ * @receive - called when a message is received for the handle
+ * associated with this module. It can be NULL, and in this case
+ * dln_transfer() can be use for this module and the receive path will
+ * be handled internally. If the receive callback is used the user
+ * must call usb_sumit_urb() after finishing reading the data.
+ *
+ * @connect - called when a new DLN2 device is connected. The module
+ * should perform any needed initialization and associated the module
+ * context to this device with dln2_set_dev_context().
+ *
+ * @disconnect - called when a DLN2 device is disconnected. The module
+ * should free any resources associated with this device.
+ */
+struct dln2_mod_ops {
+	const char *name;
+
+	void (*receive)(struct dln2_dev *dev, struct urb *urb,
+			struct dln2_response *res, void *data, int len);
+	int (*connect)(struct dln2_dev *dev);
+	void (*disconnect)(struct dln2_dev *dev);
+};
+
+/**
+ * dl2n_register_module - register a DLN2 module
+ *
+ * @handle - the requested handle for this module that is going to be
+ * passed to the hardware; a positive value to request a specific
+ * value, or -1 to automatically allocate one
+ *
+ * @mod_ops - see dln2_mod_ops()
+ *
+ * @return an ERR_PTR is return in case of error. In case of success a
+ * dln2_mod handle is returned. The module should use
+ * dln2_set_mod_context() to associate any private context to this
+ * module.
+ */
+struct dln2_mod *dln2_register_module(int handle, struct dln2_mod_ops *mod_ops);
+
+/**
+ * dl2n_register_module - unregister a DLN2 module
+ */
+void dln2_unregister_module(struct dln2_mod *mod);
+
+/**
+ * dln2_transfer - issue a DLN2 command and wait for a response and
+ * the associated data
+ *
+ * Only modules that did *NOT* register a receive callback will be
+ * able to use this function.
+ *
+ * @dev - the DLN2 device on which to issue the command
+ * @mod - the DLN2 module issuing the command
+ * @cmd - the command to be sent to the device
+ * @obuf - the buffer to be sent to the device; can be NULL if the
+ * user doesn't need to transmit data with this command
+ * @obuf_len - the size of the buffer to be sent to the device
+ * @ibuf - any data associated with the response will be copied here;
+ * it can be NULL if the user doesn't need the response data
+ * @ibuf_len - must be initialized to the input buffer size; it will
+ * be modified to indicate the actual data transfered
+ *
+ * @returns 0 for success, negative value for errors
+ */
+int dln2_transfer(struct dln2_dev *dev, struct dln2_mod *mod, u16 cmd,
+		  void *obuf, int obuf_len, void *ibuf, int *ibuf_len);
+
+/**
+ * dln2_send - issue a DLN2 command without waiting for a response
+ *
+ * @dev - the DLN2 device on which to issue the command
+ * @mod - the DLN2 module issuing the command
+ * @cmd - the command to be sent to the device
+ * @echo - this value will be echoed back in the response
+ * @obuf - the buffer to be sent to the device; can be NULL if the
+ * user doesn't need to transmit data with this command
+ * @obuf_len - the size of the buffer to be sent to the device
+ *
+ * @returns 0 for success, negative value for errors
+ */
+int dln2_send(struct dln2_dev *dev, struct dln2_mod *mod, u16 cmd, u16 echo,
+	      void *obuf, int obuf_len);
+
+/**
+ * dln2_set_mod_context - store a private pointer into dln2_mod
+ *
+ * @mod - the DLN2 module
+ * @context - the private pointer to be set
+ */
+void dln2_set_mod_context(struct dln2_mod *mod, void *context);
+
+/**
+ * dln2_set_mod_context - get the module private pointer from dln2_mod
+ *
+ * @mod - the DLN2 module
+ * @returns the module private pointer
+ */
+void *dln2_get_mod_context(struct dln2_mod *mod);
+
+
+/**
+ * dln2_set_mod_context - store a private pointer into dln2_dev
+ *
+ * @dev - the DLN2 device
+ * @context - the private pointer to be set
+ */
+void dln2_set_dev_context(struct dln2_dev *dev, struct dln2_mod *mod,
+			  void *context);
+/**
+ * dln2_set_mod_context - get the module private pointer from dln2_dev
+ *
+ * @dev - the DLN2 device
+ * @returns the device private pointer
+ */
+void *dln2_get_dev_context(struct dln2_dev *dev, struct dln2_mod *mod);
+
+struct device *dln2_get_device(struct dln2_dev *dev);
+
+#endif
-- 
1.9.1

