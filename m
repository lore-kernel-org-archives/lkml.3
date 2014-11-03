Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaKCUsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:48:08 -0500
Received: from mga14.intel.com ([192.55.52.115]:55524 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbaKCUr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:47:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="616331439"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [PATCH 05/10] added media specific (MS) TCP drivers
Date: Mon,  3 Nov 2014 12:42:52 -0800
Message-Id: <1415047377-3139-6-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we handle media specific packets and transport. The MS driver
interfaces with a media agnostic (MA) driver via a series of transfer pairs.
Transfer pairs consist of a set of functions to pass MA USB packets back
and forth between MA and MS drivers. There is one transfer pair per device
endpoint and one transfer pair for control/management traffic. When the MA
driver needs to send an MA USB packet, it hands the packet off to the MS
layer where the packet is converted into an MS form and sent via TCP over
the underlying ethernet or wireless medium. When the MS driver receives a
packet, it converts it into an MA USB packet and hands it off the the MA
driver for handling.

In addition, the MS driver provides an interface to inititate connection events.
Because there are no physical MA USB ports in an MA USB host, the host must be
notified via software when a device is connected.

Lastly, the MS driver contains a number of ioctl functions that are used by a
utility to adjust medium-related driver parameters and connect or disconnect the
MA USB host and device drivers.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/mausb/drivers/mausb_ioctl.c      | 373 +++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_ioctl.h      |  99 +++++
 drivers/staging/mausb/drivers/mausb_msapi.c      | 110 ++++++
 drivers/staging/mausb/drivers/mausb_msapi.h      | 232 ++++++++++++
 drivers/staging/mausb/drivers/mausb_tcp-device.c | 147 ++++++++
 drivers/staging/mausb/drivers/mausb_tcp-host.c   | 144 ++++++++
 drivers/staging/mausb/drivers/mausb_tcp.c        | 446 +++++++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_tcp.h        | 129 +++++++
 8 files changed, 1680 insertions(+)
 create mode 100644 drivers/staging/mausb/drivers/mausb_ioctl.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_ioctl.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_msapi.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_msapi.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_tcp-device.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tcp-host.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tcp.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tcp.h

diff --git a/drivers/staging/mausb/drivers/mausb_ioctl.c b/drivers/staging/mausb/drivers/mausb_ioctl.c
new file mode 100644
index 0000000..0c6c6bd
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_ioctl.c
@@ -0,0 +1,373 @@
+/* Name:         mausb_ioctl.c
+ * Description:  ioctl functions for MA USB media specific driver
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/ioctl.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/usb/gadget.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <asm/uaccess.h>
+#include "mausb_hcd.h"
+#include "mausb_udc.h"
+#include "mausb_ioctl.h"
+
+/* #define MAUSB_PRINT_IOCTL_MAGIC */
+
+static int ma_open;
+static char message[BUFFER];
+static char *message_point;
+
+/**
+ * This function is used to send a message to the user, in other words, the
+ * calling process. It basically copies the message one byte at a time.
+ *
+ * @msg:	The message to be sent to the user.
+ * @buffer:	The buffer in which to put the message. This buffer was given to
+ *	    	us to fill.
+ */
+void to_user(char *msg, long unsigned int buffer)
+{
+	int length = (int)strlen(msg);
+	int bytes = 0;
+
+	while (length && *msg) {
+		put_user(*(msg++), (char *)buffer++);
+		length--;
+		bytes++;
+	}
+
+	put_user('\0', (char *)buffer + bytes);
+}
+
+/**
+ * This function is used to open the device file in order to read/write
+ * from/to it.
+ *
+ * @inode:	Struct with various information that is passed in when this
+ *		function is called. We don't need to use it for our purposes.
+ * @file:	The file to be opened.
+ */
+static int mausb_open(struct inode *inode, struct file *file)
+{
+	if (ma_open)
+		return -EBUSY;
+	ma_open++;
+	message_point = message;
+	try_module_get(THIS_MODULE);
+
+	return 0;
+}
+
+/**
+ * This function is used to close the device file.
+ *
+ * @inode:	Struct with various information that is passed in when this
+ *		function is called. We don't need to use it for our purposes.
+ * @file:	The file to be closed.
+ */
+static int mausb_release(struct inode *inode, struct file *file)
+{
+	ma_open--;
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+/**
+ * This function is used to read from the device file. From the perspective of
+ * the device, the user is reading information from us. This is one of the
+ * entry points to this module.
+ *
+ * @file:	The device file. We don't use it directly, but it's passed in.
+ * @buffer:	The buffer to put the message into.
+ * @length:	The max length to be read.
+ * @offset:	File offset, which we don't use but it is passed in nontheless.
+ */
+static ssize_t mausb_read(struct file *file, char __user *buffer,
+		size_t length, loff_t *offset)
+{
+	int bytes_read = 0;
+
+	if (*message_point == 0)
+		return 0;
+	while (length && *message_point) {
+		put_user(*(message_point++), buffer++);
+		length--;
+		bytes_read++;
+	}
+
+	return bytes_read;
+}
+
+/**
+ * This function is used to write to the device file. From the perspective of
+ * the device, the user is writing information to us. This is one of the
+ * entry points to this module.
+ *
+ * @file:	The device file. We don't use it directly, but it's passed in.
+ * @buffer:	The buffer that holds the message.
+ * @length:	The length of the message to be written.
+ * @offset:	File offset, which we don't use but it is passed in nontheless.
+ */
+static ssize_t mausb_write(struct file *file, const char __user *buffer,
+		size_t length, loff_t *offset)
+{
+	int i;
+
+	for (i = 0; i < length && i < BUFFER; i++)
+		get_user(message[i], buffer + i);
+	message_point = message;
+
+	return i;
+}
+
+/**
+ * This function is used to execute ioctl commands, determined by ioctl_func.
+ *
+ * @file:	  The device file. We don't use it directly, but it's passed in.
+ * @ioctl_func:	  This value determines which ioctl function will be used.
+ * @ioctl_buffer: This buffer is used to transfer data to/from the device.
+ */
+long mausb_ioctl(struct file *file, unsigned int ioctl_func,
+		unsigned long ioctl_buffer)
+{
+	int bytes = 0;
+	char *msg, *ip_addr;
+	char chr;
+	int ret, value;
+	unsigned long int  long_ret;
+
+	switch (ioctl_func) {
+	case IOCTL_SET_MSG:
+		msg = (char *)ioctl_buffer;
+		get_user(chr, msg);
+		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
+			get_user(chr, msg);
+		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
+		break;
+	case IOCTL_GET_MSG:
+		bytes = mausb_read(file, (char *)ioctl_buffer, 99, 0);
+		put_user('\0', (char *)ioctl_buffer + bytes);
+		break;
+	case IOCTL_GET_VRSN:
+		to_user(DRIVER_VERSION, ioctl_buffer);
+		break;
+	case IOCTL_GET_NAME:
+		to_user(MAUSB_NAME, ioctl_buffer);
+		break;
+	case IOCTL_GADGET_C:
+		ret = gadget_connection(1);
+		if (ret >= 0)
+			to_user("g_zero connect process complete", ioctl_buffer);
+		else
+			to_user("g_zero connect process failed", ioctl_buffer);
+		break;
+	case IOCTL_GADGET_D:
+		ret = gadget_connection(0);
+		if (ret >= 0)
+			to_user("g_zero disconnect process complete",
+				ioctl_buffer);
+		else
+			to_user("g_zero disconnect process failed",
+				ioctl_buffer);
+		break;
+	case IOCTL_MED_DELAY:
+		msg = (char *)ioctl_buffer;
+		get_user(chr, msg);
+		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
+			get_user(chr, msg);
+		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
+		if (kstrtoint((const char *)message_point, 0, &value) != 0) {
+			/* TODO: handle error */
+		}
+		ret = set_medium_delay(value);
+		sprintf(message_point, "DELAY VALUE: ms: %d, jiffies: %d\n",
+			value, ret);
+		to_user(message_point, ioctl_buffer);
+		break;
+	case IOCTL_SET_IP:
+		msg = (char *)ioctl_buffer;
+		get_user(chr, msg);
+		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
+			get_user(chr, msg);
+		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
+		ip_addr = kmalloc(strlen(message_point)+1, GFP_KERNEL);
+		if (!ip_addr) {
+			printk(KERN_ALERT "Memory allocation failed!\n");
+			break;
+		}
+		strcpy(ip_addr, message_point);
+		sprintf(message_point, "Connecting to ...\nIP Address: %s\n",
+			ip_addr);
+		to_user(message_point, ioctl_buffer);
+		kfree(ip_addr);
+		break;
+	case IOCTL_SET_PORT:
+		msg = (char *)ioctl_buffer;
+		get_user(chr, msg);
+		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
+			get_user(chr, msg);
+		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
+		if (kstrtoint((const char *)message_point, 0, &value) != 0) {
+			/* TODO: handle error */
+		}
+		ret = set_port_no(value);
+		sprintf(message_point, "PORT NUMBER:%d, Returned %i\n", value,
+			ret);
+		to_user(message_point, ioctl_buffer);
+		break;
+	case IOCTL_SET_IP_DECIMAL:
+		msg = (char *)ioctl_buffer;
+		get_user(chr, msg);
+		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
+			get_user(chr, msg);
+		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
+		if (kstrtoul((const char *)message_point, 0, &long_ret) != 0) {
+			/* TODO: handle error */
+		}
+
+		ret = set_ip_addr(long_ret);
+		sprintf(message_point, "\nDecimal Value:%lx returned %i\n",
+			long_ret, ret);
+		to_user(message_point, ioctl_buffer);
+		break;
+	case IOCTL_SET_MAC:
+		{
+			u8 *mac = kmalloc(6, GFP_KERNEL);
+			u8 *buf = (u8 __user *)ioctl_buffer;
+			int i, ret;
+			if (!mac) {
+				pr_err("Memory allocation failed!\n");
+				break;
+			}
+			ret = copy_from_user(mac, buf, 6);
+			if (ret) {
+				pr_err("copy_from_user failed\n");
+				kfree(mac);
+				break;
+			}
+			for (i = 0; i < ETH_ALEN; i++)
+				pr_info("mac[%d]=0x%x\n", i, mac[i]);
+			ret = set_mac_addr(mac);
+			if (ret)
+				pr_err("unable to set MAC addr\n");
+			kfree(mac);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * This struct creates links with our implementations of various entry point
+ * functions.
+ */
+const struct file_operations fops = {
+	.open = mausb_open,
+	.release = mausb_release,
+	.read = mausb_read,
+	.write = mausb_write,
+	.unlocked_ioctl = mausb_ioctl
+};
+
+/**
+ * Registers a character device using our device file. This function is called
+ * in the mausb_hcd_init function.
+ */
+int reg_chrdev()
+{
+	int ret;
+
+#ifdef MAUSB_PRINT_IOCTL_MAGIC
+
+	printk(KERN_DEBUG "Printing IOCTL magic numbers:\n");
+	printk(KERN_DEBUG "IOCTL_SET_MSG        = %u\n", IOCTL_SET_MSG);
+	printk(KERN_DEBUG "IOCTL_GET_MSG        = %u\n", IOCTL_GET_MSG);
+	printk(KERN_DEBUG "IOCTL_GET_VRSN       = %u\n", IOCTL_GET_VRSN);
+	printk(KERN_DEBUG "IOCTL_GET_NAME       = %u\n", IOCTL_GET_NAME);
+	printk(KERN_DEBUG "IOCTL_GADGET_C       = %u\n", IOCTL_GADGET_C);
+	printk(KERN_DEBUG "IOCTL_GADGET_D       = %u\n", IOCTL_GADGET_D);
+	printk(KERN_DEBUG "IOCTL_MED_DELAY      = %u\n", IOCTL_MED_DELAY);
+	printk(KERN_DEBUG "IOCTL_SET_IP         = %u\n", IOCTL_SET_IP);
+	printk(KERN_DEBUG "IOCTL_SET_PORT       = %u\n", IOCTL_SET_PORT);
+	printk(KERN_DEBUG "IOCTL_SET_IP_DECIMAL = %u\n", IOCTL_SET_IP_DECIMAL);
+	printk(KERN_DEBUG "IOCTL_SET_MAC        = %u\n", IOCTL_SET_MAC);
+
+#endif
+
+	ret = register_chrdev(MAJOR_NUM, MAUSB_NAME, &fops);
+
+	if (ret < 0)
+		printk(KERN_ALERT "Registering mausb failed with %d\n", ret);
+	else
+		printk(KERN_INFO "%s registeration complete. Major device"
+			" number %d.\n", MAUSB_NAME, MAJOR_NUM);
+
+	return ret;
+}
+
+/**
+ * Unregisters the character device when the hcd is unregistered. As hinted,
+ * this function is called in the mausb_hcd_exit function.
+ */
+void unreg_chrdev()
+{
+	unregister_chrdev(MAJOR_NUM, MAUSB_NAME);
+}
diff --git a/drivers/staging/mausb/drivers/mausb_ioctl.h b/drivers/staging/mausb/drivers/mausb_ioctl.h
new file mode 100644
index 0000000..0f26988
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_ioctl.h
@@ -0,0 +1,99 @@
+/* Name:         mausb_ioctl.h
+ * Description:  header file for MA USB ioctl functions
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef MAUSB_IOCTL_H
+#define MAUSB_IOCTL_H
+
+#define BUFFER 80
+#define DRIVER_VERSION "Alpha 0.0.25"
+#define MAJOR_NUM 100
+
+/* These define the ioctl functions that can be used. */
+#define IOCTL_SET_MSG _IOR(MAJOR_NUM, 0, char *)
+#define IOCTL_GET_MSG _IOR(MAJOR_NUM, 1, char *)
+#define IOCTL_GET_VRSN _IOR(MAJOR_NUM, 2, char *)
+#define IOCTL_GET_NAME _IOR(MAJOR_NUM, 3, char *)
+#define IOCTL_GADGET_C _IOR(MAJOR_NUM, 4, char *)
+#define IOCTL_GADGET_D _IOR(MAJOR_NUM, 5, char *)
+#define IOCTL_MED_DELAY _IOR(MAJOR_NUM, 6, char *)
+#define IOCTL_SET_IP _IOR(MAJOR_NUM, 7, char *)
+#define IOCTL_SET_PORT _IOR(MAJOR_NUM, 8, char *)
+#define IOCTL_SET_IP_DECIMAL _IOR(MAJOR_NUM, 9, char *)
+#define IOCTL_SET_MAC _IOR(MAJOR_NUM, 10, char *)
+
+/* This is the location where the device file will be created. It is used to
+ * read/write to in order to communicate to and from the device. */
+#define DEVICE_FILE_NAME "/dev/mausb"
+
+/* MAC address length */
+#define ETH_ALEN 6
+
+/* forward declarations */
+struct mausb_udc;
+struct mausb_hcd;
+
+/* Functions for register/unregistering the character device */
+int reg_chrdev(void);
+void unreg_chrdev(void);
+
+/* Medium-defined functions */
+int set_medium_delay(int delay);
+int set_ip_addr(unsigned long in_addr);
+int set_port_no(int port_no);
+int set_mac_addr(unsigned char mac_addr[ETH_ALEN]);
+int gadget_connection(int on);
+
+#endif
diff --git a/drivers/staging/mausb/drivers/mausb_msapi.c b/drivers/staging/mausb/drivers/mausb_msapi.c
new file mode 100644
index 0000000..9dd8fa5
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_msapi.c
@@ -0,0 +1,110 @@
+/* Name:	mausb_msapi.c
+ * Description: This file contains helper functions for using the msapi.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/slab.h>
+#include <linux/uio.h>
+#include "mausb_msapi.h"
+
+int mausb_transfer_packet(struct ms_pkt *pkt,
+	struct mausb_pkt_transfer *transfer)
+{
+	return transfer->transfer_packet(pkt, transfer->context);
+}
+EXPORT_SYMBOL(mausb_transfer_packet);
+
+/**
+ * Frees the given ms_pkt and associated buffers. This function is not
+ * necessary to use the API, but could be useful on both sides of the interface.
+ */
+void mausb_free_ms_pkt(struct ms_pkt *pkt)
+{
+	int i;
+	void *current_buf;
+
+	for (i = 0; i < pkt->nents; ++i) {
+		current_buf = pkt[i].kvec->iov_base;
+		if (NULL != current_buf) {
+			kfree(current_buf);
+		} else {
+			printk(KERN_DEBUG "%s: cannot find buffer for "
+				"kvec #%i in ms_pkt at %p\n",
+				__func__, i, pkt->kvec);
+		}
+	}
+
+	kfree(pkt);
+
+	return;
+}
+EXPORT_SYMBOL(mausb_free_ms_pkt);
+
+/**
+ * Calculates the total length of the data in a ms_pkt. Returns the total
+ * length of the data in the ms_pkt, or a negative errno.
+ */
+int mausb_ms_pkt_length(struct ms_pkt *pkt)
+{
+	int i;
+	int total_length = 0;
+
+	for (i = 0; i < pkt->nents; ++i)
+		total_length += pkt[i].kvec->iov_len;
+
+	printk(KERN_DEBUG "%s: total *kvec length: %i\n", __func__,
+		total_length);
+
+	return total_length;
+}
diff --git a/drivers/staging/mausb/drivers/mausb_msapi.h b/drivers/staging/mausb/drivers/mausb_msapi.h
new file mode 100644
index 0000000..7a9c30c
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_msapi.h
@@ -0,0 +1,232 @@
+/* Name:	mausb_msapi.h
+ * Description: This header describes how the media agnostic driver
+ *              interfaces with a media specific driver.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/********************** Initial MS Registration **********************/
+
+/* The MS driver must initially register with the MA driver to make the
+ * inital connection. this is done via a call to mausb_register_ms_driver
+ * (see mausb_hcd.c for details)
+ */
+
+/************************ Packet Send/Recieve ************************/
+
+/* Packets are transferred between the MS and the MA driver via function
+ * calls into each other. When the MA driver has a packet to send out, it
+ * makes a function call into the MS driver with the packet it wishes to
+ * send. Likewise, the MS driver calls into the MA driver if it needs to
+ * pass it a packet.
+ */
+
+/********************** Transfer Pair Add/Remove *********************/
+
+/*
+ * The MA driver establishes a new transfer pair for every independant
+ * connection (ie: one for every independant endpoint, as well as one
+ * for every device). To establish a new connection, the MA driver
+ * calls into the MS driver with an incomplete mausb_transfer_pair.
+ * this incomplete pair includes only the data needed to call into
+ * the MA driver.
+ */
+
+#ifndef __MAUSB_MSAPI_H
+#define __MAUSB_MSAPI_H
+
+#include <linux/uio.h>
+
+/**
+ * Offset in Bytes of location of length field - streaming mediums need to
+ * know where the length field is in a packet so they can determine where
+ * packets begin and end in the stream.
+ */
+#define MAUSB_PKT_LENGTH_OFFSET 2
+ 
+/* the largest number of segments that will ever be in a mausb packet */
+#define MAUSB_PKT_MAX_NR_SEGS 3
+
+/* This is a convenience structure for keeping the number of entries in
+ * the kvec with its pointer.
+ *
+ * @kvec:	The pointer to the ma_pkt kvec or iovec.
+ * @nents:	The number of entires in the ma_pkt kvec or iovec.
+ */
+struct ms_pkt {
+	union {
+		struct kvec kvec[MAUSB_PKT_MAX_NR_SEGS];
+		struct iovec iovec[MAUSB_PKT_MAX_NR_SEGS];
+	};
+	int nents;
+};
+
+
+/**
+ * This struct defines a one way connection for passing packets from one
+ * driver to the other.
+ *
+ * @transfer_packet:	The function call to use when you want to transmit
+ *                   	a packet.
+ * @context:		The context to use in the function when calling the
+ *           		transfer packet.
+ */
+struct mausb_pkt_transfer {
+	int (*transfer_packet)(struct ms_pkt *pkt, void *context);
+	void *context;
+};
+
+int mausb_transfer_packet(struct ms_pkt *pkt,
+	struct mausb_pkt_transfer *transfer);
+
+/**
+ * This struct defines a pair of connections to and from an independant
+ * endpoint or device.
+ *
+ * @to_ma:	The transfer to use when passing a packet to the MA driver
+ *         	from the MS driver.
+ * @to_ms:	The transfer to use when passing a packet to the MS driver
+ *         	from the MA driver.
+ * @pkt_sent: 	Packet completion routine. Called by the MS driver into
+ *            	the MA driver after the packet has been put onto the medium.
+ * @handle: 	A unique identifier for this particualar transfer pair.
+ *          	In our implementation, we use the EP/Device Handle.
+ *		For the management channel, set handle to MAUSB_MGMT_HANDLE.
+ */
+
+#define MAUSB_MGMT_HANDLE 0
+
+struct mausb_transfer_pair {
+	struct mausb_pkt_transfer to_ma;
+	struct mausb_pkt_transfer to_ms;
+	void                    (*pkt_sent)(struct ms_pkt *pkt);
+	unsigned int              handle;
+};
+
+struct urb;
+
+/**
+ * This struct defines all the calls the MA USB-HCD Driver can make
+ * to a media specific driver.
+ *
+ * @add_transfer_pair:	Used to establish a new transfer pair.
+ *       @tx_pair [IN/OUT]:	An incomplete transfer pair. The MA driver
+ *                          	completes the to_ma field and passes it to
+ *				the MA driver. The MS driver fills the
+ *				to_ma field and returns the pointer.
+ * @drop_transfer_pair: Used to remove an existing transfer pair.
+ *       @handle  [IN]:		The unique identifier of the transfer pair
+ *				to remove.
+ * @pkt_destructor: 	Used to destroy a packet that was received from
+ *			the medium. Acts as a hook to allow the medium to
+ *			free any media specific data for a packet.
+ *       @pkt [IN]		The packet the MA driver wishes to free.
+ */
+struct mausb_ms_ops {
+	int  (*add_transfer_pair)(struct mausb_transfer_pair *tx_pair);
+	int  (*drop_transfer_pair)(unsigned long handle, void *context);
+	void (*pkt_destructor)(struct ms_pkt *pkt);
+};
+
+/**
+ * This struct defines all of the media-specific parameters needed by
+ * the MA driver.
+ *
+ * TODO: add spec-defined and implementation-specific variables
+ */
+struct mausb_ms_params {
+
+
+};
+
+/**
+ * This structure includes all of the data needed by the MA driver to
+ * communicate with the Media Specific Driver.
+ *
+ * @ops:	Contains function pointers to all of the functions the
+ *		MA driver will ever need to call.
+ * @params:	Contains all of the media-specific paramaters that the
+ *		MA driver needs.
+ */
+struct mausb_ms_drv {
+	struct mausb_ms_ops *ops;
+	struct mausb_ms_params *params;
+};
+
+/**
+ * This structure includes all of the ways the Media Specific Driver
+ * is capable of calling to the Media Agnostic Driver.
+ *
+ * @device_connect:	Called to indicate that a device has been connected
+ *			and is ready to receive MA packets.
+ * @pkt_dmux:		Used for passing packets into the driver. It will
+ *			parse the packet to determine what endpoint/device
+ *			it belongs to. Used when the medium cannot keep
+ *			data channels seperate.
+ * @pkt_sent:		Used as a notification that a packet has been sent
+ *			out.
+ */
+struct mausb_ma_drv {
+	int (*device_connect)(int);
+	struct mausb_pkt_transfer pkt_dmux;
+	/* TODO: implement pkt_sent indicator */
+	/* void (*pkt_sent)(struct ms_pkt *pkt); */
+};
+
+/* function declarations */
+struct mausb_ma_drv *mausb_register_ms_driver(struct mausb_ms_drv *drv);
+struct mausb_ma_drv *maudc_register_ms_driver(struct mausb_ms_drv *drv);
+void mausb_free_ms_pkt(struct ms_pkt *pkt);
+int mausb_ms_pkt_length(struct ms_pkt *pkt);
+
+#endif
diff --git a/drivers/staging/mausb/drivers/mausb_tcp-device.c b/drivers/staging/mausb/drivers/mausb_tcp-device.c
new file mode 100644
index 0000000..28978a0
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_tcp-device.c
@@ -0,0 +1,147 @@
+/* Name:	mausb_tcp-device.c
+ * Description: The device side media specific driver to allow media agnostic
+ *               packets over tcp/ip.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+
+#include "mausb_tcp.h"
+#include "mausb_ioctl.h"
+
+struct mausb_tcp_medium *dev_tcp_medium;
+
+int mausb_tcp_device_thread(void *data)
+{
+	return mausb_tcp_receive_loop(dev_tcp_medium);
+}
+
+int mausb_tcp_device_add_tx_pair(struct mausb_transfer_pair *ma_pair)
+{
+	return mausb_tcp_add_tx_pair(ma_pair, dev_tcp_medium);
+}
+
+static struct mausb_ms_ops ms_ops = {
+	.add_transfer_pair = &mausb_tcp_device_add_tx_pair,
+	.drop_transfer_pair = &mausb_tcp_drop_tx_pair,
+	.pkt_destructor = &mausb_free_ms_pkt
+};
+
+static struct mausb_ms_drv ms_driver = {
+	.ops =  &ms_ops
+};
+
+static int mausb_tcp_device_connect(int on)
+{
+	int ret;
+
+	if (on && dev_tcp_medium->socket == NULL) {
+		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			&dev_tcp_medium->socket);
+
+		if (0 > ret) /* TODO: real errorchecking */
+			return ret;
+
+		do {
+			ret = kernel_connect(dev_tcp_medium->socket,
+				&dev_tcp_medium->addr,
+				sizeof(dev_tcp_medium->addr_in), O_RDWR);
+			printk(KERN_DEBUG "%s:kernel_connect returned %i\n",
+				__func__, ret);
+
+			if (0 > ret) {
+				/* poll until we can connect sucessfully */
+				msleep(MAUSB_TCP_DEV_CONNECT_POLL_MS);
+			}
+
+
+		} while (0 > ret);
+
+		/*spawn off a listening thread */
+		dev_tcp_medium->recv_task = kthread_run(mausb_tcp_device_thread,
+			NULL, "mausb_tcp_device_thread");
+	}
+
+	ret = dev_tcp_medium->ma_driver->device_connect(on);
+
+	return ret;
+}
+
+int mausb_tcp_device_init(void)
+{
+	dev_tcp_medium = alloc_init_mausb_tcp_medium(MAUSB_TCP_DEV);
+	if (NULL == dev_tcp_medium)
+		return -ENOMEM;
+
+	dev_tcp_medium->addr_in.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+
+	dev_tcp_medium->connect = &mausb_tcp_device_connect;
+
+	dev_tcp_medium->ma_driver = maudc_register_ms_driver(&ms_driver);
+
+
+	return 0;
+}
+module_init(mausb_tcp_device_init);
+
+void mausb_tcp_device_exit(void)
+{
+	free_mausb_tcp_medium(dev_tcp_medium, MAUSB_TCP_DEV);
+}
+module_exit(mausb_tcp_device_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("mausb_tcp_device");
diff --git a/drivers/staging/mausb/drivers/mausb_tcp-host.c b/drivers/staging/mausb/drivers/mausb_tcp-host.c
new file mode 100644
index 0000000..0302031
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_tcp-host.c
@@ -0,0 +1,144 @@
+/* Name:	mausb_tcp-host.c
+ * Description: The host side media specific driver to allow media agnostic
+ *              packets over tcp/ip.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+
+#include "mausb_tcp.h"
+
+struct mausb_tcp_medium *host_tcp_medium;
+
+int mausb_tcp_host_thread(void *data)
+{
+	return mausb_tcp_receive_loop(host_tcp_medium);
+}
+
+int mausb_tcp_host_add_tx_pair(struct mausb_transfer_pair *ma_pair)
+{
+	return mausb_tcp_add_tx_pair(ma_pair, host_tcp_medium);
+}
+
+static struct mausb_ms_ops ms_ops = {
+	.add_transfer_pair = &mausb_tcp_host_add_tx_pair,
+	.drop_transfer_pair = &mausb_tcp_drop_tx_pair,
+	.pkt_destructor = &mausb_free_ms_pkt
+};
+
+static struct mausb_ms_drv ms_driver = {
+	.ops =  &ms_ops
+};
+
+static int mausb_tcp_host_connect(int on)
+{
+	int ret;
+
+	if (on) {
+		ret = kernel_bind(host_tcp_medium->setup_socket,
+			&host_tcp_medium->addr,
+			sizeof(host_tcp_medium->addr_in));
+
+		ret = kernel_listen(host_tcp_medium->setup_socket,
+			MAUSB_TCP_MAX_NUM_CHANNELS);
+		printk(KERN_DEBUG "%s: kernel_listen returned %i\n",
+			__func__, ret);
+
+		ret = kernel_accept(host_tcp_medium->setup_socket,
+				    &host_tcp_medium->socket, 0);
+		printk(KERN_DEBUG "%s:kernel_accept returned %i\n",
+			__func__, ret);
+
+		if (0 > ret)
+			return ret;
+
+		if (NULL == host_tcp_medium->recv_task) {
+			host_tcp_medium->recv_task = kthread_run(
+				mausb_tcp_host_thread, NULL,
+				"mausb_tcp_host_thread");
+		}
+	}
+
+	ret = host_tcp_medium->ma_driver->device_connect(on);
+
+	return ret;
+}
+
+int mausb_tcp_host_init(void)
+{
+	host_tcp_medium = alloc_init_mausb_tcp_medium(MAUSB_TCP_HOST);
+	if (NULL == host_tcp_medium)
+		return -ENOMEM;
+
+	host_tcp_medium->addr_in.sin_addr.s_addr = htonl(0);
+
+	host_tcp_medium->connect = &mausb_tcp_host_connect;
+
+	host_tcp_medium->ma_driver = mausb_register_ms_driver(&ms_driver);
+
+	return 0;
+
+}
+module_init(mausb_tcp_host_init);
+
+void mausb_tcp_host_exit(void)
+{
+	free_mausb_tcp_medium(host_tcp_medium, MAUSB_TCP_HOST);
+}
+module_exit(mausb_tcp_host_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("mausb_tcp_host");
diff --git a/drivers/staging/mausb/drivers/mausb_tcp.c b/drivers/staging/mausb/drivers/mausb_tcp.c
new file mode 100644
index 0000000..291139e
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_tcp.c
@@ -0,0 +1,446 @@
+/* Name:	mausb_tcp.c
+ * Description: This is a driver used to connect an MA USB driver to a tcp
+ *              socket.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/module.h>
+#include <linux/uio.h>
+#include <linux/delay.h>
+
+#include "mausb_ioctl.h"
+#include "mausb_tcp.h"
+
+struct mausb_tcp_medium *tcp_medium[MAUSB_TCP_NUM_MODS];
+
+static int gadget_connect_thread(void *data_p)
+{
+	struct mausb_connect_data *data = data_p;
+	int ret;
+
+	printk(KERN_DEBUG "%s: Running thread #%i\n", __func__, data->i);
+
+	ret = tcp_medium[data->i]->connect(data->on);
+
+	printk(KERN_DEBUG "%s: Thread #%i complete, returing with value %i\n",
+		__func__, data->i, ret);
+
+	kfree(data);
+
+	return ret;
+}
+
+/* for IOCTL */
+int gadget_connection(int on)
+{
+	int i;
+
+	struct mausb_connect_data *data;
+
+	/* make all the calls */
+	for (i = 0; i < MAUSB_TCP_NUM_MODS; ++i) {
+
+		if (NULL != tcp_medium[i] &&
+			NULL != tcp_medium[i]->ma_driver) {
+
+			data = kzalloc(sizeof(*data), GFP_KERNEL);
+			if (NULL == data)
+				return -ENOMEM;
+
+			data->task = NULL;
+			data->on = on;
+			data->i = i;
+
+			printk(KERN_DEBUG "%s: spawning thread #%i\n",
+				__func__, i);
+
+			data->task = kthread_run(gadget_connect_thread,
+				data, "mausb_connect_thread_%i", i);
+		}
+	}
+
+	return 0;
+}
+
+/* for IOCTL */
+int set_medium_delay(int delay)
+{
+	printk(KERN_DEBUG "%s: ERROR: cannot set latency of real medium\n",
+		__func__);
+	return -EINVAL;
+}
+
+int set_port_no(int port)
+{
+	int ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < MAUSB_TCP_NUM_MODS; ++i) {
+		if (NULL != tcp_medium[i]) {
+			tcp_medium[i]->addr_in.sin_port = htons(port);
+			ret = port;
+		}
+	}
+
+	return ret;
+}
+
+int set_ip_addr(unsigned long in_addr)
+{
+	int ret = -EINVAL;
+	int i;
+	struct in_addr addr;
+
+	addr.s_addr = htonl(in_addr);
+
+	for (i = 0; i < MAUSB_TCP_NUM_MODS; ++i) {
+		if (NULL != tcp_medium[i]) {
+			tcp_medium[i]->addr_in.sin_addr = addr;
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+int set_mac_addr(unsigned char mac_addr[ETH_ALEN])
+{
+	printk(KERN_DEBUG "%s: ERROR: cannot set mac address for TCP\n",
+		__func__);
+	return -EINVAL;
+}
+
+inline void *mausb_tcp_to_context(struct mausb_tcp_medium *medium)
+{
+	return (void *) medium;
+}
+EXPORT_SYMBOL(mausb_tcp_to_context);
+
+inline struct mausb_tcp_medium *mausb_context_to_tcp(void *context)
+{
+	return (struct mausb_tcp_medium *) context;
+}
+EXPORT_SYMBOL(mausb_context_to_tcp);
+
+static void mausb_tcp_init_msg(struct msghdr *msg)
+{
+	msg->msg_name = NULL;
+	msg->msg_namelen = 0;
+	msg->msg_control = NULL;
+	msg->msg_controllen = 0;
+	msg->msg_flags = 0;
+}
+
+static int mausb_tcp_enqueue(struct ms_pkt *pkt, void *context)
+{
+	struct msghdr msg;
+	struct mausb_tcp_medium *tcp_medium;
+	int total_length = 0;
+	int ret = 0;
+	int i;
+
+	mausb_tcp_init_msg(&msg);
+
+	if (NULL == context) {
+		printk(KERN_DEBUG "%s: ERROR: null context\n", __func__);
+		return -EINVAL;
+	}
+	tcp_medium = mausb_context_to_tcp(context);
+
+	if (NULL == tcp_medium->socket) {
+		printk(KERN_DEBUG "%s: ERROR: no socket for packet\n",
+			__func__);
+		return -ENOTCONN;
+	}
+
+	for (i = 0; i < pkt->nents; ++i) {
+		total_length += pkt->kvec[i].iov_len;
+	}
+
+	ret = kernel_sendmsg(tcp_medium->socket, &msg, pkt->kvec, pkt->nents,
+		total_length);
+
+	printk(KERN_DEBUG "%s: sent %i bytes\n", __func__, ret);
+
+	/*
+	 * TODO: implement completion (pkt_sent) callback
+	 * if (NULL != tcp_medium->tx_pair.pkt_sent && 0 < ret)
+	 * tcp_pair->tx_pair.pkt_sent(pkt);
+	 */
+
+	return ret;
+}
+
+static int mausb_tcp_receive_packet(struct mausb_tcp_medium *tcp_medium,
+		struct msghdr *msg, struct ms_pkt *pkt)
+{
+	struct kvec kvec;
+	int data_rcvd;
+	int total_rcvd = 0;
+	__u16 length;
+	void *buf;
+
+	buf = kmalloc(MAUSB_TCP_BUF_SIZE, GFP_KERNEL);
+	if (NULL == buf)
+		return -ENOMEM;
+
+	kvec.iov_base = buf;
+	kvec.iov_len = MAUSB_TCP_BUF_SIZE;
+
+	/* receive the first DWORD to determine length */
+	data_rcvd = kernel_recvmsg(tcp_medium->socket, msg, &kvec, 1,
+					sizeof(__u32), MSG_DONTWAIT);
+
+	while (data_rcvd == -EAGAIN && !kthread_should_stop()) {
+		/* sleep to prevent excessive polling */
+		msleep(10);
+
+		/* receive the first DWORD to determine length */
+		data_rcvd = kernel_recvmsg(tcp_medium->socket, msg, &kvec,
+				1, sizeof(__u32), MSG_DONTWAIT);
+	}
+
+	if (0 > data_rcvd) {
+		printk(KERN_DEBUG "%s: ERROR: Could not read packet length"
+			" (error #%i)\n", __func__, data_rcvd);
+		kfree(buf);
+		return data_rcvd;
+	}
+
+	/* the data is invalid */
+	if (sizeof(__u32) > data_rcvd) {
+		printk(KERN_DEBUG "%s: ERROR: did not read enough data"
+			" to get length (received %i bytes)\n", __func__,
+			data_rcvd);
+		kfree(buf);
+		return -EINVAL;
+	}
+
+	length = le16_to_cpu(*((__le16 *)(buf + MAUSB_PKT_LENGTH_OFFSET)));
+	total_rcvd += data_rcvd;
+
+	/* make sure length is valid */
+	if (length < sizeof(__u32)) {
+		printk(KERN_DEBUG "%s: ERROR: length field too small (%u)\n",
+			 __func__, length);
+		kfree(buf);
+		return -EINVAL;
+	}
+
+	/* receive the remainder of the packet */
+	while (total_rcvd < length && total_rcvd >= 0 &&
+		!kthread_should_stop()) {
+
+		data_rcvd = kernel_recvmsg(tcp_medium->socket, msg, &kvec,
+			1, length - total_rcvd, 0);
+
+		if (0 < data_rcvd) {
+			total_rcvd += data_rcvd;
+
+		} else if (0 > data_rcvd) {
+			printk(KERN_DEBUG "%s: ERROR: while receiving packet "
+			"(err #%i)\n", __func__, data_rcvd);
+			kfree(buf);
+			return data_rcvd;
+		}
+	}
+
+	if (total_rcvd != length) {
+		printk(KERN_DEBUG "%s: Warning: did not receive enough data "
+			"(length:%u, received:%i)\n", __func__,
+			length, total_rcvd);
+	}
+
+
+	pkt->nents = 1;
+	pkt->kvec[0].iov_base = buf;
+	pkt->kvec[0].iov_len = total_rcvd;
+
+	return total_rcvd;
+}
+
+int mausb_tcp_receive_loop(struct mausb_tcp_medium *tcp_medium)
+{
+	struct msghdr msg;
+	struct ms_pkt *pkt;
+	int data_rcvd = 0;
+
+	mausb_tcp_init_msg(&msg);
+
+	while (!kthread_should_stop()) {
+
+		pkt = kzalloc(sizeof(struct ms_pkt), GFP_KERNEL);
+
+		printk(KERN_DEBUG "%s: preparing to receive data\n",
+			__func__);
+
+		data_rcvd = mausb_tcp_receive_packet(tcp_medium, &msg, pkt);
+
+		if (0 >= data_rcvd) {
+			printk(KERN_DEBUG "%s: received no data (err %i)\n",
+				__func__, data_rcvd);
+
+			sock_release(tcp_medium->socket);
+			return data_rcvd;
+
+		} else {
+			printk(KERN_DEBUG "%s: received %i bytes\n",
+				__func__, data_rcvd);
+		}
+
+		if (data_rcvd > 0) {
+			mausb_transfer_packet(pkt,
+				&tcp_medium->ma_driver->pkt_dmux);
+		}
+
+		data_rcvd = 0;
+	}
+
+	sock_release(tcp_medium->socket);
+
+	return 0;
+}
+EXPORT_SYMBOL(mausb_tcp_receive_loop);
+
+int mausb_tcp_add_tx_pair(struct mausb_transfer_pair *ma_pair,
+	struct mausb_tcp_medium *medium)
+{
+	ma_pair->to_ms.transfer_packet = &mausb_tcp_enqueue;
+	ma_pair->to_ms.context = mausb_tcp_to_context(medium);
+
+	return 0;
+}
+EXPORT_SYMBOL(mausb_tcp_add_tx_pair);
+
+int mausb_tcp_drop_tx_pair(unsigned long handle, void *context)
+{
+	/* TODO: something here */
+
+	return 0;
+}
+EXPORT_SYMBOL(mausb_tcp_drop_tx_pair);
+
+/**
+ * initialization function
+ */
+struct mausb_tcp_medium *alloc_init_mausb_tcp_medium(
+	enum mausb_tcp_module_type type)
+{
+	struct mausb_tcp_medium *medium;
+	int ret;
+
+	printk(KERN_DEBUG "%s\n", __func__);
+
+	medium = kzalloc(sizeof(struct mausb_tcp_medium), GFP_KERNEL);
+	if (NULL == medium) {
+		printk(KERN_DEBUG "%s: memory allocation failed\n", __func__);
+		return NULL;
+	}
+
+	ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
+		&medium->setup_socket);
+
+	medium->addr_in.sin_family = AF_INET;
+	medium->addr_in.sin_port = htons(MAUSB_TCP_PORT_HOST);
+
+	spin_lock_init(&medium->lock);
+
+	tcp_medium[type] = medium;
+
+	return medium;
+}
+EXPORT_SYMBOL(alloc_init_mausb_tcp_medium);
+
+/**
+ * exit function
+ */
+void free_mausb_tcp_medium(struct mausb_tcp_medium *medium,
+	enum mausb_tcp_module_type type)
+{
+	if (medium->recv_task)
+		kthread_stop(medium->recv_task);
+
+	if (medium->setup_socket)
+		sock_release(medium->setup_socket);
+
+	tcp_medium[type] = NULL;
+
+	kfree(medium);
+}
+EXPORT_SYMBOL(free_mausb_tcp_medium);
+
+int mausb_tcp_core_init(void)
+{
+	int ret;
+
+	ret = reg_chrdev();
+	if (0 > ret) {
+		printk(KERN_DEBUG "%s: reg_chrdev() failed\n",
+			__func__);
+	}
+
+	return ret;
+
+}
+module_init(mausb_tcp_core_init);
+
+void mausb_tcp_core_exit(void)
+{
+	unreg_chrdev();
+}
+module_exit(mausb_tcp_core_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("mausb_tcp_core");
diff --git a/drivers/staging/mausb/drivers/mausb_tcp.h b/drivers/staging/mausb/drivers/mausb_tcp.h
new file mode 100644
index 0000000..879a7fa
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_tcp.h
@@ -0,0 +1,129 @@
+/* Name: mausb_tcp.h
+ * Description: header file for mausb_tcp.c
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __MAUSB_TCP_H
+#define __MAUSB_TCP_H
+
+#include <linux/net.h>
+#include <linux/kthread.h>
+#include <linux/tcp.h>
+#include <linux/in.h>
+
+#include "mausb_msapi.h"
+
+#define MAUSB_TCP_PORT_HOST 9001
+
+/* used to determine how many times we have to listen */
+#define MAUSB_TCP_MAX_NUM_CHANNELS 1
+
+/* how often the device should poll while connecting */
+#define MAUSB_TCP_DEV_CONNECT_POLL_MS 100
+
+/* how often to poll the port to check for a new message */
+#define MAUSB_TCP_POLL_PORT_MS 5
+
+#define MAUSB_TCP_BUF_SIZE PAGE_SIZE
+
+#define MAUSB_MAX_NAME_LEN 50
+
+#define MAUSB_TCP_RECV_POLL 1 /* in ms */
+
+#define MAUSB_DWORD_LENGTH 4 /* DWORD = 4 bytes */
+
+enum mausb_tcp_module_type {
+	MAUSB_TCP_DEV = 0,
+	MAUSB_TCP_HOST,
+	MAUSB_TCP_NUM_MODS
+};
+
+struct mausb_tcp_medium {
+	struct socket *setup_socket;
+	union {
+		struct sockaddr_in addr_in;
+		struct sockaddr addr;
+	};
+	spinlock_t lock;
+	struct mausb_ma_drv *ma_driver;
+
+	struct socket *socket;
+	struct task_struct *recv_task;
+
+	/* function call for when a device connect/disconnect is made */
+	int (*connect)(int on);
+};
+
+/* Used so that host and device side connect functions can run simultaniously.
+ * See gadget_connection() & gadget_connect_thread() for details. */
+struct mausb_connect_data {
+	struct task_struct *task;
+	int i;
+	int on;
+};
+
+/* function declarations */
+struct mausb_tcp_medium *mausb_tcp_get_medium(void);
+void *mausb_tcp_to_context(struct mausb_tcp_medium *medium);
+struct mausb_tcp_medium *mausb_context_to_tcp(void *context);
+int mausb_tcp_receive_loop(struct mausb_tcp_medium *medium);
+int mausb_tcp_add_tx_pair(struct mausb_transfer_pair *ma_pair,
+		struct mausb_tcp_medium *medium);
+int mausb_tcp_drop_tx_pair(unsigned long handle, void *context);
+struct mausb_tcp_medium *alloc_init_mausb_tcp_medium(
+		enum mausb_tcp_module_type type);
+void free_mausb_tcp_medium(struct mausb_tcp_medium *medium,
+		enum mausb_tcp_module_type type);
+
+#endif
-- 
1.9.1

