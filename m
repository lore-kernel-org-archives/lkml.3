Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaKCUvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:51:12 -0500
Received: from mga14.intel.com ([192.55.52.115]:55535 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbaKCUrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:47:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="616331443"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [PATCH 07/10] added media agnostic (MA) USB management packet handling
Date: Mon,  3 Nov 2014 12:42:54 -0800
Message-Id: <1415047377-3139-8-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Media Agnostic USB Specification outlines a number of managment
packet types for management and control functions. Each function is
initiated with a particular type of managment request packet and
completed with the corresponding management response packet. This
is where we fill the fields for outgoing management packets and parse
and handle incoming management packets.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/mausb/drivers/mausb_mgmt.c | 888 +++++++++++++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_mgmt.h |  90 +++
 2 files changed, 978 insertions(+)
 create mode 100755 drivers/staging/mausb/drivers/mausb_mgmt.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_mgmt.h

diff --git a/drivers/staging/mausb/drivers/mausb_mgmt.c b/drivers/staging/mausb/drivers/mausb_mgmt.c
new file mode 100755
index 0000000..7301ae3
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_mgmt.c
@@ -0,0 +1,888 @@
+/* name:	mausb_mgmt.c
+ * description: Handles management packet operations common to both
+ *              hosts and devices. This includes parsing incoming packets,
+ *              as well as creating outgoing packets.
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
+#include <linux/usb.h>
+#include <linux/slab.h>
+
+#include "mausb_pkt.h"
+#include "mausb_mgmt.h"
+#include "mausb_mem.h"
+#include "mausb_msapi.h"
+#include "mausb_const.h"
+
+/**
+ * Returns the ma_dev structure for a given device.
+ */
+struct ma_dev *mausb_mgmt_to_ma_dev(struct mausb_mgmt *mgmt)
+{
+	return container_of(mgmt, struct ma_dev, mgmt);
+}
+EXPORT_SYMBOL(mausb_mgmt_to_ma_dev);
+
+/**
+ * Opens a connection to the Media Specific driver to pass management packets
+ * to a particular MA device.
+ *
+ * The caller should be holding the lock protecting the MA device's data.
+ *
+ * Returns 0 on success, or a negative errno on failure.
+ *
+ * @mgmt:		The struct for the management channel to the MA device.
+ *              	after this function
+ * @drv:		The specific medium we are communicating with
+ * @transfer_pkt:	A pointer to the function that should be called by the
+ *                    	MS driver to pass incoming management packets to the
+ *                    	MA driver.
+ * @pkt_sent:		Completion callback for outgoing management packets.
+ *			This function will be called by the MS driver once a
+ *			packet has been sent to the medium to indicate that
+ *			it is done with the packet. Note: the completion
+ *			callback can be disabled by setting this to NULL.
+ */
+int mausb_add_mgmt_channel(struct mausb_mgmt *mgmt, struct mausb_ms_drv *drv,
+		int  (*transfer_pkt)(struct ms_pkt *pkt, void *context),
+		void (*pkt_sent)(struct ms_pkt *pkt))
+{
+	int				ret = 0;
+	struct mausb_transfer_pair	tx_pair;
+	unsigned long			irq_flags;
+
+	tx_pair.to_ma.transfer_packet = transfer_pkt;
+	tx_pair.pkt_sent = pkt_sent;
+	tx_pair.to_ma.context = mgmt;
+	tx_pair.handle = MAUSB_MGMT_HANDLE;
+
+	ret = drv->ops->add_transfer_pair(&tx_pair);
+
+	if (ret >= 0) {
+		spin_lock_irqsave(mgmt->ma_dev_lock, irq_flags);
+		mgmt->tx_pair = tx_pair;
+		spin_unlock_irqrestore(mgmt->ma_dev_lock, irq_flags);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(mausb_add_mgmt_channel);
+
+/**
+ * Fills the fields in an endpoint handle req.
+ *
+ * @dev:	The device struct that contains the endpoints to open.
+ * @req_flds:	The req_flds to fill.
+ *
+ * Note: this function can only be used on the host side.
+ */
+int mausb_fill_ep_handle_req_flds(struct mausb_dev *mausb_dev,
+		struct mausb_mgmt_pkt *req, bool add)
+{
+	int				   i = 0;
+	struct mausb_host_ep		   *ma_ep;
+	unsigned long			   irq_flags;
+	struct mausb_ss_ep_req		   *ss_ep_des;
+	struct mausb_ep_req		   *ep_des;
+	struct mausb_EPHandleReq_flds	   *req_flds = &req->ep_handle_req;
+	struct mausb_EPHandleDelete_flds   *del_flds = &req->ep_handle_delete;
+
+	req_flds->num_ep_des = 0;
+
+	if (USB_SPEED_SUPER == mausb_dev->dev->speed)
+		req_flds->size_ep_des = cpu_to_le32(MAUSB_SS_EP_REQ_SIZE);
+	else
+		req_flds->size_ep_des = cpu_to_le32(MAUSB_EP_REQ_SIZE);
+
+	/* for every endpoint */
+	spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+	list_for_each_entry(ma_ep, &mausb_dev->ep_list, ep_list) {
+		spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+		spin_lock_irqsave(&ma_ep->ep_lock, irq_flags);
+
+		/* if we need to add this endpoint */
+		if (add && (MAUSB_EP_HANDLE_UNASSIGNED
+					== ma_ep->ep_handle_state)) {
+
+			if (USB_SPEED_SUPER == mausb_dev->dev->speed &&
+				ma_ep->ep->desc.bEndpointAddress != 0x00) {
+				ss_ep_des = &req_flds->ss_ep_des[i];
+
+				memcpy(&ss_ep_des->ep_des,
+					&ma_ep->ep->desc,
+					USB_DT_ENDPOINT_SIZE);
+
+				memcpy(&ss_ep_des->ss_ep_comp_des,
+					&ma_ep->ep->ss_ep_comp,
+					USB_DT_SS_EP_COMP_SIZE);
+			} else {
+				ep_des = &req_flds->ep_des[i];
+
+				memcpy(&ep_des->ep_des,
+					&ma_ep->ep->desc,
+					USB_DT_ENDPOINT_SIZE);
+			}
+
+			if (ma_ep->ep->desc.bEndpointAddress == 0x00)
+				req_flds->size_ep_des = MAUSB_EP_REQ_SIZE;
+
+			i++;
+			req_flds->num_ep_des = i;
+
+		/* if we need to delete this endpoint */
+		} else if (!add &&
+			(MAUSB_EP_HANDLE_DELETED == ma_ep->ep_handle_state)) {
+
+			del_flds->ep_handle[i].handle =
+				cpu_to_le16(ma_ep->ep_handle.handle);
+
+			i++;
+			req_flds->num_ep_des = i;
+		}
+
+		spin_unlock_irqrestore(&ma_ep->ep_lock, irq_flags);
+
+		spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+	}
+
+	spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+
+	if (i <= 0)
+		return -ENODEV;
+
+	return 0;
+}
+
+/**
+ * Looks for inactive endpoints and fills EPInactivateReq packet fields
+ * accordingly.
+ */
+int mausb_fill_ep_inactivate_req_flds(struct mausb_dev *mausb_dev,
+		struct mausb_mgmt_pkt *req)
+{
+	int				    i = 0;
+	struct mausb_host_ep		    *ma_ep;
+	unsigned long			    irq_flags;
+	struct mausb_EPInactivateReq_flds   *req_flds = &req->ep_inactivate_req;
+
+	/*
+	 * Grab any inactive endpoints. After EPInactivateReq is sent, inactive
+	 * endoints will be marked for deletion.
+	 */
+	spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+	list_for_each_entry(ma_ep, &mausb_dev->ep_list, ep_list) {
+		spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+		spin_lock_irqsave(&ma_ep->ep_lock, irq_flags);
+
+		/* If endpoint has been inactivated, include it in packet. */
+		if (ma_ep->ep_handle_state == MAUSB_EP_HANDLE_INACTIVE) {
+			req_flds->ep_handle[i] = ma_ep->ep_handle;
+			i++;
+			req_flds->num_ep_handles = i;
+			ma_ep->ep_handle_state = MAUSB_EP_HANDLE_DELETED;
+		}
+
+		spin_unlock_irqrestore(&ma_ep->ep_lock, irq_flags);
+		spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+	}
+
+	/*TODO: set suspend flag when needed */
+
+	spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+
+	return req_flds->num_ep_handles;
+}
+
+/**
+ * Transmits a mausb management packet req and awaits a resp
+ *
+ * Caller should be holding the lock in the mausb_mgmt structure.
+ *
+ * This function transmits a MA USB management request packet and waits for a
+ * response. If a response packet is received, this function will return
+ * 0 with valid data in the resp. If the request timed out, will return
+ * -ETIMEDOUT.
+ *
+ * Note: since the calling process sleeps, this function CANNOT be called
+ *       from an interrupt context.
+ *
+ * @req:	A pointer to the MA USB transferRequest packet to be sent.
+ * @resp:	A pointer to the MA USB transferResponse packet received.
+ * @ma_mgmt:	The Ma USB device's management structure.
+ */
+static int internal_mausb_tx_mgmt_req(struct mausb_pkt *req,
+		struct mausb_pkt **resp, struct mausb_mgmt *ma_mgmt)
+{
+	int				retries = 0;
+	int				rem_time = 0;
+	struct mausb_mgmt_req_list	*req_entry;
+	struct mausb_pkt_transfer	*transfer;
+	unsigned long			irq_flags = 0;
+
+	if (NULL == ma_mgmt->tx_pair.to_ms.transfer_packet)
+		return -EPIPE;
+	else
+		transfer = &ma_mgmt->tx_pair.to_ms;
+
+	req_entry = kzalloc(sizeof(struct mausb_mgmt_req_list), GFP_ATOMIC);
+	if (!req_entry)
+		return -ENOMEM;
+
+	req_entry->mgmt_req = req;
+	req_entry->mgmt_resp = NULL;
+	init_completion(&req_entry->resp_rcvd);
+	INIT_LIST_HEAD(&req_entry->req_list);
+
+	list_add_tail(&req_entry->req_list, &ma_mgmt->req_list);
+
+	req->common->length = cpu_to_le16(mausb_pkt_length(req));
+
+	ma_mgmt->token = (ma_mgmt->token % MAUSB_MGMT_MAX_TOKEN) + 1;
+	req->mgmt->token = ma_mgmt->token;
+
+	/* until we time out or complete */
+	for (retries = 0; (retries <= MAUSB_MGMT_TRANSFER_RETRIES) &&
+			(NULL == req_entry->mgmt_resp); retries++) {
+
+		/* if this is a retry */
+		if (retries > 0)
+			req->common->ver_flags |= MAUSB_PKT_FLAG_RETRY;
+
+		spin_unlock_irqrestore(ma_mgmt->ma_dev_lock, irq_flags);
+
+		mausb_pkt_fill_ms_pkt(req, GFP_ATOMIC);
+
+		mamgmt_dbg("%s: sending %s packet\n", __func__,
+			mausb_type_to_string(req->common->pkt_type));
+		transfer->transfer_packet(&req->pkt, transfer->context);
+
+		rem_time = wait_for_completion_interruptible_timeout(
+			&req_entry->resp_rcvd, MAUSB_MGMT_RT_DELAY);
+
+		spin_lock_irqsave(ma_mgmt->ma_dev_lock, irq_flags);
+	}
+
+	list_del(&req_entry->req_list);
+	*resp = req_entry->mgmt_resp;
+
+	kfree(req_entry);
+
+	if (rem_time == 0) /* if we timed out */
+		return -ETIMEDOUT;
+	else if (rem_time < 0) /* if an error happened */
+		return rem_time;
+	else /* return based on the status of the response */
+		return 0;
+}
+
+/**
+ * Accepts the EPHandleResp and EPHandleReq Fields and updates
+ * endpoint(s) state based on the Resp Fields.
+ */
+static int mausb_handle_ep_resp(struct mausb_dev *mausb_dev,
+		struct mausb_EPHandleReq_flds *req,
+		struct mausb_EPHandleResp_flds *resp)
+{
+	int				i;
+	int				ret = -EINVAL;
+	struct mausb_host_ep		*ma_ep;
+	struct usb_endpoint_descriptor	*ep_des;
+
+	if (le32_to_cpu(req->num_ep_des) != le32_to_cpu(resp->num_ep_des))
+		return -EINVAL;
+
+	for (i = 0; i < resp->num_ep_des; ++i) {
+
+		ep_des = mausb_ep_handle_req_get_ep_des(req, i);
+		if (NULL != ep_des) {
+
+			ma_ep = mausb_find_ep_by_desc(ep_des, mausb_dev);
+			if (ma_ep != NULL)
+				ret = mausb_update_ep(ma_ep, &resp->ep_des[i]);
+			else {
+				mamgmt_err("%s: could not find endpoint"
+				" for handle #%i (%x)\n", __func__, i,
+				le16_to_cpu(resp->ep_des[i].ep_handle.handle));
+			}
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * Accepts the EPHandleDeleteReq and EPHandleDeleteResp Fields and updates
+ * the endpoint(s) state based on the Resp Fields.
+ */
+static int mausb_handle_ep_del_resp(struct mausb_dev *mausb_dev,
+		struct mausb_EPHandleDelete_flds *req,
+		struct mausb_EPHandleDelete_flds *resp)
+{
+	int ret			      = 0;
+	int			      i, j;
+	bool			      drop_failed;
+	struct mausb_host_ep	      *ma_ep;
+	struct mausb_ep_handle	      *req_handle;
+	struct mausb_ms_drv	      *ms_driver = mausb_dev->ma_dev->ms_driver;
+
+	/* for every endpoint in the req */
+	for (i = 0; i < req->num_ep; ++i) {
+
+		drop_failed = false;
+		req_handle = &req->ep_handle[i];
+
+		for (j = 0; j < le32_to_cpu(resp->num_ep); ++j) {
+			if (req_handle->handle ==
+				le16_to_cpu(resp->ep_handle[j].handle))
+
+				drop_failed = true;
+		}
+
+		if (false == drop_failed) {
+
+			ma_ep = mausb_find_ep_by_handle(req_handle, mausb_dev);
+
+			ret = ms_driver->ops->drop_transfer_pair(
+				ma_ep->ep_handle.handle,
+				ma_ep->tx_pair.to_ms.context);
+
+			if (0 <= ret) {
+				/* drop the endpoint locally */
+				ret = mausb_internal_drop_ep(ma_ep);
+			}
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * Determines the speed to report in the USBDevHandleReq.
+ */
+static __u8 mausb_get_dev_speed(struct mausb_dev *dev)
+{
+	switch (dev->dev->speed) {
+	case USB_SPEED_LOW:
+		return MAUSB_LOW_SPEED;
+	case USB_SPEED_FULL:
+		return MAUSB_FULL_SPEED;
+	case USB_SPEED_HIGH:
+		return MAUSB_HIGH_SPEED;
+	case USB_SPEED_SUPER:
+		return MAUSB_SUPER_SPEED;
+	/* TODO: SUPER_SPEED_PLUS */
+	default:
+		return MAUSB_INVALID_SPEED;
+	}
+}
+
+/**
+ * Parses all descriptors for a given CapResp packet and stores data in
+ * corresponding device data structure.
+ *
+ * Returns number of descriptors read.
+ */
+int parse_cap_desc(struct mausb_pkt *resp, struct ma_dev *ma_dev)
+{
+	int			   ret = 0;
+	int			   offset = 0;
+	int			   desc_count = resp->mgmt->cap_resp.desc_count;
+	struct mausb_dev_cap_desc  *desc;
+
+	offset = MAUSB_PKT_HEADER_SIZE + sizeof(struct mausb_CapResp_flds);
+	desc = cap_desc_ptr_increment(resp->mgmt, offset);
+
+	if (resp->common->pkt_type != CapResp) {
+		mamgmt_err("%s: packet is type %i (not a CapResp)\n", __func__,
+			resp->common->pkt_type);
+		return -EINVAL;
+	}
+
+	while (desc_count) {
+		if (desc == NULL) {
+			mamgmt_err("%s: no descriptor to read\n", __func__);
+			return ret;
+		}
+
+		ret++;
+
+		switch (desc->cap_type) {
+		case MAUSB_DEV_CAP_SPEED:
+			ma_dev->speed = kzalloc(
+				sizeof(struct mausb_dev_cap_speed),
+				GFP_ATOMIC);
+			ma_dev->speed->speed = desc->speed.speed;
+			ma_dev->speed->lse = desc->speed.lse;
+			ma_dev->speed->st = desc->speed.st;
+			ma_dev->speed->lane_count =
+				desc->speed.lane_count;
+			ma_dev->speed->link_protocol =
+				desc->speed.link_protocol;
+			ma_dev->speed->lsm = desc->speed.lsm;
+			break;
+		case MAUSB_DEV_CAP_POUT:
+			ma_dev->pout = kzalloc(
+				sizeof(struct mausb_dev_cap_pout),
+				GFP_ATOMIC);
+			ma_dev->pout->elastic_buf_cap =
+				desc->pout.elastic_buf_cap;
+			ma_dev->pout->drop_notif =
+				desc->pout.drop_notif;
+			break;
+		case MAUSB_DEV_CAP_ISO:
+			ma_dev->pout = kzalloc(
+				sizeof(struct mausb_dev_cap_iso),
+				GFP_ATOMIC);
+			ma_dev->iso->iso_alignment =
+				desc->iso.iso_alignment;
+			break;
+		case MAUSB_DEV_CAP_SYNC:
+			ma_dev->pout = kzalloc(
+				sizeof(struct mausb_dev_cap_sync),
+				GFP_ATOMIC);
+			ma_dev->sync->media_time_avail =
+				desc->sync.media_time_avail;
+			ma_dev->sync->timestamp_req =
+				desc->sync.timestamp_req;
+			break;
+		case MAUSB_DEV_CAP_CONT_ID:
+			ma_dev->pout = kzalloc(
+				sizeof(struct mausb_dev_cap_cont_id),
+				GFP_ATOMIC);
+			ma_dev->cont_id->cont_id_upper =
+				desc->cont_id.cont_id_upper;
+			ma_dev->cont_id->cont_id_lower =
+				desc->cont_id.cont_id_lower;
+			break;
+		case MAUSB_DEV_CAP_LINK_SLEEP:
+			ma_dev->link_sleep = kzalloc(
+				sizeof(struct mausb_dev_cap_link_sleep),
+				GFP_ATOMIC);
+			ma_dev->link_sleep->link_sleep_cap =
+				desc->link_sleep.link_sleep_cap;
+			break;
+		default:
+			mamgmt_err("%s: unknown device capability descriptor"
+				" type %i\n", __func__, desc->cap_type);
+			ret--;
+			break;
+		}
+
+		desc_count--;
+		offset += desc->length;
+		desc = cap_desc_ptr_increment(resp->mgmt, offset);
+	}
+
+	return ret;
+}
+
+/**
+ * Transmits a management packet of the specified type for the given device.
+ *
+ * @type:	The type of MA USB management request packet being sent.
+ * @mgmt:	The management data we need to send the packet.
+ * @dev:	The device this packet is associated with. Set to NULL if
+ *	        there is no associated device (ex: for MAUSBDevReset).
+ * @host:	Set TRUE to indicate we are a host, set to FALSE if we are
+ *              a device.
+ */
+int mausb_tx_dev_mgmt_req(enum mausb_pkt_type type, struct mausb_mgmt *mgmt,
+		struct mausb_dev *dev, bool host)
+{
+	return mausb_tx_dev_mgmt_req_ep(type, mgmt, dev, host, NULL);
+}
+EXPORT_SYMBOL(mausb_tx_dev_mgmt_req);
+
+/**
+ * Only necessary to call directly if you need to specify an EP, otherwise
+ * mausb_tx_dev_mgmt_req will work.
+ */
+int mausb_tx_dev_mgmt_req_ep(enum mausb_pkt_type type, struct mausb_mgmt *mgmt,
+		struct mausb_dev *dev, bool host, struct mausb_host_ep *ma_ep)
+{
+	int			ret = 0;
+	struct mausb_pkt	*req;
+	struct mausb_pkt	*resp = NULL;
+	struct ma_dev		*ma_dev = mausb_mgmt_to_ma_dev(mgmt);
+	struct mausb_dev	*hub;
+	unsigned long		irq_flags;
+
+	req = mausb_alloc_pkt(MAUSB_PKT_TYPE_MGMT, &ret, GFP_ATOMIC);
+	if (!req)
+		return -ENOMEM;
+
+	spin_lock_irqsave(mgmt->ma_dev_lock, irq_flags);
+
+	req->common->ver_flags  |= MAUSB_VERSION_1_0;
+	req->common->pkt_type    = type;
+	if (NULL != dev)
+		req->common->dev_handle  = cpu_to_le16(dev->dev_handle);
+
+	req->common->ma_dev_addr = ma_dev->ma_dev_addr;
+	req->common->mass_id     = ma_dev->mass_id;
+	req->common->pkt_status  = NO_ERROR;
+
+	if (host)
+		req->common->ver_flags  |= MAUSB_PKT_FLAG_HOST;
+
+	switch (type) {
+	case CapReq:
+		req->mgmt->cap_req.max_mgmt_reqs = MAUSB_MGMT_MAX_TOKEN;
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+
+		if (0 <= ret) {
+			ma_dev->ma_cap.num_ep = resp->mgmt->cap_resp.num_ep;
+			ma_dev->ma_cap.num_dev = resp->mgmt->cap_resp.num_dev;
+			ma_dev->ma_cap.num_stream =
+					resp->mgmt->cap_resp.num_stream;
+			ma_dev->ma_cap.dev_type = resp->mgmt->cap_resp.dev_type;
+			ma_dev->ma_cap.max_tx_reqs =
+					resp->mgmt->cap_resp.max_tx_reqs;
+			ma_dev->ma_cap.max_mgmt_reqs =
+					resp->mgmt->cap_resp.max_mgmt_reqs;
+
+			/* look for descriptors */
+			if (resp->mgmt->cap_resp.desc_count > 0) {
+				ret = parse_cap_desc(resp, ma_dev);
+
+				if (ret != resp->mgmt->cap_resp.desc_count) {
+					mamgmt_err("%s: error reading"
+						" capability descriptors\n",
+						__func__);
+				}
+			}
+		}
+		break;
+
+	case EPHandleReq:
+		mausb_fill_ep_handle_req_flds(dev, req->mgmt, MAUSB_ADD);
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+		if (0 <= ret) {
+			ret = mausb_handle_ep_resp(dev,
+				&req->mgmt->ep_handle_req,
+				&resp->mgmt->ep_handle_resp);
+		}
+		break;
+	case EPActivateReq:
+	case EPInactivateReq:
+		ret = mausb_fill_ep_inactivate_req_flds(dev, req->mgmt);
+		if (ret > 0)
+			ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+		break;
+	case EPResetReq:
+	case EPClearTransferReq:
+		break;
+	case EPHandleDeleteReq:
+		mausb_fill_ep_handle_req_flds(dev, req->mgmt, MAUSB_DEL);
+
+		if (0 < le32_to_cpu(req->mgmt->ep_handle_delete.num_ep)) {
+			ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+
+			mausb_handle_ep_del_resp(dev,
+				&req->mgmt->ep_handle_delete,
+				&resp->mgmt->ep_handle_delete);
+		}
+		break;
+	case USBDevHandleReq:
+		req->mgmt->usb_dev_handle_req.dock_hub
+			= cpu_to_le16(mgmt->hub_dev_handle);
+		req->mgmt->usb_dev_handle_req.usb_rt_str
+			= cpu_to_le32(dev->dev->route);
+		req->mgmt->usb_dev_handle_req.speed =
+			cpu_to_le32(mausb_get_dev_speed(dev));
+		req->common->dev_handle = 0;
+
+		spin_unlock_irqrestore(mgmt->ma_dev_lock, irq_flags);
+		hub = mausb_find_dev(ma_dev, dev->dev->parent, NULL, NULL);
+		spin_lock_irqsave(mgmt->ma_dev_lock, irq_flags);
+
+		if (NULL != hub) {
+			/* This will work if the device is connected directly to
+			 * the dock, but not with a hub connected to the dock...
+			 * well... unless the hub in between is slower than high
+			 * speed. */
+			/* TODO: have the parent hub point to the proper hub for
+			 *       all conditions */
+			req->mgmt->usb_dev_handle_req.parent_hub =
+				hub->dev_handle;
+			req->mgmt->usb_dev_handle_req.parent_hub_port =
+				dev->dev->portnum;
+		} else {
+			/* parent_hub_port not set for SS */
+			mamgmt_dbg("%s: could not find parent hub at %p\n",
+				__func__, dev->dev->parent);
+		}
+
+		/* TODO: all the remaining fields */
+		req->mgmt->usb_dev_handle_req.mtt = 0;
+
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+
+		if (resp && (NULL != dev))
+			dev->dev_handle =
+				le16_to_cpu(resp->mgmt->usb_dev_handle_resp);
+		break;
+
+	case DevResetReq:
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+		break;
+	case ModifyEP0Req:
+		if (NULL == ma_ep) {
+			mamgmt_err("%s: no ep0 for USB device at %p\n",
+				__func__, dev);
+		} else {
+			req->mgmt->modify_ep0_req.ep_handle = ma_ep->ep_handle;
+			req->mgmt->modify_ep0_req.max_pkt_size =
+				usb_endpoint_maxp(&ma_ep->ep->desc);
+		}
+
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+		if (0 <= ret) {
+			if (SUCCESS == resp->common->pkt_status) {
+				if (resp->mgmt->modify_ep0_resp.ep_handle.handle) {
+					ma_ep->ep_handle = resp->mgmt->modify_ep0_resp.ep_handle;
+				}
+			} else
+				ret = -EIO;
+		}
+		break;
+	case SetUSBDevAddrReq:
+		/* TODO: verify timer value */
+		req->mgmt->set_dev_addr_req.resp_timeout =
+			cpu_to_le16(MAUSB_MGMT_RT_DELAY * (1000/HZ));
+
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+
+		if (0 <= ret) {
+			if (SUCCESS == resp->common->pkt_status) {
+				dev->dev_address =
+					le32_to_cpu(
+					resp->mgmt->set_dev_addr_resp.dev_addr);
+			} else
+				ret = -EIO;
+		}
+		break;
+	case UpdateDevReq:
+		break;
+	case USBDevDisconnectReq:
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+		break;
+	case DevDisconnectReq:
+		req->common->dev_handle = 0;
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+		break;
+	case SleepReq:         /* fallthrough */
+	case WakeReq:
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+		/* not everyone supports power management yet */
+		/* if (SUCCESS != resp->common->pkt_status)
+			ret = -EBUSY; */
+		break;
+	case RemoteWakeReq:
+	case PingReq:
+	case DevInitDisconnectReq:
+	case SyncReq:
+		break;
+	case CancelTransferReq:
+		req->mgmt->cancel_transfer_req.ep_handle = ma_ep->ep_handle;
+		/* TODO: stream IDs (where applicable) */
+		req->mgmt->cancel_transfer_req.req_id =
+				ma_ep->state.active_request_id;
+		ret = internal_mausb_tx_mgmt_req(req, &resp, mgmt);
+		/* TODO: handle Responses */
+		break;
+	case USBDevResetReq:
+	case VendorSpecificReq:
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (resp != NULL)
+		mausb_free_pkt(resp);
+
+	spin_unlock_irqrestore(mgmt->ma_dev_lock, irq_flags);
+	mausb_free_pkt(req);
+
+	return ret;
+}
+EXPORT_SYMBOL(mausb_tx_dev_mgmt_req_ep);
+
+/**
+ * Parses an incoming management packet resp.
+ *
+ * This function parses an incoming response packet and connects it to
+ * its associated request.
+ *
+ * @resp:	A pointer to the MA USB management response packet received.
+ * @ma_mgmt:	The MA USB device's management structure.
+ */
+int mausb_rx_mgmt_resp(struct mausb_pkt *resp, struct mausb_mgmt *ma_mgmt)
+{
+	struct mausb_mgmt_req_list	*ma_mgmt_req;
+	unsigned long			irq_flags;
+
+	spin_lock_irqsave(ma_mgmt->ma_dev_lock, irq_flags);
+
+	list_for_each_entry(ma_mgmt_req, &ma_mgmt->req_list, req_list) {
+
+		/* if we found the request that triggered this response */
+		if (ma_mgmt_req->mgmt_req->mgmt->token == resp->mgmt->token) {
+			ma_mgmt_req->mgmt_resp = resp;
+
+			complete_all(&ma_mgmt_req->resp_rcvd);
+			spin_unlock_irqrestore(ma_mgmt->ma_dev_lock, irq_flags);
+			return 0;
+		}
+	}
+
+	/* response given was not requested */
+	spin_unlock_irqrestore(ma_mgmt->ma_dev_lock, irq_flags);
+
+	mausb_free_pkt(resp);
+
+	return -EINVAL;
+}
+
+/**
+ * This function parses an incoming request packet and generates the
+ * appropriate response packet.
+ *
+ * @resp:	A pointer to the MA USB management request packet received.
+ * @ma_mgmt:	The MA USB device's management structure.
+ */
+int mausb_rx_mgmt_req(struct mausb_pkt *req, struct mausb_mgmt *mgmt)
+{
+	int				ret;
+	struct mausb_pkt		*resp;
+	struct ma_dev			*ma_dev = mausb_mgmt_to_ma_dev(mgmt);
+	struct mausb_pkt_transfer	*transfer = &mgmt->tx_pair.to_ms;
+	unsigned long			irq_flags;
+
+	resp = mausb_alloc_pkt(MAUSB_PKT_TYPE_MGMT, &ret, GFP_ATOMIC);
+	if (!resp)
+		return -ENOMEM;
+
+	spin_lock_irqsave(mgmt->ma_dev_lock, irq_flags);
+
+	ret = mgmt->req_switch(req->mgmt, resp->mgmt, mgmt);
+
+	if (ret >= 0) {
+		/* set the values common to all response packets */
+		resp->common->ver_flags |= MAUSB_VERSION_1_0;
+		/* type set above */
+		resp->common->length      = cpu_to_le16(mausb_pkt_length(resp));
+		/* device handle set above */
+		resp->common->ma_dev_addr = ma_dev->ma_dev_addr;
+		resp->common->mass_id     = ma_dev->mass_id;
+		/* pkt_status set above */
+		resp->mgmt->token         = req->mgmt->token;
+
+		mausb_pkt_fill_ms_pkt(resp, GFP_ATOMIC);
+		mamgmt_dbg("%s: sending %s packet\n", __func__,
+			mausb_type_to_string(resp->common->pkt_type));
+
+		spin_unlock_irqrestore(mgmt->ma_dev_lock, irq_flags);
+		transfer->transfer_packet(&resp->pkt, transfer->context);
+		spin_lock_irqsave(mgmt->ma_dev_lock, irq_flags);
+
+	} else {
+		/* we don't know how to handle this packet */
+		mamgmt_dbg("%s: packet type %s not supported\n", __func__,
+			mausb_type_to_string(resp->common->pkt_type));
+		mausb_free_pkt(resp);
+	}
+
+	spin_unlock_irqrestore(mgmt->ma_dev_lock, irq_flags);
+	return ret;
+}
+
+/**
+ * This function parses an incoming management packet, determines
+ * if it is a request or response, and passes the packet to the
+ * proper handler.
+ *
+ * @mgmt_pkt:	A pointer to the incoming MA USB management packet.
+ * @ma_mgmt:	The MA USB device's management structure.
+ */
+int mausb_rx_mgmt(struct mausb_pkt *mgmt_pkt, struct mausb_mgmt *mgmt)
+{
+	mamgmt_dbg("%s: %s packet received\n", __func__,
+		mausb_type_to_string(mgmt_pkt->common->pkt_type));
+
+	if (mausb_pkt_resp(mgmt_pkt))
+		return mausb_rx_mgmt_resp(mgmt_pkt, mgmt);
+	else
+		return mausb_rx_mgmt_req(mgmt_pkt, mgmt);
+}
+EXPORT_SYMBOL(mausb_rx_mgmt);
+
+/**
+ * Handles sent callback for management packets.
+ *
+ * Request packets are held until a response is received and should not be
+ * freed until then. Response packets can be freed as soon as they are sent out.
+ */
+void mausb_mgmt_pkt_sent(struct ms_pkt *ms_pkt)
+{
+	struct mausb_pkt *pkt;
+
+	pkt = ms_pkt_to_mausb_pkt(ms_pkt);
+
+	if (mausb_pkt_resp(pkt))
+		mausb_free_pkt(pkt);
+}
+EXPORT_SYMBOL(mausb_mgmt_pkt_sent);
+
diff --git a/drivers/staging/mausb/drivers/mausb_mgmt.h b/drivers/staging/mausb/drivers/mausb_mgmt.h
new file mode 100644
index 0000000..d09b019
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_mgmt.h
@@ -0,0 +1,90 @@
+/* name:	mausb_mgmt.h
+ * description: Handles management packet structures and declarations common
+ *              to both hosts and devices.
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
+#ifndef __MAUSB_MGMT_H
+#define __MAUSB_MGMT_H
+
+#include "mausb_mem.h"
+#include "mausb_msapi.h"
+
+#define DEBUG
+
+#ifdef DEBUG
+#define mamgmt_dbg(format, arg...) \
+	printk(KERN_DEBUG format, ##arg)
+#else
+#define mamgmt_dbg(format, arg...)
+#endif
+
+#define mamgmt_warn(format, arg...) \
+	printk(KERN_WARNING format, ##arg)
+
+#define mamgmt_err(format, arg...) \
+	printk(KERN_ERR format, ##arg)
+
+struct ma_dev *mausb_mgmt_to_ma_dev(struct mausb_mgmt *mgmt);
+int mausb_tx_dev_mgmt_req(enum mausb_pkt_type type, struct mausb_mgmt *mgmt,
+		struct mausb_dev *dev, bool host);
+int mausb_tx_dev_mgmt_req_ep(enum mausb_pkt_type type, struct mausb_mgmt *mgmt,
+		struct mausb_dev *dev, bool host, struct mausb_host_ep *ma_ep);
+int mausb_rx_mgmt(struct mausb_pkt *mgmt_pkt, struct mausb_mgmt *mgmt);
+void mausb_mgmt_pkt_sent(struct ms_pkt *pkt);
+int mausb_add_mgmt_channel(struct mausb_mgmt *mgmt, struct mausb_ms_drv *drv,
+		int (*transfer_pkt)(struct ms_pkt *pkt, void *context),
+		void (*pkt_sent)(struct ms_pkt *pkt));
+
+#endif
-- 
1.9.1

