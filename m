Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab3FQIKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:10:20 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:48502 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754735Ab3FQIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:10:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <akhil.goyal@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>,
        Akhil Goyal <akhil.goyal@freescale.com>
Subject: [PATCH 1/5] drivers/misc: Support for RF interface device framework
Date: Mon, 17 Jun 2013 13:39:22 +0530
Message-ID: <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com>
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akhil Goyal <akhil.goyal@freescale.com>

The radio device framework introduces a way to accommodate the
RF(radio frequency) signal paths.  One signal path is represented
as a RF device (rf0, rf1 etc), and it can contain multiple
components which have their individual vendor specific drivers.
The framework provides mechanism by which individual components
can register with RF framework, and the framework will handle the
binding of individual component devices to a RF device. RF device
exports the control interfaces to user space, and this user space
interface is independent of component (vendor specific) drivers.

In a multimode system there can be multiple rfdev devices, depending
on number of radios connected.

In this patch, the rf controller(AIC) and RFIC(AD9361) drivers
register their respective devices with this framework. This framework
does binding of RFIC device with RF controller device and exposes
the combination as a logical rfdev to user space.

Signed-off-by: Pankaj Chauhan <pankaj.chauhan@freescale.com>
Signed-off-by: Shaveta Leekha <shaveta@freescale.com>
Signed-off-by: Bhaskar Upadhaya <bhaskar.upadhaya@freescale.com>
Signed-off-by: Akhil Goyal <akhil.goyal@freescale.com>
---
 Documentation/misc-devices/rf_framework |  110 +++
 drivers/misc/Kconfig                    |    1 +
 drivers/misc/Makefile                   |    1 +
 drivers/misc/rf/Kconfig                 |   37 +
 drivers/misc/rf/Makefile                |    5 +
 drivers/misc/rf/core/Makefile           |    2 +
 drivers/misc/rf/core/rf_channel.c       |  207 +++++
 drivers/misc/rf/core/rfdev.c            | 1263 +++++++++++++++++++++++++++++++
 include/linux/rf_channel.h              |   26 +
 include/linux/rfdev.h                   |  250 ++++++
 include/uapi/linux/rfdev.h              |  392 ++++++++++
 11 files changed, 2294 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/rf_framework
 create mode 100644 drivers/misc/rf/Kconfig
 create mode 100644 drivers/misc/rf/Makefile
 create mode 100644 drivers/misc/rf/core/Makefile
 create mode 100644 drivers/misc/rf/core/rf_channel.c
 create mode 100644 drivers/misc/rf/core/rfdev.c
 create mode 100644 include/linux/rf_channel.h
 create mode 100644 include/linux/rfdev.h
 create mode 100644 include/uapi/linux/rfdev.h

diff --git a/Documentation/misc-devices/rf_framework b/Documentation/misc-devices/rf_framework
new file mode 100644
index 0000000..b65b575
--- /dev/null
+++ b/Documentation/misc-devices/rf_framework
@@ -0,0 +1,110 @@
+		Kernel Framework for Radio devices
+
+This document explains the Framework for radio devices along with the APIs
+provided for Phy and controller drivers and the interface for user space.
+
+1. Introduction:
+
+RF signal path is integral part of any system that transmits/receives RF
+(radio frequency) signals. In these systems Data is processed/converted
+to IQ samples (digital representation a RF signal) and passed to a RFIC
+(RF PHY) which converts the digital RF signal (IQ samples) to analog and
+transmits over antenna.
+
+Typically The signal path consists of multiple components:
+
+Antenna controller <-> vector signal processors <-> RFIC <-> Antenna
+
+Each of these components have specific functionalities:
+
+1. Antenna controller: Framing of digital IQ data into protocol specific frames.
+2. vector signal processors: For conditioning of signal.
+3. RFIC : converts digital IQ data to analog signal which is
+	transmitted/received on/from Air.
+
+Also it is desirable to control the complete signal path, for example:
+bringing the complete signal path up/down etc.
+
+The radio device framework introduces a way to accommodate the RF signal
+paths.  One signal path is represented as a RF device (rf0, rf1 etc), and
+it can contain multiple components which have their individual vendor
+specific drivers. The framework provides mechanism by which individual
+components can register with RF framework, and the framework will handle the
+binding of individual component devices to a RF device. RF device exports the
+control interfaces to user space, and this user space interface is independent
+of component (vendor specific) drivers.
+
+RF framework provide APIs for PHY and Controller drivers to register themselves
+and exposes the radio device as a character device for configuration from user
+space.
+
+1. PHY and Controller APIs
+	a) Allocate/free controller and phy device structures
+		The RF framework provide APIs for allocation and deallocation
+		of controller and phy devices.
+
+		struct rf_ctrl_dev *allocate_rf_ctrl_dev(size_t priv_size,
+							unsigned long flags);
+		int free_rf_ctrl_dev(struct rf_ctrl_dev *rf_dev);
+		struct rf_phy_dev *allocate_rf_phy_dev(size_t priv_size,
+							unsigned long flags);
+		int free_rf_phy_dev(struct rf_phy_dev *phy)
+
+	b) Register/Unregister controller and phy devices
+		register_rf_ctrl_dev is used to register the controller
+		with the rf framework. Similarly, register_rf_phy_dev is for
+		registering phy with the framework. Controller and Phy drivers
+		shall populate their structures with phy_id which is used by
+		the framework to bind controller to PHY. Controller and phy
+		can populate this information from device tree or any other
+		mechanism. RF framework will internally maintain a state
+		machine for RF device. User space and controller/phy drivers
+		shall use these states to allow/disallow certain control
+		operations.
+
+		int register_rf_ctrl_dev(struct rf_ctrl_dev *rf_dev);
+		int unregister_rf_ctrl_dev(struct rf_ctrl_dev *rf_dev);
+		int register_rf_phy_dev(struct rf_phy_dev *phy);
+		int unregister_rf_phy_dev(struct rf_phy_dev *phy);
+
+2. User space file_operations
+	a) open rf node
+		User space can make open() calls to open a file descriptor for
+		RF device.
+
+		static int rf_open(struct inode *inode, struct file *filep);
+
+	b) release rf node
+		For releasing the file descriptor of rf device
+
+		static int rf_release(struct inode *inode, struct file *filep);
+
+	c) read from a file descriptor
+		User space can make read() calls to get notification for every
+		Transmit time Interval(TTI) which is an integral part of a
+		communication network.
+
+		static ssize_t rf_read(struct file *filep, char __user *buf,
+					size_t size, loff_t *offset);
+
+	d) ioctl interface
+		User space can interact with the RF framework and the
+		phy/controller drivers using various IOCTLs. Various IOCTL
+		numbers are defined in include/uapi/linux/rfdev.h.
+		User space application can include this file to interact with
+		the kernel controller/phy drivers.
+		The ioctls exposed here are independant of vendor specific
+		controller/phy drivers.
+
+		static long rf_ioctl(struct file *, unsigned int cmd,
+					unsigned long arg);
+
+	e) event handling
+		User space can register event handler to get notified of some
+		events which are triggered from the hardware and user space can
+		perform certain actions on receiving those events.
+
+		int rf_register_event_handler(struct rf_ctrl_dev *rf_dev,
+				struct rf_event_listener *listener);
+		int rf_unregister_event_handler(struct rf_ctrl_dev *rf_dev,
+				enum rf_evt_del flag);
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c002d86..c5ddc28 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -536,4 +536,5 @@ source "drivers/misc/carma/Kconfig"
 source "drivers/misc/altera-stapl/Kconfig"
 source "drivers/misc/mei/Kconfig"
 source "drivers/misc/vmw_vmci/Kconfig"
+source "drivers/misc/rf/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c235d5b..62769ab 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
+obj-$(CONFIG_RFDEVICES)		+= rf/
diff --git a/drivers/misc/rf/Kconfig b/drivers/misc/rf/Kconfig
new file mode 100644
index 0000000..ae4ff36
--- /dev/null
+++ b/drivers/misc/rf/Kconfig
@@ -0,0 +1,37 @@
+
+# RF (radio frequency) device configuration
+#
+
+menuconfig RFDEVICES
+	default n
+	bool "RF interface device support"
+	---help---
+	Support for RF interface devices.
+	In a baseband system, different radios (RF PHYs) are
+	connected depending on required radio technology. Higher layer
+	stacks need to configure the radio according to required network mode.
+	Adding this support will export different radios connected in system
+	(in case of multi mode system)as RF interface deivces 'rf0', 'rf1' etc.
+	Higher layer stacks (running in user space)can use rfX device to
+	talk to a specific radio.
+
+	radio interface controller driver (Antenna controller) and RF PHY driver
+	connected to system must also be chosen.
+
+if RFDEVICES
+
+config FSL_AIC
+	default y
+	bool "Freescale Antenna Interface Controller (AIC)"
+	---help---
+	Freescale AIC controller (Antenna Interface Controller) is found
+	in bsc913x family of SOCs. AIC has six RF lanes and maximum four
+	RF PHYs can be connected and operated simultaneously.
+
+config ADI9361
+	default y
+	bool "ADI 9361 RF PHY"
+	---help---
+	ADI9361 RF phy driver.
+
+endif
diff --git a/drivers/misc/rf/Makefile b/drivers/misc/rf/Makefile
new file mode 100644
index 0000000..566585e
--- /dev/null
+++ b/drivers/misc/rf/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the RF interface drivers.
+#
+
+obj-$(CONFIG_RFDEVICES)		+= core/
diff --git a/drivers/misc/rf/core/Makefile b/drivers/misc/rf/core/Makefile
new file mode 100644
index 0000000..f8ab6e8
--- /dev/null
+++ b/drivers/misc/rf/core/Makefile
@@ -0,0 +1,2 @@
+
+obj-$(CONFIG_RFDEVICES)		+= rfdev.o rf_channel.o
diff --git a/drivers/misc/rf/core/rf_channel.c b/drivers/misc/rf/core/rf_channel.c
new file mode 100644
index 0000000..480ab6d
--- /dev/null
+++ b/drivers/misc/rf/core/rf_channel.c
@@ -0,0 +1,207 @@
+/*
+ * drivers/rf/core/rf_channel.c
+ * RF Data Channel support
+ *
+ * RF data channels: Each RF device has per antenna RF
+ * data channel. An RF data channel is a full duplex channel
+ * (supports both Tx and RX), which supports Tx and Rx of IQ
+ * data to/from a RF device. Current Implementation only
+ * supports Rx/Tx data between rf device and user space but
+ * this framework can be extended to support in kernel users
+ * of IQ data as well.
+ *
+ * Author: pankaj chauhan <pankaj.chauhan@freescale.com>
+ *
+ * Copyright 2011-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/bitops.h>
+#include <linux/rfdev.h>
+#include <linux/rf_channel.h>
+
+int rf_channel_open(struct rf_ctrl_dev *rf_dev,
+	struct rf_channel_params *chan_params)
+{
+
+	struct rf_channel *chan;
+	struct rf_mmaped_bufs *bufs;
+	struct rf_ctrl_ops *ops;
+	int ant, rc = 0;
+
+	ant = chan_params->ant;
+	if (ant >= MAX_NUM_ANTENNAS) {
+		pr_err("%s: Ant[%d] invalid\n", rf_dev->name,
+			ant);
+		rc = -EINVAL;
+		goto out;
+	}
+	chan = rf_dev->channels[ant];
+	if (chan) {
+		pr_err("%s: Ant[%d] channel is already open\n", rf_dev->name,
+			ant);
+		rc = -EEXIST;
+		goto out;
+	}
+
+	chan = kzalloc(sizeof(struct rf_channel), GFP_KERNEL);
+	if (!chan) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	raw_spin_lock_init(&chan->lock);
+	chan->ant = ant;
+	chan->dev = rf_dev;
+	chan->flags = chan_params->flags;
+	chan->tx_buf_size = chan_params->tx_buf_size;
+	chan->rx_buf_size = chan_params->rx_buf_size;
+
+	if (chan_params->flags & RF_CHAN_MMAPED) {
+		bufs = &chan->bufs.mmap_bufs;
+		/* We don't touch the buffers in kernel space
+		 * since we don't have any in kernel users of
+		 * channel, so virtual address of bufs is being
+		 * kept NULL. If we ever have users who can touch
+		 * channel buffer in kernel then an ioremap() is
+		 * required here.
+		 */
+		bufs->tx_base = 0;
+		bufs->rx_base = 0;
+		bufs->tx_base_phys = chan_params->tx_base_phys;
+		bufs->rx_base_phys = chan_params->rx_base_phys;
+		bufs->tx_curr_idx = 0;
+		bufs->rx_curr_idx = 0;
+	} else {
+		pr_err("%s: Only MMAPED channels are supported, flags %x\n",
+			rf_dev->name, chan_params->flags);
+		kfree(chan);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	ops = rf_dev->ops;
+	rc = ops->channel_open(rf_dev, chan);
+	if (rc) {
+		pr_err("%s: Ant[%d] Ctrl dev failed to open channel\n",
+			rf_dev->name, ant);
+		kfree(chan);
+		goto out;
+	}
+
+	rf_dev->channels[ant] = chan;
+out:
+
+	return rc;
+}
+
+
+int rf_channel_close(struct rf_ctrl_dev *rf_dev, int ant)
+{
+	struct rf_ctrl_ops *ops = rf_dev->ops;
+	struct rf_channel *chan;
+	int rc = 0;
+
+	if (ant >= MAX_NUM_ANTENNAS) {
+		pr_err("%s: Ant[%d] invalid\n", rf_dev->name,
+			ant);
+		rc = -EINVAL;
+		goto out;
+	}
+	chan = rf_dev->channels[ant];
+
+	if (!chan)
+		goto out;
+
+	rc = ops->channel_close(rf_dev, chan);
+	if (rc) {
+		pr_err("%s: Ctrl dev failed to close chan %d\n",
+			rf_dev->name, ant);
+		goto out;
+	}
+
+	kfree(chan);
+	rf_dev->channels[ant] = NULL;
+
+out:
+	return rc;
+}
+
+
+int rf_rx_frame(struct rf_ctrl_dev *rf_dev, struct rf_frame *frame)
+{
+	struct rf_event_handler *event_handler;
+	struct rf_channel *chan;
+	struct rf_channel_stats *stats;
+	u16 evt;
+	int rc = 0;
+
+	chan = rf_dev->channels[frame->ant];
+
+	if (!(chan->flags & RF_CHAN_MMAPED)) {
+		rc = -ENOSYS;
+		pr_err("%s: Non MMAPED rx frame not supported\n",
+			rf_dev->name);
+		goto out;
+	}
+
+	stats = &chan->stats;
+	stats->rx_frame_count++;
+	spin_lock(&rf_dev->event_handler_lock);
+
+	list_for_each_entry(event_handler, &rf_dev->event_handler_list, list) {
+
+		if (event_handler->evt_mask & RF_EVT_RX_FRAME) {
+
+			evt = RF_MAKE_EVENT(RF_EVT_RX_FRAME, frame->ant,
+				frame->buf.buffer_idx);
+			rc = rf_send_event(rf_dev, event_handler, evt);
+			if (rc) {
+				pr_err("%s: Failed to send evt sig\n",
+					rf_dev->name);
+				break;
+			}
+		}
+	}
+
+	spin_unlock(&rf_dev->event_handler_lock);
+out:
+
+	return rc;
+}
+
+int rf_sniff_done(struct rf_ctrl_dev *rf_dev, int ant)
+{
+	struct rf_event_handler *event_handler;
+	u16 evt;
+	int rc = 0;
+
+	spin_lock(&rf_dev->event_handler_lock);
+	list_for_each_entry(event_handler, &rf_dev->event_handler_list, list) {
+
+		if (event_handler->evt_mask & RF_EVT_SNIFF_DONE) {
+
+			evt = RF_MAKE_EVENT(RF_EVT_SNIFF_DONE, ant, 0);
+			rc = rf_send_event(rf_dev, event_handler, evt);
+			if (rc) {
+				pr_err("%s: Failed to send evt sig\n",
+					rf_dev->name);
+				break;
+			}
+
+		}
+	}
+	spin_unlock(&rf_dev->event_handler_lock);
+
+	return rc;
+}
+
diff --git a/drivers/misc/rf/core/rfdev.c b/drivers/misc/rf/core/rfdev.c
new file mode 100644
index 0000000..8107c95
--- /dev/null
+++ b/drivers/misc/rf/core/rfdev.c
@@ -0,0 +1,1263 @@
+/*
+ * drivers/rf/core/rfdev.c
+ * RF device framework
+ *
+ * Radio interface device framework exposes the combination of a RF interface
+ * controller and RFIC as a RF device (eg. rf0, rf1) to user space for
+ * configuration. This interface is for RF PHYs for LTE/CDMA systems. RF
+ * interface controller driver and RFIC driver registers respective devices
+ * with this framework, and thier combination is exposed to user space as
+ * a unified rfdev interface 'rf0'.
+ *
+ * Author: pankaj chauhan <pankaj.chauhan@freescale.com>
+ *
+ * Copyright 2011-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/bitops.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/wait.h>
+#include <linux/rfdev.h>
+#include <linux/cdev.h>
+#include <linux/uaccess.h>
+#include <linux/signal.h>
+#include <linux/rf_channel.h>
+
+struct rf_priv {
+	struct list_head ctrl_list;
+	struct list_head phy_list;
+	spinlock_t phy_lock;
+	spinlock_t ctrl_lock;
+	unsigned long	name_idx_bitmap;
+	struct cdev cdev;
+	dev_t	dev;
+};
+
+static struct rf_priv *rf_priv;
+static int rf_change_state(struct rf_ctrl_dev *rf_dev, unsigned int state);
+static int rf_attach_phy(struct rf_ctrl_dev *rf_dev, struct rf_phy_dev *phy);
+static int rf_open(struct inode *inode, struct file *filep);
+static int rf_release(struct inode *inode, struct file *filep);
+static ssize_t rf_read(struct file *, char __user *, size_t, loff_t *);
+static long rf_ioctl(struct file *, unsigned int, unsigned long);
+
+const static struct file_operations rf_fops = {
+	.open 	= rf_open,
+	.release = rf_release,
+	.read 	= rf_read,
+	.unlocked_ioctl	= rf_ioctl,
+};
+
+struct rf_ctrl_dev *allocate_rf_ctrl_dev(size_t priv_size,
+		unsigned long flags)
+{
+	struct rf_ctrl_dev *rf_dev;
+	size_t size;
+
+	size = sizeof(struct rf_ctrl_dev) + priv_size;
+	rf_dev = kzalloc(size, flags);
+
+	if (!rf_dev)
+		return rf_dev;
+
+	atomic_set(&rf_dev->ref, 1);
+	mutex_init(&rf_dev->lock);
+	init_waitqueue_head(&rf_dev->wait_q);
+	INIT_LIST_HEAD(&rf_dev->event_handler_list);
+	spin_lock_init(&rf_dev->event_handler_lock);
+	raw_spin_lock_init(&rf_dev->wait_q_lock);
+	rf_dev->priv = (unsigned char *) rf_dev + sizeof(struct rf_ctrl_dev);
+	rf_dev->dev_idx = INVAL_DEV_IDX;
+
+	return rf_dev;
+}
+EXPORT_SYMBOL(allocate_rf_ctrl_dev);
+
+int free_rf_ctrl_dev(struct rf_ctrl_dev *rf_dev)
+{
+	struct rf_event_handler *evt_handler;
+	struct list_head *list, *next;
+
+	if (!atomic_dec_and_test(&rf_dev->ref))
+		return -EBUSY;
+
+	list_for_each_safe(list, next, &rf_dev->event_handler_list) {
+		evt_handler = list_entry(list, struct rf_event_handler, list);
+		kfree(evt_handler);
+	}
+
+	kfree(rf_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL(free_rf_ctrl_dev);
+
+int register_rf_ctrl_dev(struct rf_ctrl_dev *rf_dev)
+{
+	struct rf_ctrl_ops *ctrl_ops;
+	unsigned int dev_idx;
+	unsigned long *devid_map;
+	int rc = 0;
+
+	ctrl_ops = rf_dev->ops;
+	if (!ctrl_ops || !ctrl_ops->init
+			|| !ctrl_ops->start || !ctrl_ops->stop)
+		return -EINVAL;
+
+	rf_dev->state = RF_CREATED;
+	spin_lock(&rf_priv->ctrl_lock);
+
+	devid_map = (unsigned long *)&rf_priv->name_idx_bitmap;
+	if (rf_dev->dev_idx == INVAL_DEV_IDX)
+		dev_idx = find_first_zero_bit(devid_map, 32);
+	else
+		dev_idx = rf_dev->dev_idx;
+
+	if (test_and_set_bit(dev_idx, devid_map)) {
+		pr_debug("Invalid dev_idx: %d\n", dev_idx);
+		return -EINVAL;
+	}
+	list_add_tail(&rf_dev->list, &rf_priv->ctrl_list);
+
+	spin_unlock(&rf_priv->ctrl_lock);
+	sprintf(&rf_dev->name[0], "rf%d", dev_idx);
+	rf_dev->dev_idx = dev_idx;
+	if (rf_attach_phy(rf_dev, NULL))
+		rc = rf_change_state(rf_dev, RF_PHY_ATTACHED);
+
+	return rc;
+}
+EXPORT_SYMBOL(register_rf_ctrl_dev);
+
+int unregister_rf_ctrl_dev(struct rf_ctrl_dev *rf_dev)
+{
+	struct rf_phy_dev *phy;
+	int rc = 0;
+
+	/* Notify PHY that we are going down */
+	phy = rf_dev->phy;
+
+	if (phy->ops->stop) {
+		rc = phy->ops->stop(phy);
+		if (rc) {
+			pr_debug("%s: unregister failed, phy busy\n",
+					rf_dev->name);
+			return -EBUSY;
+		}
+	}
+	rf_change_state(rf_dev, RF_DOWN);
+
+	spin_lock(&rf_priv->ctrl_lock);
+
+	clear_bit(rf_dev->dev_idx, &rf_priv->name_idx_bitmap);
+	list_del(&rf_dev->list);
+
+	spin_unlock(&rf_priv->ctrl_lock);
+
+	return rc;
+}
+EXPORT_SYMBOL(unregister_rf_ctrl_dev);
+
+struct rf_phy_dev *allocate_rf_phy_dev(size_t priv_size, unsigned long flags)
+{
+	struct rf_phy_dev *phy;
+	size_t size;
+
+	size = sizeof(struct rf_phy_dev) + priv_size;
+	phy = kzalloc(size, flags);
+	if (!phy)
+		return NULL;
+
+	phy->priv = ((unsigned char *) phy) + sizeof(struct rf_phy_dev);
+
+	return phy;
+}
+EXPORT_SYMBOL(allocate_rf_phy_dev);
+
+int free_rf_phy_dev(struct rf_phy_dev *phy)
+{
+	kfree(phy);
+
+	return 0;
+}
+EXPORT_SYMBOL(free_rf_phy_dev);
+
+int register_rf_phy_dev(struct rf_phy_dev *phy)
+{
+	struct rf_ctrl_dev *rf_ctrl_dev;
+	struct rf_phy_ops *phy_ops;
+
+	phy_ops = phy->ops;
+	if (!phy_ops || !phy_ops->init
+			|| !phy_ops->start || !phy_ops->stop)
+		return -EINVAL;
+
+	spin_lock(&rf_priv->phy_lock);
+
+	list_add_tail(&phy->list, &rf_priv->phy_list);
+
+	spin_unlock(&rf_priv->phy_lock);
+
+	if (rf_attach_phy(NULL, phy)) {
+		rf_ctrl_dev = phy->ctrl_dev;
+		rf_change_state(rf_ctrl_dev, RF_PHY_ATTACHED);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(register_rf_phy_dev);
+
+int unregister_rf_phy_dev(struct rf_phy_dev *phy)
+{
+	struct rf_ctrl_dev *rf_dev;
+	int rc;
+
+	rf_dev = phy->ctrl_dev;
+	if (rf_dev->ops->phy_detach) {
+		rc = rf_dev->ops->phy_detach(rf_dev);
+		if (rc)
+			return -EBUSY;
+		rf_dev->phy = NULL;
+		rf_change_state(rf_dev, RF_DOWN);
+	}
+	spin_lock(&rf_priv->phy_lock);
+
+	list_del(&phy->list);
+
+	spin_unlock(&rf_priv->phy_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(unregister_rf_phy_dev);
+
+int rf_change_state(struct rf_ctrl_dev *rf_dev, unsigned int new_state)
+{
+	int err = 0;
+
+	/* Save old state, so that if any operation during
+	 * state change fails then we can go back to previous
+	 * state
+	 */
+	rf_dev->old_state = rf_dev->state;
+
+	switch (new_state) {
+
+	case RF_PHY_ATTACHED:
+		if (rf_dev->state != RF_CREATED) {
+			err = -EINVAL;
+			goto out;
+		}
+		break;
+
+	case RF_PHY_INITIALIZED:
+		if (rf_dev->state < RF_PHY_ATTACHED) {
+			err = -EINVAL;
+			goto out;
+		}
+		break;
+
+	case RF_INITIALIZED:
+	case RF_SNIFFING:
+		if (rf_dev->state < RF_PHY_INITIALIZED) {
+			err = -EINVAL;
+			goto out;
+		}
+		break;
+
+	case RF_READY:
+		if ((rf_dev->state < RF_INITIALIZED) ||
+			(rf_dev->state == RF_READY)) {
+			err = -EINVAL;
+			goto out;
+		}
+		break;
+	/* By default all other state changes are allowed */
+	case RF_CREATED:
+	case RF_TIMER_SYNC_AWAITED:
+	case RF_TIMER_SYNC_FAILED:
+	case RF_STOPPED:
+	case RF_DOWN:
+		/*Fall through*/
+		break;
+	}
+
+	rf_dev->state = new_state;
+out:
+	return err;
+}
+
+int rf_attach_phy(struct rf_ctrl_dev *rf_dev, struct rf_phy_dev *phy)
+{
+	int match = 0;
+	struct rf_ctrl_dev *rf_dev_itr = NULL;
+	struct rf_phy_dev *phy_itr = NULL;
+
+	/* Search for a phy for given rf ctrl dev */
+	if (rf_dev) {
+		spin_lock(&rf_priv->phy_lock);
+
+		list_for_each_entry(phy_itr, &rf_priv->phy_list, list) {
+			if (rf_dev->phy_id == phy_itr->phy_id) {
+				match = 1;
+				rf_dev->phy = phy_itr;
+				phy_itr->ctrl_dev = rf_dev;
+				break;
+			}
+		}
+
+		spin_unlock(&rf_priv->phy_lock);
+		return match;
+	}
+
+	/* Search for a rf ctrl dev for a given phy */
+	if (phy) {
+		spin_lock(&rf_priv->ctrl_lock);
+
+		list_for_each_entry(rf_dev_itr, &rf_priv->ctrl_list, list) {
+			if (phy->phy_id == rf_dev_itr->phy_id) {
+				match = 1;
+				phy->ctrl_dev = rf_dev_itr;
+				rf_dev_itr->phy = phy;
+				break;
+			}
+		}
+
+		spin_unlock(&rf_priv->ctrl_lock);
+	}
+
+	return match;
+}
+
+int rf_notify_dl_tti(struct rf_ctrl_dev *rf_dev)
+{
+	struct rf_stats *stats;
+
+	stats = &rf_dev->stats;
+	stats->tti_count++;
+	raw_spin_lock(&rf_dev->wait_q_lock);
+	wake_up_locked(&rf_dev->wait_q);
+	raw_spin_unlock(&rf_dev->wait_q_lock);
+
+	return 0;
+}
+
+static int rf_open(struct inode *inode, struct file *filep)
+{
+	int minor, match = 0;
+	struct rf_ctrl_dev *rf_dev = NULL;
+
+	minor = iminor(inode);
+	spin_lock(&rf_priv->ctrl_lock);
+
+	list_for_each_entry(rf_dev, &rf_priv->ctrl_list, list) {
+		if (rf_dev->dev_idx == minor) {
+			match = 1;
+			break;
+		}
+	}
+
+	spin_unlock(&rf_priv->ctrl_lock);
+	if (!match) {
+		return -ENODEV;
+	} else {
+		filep->private_data = rf_dev;
+		atomic_inc(&rf_dev->ref);
+	}
+
+	return 0;
+}
+
+int rf_release(struct inode *inode, struct file *filep)
+{
+	struct rf_ctrl_dev *rf_dev;
+
+	rf_dev = filep->private_data;
+	atomic_dec(&rf_dev->ref);
+
+	return 0;
+}
+static ssize_t rf_read(struct file *filep, char __user *buf, size_t size,
+			loff_t *offset)
+{
+	struct rf_ctrl_dev *rf_dev;
+	struct rf_stats *stats;
+	wait_queue_t 	wait;
+	unsigned long flags;
+	int rc;
+
+	rf_dev = filep->private_data;
+
+	if (rf_dev->state < RF_INITIALIZED) {
+		pr_err("%s: Not initialized for TTI\n", rf_dev->name);
+		rc = -EPERM;
+		goto out;
+	}
+
+	stats = &rf_dev->stats;
+	init_waitqueue_entry(&wait, current);
+
+	/*
+	 * Spin_locks are changed to mutexes if PREEMPT_RT is enabled,
+	 * i.e they can sleep. This fact is problem for us because
+	 * add_wait_queue()/wake_up_all() takes wait queue spin lock.
+	 * Since spin lock can sleep with PREEMPT_RT, wake_up_all() can not be
+	 * called from rf_notify_dl_tti (which is called in interrupt context).
+	 * As a workaround, wait_q_lock is used for protecting the wait_q and
+	 * add_wait_queue_locked()/ wake_up_locked() functions of wait queues
+	 * are used.
+	 */
+	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
+	__add_wait_queue_tail_exclusive(&rf_dev->wait_q, &wait);
+	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
+	set_current_state(TASK_INTERRUPTIBLE);
+	/*Now wait here, tti notificaion will wake us up*/
+	schedule();
+	set_current_state(TASK_RUNNING);
+	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
+	__remove_wait_queue(&rf_dev->wait_q, &wait);
+	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
+
+	rc = put_user(stats->tti_count, (int *)buf);
+	if (!rc)
+		rc = sizeof(stats->tti_count);
+out:
+	return rc;
+}
+
+int rf_fill_dev_info(struct rf_ctrl_dev *rf_dev, struct rf_dev_info *dev_info)
+{
+	int i;
+	struct rf_phy_dev *phy;
+	struct rf_dev_params *dev_params;
+	struct rf_dev_sniffer *sniffer;
+
+	dev_params = &rf_dev->dev_params;
+
+	dev_info->state = rf_dev->state;
+
+	strncpy(dev_info->controller, rf_dev->name, RIF_NAME_SIZE);
+	if (rf_dev->state >= RF_PHY_ATTACHED) {
+		phy = rf_dev->phy;
+		strncpy(dev_info->phy, phy->name, RIF_NAME_SIZE);
+		for (i = 0; i < dev_params->ants; i++)
+			dev_info->tx_atten[i] = phy->tx_atten[i];
+		dev_info->dl_carrier_freq = phy->dl_carrier_freq;
+		dev_info->ul_carrier_freq = phy->ul_carrier_freq;
+	} else {
+		memset(dev_info->phy, 0, RIF_NAME_SIZE);
+	}
+
+	dev_info->net_mode = rf_dev->net_mode;
+	dev_info->tx_rxmode = rf_dev->tx_rxmode;
+	dev_info->bw = rf_dev->bw;
+	dev_info->timing_src = rf_dev->timing_src;
+
+	dev_info->ants = dev_params->ants;
+	dev_info->symbol_len = dev_params->symbol_len;
+	dev_info->long_cp = dev_params->long_cp;
+	dev_info->cp0_len = dev_params->cp0_len;
+	dev_info->cp1_len = dev_params->cp1_len;
+
+	dev_info->sniff_enabled = rf_dev->sniff_enabled;
+	dev_info->mode = rf_dev->mode;
+	if (rf_dev->rf_master)
+		dev_info->master_state = rf_dev->rf_master->state;
+
+	if (dev_info->sniff_enabled) {
+		sniffer = &rf_dev->sniffer;
+		dev_info->sniff_net_mode = sniffer->net_mode;
+		dev_info->sniff_tx_rxmode = sniffer->tx_rxmode;
+		dev_info->sniff_timing_src = sniffer->timing_src;
+		dev_info->sniff_bw = sniffer->bw;
+		dev_info->sniff_carrier_freq = sniffer->carrier_freq;
+	}
+
+	return 0;
+}
+
+void rf_sniffer_enabled(struct rf_ctrl_dev *rf_dev,
+	struct rf_sniff_params *sniff_params)
+{
+	struct rf_dev_sniffer *sniffer = &rf_dev->sniffer;
+	struct rf_init_params *sniff_dev_params;
+
+	rf_dev->sniff_enabled = 1;
+	sniff_dev_params = &sniff_params->dev_params;
+	sniffer->net_mode = sniff_dev_params->mode;
+	sniffer->tx_rxmode = sniff_dev_params->tx_rxmode;
+	sniffer->timing_src = sniff_params->timing_src;
+	sniffer->bw = sniff_dev_params->bw;
+	sniffer->carrier_freq = sniff_params->carrier_freq;
+}
+
+void rf_sniffer_disabled(struct rf_ctrl_dev *rf_dev)
+{
+
+	rf_dev->sniff_enabled = 0;
+}
+
+int rf_send_event(struct rf_ctrl_dev *rf_dev,
+	struct rf_event_handler *evt_handler, u16 evt)
+{
+	struct task_struct *dst_task;
+	struct siginfo *siginfo = &evt_handler->siginfo;
+	int rc = 0;
+
+	dst_task = pid_task(evt_handler->pid, PIDTYPE_PID);
+	if (!dst_task) {
+		pr_err("%s: No listener task, Failed to send evt sig\n",
+			rf_dev->name);
+		goto out;
+	}
+	siginfo->si_int = evt;
+	rc = send_sig_info(siginfo->si_signo, siginfo, dst_task);
+	if (rc) {
+		pr_err("%s: Failed to send evt sig\n",
+			rf_dev->name);
+		goto out;
+	}
+
+out:
+	return rc;
+}
+
+int rf_register_event_handler(struct rf_ctrl_dev *rf_dev,
+	struct rf_event_listener *listener)
+{
+	struct rf_event_handler *evt_handler;
+	int rc = 0;
+
+	if (!(listener->evt_mask & RF_EVT_ALL)) {
+		pr_err("%s: Unkown event %x, registration failed\n",
+			rf_dev->name, listener->evt_mask);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	evt_handler = kzalloc(sizeof(struct rf_event_handler), GFP_KERNEL);
+	if (!evt_handler) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	evt_handler->evt_mask = listener->evt_mask;
+	evt_handler->pid = task_pid(current);
+	evt_handler->siginfo.si_signo = listener->signal;
+	evt_handler->siginfo.si_errno = 0;
+	evt_handler->siginfo.si_code = SI_QUEUE;
+	spin_lock(&rf_dev->event_handler_lock);
+	list_add_tail(&evt_handler->list,
+		&rf_dev->event_handler_list);
+	spin_unlock(&rf_dev->event_handler_lock);
+
+out:
+	return rc;
+}
+
+int rf_unregister_event_handler(struct rf_ctrl_dev *rf_dev,
+		enum rf_evt_del flag)
+{
+	struct rf_event_handler *evt_handler = NULL;
+	struct task_struct *listener_task;
+	struct list_head *list, *next;
+	int rc = 0, found_evt_handler = 0;
+
+	spin_lock(&rf_dev->event_handler_lock);
+
+	list_for_each_safe(list, next, &rf_dev->event_handler_list) {
+		evt_handler = list_entry(list, struct rf_event_handler, list);
+		listener_task = pid_task(evt_handler->pid, PIDTYPE_PID);
+		if (flag == DEL_ALL_EVT) {
+			list_del(&evt_handler->list);
+			kfree(evt_handler);
+			continue;
+		}
+		if (listener_task == current) {
+			list_del(&evt_handler->list);
+			found_evt_handler = 1;
+			break;
+		}
+	}
+	spin_unlock(&rf_dev->event_handler_lock);
+
+	if (found_evt_handler)
+		kfree(evt_handler);
+
+	return rc;
+}
+
+static int rf_init_master_slave(struct rf_ctrl_dev *rf_dev,
+	struct rf_phy_dev *phy)
+{
+	int rc = 0;
+	unsigned int lane_id;
+
+	lane_id = aic_get_lane_id(rf_dev);
+
+	if (rf_dev->mode == RF_LANE_SLAVE) {
+		if (rf_dev->rf_master) {
+			if (rf_dev->rf_master->state != RF_READY) {
+				pr_err("Master of %s is not in READY"
+					" state\n", rf_dev->name);
+				rc = -EFAULT;
+				goto out;
+			}
+		} else {
+			pr_err("Master of %s is not initialized\n",
+				rf_dev->name);
+			rc = -EFAULT;
+			goto out;
+		}
+	}
+
+	rc = phy->ops->config_master_slave(lane_id, phy, rf_dev->mode);
+	if (rc)
+		goto out;
+
+out:
+	return rc;
+}
+
+static long rf_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	struct rf_ctrl_dev *rf_dev;
+	struct rf_phy_dev *phy;
+	struct rf_init_params init_params;
+	struct rif_phy_cmd_set cmd_set;
+	struct rif_reg_buf reg_buf;
+	struct rif_write_reg_buf write_reg_buf;
+	struct rif_dac_params dac_params;
+	struct rif_dac_buf dac_buff;
+	struct rf_dev_info dev_info;
+	struct rf_tx_buf tx_buf;
+	struct rf_tx_en_dis tx_en_dis;
+	struct rf_rssi rssi;
+	struct rf_rx_gain rx_gain;
+	struct rf_gain_ctrl gain_ctrl;
+	struct rf_sniff_params sniff_params;
+	struct rf_synth_table synth_table;
+	struct rf_channel_params chan_params;
+	struct rf_event_listener listener;
+	unsigned long long (*params_buf)[NUM_SYNTH_PARAMS];
+	u8 (*reg_vals_buf)[NUM_SYNTH_REGS];
+	u32	*buf;
+	u32 u32arg;
+	int rc = -ENOSYS, size;
+
+	rf_dev = filep->private_data;
+	phy = rf_dev->phy;
+
+	rc = mutex_lock_interruptible(&rf_dev->lock);
+	switch (cmd) {
+
+	case RIF_DEV_INIT:
+
+		rc = rf_init_master_slave(rf_dev, phy);
+		if (rc)
+			goto out;
+
+		if (rf_change_state(rf_dev, RF_INITIALIZED)) {
+			rc = -EPERM;
+			goto out;
+		}
+		if (copy_from_user(&init_params,
+				(struct rf_init_params *)arg,
+				sizeof(init_params))) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (phy) {
+			rc = phy->ops->init(phy, &init_params);
+			if (rc)
+				goto out;
+		}
+
+		rc = rf_dev->ops->init(rf_dev, &init_params);
+		break;
+
+	case RIF_CONFIG_SNIFF:
+
+		rc = rf_init_master_slave(rf_dev, phy);
+		if (rc)
+			goto out;
+
+		if (rf_change_state(rf_dev, RF_SNIFFING)) {
+			rc = -EPERM;
+			goto out;
+		}
+		if (copy_from_user(&sniff_params,
+				(struct rf_sniff_params *)arg,
+				sizeof(sniff_params))) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (phy && phy->ops->config_sniff) {
+			rc = phy->ops->config_sniff(phy, &sniff_params);
+			if (rc)
+				goto out;
+		}
+		if (rf_dev->ops->config_sniff)
+			rc = rf_dev->ops->config_sniff(rf_dev, &sniff_params);
+		if (!rc)
+			rf_sniffer_enabled(rf_dev, &sniff_params);
+		break;
+
+	case RIF_SET_TIMER_SOURCE:
+
+		if (rf_dev->state < RF_PHY_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		if (!get_user(u32arg, (int *)arg))
+			rc = rf_dev->ops->set_timing_source(rf_dev, u32arg);
+		else
+			rc = -EFAULT;
+		break;
+
+	case RIF_SET_TIMER_CORRECTION:
+
+		if (rf_dev->state < RF_PHY_ATTACHED) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		if (copy_from_user(&dac_params, (struct rif_dac_params *)arg,
+				sizeof(struct rif_dac_params))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		if (phy && phy->ops->set_timer_correction)
+			rc = phy->ops->set_timer_correction(phy, &dac_params);
+
+		break;
+
+	case RIF_GET_DAC_VALUE:
+
+		if (rf_dev->state < RF_PHY_ATTACHED) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		if (copy_from_user(&dac_buff, (struct rif_dac_buf *)arg,
+				sizeof(struct rif_dac_buf))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		if (phy && phy->ops->read_dac_value) {
+			rc = phy->ops->read_dac_value(phy,
+				dac_buff.correction_type, &u32arg);
+		}
+		if (copy_to_user(dac_buff.buf, &u32arg, sizeof(u32arg)))
+			rc = -EFAULT;
+
+		break;
+
+	case RIF_RUN_PHY_CMDS:
+
+		if (rf_change_state(rf_dev, RF_PHY_INITIALIZED)) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		if (!phy || !phy->ops->run_cmds)
+			goto out;
+
+		rc = -EFAULT;
+		if (!copy_from_user(&cmd_set, (struct rif_phy_cmd_set *)arg,
+				sizeof(struct rif_phy_cmd_set))) {
+			size = sizeof(struct rif_phy_cmd) * cmd_set.count;
+			buf = kzalloc(size, GFP_KERNEL);
+			if (buf) {
+				if (!copy_from_user(buf,
+						(u32 *)cmd_set.cmds, size))
+					rc = phy->ops->run_cmds(phy,
+						(struct rif_phy_cmd *)buf,
+						cmd_set.count);
+				kfree(buf);
+			} else {
+				rc = -ENOMEM;
+			}
+		}
+		break;
+
+	case RIF_EN_DIS_TX:
+		if (rf_dev->state < RF_PHY_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		if (copy_from_user(&tx_en_dis, (struct rf_tx_en_dis *)arg,
+				sizeof(struct rf_tx_en_dis))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		if (phy && phy->ops->en_dis_tx) {
+			rc = phy->ops->en_dis_tx(phy,
+						tx_en_dis.tx_if,
+						tx_en_dis.tx_cmd);
+		}
+		break;
+
+	case RIF_READ_RSSI:
+
+		if (rf_dev->state < RF_PHY_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+		if (copy_from_user(&rssi, (struct rf_rssi *)arg,
+			sizeof(struct rf_rssi))) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (phy && phy->ops->read_rssi)
+			rc = phy->ops->read_rssi(phy, &rssi);
+		if (!rc && copy_to_user((struct rf_rssi *)arg,
+					&rssi, sizeof(struct rf_rssi)))
+			rc = -EFAULT;
+		break;
+
+	case RIF_READ_PHY_REGS:
+	case RIF_READ_CTRL_REGS:
+
+		if (rf_dev->state < RF_PHY_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		if (copy_from_user(&reg_buf, (struct rif_reg_buf *)arg,
+				sizeof(struct rif_reg_buf))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		size = 4 * reg_buf.count;
+		buf = kzalloc(size, GFP_KERNEL);
+		if (!buf) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		if (cmd == RIF_READ_PHY_REGS) {
+			if (phy && phy->ops->read_regs) {
+				rc = phy->ops->read_regs(phy,
+					reg_buf.addr,
+					reg_buf.count, buf);
+			}
+		} else if (cmd == RIF_READ_CTRL_REGS) {
+			if (rf_dev->ops->read_regs) {
+				rc = rf_dev->ops->read_regs(rf_dev,
+					reg_buf.addr,
+					reg_buf.count, buf);
+			}
+		}
+		if (copy_to_user(&reg_buf.buf, buf, size))
+			rc = -EFAULT;
+		kfree(buf);
+		break;
+
+	case RIF_WRITE_PHY_REGS:
+
+		if (rf_dev->state < RF_PHY_ATTACHED) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		if (copy_from_user(&write_reg_buf,
+				(struct rif_write_reg_buf *)arg,
+				sizeof(struct rif_write_reg_buf))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		if (phy->ops->write_reg) {
+			rc = phy->ops->write_reg(phy,
+						write_reg_buf.addr,
+						write_reg_buf.data);
+		}
+
+		break;
+
+	case RIF_WRITE_CTRL_REGS:
+
+		if (rf_dev->state < RF_PHY_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		if (copy_from_user(&write_reg_buf,
+				(struct rif_write_reg_buf *)arg,
+				sizeof(struct rif_write_reg_buf))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		if (rf_dev->ops->write_reg) {
+			rc = rf_dev->ops->write_reg(rf_dev,
+						write_reg_buf.addr,
+						write_reg_buf.data);
+		}
+
+		break;
+
+	case RIF_START:
+		if (rf_change_state(rf_dev, RF_READY)) {
+			rc = -EPERM;
+			goto out;
+		}
+		if (phy) {
+			rc = phy->ops->start(phy);
+			if (rc)
+				goto out;
+		}
+		rc = rf_dev->ops->start(rf_dev);
+		break;
+
+	case RIF_STOP:
+
+		if (rf_change_state(rf_dev, RF_STOPPED)) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		rf_unregister_event_handler(rf_dev, DEL_ALL_EVT);
+
+		rc = rf_dev->ops->stop(rf_dev);
+		if (!rc && rf_dev->sniff_enabled)
+			rf_sniffer_disabled(rf_dev);
+
+		if (phy) {
+			rc = phy->ops->stop(phy);
+			if (rc)
+				goto out;
+		}
+		break;
+
+	case RIF_GET_DEV_INFO:
+		rc = rf_fill_dev_info(rf_dev, &dev_info);
+		if (copy_to_user((struct rf_dev_info *)arg,
+				&dev_info, sizeof(dev_info)))
+			rc = -EFAULT;
+		break;
+	case RIF_SET_TX_ATTEN:
+		if (rf_dev->state < RF_PHY_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+
+		if (copy_from_user(&tx_buf, (struct rf_tx_buf *)arg,
+				sizeof(struct rf_tx_buf))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		if (phy && phy->ops->set_tx_atten) {
+			rc = phy->ops->set_tx_atten(phy,
+						tx_buf.tx_if,
+						tx_buf.tx_atten);
+		}
+		break;
+
+	case RIF_READ_RX_GAIN:
+
+		if (rf_dev->state < RF_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+		if (copy_from_user(&rx_gain, (struct rf_rx_gain *)arg,
+				sizeof(struct rf_rx_gain))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		if (phy && phy->ops->get_rx_gain)
+			rc = phy->ops->get_rx_gain(phy, &rx_gain);
+
+		if (!rc && copy_to_user((struct rf_rx_gain *)arg, &rx_gain,
+					sizeof(struct rf_rx_gain)))
+			rc = -EFAULT;
+		break;
+
+	case RIF_WRITE_RX_GAIN:
+
+		if (rf_dev->state < RF_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+		if (copy_from_user(&rx_gain, (struct rf_rx_gain *)arg,
+				sizeof(struct rf_rx_gain))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		if (phy && phy->ops->set_rx_gain)
+			rc = phy->ops->set_rx_gain(phy, &rx_gain);
+		break;
+
+	case RIF_SET_GAIN_CTRL_MODE:
+
+		if (rf_dev->state < RF_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+		if (copy_from_user(&gain_ctrl, (struct rf_gain_ctrl *)arg,
+				sizeof(struct rf_gain_ctrl))) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (phy && phy->ops->set_gain_ctrl_mode)
+			rc = phy->ops->set_gain_ctrl_mode(phy, &gain_ctrl);
+		break;
+
+	case RIF_INIT_SYNTH_TABLE:
+		if (rf_dev->state < RF_PHY_INITIALIZED) {
+			rc = -EPERM;
+			goto out;
+		}
+		if (!phy->ops->save_synth_table)
+			goto out;
+
+		if (copy_from_user(&synth_table, (struct rf_synth_table *)arg,
+				sizeof(struct rf_synth_table))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		size = sizeof(unsigned long long) *
+			NUM_SYNTH_PARAMS * synth_table.count;
+		params_buf = (unsigned long long (*)[NUM_SYNTH_PARAMS])
+					kzalloc(size, GFP_KERNEL);
+		rc = 0;
+		if (params_buf) {
+			if (copy_from_user(params_buf, (unsigned long long *)
+						synth_table.params, size))
+				rc = -EFAULT;
+		} else
+			rc = -ENOMEM;
+		if (rc) {
+			kfree(params_buf);
+			goto out;
+		}
+
+		size = sizeof(u8) * NUM_SYNTH_REGS * synth_table.count;
+		reg_vals_buf = (u8 (*)[NUM_SYNTH_REGS])kzalloc(size,
+				GFP_KERNEL);
+		if (reg_vals_buf) {
+			if (copy_from_user(reg_vals_buf, (u8 *)
+					synth_table.reg_vals, size))
+				rc = -EFAULT;
+		} else
+			rc = -ENOMEM;
+		if (rc) {
+			kfree(reg_vals_buf);
+			kfree(params_buf);
+			goto out;
+		}
+
+		synth_table.params = params_buf;
+		synth_table.reg_vals = reg_vals_buf;
+		rc = phy->ops->save_synth_table(phy, &synth_table);
+		kfree(params_buf);
+		kfree(reg_vals_buf);
+
+		break;
+
+	case RIF_CHANNEL_OPEN:
+		if (rf_dev->state < RF_PHY_INITIALIZED) {
+			rc = -EINVAL;
+			goto out;
+		}
+		if (copy_from_user(&chan_params,
+				(struct rf_chan_params *)arg,
+				sizeof(chan_params))) {
+			rc = -EFAULT;
+			goto out;
+		}
+		rc = rf_channel_open(rf_dev, &chan_params);
+
+		break;
+
+	case RIF_CHANNEL_CLOSE:
+		if (get_user(u32arg, (int *)arg)) {
+			rc = -EFAULT;
+			goto out;
+		}
+		rc = rf_channel_close(rf_dev, u32arg);
+		break;
+
+	case RIF_REGISTER_EVENT:
+
+		if (copy_from_user(&listener, (struct rf_event_listener *)arg,
+				sizeof(listener))) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		rc = rf_register_event_handler(rf_dev, &listener);
+		break;
+
+	case RIF_UNREGISTER_EVENT:
+		rc = rf_unregister_event_handler(rf_dev, DEL_CUR_EVT);
+		break;
+
+	default:
+		rc = -ENOTTY;
+	}
+
+	if (!rc)
+		rf_dev->old_state = rf_dev->state;
+out:
+	if (rc)
+		rf_dev->state = rf_dev->old_state;
+	mutex_unlock(&rf_dev->lock);
+	return rc;
+}
+
+/*
+** Function: rf_mark_slave_mode()
+** Assign rfdev in SLAVE mode
+*/
+int rf_mark_slave_mode(int phy_id, struct rf_ctrl_dev *rf_dev)
+{
+	struct rf_ctrl_dev *rf_dev_itr;
+	int rc = -EINVAL;
+
+	spin_lock(&rf_priv->ctrl_lock);
+	list_for_each_entry(rf_dev_itr, &rf_priv->ctrl_list, list) {
+		if (phy_id == rf_dev_itr->phy_id) {
+			rf_dev_itr->rf_master = rf_dev;
+			rf_dev_itr->mode = RF_LANE_SLAVE;
+			rc = 0;
+			break;
+		}
+	}
+	spin_unlock(&rf_priv->ctrl_lock);
+
+	return rc;
+}
+
+struct rf_ctrl_dev *rf_get_master_rfdev(u32 phy_id)
+{
+	struct rf_ctrl_dev *rf_dev = NULL;
+
+	spin_lock(&rf_priv->ctrl_lock);
+	list_for_each_entry(rf_dev, &rf_priv->ctrl_list, list) {
+		if (rf_dev->phy_id == phy_id)
+			break;
+	}
+	spin_unlock(&rf_priv->ctrl_lock);
+
+	return rf_dev;
+}
+
+/*
+** Function: rf_assign_lane_role()
+** map_buf[i].state contains the rfdev state
+** map_buf[i].phy_id contains the phy_id associated with rfdev
+**
+** This function iterates over list of rfdev having RF_PHY_ATTACHED state
+** and assign them as MASTER/SLAVE role.The first entry in map_buf[] will be
+** assigned MASTER state and the subsequent one's will be assigned as SLAVE
+*/
+int rf_assign_lane_role(struct rf_dev_lane_map *map_buf,
+			struct rf_priv *rf_priv)
+{
+	int i, master_flag = 0, rc = 0;
+	struct rf_ctrl_dev *rf_dev = NULL;
+
+	for (i = 0; i < RF_MAX_DEVS; i++) {
+		if (map_buf[i].state == RF_PHY_ATTACHED) {
+			if (!master_flag) {
+				master_flag = 1;
+				rf_dev = rf_get_master_rfdev(map_buf[i].
+							phy_id);
+				if (!rf_dev) {
+					rc = -EFAULT;
+					goto out;
+				}
+			} else {
+				rc = rf_mark_slave_mode(map_buf[i].
+						phy_id, rf_dev);
+			}
+		}
+	}
+
+out:
+	return rc;
+}
+
+/*
+** Function: rf_update_master_slave_status()
+** Mark rf lane status
+*/
+int rf_update_master_slave_status(void)
+{
+	int rc = 0;
+	unsigned int lane_id;
+	struct rf_ctrl_dev *rf_dev;
+	struct rf_dev_lane_map map_buf[RF_MAX_DEVS];
+
+	spin_lock(&rf_priv->ctrl_lock);
+
+	list_for_each_entry(rf_dev, &rf_priv->ctrl_list, list) {
+		if (rf_dev->state == RF_PHY_ATTACHED) {
+			lane_id = aic_get_lane_id(rf_dev);
+			map_buf[lane_id].phy_id = rf_dev->phy_id;
+			map_buf[lane_id].lane_id = lane_id;
+			map_buf[lane_id].state = RF_PHY_ATTACHED;
+		}
+	}
+
+	/* At this point we have list of rfdev's present in map_buf
+	 * having RF_PHY_ATTACHED state
+	 */
+	spin_unlock(&rf_priv->ctrl_lock);
+	rc = rf_assign_lane_role(map_buf, rf_priv);
+
+	return rc;
+}
+EXPORT_SYMBOL(rf_update_master_slave_status);
+
+static int __init rf_init(void)
+{
+	int rc;
+
+	rf_priv = kzalloc(sizeof(struct rf_priv), GFP_KERNEL);
+	if (!rf_priv) {
+		pr_debug("rfdev: Unable to allocate rf_priv\n");
+		return -ENOMEM;
+	}
+
+	rc = alloc_chrdev_region(&rf_priv->dev, 0, RF_MAX_DEVS, "rfdev");
+	if (rc) {
+		pr_debug("rfdev:Failed to register rf chardev,err %d\n",
+				rc);
+		return rc;
+	}
+
+	cdev_init(&rf_priv->cdev, &rf_fops);
+	cdev_add(&rf_priv->cdev, rf_priv->dev, RF_MAX_DEVS);
+	INIT_LIST_HEAD(&rf_priv->phy_list);
+	INIT_LIST_HEAD(&rf_priv->ctrl_list);
+
+	return 0;
+}
+
+static void __exit rf_cleanup(void)
+{
+	if (rf_priv) {
+		cdev_del(&rf_priv->cdev);
+		unregister_chrdev_region(rf_priv->dev, RF_MAX_DEVS);
+		kfree(rf_priv);
+	}
+}
+
+MODULE_LICENSE("GPL v2");
+module_init(rf_init);
+module_exit(rf_cleanup);
diff --git a/include/linux/rf_channel.h b/include/linux/rf_channel.h
new file mode 100644
index 0000000..408aabf
--- /dev/null
+++ b/include/linux/rf_channel.h
@@ -0,0 +1,26 @@
+/*
+ * RF device Data channels
+ *
+ * Author: pankaj chauhan <pankaj.chauhan@freescale.com>
+ *
+ * Copyright 2011-2012 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+struct rf_frame {
+	int ant;
+	union {
+		void *buffer;
+		u32 buffer_idx;
+	} buf;
+};
+
+int rf_channel_open(struct rf_ctrl_dev *rf_dev,
+	struct rf_channel_params *chan_params);
+int rf_channel_close(struct rf_ctrl_dev *rf_dev, int ant);
+int rf_rx_frame(struct rf_ctrl_dev *rf_dev, struct rf_frame *frame);
+int rf_sniff_done(struct rf_ctrl_dev *rf_dev, int ant);
diff --git a/include/linux/rfdev.h b/include/linux/rfdev.h
new file mode 100644
index 0000000..495fa4d
--- /dev/null
+++ b/include/linux/rfdev.h
@@ -0,0 +1,250 @@
+/*
+ * RF device framework
+ *
+ * Author: pankaj chauhan <pankaj.chauhan@freescale.com>
+ *
+ * Copyright 2011-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __RFDEV_H__
+#define __RFDEV_H__
+
+#include <linux/time.h>
+#include <uapi/linux/rfdev.h>
+#include <linux/list.h>
+#include <linux/atomic.h>
+
+#define TTI_LOG_SIZE	10
+#define INVAL_DEV_IDX	(~0)
+
+enum rf_evt_del {
+	DEL_CUR_EVT,
+	DEL_ALL_EVT
+};
+
+struct rf_stats {
+	unsigned int tti_count;
+	struct timeval tti_ts[TTI_LOG_SIZE];
+};
+
+struct rf_dev_params {
+	unsigned int ants;
+	unsigned int symbol_len;
+	unsigned int long_cp;
+	unsigned int cp0_len;
+	unsigned int cp1_len;
+	/*Frame structure*/
+	unsigned int subfrm_per_frm;
+	unsigned int slots_per_subfrm;
+	unsigned int chips_per_slot;
+	unsigned int symbols_per_slot;
+	/*TDD frame structure*/
+	char tdd_dl_ul_conf[LTE_SUBFRM_PER_FRM];
+	unsigned int tdd_dwpts;
+	unsigned int tdd_uppts;
+};
+
+struct rf_dev_sniffer {
+	enum rf_network_mode 	net_mode;
+	enum rf_txrxmode 	tx_rxmode;
+	enum rf_timer_src	timing_src;
+	enum rf_band_width 	bw;
+	unsigned long carrier_freq;
+};
+
+struct rf_channel_stats {
+	int tx_frame_count;
+	int tx_err;
+	int rx_frame_count;
+	int rx_err;
+};
+
+
+/**
+ * struct rf_mmaped_bufs - Memory mapped channel buffers,
+ * They are used when channel is opened using RF_CHANNEL_MMAPED
+ * flag. User space will provide mmaped buffer in this case.
+ *
+ * @ tx/rx_base : Virtual address of tx/rx buffer base. User
+ *   space will provide the physical address while opening channel
+ *   and rfdev frame work may ioremap it to store virtual address
+ *   in tx/rx_base.
+ * @ tx/rx_phys : Physical address of tx/rx buffer base.
+ * @ tx_curr_idx : Current index at which tx data has been written.
+ * @ rx_curr_idx : Current index at which rx data has been written.
+ *
+ */
+struct rf_mmaped_bufs {
+	u32 tx_base;
+	u32 rx_base;
+	u32 tx_base_phys;
+	u32 rx_base_phys;
+	unsigned int tx_curr_idx;
+	unsigned int rx_curr_idx;
+};
+
+struct rf_channel {
+	unsigned int ant;
+	struct rf_ctrl_dev *dev;
+	void *priv;
+	raw_spinlock_t	lock;
+	u32 flags;
+	unsigned int tx_buf_size;
+	unsigned int rx_buf_size;
+	union {
+		struct rf_mmaped_bufs mmap_bufs;
+		/* For non mmaped bufs, buf queues
+		 * should be added here in this union
+		 * only
+		 */
+	} bufs;
+	struct rf_channel_stats stats;
+};
+
+struct rf_event_handler {
+	struct list_head list;
+	u16 evt_mask;
+	struct pid *pid;
+	struct siginfo siginfo;
+};
+
+
+struct rf_ctrl_dev {
+	char			name[RIF_NAME_SIZE];
+	enum rf_state		state;
+	enum rf_state		old_state;
+	enum rf_network_mode 	net_mode;
+	enum rf_txrxmode 	tx_rxmode;
+	enum rf_timer_src	timing_src;
+	enum rf_band_width 	bw;
+	enum rf_lane_mode 	mode;
+	struct rf_dev_params	dev_params;
+	struct rf_channel	*channels[MAX_NUM_ANTENNAS];
+	struct list_head	event_handler_list;
+	spinlock_t		event_handler_lock;
+	struct rf_dev_sniffer   sniffer;
+	int			sniff_enabled;
+	int			data_chans_enabled;
+	int			dev_idx;
+	u32			phy_id;
+	void 			*priv;
+	struct rf_ctrl_ops	*ops;
+	struct rf_phy_dev	*phy;
+	atomic_t		ref;
+	raw_spinlock_t		wait_q_lock;
+	wait_queue_head_t	wait_q;
+	struct list_head	list;
+	struct mutex		lock;
+	struct rf_stats		stats;
+	struct rf_ctrl_dev 	*rf_master;
+	unsigned int		frame_count0;
+	unsigned int		frame_count1;
+	int			rftimer_started;
+};
+
+struct rf_phy_dev {
+	char	name[RIF_NAME_SIZE];
+	void	*priv;
+	u32	phy_id;
+	u32	tx_atten[MAX_NUM_ANTENNAS];
+	unsigned long dl_carrier_freq;
+	unsigned long ul_carrier_freq;
+	struct	rf_phy_ops *ops;
+	struct  rf_ctrl_dev *ctrl_dev;
+	struct	list_head list;
+};
+
+enum rf_lane_active {
+	LANE_ONE,
+	LANE_TWO,
+	LANE_THREE,
+	LANE_FOUR
+};
+
+struct rf_dev_lane_map {
+	u32	phy_id;
+	unsigned int lane_id;
+	enum rf_state state;
+};
+
+struct rf_phy_ops {
+	int	(*init)(struct rf_phy_dev *phy,
+				struct rf_init_params *params);
+
+	int	(*set_timer_correction)(struct rf_phy_dev *phy,
+			 struct rif_dac_params *params);
+
+	int	(*read_dac_value)(struct rf_phy_dev *phy,
+				u32 correction_type, u32 *buf);
+
+	int	(*run_cmds)(struct rf_phy_dev *phy,
+				struct rif_phy_cmd *cmds, int count);
+
+	int	(*read_regs)(struct rf_phy_dev *phy, u32 start,
+				u32 count, u32 *buff);
+
+	int 	(*write_reg)(struct rf_phy_dev *phy, u32 reg, u32 data);
+	int	(*set_tx_atten)(struct rf_phy_dev *phy, u32 reg, u32 data);
+	int	(*en_dis_tx)(struct rf_phy_dev *phy, u32 tx_if, u32 cmd);
+	int	(*read_rssi)(struct rf_phy_dev *phy, struct rf_rssi *rssi);
+	int	(*get_rx_gain)(struct rf_phy_dev *phy,
+			struct rf_rx_gain *rx_gain);
+	int	(*set_rx_gain)(struct rf_phy_dev *phy,
+			struct rf_rx_gain *rx_gain);
+	int	(*start)(struct rf_phy_dev *phy);
+	int	(*stop)(struct rf_phy_dev *phy);
+	int	(*config_sniff) (struct rf_phy_dev *ad_phy,
+			struct rf_sniff_params *sniff_params);
+	int	(*set_gain_ctrl_mode)(struct rf_phy_dev *phy,
+			struct rf_gain_ctrl *gain_ctrl);
+	int	(*save_synth_table)(struct rf_phy_dev *phy,
+			struct rf_synth_table *synth_table);
+	int	(*config_master_slave)(unsigned int lane_id,
+			struct rf_phy_dev *phy, enum rf_lane_mode mode);
+};
+
+struct rf_ctrl_ops {
+
+	int	(*init)(struct rf_ctrl_dev *ctrl_dev,
+				struct rf_init_params *params);
+
+	int	(*set_timing_source)(struct rf_ctrl_dev *ctrl_dev,
+			unsigned int pps_src);
+
+	int	(*read_regs)(struct rf_ctrl_dev *ctrl_dev, u32 start,
+				u32 count, u32 *buff);
+
+	int 	(*write_reg)(struct rf_ctrl_dev *ctrl_dev, u32 reg, u32 data);
+	int	(*phy_detach)(struct rf_ctrl_dev *ctrl_dev);
+	int	(*start)(struct rf_ctrl_dev *ctrl_dev);
+	int	(*stop)(struct rf_ctrl_dev *ctrl_dev);
+	int	(*config_sniff) (struct rf_ctrl_dev *ctrl_dev,
+			struct rf_sniff_params *sniff_params);
+	int	(*channel_open) (struct rf_ctrl_dev *ctrl_dev,
+			struct rf_channel *chan);
+	int	(*channel_close) (struct rf_ctrl_dev *ctrl_dev,
+			struct rf_channel *chan);
+};
+
+struct	rf_ctrl_dev *allocate_rf_ctrl_dev(size_t priv_size,
+			unsigned long flags);
+int 	free_rf_ctrl_dev(struct rf_ctrl_dev *rf_dev);
+int	register_rf_ctrl_dev(struct rf_ctrl_dev *rf_dev);
+int	unregister_rf_ctrl_dev(struct rf_ctrl_dev *rf_dev);
+
+struct  rf_phy_dev *allocate_rf_phy_dev(size_t priv_size,
+		unsigned long flags);
+int	free_rf_phy_dev(struct rf_phy_dev *phy);
+int	register_rf_phy_dev(struct rf_phy_dev *phy_dev);
+int	unregister_rf_phy_dev(struct rf_phy_dev *phy_dev);
+int	rf_notify_dl_tti(struct rf_ctrl_dev *rf_dev);
+int rf_send_event(struct rf_ctrl_dev *rf_dev,
+	struct rf_event_handler *evt_handler, u16 evt);
+int	rf_update_master_slave_status(void);
+int	aic_get_lane_id(struct rf_ctrl_dev *rf_dev);
+#endif
diff --git a/include/uapi/linux/rfdev.h b/include/uapi/linux/rfdev.h
new file mode 100644
index 0000000..e420874
--- /dev/null
+++ b/include/uapi/linux/rfdev.h
@@ -0,0 +1,392 @@
+/*
+ * Copyright 2011-2012 Freescale Semiconductor, Inc.
+ *
+ * RF device framework
+ *
+ * Author: Pankaj Chauhan  <pankaj.chauhan@freescale.com>
+ *
+ *  This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the BSD-type
+ * license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the names of the copyright holders nor the names of its
+ *    contributors may be used to endorse or promote products derived from
+ *    this software without specific prior written permission.
+ *
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __RFDEV_IOCTL_H__
+#define __RFDEV_IOCTL_H__
+
+#include <linux/types.h>
+
+#define RIF_NAME_SIZE	20
+#define RF_MAX_DEVS	6
+#define MAX_NUM_ANTENNAS	4
+#define PPS_TIMEOUT		4 /* seconds */
+#define NUM_SYNTH_PARAMS	6
+#define NUM_SYNTH_REGS		12
+#define LTE_SUBFRM_PER_FRM	10
+#define TIME_SYNC_NL_GROUP	1
+
+enum rf_network_mode {
+	LTE_TDD,
+	LTE_FDD,
+	WCDMA_FDD,
+	NET_MODE_END
+};
+
+enum rf_txrxmode {
+	TXRX_1T1R,
+	TXRX_1T2R,
+	TXRX_2T2R,
+	TXRX_MODE_END
+};
+
+enum rf_band_width {
+	BW_05_MHZ,
+	BW_10_MHZ,
+	BW_15_MHZ,
+	BW_20_MHZ,
+	BW_END
+};
+
+enum spi_cmd {
+	SPI_WRITE = 1,
+	SPI_READ,
+	SPI_WAIT,
+	SPI_WAIT_BBPLL_CAL,
+	SPI_WAIT_RXCP_CAL,
+	SPI_WAIT_TXCP_CAL,
+	SPI_WAIT_RXFILTER_CAL,
+	SPI_WAIT_TXFILTER_CAL,
+	SPI_WAIT_BBDC_CAL,
+	SPI_WAIT_RFDC_CAL,
+	SPI_WAIT_TXQUAD_CAL,
+	SPI_WAIT_CALDONE,
+	SPI_END
+};
+
+enum rf_state {
+	RF_CREATED,
+	RF_PHY_ATTACHED,
+	RF_STOPPED,
+	RF_PHY_INITIALIZED,
+	RF_INITIALIZED,
+	RF_TIMER_SYNC_AWAITED,
+	RF_TIMER_SYNC_FAILED,
+	RF_READY,
+	RF_DOWN,
+	RF_SNIFFING,
+	RF_STATE_END
+};
+
+enum rf_gain_ctrl_mode {
+	RF_GAIN_MGC,
+	RF_GAIN_FASTATTACK_AGC,
+	RF_GAIN_SLOWATTACK_AGC,
+	RF_GAIN_HYBRID_AGC
+};
+
+enum tmsyn_event {
+	TIME_SYNC_EVT_NONE,           /* no event */
+	TIME_SYNC_EVT_AD_DIS,  /* admin disable/stop */
+	TIME_SYNC_EVT_AD_ENAB, /* admin enable/start */
+	TIME_SYNC_EVT_TIMEINFO_RX,  /* timing info rxed */
+	TIME_SYNC_EVT_TIMEINFO_MISS, /* timing info missed */
+	TIME_SYNC_EVT_TIMEINFO_BO /* timing info blackout */
+};
+
+struct rf_synth_table {
+	__u64 (*params)[NUM_SYNTH_PARAMS];
+	__u8 (*reg_vals)[NUM_SYNTH_REGS];
+	__u32 count;
+};
+
+enum lte_tdd_subfrms {
+	RF_LTE_TDD_DL = 1,
+	RF_LTE_TDD_UL,
+	RF_LTE_TDD_SPL,
+	RF_LTE_TDD_END
+};
+
+struct rf_init_params {
+	__u32 fq_band;
+	__u32 tdd_dl_ul_conf[LTE_SUBFRM_PER_FRM];
+	__u32 tdd_dwpts;
+	__u32 tdd_uppts;
+	__u32 tdd_gp;
+	__u32 long_cp;
+	__u32 ants;
+	__u32 capture_enabled;
+	__u64 ul_freq_khz;
+	__u64 dl_freq_khz;
+	__u16 dl_delay;
+	__u16 ul_delay;
+	__u8 mode;
+	__u8 tx_rxmode;
+	__u8 bw;
+};
+
+enum rf_timer_src {
+	RF_PPS_SRC_GPS = 1,
+	RF_PPS_SRC_RAW_GPS,
+	RF_PPS_SRC_PTP,
+	RF_PPS_SRC_NLM,
+	RF_PPS_SRC_END
+};
+
+enum rf_lane_mode {
+	RF_LANE_MASTER,
+	RF_LANE_SLAVE,
+	RF_LANE_END
+};
+
+struct rf_sniff_params {
+	struct rf_init_params dev_params;
+	__u64 carrier_freq;
+	__u32 capture_duration;
+	__u8  timing_src;
+};
+
+struct rf_dev_info {
+	__u64 sniff_carrier_freq;
+	__u64 dl_carrier_freq;
+	__u64 ul_carrier_freq;
+	__u32 sniff_enabled;
+	__u32 ants;
+	__u32 symbol_len;
+	__u32 long_cp;
+	__u32 cp0_len;
+	__u32 cp1_len;
+	__u32 tx_atten[MAX_NUM_ANTENNAS];
+	char  controller[RIF_NAME_SIZE];
+	char  phy[RIF_NAME_SIZE];
+	__u8  state;
+	__u8  master_state;
+	__u8  mode;
+	__u8  net_mode;
+	__u8  tx_rxmode;
+	__u8  bw;
+	__u8  timing_src;
+	__u8  sniff_net_mode;
+	__u8  sniff_tx_rxmode;
+	__u8  sniff_timing_src;
+	__u8  sniff_bw;
+};
+
+#define RF_CHAN_MMAPED			0x00000001
+#define RF_CHAN_DIR_TX			0x00000002
+#define RF_CHAN_DIR_RX			0x00000004
+#define RF_CHAN_XFER_MODE_LTE		0x00000008
+#define RF_CHAN_XFER_MODE_SNIFF		0x00000010
+#define RF_CHAN_PER_FRAME_EVENT		0x00000020
+#define RF_CHAN_ASYNC			0x00000040
+
+/**
+ * struct rf_channel_params: RF data channel parameters
+ * @ ant: Atnenna for which the channel will tx/rx IQ data
+ * @ flags: Channel flags, see the flag #defs
+ * @ tx_buf_size: Size of Tx buffer
+ * @ rx_buf_size: Size of Rx buffer
+ * @ tx_base_phys: Tx buffer base physical address. This is valid
+ *   in case rf channel is mmaped (RF_CHAN_MMAPED)
+ * @ rx_base_phys: Rx buffer base physical address. This is valid
+ *   in case of rf channel is mmaped (RF_CHAN_MMAPED)
+ */
+struct rf_channel_params {
+
+	__u32 ant;
+	__u32 flags;
+	__u32 tx_buf_size;
+	__u32 rx_buf_size;
+	__u32 tx_base_phys;
+	__u32 rx_base_phys;
+};
+
+struct rif_phy_cmd {
+	__u32	param1;
+	__u32	param2;
+	__u32	param3;
+	__u8	cmd;
+};
+
+struct rif_phy_cmd_set {
+	struct rif_phy_cmd *cmds;
+	__u32 count;
+};
+
+struct rif_reg_buf {
+	__u64 buf;
+	__u32 addr;
+	__u32 count;
+};
+
+struct rif_write_reg_buf {
+	__u32 addr;
+	__u32 data;
+};
+
+struct time_sync_1588_cnt {
+	__u32 high;
+	__u32 low;
+};
+
+struct time_info {
+	struct time_sync_1588_cnt time_cnt;
+	__u8 event;
+};
+
+enum tmsyn_correction_mode {
+	TMSYN_CORR_MODE_DAC,
+	TMSYN_CORR_MODE_ADDEND,
+	TMSYN_CORR_MODE_DAC_ADDEND,
+	TMSYN_CORR_END
+};
+
+struct time_sync_data {
+	struct time_info time_info;
+	__u32 lte_delay;
+	__u32 ioctl_cmd;
+	__u32 black_out_duration;
+	__u8 correction_mode;
+	__u8 sync_source;
+};
+
+struct rif_dac_params {
+	__u32 correction_type;
+	__u32 correction_value;
+};
+
+struct rif_dac_buf {
+	__u32 correction_type;
+	__u32 *buf;
+};
+
+struct rf_tx_buf {
+	__u32 tx_if;
+	__u32 tx_atten;
+};
+
+struct rf_tx_en_dis {
+	__u32 tx_if;
+	__u32 tx_cmd;
+};
+
+struct rf_rssi {
+	__u32 ant;
+	__u32 symbol;
+	__u32 preamble;
+	__s32 multiplier;
+	__u8 duration;
+};
+
+struct rf_rx_gain {
+	__u32 ant;
+	__s32 gain_db;
+	__u32 lmt_index;
+	__u32 lmt_gain;
+	__u32 lpf_gain;
+	__u32 digital_gain;
+};
+
+struct rf_gain_ctrl {
+	__u32 ant;
+	__u8 mode;
+};
+
+/* RF EVENTS: These Events are notifications
+ * sent from kernel rf device f/w to user space
+ */
+struct rf_event_listener {
+	__u16 evt_mask;
+	__u32 signal;
+};
+
+#define RF_EVT_ARG_SHIFT	0
+#define RF_EVT_ARG_MASK		0xfff
+#define RF_EVT_CHAN_SHIFT	12
+#define RF_EVT_CHAN_MASK	0x3
+#define RF_EVT_CMD_SHIFT	14
+#define RF_EVT_CMD_MASK		0xffff
+
+/* RF_EVENTS: Maximum 16 events as event bitmask is 16 bits
+ * For defining new event, pick any unused bit
+ */
+#define RF_EVT_RX_FRAME		0x0001
+#define RF_EVT_SNIFF_DONE	0x0002
+
+#define RF_EVT_ALL	(RF_EVT_RX_FRAME | RF_EVT_SNIFF_DONE)
+#define RF_MAKE_EVENT(evt, chan, arg)( \
+			((evt & RF_EVT_CMD_MASK) << RF_EVT_CMD_SHIFT) | \
+			((chan & RF_EVT_CHAN_MASK) << RF_EVT_CHAN_SHIFT) | \
+			((arg & RF_EVT_ARG_MASK) << RF_EVT_ARG_SHIFT))
+
+#define RF_EVENT_GET_CMD(evt) ((evt >> RF_EVT_CMD_SHIFT) & RF_EVT_CMD_MASK)
+#define RF_EVENT_GET_CHAN(evt) ((evt >> RF_EVT_CHAN_SHIFT) & RF_EVT_CHAN_MASK)
+#define RF_EVENT_GET_ARG(evt) ((evt >> RF_EVT_ARG_SHIFT) & RF_EVT_ARG_MASK)
+
+enum dac_correction_type {
+	FINE_CORRECTION = 1,
+	COARSE_CORRECTION,
+};
+
+#define TIMING_SYNC_INIT	0x00000001
+#define TIMING_SYNC_START	0x00000002
+#define TIMING_SYNC_STOP	0x00000004
+#define TIMING_SYNC_GET_TIME	0x00000010
+
+#define FREQ_INVALID      	0xffffffff
+#define TS_DELTA_INVALID      	0xffffffff
+#define TIMESTAMP_INVALID	0xffffffffffffffffll
+
+#define RF_MAGIC 0xEE
+#define RIF_DEV_INIT		_IOWR(RF_MAGIC, 1, struct rf_init_params)
+#define RIF_SET_TIMER_SOURCE	_IOW(RF_MAGIC, 2, unsigned int)
+#define RIF_GET_STATE		_IOR(RF_MAGIC, 3, unsigned int)
+#define RIF_SET_TIMER_CORRECTION _IOW(RF_MAGIC, 4, struct rif_dac_params)
+#define	RIF_RUN_PHY_CMDS	_IOW(RF_MAGIC, 5, struct rif_phy_cmd_set)
+#define RIF_READ_RSSI		_IOWR(RF_MAGIC, 6, struct rf_rssi)
+#define RIF_READ_PHY_REGS	_IOR(RF_MAGIC, 7, struct rif_reg_buf)
+#define RIF_READ_CTRL_REGS	_IOR(RF_MAGIC, 8, struct rif_reg_buf)
+#define RIF_START		_IO(RF_MAGIC, 9)
+#define RIF_STOP		_IO(RF_MAGIC, 10)
+#define RIF_GET_DEV_INFO	_IOWR(RF_MAGIC, 11, struct rf_dev_info)
+#define RIF_WRITE_PHY_REGS _IOR(RF_MAGIC, 12, struct rif_write_reg_buf)
+#define RIF_GET_DAC_VALUE	_IOR(RF_MAGIC, 13, struct rif_dac_buf)
+#define RIF_SET_TX_ATTEN	_IOW(RF_MAGIC, 14, struct rf_tx_buf)
+#define RIF_EN_DIS_TX		_IOW(RF_MAGIC, 15, struct rf_tx_en_dis)
+#define RIF_WRITE_CTRL_REGS 	_IOW(RF_MAGIC, 16, struct rif_write_reg_buf)
+#define RIF_READ_RX_GAIN 	_IOWR(RF_MAGIC, 17, struct rf_rx_gain)
+#define RIF_CONFIG_SNIFF 	_IOWR(RF_MAGIC, 18, struct rf_sniff_params)
+#define RIF_WRITE_RX_GAIN 	_IOW(RF_MAGIC, 19, struct rf_rx_gain)
+#define RIF_SET_GAIN_CTRL_MODE 	_IOW(RF_MAGIC, 20, struct rf_gain_ctrl)
+#define RIF_INIT_SYNTH_TABLE	_IOW(RF_MAGIC, 21, struct rf_synth_table)
+#define RIF_CHANNEL_OPEN	_IOW(RF_MAGIC, 22, struct rf_channel_params)
+#define RIF_CHANNEL_CLOSE	_IOW(RF_MAGIC, 23, unsigned int)
+#define RIF_REGISTER_EVENT	_IOW(RF_MAGIC, 24, struct rf_event_listener)
+#define RIF_UNREGISTER_EVENT	_IO(RF_MAGIC, 25)
+
+#endif
-- 
1.6.3.1



