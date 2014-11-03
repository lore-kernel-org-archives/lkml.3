Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaKCUvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:51:53 -0500
Received: from mga14.intel.com ([192.55.52.115]:55524 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbaKCUrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:47:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="616331436"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [PATCH 03/10] added media agnostic (MA) data structures and handling
Date: Mon,  3 Nov 2014 12:42:50 -0800
Message-Id: <1415047377-3139-4-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we create, store and handle endpoint and device structures
that are specific to the MA USB drivers. Each MA USB structure maps 1:1
with it's corresponding USB structure (e.g. there is one MA USB endpoint
per USB endpoint).

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/mausb/drivers/mausb_const.h    | 109 ++++
 drivers/staging/mausb/drivers/mausb_mem-host.c | 404 ++++++++++++
 drivers/staging/mausb/drivers/mausb_mem-host.h |  74 +++
 drivers/staging/mausb/drivers/mausb_mem.c      | 844 +++++++++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_mem.h      | 509 +++++++++++++++
 drivers/staging/mausb/drivers/mausb_state.h    | 184 ++++++
 6 files changed, 2124 insertions(+)
 create mode 100755 drivers/staging/mausb/drivers/mausb_const.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_mem-host.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_mem-host.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_mem.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_mem.h
 create mode 100644 drivers/staging/mausb/drivers/mausb_state.h

diff --git a/drivers/staging/mausb/drivers/mausb_const.h b/drivers/staging/mausb/drivers/mausb_const.h
new file mode 100755
index 0000000..1089f81
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_const.h
@@ -0,0 +1,109 @@
+/* Name:	mausb_const.h
+ * Description: This header describes the Media Agnostic USB constants
+ *              that must be known by the both the host and device side drivers.
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
+#ifndef __MAUSB_CONST_H
+#define __MAUSB_CONST_H
+
+/* MA USB protocol constants per Table 68 of the MA USB Spec */
+#define MAUSB_DATA_CHANNEL_DELAY	400	/* temp value */
+#define MAUSB_MGMT_CHANNEL_DELAY	((100 * HZ)/1000 + 1)
+#define MAUSB_MGMT_RESPONSE_DELAY	((5 * HZ)/1000 + 1) /* 5 msec */
+#define MAUSB_MGMT_RT_DELAY \
+	((MAUSB_MGMT_RESPONSE_DELAY + (2 * MAUSB_MGMT_CHANNEL_DELAY)))
+#define MAUSB_TRANSFER_RESPONSE_TIME	10	/* 10 msec */
+#define MAUSB_TRANSFER_TIMEOUT \
+	(MAUSB_TRANSFER_RESPONSE_TIME + (2 * MAUSB_DATA_CHANNEL_DELAY))
+#define MAUSB_TRANSFER_KEEP_ALIVE \
+	(MAUSB_TRANSFER_RESPONSE_TIME + MAUSB_DATA_CHANNEL_DELAY)
+#define MAUSB_DEFAULT_KEEP_ALIVE	 0
+#define MAUSB_MAX_TRANSFER_LIFETIME	 1000	/* 1 sec */
+#define MAUSB_TRANSFER_REPEAT_TIME	 10	/* 10 msec */
+
+#define MAUSB_MAX_REQ_ID		 ((1 << 8) - 1)
+#define MAUSB_MAX_SEQ_NUM		 ((1 << 24) - 1)
+#define MAUSB_MAX_DIALOG_TOKEN		 ((1 << 10) - 1)
+#define MAUSB_MIN_CONTROL_BUF_SIZE	 4104	/* Bytes */
+
+
+/* MA USB protocol variables per Table 69 of the MA USB Spec */
+#define MAUSB_BULK_TRANSFER_RETRIES	 10	/* min value is 5 */
+#define MAUSB_CONTROL_TRANSFER_RETRIES	 10	/* min value is 5 */
+#define MAUSB_INTERRUPT_TRANSFER_RETRIES 10	/* min value is 3 */
+#define MAUSB_MGMT_TRANSFER_RETRIES	 4      /* min value is 4 */
+#define MAUSB_TRANSFER_SETUP_RETRIES	 4	/* min value is 4 */
+
+
+/* MA USB constants not explicitly defined in MA USB Spec */
+#define MAUSB_HALF_REQ_ID		 ((MAUSB_MAX_REQ_ID + 1) >> 2)
+#define MAUSB_HALF_SEQ_NUM		 ((MAUSB_MAX_SEQ_NUM + 1) >> 2)
+#define MAUSB_MAX_OUTSTANDING_SEQ_NUM	 (1 << 23)
+
+/* Largest packet size (in bytes) that the medium can handle */
+#define MAUSB_MAX_PACKET_SIZE	300
+
+/* Used to parse get_status control requests */
+#define EP_REQ (USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
+#define EP_IN_REQ (USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
+#define DEV_IN_REQ (USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE)
+#define INTF_IN_REQ (USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_INTERFACE)
+
+/* Used for generating the mass_id for the device */
+#define MASS_ID_MIN	1
+#define MASS_ID_MAX	254
+
+
+#endif
diff --git a/drivers/staging/mausb/drivers/mausb_mem-host.c b/drivers/staging/mausb/drivers/mausb_mem-host.c
new file mode 100644
index 0000000..2cc54c9
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_mem-host.c
@@ -0,0 +1,404 @@
+/* Name:	mausb_mem-host.c
+ * Description: Contains hostside-specific memory functions, as well as
+ *              wrappers for functions in mausb_mem.c.
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
+#define DEBUG
+
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+
+#include <linux/kthread.h>
+
+#include "mausb_hcd.h"
+#include "mausb_mem-host.h"
+#include "mausb_mem.h"
+#include "mausb_tx.h"
+#include "mausb_mgmt.h"
+
+/**
+ * Returns a pointer to the media agnostic data for a given endpoint.
+ */
+struct mausb_host_ep *usb_to_ma_endpoint(struct usb_host_endpoint *ep)
+{
+	return (struct mausb_host_ep *) ep->hcpriv;
+}
+
+/**
+ * Returns the number of urbs currently in the MA USB HCD. Will return 0 if the
+ * MA USB HCD is empty or a negative errno if an error occurs.
+ */
+int mausb_hcd_urb_count(struct mausb_hcd *mhcd)
+{
+	int			count = 0;
+	struct mausb_host_ep	*ma_ep;
+	struct mausb_dev	*mausb_dev;
+	struct mausb_urb	*maurb;
+	unsigned long		irq_flags;
+
+	/* for every device */
+	spin_lock_irqsave(&mhcd->hcd_lock, irq_flags);
+	list_for_each_entry(mausb_dev, &mhcd->ma_dev.dev_list, dev_list) {
+		spin_unlock_irqrestore(&mhcd->hcd_lock, irq_flags);
+
+		/* for every endpoint */
+		spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+		list_for_each_entry(ma_ep, &mausb_dev->ep_list, ep_list) {
+			spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+
+			/* for every urb */
+			spin_lock_irqsave(&ma_ep->ep_lock, irq_flags);
+			list_for_each_entry(maurb, &ma_ep->urb_list, urb_list) {
+				++count;
+			}
+
+			spin_unlock_irqrestore(&ma_ep->ep_lock, irq_flags);
+			spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+		}
+
+		spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+		spin_lock_irqsave(&mhcd->hcd_lock, irq_flags);
+	}
+
+	spin_unlock_irqrestore(&mhcd->hcd_lock, irq_flags);
+
+	return count;
+}
+
+/**
+ * This function removes a device data from the hcd. All endpoints belonging
+ * to this device are also removed from the hcd and released (including EP0).
+ */
+void mausb_free_dev(struct usb_hcd *hcd, struct usb_device *dev)
+{
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct ma_dev		*ma_dev = &mhcd->ma_dev;
+	struct mausb_dev	*mausb_dev = mausb_find_dev_host(ma_dev, dev);
+	struct mausb_host_ep	*ep0 = list_first_entry(&mausb_dev->ep_list,
+					struct mausb_host_ep, ep_list);
+
+	if (NULL == mausb_dev) {
+		mausb_err(mhcd, "%s: USB device #%i not found\n",
+			__func__, dev->devnum);
+		return;
+	}
+
+	ep0->ep_handle_state = MAUSB_EP_HANDLE_INACTIVE;
+
+	/* inactivate EP0 handle */
+	mausb_tx_dev_mgmt_req_ep(EPInactivateReq, &mhcd->ma_dev.mgmt,
+		mausb_dev, true, ep0);
+
+	/* delete remaining EP Handles */
+	mausb_tx_dev_mgmt_req(EPHandleDeleteReq, &mhcd->ma_dev.mgmt,
+		mausb_dev, MAUSB_HOST);
+
+	mausb_tx_dev_mgmt_req(USBDevDisconnectReq, &ma_dev->mgmt,
+		mausb_dev, MAUSB_HOST);
+
+	mausb_internal_free_dev(ma_dev, mausb_dev);
+
+	return;
+}
+
+/*
+ * Adds an endpoint to the specified device.
+ *
+ * This function allocates private endpoint data and adds the given endpoint
+ * to the given device. In the mausb_hcd, devices hold their endpoints in a
+ * linked list.
+ */
+int mausb_add_endpoint(struct usb_hcd *hcd, struct usb_device *dev,
+		struct usb_host_endpoint *ep)
+{
+	int			status;
+	char			*ep_type;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct ma_dev		*ma_dev = &mhcd->ma_dev;
+	struct mausb_dev	*mausb_dev;
+	struct mausb_ms_drv	*ms_driver = ma_dev->ms_driver;
+	struct mausb_host_ep	*ma_ep;
+
+	/* don't need to do anything for root hub */
+	if ((NULL == dev->parent) && (&dev->ep0 != ep))
+		return 0;
+
+	mausb_dev = mausb_find_dev_host(ma_dev, dev);
+	if (NULL == mausb_dev) {
+		mausb_err(mhcd, "unable to add endpoint: USB device #%i not"
+			" found\n", dev->devnum);
+		return -ENODEV;
+	}
+
+	status = mausb_internal_add_ep(mausb_dev, ep, NULL, &ma_ep,
+		&host_transfer_timeout, GFP_KERNEL);
+
+	if (status < 0) {
+		mausb_err(mhcd, "could not add endpoint: error %i\n", status);
+		return status;
+	}
+
+	/* need ms driver before adding endpoint */
+	if (NULL == ms_driver)
+		return -ENODEV;
+
+	/* for debug messages */
+	switch (usb_endpoint_type(&ep->desc)) {
+	case USB_ENDPOINT_XFER_CONTROL:
+		ep_type = "control";
+		break;
+	case USB_ENDPOINT_XFER_BULK:
+		ep_type = "bulk";
+		break;
+	case USB_ENDPOINT_XFER_INT:
+		ep_type = "interrupt";
+		break;
+	case USB_ENDPOINT_XFER_ISOC:
+		ep_type = "isochronous";
+		break;
+	default:
+		ep_type = "unknown";
+	}
+
+	/* set up control endpoint data channel */
+	if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_CONTROL) {
+		status = mausb_add_data_channel(ms_driver, ma_ep,
+			&complete_control_transferRequest);
+	}
+	/* set up bulk IN endpoint data channel */
+	else if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_BULK
+		&& usb_endpoint_dir_in(&ep->desc)) {
+		status = mausb_add_data_channel(ms_driver, ma_ep,
+			&complete_IN_transferRequest);
+	}
+	/* set up bulk OUT endpoint data channel */
+	else if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_BULK
+		&& usb_endpoint_dir_out(&ep->desc)) {
+		status = mausb_add_data_channel(ms_driver, ma_ep,
+			&complete_OUT_transferRequest);
+	}
+	/* set up an interrupt IN endpoint data channel */
+	else if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_INT
+		&& usb_endpoint_dir_in(&ep->desc)) {
+		status = mausb_add_data_channel(ms_driver, ma_ep,
+			&complete_IN_transferRequest);
+	}
+	/* set up an interrupt OUT endpoint data channel */
+	else if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_INT
+		&& usb_endpoint_dir_out(&ep->desc)) {
+		status = mausb_add_data_channel(ms_driver, ma_ep,
+			&complete_OUT_transferRequest);
+	} else {
+		mausb_err(mhcd,
+			"%s: attempted to add channel for ep %i of unsupported"
+			" type\n", __func__, usb_endpoint_num(&ep->desc));
+		return -EOPNOTSUPP;
+	}
+
+	if (status < 0) {
+		mausb_err(mhcd, "cannot add %s channel for ep %i: error %i\n",
+			ep_type, usb_endpoint_num(&ep->desc), status);
+		/* cleanup endpoint */
+		mausb_internal_drop_ep(ma_ep);
+	} else {
+		mausb_dbg(mhcd, "%s: added %s channel for ep %i\n", __func__,
+			ep_type, usb_endpoint_num(&ep->desc));
+	}
+
+	return status;
+}
+
+/*
+ * Removes an endpoint from the specified device.
+ *
+ * This function removes the given endpoint from the given device and releases
+ * private endpoint data. In the mausb_hcd, devices hold their endpoints in
+ * a linked list.
+ *
+ * TODO: determine & implement proper behavior when endpoint is not
+ *       associated with given device (or is associated with a different
+ *       device)
+ */
+int mausb_drop_endpoint(struct usb_hcd *hcd, struct usb_device *dev,
+		struct usb_host_endpoint *ep)
+{
+	int			ret = 0;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_host_ep	*ma_ep = usb_to_ma_endpoint(ep);
+	struct mausb_dev	*ma_dev;
+	struct mausb_urb	*ma_urb, *next_urb;
+	unsigned long		irq_flags;
+
+	if (NULL == ma_ep) {
+		mausb_err(mhcd, "%s: cannot find data for endpoint at %p\n",
+			__func__, ep);
+		return -ENODEV;
+	}
+
+	ma_dev = ma_ep->mausb_dev;
+
+	mausb_dbg(mhcd, "dropping endpoint at %p to USB device #%i\n", ep,
+		dev->devnum);
+
+	ret = mausb_tx_dev_mgmt_req_ep(CancelTransferReq, &mhcd->ma_dev.mgmt,
+		ma_dev, true, ma_ep);
+
+	ma_ep->ep_handle_state = MAUSB_EP_HANDLE_INACTIVE;
+
+	ret = mausb_tx_dev_mgmt_req_ep(EPInactivateReq, &mhcd->ma_dev.mgmt,
+		ma_dev, true, ma_ep);
+
+	spin_lock_irqsave(&ma_ep->ep_lock, irq_flags);
+	list_for_each_entry_safe(ma_urb, next_urb, &ma_ep->urb_list, urb_list) {
+
+		mausb_unlink_giveback_urb(ma_urb, -ECONNRESET);
+	}
+
+	if (!list_empty(&ma_ep->urb_list)) {
+		mausb_err(mhcd, "%s: could not drop all urbs for ma_ep at %p\n",
+			__func__, ma_ep->ep);
+	}
+
+	spin_unlock_irqrestore(&ma_ep->ep_lock, irq_flags);
+
+	return 0;
+}
+
+/**
+ * This function allocates a new device and adds it onto the MA device's linked
+ * list of usb devices. It also allocates endpoint data for the control
+ * endpoint (EP0).
+ *
+ * Returns 1 on success or 0 on failure.
+ */
+int mausb_alloc_dev(struct usb_hcd *hcd, struct usb_device *dev)
+{
+	int			status = 0;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct ma_dev		*ma_dev = &mhcd->ma_dev;
+	struct mausb_dev	*mausb_dev;
+
+	mausb_dev = mausb_internal_alloc_dev(ma_dev, dev, NULL);
+	if (NULL == mausb_dev)
+		return 0;
+
+	/* add EP0 */
+	mausb_dbg(mhcd, "%s: adding EP0 . . .\n", __func__);
+	status = mausb_add_endpoint(hcd, dev, &dev->ep0);
+
+	/*
+	 * Don't add send the EP Request yet, usbcore hasn't set
+	 * the ep0 descriptor. Wait until a datapacket is sent.
+	 */
+
+	if (status >= 0)
+		return 1;
+
+	/* TODO: drop endpoint here if failure */
+	mausb_free_dev(hcd, dev);
+	mausb_err(mhcd, "%s: could not add EP0 %i\n", __func__, status);
+	return 0;
+}
+
+/**
+ * USB core calls the HCD's check_bandwidth function immediately after adding
+ * or deleting endpoints.
+ */
+int mausb_check_bandwidth(struct usb_hcd *hcd, struct usb_device *dev)
+{
+	int			status;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct ma_dev		*ma_dev = &mhcd->ma_dev;
+	struct mausb_dev	*mausb_dev = mausb_find_dev_host(ma_dev, dev);
+
+	/* don't do anything if roothub */
+	if (NULL == dev->parent)
+		return 0;
+
+	if (NULL == mausb_dev) {
+		mausb_err(mhcd, "%s: could not find data for USB device #%i\n",
+			__func__, dev->devnum);
+		return -ENODEV;
+	}
+
+	/* delete the old endpoints (if applicable) */
+	status = mausb_tx_dev_mgmt_req(EPHandleDeleteReq, &ma_dev->mgmt,
+					mausb_dev, MAUSB_HOST);
+
+	/* TODO: error checking (suppose the EPHandleDelete fails...) */
+
+	/* add the new endpoints (if applicable) */
+	status = mausb_tx_dev_mgmt_req(EPHandleReq, &ma_dev->mgmt, mausb_dev,
+		MAUSB_HOST);
+
+	if (-ENODEV == status) /* no endpoints were applicable */
+		status = 0;
+
+	return status;
+}
+
+/**
+ * This function will be called if mausb_add_endpoint(), mausb_drop_ep(),
+ * or mausb_check_bandwidth returns with an error. It is supposed to revert
+ * a device to a previously good schedule. We assume any schedule will work,
+ * so we should, in theory, never have to revert to a previous schedule.
+ */
+void mausb_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *dev)
+{
+	mausb_dbg(usb_hcd_to_mausb_hcd(hcd),
+		"resetting bandwidth for USB edvice #%i\n", dev->devnum);
+	return;
+}
+
diff --git a/drivers/staging/mausb/drivers/mausb_mem-host.h b/drivers/staging/mausb/drivers/mausb_mem-host.h
new file mode 100644
index 0000000..9df6c1f
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_mem-host.h
@@ -0,0 +1,74 @@
+/* Name:	mausb_mem-host.h
+ * Description: header for mausb_mem-host.c
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
+#ifndef __MAUSB_MEM_HOST_H
+#define __MAUSB_MEM_HOST_H
+
+/* endpoint/device helper functions */
+struct mausb_host_ep *usb_to_ma_endpoint(struct usb_host_endpoint *ep);
+int mausb_hcd_urb_count(struct mausb_hcd *mhcd);
+
+/* USB core interfaces */
+int mausb_alloc_dev(struct usb_hcd *hcd, struct usb_device *dev);
+void mausb_free_dev(struct usb_hcd *hcd, struct usb_device *dev);
+int mausb_add_endpoint(struct usb_hcd *hcd, struct usb_device *dev,
+		struct usb_host_endpoint *ep);
+int mausb_drop_endpoint(struct usb_hcd *hcd, struct usb_device *dev,
+		struct usb_host_endpoint *ep);
+int mausb_check_bandwidth(struct usb_hcd *hcd, struct usb_device *dev);
+void mausb_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *dev);
+
+#endif
diff --git a/drivers/staging/mausb/drivers/mausb_mem.c b/drivers/staging/mausb/drivers/mausb_mem.c
new file mode 100644
index 0000000..9f828d7
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_mem.c
@@ -0,0 +1,844 @@
+/* Name:	mausb_mem.c
+ * Description: Handles all of the dynamic data structures for the host
+ *              controller, including any data that needs to exist
+ *              on a per-device, per-endpoint, or per-transfer basis.
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
+#define DEBUG
+
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/kthread.h>
+
+#include "mausb_mem.h"
+#include "mausb_mgmt.h"
+#include "mausb_tx.h"
+#include "mausb_pkt.h"
+#include "mausb_const.h"
+#include "mausb_hcd.h"
+
+struct mausb_host_ep *mausb_state_to_ep(struct mausb_ep_state *state)
+{
+	return container_of(state, struct mausb_host_ep, state);
+}
+EXPORT_SYMBOL(mausb_state_to_ep);
+
+struct mausb_hcd *mausb_host_ep_to_mahcd(struct mausb_host_ep *ep)
+{
+	return ep->mausb_dev->ma_dev->mhcd;
+}
+EXPORT_SYMBOL(mausb_host_ep_to_mahcd);
+
+struct mausb_udc *mausb_host_ep_to_maudc(struct mausb_host_ep *ep)
+{
+	return ep->mausb_dev->ma_dev->maudc;
+}
+EXPORT_SYMBOL(mausb_host_ep_to_maudc);
+
+struct ma_dev *context_to_ma_dev(void *context)
+{
+	return (struct ma_dev *) context;
+}
+
+/*
+ * Finds the media-agnostic data for a given device.
+ *
+ * @ma_dev:	The MA USB device the USB device is located behind.
+ * @dev:	The USB device to find.
+ * @handle:	The MA USB device handle of USB device to find.
+ * @gadget:	The USB gadget device to find.
+ *
+ * Returns a pointer to the media agnostic data for a USB device given one or
+ * more parameters. Returns NULL if the device cannot be found.
+ */
+struct mausb_dev *mausb_find_dev(struct ma_dev *ma_dev,
+		struct usb_device *dev, unsigned long *handle,
+		struct usb_gadget *gadget)
+{
+	struct mausb_dev *mausb_dev;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&ma_dev->ma_dev_lock, irq_flags);
+	list_for_each_entry(mausb_dev, &ma_dev->dev_list, dev_list) {
+
+		/* if found */
+		if ((NULL != dev && mausb_dev->dev == dev) ||
+			(NULL != gadget && mausb_dev->gadget == gadget) ||
+			(NULL != handle && mausb_dev->dev_handle == *handle)) {
+			spin_unlock_irqrestore(&ma_dev->ma_dev_lock, irq_flags);
+			return mausb_dev;
+		}
+	}
+	spin_unlock_irqrestore(&ma_dev->ma_dev_lock, irq_flags);
+
+	/* device not found */
+	return NULL;
+}
+
+struct mausb_dev *mausb_find_dev_host(struct ma_dev *ma_dev,
+		struct usb_device *dev)
+{
+	return mausb_find_dev(ma_dev, dev, NULL, NULL);
+}
+EXPORT_SYMBOL(mausb_find_dev_host);
+
+/**
+ * Returns true if usb_endpoint descriptors are the same.
+ */
+static bool mausb_ep_desc_eq(const struct usb_endpoint_descriptor *desc1,
+		const struct usb_endpoint_descriptor *desc2)
+{
+	return ((desc1->bLength == desc2->bLength)
+		&& (desc1->bDescriptorType  == desc2->bDescriptorType)
+		&& (desc1->bEndpointAddress == desc2->bEndpointAddress)
+		&& (desc1->bmAttributes     == desc2->bmAttributes)
+		&& (desc1->wMaxPacketSize   == desc2->wMaxPacketSize));
+}
+
+/**
+ * Finds the media agnostic data for an endpoint given one or more parameters.
+ *
+ * @ep:			USB host endpoint to find MA USB endpoint for.
+ * @dev_ep:		USB device endpoint to find MA USB endpoint for.
+ * @handle:		Endpoint handle of MA USB endpoint.
+ * @mausb_dev:		The MA USB device the endpoint belongs to.
+ * @ep_desc:		endpoint descriptor for USB endpoint.
+ * @address:		MA USB endpoint address.
+ *
+ * Returns a pointer to the media agnostic data for the endpoint or NULL if
+ * the device cannot be found.
+ */
+static struct mausb_host_ep *mausb_find_ep(struct usb_host_endpoint *ep,
+		struct usb_ep *dev_ep, struct mausb_ep_handle *handle,
+		struct mausb_dev *mausb_dev,
+		const struct usb_endpoint_descriptor *ep_desc,
+		u8 address)
+{
+	struct mausb_host_ep *ma_ep;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+	list_for_each_entry(ma_ep, &mausb_dev->ep_list, ep_list) {
+
+		/* if found */
+		if ((NULL != dev_ep && ma_ep->dev_ep == dev_ep) ||
+			(NULL != ep && ma_ep->ep == ep) ||
+			(NULL != handle
+			 && ma_ep->ep_handle_state != MAUSB_EP_HANDLE_UNASSIGNED
+			 && ma_ep->ep_handle.handle == handle->handle) ||
+			(NULL != ep_desc && NULL != ma_ep->ep
+			 && mausb_ep_desc_eq(ep_desc, &ma_ep->ep->desc)) ||
+			(NULL != ep_desc && NULL != ma_ep->dev_ep &&
+			 NULL != ma_ep->dev_ep->desc
+			 && mausb_ep_desc_eq(ep_desc, ma_ep->dev_ep->desc)) ||
+			(address != 0 && NULL != ma_ep->dev_ep &&
+			 address == ma_ep->dev_ep->address)) {
+
+			spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+			return ma_ep;
+		}
+	}
+
+	spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+
+	/* endpoint not found */
+	return NULL;
+}
+
+struct mausb_host_ep *mausb_find_ep_dev(struct usb_ep *dev_ep,
+			struct mausb_dev *mausb_dev)
+{
+	return mausb_find_ep(NULL, dev_ep, NULL, mausb_dev, NULL, 0);
+}
+EXPORT_SYMBOL(mausb_find_ep_dev);
+
+struct mausb_host_ep *mausb_find_ep_host(struct usb_host_endpoint *ep,
+	struct mausb_dev *mausb_dev)
+{
+	return mausb_find_ep(ep, NULL, NULL, mausb_dev, NULL, 0);
+}
+EXPORT_SYMBOL(mausb_find_ep_host);
+
+struct mausb_host_ep *mausb_find_ep_by_desc(
+	const struct usb_endpoint_descriptor *ep_desc,
+	struct mausb_dev *mausb_dev)
+
+{
+	return mausb_find_ep(NULL, NULL, NULL, mausb_dev, ep_desc, 0);
+}
+EXPORT_SYMBOL(mausb_find_ep_by_desc);
+
+struct mausb_host_ep *mausb_find_ep_by_handle(struct mausb_ep_handle *handle,
+	struct mausb_dev *mausb_dev)
+{
+	return mausb_find_ep(NULL, NULL, handle, mausb_dev, NULL, 0);
+}
+EXPORT_SYMBOL(mausb_find_ep_by_handle);
+
+struct mausb_host_ep *mausb_find_ep_by_address(u8 address,
+	struct mausb_dev *mausb_dev)
+
+{
+	return mausb_find_ep(NULL, NULL, NULL, mausb_dev, NULL, address);
+}
+EXPORT_SYMBOL(mausb_find_ep_by_address);
+
+struct mausb_host_ep *mausb_find_ep_from_handle(struct mausb_ep_handle handle,
+	struct ma_dev *ma_dev)
+{
+	struct mausb_host_ep *ma_ep;
+	struct mausb_dev *mausb_dev;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&ma_dev->ma_dev_lock, irq_flags);
+	list_for_each_entry(mausb_dev, &ma_dev->dev_list, dev_list) {
+		spin_unlock_irqrestore(&ma_dev->ma_dev_lock, irq_flags);
+
+		ma_ep = mausb_find_ep_by_handle(&handle, mausb_dev);
+		if (ma_ep != NULL)
+			return ma_ep;
+
+		spin_lock_irqsave(&ma_dev->ma_dev_lock, irq_flags);
+	}
+	spin_unlock_irqrestore(&ma_dev->ma_dev_lock, irq_flags);
+
+	return NULL;
+}
+
+/**
+ * Wrapper function to be used by devices when they want to generate an
+ * ma packet.
+ */
+struct mausb_pkt *mausb_pkt_from_ms_pkt_ma_dev(struct ms_pkt *ms_pkt,
+	struct ma_dev *ma_dev, gfp_t mem_flags)
+{
+	return mausb_pkt_from_ms_pkt(ms_pkt,
+			ma_dev->ms_driver->ops->pkt_destructor, mem_flags);
+}
+EXPORT_SYMBOL(mausb_pkt_from_ms_pkt_ma_dev);
+
+/**
+ * Wrapper to be used by endpoints when they want to generate an ma packet.
+ */
+struct mausb_pkt *mausb_pkt_from_ms_pkt_ep(struct ms_pkt *ms_pkt,
+	struct mausb_host_ep *ep, gfp_t mem_flags)
+{
+	return mausb_pkt_from_ms_pkt_ma_dev(ms_pkt, ep->mausb_dev->ma_dev,
+		mem_flags);
+}
+EXPORT_SYMBOL(mausb_pkt_from_ms_pkt_ep);
+
+const struct usb_endpoint_descriptor *mausb_get_ep_des(
+		struct mausb_host_ep *ma_ep)
+{
+	if ((NULL != ma_ep->ep && NULL != ma_ep->dev_ep) ||
+	    (NULL == ma_ep->ep && NULL == ma_ep->dev_ep)) {
+
+		mamem_err("%s: ERROR: ep = 0x%p, dev_ep = 0x%p "
+			"(only one should be set)\n", __func__,
+			ma_ep->ep, ma_ep->dev_ep);
+
+		return NULL;
+	}
+
+	if (NULL != ma_ep->ep)
+		return &ma_ep->ep->desc;
+
+	if (NULL != ma_ep->dev_ep)
+		return ma_ep->dev_ep->desc;
+
+	/* We should never get here */
+	BUG();
+	return NULL;
+}
+EXPORT_SYMBOL(mausb_get_ep_des);
+
+/**
+ * Fills an MA USB packet header for the given maurb
+ */
+static int fill_mausb_dph(struct mausb_dph *ma_pkt, struct mausb_urb *maurb,
+		  bool in, bool host)
+{
+	const struct usb_endpoint_descriptor *ep_des;
+	unsigned long irq_flags;
+
+	/* set the version number */
+	ma_pkt->common.ver_flags =  MAUSB_VERSION_1_0 & MAUSB_VERSION_MASK;
+
+	/* set the host flag if from the host */
+	ma_pkt->common.ver_flags |= host ? MAUSB_PKT_FLAG_HOST : 0;
+
+	/* set the device handle field */
+	spin_lock_irqsave(&maurb->ep->ep_lock, irq_flags);
+	ma_pkt->common.ep_handle = maurb->ep->ep_handle;
+	spin_unlock_irqrestore(&maurb->ep->ep_lock, irq_flags);
+
+	ma_pkt->common.pkt_status = SUCCESS;
+
+	ep_des = mausb_get_ep_des(maurb->ep);
+
+	/* set transfer type in tflags field */
+	switch (usb_endpoint_type(ep_des)) {
+	case USB_ENDPOINT_XFER_CONTROL:
+		ma_pkt->eps_tflags |= MAUSB_PKT_TFLAG_TYPE_CTRL;
+		break;
+	case USB_ENDPOINT_XFER_ISOC:
+		ma_pkt->eps_tflags |= MAUSB_PKT_TFLAG_TYPE_ISOC;
+		break;
+	case USB_ENDPOINT_XFER_BULK:
+		ma_pkt->eps_tflags |= MAUSB_PKT_TFLAG_TYPE_BULK;
+		break;
+	case USB_ENDPOINT_XFER_INT:
+		ma_pkt->eps_tflags |= MAUSB_PKT_TFLAG_TYPE_INT;
+		break;
+	default:
+		mamem_err("%s: invalid transfer type\n", __func__);
+	}
+
+	return 0;
+}
+
+/**
+ * Create a datapacket from a given URB.
+ */
+struct mausb_pkt *mausb_create_dp(int *status, struct mausb_urb *maurb,
+	bool in, bool host, gfp_t memflags)
+{
+	struct mausb_pkt	*pkt;
+	int			ret = 0;
+
+	pkt = mausb_alloc_pkt(MAUSB_PKT_TYPE_DATA, status, memflags);
+	if (NULL == pkt) {
+		mamem_err("%s:failed to allocate memory for mausb packet\n",
+			__func__);
+
+		if (NULL != status)
+			*status = -ENOMEM;
+
+		return NULL;
+	}
+
+	ret = fill_mausb_dph(pkt->data, maurb, in, host);
+	INIT_LIST_HEAD(&pkt->pkt_list);
+	if (NULL != status)
+		*status = ret;
+
+	return pkt;
+}
+EXPORT_SYMBOL(mausb_create_dp);
+
+struct mausb_urb *mausb_alloc_maurb(struct mausb_host_ep *ma_ep, gfp_t memflags)
+{
+	struct mausb_urb     *maurb;
+
+	maurb = kzalloc(sizeof(struct mausb_urb), memflags);
+	if (!maurb)
+		return NULL;
+
+	INIT_LIST_HEAD(&maurb->urb_list);
+	maurb->ep = ma_ep;
+	maurb->dev = ma_ep->mausb_dev;
+
+	return maurb;
+}
+EXPORT_SYMBOL(mausb_alloc_maurb);
+
+/**
+ * Deletes the given maurb and removes all pointers to it from memory.
+ */
+int mausb_internal_drop_maurb(struct mausb_urb *maurb, struct mausb_hcd *mhcd)
+{
+	struct mausb_host_ep *ep = maurb->ep;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+
+	list_del(&maurb->urb_list);
+	if (maurb == ep->active_transfer)
+		ep->active_transfer = NULL;
+
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+	spin_lock_irqsave(&mhcd->urb_list_lock, irq_flags);
+	list_del(&maurb->ma_hcd_urb_list);
+	spin_unlock_irqrestore(&mhcd->urb_list_lock, irq_flags);
+
+	/*
+	 * Nobody else should know this maurb exists, so it should be
+	 * safe to free
+	 */
+	kfree(maurb);
+
+	return 0;
+}
+EXPORT_SYMBOL(mausb_internal_drop_maurb);
+
+/**
+ * Sets endpoint state to default.
+ *
+ * @state:	State of endpoint to be configured.
+ * @buf_size:	The maximum number of Bytes the device-side buffer
+ *              can receive from the host.
+ *
+ * Called whenever an MA USB endpoint is configured and needs to be set
+ * or reset to its initial state.
+ */
+void init_ep_state(struct mausb_ep_state *state, u32 buf_size)
+{
+	state->request_id = 0;
+	state->active_request_id = 0;
+	state->seq_number = 0;
+	state->tx_pending = 0;
+	state->earliest_request_id = 0;
+	state->earliest_unacked = 0;
+	state->occupancy = 0;
+	state->rx_buf_size = buf_size;
+	state->keep_alive_timer = MAUSB_TRANSFER_KEEP_ALIVE;
+	state->retry_counter = MAUSB_BULK_TRANSFER_RETRIES;
+	/* TODO: number of retries depends on transfer type, include
+	 * other transfer types (control and interrupt) */
+}
+
+struct mausb_gadget_ep *usb_ep_to_mausb_gadget_ep(struct usb_ep *ep)
+{
+	return container_of(ep, struct mausb_gadget_ep, dev_ep);
+}
+EXPORT_SYMBOL(usb_ep_to_mausb_gadget_ep);
+
+/**
+ * Links a Device-side endpoint to an MA USB endpoint
+ */
+void mausb_link_ma_ep_to_usb_ep(struct mausb_host_ep *ma_ep,
+		struct usb_ep *dev_ep)
+{
+	struct mausb_gadget_ep *gadget_ep = usb_ep_to_mausb_gadget_ep(dev_ep);
+
+	ma_ep->dev_ep = dev_ep;
+	ma_ep->halted = 0;
+	ma_ep->wedged = 0;
+
+	ma_ep->usb_req_list = &gadget_ep->usb_req_list;
+}
+EXPORT_SYMBOL(mausb_link_ma_ep_to_usb_ep);
+
+/*
+ * Adds an endpoint to the specified device.
+ *
+ * @ma_dev:		The usb device to add the endpoint to.
+ * @ep/dev_ep:		The usb struct for the endpoint being added.
+ *			Note: give only one of the endpoint pointers and
+ *                      set the other to NULL.
+ * @mausb_ep:		The mausb_ep struct created by this function.
+ * @transfer_timeout:	The transfer timeout function. A thread will be
+ *                      spawned with this function for handling timeouts.
+ *
+ * Adds the given endpoint to the given device. The difference between this
+ * function and mausb_add_endpoint (which can be called from the usb core)
+ * is that this uses the private ma-structs. Calling this function is
+ * cheaper, and therefore preferred when possible, since mausb_add_endpoint
+ * will have to find the internal structures.
+ */
+int mausb_internal_add_ep(struct mausb_dev *ma_dev,
+		struct usb_host_endpoint *ep, struct usb_ep *dev_ep,
+		struct mausb_host_ep **mausb_ep,
+		int (*transfer_timeout)(void *data), gfp_t memflags)
+{
+	struct mausb_host_ep *ma_ep;
+	unsigned long irq_flags;
+
+	ma_ep = kzalloc(sizeof(struct mausb_host_ep), memflags);
+	if (!ma_ep)
+		return -ENOMEM;
+
+	/* host operations */
+	if (ep != NULL) {
+		ep->hcpriv = ma_ep;
+		ma_ep->ep = ep;
+
+	/* device operations */
+	} else if (dev_ep != NULL)
+		mausb_link_ma_ep_to_usb_ep(ma_ep, dev_ep);
+
+	ma_ep->mausb_dev = ma_dev;
+
+	/* set initial EP State */
+	init_ep_state(&ma_ep->state, DEVICE_RX_BUF_SIZE);
+
+	/*
+	 * only used by full speed devices to determine if the max packet
+	 * size has changed for EP0
+	 */
+	ma_ep->max_pkt = 8;
+
+	/* initialize mausb_ep_handle */
+	ma_ep->ep_handle_state = MAUSB_EP_HANDLE_UNASSIGNED;
+
+	INIT_LIST_HEAD(&ma_ep->urb_list);
+	INIT_LIST_HEAD(&ma_ep->ep_list);
+	INIT_LIST_HEAD(&ma_ep->req_list);
+	INIT_LIST_HEAD(&ma_ep->resp_list);
+
+	spin_lock_init(&ma_ep->ep_lock);
+	ma_ep->tx_timed_out = false;
+
+	/* initialize endpoint work queue */
+	init_waitqueue_head(&ma_ep->host_ep_wq);
+
+	/* initialize endpoint timer */
+	setup_timer(&ma_ep->timer, wake_timeout_thread, (unsigned long) ma_ep);
+
+	/* add the endpoint to the device */
+	spin_lock_irqsave(&ma_dev->dev_lock, irq_flags);
+	list_add_tail(&ma_ep->ep_list, &ma_dev->ep_list);
+	spin_unlock_irqrestore(&ma_dev->dev_lock, irq_flags);
+
+	/* give a pointer to the ma_ep back to the caller */
+	if (NULL != mausb_ep)
+		*mausb_ep = ma_ep;
+
+	return 0;
+}
+EXPORT_SYMBOL(mausb_internal_add_ep);
+
+/**
+ * Drops the given endpoint from the given device. The difference between this
+ * function and mausb_drop_endpoint (which can be called from the usb core)
+ * is that this uses the private ma-structs. Calling this function is
+ * cheaper, and therefore preferred when possible, since mausb_drop_endpoint
+ * will have to find the internal endpoint structure.
+ */
+int mausb_internal_drop_ep(struct mausb_host_ep *ma_ep)
+{
+	struct mausb_dev *ma_dev;
+	struct mausb_request  *ma_request, *next_request;
+	struct mausb_pkt *ma_pkt, *next_pkt;
+	unsigned long     irq_flags;
+	unsigned long     irq_flags2;
+
+	if (NULL == ma_ep)
+		return -EINVAL;
+
+	/* drop all pending transfers */
+	spin_lock_irqsave(&ma_ep->ep_lock, irq_flags);
+	ma_dev = ma_ep->mausb_dev;
+
+	/* stop transfer timeout thread */
+	if (NULL != ma_ep->timeout_task)
+		kthread_stop(ma_ep->timeout_task);
+
+	/* drop all pending usb_requests (if there are any) */
+	if (NULL != ma_ep->usb_req_list) {
+		list_for_each_entry_safe(ma_request, next_request,
+					ma_ep->usb_req_list, usb_req_list) {
+			list_del(&ma_request->usb_req_list);
+			ma_request->req.status = -ESHUTDOWN;
+			ma_request->req.complete(ma_ep->dev_ep,
+							&ma_request->req);
+		}
+	}
+
+	/* flush out all of the stored request/response packets */
+	list_for_each_entry_safe(ma_pkt, next_pkt, &ma_ep->req_list, pkt_list) {
+		list_del(&ma_pkt->pkt_list);
+		mausb_free_pkt(ma_pkt);
+	}
+	list_for_each_entry_safe(ma_pkt, next_pkt,
+					&ma_ep->resp_list, pkt_list) {
+		list_del(&ma_pkt->pkt_list);
+		mausb_free_pkt(ma_pkt);
+	}
+
+	/* remove the endpoint from the list */
+	spin_lock_irqsave(&ma_dev->dev_lock, irq_flags2);
+	list_del(&ma_ep->ep_list);
+	spin_unlock_irqrestore(&ma_dev->dev_lock, irq_flags2);
+
+	spin_unlock_irqrestore(&ma_ep->ep_lock, irq_flags);
+
+	kfree(ma_ep);
+
+	return 0;
+}
+EXPORT_SYMBOL(mausb_internal_drop_ep);
+
+/**
+ * Updates the state of an endpoint based on the mausb_ep_des.
+ */
+int mausb_update_ep(struct mausb_host_ep *ma_ep,
+			struct mausb_ep_des *ma_ep_des)
+{
+	unsigned long     irq_flags;
+
+	spin_lock_irqsave(&ma_ep->ep_lock, irq_flags);
+
+	if (!ma_ep_des->valid) { /* Valid bit: 0 means valid */
+		ma_ep->ep_handle.handle = ma_ep_des->ep_handle.handle;
+		ma_ep->ep_handle_state = MAUSB_EP_HANDLE_ACTIVE;
+	}
+
+	if (ma_ep_des->dir == 0) {
+		ma_ep->state.rx_buf_size = ma_ep_des->buffer_size;
+
+
+		if (ma_ep_des->l_man)
+			ma_ep->lman_support = true;
+		else
+			ma_ep->lman_support = false;
+	}
+
+	/*TODO: parse and use the remainder of the values in the packet */
+
+	spin_unlock_irqrestore(&ma_ep->ep_lock, irq_flags);
+
+	return 0;
+}
+
+/**
+ * Allocates private per-usb-device data.
+ *
+ * @ma_dev:	The MA USB device to which the USB device belongs
+ * @usb_dev:	The host-side USB device struct to add.
+ * @gadget:	The device-side USB device struct to add.
+ *
+ * This function allocates a new device and adds it onto the MA USB device's
+ * linked list of usb devices. It also allocates endpoint data for the control
+ * endpoint (EP0).
+ */
+struct mausb_dev *mausb_internal_alloc_dev(struct ma_dev *ma_dev,
+		struct usb_device *dev, struct usb_gadget *gadget)
+{
+	unsigned long     irq_flags;
+	struct mausb_dev *mausb_dev;
+
+	mausb_dev = kzalloc(sizeof(struct mausb_dev), GFP_KERNEL);
+
+	if (!mausb_dev)
+		return NULL;
+
+	if (NULL != dev)
+		mausb_dev->dev = dev;
+	if (NULL != gadget)
+		mausb_dev->gadget = gadget;
+	mausb_dev->ma_dev = ma_dev;
+	INIT_LIST_HEAD(&mausb_dev->ep_list);
+	INIT_LIST_HEAD(&mausb_dev->dev_list);
+	spin_lock_init(&mausb_dev->dev_lock);
+
+	spin_lock_irqsave(&ma_dev->ma_dev_lock, irq_flags);
+
+	/*
+	 * If this is the first device to be allocated, then it should be the
+	 * most upstream.
+	 */
+	if (NULL == ma_dev->top_dev)
+		ma_dev->top_dev = mausb_dev;
+
+	list_add_tail(&mausb_dev->dev_list, &ma_dev->dev_list);
+	spin_unlock_irqrestore(&ma_dev->ma_dev_lock, irq_flags);
+
+	return mausb_dev;
+}
+EXPORT_SYMBOL(mausb_internal_alloc_dev);
+
+/**
+ * Frees private per-device data.
+ *
+ * @ma_dev:	The MA USB device that the USB device beingfreed belongs to.
+ * @mausb_dev:	The MA USB data associated with the USB device being freed.
+ *
+ * This function removes a USB device from the MA USB hcd's linked list
+ * and releases the device's media agnostic data structure. All endpoints
+ * belonging to this device are also removed from the MA USB hcd and released
+ * (including EP0).
+ */
+int mausb_internal_free_dev(struct ma_dev *ma_dev, struct mausb_dev *mausb_dev)
+{
+	int			ret = 0;
+	unsigned long		irq_flags, irq_flags2;
+	struct mausb_host_ep	*ma_ep, *next;
+
+	/* remove all the endpoints from the device */
+	spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+	list_for_each_entry_safe(ma_ep, next, &mausb_dev->ep_list, ep_list) {
+		spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+		ret = mausb_internal_drop_ep(ma_ep);
+
+		spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+	}
+
+	if (!list_empty(&mausb_dev->ep_list)) {
+		spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+		return ret;
+	}
+
+	/* remove the mausb device from the ma device */
+	spin_lock_irqsave(&ma_dev->ma_dev_lock, irq_flags2);
+	list_del(&mausb_dev->dev_list);
+
+	/* if the top device is being removed */
+	if (ma_dev->top_dev == mausb_dev)
+		ma_dev->top_dev = NULL;
+
+	spin_unlock_irqrestore(&ma_dev->ma_dev_lock, irq_flags2);
+
+	spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+
+	kfree(mausb_dev);
+
+	return ret;
+
+}
+EXPORT_SYMBOL(mausb_internal_free_dev);
+
+/**
+ * Resets all the data in a ma_dev struct. This includes freeing all the MA
+ * data for the usb devices and endpoints connected to this device.
+ */
+int mausb_internal_reset_ma_dev(struct ma_dev *ma_dev, __u8 ma_dev_addr,
+	__u8 mass_id, struct mausb_hcd *mhcd, struct mausb_udc *maudc)
+{
+	int			ret = -EINVAL;
+	struct mausb_dev	*mausb_dev, *mausb_next;
+	int (*req_switch)(struct mausb_mgmt_pkt *req,
+			  struct mausb_mgmt_pkt *resp,
+			  struct mausb_mgmt *mgmt)
+		= ma_dev->mgmt.req_switch;
+	int (*device_connect)(int) = ma_dev->ma_drv.device_connect;
+	unsigned long irq_flags;
+
+	if (NULL != mhcd)
+		ma_dev->mhcd = mhcd;
+
+	if (NULL != maudc)
+		ma_dev->maudc = maudc;
+
+	spin_lock_irqsave(&ma_dev->ma_dev_lock, irq_flags);
+	list_for_each_entry_safe(mausb_dev, mausb_next, &ma_dev->dev_list,
+				dev_list) {
+		spin_unlock_irqrestore(&ma_dev->ma_dev_lock, irq_flags);
+
+		ret = mausb_internal_free_dev(ma_dev, mausb_dev);
+
+		spin_lock_irqsave(&ma_dev->ma_dev_lock, irq_flags);
+	}
+
+	if (!list_empty(&ma_dev->dev_list)) {
+		/* could not clear all the devices */
+		ret = -EAGAIN;
+	}
+
+	spin_unlock_irqrestore(&ma_dev->ma_dev_lock, irq_flags);
+
+	/* TODO: make sure this doesn't break any locking rules */
+	mausb_init_ma_device(ma_dev, ma_dev_addr, mass_id, mhcd,
+			     maudc, req_switch, device_connect);
+
+	return ret;
+}
+
+/**
+ * Initializes the media agnostic management structure.
+ */
+int mausb_init_mgmt(struct mausb_mgmt *mgmt, spinlock_t *ma_dev_lock,
+		int (*req_switch)(struct mausb_mgmt_pkt *req,
+		struct mausb_mgmt_pkt *resp, struct mausb_mgmt *mgmt))
+{
+	INIT_LIST_HEAD(&mgmt->req_list);
+	mgmt->token = 0;
+	mgmt->tx_pair.to_ms.context = NULL;
+	mgmt->tx_pair.to_ms.transfer_packet = NULL;
+	mgmt->tx_pair.to_ma.context = NULL;
+	mgmt->tx_pair.to_ma.transfer_packet = NULL;
+	mgmt->hub_dev_handle = 0;
+	mgmt->ma_dev_lock = ma_dev_lock;
+	mgmt->req_switch = req_switch;
+
+	return 0;
+}
+
+static void mausb_init_pkt_dmux(struct mausb_pkt_transfer *pkt_dmux,
+		void *context)
+{
+	pkt_dmux->transfer_packet = &mausb_pkt_dmux;
+	pkt_dmux->context = context;
+}
+
+/*
+ * Initializes the data structure for an MA USB device.
+ */
+int mausb_init_ma_device(struct ma_dev *ma_dev, __u8 ma_dev_addr, __u8 mass_id,
+		struct mausb_hcd *mhcd, struct mausb_udc *maudc,
+		int (*req_switch)(struct mausb_mgmt_pkt *req,
+		struct mausb_mgmt_pkt *resp, struct mausb_mgmt *mgmt),
+		int (*device_connect)(int))
+{
+	INIT_LIST_HEAD(&ma_dev->dev_list);
+	ma_dev->top_dev = NULL;
+	ma_dev->ma_dev_addr = ma_dev_addr;
+	ma_dev->mass_id = mass_id;
+	if (mhcd != NULL)
+		ma_dev->mhcd = mhcd;
+	if (maudc != NULL)
+		ma_dev->maudc = maudc;
+	spin_lock_init(&ma_dev->ma_dev_lock);
+	ma_dev->ma_drv.device_connect = device_connect;
+	mausb_init_pkt_dmux(&ma_dev->ma_drv.pkt_dmux, ma_dev);
+
+	mausb_init_mgmt(&ma_dev->mgmt, &ma_dev->ma_dev_lock, req_switch);
+
+	return 0;
+}
+EXPORT_SYMBOL(mausb_init_ma_device);
+
diff --git a/drivers/staging/mausb/drivers/mausb_mem.h b/drivers/staging/mausb/drivers/mausb_mem.h
new file mode 100644
index 0000000..870591f
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_mem.h
@@ -0,0 +1,509 @@
+/* Name:	mausb_mem.h
+ * Description: Header for mausb_mem.c. Needed do make calls to
+ *              functions defined in mausb_mem.c.
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
+#ifndef __MAUSB_MEM_H
+#define __MAUSB_MEM_H
+
+#include "mausb_state.h"
+#include "mausb_pkt.h"
+#include "mausb_msapi.h"
+
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/usb/gadget.h>
+#include <linux/timer.h>
+
+#ifdef DEBUG
+#define mamem_dbg(format, arg...) \
+	printk(KERN_DEBUG format, ##arg)
+#else
+#define mamem_dbg(format, arg...)
+#endif
+
+#define mamem_warn(format, arg...) \
+	printk(KERN_WARNING format, ##arg)
+
+#define mamem_err(format, arg...) \
+	printk(KERN_ERR format, ##arg)
+
+/* forward declarations */
+struct mausb_urb;
+struct mausb_pkt;
+struct mausb_host_ep;
+
+/**
+ * mausb_mgmt - MAUSB management datastrucure
+ *
+ * Contains all the data necessary to handle management packets.
+ *
+ * @req_list:		List of all currently pending management requests for
+ *			this device.
+ * @token:		The value of the token field in the most recently sent
+ *			management request.
+ * @tx_pair:		Indicates where management packets should be sent.
+ *
+ * The following variables are to store common management packet fields:
+ *
+ * @hub_dev_handle:	Device Handle of the MAUSB Dock hub. used for
+ *                  	USBDevHandleReq packets.
+ * @ma_dev_lock:	The spinlock which protects the management data in this
+ *			struct.
+ * @req_switch:		The host or devices request switch. It accepts an
+ * 			incoming request, makes the necessary calls, and
+ *			returns a partially completed response (it fills the
+ *			response type, status & any data fields specific to
+ *			that response). the remainder of the fields are
+ *			completed by mausb_rx_mgmt_req.
+ */
+struct mausb_mgmt {
+	struct list_head		req_list;
+	__u16				token:10;
+	struct mausb_transfer_pair	tx_pair;
+	__u16				hub_dev_handle;
+	spinlock_t			*ma_dev_lock;
+	int (*req_switch)(struct mausb_mgmt_pkt *req,
+			struct mausb_mgmt_pkt *resp, struct mausb_mgmt *mgmt);
+};
+
+/**
+ * mausb_mgmt_req_list - MAUSB management request list entry
+ *
+ * An entry in the mausb_mgmt request linked list.
+ *
+ * @req_list:	Pointers to other entries in the list.
+ * @mgmt_req:	The request management packet.
+ * @mgmt_resp:	The response management packet, set to NULL until a response
+ *		is received.
+ * @resp_rcvd:	An event triggered when the response is received.
+ */
+struct mausb_mgmt_req_list {
+	struct list_head	req_list;
+
+	struct mausb_pkt	*mgmt_req;
+	struct mausb_pkt	*mgmt_resp;
+
+	struct completion	resp_rcvd;
+};
+
+/**
+ * Media Agnostic Session State
+ *
+ * Defines the current state of the session between the host & device.
+ * Per MAUSB spec, sections 7.1 & 8.1.1.
+ */
+enum mausb_session_state {
+	MAUSB_SESSION_DOWN,
+	MAUSB_SESSION_CONNECTING,
+	MAUSB_SESSION_ACITVE,
+	MAUSB_SESSION_INACTIVE
+};
+
+/**
+ * stores information returned in a CapResp packet
+ */
+struct ma_capability {
+	__u16		num_ep;
+	__u8		num_dev;
+	__u8		num_stream:5;
+	__u8		dev_type:3;
+	__u16		max_tx_reqs;
+	__u16		max_mgmt_reqs:12;
+};
+
+/**
+ * MA device data
+ *
+ * This structure is used to hold MA device-specific data
+ * (i.e. one instance of this structure exists per MA device).
+ *
+ * @mgmt:		Contains the data needed to keep track of the device's
+ *			management packets.
+ * @dev_list:		Stores a list of the devices connected to this HCD.
+ *			This includes any internal mausb data that exists on
+ *			a per-device, per-endpoint, or per-transfer basis.
+ * @top_dev:		The most upstream mausb device. Used to determine
+ *			where to send MA USB device management packets (such as
+ *			MAUSBDevSleepReq and MAUSBDevWakeReq).
+ * @session_state:	Defines the current state of the session between the
+ *			host and device. Per MAUSB spec, sections 7.1 & 8.1.1.
+ * @ma_dev_addr: 	MA Device Address. Assigned by the host via a
+ *               	MAUSBDevResetReq.
+ * @mass_id:		Media-Agnostic Service Set Identifier. Assigned by the
+ *			host via a MAUSBDevResetReq.
+ * @ma_dev_lock:	Spinlock for this device. This lock should be held
+ *			before accessing any data in this structure.
+ * @ma_drv:		Media agnostic driver interfaces.
+ * @ms_drv:		Media specific driver interfaces.
+ * @ma_cap:		Stores MA device info from CapResp packet fields.
+ * @speed:		Stores MA device info from speed capability descriptor.
+ * @pout:		Stores MA device info from P-managed OUT capability
+ *			descriptor.
+ * @iso:		Stores MA device info from isochronous capabilities
+ *			descriptor.
+ * @synch:		Stores MA device info from synchronization capabilities
+ *			descriptor.
+ * @cont_id:		Stores MA device info from container ID capability
+ *			descriptor.
+ * @link_sleep:		Stores MA device info from link sleep capability
+ *			descriptor.
+ */
+struct ma_dev {
+	struct mausb_mgmt		mgmt;
+	struct list_head		dev_list;
+	struct mausb_dev		*top_dev;
+	enum mausb_session_state	session_state;
+	__u8				ma_dev_addr:7;
+	__u8				mass_id;
+	spinlock_t			ma_dev_lock;
+
+	union {
+		struct mausb_hcd *mhcd;
+		struct mausb_udc *maudc;
+	};
+
+	struct mausb_ma_drv		ma_drv;
+	struct mausb_ms_drv		*ms_driver;
+
+	struct ma_capability		ma_cap;
+	struct mausb_dev_cap_speed	*speed;
+	struct mausb_dev_cap_pout	*pout;
+	struct mausb_dev_cap_iso	*iso;
+	struct mausb_dev_cap_sync	*sync;
+	struct mausb_dev_cap_cont_id	*cont_id;
+	struct mausb_dev_cap_link_sleep *link_sleep;
+};
+
+/**
+ * MA USB device data
+ *
+ * This structure is used to hold device-pecific data
+ * (i.e. one instance of this structure exists per usb device).
+ *
+ * @dev:		A pointer to the kernel's usb device structure. Can be
+ *			used to uniquely identify a device.
+ * @gadget:		A pointer to the kernel's usb gadget structure.
+ * @ma_dev:		Pointer to parent ma_dev structure.
+ * @ep_list:		A linked list of all the endpoints for this device.
+ *              	MAUSBDevHandleResp packet.
+ * @dev_handle:		MA USB device handle for this device
+ * @dev_address:	The usb device address. set by the ma_dev.
+ *               	NOTE: this is not the same as the address given by
+ *			the kernel.
+ * @dev_list:		A linked list of all the devices in the HCD.
+ * @dev_lock:		Spinlock for this device. This lock should be held
+ * 			before accessing any data in this structure.
+ */
+struct mausb_dev {
+	union {
+		struct usb_device *dev;	   /* Host only */
+		struct usb_gadget *gadget; /* Device only */
+	};
+	struct ma_dev     *ma_dev;
+	struct list_head   ep_list;
+	__u16              dev_handle;
+	__u8               dev_address;
+	struct list_head   dev_list;
+	spinlock_t         dev_lock;
+};
+
+/**
+ * MAUSB Endpoint Handle State Variables
+ *
+ * Defines the states for an MA USB Endpoint Handle.
+ *
+ * Per MAUSB spec, seciton 7.2
+ *
+ * Note: MAUSB_EP_HANDLE_DELETED is used to flag an endpoint for deletion
+ *       it is not per spec; endpoints in this state should not be used and
+ *       will be deleted in the next EPHandleDeleteReq.
+ */
+enum mausb_ep_handle_state {
+	MAUSB_EP_HANDLE_UNASSIGNED = 0,
+	MAUSB_EP_HANDLE_ACTIVE,
+	MAUSB_EP_HANDLE_INACTIVE,
+	MAUSB_EP_HANDLE_HALTED,
+	MAUSB_EP_HANDLE_DELETED
+};
+
+/**
+ * MA USB host-side endpoint data
+ *
+ * This structure is used to hold endpoint-specific data
+ * (i.e. one instance of this structure exists per endpoint).
+ *
+ * The following data is protected by the devices's dev_lock:
+ *
+ * @ep: 	Used only by the host side. A pointer to the kernel's host-side
+ *      	endpoint structure. Can be used to uniquely identify an
+ *		endpoint. Note: the HCD probably shouldn't read or write
+ *		anything from the usb_host_endpoint structure, since it belongs
+ *		to the kernel.
+ * @dev_ep:	Used only by the device side. A pointer to the kernel's
+ *          	device-side endpoint structure.
+ * @ep_list:	A linked list of all the endpoints connected to the same
+ *           	device.
+ *
+ * The following data is protected by the endpoint's ep_lock:
+ *
+ * @state:		The MA USB state variables for this endpoint. Per
+ *			MA USB Spec, sections 5.4.1 and 5.5.2.
+ * @active_transfer:	Urb that maps to the transfer in progress.
+ * @ep_handle:		The endpoint handle to be used by packets for this
+ *			endpoint per MA USB Spec, section 6.2.1.5.
+ * @ep_handle_state:	Defines the states an Endpoint Handle can be in.
+ *                   	Per MA USB Spec, section 7.2.
+ * @buffer:		Buffer that holds data going to/from a host during
+ *			transfer.
+ * @actual_length:	Length of buffer.
+ * @lman_support:	For control or non-iso OUT endpoints. Indicates if
+ *                	link-managed tranfers are supported. Not valid until
+ *                	an EPHandleResp is received for this endpoint.
+ * @control_dir:	Control endpoints only; used to determine the direction
+ *               	of the current transfer.
+ * @ccu:		The credit conumption unit, in bytes. Per MA USB Spec,
+ *			table 27.
+ * @mausb_dev:		The device the endpoint belongs to.
+ * @urb_list:		A linked list of all URBs pending for this endpoint.
+ *            		URBs map one-to-one with MAUSB Transfers, so each entry
+ *            		also represents an MA USB Transfer.
+ * @usb_req_list:	Only used on the device side. A linked list of all
+ *                	usb_requests submitted to this endpoint.
+ * @req_list:		Head of list of created transferRequests and
+ *	      		transferAck packets.
+ * @resp_list:		Head of list of received transferResponses packets.
+ * @ep_lock:		Spinlock for this endpoint. This lock should be held
+ *			before accessing any data in this structure.
+ * @timer:		Endpoint timer structure, used to monitor transfer
+ *			timeouts.
+ * @timeout_task:	Thread used to perform packet resends after transfer
+ *			timeout.
+ * @host_ep_wq:		Work queue for timeout thread to wait on while sleeping.
+ * @tx_timed_out:	Used to flag when a timeout event has occured during
+ *			a transfer.
+ * @tx_pair:		Transfer pair for this endpoint.
+ * @gadget:		USB gadget associated with this endpoint.
+ * @busy:		True if this endpoint is busy, otherwise false.
+ * @halted:		1 if endpoint is halted, otherwise 0.
+ * @wedged:		1 if endpoint is wedged, otherwise 0.
+ * @stream_en:		1 if streams are enabled for this endpoint, otherwise 0.
+ * @max_pkt:		Max packet size for this endpoint.
+ */
+struct mausb_host_ep {
+
+	struct usb_host_endpoint	*ep; 	 /* Host only */
+	struct usb_ep			*dev_ep; /* Device only */
+	struct list_head		ep_list;
+	struct mausb_ep_state		state;
+	struct mausb_urb		*active_transfer;
+	struct mausb_ep_handle		ep_handle;
+	enum mausb_ep_handle_state	ep_handle_state;
+	void				*buffer;
+	u32				actual_length;
+	bool				lman_support;
+	bool				control_dir;
+	u16				ccu;
+	struct mausb_dev		*mausb_dev;
+	struct list_head		urb_list;
+	struct list_head		*usb_req_list;
+	struct list_head		req_list;
+	struct list_head		resp_list;
+	spinlock_t			ep_lock;
+	struct timer_list		timer;
+	struct task_struct		*timeout_task;
+	wait_queue_head_t		host_ep_wq;
+	bool				tx_timed_out;
+	struct mausb_transfer_pair	tx_pair;
+	struct usb_gadget		*gadget; /* Device only */
+	bool				busy;
+	unsigned			halted:1;
+	unsigned			wedged:1;
+	unsigned			stream_en:1;
+	u16                             max_pkt;
+};
+
+/**
+ * endpoint request structure - describes one I/O request
+ *
+ * @usb_ep:	A device-side endpoint structure.
+ * @queue:	The list of all requests currently enqueued to this endpoint.
+ */
+struct mausb_gadget_ep {
+	struct usb_ep dev_ep;
+	struct list_head usb_req_list;
+};
+
+/**
+ * MA USB urb structure
+ *
+ * Stores MAUSB-specific urb data. In our implementation, one urb from usb
+ * core maps to exactly one MA USB transfer. When an urb is submitted, it
+ * queues a new transfer. When a transfer is complete (or fails), the urb
+ * is given back to the core.
+ *
+ * All data listed in this structure is protected by the ep_lock.
+ * If you want to use any of this data, you need to be in posession
+ * of this lock.
+ *
+ * @urb:		Used only on the host side. The urb submitted to the
+ *			HCD by usbcore.
+ * @usb_request_list:	Used only on the device side. A pointer to the list of
+ *                    	msusb_requests for this endpoint.
+ * @urb_list:		Connects this mausb_urb with other mausb_urbs
+ *			queued to the same endpoint.
+ * @ma_hcd_urb_list:	Connects this urb to urbs queued to the same ma hcd.
+ * @state:		Current state of the transfer as defined in the
+ *			MA USB Spec.
+ * @ep:			The endpoint that the transfer belongs to.
+ * @dev:		The device that the transfer belongs to.
+ * @transfer_size:	Total number of bytes for transfer associated with urb.
+ */
+struct mausb_urb {
+	struct urb			*urb;		   /* Host Only */
+	struct list_head		*usb_request_list; /* Device Only */
+	struct list_head		urb_list;
+	struct list_head		ma_hcd_urb_list;
+	struct mausb_transfer_state	state;
+	struct mausb_host_ep		*ep;
+	struct mausb_dev		*dev;
+	unsigned int			transfer_size;
+};
+
+/**
+ * endpoint request structure - describes one I/O request
+ *
+ * @req:		The usb_request struct. Enqueuing a usb_request is
+ *			what triggers the creation of this struct.
+ * @usb_req_list:	List of all requests enqueued at this endpoint.
+ */
+struct mausb_request {
+	struct usb_request req;
+	struct list_head   usb_req_list;
+};
+
+/* endpoint/device helper functions */
+struct mausb_host_ep *usb_to_ma_endpoint(struct usb_host_endpoint *ep);
+int mausb_hcd_urb_count(struct mausb_hcd *mhcd);
+
+#define MAUSB_ADD  true
+#define MAUSB_DEL  false
+#define MAUSB_DEV  false
+#define MAUSB_HOST true
+#define MAUSB_OUT  false
+#define MAUSB_IN   true
+struct mausb_pkt *mausb_create_dp(int *status, struct mausb_urb *maurb,
+		bool in, bool host, gfp_t memflags);
+
+/* endpoint/device memory management functions */
+struct mausb_host_ep *mausb_state_to_ep(struct mausb_ep_state *state);
+struct ma_dev *context_to_ma_dev(void *context);
+struct mausb_hcd *mausb_host_ep_to_mahcd(struct mausb_host_ep *ep);
+struct mausb_udc *mausb_host_ep_to_maudc(struct mausb_host_ep *ep);
+struct mausb_dev *usb_dev_to_mausb_dev(struct usb_device *udev);
+struct mausb_host_ep *mausb_find_ep_dev(struct usb_ep *dev_ep,
+		struct mausb_dev *mausb_dev);
+struct mausb_host_ep *mausb_find_ep_host(struct usb_host_endpoint *ep,
+		struct mausb_dev *mausb_dev);
+struct mausb_host_ep *mausb_find_ep_by_handle(struct mausb_ep_handle *handle,
+		struct mausb_dev *mausb_dev);
+struct mausb_host_ep *mausb_find_ep_from_handle(struct mausb_ep_handle handle,
+		struct ma_dev *ma_dev);
+struct mausb_pkt *mausb_pkt_from_ms_pkt_ma_dev(struct ms_pkt *ms_pkt,
+		struct ma_dev *ma_dev, gfp_t mem_flags);
+struct mausb_pkt *mausb_pkt_from_ms_pkt_ep(struct ms_pkt *ms_pkt,
+		struct mausb_host_ep *ep, gfp_t mem_flags);
+struct mausb_dev *mausb_find_dev(struct ma_dev *ma_dev, struct usb_device *dev,
+		unsigned long *handle, struct usb_gadget *gadget);
+struct mausb_dev *mausb_find_dev_host(struct ma_dev *ma_dev,
+		struct usb_device *dev);
+struct mausb_host_ep *mausb_find_ep_by_desc(
+		const struct usb_endpoint_descriptor *ep_desc,
+		struct mausb_dev *mausb_dev);
+struct mausb_host_ep *mausb_find_ep_by_address(u8 address,
+		struct mausb_dev *mausb_dev);
+struct mausb_urb *mausb_alloc_maurb(struct mausb_host_ep *ma_ep,
+		gfp_t memflags);
+int mausb_internal_drop_maurb(struct mausb_urb *maurb, struct mausb_hcd *mhcd);
+void init_ep_state(struct mausb_ep_state *state, u32 buf_size);
+int mausb_activate_endpoints(struct mausb_dev *mausb_dev);
+void mausb_link_ma_ep_to_usb_ep(struct mausb_host_ep *ma_ep,
+		struct usb_ep *dev_ep);
+struct mausb_gadget_ep *usb_ep_to_mausb_gadget_ep(struct usb_ep *ep);
+int mausb_internal_add_ep(struct mausb_dev *ma_dev,
+		struct usb_host_endpoint *ep, struct usb_ep *dev_ep,
+		struct mausb_host_ep **mausb_ep,
+		int (*transfer_timeout)(void *data), gfp_t memflags);
+int mausb_internal_drop_ep(struct mausb_host_ep *ma_ep);
+int mausb_update_ep(struct mausb_host_ep *ma_ep,
+		struct mausb_ep_des *ma_ep_des);
+struct mausb_dev *mausb_internal_alloc_dev(struct ma_dev *ma_dev,
+		struct usb_device *dev, struct usb_gadget *gadget);
+int mausb_internal_free_dev(struct ma_dev *ma_dev,
+		struct mausb_dev *mausb_dev);
+int mausb_internal_reset_ma_dev(struct ma_dev *ma_dev, __u8 ma_dev_addr,
+		__u8 mass_id, struct mausb_hcd *mhcd, struct mausb_udc *maudc);
+int mausb_init_ma_device(struct ma_dev *ma_dev, __u8 ma_dev_addr, __u8 mass_id,
+		struct mausb_hcd *mhcd, struct mausb_udc *maudc,
+		int (*req_switch)(struct mausb_mgmt_pkt *req,
+		struct mausb_mgmt_pkt *resp, struct mausb_mgmt *mgmt),
+		int (*device_connect)(int));
+int mausb_init_mgmt(struct mausb_mgmt *mgmt, spinlock_t *ma_dev_lock,
+		int (*req_switch)(struct mausb_mgmt_pkt *req,
+		struct mausb_mgmt_pkt *resp, struct mausb_mgmt *mgmt));
+const struct usb_endpoint_descriptor *mausb_get_ep_des(
+		struct mausb_host_ep *ma_ep);
+
+#endif
diff --git a/drivers/staging/mausb/drivers/mausb_state.h b/drivers/staging/mausb/drivers/mausb_state.h
new file mode 100644
index 0000000..01f0171
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_state.h
@@ -0,0 +1,184 @@
+/* Name:	mausb_state.h
+ * Description: Contains all of the state variables for hosts and devices as
+ *              defined by the MAUSB spec.
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
+#ifndef __MAUSB_STATE_H
+#define __MAUSB_STATE_H
+
+/**
+ * MAUSB endpoint state variables, per MA USB Spec sections 5.4.1 & 5.5.2.
+ *
+ * Note: this struct contains the fields necessary to store the state on both
+ * the host and device side.
+ *
+ * @seq_number:		For a sender, this field contains the sequence number
+ *			that should be placed in the next outgoing packet.
+ *              	For a receiver, this field contains the sequence number
+ *              	expected in the next incoming packet.
+ * @keep_alive_timer:	Timeout counter. Set to aMausbTransferKeepAlive
+ *                    	upon a new transfer initialization. To be decremented
+ *                    	every aMAUSBTransferTimeTick interval. If the timer
+ *                    	reaches 0, A retry is triggered.
+ * @retry_counter: 	Indicates how many more times the
+ *                 	transfer will be attempted. Decremented upon a timeout
+ *                 	(see keep_alive_timer for details). If this counter
+ *                 	reaches 0, the transfer fails due to a timeout.
+ * @request_id: 	Request ID number. for IN transfers,  all
+ *			transfer_request packets currently being sent or
+ *			received should have this request ID number. for OUT
+ *			transfers, All transfer_request and transfer_ack
+ *			packets currently being sent or received should have
+ *			this request ID number.
+ * @active_request_id: 	Active Request ID number. used by IN transfers only.
+ *                     	All transfer_ack packets being sent/received should
+ *                     	contain this number.
+ * @earliest_unacked: 	Stores the sequence number of the most recent packet
+ *                    	that has been sent out but has not been acknowledged
+ *                    	by the receiver.
+ * @rx_buf_size: 	Receiver Buffer Size. Used for OUT transfers only.
+ *			Indicates the available buffer space for packets in the
+ *			device (in bytes).
+ *			Note: this value is signed for the host and
+ *			unsigned for the receiver. A negative number
+ *			indicates a buffer overflow.
+ *			Note: defined in spec as a 25-bit signed int
+ *			for a host and a 32-bit unsigned for a device.
+ * @occupancy: 		Size (in bytes) of the payload accepted into the receive
+ *             		buffer. Used only on the device side for OUT transfers.
+ * @earliest_request_id:Request ID of earliest transferReq whose state
+ *			needs to be tracked (host IN).
+ * @transfer_retries:	Reload value for retry_counter. Should be set to
+ *		      	a ControlTransferRetries, aBulkTransferRetries,
+ *		      	or aInterruptTransferRetries depending on transfer
+ *		      	type.
+ * @delayed:		Set to true if the interval between two sucessive
+ *			transferResp packets exceeds aTransferRepeatTime.
+ * @tx_pending: 	Set to 1 when a transfer is in progress, otherwise it
+ *			should be zero. A new transfer cannot be started until
+ *			this flag is cleared.
+ */
+struct mausb_ep_state {                      /* HOST     | DEVICE       */
+
+	unsigned int seq_number:24;          /* IN | OUT | IN | OUT     */
+	int 	     keep_alive_timer;       /* IN | OUT | IN | OUT     */
+	unsigned int retry_counter;          /* IN | OUT | IN | OUT     */
+	__u8         request_id;             /* IN | OUT | IN | OUT     */
+	__u8         active_request_id;      /* IN | OUT | IN |         */
+	unsigned int earliest_unacked:24;    /*    | OUT | IN | OUT     */
+	__u32        rx_buf_size;            /*    | OUT |    | OUT     */
+	unsigned int occupancy;              /*    |     |    | OUT     */
+	u8	     earliest_request_id;    /* IN | OUT | IN | OUT     */
+	unsigned int transfer_retries;       /* IN | OUT | IN | OUT     */
+	bool	     delayed;                /*    |     | IN |         */
+
+	/* TODO: add response_timer (device IN and OUT/host OUT) */
+
+	unsigned int tx_pending:1;       /* beyond spec */
+};
+
+/**
+ * MA USB transfer state variables, per section 5.4.1 & 5.5.2.
+ *
+ * In our implementation, URBs and MAUSB transfers map one-to-one,
+ * so the transfer state and the urb state are one in the same.
+ *
+ * @rem_size:		The remaining transfer size (in bytes). This value is
+ *			set at the beginning of a transfer and is decremented
+ *			as data is received.
+ * @payload_size:	Payload size for out transfer (in bytes). For MA USB
+ *			host, it indicates the overall transfered OUT payload
+ *			size for the current urb. For MA USB device, It
+ *			indicates the received OUT payload size for the
+ *			current MA USB OUT request.
+ * @transfer_error:	A boolean which is only set to TRUE when a
+ *			non-recoverable error is detected in the transfer.
+ * @transfer_complete: 	A boolean which is only set to TRUE when a transfer
+ *                     	is evaluated to be complete. (ie. the final ACK has
+ *                     	has been sent/received).
+ * @eot_detected: 	A boolean which is only set to TRUE when a transfer
+ *                	is complete (ie: all the data has been transferred).
+ *                	Note: eot_detected & transfer_complete differ in when
+ *                	they are set. eot_detected is sent after the last data
+ *                	packet received, transfer_complete is set after the
+ *			final ACK.
+ * @last_transfer_sn: 	Last Transfer Sequence Number. Stores the sequence
+ *                    	number of the final packet of this transfer.
+ * @transfer_acked:	Set to true when a transferReq or transferAck packet is
+ *                  	released to the data channel acknowledging the last
+ *		    	transferResp belonging to a transfer.
+ * @k:			A  transfer-dependent multiplicative factor used to
+ *			reload keep_alive_timer when a transfer has a status
+ *			of TRANSFER_PENDING.
+ * @ack_transfer_sn:	The value of the sequence number in the last
+ *                   	transferReq packet that belongs to the transfer and
+ *                   	has the ARQ field set to 1.
+ */
+struct mausb_transfer_state {             /* HOST     | DEVICE       */
+
+	__u32        rem_size;            /* IN | OUT | IN | OUT     */
+	__u32        payload_size;        /* IN | OUT | IN | OUT     */
+	bool         transfer_error;      /* IN | OUT | IN | OUT     */
+	bool         transfer_complete;   /* IN | OUT | IN | OUT     */
+	bool         eot_detected;        /* IN |     | IN | OUT     */
+	unsigned int last_transfer_sn:24; /* IN |     | IN |         */
+	bool         transfer_acked;      /* IN | OUT |    |         */
+	unsigned int k;                   /* IN |     |    |         */
+	unsigned int ack_transfer_sn:24;  /*    | OUT |    |         */
+
+	/*TODO: add transfer_completion_timer (host IN) */
+};
+
+#endif
-- 
1.9.1

