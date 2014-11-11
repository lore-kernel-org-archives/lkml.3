Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaKKCMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:12:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:59180 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaKKCKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:10:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414590931"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [V2 PATCH 08/10] added media agnostic (MA) USB data packet handling
Date: Mon, 10 Nov 2014 18:09:39 -0800
Message-Id: <1415671781-11351-8-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MA USB Specification outlines packet types and a protocol for
bulk and interrupt transfers. This is where we implement that protocol.
MA USB transfers are initiated by the host via a TransferRequest packet.
The host then either sends data to the device via subsequent
TransferRequest packets (OUT transfer) or receives data from the device
via TransferResponse packets (IN transfer). Each data transfer is
identified by a Request ID number that increments up for each new transfer.
One URB maps to one MA USB transfer. A transfer can consist of one or
more MA USB packets depending on total transfer size. Each MA USB packet
is assigned a Sequence Number with sequence numbers incrementing up for
each new packet. The host sends a TransferAck packet to acknowledge the
end of a transfer or when requested to do so by the device.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/mausb/drivers/mausb_tx-device.c |  845 ++++++++++++++++
 drivers/staging/mausb/drivers/mausb_tx-host.c   | 1209 +++++++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_tx.c        |  316 ++++++
 drivers/staging/mausb/drivers/mausb_tx.h        |  127 +++
 4 files changed, 2497 insertions(+)
 create mode 100644 drivers/staging/mausb/drivers/mausb_tx-device.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tx-host.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tx.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_tx.h

diff --git a/drivers/staging/mausb/drivers/mausb_tx-device.c b/drivers/staging/mausb/drivers/mausb_tx-device.c
new file mode 100644
index 0000000..7d1cab2
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_tx-device.c
@@ -0,0 +1,845 @@
+/* Name:        mausb_tx_device.c
+ * Description: implements MA USB transfers on device side
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
+   * Redistributions of source code must retain the above copyright
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
+#include "mausb_hcd.h"
+#include "mausb_udc.h"
+#include "mausb_pkt.h"
+#include "mausb_tx.h"
+
+#include <linux/kthread.h>
+
+int device_transfer_timeout(void *data)
+{
+	struct mausb_host_ep		*ep = (struct mausb_host_ep *) data;
+	struct mausb_udc		*udc = mausb_host_ep_to_maudc(ep);
+
+	while (!kthread_should_stop()) {
+		/*
+		 * make sure actual transfer timeout (i.e. not thread
+		 * setup)
+		 */
+		if (ep->tx_timed_out) {
+			if (ep->state.retry_counter > 0) {
+				maudc_dbg(udc, "%s: device timed out,"
+				      "  resending packet %i\n",
+				       __func__, ep->state.seq_number);
+
+				device_OUT_send_txResp(
+					&ep->active_transfer->state,
+					&ep->state,
+					ep->state.active_request_id,
+					ep->state.seq_number,
+					SUCCESS,
+					false, false, false);
+
+				ep->state.retry_counter--;
+			} else {
+				/*
+				 * TODO: start ping protocol per 5.2.2, if
+				 * successful reset timer and retries. For now
+				 * we just treat as if failed.
+				 */
+				ep->active_transfer->state.transfer_error =
+					true;
+				return -ETIMEDOUT;
+			}
+
+			ep->tx_timed_out = false;
+		}
+
+		/* put thread to sleep to wait for next timeout event */
+		wait_event_interruptible(ep->host_ep_wq,
+			kthread_should_stop() || ep->tx_timed_out);
+	}
+
+	return 0;
+}
+
+
+/*-------------------------IN transfer ------------------------*/
+
+/**
+ * Device-side IN transfer initialization process.
+ *
+ * @ tx_state:	Transfer state to be initialized.
+ * @ ep_state:	Endpoint state to be initialized.
+ * @ tx_req:	TransferReq packet from host that intiated transfer.
+ *
+ * Called every time a transferReq packet is received. Initializes transfer
+ * management variables.
+ */
+void device_init_IN_transfer(struct mausb_transfer_state *tx_state,
+		struct mausb_ep_state *ep_state, struct mausb_pkt *tx_req)
+{
+	struct mausb_host_ep *ep = mausb_state_to_ep(ep_state);
+
+	tx_state->transfer_error = false;
+	tx_state->transfer_complete = false;
+	tx_state->rem_size = le32_to_cpu(tx_req->data->remaining_size_credit);
+
+	ep_state->keep_alive_timer = MAUSB_TRANSFER_KEEP_ALIVE;
+	ep_state->retry_counter = MAUSB_BULK_TRANSFER_RETRIES;
+	ep_state->earliest_unacked = le32_to_cpu(tx_req->data->seq_num);
+	ep_state->active_request_id = tx_req->data->req_id;
+	ep_state->request_id++;
+
+	ep->actual_length = 0;
+
+	/* free old buffer if not previously freed */
+	if (ep->buffer)
+		kfree(ep->buffer);
+
+	/* alocate new buffer for this transfer */
+	ep->buffer = kzalloc(tx_state->rem_size, GFP_ATOMIC);
+}
+
+/* Determines if packet request id or sequence number is outside of the
+ * acceptable range
+ *
+ * Returns true if the packet sequence number or request id is invalid,
+ * otherwise returns false.
+ */
+bool is_invalid_IN_request(struct mausb_ep_state *ep_state,
+		struct mausb_pkt *tx_req)
+{
+	u8			r = tx_req->data->req_id;
+	u32			SN = le32_to_cpu(tx_req->data->seq_num);
+	bool			invalid = false;
+	struct mausb_udc	*udc = mausb_host_ep_to_maudc(
+					mausb_state_to_ep(ep_state));
+
+	if ((ep_state->earliest_request_id - MAUSB_HALF_REQ_ID) <= r) {
+		if (r < ep_state->earliest_request_id) {
+			maudc_err(udc, "%s: too many outstanding requests\n",
+				__func__);
+			invalid = true;
+		}
+	}
+
+	if ((ep_state->earliest_unacked - MAUSB_HALF_SEQ_NUM) <= SN) {
+		if (SN < ep_state->earliest_unacked) {
+			maudc_err(udc, "%s: too many unacknowledged packets\n",
+				__func__);
+			invalid = true;
+		}
+	}
+
+	if (ep_state->seq_number < SN) {
+		if (SN < (ep_state->seq_number + MAUSB_HALF_SEQ_NUM)) {
+			maudc_err(udc, "%s: too many outstanding sequence"
+			       " numbers\n", __func__);
+			invalid = true;
+		}
+
+	}
+
+	return invalid;
+}
+
+/*
+ * transferReq reception process outlined in MA USB spec.
+ */
+int device_IN_rcvd_txReq(struct mausb_ep_state *ep_state,
+		struct mausb_transfer_state *tx_state,
+		struct mausb_pkt *tx_req)
+{
+	u8			r = tx_req->data->req_id;
+	u32			SN  = le32_to_cpu(tx_req->data->seq_num);
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_udc	*udc = mausb_host_ep_to_maudc(ep);
+
+	if (is_invalid_IN_request(ep_state, tx_req)) {
+		mausb_drop_packet(ep, tx_req);
+		device_IN_send_null_txResp(ep, ep_state->request_id,
+					   INVALID_REQUEST);
+	}
+
+	ep_state->earliest_unacked = SN;
+
+	if (tx_state->eot_detected && !tx_state->transfer_error) {
+		if (tx_state->last_transfer_sn < SN)
+			tx_state->transfer_complete = true;
+		else
+		ep_state->earliest_request_id = r;
+	}
+
+	if (r == ep_state->active_request_id && ep_state->delayed) {
+		maudc_dbg(udc, "%s: transfer %i is delayed, sending txResp with"
+		      " status = TRANSFER_PENDING\n", __func__, r);
+		device_IN_send_null_txResp(ep, r, TRANSFER_PENDING);
+	}
+
+	if (r == ep_state->request_id)
+		device_init_IN_transfer(tx_state, ep_state, tx_req);
+
+	return 0;
+}
+
+/* transferAck packet reception process for device side.
+ *
+ * @tx_state:	Transfer state variables for associated transfer.
+ * @ep_state:	Endpoint state variables for associated transfer.
+ * @tx_ack:	TransferAck packet being received.
+ *
+ * Called when device side driver receives a transferAck packet. Caller should
+ * verify that the request_id in the transferAck packet is valid before
+ * calling this function.
+ */
+int device_IN_ack_rcvd(struct mausb_transfer_state *tx_state,
+		struct mausb_ep_state *ep_state, struct mausb_pkt *tx_ack)
+{
+	int			ret = 0;
+	u8			r = tx_ack->data->req_id;
+	u8			u = ep_state->active_request_id;
+	u32			SN = le32_to_cpu(tx_ack->data->seq_num);
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_udc	*udc = mausb_host_ep_to_maudc(ep);
+	bool			tx_complete = (!tx_state->transfer_error)
+					&& (tx_state->last_transfer_sn < SN);
+	bool			tx_complete_with_error =
+					(tx_state->transfer_error) && (u == r);
+	unsigned long		irq_flags = 0;
+
+	if (is_invalid_IN_request(ep_state, tx_ack))
+		tx_ack->data->common.pkt_status = DROPPED_PACKET;
+
+	switch (tx_ack->data->common.pkt_status) {
+	case DROPPED_PACKET:
+		maudc_dbg(udc, "%s: status = DROPPED_PACKET\n", __func__);
+		mausb_drop_packet(ep, tx_ack);
+		break;
+	case TRANSFER_PENDING:
+		maudc_dbg(udc, "%s: status = TRANSFER_PENDING\n", __func__);
+		if (r != ep_state->active_request_id)
+			mausb_drop_packet(ep, tx_ack);
+		/* else can start power saving measures */
+		break;
+	case MISSING_SEQUENCE_NUMBER:
+		maudc_dbg(udc, "%s: status = MISSING_SEQUENCE_NUMBER\n",
+			__func__);
+		mausb_resend_multi_packets(ep, &ep->resp_list,
+			le32_to_cpu(tx_ack->data->seq_num), irq_flags);
+		break;
+	case SUCCESS:
+		maudc_dbg(udc, "%s: status = SUCCESS\n", __func__);
+		ep_state->earliest_unacked = SN + 1;
+
+		if (tx_state->eot_detected) {
+			if (tx_complete || tx_complete_with_error)
+				tx_state->transfer_complete = true;
+			else
+				ep_state->earliest_request_id = u;
+
+			mausb_cleanup_ma_packets(ep,
+				le32_to_cpu(tx_ack->data->seq_num),
+				tx_ack->data->req_id);
+			kfree(ep->buffer);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+/* Submit a transferResp packet to host with no payload (used for errors).
+ *
+ * Per spec, sequence number field in a null transferResp packet is always
+ * reserved and set to 0
+ */
+int device_IN_send_null_txResp(struct mausb_host_ep *ep, u8 req_id, int status)
+{
+	struct mausb_pkt		*tx_resp;
+	struct mausb_transfer_state	*tx_state = &ep->active_transfer->state;
+
+	tx_resp = mausb_create_dp(NULL, ep->active_transfer, MAUSB_IN,
+		MAUSB_DEV, GFP_ATOMIC);
+
+	if (!tx_resp)
+		return -ENOMEM;
+
+	list_add_tail(&tx_resp->pkt_list, &ep->resp_list);
+
+	mausb_fill_pkt_ep(tx_resp, ep);
+
+	tx_resp->data->common.pkt_type = TransferResp;
+	tx_resp->data->req_id = req_id;
+	tx_resp->data->seq_num = 0;
+	tx_resp->buffer_length = 0;
+	tx_resp->data->remaining_size_credit = cpu_to_le32(tx_state->rem_size);
+	tx_resp->data->common.pkt_status = status;
+	tx_resp->common->length = cpu_to_le32(mausb_pkt_length(tx_resp));
+
+	mausb_transfer_data_pkt(tx_resp, ep, GFP_ATOMIC);
+
+	return 0;
+}
+
+/**
+ * Submit a transferResp packet with payload to host (normal data transfer).
+ */
+int device_IN_send_txResp_with_payload(struct mausb_host_ep *ep)
+{
+	int				payload = 0;
+	int				max_buffer_length = 0;
+	int				ep_rem_size = ep->actual_length;
+	struct mausb_ep_state		*ep_state = &ep->state;
+	struct mausb_transfer_state	*tx_state = &ep->active_transfer->state;
+	struct mausb_pkt		*tx_resp;
+	struct mausb_udc		*udc = mausb_host_ep_to_maudc(ep);
+
+	while (ep_rem_size > 0 || ep_state->seq_number == 0)  {
+
+		tx_resp = mausb_create_dp(NULL, ep->active_transfer, MAUSB_IN,
+					  MAUSB_DEV, GFP_ATOMIC);
+
+		if (!tx_resp)
+			return -ENOMEM;
+
+		list_add_tail(&tx_resp->pkt_list, &ep->resp_list);
+
+		mausb_fill_pkt_ep(tx_resp, ep);
+
+		tx_resp->data->common.pkt_type = TransferResp;
+		tx_resp->data->req_id = ep_state->active_request_id;
+		tx_resp->data->seq_num = cpu_to_le32(ep_state->seq_number);
+		tx_resp->data->remaining_size_credit =
+			cpu_to_le32(tx_state->rem_size);
+
+		max_buffer_length =
+			MAUSB_MAX_PACKET_SIZE - sizeof(tx_resp->data);
+
+		if (max_buffer_length <= 0) {
+			maudc_err(udc, "%s: packet buffer error: length"
+			       " = %i\n", __func__, max_buffer_length);
+		} else if (tx_state->rem_size <= 0) {
+			maudc_err(udc, "%s: packet buffer error: rem_size"
+			       " = %i\n", __func__, tx_state->rem_size);
+			ep->buffer = NULL;
+		} else {
+			payload = min_t(int, max_buffer_length,
+					ep_rem_size);
+		}
+
+		tx_resp->buffer = ep->buffer;
+		tx_resp->buffer_length = payload;
+		tx_resp->common->length = cpu_to_le16(mausb_pkt_length(tx_resp));
+
+		/* note: setting ARQ flag for error is optional */
+		if (tx_state->transfer_error) {
+			maudc_err(udc, "%s: transfer error with %i bytes "
+			       "remaining\n", __func__, tx_state->rem_size);
+
+			tx_resp->data->eps_tflags |= MAUSB_PKT_TFLAG_EOT;
+			tx_resp->data->eps_tflags |= MAUSB_PKT_TFLAG_ARQ;
+			tx_resp->data->common.pkt_status = UNSUCCESSFUL;
+
+			/*
+			 * TODO: take corrective action - e.g. clear all
+			 * transfers and restart endpoint
+			 */
+		}
+
+		tx_state->rem_size -= payload;
+		ep_rem_size -= payload;
+		/* note: setting ARQ flag for completion is optional */
+		if (tx_state->rem_size == 0 || ep_rem_size == 0) {
+			tx_resp->data->eps_tflags |= MAUSB_PKT_TFLAG_EOT;
+			tx_resp->data->eps_tflags |= MAUSB_PKT_TFLAG_ARQ;
+			tx_resp->data->common.pkt_status = SUCCESS;
+
+			ep_state->active_request_id++;
+		}
+
+		maudc_dbg(udc, "%s: sending transferResp packet with sequence"
+			" number %i for tranfer %i with %i bytes\n", __func__,
+			le32_to_cpu(tx_resp->data->seq_num),
+			le32_to_cpu(tx_resp->data->req_id), payload);
+
+		mausb_transfer_data_pkt(tx_resp, ep, GFP_ATOMIC);
+
+		ep_state->seq_number++;
+
+	}
+
+	return 0;
+}
+
+/*------------------ protocol-managed OUT transfer --------------------*/
+
+bool should_drop_OUT_txReq(struct mausb_ep_state *ep_state,
+		struct mausb_transfer_state *tx_state, struct mausb_pkt *tx_req)
+{
+	u8			r = tx_req->data->req_id;
+	u32			SN = le32_to_cpu(tx_req->data->seq_num);
+	int			payload_size = tx_req->buffer_length;
+	int			status = SUCCESS;
+	bool			drop = false;
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_udc	*udc = mausb_host_ep_to_maudc(ep);
+
+	if (SN > ep_state->seq_number) {
+		maudc_err(udc, "%s: sequence number %i is too large "
+			"(expected < %i)\n", __func__, SN,
+			ep_state->seq_number);
+		drop = true;
+		status = MISSING_SEQUENCE_NUMBER;
+	} else if (SN < ep_state->seq_number) {
+		/* per spec, don't have to send response for this case */
+		maudc_err(udc, "%s: sequence number %i is too small "
+			"(expected >= %i)\n", __func__, SN,
+			ep_state->seq_number);
+		drop = true;
+	} else if (r < ep_state->earliest_request_id) {
+		maudc_err(udc, "%s: request ID %i is too small "
+			"(expected > %i)\n", __func__, r,
+			ep_state->earliest_request_id);
+		drop = true;
+		status = INVALID_REQUEST;
+	} else if (r > ep_state->request_id) {
+		/* account for wraparound */
+		if (ep_state->request_id != 0 && r != MAUSB_MAX_REQ_ID) {
+			maudc_err(udc, "%s: request ID %i is too large "
+				"(expected < %i)\n", __func__, r,
+				ep_state->request_id);
+			drop = true;
+			status = INVALID_REQUEST;
+		}
+	} else if ((payload_size + ep_state->occupancy)
+			> ep_state->rx_buf_size) {
+		maudc_err(udc, "%s: payload (%i bytes) is too large for buffer"
+			" (%i bytes)\n", __func__, payload_size,
+			ep_state->occupancy);
+		drop = true;
+		status = TRANSFER_DATA_BUFFER_ERROR;
+	}
+
+	/*
+	 * send txResp to host with appropriate status if txReq is going to
+	 * get dropped
+	 */
+	if (status) {
+		device_OUT_send_txResp(tx_state, ep_state,
+			ep_state->request_id, ep_state->seq_number, status,
+			false, false, false);
+	}
+
+	return drop;
+}
+
+/**
+ * Handles receipt of a transferRequest packet.
+ *
+ * @tx_state: State variables for associated transfer.
+ * @ep_state: State variables for associated device endpoint.
+ * @tx_req:   TransferRequest packet being received.
+ */
+int device_OUT_txReq_rcvd(struct mausb_transfer_state *tx_state,
+		struct mausb_ep_state *ep_state, struct mausb_pkt *tx_req)
+{
+	u8			req_id = tx_req->data->req_id;
+	u32			SN = le32_to_cpu(tx_req->data->seq_num);
+	int			ret = 0;
+	int			payload_size = tx_req->buffer_length;
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_udc	*udc = mausb_host_ep_to_maudc(ep);
+
+	maudc_dbg(udc, "%s: received transferReq packet %i for transfer %i\n",
+		__func__, SN, req_id);
+
+	if (should_drop_OUT_txReq(ep_state, tx_state, tx_req)) {
+		maudc_err(udc, "%s: dropping packet %i\n", __func__, SN);
+		mausb_drop_packet(ep, tx_req);
+		return 0;
+	}
+
+	/* start new transfer */
+	if (req_id == (ep_state->request_id)) {
+		tx_state->transfer_error = false;
+		tx_state->transfer_complete = false;
+		tx_state->eot_detected = false;
+		tx_state->rem_size =
+			le32_to_cpu(tx_req->data->remaining_size_credit);
+		tx_state->payload_size = 0;
+		ep->active_transfer->transfer_size = tx_state->rem_size;
+		ep_state->active_request_id = req_id;
+		INIT_LIST_HEAD(&ep->req_list);
+		INIT_LIST_HEAD(&ep->resp_list);
+
+		ep->actual_length = 0;
+
+		ep_state->request_id =
+			mausb_req_id_add(ep_state->request_id, 1);
+	}
+
+	ep->buffer = tx_req->buffer;
+	ep_state->occupancy += payload_size;
+	ret = device_OUT_deliver_payload(tx_req, ep_state, tx_state);
+	ep_state->occupancy -= payload_size;
+
+	ep_state->seq_number++;
+
+	return 0;
+}
+
+/**
+ * Transmits a transferReq or transferAck packet.
+ */
+int device_OUT_send_txResp(struct mausb_transfer_state *tx_state,
+		struct mausb_ep_state *ep_state, u32 req_id, u32 seq_num,
+		int status, bool retry, bool eot, bool arq)
+{
+	struct mausb_host_ep *ep = mausb_state_to_ep(ep_state);
+	struct mausb_pkt *tx_resp = mausb_create_dp(NULL, ep->active_transfer,
+				     MAUSB_OUT, MAUSB_DEV, GFP_ATOMIC);
+	struct mausb_udc *udc = mausb_host_ep_to_maudc(ep);
+
+	if (!tx_resp)
+		return -ENOMEM;
+
+	mausb_fill_pkt_ep(tx_resp, ep);
+
+	tx_resp->data->common.pkt_type = TransferResp;
+	tx_resp->data->req_id = req_id;
+	tx_resp->data->seq_num = cpu_to_le32(seq_num);
+	tx_resp->data->common.pkt_status = status;
+	tx_resp->data->remaining_size_credit =
+		cpu_to_le32(ep_state->rx_buf_size - ep_state->occupancy);
+
+	list_add_tail(&tx_resp->pkt_list, &ep->resp_list);
+
+
+	tx_resp->common->length = cpu_to_le16(mausb_pkt_length(tx_resp));
+
+	if (retry)
+		tx_resp->common->ver_flags |= MAUSB_PKT_FLAG_RETRY;
+
+	if (eot)
+		tx_resp->data->eps_tflags |= MAUSB_PKT_TFLAG_EOT;
+
+	if (arq)
+		tx_resp->data->eps_tflags |= MAUSB_PKT_TFLAG_ARQ;
+
+	maudc_dbg(udc, "%s: sending transferResp packet %i for transfer %i\n",
+		__func__, le32_to_cpu(tx_resp->data->seq_num),
+		tx_resp->data->req_id);
+
+	/* send transferResp packet to host */
+	mausb_transfer_data_pkt(tx_resp, ep, GFP_ATOMIC);
+
+	return 0;
+}
+
+/**
+ * Handles receipt of a transferAck packet.
+ *
+ * Caller should ensure that transfer complete and error flags are not set.
+ * Note that what to do isn't defined in spec - we are on our own for this one!
+ */
+void device_OUT_ack_rcvd(struct mausb_transfer_state *tx_state,
+		struct mausb_ep_state *ep_state,
+		struct mausb_pkt *tx_ack)
+{
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_udc	*udc = mausb_host_ep_to_maudc(ep);
+
+	maudc_dbg(udc, "%s: received transferAck packet for transfer %i\n",
+		__func__, tx_ack->data->req_id);
+
+	ep_state->occupancy = 0;
+	mausb_cleanup_ma_packets(ep, le32_to_cpu(tx_ack->data->seq_num),
+		tx_ack->data->req_id);
+}
+
+/*
+ * Copy payload from transferRequest into device buffer.
+ *
+ * @tx_req:   TransferRequest with payload to be delivered.
+ * @ep_state: State variables for associated device endpoint.
+ * @tx_state: State variables for associated transfer.
+ *
+ * Caller should ensure that transfer complete and error flags are not set.
+ * This function also includes payload delivery process outlined in spec.
+ */
+int device_OUT_deliver_payload(struct mausb_pkt *tx_req,
+		struct mausb_ep_state *ep_state,
+		struct mausb_transfer_state *tx_state)
+{
+	u32			req_sn = le32_to_cpu(tx_req->data->seq_num);
+	int			payload_size;
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_udc	*udc = mausb_host_ep_to_maudc(ep);
+
+	/* payload delivery process */
+	payload_size = do_ma_transfer(ep, tx_req, MAUSB_OUT);
+
+	/* payload delivery confirmation process */
+	if (payload_size < 0) {
+		maudc_err(udc, "%s: transfer error %i\n", __func__,
+			payload_size);
+
+		device_OUT_send_txResp(tx_state, ep_state, tx_req->data->req_id,
+			le32_to_cpu(tx_req->data->seq_num), UNSUCCESSFUL,
+				       false, true, false);
+	}
+
+	else {
+		ep_state->earliest_unacked = req_sn + 1;
+		tx_state->payload_size = payload_size - tx_state->payload_size;
+		tx_state->rem_size =
+			le32_to_cpu(tx_req->data->remaining_size_credit);
+		tx_state->payload_size = payload_size;
+
+		maudc_dbg(udc, "%s: delivered %i bytes with %i remaining\n",
+		       __func__, payload_size, tx_state->rem_size);
+
+		/* control response packet */
+		if (tx_req->setup) {
+			device_OUT_send_txResp(tx_state, ep_state,
+				tx_req->data->req_id,
+				le32_to_cpu(tx_req->data->seq_num),
+				SUCCESS, false, true, true);
+
+		/* end of transfer response packet */
+		} else if (tx_state->rem_size == 0) {
+			tx_state->last_transfer_sn = req_sn;
+
+			device_OUT_send_txResp(tx_state, ep_state,
+				tx_req->data->req_id,
+				le32_to_cpu(tx_req->data->seq_num),
+				SUCCESS, false, true, true);
+		} else if (tx_req->data->eps_tflags & MAUSB_PKT_TFLAG_ARQ) {
+			device_OUT_send_txResp(tx_state, ep_state,
+				tx_req->data->req_id,
+				le32_to_cpu(tx_req->data->seq_num),
+				SUCCESS, false, false, true);
+		}
+	}
+
+	return 0;
+}
+
+/*------------------ transfer interfaces ----------------------------*/
+
+/**
+ * Called to receive both transferRequest and transferAck packets.
+ * For transferRequests, a new transfer is initiated - transfer state values
+ * are initialized and a request is send to the device to get data. For
+ * transferAcks, a transfer is ended (either successfully or with error,
+ * depending on transferAck packet status).
+ */
+int receive_ma_packet_IN(struct ms_pkt *ms_pkt, void *context)
+{
+	int				ret = 0;
+	struct mausb_host_ep		*ep;
+	struct mausb_pkt		*pkt;
+	struct mausb_udc		*udc;
+
+	if ((NULL == context) || (NULL == ms_pkt)) {
+		pr_err("%s: received NULL %s\n", __func__,
+			context ? "packet" : "context");
+		return -EFAULT;
+	}
+
+	ep = (struct mausb_host_ep *) context;
+	del_timer(&ep->timer);
+
+	pkt = mausb_pkt_from_ms_pkt_ep(ms_pkt, ep, GFP_ATOMIC);
+	list_add_tail(&pkt->pkt_list, &ep->req_list);
+
+	udc = mausb_host_ep_to_maudc(ep);
+
+	if (mausb_is_a_retry(ep, &ep->resp_list, pkt))
+		return 0;
+
+	switch (pkt->data->common.pkt_type) {
+	case TransferReq:
+		maudc_dbg(udc, "%s: received transferReq %i for transfer %i\n",
+			__func__, le32_to_cpu(pkt->data->seq_num),
+			pkt->data->req_id);
+		device_IN_rcvd_txReq(&ep->state, &ep->active_transfer->state,
+			pkt);
+		ret = do_ma_transfer(ep, pkt, MAUSB_IN);
+		ret = device_IN_send_txResp_with_payload(ep);
+		break;
+	case TransferAck:
+		maudc_dbg(udc, "%s: received transferAck for transfer %i\n",
+			__func__, pkt->data->req_id);
+		ret = device_IN_ack_rcvd(&ep->active_transfer->state,
+			&ep->state, pkt);
+		break;
+	default:
+		maudc_err(udc, "%s: invalid packet type/subtype %i\n",
+			__func__, pkt->data->common.pkt_type);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/**
+ * Receives both transferReq and transferAck packets for OUT transfers. When a
+ * packet is received, it is put on a list for handling. If the endpoint is not
+ * already handling a packet, it starts iterating through the list of received
+ * packets.
+ */
+int receive_ma_packet_OUT(struct ms_pkt *ms_pkt, void *context)
+{
+	int				ret = 0;
+	struct mausb_host_ep		*ep;
+	struct mausb_pkt		*pkt;
+	struct mausb_udc		*udc;
+
+	if ((NULL == context) || (NULL == ms_pkt)) {
+		pr_err("%s: received NULL %s\n", __func__,
+			context ? "packet" : "context");
+		return -EFAULT;
+	}
+
+	ep = (struct mausb_host_ep *) context;
+	del_timer(&ep->timer);
+
+	pkt = mausb_pkt_from_ms_pkt_ep(ms_pkt, ep, GFP_ATOMIC);
+	list_add_tail(&pkt->pkt_list, &ep->req_list);
+
+	udc = mausb_host_ep_to_maudc(ep);
+
+	if (mausb_is_a_retry(ep, &ep->resp_list, pkt))
+		return 0;
+
+	/* determine if packet is a transferRequest */
+	if (pkt->data->common.pkt_type == TransferReq) {
+		maudc_dbg(udc, "%s: received transferReq %i for transfer %i\n",
+			__func__, le32_to_cpu(pkt->data->seq_num),
+			pkt->data->req_id);
+		ret = device_OUT_txReq_rcvd(&ep->active_transfer->state,
+			&ep->state, pkt);
+
+	/* if not a transferReq, it should be a transferAck */
+	} else if (pkt->data->common.pkt_type == TransferAck) {
+		maudc_dbg(udc, "%s: received transferAck for transfer %i\n",
+			__func__, pkt->data->req_id);
+		device_OUT_ack_rcvd(&ep->active_transfer->state, &ep->state,
+			pkt);
+	} else {
+		/* TODO: deal with invalid packet type */
+	}
+
+	return ret;
+}
+
+/**
+ * Called when a transferReq is received on a control endpoint.
+ *
+ * @ms_pkt:	Packet being received.
+ * @context:	Device endpoint associated with transfer (this should always
+ *		be ep0).
+ */
+int receive_ma_packet_control(struct ms_pkt *ms_pkt, void *context)
+{
+	int				ret = 0;
+	struct mausb_host_ep		*ep;
+	struct mausb_pkt		*pkt;
+	struct mausb_udc		*udc;
+
+	if ((NULL == context) || (NULL == ms_pkt)) {
+		pr_err("%s: received NULL %s\n", __func__,
+			context ? "packet" : "context");
+		return -EFAULT;
+	}
+
+	ep = (struct mausb_host_ep *) context;
+	del_timer(&ep->timer);
+
+	pkt = mausb_pkt_from_ms_pkt_ep(ms_pkt, ep, GFP_ATOMIC);
+	udc = mausb_host_ep_to_maudc(ep);
+
+	/*
+	 * A new control transfer begins with a transfer request carrying setup
+	 * data and sequence number 0.
+	 */
+	if (pkt->setup) {
+		ep->state.seq_number = 0;
+		ep->actual_length = 0;
+		ep->active_transfer->state.rem_size =
+			le32_to_cpu(pkt->data->remaining_size_credit);
+
+		/*
+		 * Determine if this is a control IN or OUT - if there is data
+		 * in the packet, or the host is requesting no data, we are
+		 * an OUT.
+		 */
+		if (0 != pkt->buffer_length ||
+		    0 == le32_to_cpu(pkt->data->remaining_size_credit)) {
+
+			ep->control_dir = MAUSB_OUT;
+
+		} else
+			ep->control_dir = MAUSB_IN;
+	}
+
+	kfree(pkt);
+	pkt = NULL;
+
+	if (MAUSB_IN == ep->control_dir)
+		ret = receive_ma_packet_IN(ms_pkt, context);
+	else
+		ret = receive_ma_packet_OUT(ms_pkt, context);
+
+	return ret;
+}
+
diff --git a/drivers/staging/mausb/drivers/mausb_tx-host.c b/drivers/staging/mausb/drivers/mausb_tx-host.c
new file mode 100644
index 0000000..94b9e25
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_tx-host.c
@@ -0,0 +1,1209 @@
+/* Name:        mausb_tx-host.c
+ * Description: implement host-side Ma USB transfers
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
+   * Redistributions of source code must retain the above copyright
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
+#include <linux/kthread.h>
+
+#include "mausb_hcd.h"
+#include "mausb_pkt.h"
+#include "mausb_tx.h"
+
+/**
+ * Handles a data transfer timeout event, then sleeps until the next
+ * timeout event. Timeout events that wish to use this thread should
+ * set the ep->tx_timed_out flag to true to ensure that the thread
+ * is woken.
+ */
+int host_transfer_timeout(void *data)
+{
+	int				err = 0;
+	int				dir_in = 0;
+	int				seq_num = 0;
+	struct mausb_host_ep		*ep = (struct mausb_host_ep *) data;
+	struct mausb_ep_state		*ep_state = &ep->state;
+	struct mausb_transfer_state	*tx_state;
+	struct mausb_pkt		*tx_req;
+	unsigned long			irq_flags;
+	struct mausb_hcd		*mhcd = mausb_host_ep_to_mahcd(ep);
+
+	while (!kthread_should_stop()) {
+
+		spin_lock_irqsave(&ep->ep_lock, irq_flags);
+		/*
+		 * make sure there is an active transfer for timeout
+		 * to handle (i.e. not thread creation/initialization)
+		 */
+		if (ep->active_transfer && ep->active_transfer->urb) {
+			tx_state = &ep->active_transfer->state;
+			dir_in = usb_pipein(ep->active_transfer->urb->pipe);
+
+			seq_num = ep_state->earliest_unacked;
+
+			if (ep_state->retry_counter >  0) {
+				mausb_dbg(mhcd, "%s: host timed out waiting"
+					" for pkt %i\n", __func__, seq_num);
+
+				/* see if we have corresponding request */
+				err = mausb_resend_multi_packets(ep,
+					&ep->req_list, seq_num, irq_flags);
+
+				/* if not, send new req */
+				if (err != 0) {
+					spin_unlock_irqrestore(&ep->ep_lock,
+								irq_flags);
+
+					tx_req = mausb_create_dp(NULL,
+						 ep->active_transfer,
+						 MAUSB_IN, MAUSB_HOST,
+						 GFP_ATOMIC);
+
+					tx_req->data->common.pkt_type =
+						TransferReq;
+					tx_req->data->seq_num = seq_num;
+					tx_req->data->common.pkt_status =
+						SUCCESS;
+					tx_req->data->req_id =
+						ep_state->active_request_id;
+					tx_req->common->ver_flags
+						|= MAUSB_PKT_FLAG_RETRY;
+					tx_req->common->length =
+						mausb_pkt_length(tx_req);
+
+					/* submit packet for transport */
+					mausb_transfer_data_pkt(tx_req, ep,
+								GFP_ATOMIC);
+
+					spin_lock_irqsave(&ep->ep_lock,
+								irq_flags);
+
+					list_add_tail(&tx_req->pkt_list,
+						      &ep->req_list);
+				}
+
+				ep_state->retry_counter--;
+			} else {
+				/*
+				 * Can optionally initiate ping process in sec
+				 * 5.2.3 of spec. For now we just treat as if
+				 * ping protocol failed. */
+				tx_state->transfer_error = true;
+
+				spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+				mausb_unlink_giveback_urb(ep->active_transfer,
+							  -ETIMEDOUT);
+				spin_lock_irqsave(&ep->ep_lock, irq_flags);
+			}
+		}
+
+		ep->tx_timed_out = false;
+
+		spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+		/* put thread to sleep to wait for next timeout event */
+		wait_event_interruptible(ep->host_ep_wq,
+			kthread_should_stop() || ep->tx_timed_out);
+	}
+
+	return 0;
+}
+
+/* Initialize transfer state, for beginning a new transfer */
+static void mausb_host_init_tx_state(struct mausb_transfer_state *tx_state,
+		u32 tx_size)
+{
+	tx_state->transfer_error = false;
+	tx_state->transfer_complete = false;
+	tx_state->eot_detected = false;
+	tx_state->transfer_acked = false;
+	tx_state->rem_size = tx_size;
+	tx_state->payload_size = 0;
+}
+
+/*--------------------- IN transfers ------------------------------*/
+
+/**
+ * Host-side IN transfer initialization process.
+ *
+ * @tx_state: Transfer state to be initialized.
+ * @ep_state: Endpoint state to be initialized.
+ * @maurb:    maurb associated with transfer.
+ *
+ * Called whenever a new IN transfer is initiated by the host.
+ * Initializes transfer state variables, resets timers, then submits a
+ * transferReq packet to the device side driver. After successful submission
+ * of a transferReq packet, the transfer request id is incremented by one
+ * for the next transfer. When transfer request id reaches its max value,
+ * it wraps back around to zero (per mausb spec requirements).
+ */
+void host_init_IN_transfer(struct mausb_transfer_state *tx_state,
+		struct mausb_host_ep *ep, struct mausb_urb *maurb)
+{
+	int			status = SUCCESS;
+	u32			tx_size = maurb->urb->transfer_buffer_length;
+	unsigned long		irq_flags;
+	struct mausb_ep_state	*ep_state = &ep->state;
+	struct mausb_pkt	*tx_req = mausb_create_dp(&status, maurb,
+					MAUSB_IN, MAUSB_HOST, GFP_ATOMIC);
+
+	if (!tx_req)
+		return;
+
+	mausb_fill_pkt_ep(tx_req, ep);
+
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+
+	/* fill the transfer request */
+	tx_req->data->common.pkt_type = TransferReq;
+	tx_req->data->remaining_size_credit =
+		maurb->urb->transfer_buffer_length;
+	tx_req->data->req_id = ep_state->request_id;
+	tx_req->data->seq_num = cpu_to_le32(ep_state->seq_number);
+
+	if (mausb_pkt_has_setup_data(tx_req->data)) {
+		tx_req->setup =
+			(struct usb_ctrlrequest *) maurb->urb->setup_packet;
+	}
+
+	tx_req->common->length = mausb_pkt_length(tx_req);
+
+	/* set the transfer state */
+	mausb_host_init_tx_state(tx_state, tx_size);
+
+	/* set the endpoint state */
+	ep->tx_timed_out = false;
+	ep_state->active_request_id = ep_state->request_id;
+	ep_state->keep_alive_timer = MAUSB_TRANSFER_TIMEOUT;
+	ep_state->retry_counter = MAUSB_BULK_TRANSFER_RETRIES;
+	ep_state->request_id = mausb_req_id_add(ep_state->request_id, 1);
+
+	/* send the packet */
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+	host_IN_txReq_transmit(tx_req, ep, tx_state);
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+
+	/* start timeout timer */
+	mod_timer(&ep->timer,
+	jiffies + msecs_to_jiffies(ep_state->keep_alive_timer));
+
+	/* add the packet to the endpoint */
+	list_add_tail(&tx_req->pkt_list, &ep->req_list);
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+}
+
+/**
+* Releases an MA USB packet to the data channel and updates state.
+*/
+void host_IN_txReq_transmit(struct mausb_pkt *tx_req, struct mausb_host_ep *ep,
+		struct mausb_transfer_state *tx_state)
+{
+	int			ret;
+	struct mausb_hcd	*mhcd = mausb_host_ep_to_mahcd(ep);
+
+	mausb_dbg(mhcd, "%s: sending pkt %i for request %i\n", __func__,
+		  le32_to_cpu(tx_req->data->seq_num), tx_req->data->req_id);
+
+	/* submit packet for transport */
+	ret = mausb_transfer_data_pkt(tx_req, ep, GFP_ATOMIC);
+
+	if (tx_state->eot_detected && !tx_state->transfer_error)
+		if (tx_state->last_transfer_sn
+			< le32_to_cpu(tx_req->data->seq_num)) {
+			tx_state->transfer_acked = true;
+		/* TODO:transfer_completion_timer = aMaxTransferLifetime */
+		}
+}
+
+/**
+ * Transmits a TransferAck packet.
+ *
+ * @tx_state: State information associated with this transfer.
+ * @in:	      Set to true for an IN transfer.
+ * @ep_state: State information associated with transfer endpoint.
+ * @status:   Status to fill transferAck packet status field.
+ *	      Note: unless otherwise specified in spec, should be SUCCESS.
+ * @seq_num:  Sequence number to fill transferAck packet sequence number field.
+ *	      Note: should be the greatest sequence number of the packets to
+ *	      be acked.
+ *
+ * Called to acknowledge end of transfer or when a packet that otherwise
+ * requires acknowledgement (i.e. ARQ flag is set) is received.
+ */
+int host_send_ack(struct mausb_transfer_state *tx_state, bool in,
+		struct mausb_ep_state *ep_state, int status, u32 seq_num)
+{
+	struct mausb_urb	*maurb = container_of(tx_state,
+					struct mausb_urb, state);
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_pkt	*tx_ack = mausb_create_dp(NULL, maurb, in,
+					MAUSB_HOST, GFP_ATOMIC);
+	struct mausb_hcd	*mhcd = mausb_host_ep_to_mahcd(ep);
+	unsigned long		irq_flags;
+
+	if (tx_ack == NULL)
+		return -ENOMEM;
+
+	mausb_fill_pkt_ep(tx_ack, ep);
+
+	tx_ack->data->common.pkt_type = TransferAck;
+	tx_ack->data->seq_num = cpu_to_le32(seq_num);
+	tx_ack->data->common.pkt_status = status;
+	tx_ack->data->req_id = ep_state->active_request_id;
+	tx_ack->common->length = cpu_to_le16(mausb_pkt_length(tx_ack));
+
+	mausb_dbg(mhcd, "%s: sending ack for transfer %i\n",
+	       __func__, ep_state->active_request_id);
+
+	if (in && tx_state->eot_detected) {
+		if (mausb_transfer_is_complete(tx_state, seq_num)) {
+			tx_state->transfer_acked = true;
+			/* TODO: set completion timer */
+		}
+
+		/* since we're done, clear out packet lists and free memory */
+		mausb_cleanup_ma_packets(ep, seq_num,
+			 ep_state->earliest_request_id);
+
+	} else if (!in) {
+		tx_state->transfer_acked = true;
+		/* TODO: set transfer completion timer = aMaxTransferLifetime */
+	}
+
+	/* submit packet for transport */
+	mausb_transfer_data_pkt(tx_ack, ep, GFP_ATOMIC);
+
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+	list_add_tail(&tx_ack->pkt_list, &ep->req_list);
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+	return 0;
+}
+
+/**
+ * Deliver payload from transferResp to target urb.
+ *
+ * @tx_resp:	transferResponse packet with data to be transfered.
+ * @maurb:	urb associated with transfer.
+ *
+ * Must ensure that transfer has not been completed (transfer_complete is
+ * false) and there are no transfer errors (transfer_error is false) before
+ * calling.
+ *
+ * Returns length in bytes of data delivered.
+ */
+int host_IN_deliver_payload(struct mausb_pkt *tx_resp, struct mausb_urb *maurb)
+{
+	int			offset;
+	int			length = tx_resp->buffer_length;
+	struct mausb_hcd	*mhcd = mausb_host_ep_to_mahcd(maurb->ep);
+
+	if (length == 0) {
+		mausb_err(mhcd, "%s: no payload (length = 0)\n", __func__);
+		return length;
+	}
+
+	if (!maurb || !maurb->urb || !maurb->urb->transfer_buffer) {
+		mausb_err(mhcd, "%s: urb not found\n", __func__);
+		return -EINVAL;
+	}
+
+	if (!tx_resp || !tx_resp->buffer) {
+		mausb_err(mhcd, "%s: no transferResponse buffer\n", __func__);
+		return -EINVAL;
+	}
+
+	offset = maurb->urb->transfer_buffer_length - maurb->state.rem_size;
+
+	memcpy(maurb->urb->transfer_buffer + offset, tx_resp->buffer, length);
+
+	maurb->urb->actual_length += length;
+
+	return length;
+}
+
+/**
+ * Determines if a received transfer response should be dropped
+ * due to invalid request or sequence number. Note: this fuction does not
+ * actually drop any packets.
+ *
+ * The caller should be holding the endpoints spinlock.
+ *
+ * Returns true if packet should be dropped, otherwise returns false.
+ */
+bool should_drop_txResp(struct mausb_ep_state *ep_state,
+		struct mausb_transfer_state *tx_state,
+		struct mausb_pkt *tx_resp, bool in)
+{
+	bool			drop = false;
+	u8			r = tx_resp->data->req_id;
+	u32			SN = le32_to_cpu(tx_resp->data->seq_num);
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_hcd	*mhcd = mausb_host_ep_to_mahcd(ep);
+
+	/* transfer is complete or error flag is set */
+	if (tx_state->transfer_complete || tx_state->transfer_error) {
+		mausb_err(mhcd, "%s: transfer %i already completed %s error\n",
+			__func__, r,
+			(tx_state->transfer_error ? "with" : "without:"));
+		drop = true;
+	}
+
+	/* request id is invalid */
+	if (mausb_req_id_lt(r, ep_state->earliest_request_id) ||
+		(mausb_req_id_gt_eq(r, ep_state->request_id))) {
+
+		mausb_err(mhcd, "%s: request ID %i is invalid\n", __func__, r);
+
+		host_send_ack(tx_state, MAUSB_IN, ep_state,
+			INVALID_REQUEST, SN);
+		drop = true;
+	}
+
+	/*
+	 * Sequence number is reserved for TRANSFER_PENDING,
+	 * so skip sequence number checks.
+	 */
+	if (TRANSFER_PENDING == tx_resp->common->pkt_status)
+		return drop;
+
+	/* sequence number is larger than expected */
+	if (mausb_seq_num_gt(SN, ep_state->seq_number)) {
+
+		mausb_err(mhcd, "%s: missing sequence number - expected %i but"
+			" received %i\n", __func__, ep_state->seq_number, SN);
+
+		drop = true;
+		host_send_ack(tx_state, MAUSB_IN, ep_state,
+			MISSING_SEQUENCE_NUMBER, ep_state->seq_number);
+	}
+
+	/* sequence number is invalid */
+	if ((!in && mausb_seq_num_lt(SN, ep_state->earliest_unacked)) ||
+		(in && mausb_seq_num_lt(SN, ep_state->seq_number))) {
+
+		mausb_err(mhcd, "%s: invalid sequence number %i for %s"
+			" transfer\n", __func__, SN, (in ? "IN" : "OUT"));
+		drop = true;
+	}
+
+	return drop;
+}
+
+/**
+ * Handles receipt of transferResp.
+ *
+ * @ep_state: State information associated with transfer endpoint.
+ * @tx_state: State information associated with transfer.
+ * @tx_resp:  transferResponse packet being received.
+ *
+ * Called when host receives a transferResp packet from a device during an IN
+ * transfer. Updates host-side transfer and endpoint states and checks for
+ * packet errors.
+ *
+ * Returns length of payload copied into host buffer. If nothing was copied
+ * returns 0 or errno if error.
+ */
+int host_IN_txResp_rcvd(struct mausb_ep_state *ep_state,
+		struct mausb_transfer_state *tx_state,
+		struct mausb_pkt *tx_resp)
+{
+	int			length = 0;
+	u8			r = tx_resp->data->req_id;
+	u8			eps_flags = tx_resp->data->eps_tflags;
+	u32			payload_size = tx_resp->buffer_length;
+	u32			SN = le32_to_cpu(tx_resp->data->seq_num);
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_hcd	*mhcd = mausb_host_ep_to_mahcd(ep);
+
+	/* look for sequence number and request ID errors */
+	if (should_drop_txResp(ep_state, tx_state, tx_resp, MAUSB_IN)) {
+		mausb_drop_packet(ep, tx_resp);
+		return length;
+	}
+
+	switch (tx_resp->data->common.pkt_status) {
+	case DROPPED_PACKET:
+		mausb_dbg(mhcd, "%s: status = DROPPED_PACKET\n", __func__);
+		mausb_drop_packet(ep, tx_resp);
+		break;
+	case INVALID_REQUEST: /* same as MISSING_REQUEST_ID in spec */
+		mausb_dbg(mhcd, "%s: status = INVALID_REQUEST\n", __func__);
+		/*
+		 * TODO: invalidate all outstanding transferReqs with req id
+		 * from r to ep_state->request_id - 1
+		 */
+		ep_state->request_id = r;
+		break;
+	case TRANSFER_PENDING:
+		mausb_dbg(mhcd, "%s: status = TRANSFER_PENDING\n", __func__);
+		ep_state->keep_alive_timer =
+			(tx_state->k * MAUSB_TRANSFER_KEEP_ALIVE);
+		ep_state->retry_counter = ep_state->transfer_retries;
+		if (eps_flags & MAUSB_PKT_TFLAG_ARQ) {
+			/*
+			 * NOTE: per spec, the sequence number in the ack packet
+			 * is reserved and set to 0.
+			 */
+			host_send_ack(tx_state, MAUSB_IN, ep_state,
+				TRANSFER_PENDING, 0);
+		}
+		break;
+	case TRANSFER_EP_STALL:
+		mausb_dbg(mhcd, "%s: status = TRANSFER_EP_STALL\n", __func__);
+		if (eps_flags & MAUSB_PKT_TFLAG_EOT) {
+			host_send_ack(tx_state, MAUSB_IN, ep_state,
+				      TRANSFER_EP_STALL, SN);
+
+			tx_state->eot_detected = true;
+		}
+		break;
+	case SUCCESS:
+		ep_state->keep_alive_timer = MAUSB_TRANSFER_KEEP_ALIVE;
+		ep_state->transfer_retries = MAUSB_BULK_TRANSFER_RETRIES;
+
+		if (SN == ep_state->seq_number) {
+			if (tx_state->rem_size >= payload_size) {
+				length = host_IN_deliver_payload(tx_resp,
+					 container_of(tx_state,
+						struct mausb_urb, state));
+
+				ep_state->seq_number++;
+				tx_state->rem_size -= length;
+
+				if (eps_flags & MAUSB_PKT_TFLAG_ARQ ||
+					eps_flags & MAUSB_PKT_TFLAG_EOT) {
+					host_send_ack(tx_state, MAUSB_IN,
+						ep_state, SUCCESS, SN);
+				}
+
+				if (eps_flags & MAUSB_PKT_TFLAG_EOT) {
+					tx_state->eot_detected = true;
+					tx_state->last_transfer_sn = SN;
+					ep_state->earliest_request_id =
+						mausb_req_id_add(
+						ep_state->earliest_request_id,
+						1);
+					ep_state->active_request_id =
+						mausb_req_id_add(
+						ep_state->active_request_id, 1);
+
+					/*
+					 * Can optionally send ack here.
+					 * If don't send ack, next txReq
+					 * serves as ack.
+					 */
+
+					if (tx_state->rem_size > 0) {
+						tx_state->transfer_error = true;
+						mausb_dbg(mhcd, "%s: end of "
+						"transfer with %i bytes left\n",
+						__func__, tx_state->rem_size);
+					}
+				}
+			} else {
+				/*
+				 * For now just drop packet, but can also
+				 * optionally admit up to rem_size of payload
+				 * into buffer.
+				 */
+				tx_state->transfer_error = true;
+				mausb_drop_packet(ep, tx_resp);
+				host_send_ack(tx_state, MAUSB_IN, ep_state,
+						 TRANSFER_SIZE_ERROR, SN);
+			}
+		}
+		break;
+	default:
+		mausb_dbg(mhcd, "%s: status = %i, dropping packet\n",
+		       __func__, tx_resp->data->common.pkt_status);
+		mausb_drop_packet(ep, tx_resp);
+		break;
+	}
+
+	return length;
+}
+
+
+/*------------------ protocol-managed OUT transfers -----------------*/
+
+/**
+ * @ tx_state: Transfer state to be initialized.
+ * @ ep:       Endpoint associated with transfer.
+ * @ tx_size:  Transfer size in bytes.
+ *
+ * Called every time a new OUT transfer is initiated. Initializes transfer
+ * state variables.
+ */
+void host_init_OUT_transfer(struct mausb_transfer_state *tx_state,
+	struct mausb_host_ep *ep, u32 tx_size)
+{
+	unsigned long irq_flags;
+
+	mausb_host_init_tx_state(tx_state, tx_size);
+
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+
+	ep->tx_timed_out = false;
+
+	ep->state.active_request_id = ep->state.request_id;
+
+	/*
+	 * Increment request id for new transfer (or go back to zero
+	 * if max sequence number is reached.
+	 */
+	ep->state.request_id = mausb_req_id_add(ep->state.request_id, 1);
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+}
+
+/**
+ * Send a transferReq packet to a device.
+ *
+ * @tx_state:     State variables for transfer.
+ * @ep_state:     State variables for endpoint associated with transfer.
+ * @tx_req;	  MA USB transferReq packet to be sent out.
+ */
+int host_OUT_send_txReq(struct mausb_transfer_state *tx_state,
+		struct mausb_ep_state *ep_state, struct mausb_pkt *tx_req)
+{
+	int			i = 0;
+	int			payload_size = tx_req->buffer_length;
+	int			mausb_pkt_head_size;
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_hcd	*mhcd = mausb_host_ep_to_mahcd(ep);
+	unsigned long		irq_flags;
+
+	mausb_pkt_head_size = mausb_pkt_header_length(tx_req->common);
+
+	if (payload_size > ep_state->rx_buf_size) {
+		mausb_dbg(mhcd, "%s: payload of %i bytes is too big - device "
+		       "can only receive %i bytes\n", __func__, payload_size,
+		       ep_state->rx_buf_size);
+		while (payload_size > ep_state->rx_buf_size &&
+		       i <= MAUSB_WAIT_GADGET_BUFFER_FREE_TIMEOUT) {
+			msleep(1);
+			i++;
+		}
+		if (i > MAUSB_WAIT_GADGET_BUFFER_FREE_TIMEOUT) {
+			mausb_dbg(mhcd,
+				"wait gadget receive buffer free time out\n");
+			return -ETIMEDOUT;
+		}
+	}
+
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+
+	if (mausb_seq_num_lt(ep_state->seq_number,
+				ep_state->earliest_unacked)) {
+
+		mausb_err(mhcd, "%s: too many outstanding packets\n",
+		       __func__);
+		/* TODO: transmit packet at later time (flow control) */
+	}
+
+	if (payload_size <= ep_state->rx_buf_size) {
+		/*
+		 * Credit remains less than 1 max_packet_payload,
+		 * and there are more than 1 max_packet_payload data to
+		 * transfer. Ask device to update credit.
+		 */
+		if (ep_state->rx_buf_size - payload_size <
+		    MAUSB_MAX_PACKET_SIZE - mausb_pkt_head_size  &&
+		    tx_state->rem_size > ep_state->rx_buf_size - payload_size) {
+			mausb_dbg(mhcd, "request ARQ, payload_size: %d,"
+				" rx_buf_size: %d\n", payload_size,
+				ep_state->rx_buf_size);
+			tx_req->data->eps_tflags |= MAUSB_PKT_TFLAG_ARQ;
+		}
+		/* look for end of transfer */
+		if (tx_state->rem_size == 0) {
+			tx_req->data->eps_tflags |= MAUSB_PKT_TFLAG_EOT;
+			tx_req->data->eps_tflags |= MAUSB_PKT_TFLAG_ARQ;
+		}
+
+		/* set timer if expecting a response */
+		if (tx_req->data->eps_tflags & MAUSB_PKT_TFLAG_ARQ &&
+		    le32_to_cpu(tx_req->data->seq_num) != 0) {
+			tx_state->ack_transfer_sn =
+				le32_to_cpu(tx_req->data->seq_num);
+			mod_timer(&ep->timer, jiffies +
+				msecs_to_jiffies(MAUSB_TRANSFER_TIMEOUT));
+		}
+
+		spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+		tx_req->common->length = cpu_to_le16(mausb_pkt_length(tx_req));
+
+		mausb_dbg(mhcd, "%s: sending transferRequest with sequence"
+			" number %i for request %i with %i bytes of payload\n",
+			__func__, le32_to_cpu(tx_req->data->seq_num),
+			le32_to_cpu(tx_req->data->req_id),
+			tx_req->buffer_length);
+
+		tx_state->payload_size += payload_size;
+
+		/* submit packet for transport */
+		mausb_transfer_data_pkt(tx_req, ep, GFP_ATOMIC);
+
+		spin_lock_irqsave(&ep->ep_lock, irq_flags);
+
+		ep_state->rx_buf_size -= payload_size;
+	}
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+	return 0;
+}
+
+/**
+ * Determines if this urb is a for a control transfer. For host side only
+ * (device doesn't have urbs).
+ */
+static bool mausb_control_xfer(struct mausb_urb *maurb)
+{
+	return (usb_endpoint_type(&maurb->urb->ep->desc) ==
+		USB_ENDPOINT_XFER_CONTROL && maurb->urb->setup_packet);
+}
+
+/**
+ * Create and send OUT transferRequest packets for a given transfer.
+ *
+ * @tx_state:	State associated with transfer.
+ * @ep_state:	State associated with transfer endpoint.
+ * @maurb:	MA USB urb associated with transfer.
+ */
+int host_OUT_generate_txReqs(struct mausb_transfer_state *tx_state,
+		struct mausb_ep_state *ep_state, struct mausb_urb *maurb)
+{
+	int				offset = 0;
+	int				pkt_length = 0;
+	int				payload_size = 0;
+	int				max_buffer_length = 0;
+	struct				mausb_pkt *tx_req;
+	struct mausb_host_ep		*ep = mausb_state_to_ep(ep_state);
+	struct mausb_hcd		*mhcd = mausb_host_ep_to_mahcd(ep);
+	unsigned long irq_flags;
+
+	/*
+	 * Always generate at least one OUT transferReq (OUT control
+	 * transfers may only contain setup data).
+	 */
+	do {
+		/* create transferReq and set packet field values */
+		tx_req = mausb_create_dp(SUCCESS, maurb, MAUSB_OUT,
+					 MAUSB_HOST, GFP_ATOMIC);
+
+		if (!tx_req)
+			return -ENOMEM;
+
+		mausb_fill_pkt_ep(tx_req, ep);
+		tx_req->data->common.pkt_type = TransferReq;
+		tx_req->data->req_id = ep_state->active_request_id;
+		tx_req->data->seq_num = cpu_to_le32(ep_state->seq_number);
+		tx_req->data->remaining_size_credit =
+			cpu_to_le32(tx_state->rem_size);
+		tx_req->buffer_length = 0;
+		tx_req->nents = 0;
+
+		/* add setup data (If necessary) */
+		if (mausb_pkt_has_setup_data(tx_req->data)) {
+			tx_req->setup = (struct usb_ctrlrequest *)
+						maurb->urb->setup_packet;
+		}
+
+		/* calculate max packet buffer size */
+		pkt_length = mausb_pkt_length(tx_req);
+		max_buffer_length = MAUSB_MAX_PACKET_SIZE - pkt_length;
+		payload_size = min_t(int, max_buffer_length,
+				     tx_state->rem_size);
+
+		/* a control transfer can be empty, but nothing else */
+		if (payload_size <= 0 &&
+				!mausb_pkt_has_setup_data(tx_req->data)) {
+			mausb_err(mhcd, "%s: packet error - no room for "
+			       "payload (buffer size is %i)\n", __func__,
+			       payload_size);
+			return -ENOBUFS;
+		} else if (payload_size > 0) {
+
+			if (!maurb->urb->transfer_buffer) {
+				mausb_err(mhcd, "%s: no transfer buffer\n",
+				__func__);
+			}
+
+			/* create packet buffer and fill */
+			tx_req->buffer = maurb->urb->transfer_buffer + offset;
+			if (!tx_req->buffer) {
+				mausb_free_pkt(tx_req);
+				return -ENOMEM;
+			}
+
+			tx_req->buffer_length = payload_size;
+		}
+
+		/* update state variables */
+		offset += payload_size;
+		tx_state->rem_size -= payload_size;
+		tx_req->data->remaining_size_credit = tx_state->rem_size;
+
+		/* send transferReq packet to device */
+		host_OUT_send_txReq(tx_state, ep_state, tx_req);
+
+		spin_lock_irqsave(&ep->ep_lock, irq_flags);
+		ep_state->seq_number =
+				mausb_seq_num_add(ep_state->seq_number, 1);
+		list_add_tail(&tx_req->pkt_list, &ep->req_list);
+
+		spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+	} while (tx_state->rem_size > 0);
+
+	return 0;
+}
+
+/**
+ * Updates transfer and endpoint states after a transferResp is received.
+ *
+ * @ep_state: State information for enpoint associated with transfer.
+ * @tx_state: State information for transfer in progress.
+ * @tx_resp:  transferResponse packet that has been received.
+ *
+ * Called whenever a transferResp packet is received. Returns size in bytes
+ * of payload transferred.
+ */
+int host_OUT_txResp_rcvd(struct mausb_ep_state *ep_state,
+		struct mausb_transfer_state *tx_state,
+		struct mausb_pkt *tx_resp)
+{
+	int			payload_size = 0;
+	u8			status = tx_resp->common->pkt_status;
+	u8			ep_flags = tx_resp->data->eps_tflags;
+	u32			SN = le32_to_cpu(tx_resp->data->seq_num);
+	u32			credit = le32_to_cpu(
+					tx_resp->data->remaining_size_credit);
+	struct mausb_host_ep	*ep = mausb_state_to_ep(ep_state);
+	struct mausb_urb	*maurb = container_of(tx_state,
+					struct mausb_urb, state);
+	struct mausb_hcd	*mhcd = mausb_host_ep_to_mahcd(ep);
+	unsigned long		irq_flags;
+
+	mausb_dbg(mhcd, "%s: received transferResponse with sequence number %i"
+		" for transfer %i\n", __func__, SN, tx_resp->data->req_id);
+
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+	/* look for sequence number and/or request ID errors */
+	if (should_drop_txResp(ep_state, tx_state, tx_resp, MAUSB_OUT)) {
+		mausb_drop_packet(ep, tx_resp);
+		spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+		return payload_size;
+	}
+
+	switch (status) {
+	case SUCCESS:
+		/*  look for and acknowledge end of transfer */
+		if (ep_flags & MAUSB_PKT_TFLAG_EOT) {
+
+			spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+			host_send_ack(tx_state, MAUSB_OUT, ep_state,
+				 SUCCESS, SN);
+			spin_lock_irqsave(&ep->ep_lock, irq_flags);
+
+			ep_state->earliest_request_id =
+				mausb_req_id_add(
+					ep_state->earliest_request_id, 1);
+			ep_state->active_request_id =
+				mausb_req_id_add(
+					ep_state->active_request_id, 1);
+
+			tx_state->eot_detected = true;
+			tx_state->last_transfer_sn = SN;
+			maurb->urb->actual_length += tx_state->payload_size;
+		}
+
+		ep_state->earliest_unacked = SN + 1;
+		ep_state->rx_buf_size = credit - payload_size;
+		break;
+	case INVALID_REQUEST:
+		mausb_dbg(mhcd, "%s: status = INVALID_REQUEST\n", __func__);
+		/* TODO: start over with request number in packet */
+		break;
+	case DROPPED_PACKET:
+		mausb_dbg(mhcd, "%s: status = DROPPED_PACKET\n", __func__);
+		/* fallthrough, same as MISSING_SEQUENCE_NUMBER */
+	case MISSING_SEQUENCE_NUMBER:
+		mausb_dbg(mhcd, "%s: status = MISSING_SEQUENCE_NUMBER\n",
+		       __func__);
+		mausb_resend_multi_packets(ep, &ep->req_list,
+			le32_to_cpu(tx_resp->data->seq_num), irq_flags);
+		break;
+	case TRANSFER_PENDING:
+		mausb_dbg(mhcd, "%s: status = TRANSFER_PENDING\n", __func__);
+		/* TODO: reset transmission counter */
+		break;
+	case TRANSFER_EP_STALL:
+		mausb_dbg(mhcd, "%s: status = TRANSFER_EP_STALL\n", __func__);
+		if (ep_flags & MAUSB_PKT_TFLAG_EOT) {
+			spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+			host_send_ack(tx_state, MAUSB_OUT, ep_state,
+				      TRANSFER_EP_STALL, SN);
+			spin_lock_irqsave(&ep->ep_lock, irq_flags);
+
+			tx_state->eot_detected = true;
+		}
+		break;
+	case TRANSFER_CANCELLED:
+		mausb_dbg(mhcd, "%s: status = TRANSFER_CANCELLED\n",
+			__func__);
+		break;
+	case TRANSFER_DATA_BUFFER_ERROR:
+		mausb_dbg(mhcd, "%s: status = TRANSFER_DATA_BUFFER_ERROR\n",
+		       __func__);
+		break;
+	default:
+		tx_state->transfer_error = true;
+		mausb_drop_packet(ep, tx_resp);
+		break;
+	}
+
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+	return payload_size;
+}
+
+
+/* --------------------- Transfer interfaces ----------------------*/
+
+/**
+ * Interface called to initiate an IN or OUT transfer.
+ *
+ * @ep:     Host endpoint associated with transfer.
+ * @maurb:  maurb with payload to transfer.
+ *	    NOTE: one maurb maps to one transfer.
+ * @dir_in: Transfer direction. Set to one if IN (to host) or zero if OUT.
+ *
+ * Only one transfer can be in progress at a time for a particular endpoint.
+ * When a transfer is in progress, the tx_pending flag for that endpoint is set
+ * indicating that the endpoint is busy.
+ */
+int start_ma_transfer(struct mausb_host_ep *ep, struct mausb_urb *maurb,
+		int dir_in)
+{
+	int				     tx_size;
+	unsigned long			     irq_flags;
+	char				     *tx_type;
+	struct mausb_hcd		     *mhcd = mausb_host_ep_to_mahcd(ep);
+	const struct usb_endpoint_descriptor *ep_desc;
+
+	ep_desc = mausb_get_ep_des(ep);
+
+	switch (usb_endpoint_type(ep_desc)) {
+	case USB_ENDPOINT_XFER_CONTROL:
+		tx_type = "control";
+		break;
+	case USB_ENDPOINT_XFER_ISOC:
+		tx_type = "isochronous";
+		break;
+	case USB_ENDPOINT_XFER_BULK:
+		tx_type = "bulk";
+		break;
+	case USB_ENDPOINT_XFER_INT:
+		tx_type = "interrupt";
+		break;
+	default:
+		tx_type = "unknown";
+	}
+
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+
+	/* start a new transfer if there isn't one already in progress. */
+	if (ep->state.tx_pending == 0) {
+
+		ep->state.tx_pending = 1;
+		tx_size = maurb->urb->transfer_buffer_length;
+
+		/*
+		 * Set this transfer as active transfer for endpoint - this
+		 * is how we will get active transfer info when we receive
+		 * transferRequests.
+		 */
+		ep->active_transfer = maurb;
+
+		/* check to see if setup phase of control transfer */
+		if (mausb_control_xfer(maurb)) {
+			ep->state.seq_number = 0;
+			ep->state.earliest_unacked = 0;
+		}
+
+		spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+		/* initiate transfer by direction */
+		if (dir_in) {
+			mausb_dbg(mhcd, "%s: starting %s IN transfer for"
+				" endpoint %u\n", __func__, tx_type,
+				ep->ep_handle.ep_num);
+
+			host_init_IN_transfer(&maurb->state, ep, maurb);
+
+		} else {
+			mausb_dbg(mhcd, "%s: starting %s OUT transfer for"
+				" endpoint %u\n", __func__, tx_type,
+				ep->ep_handle.ep_num);
+
+			host_init_OUT_transfer(&maurb->state, ep, tx_size);
+			host_OUT_generate_txReqs(&maurb->state, &ep->state,
+				maurb);
+		}
+		spin_lock_irqsave(&ep->ep_lock, irq_flags);
+	}
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+	return -EINPROGRESS;
+}
+
+/**
+ * Interface called to give a transferResp to the host for IN transfers.
+ *
+ * @pkt:      transferResponse packet being received.
+ * @context:  Host endpoint associated with transfer.
+ *
+ * After an IN transfer is initiated, the host waits to receive transferResponse
+ * packets from the device-side endpoint. When a transferResponse is received,
+ * the host updates its transfer and endpoint states and copies the packet
+ * payload into the maurb buffer associated with the tranfer. If the device
+ * requests a transferAck packet, one is sent.
+ */
+int complete_IN_transferRequest(struct ms_pkt *pkt, void *context)
+{
+	int				urb_stat;
+	int				length = 0;
+	struct mausb_host_ep		*ep;
+	struct mausb_pkt		*tx_resp;
+	struct mausb_urb		*maurb;
+	struct mausb_transfer_state	*tx_state;
+	struct mausb_hcd		*mhcd;
+
+	if ((NULL == context) || (NULL == pkt)) {
+		pr_err("%s: received NULL %s\n", __func__,
+			context ? "packet" : "context");
+		return -EFAULT;
+	}
+
+	ep = (struct mausb_host_ep *) context;
+
+	/* stop timeout timer */
+	del_timer(&ep->timer);
+
+	tx_resp = mausb_pkt_from_ms_pkt_ep(pkt, ep, GFP_ATOMIC);
+	list_add_tail(&tx_resp->pkt_list, &ep->resp_list);
+
+	mhcd = mausb_host_ep_to_mahcd(ep);
+	maurb = ep->active_transfer;
+
+	if (NULL == maurb) {
+		mausb_err(mhcd, "%s: no active transfer for endpoint at %p\n",
+			__func__, ep);
+		return -EINVAL;
+	}
+
+	tx_state = &maurb->state;
+	length = host_IN_txResp_rcvd(&ep->state, tx_state, tx_resp);
+
+	/* something went wrong in receiving the transferResp packet */
+	if (length < 0) {
+		mausb_err(mhcd, "%s: returning error %i\n", __func__, length);
+		return length;
+	}
+
+	/* look for end of transfer */
+	if (tx_state->eot_detected) {
+		ep->state.tx_pending = 0;
+
+		urb_stat = mausb_to_urb_status(tx_resp->data->common.pkt_status);
+		if (NULL != maurb)
+			mausb_unlink_giveback_urb(maurb, urb_stat);
+	}
+
+	/* if not end of transfer, set timer between packets */
+	else {
+		mod_timer(&ep->timer,
+			jiffies + msecs_to_jiffies(MAUSB_TRANSFER_KEEP_ALIVE));
+	}
+
+	return length;
+}
+
+/**
+ * Interface called to give the host a transferResp packet.
+ *
+ * @pkt:     transferResponse packet being received.
+ * @context: Host endpoint associated with transfer.
+ *
+ * For OUT transfers the host sends a series of transferRequest packets. A
+ * transferResponse packet is only sent by the device when a transferAck packet
+ * is requested by the host or the end of the transfer is reached.
+ */
+int complete_OUT_transferRequest(struct ms_pkt *pkt, void *context)
+{
+	int				urb_stat;
+	int				ret = 0;
+	struct mausb_host_ep		*ep;
+	struct mausb_pkt		*tx_resp;
+	struct mausb_urb		*maurb;
+	struct mausb_transfer_state	*tx_state;
+	struct mausb_hcd		*mhcd;
+
+	if ((NULL == context) || (NULL == pkt)) {
+		pr_err("%s: received NULL %s\n", __func__,
+			context ? "packet" : "context");
+		return -EFAULT;
+	}
+
+	ep = (struct mausb_host_ep *) context;
+
+	/* stop timeout timer */
+	del_timer(&ep->timer);
+
+	tx_resp = mausb_pkt_from_ms_pkt_ep(pkt, ep, GFP_ATOMIC);
+	list_add_tail(&tx_resp->pkt_list, &ep->resp_list);
+
+	mhcd = mausb_host_ep_to_mahcd(ep);
+	maurb = ep->active_transfer;
+
+	if (NULL == maurb) {
+		mausb_err(mhcd, "%s: no active transfer for endpoint at %p\n",
+			__func__, ep);
+		return -EFAULT;
+	}
+
+	tx_state = &maurb->state;
+
+	/*
+	 * Look for Retry flag in packet and resend requested packets
+	 * if we have them. Otherwise, pass packet on to receiving process.
+	 */
+	if (mausb_is_a_retry(ep, &ep->req_list, tx_resp) == false)
+		ret = host_OUT_txResp_rcvd(&ep->state, tx_state, tx_resp);
+
+	/* make sure we still have an active transfer */
+	if (!ep->active_transfer) {
+		mausb_cleanup_ma_packets(ep,
+			le32_to_cpu(tx_resp->data->seq_num),
+			tx_resp->data->req_id);
+		mausb_unlink_giveback_urb(maurb, -EINVAL);
+		return ret;
+	}
+
+	/* handle end of transfer */
+	if (tx_state->eot_detected) {
+		ep->state.tx_pending = 0;
+		mausb_cleanup_ma_packets(ep,
+			le32_to_cpu(tx_resp->data->seq_num),
+			tx_resp->data->req_id);
+		urb_stat = mausb_to_urb_status(
+			tx_resp->data->common.pkt_status);
+		mausb_unlink_giveback_urb(maurb, urb_stat);
+	}
+
+	return ret;
+}
+
+/*
+ * Receives transferRequest packets for control endpoint (ep0).
+ *
+ * @pkt:     transferResponse packet being received.
+ * @context: Host endpoint associated with transfer. This should always be
+ *	     control endpoint (ep0).
+ *
+ * Control transfers can be either IN or OUT. Transfer direction is parsed
+ * from the urb associated with the transfer, then the appropriate completion
+ * function is called.
+ */
+int complete_control_transferRequest(struct ms_pkt *pkt, void *context)
+{
+	int			dir_in = 0;
+	struct mausb_host_ep	*ep;
+	struct mausb_hcd	*mhcd;
+
+	if ((NULL == context) || (NULL == pkt)) {
+		pr_err("%s: received NULL %s\n", __func__,
+			context ? "packet" : "context");
+		return -EFAULT;
+	}
+
+	ep = (struct mausb_host_ep *) context;
+	mhcd = mausb_host_ep_to_mahcd(ep);
+
+	if (NULL == mhcd) {
+		pr_err("%s: could not find MA USB HCD for endpoint"
+			" at 0x%p\n", __func__, ep);
+		return -EFAULT;
+	}
+
+	if (NULL == ep->active_transfer || NULL == ep->active_transfer->urb) {
+		mausb_err(mhcd, "%s: no active transfer for endpoint at %p\n",
+			__func__, ep);
+		return -EFAULT;
+	}
+
+	/* stop timeout timer */
+	del_timer(&ep->timer);
+
+	dir_in = usb_pipein(ep->active_transfer->urb->pipe);
+
+	if (dir_in)
+		complete_IN_transferRequest(pkt, context);
+	else
+		complete_OUT_transferRequest(pkt, context);
+
+	return 0;
+}
+
diff --git a/drivers/staging/mausb/drivers/mausb_tx.c b/drivers/staging/mausb/drivers/mausb_tx.c
new file mode 100644
index 0000000..02327a1
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_tx.c
@@ -0,0 +1,316 @@
+/* Name:        mausb_tx.c
+ * Description: Common functions for both host and device media agnostic
+ *              transfers.
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
+   * Redistributions of source code must retain the above copyright
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
+#include "mausb_pkt.h"
+#include "mausb_tx.h"
+#include "mausb_const.h"
+
+int mausb_transfer_data_pkt(struct mausb_pkt *pkt, struct mausb_host_ep *ep,
+		gfp_t mem_flags)
+{
+	int ret;
+
+	ret = mausb_pkt_fill_ms_pkt(pkt, mem_flags);
+	if (0 > ret)
+		return ret;
+
+	return mausb_transfer_packet(&pkt->pkt, &ep->tx_pair.to_ms);
+
+}
+EXPORT_SYMBOL(mausb_transfer_data_pkt);
+
+/**
+ * Opens an endpoint-specific connection between the media specific and media
+ * agnostic drivers in order to send and receive MA USB data packets.
+ *
+ * @drv:	  Media specific driver to establish connection with.
+ * @ep:  	  Host endpoint to be associated with this channel.
+ * @transfer_pkt: The call the MS driver should make when a packet is received.
+ */
+int mausb_add_data_channel(struct mausb_ms_drv *drv, struct mausb_host_ep *ep,
+		int (*transfer_pkt)(struct ms_pkt *pkt, void *context))
+{
+	int				ret = 0;
+	struct mausb_transfer_pair	tx_pair;
+
+	matx_dbg("%s: adding channel for ep with handle %x\n", __func__,
+		ep->ep_handle.handle);
+
+	tx_pair.to_ma.transfer_packet = transfer_pkt;
+	tx_pair.to_ma.context = ep;
+	tx_pair.pkt_sent = NULL;
+	tx_pair.handle = ep->ep_handle.handle;
+
+	ret = drv->ops->add_transfer_pair(&tx_pair);
+
+	if (ret >= 0)
+		ep->tx_pair = tx_pair;
+
+	return ret;
+}
+EXPORT_SYMBOL(mausb_add_data_channel);
+
+/**
+ * Determines if conditions are met to complete a data transfer.
+ *
+ * @tx_state: State of transfer to be checked.
+ * @seq_num:  Sequence number to be compared to last sequence number in the
+ *	      transfer.
+ *
+ * Returns true if a transfer can be considered complete or false otherwise.
+ * Note that this does not differentiate between transfers that complete
+ * with and without an error.
+ */
+bool mausb_transfer_is_complete(struct mausb_transfer_state *tx_state,
+		u8 seq_num)
+{
+	bool complete = false;
+
+	if (!tx_state->transfer_error && tx_state->last_transfer_sn <= seq_num)
+		complete = true;
+
+	if (tx_state->transfer_error) {
+		matx_err("%s: transfer ending with error\n", __func__);
+		complete = true;
+	}
+
+	return complete;
+}
+EXPORT_SYMBOL(mausb_transfer_is_complete);
+
+/**
+ * Deletes packet from endpoint list and frees memory.
+ *
+ * @ep:	 Endpoint associated with packet to be dropped.
+ * @pkt: Packet to be dropped.
+ */
+void mausb_drop_packet(struct mausb_host_ep *ep, struct mausb_pkt *pkt)
+{
+	if (ep == NULL || pkt == NULL)
+		return;
+
+	list_del(&pkt->pkt_list);
+	mausb_free_pkt(pkt);
+
+	if (list_empty(&ep->req_list))
+		INIT_LIST_HEAD(&ep->req_list);
+
+	if (list_empty(&ep->resp_list))
+		INIT_LIST_HEAD(&ep->resp_list);
+}
+EXPORT_SYMBOL(mausb_drop_packet);
+
+/**
+ * Deletes all of the packets based on the sequence number.
+ *
+ * @ep:      Endpoint associated with transfer.
+ * @seq_num: The sequence number of the packets to delete. This will
+ *           delete all the packets with sequence numbers up to
+ *           (but not including) seq_num.
+ * @req_id:  The request ID of the packets to delete. This will
+ *           delete all the packets with request IDs up to
+ *           (but not including) req_id.
+ */
+void mausb_cleanup_ma_packets(struct mausb_host_ep *ep, u32 seq_num, u8 req_id)
+{
+	struct mausb_pkt *active, *next;
+
+	list_for_each_entry_safe(active, next, &ep->req_list, pkt_list) {
+		if (mausb_seq_num_lt(active->data->seq_num, seq_num) ||
+			mausb_req_id_lt(active->data->req_id, req_id))
+			mausb_drop_packet(ep, active);
+	}
+
+	list_for_each_entry_safe(active, next, &ep->resp_list, pkt_list) {
+		if (mausb_seq_num_lt(active->data->seq_num, seq_num) ||
+			mausb_req_id_lt(active->data->req_id, req_id))
+
+			mausb_drop_packet(ep, active);
+	}
+}
+EXPORT_SYMBOL(mausb_cleanup_ma_packets);
+
+/**
+ * Resend all packets starting from a given sequence number.
+ *
+ * @ep:		Endpoint associated with packets.
+ * @pkt_list: 	Head of list of packets to search.
+ * @seq_num: 	Sequence number of first packet to be sent.
+ *
+ * Returns 0 if at least one packet is sent, otherwise returns non-zero value.
+ * Note: the caller should be holding the endpoint's spinlock.
+ */
+int mausb_resend_multi_packets(struct mausb_host_ep *ep,
+		struct list_head *pkt_list,
+		u32 seq_num, unsigned long irq_flags)
+{
+	int			ret = -EINVAL;
+	struct mausb_pkt	*pkt;
+	int			i = 0;
+
+	list_for_each_entry(pkt, pkt_list, pkt_list) {
+
+		i++;
+		if (mausb_seq_num_gt_eq(pkt->data->seq_num, seq_num)) {
+			matx_dbg("%s: resending pkt %i\n", __func__,
+				pkt->data->seq_num);
+			pkt->common->ver_flags |= MAUSB_PKT_FLAG_RETRY;
+			ret = 0;
+			mausb_transfer_data_pkt(pkt, ep, GFP_ATOMIC);
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(mausb_resend_multi_packets);
+
+/**
+ * Checks to see if a received packet is a retry and resends response packets
+ * (if found).
+ *
+ * @ep:		Endpoint associated with transfer.
+ * @pkt_list:	List of packets previously sent.
+ * @pkt:	Received packet.
+ *
+ * Returns true if received packet has the Retry flag set AND at least one
+ * response packet was found and sent. Returns false if the Retry flag not
+ * set or the Retry flag is set but no corresponding packets have been found.
+ */
+bool mausb_is_a_retry(struct mausb_host_ep *ep, struct list_head *pkt_list,
+		struct mausb_pkt *pkt)
+{
+	int			err	= 0;
+	unsigned long		irq_flags;
+
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+	if (pkt->common->ver_flags & MAUSB_PKT_FLAG_RETRY) {
+		matx_dbg("%s: packet is a retry\n", __func__);
+
+		/*
+		 * If received packet is a retry, look to see if we've
+		 * already generated the corresponding packets.
+		 */
+		err = mausb_resend_multi_packets(ep, pkt_list,
+			pkt->data->seq_num,
+				irq_flags);
+
+		/*
+		 * Only return true if packet is found, otherwise we might
+		 * miss responding to a packet we never received.
+		 */
+		if (err == 0)
+			return true;
+	}
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+	return false;
+}
+EXPORT_SYMBOL(mausb_is_a_retry);
+
+/**
+ * Called by timeout timer to start thread that handles error handling and
+ * packet resends.
+ *
+ * Used to avoid passing packets to a medium while in an interrupt context,
+ * which can be problematic for some mediums.
+ */
+void wake_timeout_thread(unsigned long _ep)
+{
+	struct mausb_host_ep	*ep = (struct mausb_host_ep *) _ep;
+	unsigned long		irq_flags;
+
+	matx_dbg("%s: timeout occurred!!!\n", __func__);
+
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+	ep->tx_timed_out = true;
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+	wake_up_interruptible(&ep->host_ep_wq);
+}
+
+/**
+ * Fills packet fields based on the given EP. Also fills device fields.
+ */
+void mausb_fill_pkt_ep(struct mausb_pkt *pkt, struct mausb_host_ep *ma_ep)
+{
+	struct mausb_dev	*mausb_dev;
+	struct ma_dev		*ma_dev;
+	unsigned long		irq_flags;
+
+	spin_lock_irqsave(&ma_ep->ep_lock, irq_flags);
+
+	if (MAUSB_EP_HANDLE_ACTIVE != ma_ep->ep_handle_state) {
+		matx_warn("%s: endpoint handle not active\n", __func__);
+	}
+
+	pkt->common->ep_handle = ma_ep->ep_handle;
+	pkt->data->eps_tflags |= ma_ep->ep_handle_state;
+	/* TODO: set transfer Type */
+
+	mausb_dev = ma_ep->mausb_dev;
+	spin_unlock_irqrestore(&ma_ep->ep_lock, irq_flags);
+
+
+	spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
+	ma_dev = mausb_dev->ma_dev;
+	spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
+
+
+	spin_lock_irqsave(&ma_dev->ma_dev_lock, irq_flags);
+	pkt->common->ma_dev_addr = ma_dev->ma_dev_addr;
+	pkt->common->mass_id = ma_dev->mass_id;
+	spin_unlock_irqrestore(&ma_dev->ma_dev_lock, irq_flags);
+}
+EXPORT_SYMBOL(mausb_fill_pkt_ep);
diff --git a/drivers/staging/mausb/drivers/mausb_tx.h b/drivers/staging/mausb/drivers/mausb_tx.h
new file mode 100644
index 0000000..c68ac09
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_tx.h
@@ -0,0 +1,127 @@
+/* Name:        mausb_tx.h
+ * Description:	header file for mausb_tx-device.c and mausb_tx-host.c
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
+   * Redistributions of source code must retain the above copyright
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
+#ifndef __MAUSB_TX_H
+#define __MAUSB_TX_H
+
+#include "mausb_mem.h"
+#include "mausb_pkt.h"
+
+#ifdef DEBUG
+#define matx_dbg(format, arg...) \
+	printk(KERN_DEBUG format, ##arg)
+#else
+#define matx_dbg(format, arg...)
+#endif
+
+#define matx_warn(format, arg...) \
+	printk(KERN_WARNING format, ##arg)
+
+#define matx_err(format, arg...) \
+	printk(KERN_ERR format, ##arg)
+
+/* TODO: for now this is set to match gadget zero's buffer size, but
+ * eventually we need to get this value from the device instead of
+ * predefining it. */
+# define DEVICE_RX_BUF_SIZE 4096
+
+#define MAUSB_WAIT_GADGET_BUFFER_FREE_TIMEOUT 3000
+
+/* functions common to both host and device */
+int mausb_add_data_channel(struct mausb_ms_drv *drv, struct mausb_host_ep *ep,
+		int (*transfer_pkt)(struct ms_pkt *pkt, void *context));
+
+int mausb_transfer_data_pkt(struct mausb_pkt *pkt, struct mausb_host_ep *ep,
+		gfp_t mem_flags);
+bool mausb_transfer_is_complete(struct mausb_transfer_state *tx_state,
+		u8 seq_num);
+void mausb_drop_packet(struct mausb_host_ep *ep, struct mausb_pkt *pkt);
+void mausb_cleanup_ma_packets(struct mausb_host_ep *ep, u32 seq_num,
+		u8 req_id);
+bool mausb_is_a_retry(struct mausb_host_ep *ep, struct list_head *pkt_list,
+		struct mausb_pkt *pkt);
+int mausb_resend_multi_packets(struct mausb_host_ep *ep,
+		struct list_head *pkt_list, u32 seq_num,
+		unsigned long irq_flags);
+void mausb_fill_pkt_ep(struct mausb_pkt *pkt, struct mausb_host_ep *ma_ep);
+
+/* transfer interface function declarations */
+int complete_control_transferRequest(struct ms_pkt *pkt, void *context);
+int complete_IN_transferRequest(struct ms_pkt *pkt, void *context);
+int complete_OUT_transferRequest(struct ms_pkt *pkt, void *context);
+int receive_ma_packet_control(struct ms_pkt *ms_pkt, void *context);
+int receive_ma_packet_IN(struct ms_pkt *ms_pkt, void *context);
+int receive_ma_packet_OUT(struct ms_pkt *ms_pkt, void *context);
+int start_ma_transfer(struct mausb_host_ep *ep, struct mausb_urb *maurb,
+		int dir_in);
+
+/* transfer state fucntion declarations */
+int device_OUT_deliver_payload(struct mausb_pkt *tx_req,
+		struct mausb_ep_state *ep_state,
+		struct mausb_transfer_state *tx_state);
+int device_OUT_send_txResp(struct mausb_transfer_state *tx_state,
+		struct mausb_ep_state *ep_state, u32 req_id,
+		u32 seq_num, int status, bool retry, bool eot, bool arq);
+void host_IN_txReq_transmit(struct mausb_pkt *tx_req, struct mausb_host_ep *ep,
+		struct mausb_transfer_state *tx_state);
+int device_IN_send_null_txResp(struct mausb_host_ep *ep, u8 req_id, int status);
+
+/* transfer timeout function declarations */
+void wake_timeout_thread(unsigned long _ep);
+int host_transfer_timeout(void *data);
+int device_transfer_timeout(void *data);
+
+#endif
-- 
1.9.1

