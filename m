Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaKCUsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:48:00 -0500
Received: from mga14.intel.com ([192.55.52.115]:55527 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbaKCUrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:47:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="616331437"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [PATCH 04/10] added media agnostic (MA) USB packet handling
Date: Mon,  3 Nov 2014 12:42:51 -0800
Message-Id: <1415047377-3139-5-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we handle MA USB packets. The structure and types of MA USB
packets are defined in the MA USB specification. When an MA USB driver
receives a USB packet, it translates it into a MA USB packet (or packets
if urb exceeds maximum USB packet size). When an MA USB packet is received,
the data from that packet is given to the waiting USB packet and the USB
packet is released.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/mausb/drivers/mausb_pkt.c | 1038 +++++++++++++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_pkt.h |  914 +++++++++++++++++++++++++
 2 files changed, 1952 insertions(+)
 create mode 100644 drivers/staging/mausb/drivers/mausb_pkt.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_pkt.h

diff --git a/drivers/staging/mausb/drivers/mausb_pkt.c b/drivers/staging/mausb/drivers/mausb_pkt.c
new file mode 100644
index 0000000..c78cfc2
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_pkt.c
@@ -0,0 +1,1038 @@
+/* name:	mausb_pkt.c
+ * description: MA USB packet helper functions
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
+#include <linux/usb/ch9.h>
+#include <linux/usb.h>
+
+#include "mausb_mem.h"
+#include "mausb_pkt.h"
+#include "mausb_const.h"
+
+/**
+ * Translates numerical packet type into corresponding string (for printing).
+ */
+const char *mausb_type_to_string(enum mausb_pkt_type type)
+{
+	switch (type) {
+	case CapReq:
+		return "CapReq";
+	case CapResp:
+		return "CapResp";
+	case USBDevHandleReq:
+		return "USBDevHandleReq";
+	case USBDevHandleResp:
+		return "USBDevHandleResp";
+	case EPHandleReq:
+		return "EPHandleReq";
+	case EPHandleResp:
+		return "EPHandleResp";
+	case EPActivateReq:
+		return "EPActivateReq";
+	case EPActivateResp:
+		return "EPActivateResp";
+	case EPInactivateReq:
+		return "EPInactivateReq";
+	case EPInactivateResp:
+		return "EPInactivateResp";
+	case EPResetReq:
+		return "EPResetReq";
+	case EPResetResp:
+		return "EPResetResp";
+	case EPClearTransferReq:
+		return "EPClearTransferReq";
+	case EPClearTransferResp:
+		return "EPClearTransferResp";
+	case EPHandleDeleteReq:
+		return "EPHandleDeleteReq";
+	case EPHandleDeleteResp:
+		return "EPHandleDeleteResp";
+	case DevResetReq:
+		return "DevResetReq";
+	case DevResetResp:
+		return "DevResetResp";
+	case ModifyEP0Req:
+		return "ModifyEP0Req";
+	case ModifyEP0Resp:
+		return "ModifyEP0Resp";
+	case SetUSBDevAddrReq:
+		return "SetUSBDevAddrReq";
+	case SetUSBDevAddrResp:
+		return "SetUSBDevAddrResp";
+	case UpdateDevReq:
+		return "UpdateDevReq";
+	case UpdateDevResp:
+		return "UpdateDevResp";
+	case USBDevDisconnectReq:
+		return "USBDevDisconnectReq";
+	case USBDevDisconnectResp:
+		return "USBDevDisconnectResp";
+	case USBSuspendReq:
+		return "USBSuspendReq";
+	case USBSuspendResp:
+		return "USBSuspendResp";
+	case USBResumeReq:
+		return "USBResumeReq";
+	case USBResumeResp:
+		return "USBResumeResp";
+	case RemoteWakeReq:
+		return "RemoteWakeReq";
+	case RemoteWakeResp:
+		return "RemoteWakeResp";
+	case PingReq:
+		return "PingReq";
+	case PingResp:
+		return "PingResp";
+	case DevDisconnectReq:
+		return "DevDisconnectReq";
+	case DevDisconnectResp:
+		return "DevDisconnectResp";
+	case DevInitDisconnectReq:
+		return "DevInitDisconnectReq";
+	case DevInitDisconnectResp:
+		return "DevInitDisconnectResp";
+	case SyncReq:
+		return "SyncReq";
+	case SyncResp:
+		return "SyncResp";
+	case CancelTransferReq:
+		return "CancelTransferReq";
+	case CancelTransferResp:
+		return "CancelTransferResp";
+	case EPOpenStreamReq:
+		return "EPOpenStreamReq";
+	case EPOpenStreamResp:
+		return "EPOpenStreamResp";
+	case EPCloseStreamReq:
+		return "EPCloseStreamReq";
+	case EPCloseStreamResp:
+		return "EPCloseStreamResp";
+	case USBDevResetReq:
+		return "USBDevResetReq";
+	case USBDevResetResp:
+		return "USBDevResetResp";
+	case DevNotificationReq:
+		return "DevNotificationReq";
+	case DevNotificationResp:
+		return "DevNotificationResp";
+	case EPSetKeepAliveReq:
+		return "EPSetKeepAliveReq";
+	case EPSetKeepAliveResp:
+		return "EPSetKeepAliveResp";
+	case GetPortBWReq:
+		return "GetPortBWReq";
+	case GetPortBWResp:
+		return "GetPortBWResp";
+	case SleepReq:
+		return "SleepReq";
+	case SleepResp:
+		return "SleepResp";
+	case WakeReq:
+		return "WakeReq";
+	case WakeResp:
+		return "WakeResp";
+	case VendorSpecificReq:
+		return "VendorSpecificReq";
+	case VendorSpecificResp:
+		return "VendorSpecificResp";
+	case TransferSetupReq:
+		return "TransferSetupReq";
+	case TransferSetupResp:
+		return "TransferSetupResp";
+	case TransferTearDownConf:
+		return "TransferTearDownConf";
+	case TransferReq:
+		return "TransferReq";
+	case TransferResp:
+		return "TransferResp";
+	case TransferAck:
+		return "TransferAck";
+	case IsochTransferReq:
+		return "IsochTransferReq";
+	case IsochTransferResp:
+		return "IsochTransferResp";
+	}
+
+	return "unknown";
+}
+EXPORT_SYMBOL(mausb_type_to_string);
+
+/**
+ * Translates a negative errno to a MAUSB status. Returns a packet status value.
+ */
+enum mausb_pkt_status mausb_errno_to_ma_status(int errno)
+{
+	switch (errno) {
+	case 0: /* no error */
+		return SUCCESS;
+	case -EINPROGRESS:
+		return TRANSFER_PENDING;
+	case -ESTRPIPE:
+		return TRANSFER_EP_STALL;
+	/* TODO: map all relevant ma status' */
+	default:
+		return UNSUCCESSFUL;
+	} /* end switch */
+
+}
+EXPORT_SYMBOL(mausb_errno_to_ma_status);
+
+/**
+ * Translates an URB status to a MAUSB status
+ */
+int mausb_to_urb_status(enum mausb_pkt_status pkt_status)
+{
+	switch (pkt_status) {
+	case SUCCESS: /* no error */
+		return 0;
+	case TRANSFER_PENDING:
+		return -EINPROGRESS;
+	case TRANSFER_EP_STALL:
+		return -ESTRPIPE;
+	/* TODO: map all relevant urb statuses */
+	default:
+		return -EIO; /* generic I/O error */
+	} /* end switch */
+
+}
+EXPORT_SYMBOL(mausb_to_urb_status);
+
+/**
+ * Determines if the packet is a response packet. Returns true if the packet is
+ * a response packet. Returns false otherwise.
+ */
+bool mausb_pkt_resp(struct mausb_pkt *pkt)
+{
+	return pkt->common->pkt_type & MAUSB_PKT_RESP_FLAG;
+}
+
+/**
+ * Determines if a given packet is a management packet.
+ */
+static bool mausb_pkt_is_mgmt(struct mausb_pkt_common *common)
+{
+	if ((common->pkt_type & MAUSB_PKT_TYPE_MASK) == MAUSB_PKT_TYPE_MGMT)
+		return true;
+	else
+		return false;
+}
+
+
+/**
+ * Returns the sum of the sequnce number & the value added. Handles sequence
+ * number wraparound.
+ */
+u32 mausb_seq_num_add(u32 seq_num, int val)
+{
+	return (seq_num + val) % (MAUSB_MAX_SEQ_NUM + 1);
+}
+EXPORT_SYMBOL(mausb_seq_num_add);
+
+/**
+ * Increments a sequence number value by one.
+ */
+void mausb_increment_seq_num(u32 *seq_num)
+{
+	*seq_num = mausb_seq_num_add(*seq_num, 1);
+}
+
+/**
+ * Compares two sequence numbers. Returns true if a is less than b.
+ * Handles sequence number wraparound.
+ */
+bool mausb_seq_num_lt(u32 a, u32 b)
+{
+
+	if (a > MAUSB_MAX_SEQ_NUM || b > MAUSB_MAX_SEQ_NUM) {
+		mapkt_warn("%s: input out of range\n", __func__);
+		return false;
+	}
+
+	if (b < MAUSB_HALF_SEQ_NUM) { /* b is in the lower half */
+
+		if ((b > a) || ((b + MAUSB_HALF_SEQ_NUM) < a))
+			return true;
+		else
+			return false;
+
+	} else { /* b is in the upper half */
+
+		if ((b > a) && (b - MAUSB_HALF_SEQ_NUM) < a)
+			return true;
+		else
+			return false;
+	}
+
+	/* we should never get here */
+	BUG();
+	return false;
+}
+EXPORT_SYMBOL(mausb_seq_num_lt);
+
+/**
+ * Sequence number less than or equal to.
+ */
+bool mausb_seq_num_lt_eq(u32 a, u32 b)
+{
+	return mausb_seq_num_lt(b, a) ? false : true;
+}
+
+/**
+ * Sequence number greater than or equal to.
+ */
+bool mausb_seq_num_gt_eq(u32 a, u32 b)
+{
+	return mausb_seq_num_lt(a, b) ? false : true;
+}
+
+/**
+ * Sequence number greater than.
+ */
+bool mausb_seq_num_gt(u32 a, u32 b)
+{
+	return mausb_seq_num_lt(b, a);
+}
+EXPORT_SYMBOL(mausb_seq_num_gt);
+
+/**
+ * Returns the sum of the request id and the value added. Handles request id
+ * wraparound.
+ */
+u8 mausb_req_id_add(u8 req_id, int val)
+{
+	return (req_id + val) % (MAUSB_MAX_REQ_ID + 1);
+}
+EXPORT_SYMBOL(mausb_req_id_add);
+
+/**
+ * Compares 2 request IDs. Returns true if a is less than b. Handles request id
+ * wraparound.
+ */
+bool mausb_req_id_lt(u8 a, u8 b)
+{
+
+	if (a > MAUSB_MAX_REQ_ID || b > MAUSB_MAX_REQ_ID) {
+		mapkt_warn("%s: input out of range\n", __func__);
+		return false;
+	}
+
+	if (b < MAUSB_HALF_REQ_ID) { /* b is in the lower half */
+
+		if ((b > a) || ((b + MAUSB_HALF_REQ_ID) < a))
+			return true;
+		else
+			return false;
+
+	} else { /* b is in the upper half */
+
+		if ((b > a) && (b - MAUSB_HALF_REQ_ID) < a)
+			return true;
+		else
+			return false;
+	}
+
+	/* we should never get here */
+	BUG();
+	return false;
+}
+EXPORT_SYMBOL(mausb_req_id_lt);
+
+bool mausb_req_id_gt(u8 a, u8 b)
+{
+	return mausb_req_id_lt(b, a);
+}
+
+bool mausb_req_id_gt_eq(u8 a, u8 b)
+{
+	return mausb_req_id_lt(a, b) ? false : true;
+}
+EXPORT_SYMBOL(mausb_req_id_gt_eq);
+
+/**
+ * Finds an endpoint descriptor inside of an endpoint handle request
+ */
+struct usb_endpoint_descriptor *mausb_ep_handle_req_get_ep_des(
+	struct mausb_EPHandleReq_flds *req, int i)
+{
+
+	if (i >= le32_to_cpu(req->num_ep_des)) {
+		mapkt_warn("%s: endpoint descriptor not in packet\n", __func__);
+		return NULL;
+	}
+
+	if (MAUSB_EP_REQ_SIZE == le32_to_cpu(req->size_ep_des)) {
+		return (struct usb_endpoint_descriptor *)
+					&req->ep_des[i].ep_des;
+
+	} else if (MAUSB_SS_EP_REQ_SIZE == le32_to_cpu(req->size_ep_des)) {
+		return (struct usb_endpoint_descriptor *)
+					 &req->ss_ep_des[i].ep_des;
+
+	} else {
+		mapkt_err("%s: unsupported size_ep_des value (%u)\n",
+			  __func__, le32_to_cpu(req->size_ep_des));
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(mausb_ep_handle_req_get_ep_des);
+
+static struct mausb_pkt_common *mausb_header_from_ms_pkt(struct ms_pkt *pkt)
+{
+	struct mausb_pkt_common *header;
+
+	if (pkt->kvec[0].iov_len < sizeof(*header)) {
+		mapkt_err("%s: first entry too small for header\n", __func__);
+		header = NULL;
+	} else
+		header = pkt->kvec[0].iov_base;
+
+	return header;
+}
+
+/**
+ * Accepts an MA USB packet for the MA device and forwards it to the correct
+ * handler based on packet type and endpoint/device handle.
+ */
+int mausb_pkt_dmux(struct ms_pkt *pkt, void *context)
+{
+	int				ret = -EINVAL;
+	struct mausb_pkt_common		*header = mausb_header_from_ms_pkt(pkt);
+	struct ma_dev			*ma_dev = context_to_ma_dev(context);
+	struct mausb_host_ep		*ma_ep = NULL;
+	struct mausb_pkt_transfer	*transfer = NULL;
+
+	if (mausb_pkt_is_mgmt(header)) {
+		transfer = &ma_dev->mgmt.tx_pair.to_ma;
+
+	} else {
+		/* otherwise, find the endpoint it belongs to */
+		ma_ep = mausb_find_ep_from_handle(header->ep_handle,
+			ma_dev);
+
+		if (NULL != ma_ep)
+			transfer = &ma_ep->tx_pair.to_ma;
+	}
+
+	if (NULL != transfer)
+		ret = transfer->transfer_packet(pkt, transfer->context);
+
+	return ret;
+}
+
+/**
+ * Packet destructor for packets generated by the MA driver. For packets that we
+ * have created, we want to free the header but not the data buffers (since the
+ * buffers belong to the URB).
+ */
+static void mausb_pkt_destructor(struct ms_pkt *ms_pkt)
+{
+	struct mausb_pkt *ma_pkt = ms_pkt_to_mausb_pkt(ms_pkt);
+
+	kfree(ma_pkt->common);
+
+	return;
+}
+
+/**
+ * Allocates space for given packet type.
+ */
+struct mausb_pkt *mausb_alloc_pkt(enum mausb_pkt_type pkt_type, int *status,
+		gfp_t memflags)
+{
+	int			size;
+	int			ret = 0;
+	struct mausb_pkt	*pkt;
+
+	/* determine header length */
+	switch (pkt_type & MAUSB_PKT_TYPE_MASK) {
+
+	case MAUSB_PKT_TYPE_MGMT:
+		size = sizeof(struct mausb_mgmt_pkt);
+		break;
+	case MAUSB_PKT_TYPE_CTRL:
+		size = sizeof(struct mausb_ctrl_pkt);
+		break;
+	case MAUSB_PKT_TYPE_DATA:
+		size = sizeof(struct mausb_iso_dph);
+		break;
+	default:
+		mapkt_err("%s: could not determine packet type\n", __func__);
+		if (NULL != status)
+			*status = -EINVAL;
+		return NULL;
+	}
+
+	pkt = kzalloc(sizeof(struct mausb_pkt), memflags);
+	if (NULL == pkt) {
+		ret = -ENOMEM;
+		pkt = NULL;
+	} else {
+		pkt->common = kzalloc(size, memflags);
+		if (NULL == pkt->common) {
+			mapkt_err("could not allocate memory for MA USB"
+				" packet header of length %i\n", size);
+			kfree(pkt);
+			ret = -ENOMEM;
+			pkt = NULL;
+		}
+
+		pkt->ms_pkt_destructor = &mausb_pkt_destructor;
+		pkt->orig_pkt = &pkt->pkt;
+	}
+
+	if (NULL != status)
+		*status = ret;
+
+	return pkt;
+}
+
+/**
+ * Deletes the given data packet
+ */
+void mausb_free_pkt(struct mausb_pkt *pkt)
+{
+	/* kill the buffers (when necessary) */
+	pkt->ms_pkt_destructor(pkt->orig_pkt);
+	kfree(pkt);
+}
+EXPORT_SYMBOL(mausb_free_pkt);
+
+/**
+ * Returns the length of the header or a negative errno.
+ */
+int mausb_pkt_header_length(struct mausb_pkt_common *header)
+{
+	int length;
+
+	switch (header->pkt_type & MAUSB_PKT_TYPE_MASK) {
+
+	case MAUSB_PKT_TYPE_MGMT:
+	case MAUSB_PKT_TYPE_CTRL:
+		length = le16_to_cpu(header->length);
+		break;
+	case MAUSB_PKT_TYPE_DATA:
+		length = sizeof(struct mausb_dph);
+		break;
+	default:
+		mapkt_err("%s:invalid packet type\n", __func__);
+		length = -EINVAL;
+		break;
+	}
+
+	return length;
+}
+EXPORT_SYMBOL(mausb_pkt_header_length);
+
+/**
+ * Returns a pointer to a buffer of specified length that is
+ * found offset a given number of bytes into the ms_pkt.
+ *
+ * If a contigious buffer can be found, this function returns
+ * the virtual address of this buffer. otherwise, it returns null
+ */
+static void *mausb_get_buf_from_ms_pkt(struct ms_pkt *pkt,
+		int offset, int buf_length)
+{
+	int		i;
+	int		page_offset = offset;
+	char		*ret = NULL;
+	struct kvec	*current_kvec;
+
+	for (i = 0; i < pkt->nents; ++i) {
+		current_kvec = &pkt->kvec[i];
+
+		/* if the buffer is in this kvec entry */
+		if (page_offset < current_kvec->iov_len) {
+
+			/* and the whole buffer is in current_kvec */
+			if (page_offset + buf_length <= current_kvec->iov_len) {
+				ret = (char *) current_kvec->iov_base;
+				ret += page_offset;
+			}
+
+			return ret;
+		}
+
+		page_offset -= current_kvec->iov_len;
+	}
+
+	if (0 != page_offset) {
+		mapkt_err("%s: offset of %i Bytes is greater than packet"
+			" length\n", __func__, page_offset);
+	}
+	return NULL;
+}
+
+bool mausb_pkt_has_setup_data(struct mausb_dph *header)
+{
+	/*
+	 * Only control transfer requests with sequence number 0 should have
+	 * setup data - nothing else should ever carry setup data.
+	 */
+	if (header->common.pkt_type == TransferReq) {
+		if ((header->eps_tflags & MAUSB_PKT_TFLAG_TYPE_MASK)
+			== MAUSB_PKT_TFLAG_TYPE_CTRL
+			&& le32_to_cpu(header->seq_num) == 0)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(mausb_pkt_has_setup_data);
+
+/**
+ * Gets an mausb_pkt structure from a given ms_pkt structure.
+ *
+ * can only be used if this driver created the packet i.e. if you just received
+ * an ms_pkt from another machine, it will not be part of a mausb_pkt.
+ */
+struct mausb_pkt *ms_pkt_to_mausb_pkt(struct ms_pkt *ms_pkt)
+{
+	return container_of(ms_pkt, struct mausb_pkt, pkt);
+}
+
+/**
+ * Creates a mausb_pkt structure from a given ms_pkt structure. Used for parsing
+ * incoming packets.
+ */
+struct mausb_pkt *mausb_pkt_from_ms_pkt(struct ms_pkt *ms_pkt,
+	void (*ms_pkt_destructor)(struct ms_pkt *ms_pkt), gfp_t mem_flags)
+{
+	struct mausb_pkt	*pkt;
+	int			current_offset;
+	int			packet_length;
+
+	pkt = kzalloc(sizeof(struct mausb_pkt), mem_flags);
+	if (NULL == pkt)
+		return NULL;
+
+	pkt->pkt = *ms_pkt;
+	pkt->orig_pkt = ms_pkt;
+	pkt->ms_pkt_destructor = ms_pkt_destructor;
+
+	/* the first portion is always the header */
+	pkt->common = mausb_header_from_ms_pkt(ms_pkt);
+	current_offset = mausb_pkt_header_length(pkt->common);
+	packet_length = pkt->common->length;
+
+	/* checks to see if header is contigious */
+	if (NULL == mausb_get_buf_from_ms_pkt(ms_pkt, 0, current_offset)) {
+
+		mapkt_err("%s: packet header bigger than entry (header is %i"
+			" bytes)\n", __func__, current_offset);
+		kfree(pkt);
+		return NULL;
+	}
+
+	/*
+	 * NOTE: Currently control and management packets must be contigious.
+	 *       data packet headers must also be contigious.
+	 *       (ie: the data must all be in 1 ms_pkt entry).
+	 *
+	 * TODO: handle when a control/management is in more than 1
+	 *       kvec entry
+	 */
+
+	if (MAUSB_PKT_TYPE_DATA ==
+		(pkt->common->pkt_type & MAUSB_PKT_TYPE_MASK)) {
+
+		if (mausb_pkt_has_setup_data(pkt->data)) {
+			pkt->setup = mausb_get_buf_from_ms_pkt(ms_pkt,
+				current_offset, sizeof(*pkt->setup));
+
+			if (NULL == pkt->setup) {
+				mapkt_err("%s: could not get setup data\n",
+					__func__);
+			} else {
+				current_offset += sizeof(*pkt->setup);
+			}
+		}
+
+		if (packet_length > current_offset) {
+			pkt->buffer = mausb_get_buf_from_ms_pkt(ms_pkt,
+				current_offset, packet_length - current_offset);
+
+			/*
+			 * if the remaining data was contigious, treat it as a
+			 * buffer
+			 */
+			if (NULL != pkt->buffer) {
+				pkt->buffer_length =
+					packet_length - current_offset;
+				current_offset += pkt->buffer_length;
+			}
+
+		} else if (packet_length < current_offset) {
+			mapkt_dbg("%s: packet_length:%i, current_offset:%i\n",
+				__func__, packet_length, current_offset);
+		}
+	}
+
+	/* checks to see if there is data after packet */
+	if (NULL != mausb_get_buf_from_ms_pkt(ms_pkt, current_offset, 0))
+		mapkt_warn("%s: Warning: data exists after packet\n", __func__);
+
+	return pkt;
+
+}
+EXPORT_SYMBOL(mausb_pkt_from_ms_pkt);
+
+/**
+ * Fills the ms_pkt of a given mausb_pkt based on fields in the mausb_pkt struct.
+ */
+int mausb_pkt_fill_ms_pkt(struct mausb_pkt *pkt, gfp_t mem_flags)
+{
+	struct ms_pkt		*ms_pkt = &pkt->pkt;
+	unsigned int		ent_length;
+
+	ms_pkt->nents = 0;
+
+	if (NULL != pkt->common) {
+		/* add the header */
+		ent_length = mausb_pkt_header_length(pkt->common);
+		if (0 >= ent_length) {
+			return -EINVAL;
+		}
+
+	} else { /* We should ALWAYS have a header, and we dont... */
+		mapkt_err("%s: header not found\n", __func__);
+		return -EINVAL;
+	}
+
+	ms_pkt->kvec[ms_pkt->nents].iov_base = pkt->common;
+	ms_pkt->kvec[ms_pkt->nents].iov_len = ent_length;
+	ms_pkt->nents += 1;
+
+	/* If this packet should have data, send it */
+	if (pkt->common->pkt_type == TransferReq ||
+		pkt->common->pkt_type == TransferResp){
+
+		/* add the setup field */
+		if (mausb_pkt_has_setup_data(pkt->data)) {
+			ms_pkt->kvec[ms_pkt->nents].iov_base = pkt->setup;
+			ms_pkt->kvec[ms_pkt->nents].iov_len =
+						sizeof(*pkt->setup);
+			ms_pkt->nents += 1;
+
+		} else if (NULL != pkt->setup) {
+			mapkt_warn("%s: Warning: packet has Setup field, but "
+				"flags in header are not set\n", __func__);
+		}
+
+		if (NULL != pkt->buffer && pkt->nents > 0) {
+			mapkt_err("%s: packet has scatterlist and databuffer\n"
+				, __func__);
+			return -EINVAL;
+		}
+
+		/* add the data buffer */
+		if (NULL != pkt->buffer) {
+			ms_pkt->kvec[ms_pkt->nents].iov_base = pkt->buffer;
+			ms_pkt->kvec[ms_pkt->nents].iov_len =
+				pkt->buffer_length;
+			ms_pkt->nents += 1;
+		}
+	}
+
+	mapkt_dbg("%s: pkt filled with %i entries\n", __func__, ms_pkt->nents);
+
+	return 0;
+}
+
+/**
+ * Calculates the total length of data contained in an ms_pkt (in bytes).
+ * Returns the length of the kvec, or 0 on an error.
+ */
+static int mausb_ms_data_length(struct ms_pkt *pkt)
+{
+	int		i;
+	int		total_length;
+	struct kvec	*current_kvec;
+
+	for (i = 0; i < pkt->nents; ++i) {
+		current_kvec = &pkt->kvec[i];
+		if (NULL == current_kvec)
+			return -EINVAL;
+		else
+			total_length += current_kvec->iov_len;
+	}
+
+	return total_length;
+}
+
+/**
+ * Calculates the length of the datafield in a given datapacket.
+ */
+static int mausb_pkt_datafield_length(struct mausb_pkt *pkt)
+{
+	int length = 0;
+
+	if (NULL != pkt->buffer)
+		length += pkt->buffer_length;
+	if (0 != pkt->nents)
+		length += mausb_ms_data_length(&pkt->pkt);
+
+	return length;
+}
+
+/**
+ * Parses the packet fields to determine how long the packet is. Returns the
+ * packet length on sucess, or a negative errno on error.
+ */
+int mausb_pkt_length(struct mausb_pkt *pkt)
+{
+	int length;
+
+	/* all packets have this field */
+	switch (pkt->common->pkt_type & MAUSB_PKT_TYPE_MASK) {
+
+	/* Management packets */
+	case MAUSB_PKT_TYPE_MGMT:
+		length = sizeof(*pkt->common);
+		length += MAUSB_MGMT_TOKEN_PAD_LEN;
+
+		/* subtypes without additional data */
+		switch (pkt->common->pkt_type) {
+		case DevResetReq:
+		case DevResetResp:
+		case UpdateDevResp:
+		case DevDisconnectReq:
+		case DevDisconnectResp:
+		case USBDevDisconnectReq:
+		case USBDevDisconnectResp:
+		case SleepReq:
+		case SleepResp:
+		case WakeReq:
+		case WakeResp:
+		case RemoteWakeReq:
+		case RemoteWakeResp:
+		case PingReq:
+		case PingResp:
+		case DevInitDisconnectReq:
+		case DevInitDisconnectResp:
+		case SyncResp:
+			break;
+
+		/* subtypes with constant length additional data */
+		case CapReq:
+			length += sizeof(pkt->mgmt->cap_req);
+			break;
+		case CapResp:
+			length += sizeof(pkt->mgmt->cap_resp);
+			/* also include length of any descriptors */
+			length += pkt->mgmt->cap_resp.desc_length;
+			break;
+		case USBDevHandleReq:
+			length += sizeof(pkt->mgmt->usb_dev_handle_req);
+			break;
+		case USBDevHandleResp:
+			length += sizeof(pkt->mgmt->usb_dev_handle_resp);
+			break;
+		case ModifyEP0Req:
+			length += sizeof(pkt->mgmt->modify_ep0_req);
+			break;
+		case ModifyEP0Resp:
+			length += sizeof(pkt->mgmt->modify_ep0_resp);
+			break;
+		case SetUSBDevAddrReq:
+			length += sizeof(pkt->mgmt->set_dev_addr_req);
+			break;
+		case SetUSBDevAddrResp:
+			length += sizeof(pkt->mgmt->set_dev_addr_resp);
+			break;
+		case UpdateDevReq:
+			length += sizeof(pkt->mgmt->update_dev_req);
+			break;
+		case SyncReq:
+			length += sizeof(pkt->mgmt->synch_req);
+			break;
+		case EPCloseStreamReq:
+			length += sizeof(pkt->mgmt->ep_close_stream_req);
+			break;
+		case CancelTransferReq:
+			length += sizeof(pkt->mgmt->cancel_transfer_req);
+			break;
+		case CancelTransferResp:
+			length += sizeof(pkt->mgmt->cancel_transfer_resp);
+			break;
+		case EPOpenStreamReq:
+			length += sizeof(pkt->mgmt->ep_open_stream_req);
+			break;
+		/* subtypes with variable length additional data */
+		case EPHandleReq:
+			length += sizeof(__u32);
+			length += pkt->mgmt->ep_handle_req.num_ep_des *
+				pkt->mgmt->ep_handle_req.size_ep_des;
+			break;
+		case EPHandleResp:
+			length += sizeof(__u32);
+			length += pkt->mgmt->ep_handle_resp.num_ep_des *
+				sizeof(struct mausb_ep_des);
+			break;
+		case EPActivateReq:
+		case EPActivateResp:
+		case EPInactivateReq:
+		case EPInactivateResp:
+		case EPResetReq:
+		case EPResetResp:
+		case EPClearTransferReq:
+		case EPClearTransferResp:
+		case EPHandleDeleteReq: /* FALLTHROUGH */
+		case EPHandleDeleteResp:
+			length += sizeof(__u32);
+			length += pkt->mgmt->ep_handle_delete.num_ep
+				* sizeof(struct mausb_ep_handle);
+			break;
+		case EPCloseStreamResp:
+		case USBDevResetReq:
+		case USBDevResetResp:
+		case EPOpenStreamResp:
+		case VendorSpecificReq:
+		case VendorSpecificResp:
+			mapkt_err("%s: cannot determine length of %s packet -"
+				" packet type not yet handled\n", __func__,
+				mausb_type_to_string(pkt->common->pkt_type));
+			BUG();
+			break;
+		default:
+			mapkt_err("%s: invalid management packet type %x\n",
+				__func__, pkt->common->pkt_type);
+			BUG();
+			break;
+		}
+
+		break;
+
+	/* Control Packets */
+	case MAUSB_PKT_TYPE_CTRL:
+		length = sizeof(struct mausb_ctrl_pkt);
+		switch (pkt->common->pkt_type) {
+		case TransferSetupReq:
+			length += sizeof(struct mausb_TransferSetupReq_flds);
+			break;
+		case TransferSetupResp:
+			break;
+		case TransferTearDownConf:
+			break;
+		default:
+			mapkt_err("%s: invalid control packet type %x\n",
+				__func__, pkt->common->pkt_type);
+			BUG();
+			break;
+		}
+		break;
+
+	/* Data Packets */
+	case MAUSB_PKT_TYPE_DATA:
+
+		length = sizeof(struct mausb_dph);
+
+		switch (pkt->common->pkt_type) {
+		case TransferReq:
+		case TransferResp: /* FALLTHROUGH */
+			if (mausb_pkt_has_setup_data(pkt->data))
+				length += sizeof(*pkt->setup);
+
+			length += mausb_pkt_datafield_length(pkt);
+			break;
+		case TransferAck:
+			break;
+		case IsochTransferReq:
+		case IsochTransferResp: /* FALLTHROUGH */
+			length = sizeof(struct mausb_iso_dph);
+			length += mausb_pkt_datafield_length(pkt);
+
+			break;
+		default:
+			mapkt_err("%s: invalid data packet type %x\n", __func__,
+				pkt->common->pkt_type);
+			BUG();
+			break;
+		}
+		break;
+
+	default:
+		mapkt_err("%s: invalid packet type %x\n", __func__,
+			pkt->common->pkt_type);
+		BUG();
+		break;
+	}
+
+	return length;
+}
+EXPORT_SYMBOL(mausb_pkt_length);
+
+/**
+ * Finds and returns the memory location offset a number of bytes from a
+ * CapResp packet. Used to find or place device capability descriptors in
+ * a CapResp packet.
+ */
+struct mausb_dev_cap_desc *cap_desc_ptr_increment(struct mausb_mgmt_pkt *resp,
+						  int offset)
+{
+	struct mausb_dev_cap_desc *desc;
+	char  *temp;
+
+	temp = (char *) resp;
+	temp += offset;
+
+	desc  =  (struct mausb_dev_cap_desc *) (temp);
+
+	return desc;
+}
+EXPORT_SYMBOL(cap_desc_ptr_increment);
+
diff --git a/drivers/staging/mausb/drivers/mausb_pkt.h b/drivers/staging/mausb/drivers/mausb_pkt.h
new file mode 100644
index 0000000..fe959c7
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_pkt.h
@@ -0,0 +1,914 @@
+/* name:	mausb_pkt.h
+ * description:	library of MA USB packet structures
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
+#ifndef __MAUSB_PKT_H__
+#define __MAUSB_PKT_H__
+
+#include <linux/usb/ch9.h>
+#include "mausb_msapi.h"
+
+#ifdef DEBUG
+#define mapkt_dbg(format, arg...) \
+	printk(KERN_DEBUG format, ##arg)
+#else
+#define mapkt_dbg(format, arg...)
+#endif
+
+#define mapkt_warn(format, arg...) \
+	printk(KERN_WARNING format, ##arg)
+
+#define mapkt_err(format, arg...) \
+	printk(KERN_ERR format, ##arg)
+
+/* protocol Version, per section 6.2.1.1 */
+#define MAUSB_VERSION_1_0     0x0
+#define MAUSB_VERSION_MASK    0x0F
+
+/* packet Flags, per section 6.2.1.2 */
+#define MAUSB_PKT_FLAG_MASK       0xF0
+#define MAUSB_PKT_FLAG_HOST       (1 << 4)
+#define MAUSB_PKT_FLAG_RETRY      (1 << 5)
+#define MAUSB_PKT_FLAG_TIMESTAMP  (1 << 6)
+
+/* packet Types, per section 6.2.1.3 */
+#define MAUSB_PKT_TYPE_MASK       0xC0
+#define MAUSB_PKT_TYPE_MGMT       (0 << 6)
+#define MAUSB_PKT_TYPE_CTRL       (1 << 6)
+#define MAUSB_PKT_TYPE_DATA       (2 << 6)
+
+/* packet Subtypes, section 6.2.1.3 */
+#define MAUSB_SUBTYPE_MASK        0x3F
+
+enum mausb_pkt_type {
+	/* Management packets */
+	CapReq = 0x00 | MAUSB_PKT_TYPE_MGMT,
+	CapResp               , /* 1 */
+	USBDevHandleReq       , /* 2 */
+	USBDevHandleResp      , /* 3 */
+
+	EPHandleReq           , /* 4 */
+	EPHandleResp          , /* 5 */
+	EPActivateReq         , /* 6 */
+	EPActivateResp        , /* 7 */
+	EPInactivateReq       , /* 8 */
+	EPInactivateResp      , /* 9 */
+	EPResetReq            , /* 10 */
+	EPResetResp           , /* 11 */
+	EPClearTransferReq    , /* 12 */
+	EPClearTransferResp   , /* 13 */
+	EPHandleDeleteReq     , /* 14 */
+	EPHandleDeleteResp    , /* 15 */
+
+	DevResetReq           , /* 16 */
+	DevResetResp          , /* 17 */
+	ModifyEP0Req          , /* 18 */
+	ModifyEP0Resp         , /* 19 */
+	SetUSBDevAddrReq      , /* 20 */
+	SetUSBDevAddrResp     , /* 21 */
+	UpdateDevReq          , /* 22 */
+	UpdateDevResp         , /* 23 */
+	USBDevDisconnectReq   , /* 24 */
+	USBDevDisconnectResp  , /* 25 */
+
+	USBSuspendReq         , /* 26 */
+	USBSuspendResp        , /* 27 */
+	USBResumeReq          , /* 28 */
+	USBResumeResp         , /* 29 */
+	RemoteWakeReq         , /* 30 */
+	RemoteWakeResp        , /* 31 */
+	PingReq               , /* 32 */
+	PingResp              , /* 33 */
+	DevDisconnectReq      , /* 34 */
+	DevDisconnectResp     , /* 35 */
+	DevInitDisconnectReq  , /* 36 */
+	DevInitDisconnectResp , /* 37 */
+	SyncReq               , /* 38 */
+	SyncResp              , /* 39 */
+	CancelTransferReq     , /* 40 */
+	CancelTransferResp    , /* 41 */
+	EPOpenStreamReq       , /* 42 */
+	EPOpenStreamResp      , /* 43 */
+	EPCloseStreamReq      , /* 44 */
+	EPCloseStreamResp     , /* 45 */
+	USBDevResetReq        , /* 46 */
+	USBDevResetResp       , /* 47 */
+
+	DevNotificationReq    , /* 48 */
+	DevNotificationResp   , /* 49 */
+	EPSetKeepAliveReq     , /* 50 */
+	EPSetKeepAliveResp    , /* 51 */
+	GetPortBWReq          , /* 52 */
+	GetPortBWResp         , /* 53 */
+	SleepReq              , /* 54 */
+	SleepResp             , /* 55 */
+	WakeReq               , /* 56 */
+	WakeResp              , /* 57 */
+
+	/* Vendor-Specific Management Packets */
+	VendorSpecificReq = 0x3E | MAUSB_PKT_TYPE_MGMT,
+	VendorSpecificResp    ,
+
+	/* Control Packets */
+	TransferSetupReq = 0x00 | MAUSB_PKT_TYPE_CTRL,
+	TransferSetupResp     ,
+	TransferTearDownConf  ,
+
+	/* Data Packets */
+	TransferReq = 0x00 | MAUSB_PKT_TYPE_DATA,
+	TransferResp = 0x01 | MAUSB_PKT_TYPE_DATA,
+	TransferAck           ,
+	IsochTransferReq      ,
+	IsochTransferResp
+};
+
+/* Endpoint Handle Fields, per section 6.2.1.5 */
+struct __packed mausb_ep_handle {
+	union {
+		struct {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+			__le16 dir:1;      /**< Direction Field    */
+			__le16 ep_num:4;   /**< Endpoint Number    */
+			__le16 dev_addr:7; /**< USB Device Address */
+			__le16 bus_num:4;  /**< Bus Number         */
+#else
+			__le16 bus_num:4;  /**< Bus Number         */
+			__le16 dev_addr:7; /**< USB Device Address */
+			__le16 ep_num:4;   /**< Endpoint Number    */
+			__le16 dir:1;      /**< Direction Field    */
+#endif
+		};
+		__u16 handle;
+	};
+};
+
+#define MAUSB_VIRTUAL_BUS_NUM 15
+
+/* The least significant bit of the packet is only set to 1 in */
+/* response packets. */
+#define MAUSB_PKT_RESP_FLAG       0x01
+
+/** Status Code Values, per section 6.2.1.8, Table 6 */
+enum mausb_pkt_status {
+	SUCCESS = 0,
+	UNSUCCESSFUL = 128,
+	INVALID_MA_USB_SESSION_STATE,
+	INVALID_DEVICE_HANDLE,
+	INVALID_EP_HANDLE,
+	INVALID_EP_HANDLE_STATE,
+	INVALID_REQUEST,
+	MISSING_SEQUENCE_NUMBER,
+	TRANSFER_PENDING,
+	TRANSFER_EP_STALL,
+	TRANSFER_SIZE_ERROR,
+	TRANSFER_DATA_BUFFER_ERROR,
+	TRANSFER_BABBLE_DETECTED,
+	TRANSFER_TRANSACTION_ERROR,
+	TRANSFER_SHORT_TRANSFER,
+	TRANSFER_CANCELLED,
+	INSUFFICENT_RESOURCES,
+	NOT_SUFFICENT_BANDWIDTH,
+	INTERNAL_ERROR,
+	DATA_OVERRUN,
+	DEVICE_NOT_ACCESSED,
+	BUFFER_OVERRUN,
+	BUSY,
+	DROPPED_PACKET,
+	ISOC_TIME_EXPIRED,
+	ISOCH_TIME_INVALID,
+	NO_USB_PING_RESPONSE,
+	NOT_SUPPORTED,
+	REQUEST_DENIED
+};
+
+/* Status codes NO_ERROR and SUCCESS are interchangeable. */
+#define NO_ERROR SUCCESS
+
+/* MA USB packet header size, per 6.2.1 */
+#define MAUSB_PKT_HEADER_SIZE	12
+
+/** common header fields, per section 6.2.1 */
+struct __packed mausb_pkt_common {
+	/* DWORD 0 */
+	__u8                  ver_flags;   /**< MA USB version & Flags */
+	enum mausb_pkt_type   pkt_type:8;  /**< type and subtype */
+	__le16                 length;     /**< length (in bytes) */
+	/* DWORD 1 */
+	union {
+		struct mausb_ep_handle ep_handle; /**< Endpoint Handle */
+		__le16                  dev_handle;/**< Device Handle */
+	};
+	__u8                  ma_dev_addr;/**< MA USB Device Address */
+	__u8                  mass_id;    /**< MA USB Service Set (MSS) id*/
+	/* DWORD 2 */
+	enum mausb_pkt_status pkt_status:8; /**< packet status code */
+};
+
+/** MA USB Global Time, per section 6.6.1 */
+struct __packed mausb_time {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	/** value of delta field in ITP, defined in USB 3.1 spec. */
+	__le32 delta:13;
+	/** nominal bus interval, Indicates USB microframe number */
+	__le32 nom_bus_itvl:19;
+#else
+	__le32 nom_bus_itvl:19;
+	__le32 delta:13;
+#endif
+};
+
+#define MAUSB_PKT_WSE_NO_DOCK  0
+#define MAUSB_PKT_WSE_DOCK_2_0 1
+#define MAUSB_PKT_WSE_DOCK_3_0 2
+
+/**
+ * MAUSB Device Functionality Support Speed
+ *
+ * mausb_dev_bfs_speed are used for the bFunctionalitySupport field.
+ * Note that they are different values than usb_device_speed.
+ */
+enum mausb_dev_bfs_speed {
+	MAUSB_LOW_SPEED = 0,
+	MAUSB_FULL_SPEED,
+	MAUSB_HIGH_SPEED,
+	MAUSB_SUPER_SPEED,
+	MAUSB_SUPER_SPEED_PLUS,
+	MAUSB_INVALID_SPEED
+};
+
+/* MA USB Capability Request fields, per 6.3.2, table 7 */
+struct __packed mausb_CapReq_flds {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32 max_mgmt_reqs:12; /**< max # of outstanding mgmt reqs to host */
+	__le32 rsvd:20; /**< reserved */
+#else
+	__le32 rsvd:20; /**< reserved */
+	__le32 max_mgmt_reqs:12; /**< max # of outstanding mgmt reqs to host */
+#endif
+};
+
+#define MAUSB_DEV_TYPE_INTEGRATED 0
+#define MAUSB_DEV_TYPE_HS_HUB 1
+#define MAUSB_DEV_TYPE_SS_HUB 2
+
+/** MA USB Capability Response fields, per 6.3.3, table 12 */
+struct __packed mausb_CapResp_flds {
+	__le16 num_ep;       	/**< number of endpoints */
+	__u8  num_dev;      	/**< number of devices */
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__u8  num_stream:5; /**< 2^this value = max streams supported */
+	__u8  dev_type:3;   /**< 0 = not a hub, 1 = 2.0 hub, 2 = 3.1 hub */
+#else
+	__u8  dev_type:3;   /**< 0 = not a hub, 1 = 2.0 hub, 2 = 3.1 hub */
+	__u8  num_stream:5; /**< 2^this value = max streams supported */
+#endif
+
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32 desc_count:8;    /**< descriptors count */
+	__le32 desc_length:24;  /**< total length of descriptors */
+#else
+	__le32 desc_length:24;  /**< total length of descriptors */
+	__le32 desc_count:8;    /**< descriptors count */
+#endif
+
+	__le16 max_tx_reqs;     /**< max # of outstanding transfer reqs */
+
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le16 max_mgmt_reqs:12;/**< max # of outstanding management reqs */
+	__le16 rsvd:4;          /**< reserved */
+#else
+	__le16 rsvd:4;          /**< reserved */
+	__le16 max_mgmt_reqs:12;/**< max # of outstanding management reqs */
+#endif
+};
+
+/** MA USB Device Capability Type Values, per 6.3.3, table 14 */
+enum mausb_dev_cap_type {
+	MAUSB_DEV_CAP_SPEED = 0,
+	MAUSB_DEV_CAP_POUT,
+	MAUSB_DEV_CAP_ISO,
+	MAUSB_DEV_CAP_SYNC,
+	MAUSB_DEV_CAP_CONT_ID,
+	MAUSB_DEV_CAP_LINK_SLEEP
+};
+
+/** Speed Capability Speed Enumeration, per 6.3.3.1 */
+enum mausb_dev_cap_speed_speed {
+	MAUSB_DEV_CAP_SPEED_LOW = 0,
+	MAUSB_DEV_CAP_SPEED_FULL,
+	MAUSB_DEV_CAP_SPEED_HIGH,
+	MAUSB_DEV_CAP_SPEED_SUPER,
+	MAUSB_DEV_CAP_SPEED_SS_PLUS
+};
+
+/** Speed Capability Descriptor, per 6.3.3.1 */
+struct __packed mausb_dev_cap_speed {
+	/* DWORD n+0 */
+	__u8 rsvd_0:4;                          /**< Reserved */
+	enum mausb_dev_cap_speed_speed speed:4; /**< USB Device Speed */
+	__u8 rsvd_1:4;                          /**< Reserved */
+	__u8 lse:2;                             /**< Lane Speed Exponent */
+	__u8 st:2;                              /**< Sublink Type */
+
+	/* DWORD n+1 */
+	__u8  rsvd_2:2;			/**< Reserved */
+	__u8  lane_count:4;		/**< Lane Count */
+	__u8  link_protocol:2;		/**< Link Protocol */
+	__le16 lsm;			/**< Lane Speed Mantissa */
+};
+
+#define MAUSB_DEV_CAP_SPEED_LENGTH 7
+
+/** P-Managed OUT Capabilities Descriptor, per 6.3.3.2 */
+struct __packed mausb_dev_cap_pout {
+	__u8 elastic_buf_cap:1;		/**< Elastic Buffer Capability */
+	__u8 drop_notif:1;		/**< Drop Notification */
+	__u8 rsvd:6;			/**< Reserved */
+
+};
+
+#define MAUSB_DEV_CAP_POUT_LENGTH 3
+
+/** Isochronous Capabilities Descriptor, per 6.3.3.3 */
+struct __packed mausb_dev_cap_iso {
+	__u8 iso_alignment:1;	/**< Isochronous Payload Alignment */
+	__u8 rsvd:7;		/**< Reserved */
+};
+
+#define MAUSB_DEV_CAP_ISO_LENGTH 3
+
+/** Synchronization Capabilities Descriptor, per 6.3.3.4 */
+struct __packed mausb_dev_cap_sync {
+	__u8 media_time_avail:1;	/**< Media Time Available */
+	__u8 timestamp_req:1;		/**< Timestamp Request */
+	__u8 rsvd:6;			/**< Reserved */
+};
+
+#define MAUSB_DEV_CAP_SYNCH_LENGTH 3
+
+/** Container ID Capability Descriptor, per 6.3.3.5 */
+struct __packed mausb_dev_cap_cont_id {
+	long long int cont_id_upper;	/**< 64 msb of Container ID */
+	long long int cont_id_lower;	/**< 64 lsb of Container ID */
+};
+
+#define MAUSB_DEV_CAP_CONT_ID_LENGTH 18
+
+/** Link Sleeo Capability Descriptor, per 6.3.3.6 */
+struct __packed mausb_dev_cap_link_sleep {
+	__u8 link_sleep_cap:1;		/**< Link Sleep Capable */
+	__u8 rsvd:7;			/**< Reserved */
+};
+
+#define MAUSB_DEV_CAP_LINK_SLEEP_LENGTH 3
+
+/** MA Device Capability Descriptor  */
+struct __packed mausb_dev_cap_desc {
+	/* common descriptor fields */
+	__u8 length;				/**< Descriptor length */
+	enum mausb_dev_cap_type cap_type:8;     /**< Capability type */
+
+	/* Descriptor-specific format */
+	union {
+		struct mausb_dev_cap_speed      speed;
+		struct mausb_dev_cap_pout       pout;
+		struct mausb_dev_cap_iso        iso;
+		struct mausb_dev_cap_sync       sync;
+		struct mausb_dev_cap_cont_id    cont_id;
+		struct mausb_dev_cap_link_sleep link_sleep;
+	};
+};
+
+/** USB Device Handle Request fields, per 6.3.4, table 8 */
+struct __packed mausb_USBDevHandleReq_flds {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32 usb_rt_str:20;     /**< USB Route String, per USB3.0 Spec */
+	__le32 speed:4;           /**< USB Device Speed */
+	__le32 rsvd_0:8;          /**< reserved */
+	__le16 dock_hub;          /**< dock hub device handle */
+	__le16 rsvd_1;            /**< reserved */
+	__le16 parent_hub;        /**< parent hub handle (if LS or HS) */
+	__u8  parent_hub_port:4;  /**< parent hub port   (if LS or HS) */
+	__u8  mtt:1;              /**< multiple transaction translators */
+	__le16 rsvd_2:15;         /**< reserved */
+	__u8  lse:2;		  /**< lane speed exponent */
+	__u8  st:2;		  /**< sublink type */
+	__u8  rsvd_3:2;		  /**< reserved */
+	__u8  lane_count:2;	  /**< lane count */
+	__u8  link_protocol:2;	  /**< link protocol */
+	__le16 lsm;		  /**< lane speed mantissa */
+
+#else
+	__le16 lsm;		  /**< lane speed mantissa */
+	__u8  link_protocol:2;	  /**< link protocol */
+	__u8  lane_count:2;	  /**< lane count */
+	__u8  rsvd_3:2;		  /**< reserved */
+	__u8  st:2;		  /**< sublink type */
+	__u8  lse:2;		  /**< lane speed exponent */
+	__le16 rsvd_2:15;         /**< reserved */
+	__u8  mtt:1;              /**< multiple transaction translators */
+	__u8  parent_hub_port:4;  /**< parent hub port   (if LS or HS) */
+	__le16 parent_hub;        /**< parent hub handle (if LS or HS) */
+	__le16 rsvd_1;            /**< reserved */
+	__le16 dock_hub;          /**< dock hub device handle */
+	__le32 rsvd_0:8;          /**< reserved */
+	__le32 speed:4;           /**< USB Device Speed */
+	__le32 usb_rt_str:20;     /**< USB Route String, per USB3.0 Spec */
+#endif
+};
+
+/* maximum number of EPs in a packet array */
+#define MAUSB_PKT_MAX_NUM_EP 31
+
+/* EPHandleReq constants, per section 6.3.6 */
+#define MAUSB_EP_REQ_SIZE 8
+#define MAUSB_EP_REQ_PADDING (MAUSB_EP_REQ_SIZE - USB_DT_ENDPOINT_SIZE)
+#define MAUSB_SS_EP_REQ_SIZE 16
+#define MAUSB_SS_EP_REQ_PADDING (MAUSB_SS_EP_REQ_SIZE - \
+		(USB_DT_ENDPOINT_SIZE + USB_DT_SS_EP_COMP_SIZE))
+
+/** packed USB endpoint descriptor */
+struct __packed mausb_ep_req {
+	unsigned char ep_des[USB_DT_ENDPOINT_SIZE];
+	unsigned char padding[MAUSB_EP_REQ_PADDING];
+};
+
+/** packed SuperSpeed USB endpoint descriptor */
+struct __packed mausb_ss_ep_req {
+	unsigned char ep_des[USB_DT_ENDPOINT_SIZE];
+	unsigned char ss_ep_comp_des[USB_DT_SS_EP_COMP_SIZE];
+	unsigned char padding[MAUSB_SS_EP_REQ_PADDING];
+};
+
+/** Endpoint Handle Request fields, per 6.3.6, Tables 10 & 11 */
+struct __packed mausb_EPHandleReq_flds {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32 num_ep_des:5;  /**< number of EP descriptors in the packet */
+	__le32 size_ep_des:6; /**< size of EP descriptors (in bytes) */
+	__le32 rsvd:21;        /**< reserved */
+#else
+	__le32 rsvd:21;
+	__le32 size_ep_des:6;
+	__le32 num_ep_des:5;
+#endif
+	/** array of endpoint descriptors (Standard or SuperSpeed) */
+	union {
+		struct mausb_ep_req ep_des[MAUSB_PKT_MAX_NUM_EP]
+			__aligned(4);
+		struct mausb_ss_ep_req ss_ep_des[MAUSB_PKT_MAX_NUM_EP]
+			__aligned(4);
+		/* TODO: structure for USB 3.1 devices with ISO endpoints */
+	};
+};
+
+
+/** WEP Descriptor format, per 6.3.7, table 13 */
+struct __packed mausb_ep_des {
+	struct mausb_ep_handle ep_handle; /**< requested endpoint handle */
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le16 dir:1;        /**< direction */
+	__le16 iso:1;        /**< isochronous */
+	__le16 l_man:1;      /**< L-managed transfers */
+	__le16 valid:1;      /**< valid handle bit */
+	__le16 rsvd_0:12;    /**< reserved */
+#else
+	__le16 rsvd_0:12;    /**< reserved */
+	__le16 valid:1;      /**< valid handle bit */
+	__le16 l_man:1;      /**< L-managed transfers */
+	__le16 iso:1;        /**< isochronous */
+	__le16 dir:1;        /**< direction */
+#endif
+	__le16 ccu;          /**< credit consumption unit */
+	__le16 rsvd_1;       /**< reserved */
+	__le32 buffer_size;  /**< buffer size (in bytes) */
+	__le16 iso_prog_dly; /**< max iso programming delay (in uSec) */
+	__le16 iso_resp_dly; /**< max iso response delay (in uSec) */
+};
+
+/** Endpoint Handle Response fields, per 6.3.7, Tables 12 & 13 */
+struct __packed mausb_EPHandleResp_flds {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32 num_ep_des:5; /**< number of EP descriptors in this packet */
+	__le32 rsvd:27;      /**< reserved */
+#else
+	__le32 rsvd:27;      /**< reserved */
+	__le32 num_ep_des:5; /**< number of EP descriptors in this packet */
+#endif
+	struct mausb_ep_des ep_des[MAUSB_PKT_MAX_NUM_EP];
+};
+
+/** Endpoint Handle Delete fields, per 6.3.16 & 6.3.17, Tables 37 & 38 */
+/*
+ * Note: both the request and response packets are in the same format.
+ * The the request contains all the handles to delete, and the
+ * response indicates how many were deleted.
+ */
+struct __packed mausb_EPHandleDelete_flds {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32 num_ep:5; /**< number of EP descriptors */
+	__le32 rsvd:27;  /**< reserved */
+#else
+	__le32 rsvd:27;  /**< reserved */
+	__le32 num_ep:5; /**< number of EP descriptors */
+#endif
+	struct mausb_ep_handle ep_handle[MAUSB_PKT_MAX_NUM_EP];
+};
+
+/** Modify EP0 Request and Response fields, per 6.3.20-21, table 39 & 40 */
+struct __packed mausb_ModifyEP0_flds {
+	/** Endpoint 0 handle for the device */
+	struct mausb_ep_handle ep_handle;
+	union {
+		__le16 max_pkt_size; /**< Maximum packet size for EP0 */
+		__le16 rsvd; 	     /**< reserved */
+	};
+};
+
+/** Set USB Device Address Request fields, per 6.3.22, table 41 */
+struct __packed mausb_SetDevAddrReq_flds {
+	__le16  resp_timeout; /**< time the device has to respond (in ms) */
+	__le16  rsvd;
+};
+
+/** Set USB Device Address Response fields, per 6.3.23, table 42 */
+struct __packed mausb_SetDevAddrResp_flds {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32  dev_addr:7; /**< USB Device Address from request */
+	__le32  rsvd:25;
+#else
+	__le32  rsvd:25;
+	__le32  dev_addr:7; /**< USB Device Address from request */
+#endif
+};
+
+/** Update Device Request fields, per 6.3.24, Table 28 */
+struct __packed mausb_UpdateDevReq_flds {
+	__le16 max_exit_lat; /**< Max Exit Latency */
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__u8  hub:1;        /**< Hub flag, set to 1 if hub */
+	__u8  num_ports:4;  /**< hub only, number of downward-facing ports */
+	__u8  mtt:1;        /**< HS hub only, Multiple Transaction Translator */
+	__u8  ttt:2;        /**< HS hub only, Transaction Think Time */
+	/**< 0 = at most 8  FS bit times */
+	/**< 1 = at most 16 FS bit times */
+	/**< 2 = at most 24 FS bit times */
+	/**< 3 = at most 32 FS bit times */
+#else
+	__u8  ttt:2;
+	__u8  mtt:1;
+	__u8  num_ports:4;
+	__u8  hub:1;
+#endif
+};
+
+/** MAUSB Synchronization Request fields, per 6.3.40, Table 30 */
+struct __packed mausb_SynchReq_flds {
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le16             td_valid:1; /**< Transmission Delay field valid */
+	__le16             rsvd:15;    /**< reserved */
+#else
+	__le16             rsvd:15;    /**< reserved */
+	__le16             td_valid:1; /**< Transmission Delay field valid */
+#endif
+	struct mausb_time timestamp;   /**< MA USB Timestamp, per 6.5.1.11 */
+	__le32             tx_dly;     /**< Transmission delay, per 6.5.1.12 */
+};
+
+/** Cancel Transfer Request fields, per 6.3.42, Table 31 */
+struct __packed mausb_CancelTransferReq_flds {
+	struct mausb_ep_handle ep_handle;	/**< Target Endpoint Handle */
+	__le16                  stream_id;	/**< Target stream ID */
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32                  req_id:8;	/**< Target request ID */
+	__le32                  rsvd:24;	/**< reserved */
+#else
+	__u32                  rsvd:24;    /**< reserved */
+	__u32                  req_id:8;    /**< Target request ID */
+#endif
+};
+
+/** Cancel Transfer Response fields, per 6.3.43, Table 32 */
+struct __packed mausb_CancelTransferResp_flds {
+	struct mausb_ep_handle ep_handle;
+	__u16 stream_id;
+	/** Cancellation status                         */
+	/** 0 = Cancel Error                            */
+	/** 1 = Cancel Sucess before any data was moved */
+	/** 2 = Cancel Sucess after some data was moved */
+	/** 3 = Transfer not found                      */
+
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32 req_id:8;
+	__le32 cancel_status:2;
+	__le32 rsvd_0:22;
+#else
+	__le32 rsvd_0:22;
+	__le32 cancel_status:2;
+	__le32 req_id:8;
+#endif
+	/** Delivered Sequence Number */
+	/** For OUT Transfers only. Only valid if cancel_status = 2 */
+	/** Indicates last sequence number delivered to the device. */
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32 deliv_seq_num:24;
+	__le32 rsvd_1:8;
+#else
+	__le32 deliv_seq_num:24;
+	__le32 rsvd_1:8;
+#endif
+	/** Delivered Byte Offset. Only valid if cancel_status = 2 */
+	__le32 deliv_byte_offset;
+};
+
+/** Enpoint Open Stream Request fields, per 6.3.44, Table 33 */
+struct __packed mausb_EPOpenStreamReq_flds {
+	struct mausb_ep_handle ep_handle; /**< Target bulk endpoint */
+	__le32  num_streams:17; /**< number of streams to be opened */
+	__le32  rsvd:7;
+};
+
+/** Enpoint Inactivate Request fields, per 6.3.10, Table 30 */
+struct __packed mausb_EPInactivateReq_flds {
+	__u8  num_ep_handles:5; /** number of ep handles included packet */
+	__u8  suspend_flg:1; /** indicates if issued due to suspension of */
+			     /** included endpoints */
+			     /** 0 = endpoints not suspended */
+			     /** 1 = endpoints suspended */
+	__u32  rsvd:26;
+
+	/** list of EP handles MA USB host is requesting to inactivate */
+	struct mausb_ep_handle ep_handle[MAUSB_PKT_MAX_NUM_EP];
+};
+
+/** Enpoint Inactivate Response fields, per 6.3.11, Table 33 */
+struct __packed mausb_EPInactivateResp_flds {
+	__u8  num_ep_with_error:5; /** number of EP handles with */
+				   /** unsuccessful inactivation */
+				   /** should only be non-zero if */
+				   /** packet status is not SUCCESS */
+	__u32  rsvd:27;
+
+	/** list of EP handles whose inactivation failed */
+	struct mausb_ep_handle ep_handle[MAUSB_PKT_MAX_NUM_EP];
+};
+
+#define MAUSB_MGMT_MAX_TOKEN ((1 << 10) - 1)
+#define MAUSB_MGMT_TOKEN_PAD_LEN 3 /* token + pad to DWORD */
+
+/** Management Packet fields, per 6.3.1 */
+struct __packed mausb_mgmt_pkt {
+	struct mausb_pkt_common common;
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le16                  token:10;
+	__le16                  padding:6; /* for DWORD alignment */
+#else
+	__le16                  padding:6; /* for DWORD alignment */
+	__le16                  token:10;
+#endif
+	__u8                    padding_2;
+	union {
+		struct mausb_CapReq_flds             cap_req;
+		struct mausb_CapResp_flds            cap_resp;
+		struct mausb_USBDevHandleReq_flds    usb_dev_handle_req;
+		__le16                                usb_dev_handle_resp;
+		struct mausb_EPHandleReq_flds        ep_handle_req;
+		struct mausb_EPHandleResp_flds       ep_handle_resp;
+		struct mausb_EPHandleDelete_flds     ep_handle_delete;
+		struct mausb_ModifyEP0_flds          modify_ep0_req;
+		struct mausb_ModifyEP0_flds          modify_ep0_resp;
+		struct mausb_SetDevAddrReq_flds      set_dev_addr_req;
+		struct mausb_SetDevAddrResp_flds     set_dev_addr_resp;
+		struct mausb_UpdateDevReq_flds       update_dev_req;
+		struct mausb_SynchReq_flds           synch_req;
+		__le16                                ep_close_stream_req;
+		struct mausb_CancelTransferReq_flds  cancel_transfer_req;
+		struct mausb_CancelTransferResp_flds cancel_transfer_resp;
+		struct mausb_EPOpenStreamReq_flds    ep_open_stream_req;
+		struct mausb_EPInactivateReq_flds    ep_inactivate_req;
+		struct mausb_EPInactivateResp_flds   ep_inactivate_resp;
+
+		/* TODO: add remaining management packet data */
+
+	};
+};
+
+/** Transfer Setup Request fields, per 6.4.1, Table 38 */
+struct __packed mausb_TransferSetupReq_flds {
+	/** Identifies link type     */
+	/** 0     = Reserved         */
+	/** 1     = IEEE 802.11 link */
+	/** 2-255 = Reserved         */
+	__u8 link_type;
+	/** Connection ID data is dependant on Link Type */
+	union {
+		/** for 802.11 links (link_type == 1) */
+		struct __packed {
+			__u8 tid:4;  /**< Traffic Identifier */
+			__u8 rsvd:4;
+		} connection_id;
+	};
+};
+
+/** Control Packet fields, per 6.4 */
+struct __packed mausb_ctrl_pkt {
+	struct mausb_pkt_common common;
+	struct mausb_TransferSetupReq_flds transfer_setup_req;
+	__u8 padding; /* for header DWORD alignment */
+};
+
+#define MAUSB_PKT_EPS_UNASSIGNED 0
+#define MAUSB_PKT_EPS_ACTIVE     1
+#define MAUSB_PKT_EPS_INACTIVE   2
+#define MAUSB_PKT_EPS_HALTED     3
+
+#define MAUSB_PKT_TFLAG_ARQ  (1 << 2)
+#define MAUSB_PKT_TFLAG_NEG  (1 << 3)
+#define MAUSB_PKT_TFLAG_EOT  (1 << 4)
+#define MAUSB_PKT_TFLAG_TYPE_CTRL (0 << 5)
+#define MAUSB_PKT_TFLAG_TYPE_ISOC (1 << 5)
+#define MAUSB_PKT_TFLAG_TYPE_BULK (2 << 5)
+#define MAUSB_PKT_TFLAG_TYPE_INT  (3 << 5)
+#define MAUSB_PKT_TFLAG_TYPE_MASK 0x60
+
+#define MAUSB_PKT_SEQ_NUM_MASK 0x00FFFFFF
+
+/** Fields common to all datapackets, per 6.5 */
+struct __packed mausb_dph {
+	struct mausb_pkt_common common;
+	__u8   eps_tflags;	/**< EPS & T-Flags */
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le16 num_seg:12;
+	__le16 iflags:4;
+#else
+	__le16 iflags:4;
+	__le16 num_seg:12;
+#endif
+#ifdef __LITTLE_ENDIAN_BITFIELD
+	__le32 seq_num:24;	/**< Sequence Number */
+	__le32  req_id:8;	/**< request ID */
+#else
+	__le32  req_id:8;	/**< request ID */
+	__le32 seq_num:24;      /**< Sequence Number */
+#endif
+	union {
+		__le32 remaining_size_credit;
+		__le32 present_time;
+	};
+};
+
+/** Fields exclusive to isochronous data packets, per 6.5 */
+struct __packed mausb_iso_dph {
+	struct mausb_dph data;
+	__le32 wse_ts;          /**< WSE Timestamp */
+	__le32 tx_dly;          /**< Transmission Delay */
+};
+
+
+/* unless the urb contains scattergather buffers, a packet will
+ * need at most 3 entries:
+ *	- 1 for the header
+ *	- 1 for the setup data
+ *	- 1 for the data buffer
+ *
+ */
+#define MAUSB_MS_PKT_ORIG_NENTS 4
+
+/**
+ * mausb_pkt structure
+ *
+ * Can be used to parse any type of MAUSB packet, regardless of contents.
+ * If the packet type is known, this structure shouldn't be used. Instead,
+ * a type-specific structure (ie: mausb_XXXX_pkt) should be used.
+ *
+ * @setup:		setup data (control packets only)
+ * @buffer:		data buffer
+ * @buffer_length:	length of data buffer
+ * @pkt_list:		connects packet to other packets in a linked list
+ * @kvec_list:		kvec list
+ * @nents:		number of kvecs
+ * @pkt:		A compilation of all the buffers needed to be sent
+ *			across the medium. Used to pass packet to medium.
+ * @orig_pkt:		Original ms_pkt for this packet. Used for destructor.
+ *	 		If this packet originated from the MA driver, it will
+ *			point to the ms_pkt of this ma_pkt. If it came in from
+ *			the MS driver, it will point at the ms_pkt it sent
+ *			us. This is used by the ms_pkt_destructor, so we can
+ *			make sure we are pointing to the right ms_pkt.
+ */
+struct mausb_pkt {
+	union {
+		struct mausb_pkt_common *common;
+		struct mausb_mgmt_pkt   *mgmt;
+		struct mausb_ctrl_pkt   *ctrl;
+		struct mausb_dph        *data;
+		struct mausb_iso_dph    *iso_data;
+	};
+
+	struct usb_ctrlrequest *setup;
+	void *buffer;
+	u32 buffer_length;
+	struct list_head pkt_list;
+	struct kvec *kvec_list;
+	int nents;
+	struct ms_pkt pkt;
+	struct ms_pkt *orig_pkt;
+	void (*ms_pkt_destructor)(struct ms_pkt *pkt);
+};
+
+enum mausb_pkt_buf_copy_dir {
+	MAUSB_PKT_BUF_COPY_TO_KVEC = 0,
+	MAUSB_PKT_BUF_COPY_FROM_KVEC
+};
+
+void mausb_pkt_buf_copy_kvec(struct mausb_pkt *pkt, int buf_length, int offset,
+			  struct kvec *kv, int nents,
+			   enum mausb_pkt_buf_copy_dir dir);
+
+/* function declarations */
+const char *mausb_type_to_string(enum mausb_pkt_type type);
+int mausb_pkt_fill_ms_pkt(struct mausb_pkt *pkt, gfp_t mem_flags);
+int mausb_pkt_header_length(struct mausb_pkt_common *header);
+enum mausb_pkt_status mausb_errno_to_ma_status(int errno);
+int mausb_to_urb_status(enum mausb_pkt_status pkt_status);
+struct usb_endpoint_descriptor *mausb_ep_handle_req_get_ep_des(
+		struct mausb_EPHandleReq_flds *req, int i);
+int mausb_pkt_length(struct mausb_pkt *pkt);
+struct mausb_pkt *mausb_alloc_pkt(enum mausb_pkt_type pkt_type, int *status,
+		gfp_t memflags);
+int mausb_generate_ms_pkt(struct mausb_pkt *pkt);
+bool mausb_pkt_has_setup_data(struct mausb_dph *header);
+struct mausb_pkt *ms_pkt_to_mausb_pkt(struct ms_pkt *ms_pkt);
+struct mausb_pkt *mausb_pkt_from_ms_pkt(struct ms_pkt *ms_pkt,
+		void (*ms_pkt_destructor)(struct ms_pkt *ms_pkt),
+		gfp_t mem_flags);
+int mausb_pkt_dmux(struct ms_pkt *ms_pkt, void *context);
+void mausb_free_pkt(struct mausb_pkt *pkt);
+bool mausb_pkt_resp(struct mausb_pkt *pkt);
+struct mausb_dev_cap_desc *cap_desc_ptr_increment(struct mausb_mgmt_pkt *resp,
+		int offset);
+
+/* Helper functions for sequence number and request id wraparound */
+u32 mausb_seq_num_add(u32 seq_num, int val);
+void mausb_increment_seq_num(u32 *seq_num);
+bool mausb_seq_num_lt(u32 a, u32 b);
+bool mausb_seq_num_lt_eq(u32 a, u32 b);
+bool mausb_seq_num_gt_eq(u32 a, u32 b);
+bool mausb_seq_num_gt(u32 a, u32 b);
+u8 mausb_req_id_add(u8 req_id, int val);
+bool mausb_req_id_lt(u8 a, u8 b);
+bool mausb_req_id_gt(u8 a, u8 b);
+bool mausb_req_id_gt_eq(u8 a, u8 b);
+
+#endif
-- 
1.9.1

