Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaKKCOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:14:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:38739 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaKKCKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:10:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414590923"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [V2 PATCH 06/10] added media agnostic (MA) UDC
Date: Mon, 10 Nov 2014 18:09:37 -0800
Message-Id: <1415671781-11351-6-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we implement the behavior of a USB device controller for
the MA USB device-side driver. The MA UDC interfaces with a gadget driver
and appears to the driver as a regular UDC. However, instead of sending
USB packets over a wired USB bus, the MA UDC hands MA USB packets off to
a media specific layer for transport.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/mausb/drivers/mausb_udc.c | 1486 +++++++++++++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_udc.h |  147 +++
 2 files changed, 1633 insertions(+)
 create mode 100644 drivers/staging/mausb/drivers/mausb_udc.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_udc.h

diff --git a/drivers/staging/mausb/drivers/mausb_udc.c b/drivers/staging/mausb/drivers/mausb_udc.c
new file mode 100644
index 0000000..af00786
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_udc.c
@@ -0,0 +1,1486 @@
+/* name:	mausb_udc.c
+ * description: Implements a USB device controller(UDC) for interfacing with
+ *		gadget drivers. The gadget driver uses this interface to return
+ *		descriptors and to implement configuration and data transfer
+ *		protocols with the pHCD. The UDC also allocates and initializes
+ *		endpoints to support gadget/pHCD interfacing.
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
+ * Sean Stalley, sean.o.stalley@intel.com
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/platform_device.h>
+#include <linux/usb/ch11.h>
+#include <linux/usb/gadget.h>
+#include <linux/device.h>
+#include <linux/usb/composite.h>
+#include <linux/spinlock.h>
+
+#include "mausb_udc.h"
+#include "mausb_mgmt.h"
+#include "mausb_mem.h"
+#include "mausb_msapi.h"
+#include "mausb_tx.h"
+
+static const char	 ep0[] = "ep0";
+static const char *const ep_name[] = {ep0, "ep1", "ep2"};
+
+static struct platform_device udc_pdev;
+
+void udc_dev_release(struct device *dev)
+{
+	/* free any dynamically allocated structures here */
+}
+
+static inline struct mausb_udc *gadget_to_udc(struct usb_gadget *gadget)
+{
+	return container_of(gadget, struct mausb_udc, gadget);
+}
+
+static inline struct mausb_udc *gadget_dev_to_mausb_udc(struct device *dev)
+{
+	return container_of(dev, struct mausb_udc, gadget.dev);
+}
+
+static inline struct mausb_request *usb_req_to_mausb_req(
+		struct usb_request *req)
+{
+	return container_of(req, struct mausb_request, req);
+}
+
+static inline struct mausb_udc *mausb_ma_dev_to_udc(struct ma_dev *ma_dev)
+{
+	return container_of(ma_dev, struct mausb_udc, ma_dev);
+}
+
+/*
+ * forward declarations
+ */
+static int set_or_clear_gadget_feature(struct usb_ctrlrequest *ctrlreq,
+		struct mausb_udc *udc, int set);
+static int get_gadget_status(struct usb_ctrlrequest *ctrlreq,
+		struct mausb_udc *udc);
+
+/**
+ * Finds a matching endpoint for a given address.
+ */
+static struct usb_ep *get_ep(struct mausb_udc *udc, u8 address)
+{
+	int			i;
+	struct usb_ep		*ep;
+
+	/* address is 0 (ignore direction bit flag) */
+	if ((address & ~USB_DIR_IN) == 0)
+		return &udc->usb_ep[0].dev_ep;
+
+	/* otherwise look for match */
+	for (i = 1; i < MAUDC_MAX_NUM_EP; i++) {
+
+		ep = &udc->usb_ep[i].dev_ep;
+
+		if (ep->address == address)
+			return ep;
+	}
+
+	maudc_dbg(udc, "%s: no endpoint found for address 0x%x\n",
+		__func__, address);
+
+	return NULL;
+}
+
+/**
+ * Called by gadget driver to enable endpoint.
+ */
+static int mausb_ep_enable(struct usb_ep *ep,
+		const struct usb_endpoint_descriptor *desc)
+{
+	struct mausb_udc		*udc = platform_get_drvdata(&udc_pdev);
+	struct mausb_host_ep		*ma_ep = mausb_find_ep_by_desc(desc,
+						udc->mausb_dev);
+
+	maudc_dbg(udc, "%s: enabling gadget endpoint %s\n",
+		__func__, ep->name);
+
+	/* ep0 is control endpoint, don't try and configure it */
+	if (ep->name == ep0) {
+		maudc_err(udc, "%s: cannot configure ep0\n", __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * Get maximum packet size from descriptor and set for ep.
+	 * Bits 0->10 of wMaxPacketSize = maximum packet size for HS and
+	 * FS devices maximum packet size for SS devices = 1024.
+	 */
+	ep->maxpacket = EP_MAX_PACKET;
+
+	if (NULL != ma_ep)
+		mausb_link_ma_ep_to_usb_ep(ma_ep, ep);
+
+	return 0;
+}
+
+/**
+ * Called by gadget driver to disable endpoint.
+ */
+static int mausb_ep_disable(struct usb_ep *ep)
+{
+	struct mausb_udc *udc = platform_get_drvdata(&udc_pdev);
+
+	if (!ep) {
+		maudc_dbg(udc, "%s: no endpoint\n", __func__);
+		return -EINVAL;
+	}
+
+	maudc_dbg(udc, "%s: disabling gadget endpoint %s\n",
+		__func__, ep->name);
+
+	return 0;
+}
+
+/**
+ * Called by gadget driver to allocate a request packet.
+ */
+static struct usb_request *mausb_ep_alloc_request(struct usb_ep *ep,
+		gfp_t mem_flags)
+{
+	struct mausb_request *req;
+
+	if (!ep)
+		return NULL;
+
+	req = kzalloc(sizeof(*req), mem_flags);
+	if (!req)
+		return NULL;
+
+	INIT_LIST_HEAD(&req->usb_req_list);
+
+	return &req->req;
+}
+
+/**
+ * Called by gadget driver to free a request packet.
+ */
+static void mausb_ep_free_request(struct usb_ep *ep, struct usb_request *req)
+{
+	struct mausb_request *mreq;
+
+	if (!ep || !req)
+		return;
+
+	mreq = usb_req_to_mausb_req(req);
+	kfree(mreq);
+}
+
+/**
+ * Called by gadget driver to queue a request.
+ */
+static int mausb_ep_queue(struct usb_ep *ep, struct usb_request *req,
+		gfp_t mem_flags)
+{
+	struct mausb_udc		*udc = platform_get_drvdata(&udc_pdev);
+	struct mausb_request		*ma_req;
+	struct mausb_gadget_ep		*gadget_ep;
+
+	if (!ep) {
+		maudc_err(udc, "%s: no endpoint\n", __func__);
+		return -EINVAL;
+	}
+
+	if (!req) {
+		maudc_err(udc, "%s: no USB request\n", __func__);
+		return -EINVAL;
+	}
+
+	ma_req = usb_req_to_mausb_req(req);
+	gadget_ep = usb_ep_to_mausb_gadget_ep(ep);
+
+	req->status = -EINPROGRESS;
+	req->actual = 0;
+
+	maudc_dbg(udc, "%s: queueing request to ep %i at 0x%p with data at "
+		"0x%p\n", __func__, usb_endpoint_num(ep->desc), ep, req->buf);
+
+	list_add_tail(&ma_req->usb_req_list, &gadget_ep->usb_req_list);
+
+	return 0;
+}
+
+/**
+ * Called by gadget driver to dequeue a request.
+ */
+static int mausb_ep_dequeue(struct usb_ep *ep, struct usb_request *req)
+{
+	struct mausb_udc		*udc = platform_get_drvdata(&udc_pdev);
+	struct mausb_request		*ma_req;
+
+	if (!ep) {
+		maudc_err(udc, "%s: no endpoint\n", __func__);
+		return -EINVAL;
+	}
+
+	if (!req) {
+		maudc_err(udc, "%s: no USB request\n", __func__);
+		return -EINVAL;
+	}
+
+	ma_req = usb_req_to_mausb_req(req);
+
+	list_del(&ma_req->usb_req_list);
+
+	maudc_dbg(udc, "%s: dequeueing request\n", __func__);
+
+	return 0;
+}
+
+/**
+ * Halts or clears a halt of an endpoint.
+ */
+static int mausb_ep_set_halt(struct usb_ep *ep, int value)
+{
+	struct mausb_udc 	*udc = platform_get_drvdata(&udc_pdev);
+	struct mausb_host_ep	*ma_ep = mausb_find_ep_dev(ep, udc->mausb_dev);
+
+	if (NULL == ma_ep) {
+		maudc_err(udc, "%s: no MA USB endpoint\n", __func__);
+		return -EINVAL;
+	}
+
+	/* probably don't want to halt default control ep */
+	if (ma_ep->dev_ep->name == ep0) {
+		maudc_err(udc, "%s: cannot halt ep0!\n", __func__);
+		return -EINVAL;
+	}
+
+	if (value) {
+		maudc_dbg(udc, "%s: halting ep\n", __func__);
+		ma_ep->halted = 1;
+	}
+
+	else {
+		maudc_dbg(udc, "%s: clearing ep halt\n", __func__);
+		ma_ep->halted = 0;
+	}
+
+	return 0;
+}
+
+/**
+ * Wedges an endpoint; wedge causes request to clear halt from host to be
+ * ignored.
+ */
+static int mausb_ep_set_wedge(struct usb_ep *ep)
+{
+	struct mausb_udc	*udc = platform_get_drvdata(&udc_pdev);
+	struct mausb_host_ep	*ma_ep = mausb_find_ep_dev(ep, udc->mausb_dev);
+
+	if (NULL == ma_ep) {
+		maudc_err(udc, "%s: no MA USB endpoint\n", __func__);
+		return -EINVAL;
+	}
+
+	/* wedging default control ep is probably bad */
+	if (ma_ep->dev_ep->name == ep0) {
+		maudc_dbg(udc, "%s: cannot wedge ep0\n", __func__);
+		return -EINVAL;
+	}
+
+	ma_ep->halted = 1;
+	ma_ep->wedged = 1;
+
+	return 0;
+}
+
+static struct usb_ep_ops mausb_ep_ops = {
+	.enable = mausb_ep_enable,
+	.disable = mausb_ep_disable,
+	.alloc_request = mausb_ep_alloc_request,
+	.free_request = mausb_ep_free_request,
+	.queue = mausb_ep_queue,
+	.dequeue = mausb_ep_dequeue,
+	.set_halt = mausb_ep_set_halt,
+	.set_wedge = mausb_ep_set_wedge
+};
+
+/*---------------------- transfer operations ------------------------------*/
+
+/**
+ * Handles control requests from usb core. Returns 0 if request is fully
+ * handled, otherwise returns the length of the transfer
+ */
+static int handle_ma_control_request(struct mausb_host_ep *ep,
+		struct usb_ctrlrequest *ctrlreq)
+{
+	int			ret = 0;
+	struct mausb_udc	*udc = platform_get_drvdata(&udc_pdev);
+
+	if (!ctrlreq) {
+		maudc_err(udc, "%s: no control request\n", __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * UDC handles set/clear feature, get status, and set address
+	 * requests, anything else is passed to gadget driver.
+	 */
+	switch (ctrlreq->bRequest) {
+	case USB_REQ_CLEAR_FEATURE:
+		maudc_dbg(udc, "USB_REQ: clearing feature\n");
+		ret = set_or_clear_gadget_feature(ctrlreq, udc, 0);
+		break;
+
+	case USB_REQ_GET_STATUS:
+		maudc_dbg(udc, "USB_REQ: getting status\n");
+		ret = get_gadget_status(ctrlreq, udc);
+		break;
+
+	case USB_REQ_SET_FEATURE:
+		maudc_dbg(udc, "USB_REQ: setting feature\n");
+		ret = set_or_clear_gadget_feature(ctrlreq, udc, 1);
+		break;
+
+	default: /* pass the request to the gadget driver */
+		maudc_dbg(udc, "USB_REQ: forwarding REQ #%i to gadget driver\n",
+				ctrlreq->bRequest);
+		if (NULL != udc->driver)
+			ret = udc->driver->setup(&udc->gadget, ctrlreq);
+		else
+			maudc_err(udc, "gadget driver not found\n");
+
+		if (ret >= 0)
+			ret = ctrlreq->wLength;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * Transfers contents of request and endpoint buffers.
+ */
+int do_ma_transfer(struct mausb_host_ep *ep, struct mausb_pkt *tx_req,
+		bool dir_in)
+{
+	int				i = 0;
+	int				out_copy_length = 0;
+	int				ret, host_len, device_len;
+	int				status = -EINPROGRESS;
+	int				length = 0;
+	struct mausb_transfer_state	*tx_state = &ep->active_transfer->state;
+	struct mausb_request		*req, *next;
+	struct mausb_udc		*udc = platform_get_drvdata(&udc_pdev);
+	void				*epbuf, *rbuf;
+
+	/* look for setup data */
+	if (tx_req->setup)
+		ret = handle_ma_control_request(ep, tx_req->setup);
+
+	if (NULL == ep->usb_req_list)
+		return -ENOTCONN;
+
+	if (list_empty(ep->usb_req_list) && !in_interrupt()) {
+		maudc_dbg(udc, "wait gadget function driver submit request\n");
+		while (list_empty(ep->usb_req_list) &&
+		       i <= MAUSB_GADGET_TIMEOUT) {
+			msleep(1);
+			i++;
+		}
+	}
+	if (i > MAUSB_GADGET_TIMEOUT) {
+		maudc_dbg(udc, "Wait gadget request time out\n");
+		return -ETIMEDOUT;
+	}
+
+ loop_request_queue:
+	/* take care of each request in request queue */
+	list_for_each_entry_safe(req, next, ep->usb_req_list, usb_req_list) {
+
+		if (dir_in)
+			host_len = tx_state->rem_size - ep->actual_length;
+		else
+			host_len = tx_req->buffer_length - out_copy_length;
+		device_len = req->req.length - req->req.actual;
+		length = min(host_len, device_len);
+
+		/* there is something to transfer so do transfer */
+		if (length > 0) {
+
+			rbuf = req->req.buf + req->req.actual;
+
+			/*
+			 * If IN transfer, copy req buffer contents into
+			 * ep buffer. Vice versa for OUT transfer.
+			 */
+			if (dir_in) {
+				epbuf = ep->buffer + ep->actual_length;
+				if (epbuf)
+					memcpy(epbuf, rbuf, length);
+				else
+					maudc_err(udc, "%s: no ep buffer\n",
+						__func__);
+			} else {
+				/*
+				 * For bulk OUT, we can't use ep->actual_length
+				 * as indicator because ep->buffer for every
+				 * transfer request is only "rx_buf_size" bytes
+				 * length.
+				 */
+				epbuf = ep->buffer + out_copy_length;
+				memcpy(rbuf, epbuf, length);
+				out_copy_length += length;
+			}
+			ep->actual_length += length;
+			req->req.actual += length;
+		}
+		/* zero length packet ends a read */
+		else {
+			req->req.status = 0;
+			status = 0;
+		}
+
+		/*
+		 * A transfer usually ends when buffer contents are completely
+		 * transferred. But, look out for for the zero packet transfer
+		 * flag. If flag is set, bulk OUT transfers need to wait for
+		 * zero length packet (short packet) for completion.
+		 */
+		if ((req->req.length == req->req.actual) ||
+		    /* bulk IN short packet */
+		    (dir_in && (req->req.actual % ep->dev_ep->maxpacket)) ||
+		    /* bulk OUT transfer all data requested by host urb*/
+		    (!dir_in && ep->active_transfer->transfer_size
+		     == ep->actual_length) ||
+		    /* bulk OUT last request */
+		    (!dir_in && req->req.zero)) {
+			req->req.status = 0;
+			/* device completion */
+			list_del_init(&req->usb_req_list);
+			req->req.complete(ep->dev_ep, &req->req);
+		}
+
+		if (tx_state->rem_size == 0)
+			status = 0;
+
+		/*
+		 * Host completion - end when nothing left to read/write,
+		 * otherwise keep going through queue.
+		 */
+		if (status != -EINPROGRESS)
+			break;
+		/* bulk IN/OUT transfers last request serves for one host urb */
+		if (tx_state->rem_size == req->req.actual) {
+			maudc_dbg(udc, "bulk IN/OUT last request return\n");
+			break;
+		}
+		/* bulk IN short packet */
+		if (dir_in && (req->req.actual % ep->dev_ep->maxpacket)) {
+			maudc_dbg(udc, "bulk IN short packet return\n");
+			break;
+		}
+		/*
+		 * Bulk OUT transfer contains multiple bulk OUT MA requests.
+		 * So for bulk out MA request just return to serve subsequent
+		 * bulk out MA request.
+		 */
+		if (!dir_in && host_len == length) {
+			maudc_dbg(udc, "normal bulk OUT MA request return\n");
+			break;
+		}
+		/*
+		 * Gadget driver should transfer more data to
+		 * serve bulk IN transfer, then wait for more requests.
+		 */
+		if (dir_in && (req->req.actual % ep->dev_ep->maxpacket == 0) &&
+		    (tx_state->rem_size - ep->actual_length > 0)
+		    && !req->req.zero) {
+			if (list_empty(ep->usb_req_list)) {
+				maudc_dbg(udc, "bulk IN: gadget request queue"
+					" is empty - waiting . . .\n");
+				while (list_empty(ep->usb_req_list))
+					msleep(1);
+			}
+			goto loop_request_queue;
+		}
+		/*
+		 * Doesn't copy all data in MA USB bulk OUT request.
+		 * Wait for additional gadget requests
+		 * to serve this MA USB bulk OUT request.
+		 */
+		if (!dir_in && (host_len > length)) {
+			if (list_empty(ep->usb_req_list)) {
+				maudc_dbg(udc, "bulk OUT: gadget request"
+					" is queue empty - waiting . . .\n");
+				while (list_empty(ep->usb_req_list))
+					msleep(1);
+			}
+			goto loop_request_queue;
+		}
+	}
+
+	return ep->actual_length;
+}
+
+
+/*------------------------- gadget operations -------------------------*/
+
+/**
+ * Handles control request to get device status.
+ */
+static int get_gadget_status(struct usb_ctrlrequest *ctrlreq,
+		struct mausb_udc *udc)
+{
+	int			ret = 0;
+	char			*buf;
+	unsigned int		address = le16_to_cpu(ctrlreq->wIndex);
+	struct usb_ep		*usb_ep = get_ep(udc, address);
+	struct mausb_host_ep	*ma_ep = mausb_find_ep_dev(usb_ep,
+					udc->mausb_dev);
+
+	if (!ma_ep) {
+		maudc_err(udc, "%s: cannot find endpoint\n", __func__);
+		return -EINVAL;
+	}
+
+	buf = (char *)ma_ep->buffer;
+
+	maudc_dbg(udc, "%s: responding to request type %i\n",
+			__func__, ctrlreq->bRequestType);
+
+	/* requesting device status */
+	switch (ctrlreq->bRequestType) {
+	case DEV_IN_REQ:
+		buf[0] = udc->dev_status;
+		ma_ep->actual_length = 1;
+		break;
+
+	/* requesting an endpoint status */
+	case EP_IN_REQ:
+		buf[0] = ma_ep->halted;
+		ma_ep->actual_length = 1;
+		break;
+
+	/* requesting interface status */
+	case INTF_IN_REQ:
+		buf[0] = 0;
+		break;
+
+	default:
+		maudc_dbg(udc, "%s: invalid request type %i\n",
+			__func__, ctrlreq->bRequestType);
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * Handles control request to set a gadget device feature.
+ */
+static int set_or_clear_gadget_feature(struct usb_ctrlrequest *ctrlreq,
+		struct mausb_udc *udc, int set)
+{
+	int			ret = 0;
+	unsigned int		address = le16_to_cpu(ctrlreq->wIndex);
+	struct usb_ep		*usb_ep = get_ep(udc, address);
+	struct mausb_host_ep	*ma_ep  = mausb_find_ep_dev(usb_ep,
+					udc->mausb_dev);
+
+	if (ctrlreq->bRequestType == EP_REQ) {
+
+		if (!ma_ep)
+			ret = -EINVAL;
+		else if (ma_ep->dev_ep->name == udc->gadget.ep0->name) {
+			maudc_err(udc, "%s: cannot halt ep0!\n", __func__);
+			ret = -EINVAL;
+		} else {
+			ma_ep->halted = set;
+			maudc_dbg(udc, "%s: %s halt %s\n", __func__,
+				ma_ep->dev_ep->name, set ? "set" : "cleared");
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * Handles incoming management packets. Used to pass an MA USB management
+ * packet to the device.
+ */
+static int maudc_transfer_mgmt_packet(struct ms_pkt *ms_pkt, void *context)
+{
+	int			ret;
+	struct mausb_pkt	*pkt;
+	struct mausb_udc	*udc  = platform_get_drvdata(&udc_pdev);
+	struct mausb_mgmt	*mgmt;
+
+	if ((NULL == context) || (NULL == ms_pkt)) {
+		maudc_err(udc, "%s: received NULL %s\n", __func__,
+			context ? "packet" : "context");
+		return -EFAULT;
+	}
+
+	mgmt = (struct mausb_mgmt *) context;
+
+	pkt = mausb_pkt_from_ms_pkt(ms_pkt,
+			udc->ma_dev.ms_driver->ops->pkt_destructor, GFP_ATOMIC);
+
+	maudc_dbg(udc, "%s: received %s packet\n", __func__,
+		mausb_type_to_string(pkt->common->pkt_type));
+
+	ret = mausb_rx_mgmt(pkt, mgmt);
+
+	return ret;
+}
+
+/**
+ * Suspends gadget..Called when a MAUSBDeviceSleepReq management packet is
+ * received.
+ */
+static void mausb_device_suspend(void)
+{
+	struct mausb_udc *udc = platform_get_drvdata(&udc_pdev);
+
+	if (udc->driver)
+		udc->driver->suspend(&udc->gadget);
+}
+
+/**
+ * Resumes gadget. Called by mausb_bus_resume in hcd to resume a connected
+ * device.
+ */
+static void mausb_device_resume(void)
+{
+	struct mausb_udc *udc = platform_get_drvdata(&udc_pdev);
+
+	if (udc->driver)
+		udc->driver->resume(&udc->gadget);
+}
+
+/**
+ * Manages USB device connection to host. Called for connect and disconnect
+ * events.
+ */
+static int mausb_udc_pullup(struct usb_gadget *gadget, int is_on)
+{
+	struct mausb_udc *udc = gadget_to_udc(gadget);
+
+	udc->usb_ep[0].dev_ep.maxpacket = 64;
+	udc->gadget.speed = udc->driver->max_speed;
+	udc->pullup = is_on;
+
+	return 0;
+}
+
+/**
+ * Assigns an MA USB ep handle to the given endpoint.
+ */
+static void maudc_assign_ep_handle(struct mausb_host_ep *ma_ep,
+		struct usb_endpoint_descriptor *ep_des)
+{
+	struct mausb_ep_handle *handle = &ma_ep->ep_handle;
+
+	handle->dir = usb_endpoint_dir_in(ep_des) ? 1 : 0;
+	handle->ep_num = usb_endpoint_num(ep_des);
+	handle->dev_addr = MAUDC_DEV_ADDR;
+	handle->bus_num = MAUSB_VIRTUAL_BUS_NUM;
+
+	ma_ep->ep_handle_state = MAUSB_EP_HANDLE_ACTIVE;
+}
+
+/**
+ * Adds a media-agnostic endpoint datastructure to the UDC for the given
+ * endpoint.
+ */
+static int maudc_add_ma_ep(struct usb_endpoint_descriptor *ep_des,
+		struct mausb_dev *mausb_dev, struct mausb_host_ep **mausb_ep)
+{
+	int			ret = -EINVAL;
+	struct mausb_host_ep	*ma_ep;
+	struct mausb_ms_drv	*drv = mausb_dev->ma_dev->ms_driver;
+	struct mausb_udc	*udc = platform_get_drvdata(&udc_pdev);
+	struct usb_ep		*usb_ep = get_ep(udc, ep_des->bEndpointAddress);
+	unsigned long		irq_flags;
+	int (*transfer_pkt)(struct ms_pkt *pkt, void *context);
+
+	if (USB_ENDPOINT_XFER_CONTROL == usb_endpoint_type(ep_des)) {
+
+		maudc_dbg(udc, "%s: adding control endpoint %i...\n",
+			__func__, usb_endpoint_num(ep_des));
+		transfer_pkt = &receive_ma_packet_control;
+
+	} else if (usb_endpoint_dir_in(ep_des)) {
+		maudc_dbg(udc, "%s: adding IN endpoint %i...\n",
+			__func__, usb_endpoint_num(ep_des));
+		transfer_pkt = &receive_ma_packet_IN;
+
+	} else if (usb_endpoint_dir_out(ep_des)) {
+		maudc_dbg(udc, "%s: adding OUT endpoint %i...\n",
+			__func__, usb_endpoint_num(ep_des));
+		transfer_pkt = &receive_ma_packet_OUT;
+
+	} else {
+		maudc_dbg(udc, "%s: unknown endpoint type\n", __func__);
+		return -EINVAL;
+	}
+
+	mausb_internal_add_ep(mausb_dev, NULL, usb_ep, &ma_ep,
+		&device_transfer_timeout, GFP_ATOMIC);
+
+	if (NULL == ma_ep)
+		return -ENOMEM;
+
+	maudc_dbg(udc, "%s: added endpoint at 0x%p\n", __func__, ma_ep);
+
+	spin_lock_irqsave(&ma_ep->ep_lock, irq_flags);
+
+	maudc_assign_ep_handle(ma_ep, ep_des);
+	ret = mausb_add_data_channel(drv, ma_ep, transfer_pkt);
+
+	ma_ep->gadget = mausb_dev->gadget;
+
+	/*
+	 * Note: The UDC uses a single MA URB to track the transfer
+	 * State variables for the active transfer.
+	 */
+	ma_ep->active_transfer = mausb_alloc_maurb(ma_ep, GFP_ATOMIC);
+
+	if (NULL != mausb_ep)
+		*mausb_ep = ma_ep;
+
+	spin_unlock_irqrestore(&ma_ep->ep_lock, irq_flags);
+
+	return ret;
+}
+
+/**
+ * Registers a media specific driver with the media agnostic driver.
+ */
+struct mausb_ma_drv *maudc_register_ms_driver(struct mausb_ms_drv *drv)
+{
+	struct mausb_udc	*udc = platform_get_drvdata(&udc_pdev);
+	unsigned long		irq_flags;
+
+	spin_lock_irqsave(&udc->udc_lock, irq_flags);
+	udc->ma_dev.ms_driver = drv;
+	spin_unlock_irqrestore(&udc->udc_lock, irq_flags);
+
+	/* open the management channel */
+	maudc_dbg(udc, "%s: adding Managment channel...\n", __func__);
+	mausb_add_mgmt_channel(&udc->ma_dev.mgmt, drv,
+		&maudc_transfer_mgmt_packet, &mausb_mgmt_pkt_sent);
+
+	return &udc->ma_dev.ma_drv;
+}
+EXPORT_SYMBOL(maudc_register_ms_driver);
+
+int check_for_device(int dont_use)
+{
+	struct mausb_udc *udc = platform_get_drvdata(&udc_pdev);
+
+	if (udc->driver != NULL)
+		return 1;
+
+	return 0;
+}
+
+static int mausb_udc_start(struct usb_gadget *gadget,
+		struct usb_gadget_driver *driver)
+{
+	struct mausb_udc	*udc = gadget_to_udc(gadget);
+
+	maudc_dbg(udc, "%s: binding gadget '%s' driver\n",
+		__func__, driver->driver.name);
+
+	udc->driver = driver;
+
+	return 0;
+}
+
+static int mausb_udc_stop(struct usb_gadget *gadget,
+		struct usb_gadget_driver *driver)
+{
+	struct mausb_udc	*udc = gadget_to_udc(gadget);
+
+	maudc_dbg(udc, "%s: stopping udc\n", __func__);
+
+	udc->driver = NULL;
+
+	return 0;
+}
+
+/**
+ * API to UDC operations that do not involve endpoints or i/o.
+ */
+static struct usb_gadget_ops mudc_ops = {
+	.pullup = &mausb_udc_pullup,
+	.udc_start = &mausb_udc_start,
+	.udc_stop = &mausb_udc_stop
+};
+
+/**
+ * Appends a Capabilities Descriptor to the end of a CapResp packet.
+ *
+ * @resp:	     CapResp to that will carry descriptor.
+ * @type:	     Descriptor type to add.
+ *		     Note: make sure to use values from MA USB Spec, Table 14.
+ * @offset:          Total length of other Device Capability Descriptors
+ *		     in resp.
+ *
+ * Returns length of added descriptor.
+ */
+static int add_cap_desc(struct mausb_mgmt_pkt *resp, int type, int offset)
+{
+	int			ret = 0;
+	int			ttl_offset;
+	struct			mausb_dev_cap_desc *desc;
+	struct mausb_udc	*udc = platform_get_drvdata(&udc_pdev);
+
+	ttl_offset = MAUSB_PKT_HEADER_SIZE +
+			sizeof(struct mausb_CapResp_flds) + offset;
+	desc = cap_desc_ptr_increment(resp, ttl_offset);
+
+	switch (type) {
+	case MAUSB_DEV_CAP_SPEED:
+		desc->length = MAUSB_DEV_CAP_SPEED_LENGTH;
+		desc->cap_type = MAUSB_DEV_CAP_SPEED;
+		desc->speed.speed = MAUSB_DEV_CAP_SPEED_SUPER;
+		/* TODO: assign speed fields meaningful values */
+		desc->speed.lse = 1;
+		desc->speed.st = 2;
+		desc->speed.lane_count = 3;
+		desc->speed.link_protocol = 3;
+		desc->speed.lsm = 234;
+		ret = desc->length;
+		break;
+	case MAUSB_DEV_CAP_POUT:
+		break;
+	case MAUSB_DEV_CAP_ISO:
+		break;
+	case MAUSB_DEV_CAP_SYNC:
+		break;
+	case MAUSB_DEV_CAP_CONT_ID:
+		break;
+	case MAUSB_DEV_CAP_LINK_SLEEP:
+		desc->length = MAUSB_DEV_CAP_LINK_SLEEP_LENGTH;
+		desc->cap_type = MAUSB_DEV_CAP_LINK_SLEEP;
+		desc->link_sleep.link_sleep_cap = 0;
+		ret = desc->length;
+		break;
+	default:
+		maudc_err(udc, "%s: invalid Device Capability Type %i\n",
+			__func__, type);
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * Finds an MA USB endpoint descriptor inside of an endpoint handle response.
+ */
+static void maudc_fill_ma_ep_desc(struct mausb_ep_des *ma_ep_des,
+		struct usb_endpoint_descriptor *ep_des,
+		struct mausb_host_ep *ma_ep)
+{
+	ma_ep_des->ep_handle.handle = ma_ep->ep_handle.handle;
+	ma_ep_des->dir = usb_endpoint_dir_in(ep_des) ? 1 : 0;
+	ma_ep_des->iso = usb_endpoint_xfer_isoc(ep_des) ? 1 : 0;
+	ma_ep_des->l_man = 0;
+	ma_ep_des->valid = 0;
+	ma_ep_des->rsvd_0 = 0;
+
+	if ((usb_endpoint_dir_out(ep_des) && !usb_endpoint_xfer_isoc(ep_des))
+			|| usb_endpoint_xfer_control(ep_des)) {
+		ma_ep_des->ccu = 1;
+	} else
+		ma_ep_des->ccu = 0;
+
+	ma_ep_des->rsvd_1 = 0;
+
+	if (usb_endpoint_dir_out(ep_des) || usb_endpoint_xfer_control(ep_des))
+		ma_ep_des->buffer_size = ma_ep->state.rx_buf_size;
+	else
+		ma_ep_des->buffer_size = 0;
+
+	if (usb_endpoint_xfer_isoc(ep_des)) {
+		/* TODO: iso transfers */
+		/* ma_ep_des->iso_prog_dly = 0; */
+		/* ma_ep_des->iso_resp_dly = 0; */
+	} else {
+		ma_ep_des->iso_prog_dly = 0;
+		ma_ep_des->iso_resp_dly = 0;
+	}
+}
+
+/**
+ * Handles incoming EPHandleReq packets and fills EPHandleResp fields.
+ */
+static enum mausb_pkt_status maudc_handle_ep_req(struct mausb_dev *mausb_dev,
+		struct mausb_EPHandleReq_flds *req,
+		struct mausb_EPHandleResp_flds *resp)
+{
+	int				i;
+	enum mausb_pkt_status		status = UNSUCCESSFUL;
+	struct mausb_udc		*udc = platform_get_drvdata(&udc_pdev);
+	struct usb_endpoint_descriptor	*ep_des;
+	struct usb_ep			*usb_ep;
+	struct mausb_host_ep		*ma_ep;
+
+	resp->num_ep_des = req->num_ep_des;
+
+	/* TODO: Sanity check; make sure we dont look past end of packet */
+	for (i = 0; i < req->num_ep_des; ++i) {
+
+		ep_des = mausb_ep_handle_req_get_ep_des(req, i);
+
+		if (NULL != ep_des) {
+
+			ma_ep = mausb_find_ep_by_address(
+				ep_des->bEndpointAddress, mausb_dev);
+
+			if (NULL != ma_ep) {
+				maudc_warn(udc, "%s: endpoint already exists"
+					"  resetting . . .\n", __func__);
+				mausb_internal_drop_ep(ma_ep);
+			}
+
+			maudc_add_ma_ep(ep_des, mausb_dev, &ma_ep);
+
+			if (NULL == ma_ep) {
+				maudc_err(udc, "%s: failed to add endpoint"
+					" for entry %i\n", __func__, i);
+			}
+
+			maudc_fill_ma_ep_desc(&resp->ep_des[i], ep_des, ma_ep);
+
+			usb_ep = get_ep(udc, ep_des->bEndpointAddress);
+
+			if (NULL != usb_ep)
+				mausb_link_ma_ep_to_usb_ep(ma_ep, usb_ep);
+
+			/* Per spec, if at least 1 endpoint assignment
+			 * is sucessful, the packet returns success.
+			 */
+			status = SUCCESS;
+		}
+	}
+
+	return status;
+}
+
+/**
+ * Handles incoming EPHandleDeleteReq packets and fills EPHandleDeleteResp
+ * fields.
+ */
+static enum mausb_pkt_status maudc_handle_ep_del_req(
+		struct mausb_dev *mausb_dev,
+		struct mausb_EPHandleDelete_flds *req,
+		struct mausb_EPHandleDelete_flds *resp)
+{
+	int				i;
+	int				ret = 0;
+	enum mausb_pkt_status		status = UNSUCCESSFUL;
+	struct mausb_udc		*udc = platform_get_drvdata(&udc_pdev);
+	struct mausb_host_ep		*ma_ep = NULL;
+	struct mausb_ep_handle		*req_handle;
+
+	resp->num_ep = 0;
+
+	/* TODO: Sanity check; make sure we dont look past end of packet */
+	for (i = 0; i < req->num_ep; ++i) {
+		req_handle = &req->ep_handle[i];
+
+		ma_ep = mausb_find_ep_by_handle(req_handle, mausb_dev);
+
+		ret = mausb_internal_drop_ep(ma_ep);
+
+		if (0 <= ret) {
+			/*
+			 * per spec, the packet returns sucess if it can
+			 * delete at least 1 endpoint
+			 */
+			status = SUCCESS;
+
+		} else {
+			resp->ep_handle[resp->num_ep].handle
+						= req_handle->handle;
+			resp->num_ep++;
+
+			maudc_err(udc, "%s: could not delete endpoint with"
+				" handle %x\n", __func__, req_handle->handle);
+		}
+	}
+
+	return status;
+}
+
+/**
+ * Inactivate endpoints in EPInactivateReq packet and fill
+ * EPInactivateResp fields.
+ */
+static enum mausb_pkt_status maudc_handle_ep_inactivate(
+		struct mausb_EPInactivateReq_flds *req,
+		struct mausb_EPInactivateResp_flds *resp,
+		struct mausb_dev *dev)
+{
+	int			i = 0;
+	int			failures = 0;
+	enum			mausb_pkt_status status = SUCCESS;
+	struct mausb_host_ep	*ma_ep = NULL;
+	struct mausb_ep_handle	*req_handle;
+
+	for (i = 0; i < req->num_ep_handles; ++i) {
+		req_handle = &req->ep_handle[i];
+		ma_ep = mausb_find_ep_by_handle(req_handle, dev);
+
+		if (!ma_ep) {
+			resp->ep_handle[failures] = *req_handle;
+			status = UNSUCCESSFUL;
+			failures++;
+		} else
+			ma_ep->ep_handle_state = MAUSB_EP_HANDLE_INACTIVE;
+	}
+
+	resp->num_ep_with_error = failures;
+
+	return status;
+}
+
+/**
+ * This function handles management requests to the UDC. It parses the packet
+ * and makes the necessary function calls into the system.
+ *
+ * @req:	The incoming request to handle.
+ * @resp: 	The response packet to send out.
+ * @mgmt:	The MA USB management structure associated with transfer.
+ *
+ * Note: this function only fills the packet type, status and
+ * request-specific data-fields. The remainder of the fields are set by
+ * mausb_rx_mgmt_req.
+ */
+static int udc_mgmt_req_switch(struct mausb_mgmt_pkt *req,
+		struct mausb_mgmt_pkt *resp, struct mausb_mgmt *mgmt)
+{
+	int			ret = -EINVAL;
+	int			desc_count = 0;
+	int			offset = 0;
+	struct ma_dev		*ma_dev = mausb_mgmt_to_ma_dev(mgmt);
+	struct mausb_udc	*udc = mausb_ma_dev_to_udc(ma_dev);
+
+	/* always set the device handle */
+	req->common.dev_handle = udc->mausb_dev->dev_handle;
+
+	switch (req->common.pkt_type) {
+
+	case CapReq:
+		/* non-hub devices require a Speed Capability Descriptor */
+		ret = add_cap_desc(resp, MAUSB_DEV_CAP_SPEED, offset);
+		if (ret <= 0) {
+			maudc_err(udc, "%s: could not add speed capability "
+				"descriptor\n", __func__);
+		} else {
+			desc_count++;
+			offset += ret;
+		}
+
+		ret = add_cap_desc(resp, MAUSB_DEV_CAP_LINK_SLEEP, offset);
+		if (ret <= 0) {
+			maudc_err(udc, "%s; could not add link sleep"
+				 " capability descriptor\n", __func__);
+		} else {
+			desc_count++;
+			offset += ret;
+		}
+
+		/*
+		 * TODO: if want to add more device cap descriptors, this would
+		 * be a good place to do it.
+		 */
+
+		resp->common.pkt_type = CapResp;
+		resp->common.pkt_status = NO_ERROR;
+		resp->cap_resp.num_ep = CAP_MAX_EP_NUM;
+		resp->cap_resp.num_dev = CAP_MAX_DEV_NUM;
+		resp->cap_resp.num_stream = EP_MAX_STREAMS;
+		resp->cap_resp.dev_type = CAP_DEV_TYPE;
+		resp->cap_resp.desc_count = desc_count;
+		resp->cap_resp.desc_length = offset;
+		resp->cap_resp.max_tx_reqs = CAP_MAX_TX_REQS;
+		resp->cap_resp.max_mgmt_reqs = CAP_MAX_MGMT_REQS;
+
+		ret = 0;
+		break;
+	case USBDevHandleReq:
+		udc->mausb_dev->dev_handle = MAUDC_DEV_HANDLE;
+
+		resp->common.pkt_type     = USBDevHandleResp;
+		resp->common.pkt_status   = NO_ERROR;
+		resp->usb_dev_handle_resp = MAUDC_DEV_HANDLE;
+
+		ret = 0;
+		break;
+	case EPHandleReq:
+		resp->common.pkt_type   = EPHandleResp;
+		resp->usb_dev_handle_resp = udc->mausb_dev->dev_handle;
+		resp->common.pkt_status = maudc_handle_ep_req(udc->mausb_dev,
+			&req->ep_handle_req, &resp->ep_handle_resp);
+		ret = 0;
+		break;
+	case EPActivateReq:
+		break;
+	case EPInactivateReq:
+		resp->common.pkt_type   = EPInactivateResp;
+		resp->common.pkt_status = maudc_handle_ep_inactivate(
+						&req->ep_inactivate_req,
+						&resp->ep_inactivate_resp,
+						udc->mausb_dev);
+		ret = 0;
+		break;
+	case EPResetReq:
+		break;
+	case EPClearTransferReq:
+		break;
+	case EPHandleDeleteReq:
+		resp->common.pkt_type   = EPHandleDeleteResp;
+
+		resp->common.pkt_status = maudc_handle_ep_del_req(
+			udc->mausb_dev, &req->ep_handle_delete,
+					&resp->ep_handle_delete);
+		ret = 0;
+		break;
+	case DevResetReq:
+		resp->common.pkt_type   = DevResetResp;
+
+		ma_dev->ma_dev_addr = req->common.ma_dev_addr;
+		ma_dev->mass_id = req->common.mass_id;
+
+		ret = 0;
+
+		if (0 == ret) {
+			resp->common.pkt_status = NO_ERROR;
+		} else {
+			resp->common.pkt_status =
+				mausb_errno_to_ma_status(ret);
+		}
+		break;
+	case ModifyEP0Req:
+		resp->common.pkt_type   = ModifyEP0Resp;
+		resp->common.pkt_status = SUCCESS;
+
+		/*
+		 * TODO: fix so to spec - for now we don't track USB device
+		 * state and can't do proper checks.
+		 */
+		if (req->modify_ep0_req.ep_handle.dev_addr == 0) {
+			/* && USB device is in addressed state) { */
+			resp->modify_ep0_resp.ep_handle.handle =
+				req->modify_ep0_req.ep_handle.handle
+					| (MAUDC_DEV_ADDR << 5);
+		} else {
+			resp->modify_ep0_resp.ep_handle.handle = 0;
+		}
+
+		ret = 0;
+		break;
+	case SetUSBDevAddrReq:
+		resp->common.pkt_type   = SetUSBDevAddrResp;
+		resp->common.pkt_status = NO_ERROR;
+		udc->mausb_dev->dev_address = MAUDC_DEV_ADDR;
+
+		resp->set_dev_addr_resp.dev_addr = udc->mausb_dev->dev_address;
+		ret = 0;
+		break;
+	case UpdateDevReq:
+		break;
+	case USBDevDisconnectReq:
+		resp->common.pkt_type   = USBDevDisconnectResp;
+		resp->common.dev_handle	= req->common.dev_handle;
+		resp->common.pkt_status = NO_ERROR;
+		ret = 0;
+		break;
+	case DevDisconnectReq:
+		resp->common.pkt_type   = DevDisconnectResp;
+		resp->common.dev_handle	= 0;
+		resp->common.pkt_status = NO_ERROR;
+		ret = 0;
+		break;
+	case SleepReq:
+		resp->common.pkt_type   = SleepResp;
+		resp->common.pkt_status = NO_ERROR;
+		mausb_device_suspend();
+		ret = 0;
+		break;
+	case WakeReq:
+		resp->common.pkt_type   = WakeResp;
+		resp->common.pkt_status = NO_ERROR;
+		mausb_device_resume();
+		ret = 0;
+		break;
+	case PingReq:
+		break;
+	case SyncReq:
+		break;
+	case CancelTransferReq:
+		resp->common.pkt_type   = CancelTransferResp;
+		resp->common.pkt_status = NO_ERROR;
+		resp->cancel_transfer_resp.ep_handle =
+				req->cancel_transfer_req.ep_handle;
+		resp->cancel_transfer_resp.stream_id =
+				req->cancel_transfer_req.stream_id;
+		resp->cancel_transfer_resp.req_id =
+				req->cancel_transfer_req.req_id;
+		/* TODO: cancel transfer and set fields below accordingly */
+		resp->cancel_transfer_resp.cancel_status = 1;
+		resp->cancel_transfer_resp.deliv_seq_num = 0;
+		resp->cancel_transfer_resp.deliv_byte_offset = 0;
+		ret = 0;
+		break;
+	case EPOpenStreamReq:
+		break;
+	case EPCloseStreamReq:
+		break;
+	case USBDevResetReq:
+		break;
+	case VendorSpecificReq:
+		break;
+
+	/* Invalid packet type */
+	default:
+		maudc_err(udc, "%s: invalid packet type\n", __func__);
+		ret = -EBADMSG;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * MA USB ep0 endpoint descriptor for a super speed endpoint
+ * per spec section 7.3.2.2.
+ */
+static struct usb_endpoint_descriptor mausb_ep0_desc = {
+
+	.bLength = USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType = USB_DT_ENDPOINT,
+	.bEndpointAddress = 0x00,
+	.bmAttributes = USB_ENDPOINT_XFER_CONTROL,
+	.wMaxPacketSize = 512,
+	.bInterval = 0
+};
+
+/**
+ * UDC probe function
+ */
+int mausb_udc_probe(struct platform_device *pdev)
+{
+	int				ret = 0;
+	int				i;
+	struct mausb_udc		*udc;
+	struct usb_ep			*usb_ep;
+
+	udc = kzalloc(sizeof(*udc), GFP_KERNEL);
+	if (!udc)
+		return -ENOMEM;
+
+	udc->udc_lock = __SPIN_LOCK_UNLOCKED(udc->udc_lock);
+	/* initialize gadget structure */
+	udc->gadget.name = UDC_NAME;
+	udc->gadget.ops = &mudc_ops;
+	udc->gadget.speed = USB_SPEED_UNKNOWN;
+	udc->gadget.max_speed = USB_SPEED_SUPER;
+	udc->gadget.dev.parent = &pdev->dev;
+
+	/* set head for list of gadget endpoints   */
+	INIT_LIST_HEAD(&udc->gadget.ep_list);
+
+	/* initalize the ma_dev structure */
+	mausb_init_ma_device(&udc->ma_dev, 0, 0,
+		NULL, udc, &udc_mgmt_req_switch, &check_for_device);
+
+	udc->mausb_dev = mausb_internal_alloc_dev(&udc->ma_dev, NULL,
+		&udc->gadget);
+
+	for (i = 0; i < MAUDC_MAX_NUM_EP; i++) {
+		usb_ep = &udc->usb_ep[i].dev_ep;
+
+		usb_ep->name = ep_name[i];
+		usb_ep->ops = &mausb_ep_ops;
+		usb_ep->maxpacket = EP_MAX_PACKET;
+		usb_ep->max_streams = EP_MAX_STREAMS;
+
+		list_add_tail(&usb_ep->ep_list, &udc->gadget.ep_list);
+
+		INIT_LIST_HEAD(&udc->usb_ep[i].usb_req_list);
+	}
+
+	/* give gadget driver ep0 then remove from list*/
+	udc->usb_ep[0].dev_ep.desc = &mausb_ep0_desc;
+	udc->gadget.ep0 = &udc->usb_ep[0].dev_ep;
+	list_del_init(&udc->usb_ep[0].dev_ep.ep_list);
+
+	/* add a new gadget to the udc class driver list */
+	ret = usb_add_gadget_udc(&pdev->dev, &udc->gadget);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "%s: could not add gadget UDC, error %d\n",
+			__func__, ret);
+	} else
+		platform_set_drvdata(pdev, udc);
+
+	return ret;
+}
+
+int mausb_udc_remove(struct platform_device *pdev)
+{
+	struct mausb_udc *udc = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s: removing udc\n", __func__);
+
+	usb_del_gadget_udc(&udc->gadget);
+
+	return 0;
+}
+
+int mausb_udc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct mausb_udc *udc = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s: suspending udc\n", __func__);
+
+	udc->suspended = 1;
+
+	return 0;
+}
+
+int mausb_udc_resume(struct platform_device *pdev)
+{
+	struct mausb_udc *udc = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s: resuming udc\n", __func__);
+
+	udc->suspended = 0;
+
+	return 0;
+}
+
+/**
+ * platform structures for USB Device Controller (UDC)
+ */
+static struct platform_device udc_pdev = {
+	.name = UDC_NAME,
+	.id = 0
+};
+
+static struct platform_driver udc_driver = {
+	.probe = mausb_udc_probe,
+	.remove = mausb_udc_remove,
+	.suspend = mausb_udc_suspend,
+	.resume = mausb_udc_resume,
+	.driver = {
+		.name = UDC_NAME,
+		.owner = THIS_MODULE
+	}
+};
+
+/**
+ * initialization function
+ *
+ * TODO: get rid of platform device and replace with "virtual" device
+ */
+static int mausb_udc_init(void)
+{
+	int ret;
+
+	pr_debug("loading MA USB UDC . . .\n");
+
+	/* register UDC driver */
+	ret = platform_driver_register(&udc_driver);
+	if (ret < 0) {
+		pr_err("failed to register UDC driver: err %d\n", ret);
+	} else {
+		/* register UDC device */
+		ret = platform_device_register(&udc_pdev);
+		if (ret < 0) {
+			pr_err("failed to register UDC device: err %d\n", ret);
+			platform_driver_unregister(&udc_driver);
+
+		} else {
+			/* direct the release function (for exiting) */
+			udc_pdev.dev.release = &udc_dev_release;
+		}
+	}
+
+	return ret;
+}
+module_init(mausb_udc_init);
+
+/**
+ * exit function
+ */
+static void mausb_udc_exit(void)
+{
+	/* deregister UDC device */
+	platform_device_unregister(&udc_pdev);
+
+	/* deregister UDC driver */
+	platform_driver_unregister(&udc_driver);
+
+}
+module_exit(mausb_udc_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("mausb_udc");
diff --git a/drivers/staging/mausb/drivers/mausb_udc.h b/drivers/staging/mausb/drivers/mausb_udc.h
new file mode 100644
index 0000000..b900b2d
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_udc.h
@@ -0,0 +1,147 @@
+/* name:	mausb_udc.h
+ * description:	header file for mausb_udc.h
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
+ * Sean Stalley, sean.o.stalley@intel.com
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
+#ifndef __MAUSB_UDC_H
+#define __MAUSB_UDC_H
+
+#include <linux/timer.h>
+#include <linux/usb/gadget.h>
+#include "mausb_state.h"
+#include "mausb_pkt.h"
+#include "mausb_msapi.h"
+#include "mausb_mem.h" /* for mgmt structure */
+#include "mausb_const.h"
+
+#define UDC_NAME "mausb udc"
+#define MAUDC_MAX_NUM_EP 3
+#define EP_MAX_PACKET  64  /* max number of packets ep can handle */
+#define EP_MAX_STREAMS 16 /* max number of streams ep can handle */
+#define REQ_BUF_SIZE   64
+#define CAP_MAX_EP_NUM	3 /* max number of endpoints state can be tracked for */
+#define CAP_MAX_DEV_NUM 1 /* max number of devices that can be managed
+			   * note this is 1 because only hubs can have >1 */
+#define CAP_DEV_TYPE	0 /* device type: 0 = not an MA USB hub
+			   *		  1 = USB 2.0 hub
+			   *		  2 = USB 3.1 hub */
+#define CAP_MAX_TX_REQS 0x01FF /* max number of outstanding transfer requests
+				* device can track - arbitrarily chosen */
+#define CAP_MAX_MGMT_REQS 0x01F /* max number of outstanding management requests
+				 * device can track - arbitrarily chosen */
+
+#define MAUDC_DEV_HANDLE 0x1359 /* MA Device handle for the USB device */
+
+#define MAUDC_DEV_ADDR 0x7D /* USB Device address for the USB device */
+			/* Note: MAUDC_DEV_ADDR is arbitrary */
+
+#define MAUDC_BUS_NUM 0xD /* Bus number to be used in the endpoint handle */
+
+#define MAUSB_GADGET_TIMEOUT 3	/* time out for gadget driver enqueue request */
+
+#define maudc_info(udc, fmt, args...) \
+	dev_info(udc->gadget.dev.parent , fmt , ## args)
+#define maudc_dbg(udc, fmt, args...) \
+	dev_dbg(udc->gadget.dev.parent , fmt , ## args)
+#define maudc_warn(udc, fmt, args...) \
+	dev_warn(udc->gadget.dev.parent , fmt , ## args)
+#define maudc_err(udc, fmt, args...) \
+	dev_err(udc->gadget.dev.parent , fmt , ## args)
+
+/* function declarations */
+void udc_dev_release(struct device *dev);
+int mausb_udc_probe(struct platform_device *pdev);
+int mausb_udc_remove(struct platform_device *pdev);
+int mausb_udc_suspend(struct platform_device *pdev, pm_message_t state);
+int mausb_udc_resume(struct platform_device *pdev);
+int check_for_device(int dont_use);
+
+
+/* function declarations */
+int do_ma_transfer(struct mausb_host_ep *ep, struct mausb_pkt *tx_req,
+		bool dir_in);
+/**
+ * UDC structure
+ *
+ * The UDC structure holds all of the per-device data. This includes both the
+ * media agnostic device data as well as the USB device data. The USB device
+ * connected to the UDC is considered an integrated USB Device.
+ *
+ * @mausb_gadget_ep:	An array of all the endpoints for this device.
+ * @usb_gadget:		The device's gadget structure.
+ * @usb_gadget_driver:	the device's driver.
+ * @ma_dev:		The media agnostic device structure. Holds all the
+ *			data common to all media agnostic devices.
+ * @mausb_dev:		Holds media agnostic data that represents a USB device.
+ * @ms_driver:		The MAUSB driver's interface with the media specific
+ *			driver.
+ * @udc_lock:		The 'big' lock. Used to protect this structure's data
+ *            		from concurrent access.
+ * @dev_status:		Holds USB device status.
+ * @suspended:		1 when UDC is suspended, otherwise 0.
+ * @pullup:		1 when a USB device is connecting to UDC, otherwise 0.
+ */
+struct mausb_udc {
+	struct mausb_gadget_ep		usb_ep[MAUDC_MAX_NUM_EP];
+	struct usb_gadget		gadget;
+	struct usb_gadget_driver	*driver;
+	struct ma_dev			ma_dev;
+	struct mausb_dev		*mausb_dev;
+	spinlock_t			udc_lock;
+	u16				dev_status;
+	unsigned			suspended:1;
+	unsigned			pullup:1;
+};
+
+#endif
-- 
1.9.1

