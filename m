Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaI3AgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:36:04 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10953 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755130AbaI3AfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:35:08 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC 5/7] soc: qcom: Add Shared Memory Driver
Date: Mon, 29 Sep 2014 17:34:49 -0700
Message-ID: <1412037291-16880-6-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the Qualcomm Shared Memory Driver (SMD) providing
communication channels to remote processors, ontop of SMEM.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

As we've already seen this is fuel for discussions, so I hope to start these
off by giving some insight in my research here.

== Codeaurora implementation ==
The codeaurora implementation originates from an implementation that was based
purely on initcall and global state. Clients are platform_drivers, they request
channels, has an "event callback" to indicate when to do things and handles the
fifo logic in the client. That means that every client driver duplicates this
logic - in comparison to e.g. rpmsg where this is completely abstracted away.

My proposal is following the rpmsg way of providing all these things, in an
attempt to reduce the code duplication and create a cleaner abstraction between
the two pieces. The side effect of this is that smd devices will follow the
life cycle of the corresponding smd channel, i.e. devices will be removed when
the other side goes away.

In the msm-3.10 branch there are 19 calls to smd_open_named_on_edge() but only
one of these cases have multiple channels per "smd client". So I've followed
rpmsg and optimized the implementation for the 1:1 channel vs device setup. The
idea is to follow rpmsg and provide an actual "open" api, that will attach
further channels to an already existing device.

== RPMSG ==

The rpmsg_driver fits nicely into what I want to do, so that could be used
straight off. Data is transmitted by calling rpmsg_send() and incoming data is
delivered through the registered callback on a channel.  It's possible to
request additional channels for a rpmsg device, although this is probably never
tested as there is no way to send data on this additional endpoint.

Endpoints are sort of equivalent of a smd channel although the life cycle is
slightly different, but a major issue with the rpmsg interface is that channels
are identified by a single u32, while SMD channels are identified by a u32 and
the channel name.

So to be able to use the rpmsg api we would need to create additional apis that
handles the custom address format of the smd channels. Furthermore all the "off
channel" functions would be invalid.
Furthermore most of the channel and endpoint structures would be "invalid".


But these are the problems with the actual api, rpmsg is not only the api. It's
a direct implementation of these functions, defining how services are
discovered, how channels are represented as well as the actual "wire" protocol.

Or to put it in another way: rpmsg is an implementation of a packet protocol
on-top of virtio, it is not a framework or api for abstracting packet transport
logic.

As there are discussions regarding replacing SMD with a new wire protocol, it
would probably be convenient to create a generic version of my proposed "api"
that can be re-used between different implementations and hopefully provide
re-use of parts of the code. Maybe we can make rpmsg an implementation under
such a generic api.

== Mailbox "framework" ==
The recently proposed mailbox "framework" have already come up numerous times
in discussing this.

The proposed mailbox framework consists of a notion of a mailbox client and a
mailbox controller. The controller exposes a predefined number of allways
available channels and there is a set of apis and callbacks related to how to
interact between the two sides.

A client, e.g. a platform_driver, requests a handle to a channel and use this
for communication. In SMD channels have life cycles, so for this to work I
would need to implement some sort of life cycle management around this. 

SMD can operate in packet or streaming mode, in both cases we have dynamically
sized data chunks. The mailbox api presents the mbox_send_message() function,
where the data chunk is defined by a "void *mssg" - i.e. a pointer to some data
of size magically known by both sides of the api.

The rx_callback in mbox_client would be used for handing data to the SMD client
similarly to below. I think the rest of tx_done, mbox_client_txdone and
mbox_client_peek_data are implementing the rest of my receive loop. But at the
cost of spreading this code in all clients.

So, if the mailbox framework had the life cycle management of channels,
supported variable size data and I move half the implementation of the message
pump to the clients (spread out over 4-5 callbacks/function calls), then we
should be able to use the framework.

The benefit would be to say that we're using the framework, the drawback would
be that the api between the smd implementation and it's clients would be much
more complicated.

We would not save a single line of code and we would not be able to reuse any
existing controller as the api does not abstract much of this.

== Firmware loader and crashes ==
I believe we can generalize remoteproc (align it with the documentation) and
get the Qualcomm peripheral image loader in there. There are several ways in
the Qualcomm system to get notified that a remote processor has crashed and we
can tie those into methods of e.g. dumping the ram associated with the remote
processor. But when this is done the remoteproc must trigger a reset on all
channels associated with the remote processor, as these will in most cases
remain "open".
In codeaurora this is done by an explicit call resetting all channels when this
happen, the question for our mainline version is how to tie the two components
together to trigger this action. (remoteproc would be notified by an raising
gpio/irq)

== Error handling ==
In the codeaurora version of this driver faulty state of a channel info is
cause for a BUG() and incoming packets that are greater than the ring buffer
causes triggers a restart of that remote processor (and then a BUG if that
fails). It might in some cases be enough to just close the faulty channel and
hope for the other side to clean up the state and restart, or we need to
trigger remoteproc to restart the remote processor, but part of RPM failing
these things should not be considered fatal for the Linux processor.

 drivers/soc/qcom/Kconfig          |    8 +
 drivers/soc/qcom/Makefile         |    1 +
 drivers/soc/qcom/qcom_smd.c       | 1043 +++++++++++++++++++++++++++++++++++++
 include/linux/soc/qcom/qcom_smd.h |   47 ++
 4 files changed, 1099 insertions(+)
 create mode 100644 drivers/soc/qcom/qcom_smd.c
 create mode 100644 include/linux/soc/qcom/qcom_smd.h

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 9e6bc56..9ac1541 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -9,6 +9,14 @@ config QCOM_GSBI
           functions for connecting the underlying serial UART, SPI, and I2C
           devices to the output pins.
 
+config QCOM_SMD
+	tristate "Qualcomm Shared Memory Driver"
+	depends on QCOM_SMEM
+	help
+	  Say y here to enable support for the Qualcomm Shared Memory Driver
+	  providing communication channels to remote processors in Qualcomm
+	  platforms.
+
 config QCOM_SMEM
 	tristate "Qualcomm Shared Memory Interface"
 	depends on ARCH_QCOM
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index b1f7b18..0e89532 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_QCOM_GSBI)	+=	qcom_gsbi.o
+obj-$(CONFIG_QCOM_SMD) +=	qcom_smd.o
 obj-$(CONFIG_QCOM_SMEM) +=	qcom_smem.o
diff --git a/drivers/soc/qcom/qcom_smd.c b/drivers/soc/qcom/qcom_smd.c
new file mode 100644
index 0000000..0175293
--- /dev/null
+++ b/drivers/soc/qcom/qcom_smd.c
@@ -0,0 +1,1043 @@
+/*
+ * Copyright (c) 2014, Sony Mobile Communications AB.
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of_platform.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/memblock.h>
+#include <linux/slab.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/hwspinlock.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/delay.h>
+#include <linux/soc/qcom/qcom_smd.h>
+#include <linux/soc/qcom/qcom_smem.h>
+
+/*
+ * The Qualcomm Shared Memory communication solution provides point-to-point
+ * channels for clients to send and receive streaming or packet based data.
+ *
+ * Each channel consists of a control item (channel info) and a ring buffer
+ * pair. The channel info carry information related to channel state, flow
+ * control and the offsets within the ring buffer.
+ *
+ * All allocated channels are listed in an allocation table, identifying the
+ * pair of items by name, type and remote processor.
+ *
+ * Upon creating a new channel the remote processor allocates channel info and
+ * ring buffer items from the smem heap and populate the allocation table. An
+ * interrupt is sent to the other end of the channel and a scan for new
+ * channels should be done. A channel never goes away, it will only change
+ * state.
+ *
+ * The remote processor signals it intent for bring up the communication
+ * channel by setting the state of its end of the channel to "opening" and
+ * sends out an interrupt. We detect this change and register a smd device to
+ * consume the channel. Upon finding a consumer we finish the handshake and the
+ * channel is up.
+ *
+ * Upon closing a channel, the remote processor will update the state of its
+ * end of the channel and signal us, we will then unregister any attached
+ * device and close our end of the channel.
+ *
+ * Devices attached to a channel can use the qcom_smd_send function to push
+ * data to the channel, this is done by copying the data into the tx ring
+ * buffer, updating the pointers in the channel info and signaling the remote
+ * processor.
+ *
+ * The remote processor does the equivalent when it transfer data and upon
+ * receiving the interrupt we check the channel info for new data and delivers
+ * this to the attached device. If the device is not ready to receive the data
+ * we leave it in the ring buffer for now.
+ */
+
+#define SMEM_CHANNEL_ALLOC_TBL	13
+#define SMEM_SMD_INFO_BASE_ID	14
+#define SMEM_SMD_FIFO_BASE_ID	338
+
+#define SMD_CHANNEL_NAME_LEN	20
+#define SMD_NUM_CHANNELS        64
+
+struct smd_channel_info;
+struct smd_channel_info_word;
+
+/**
+ * struct qcom_smd_edge - representing a remote processor
+ * @smd:		handle to qcom_smd
+ * @of_node:		of_node handle for information related to this edge
+ * @edge_id:		identifier of this edge
+ * @ipc_regmap:		regmap handle holding the outgoing ipc register
+ * @ipc_offset:		offset within @ipc_regmap of the register for ipc
+ * @ipc_bit:		bit in the register at @ipc_offset of @ipc_regmap
+ * @channels:		list of all channels detected on this edge
+ * @smem_available:	last available amount of smem triggering a channel scan
+ * @channel_scan_work:	work item for channel scanning
+ * @state_change_work:	work item for state changes
+ */
+struct qcom_smd_edge {
+	struct qcom_smd *smd;
+	struct device_node *of_node;
+	unsigned edge_id;
+
+	struct regmap *ipc_regmap;
+	int ipc_offset;
+	int ipc_bit;
+
+	struct list_head channels;
+
+	unsigned smem_available;
+	struct work_struct channel_scan_work;
+	struct work_struct state_change_work;
+};
+
+/**
+ * struct qcom_smd_channel - smd channel struct
+ * @smd:	handle to qcom_smd
+ * @edge:	qcom_smd_edge this channel is living on
+ * @qsdev:	reference to a associated smd device
+ * @name:	name of the channel
+ * @state:	local state of the channel
+ * @remote_state:	remote state of the channel
+ * @tx_info:	byte aligned outgoing channel info
+ * @rx_info:	byte aligned incoming channel info
+ * @tx_info_word:	word aligned outgoing channel info
+ * @rx_info_word:	word aligned incoming channel info
+ * @tx_lock:	lock to make writes to the channel mutually exclusive
+ * @tx_fifo:	pointer to the outgoing ring buffer
+ * @rx_fifo:	pointer to the incoming ring buffer
+ * @fifo_size:	size of the ring buffers
+ * @bounce_buffer: bounce buffer for reading wrapped packets
+ * @cb:		callback function registered for this channel
+ * @cb_lock:	guard for modifying @cb while handling incoming data
+ * @pkt_size:	size of the currently handled packet
+ * @list:	lite entry for @channels in qcom_smd_edge
+ */
+struct qcom_smd_channel {
+	struct qcom_smd *smd;
+	struct qcom_smd_edge *edge;
+
+	struct qcom_smd_device *qsdev;
+
+	char *name;
+	unsigned state;
+	unsigned remote_state;
+
+	struct smd_channel_info *tx_info;
+	struct smd_channel_info *rx_info;
+
+	struct smd_channel_info_word *tx_info_word;
+	struct smd_channel_info_word *rx_info_word;
+
+	struct mutex tx_lock;
+
+	void *tx_fifo;
+	void *rx_fifo;
+	int fifo_size;
+
+	void *bounce_buffer;
+	int (*cb)(struct qcom_smd_device *, void *, size_t);
+	spinlock_t cb_lock;
+
+	int pkt_size;
+
+	struct list_head list;
+};
+
+/**
+ * struct qcom_smd - smd struct
+ * @dev:	device struct
+ * @smem:	reference to smem handler
+ * @allocated:	bitmap representing already allocated channels
+ * @num_edges:	number of entries in @edges
+ * @edges:	array of edges to be handled
+ */
+struct qcom_smd {
+	struct device *dev;
+
+	struct qcom_smem *smem;
+
+	DECLARE_BITMAP(allocated, SMD_NUM_CHANNELS);
+
+	unsigned num_edges;
+	struct qcom_smd_edge edges[0];
+};
+
+struct smd_channel_info {
+	u32 state;
+	u8  fDSR;
+	u8  fCTS;
+	u8  fCD;
+	u8  fRI;
+	u8  fHEAD;
+	u8  fTAIL;
+	u8  fSTATE;
+	u8  fBLOCKREADINTR;
+	u32 tail;
+	u32 head;
+};
+
+struct smd_channel_info_word {
+	u32 state;
+	u32 fDSR;
+	u32 fCTS;
+	u32 fCD;
+	u32 fRI;
+	u32 fHEAD;
+	u32 fTAIL;
+	u32 fSTATE;
+	u32 fBLOCKREADINTR;
+	u32 tail;
+	u32 head;
+};
+
+enum {
+	SMD_CHANNEL_CLOSED,
+	SMD_CHANNEL_OPENING,
+	SMD_CHANNEL_OPENED,
+	SMD_CHANNEL_FLUSHING,
+	SMD_CHANNEL_CLOSING,
+	SMD_CHANNEL_RESET,
+	SMD_CHANNEL_RESET_OPENING
+};
+
+#define GET_RX_CHANNEL_INFO(channel, param) \
+	(channel->rx_info_word ? \
+		channel->rx_info_word->param : \
+		channel->rx_info->param)
+
+#define GET_TX_CHANNEL_INFO(channel, param) \
+	(channel->rx_info_word ? \
+		channel->tx_info_word->param : \
+		channel->tx_info->param)
+
+#define SET_RX_CHANNEL_INFO(channel, param, value) \
+	(channel->rx_info_word ? \
+		(channel->rx_info_word->param = value) : \
+		(channel->rx_info->param = value))
+
+#define SET_TX_CHANNEL_INFO(channel, param, value) \
+	(channel->rx_info_word ? \
+		(channel->tx_info_word->param = value) : \
+		(channel->tx_info->param = value))
+
+/**
+ * struct qcom_smd_alloc_entry - channel allocation entry
+ * @name:	channel name
+ * @cid:	channel index
+ * @flags:	channel flags and type
+ * @ref_count:	reference count of the channel
+ */
+struct qcom_smd_alloc_entry {
+	u8 name[SMD_CHANNEL_NAME_LEN];
+	u32 cid;
+	u32 flags;
+	u32 ref_count;
+} __packed;
+
+#define SMD_CHANNEL_FLAGS_EDGE		0xff
+#define SMD_CHANNEL_FLAGS_STREAM	BIT(8)
+#define SMD_CHANNEL_FLAGS_PACKET	BIT(9)
+
+static void qcom_smd_signal_channel(struct qcom_smd_channel *channel)
+{
+	struct qcom_smd_edge *edge = channel->edge;
+
+	regmap_write(edge->ipc_regmap, edge->ipc_offset, BIT(edge->ipc_bit));
+}
+
+/*
+ * Initialize the tx channel info
+ */
+static void qcom_smd_channel_reset(struct qcom_smd_channel *channel)
+{
+	SET_TX_CHANNEL_INFO(channel, state, SMD_CHANNEL_CLOSED);
+	SET_TX_CHANNEL_INFO(channel, fDSR, 0);
+	SET_TX_CHANNEL_INFO(channel, fCTS, 0);
+	SET_TX_CHANNEL_INFO(channel, fCD, 0);
+	SET_TX_CHANNEL_INFO(channel, fRI, 0);
+	SET_TX_CHANNEL_INFO(channel, fHEAD, 0);
+	SET_TX_CHANNEL_INFO(channel, fTAIL, 0);
+	SET_TX_CHANNEL_INFO(channel, fSTATE, 1);
+	SET_TX_CHANNEL_INFO(channel, fBLOCKREADINTR, 0);
+	SET_TX_CHANNEL_INFO(channel, head, 0);
+	SET_TX_CHANNEL_INFO(channel, tail, 0);
+
+	qcom_smd_signal_channel(channel);
+
+	channel->state = SMD_CHANNEL_CLOSED;
+	channel->pkt_size = 0;
+}
+
+/*
+ * Calculate the amount of data available in the rx fifo
+ */
+static size_t qcom_smd_channel_get_rx_avail(struct qcom_smd_channel *channel)
+{
+	unsigned head;
+	unsigned tail;
+
+	head = GET_RX_CHANNEL_INFO(channel, head);
+	tail = GET_RX_CHANNEL_INFO(channel, tail);
+
+	return (head - tail) & (channel->fifo_size - 1);
+}
+
+/*
+ * Set tx channel state and inform the remote processor
+ */
+static void qcom_smd_channel_set_state(struct qcom_smd_channel *channel,
+				       int state)
+{
+	bool is_open = state == SMD_CHANNEL_OPENED;
+
+	if (channel->state == state)
+		return;
+
+	dev_dbg(channel->smd->dev, "set_state(%s, %d)\n", channel->name, state);
+
+	SET_TX_CHANNEL_INFO(channel, fDSR, is_open);
+	SET_TX_CHANNEL_INFO(channel, fCTS, is_open);
+	SET_TX_CHANNEL_INFO(channel, fCD, is_open);
+
+	SET_TX_CHANNEL_INFO(channel, state, state);
+	SET_TX_CHANNEL_INFO(channel, fSTATE, 1);
+
+	channel->state = state;
+	qcom_smd_signal_channel(channel);
+}
+
+static size_t qcom_smd_channel_peek(struct qcom_smd_channel *channel,
+				    void *buf, size_t count)
+{
+	unsigned tail;
+	size_t len;
+
+	tail = GET_RX_CHANNEL_INFO(channel, tail);
+
+	len = min(count, channel->fifo_size - tail);
+	if (len)
+		memcpy(buf, channel->rx_fifo + tail, len);
+
+	if (len != count)
+		memcpy(buf + len, channel->rx_fifo, count - len);
+
+	return count;
+}
+
+static size_t qcom_smd_channel_read(struct qcom_smd_channel *channel,
+				    void *buf, size_t count)
+{
+	unsigned tail;
+	size_t ret;
+
+	tail = GET_RX_CHANNEL_INFO(channel, tail);
+
+	ret = qcom_smd_channel_peek(channel, buf, count);
+
+	tail += count;
+	tail &= (channel->fifo_size - 1);
+	SET_RX_CHANNEL_INFO(channel, tail, tail);
+
+	return ret;
+}
+
+/*
+ * Read out a single packet from the rx fifo and deliver it to the device
+ */
+static int qcom_smd_channel_recv_single(struct qcom_smd_channel *channel)
+{
+	struct qcom_smd_device *qsdev = channel->qsdev;
+	unsigned tail;
+	size_t len;
+	void *ptr;
+	int ret;
+
+	tail = GET_RX_CHANNEL_INFO(channel, tail);
+
+	/* Use bounce buffer if the data wraps */
+	if (tail + channel->pkt_size >= channel->fifo_size) {
+		ptr = channel->bounce_buffer;
+		len = qcom_smd_channel_peek(channel, ptr, channel->pkt_size);
+	} else {
+		ptr = channel->rx_fifo + tail;
+		len = channel->pkt_size;
+	}
+
+	spin_lock(&channel->cb_lock);
+	if (channel->cb)
+		ret = channel->cb(qsdev, ptr, len);
+	else
+		ret = 0;
+	spin_unlock(&channel->cb_lock);
+
+	/* Only forward the tail if the device consumed the data */
+	if (!ret) {
+		tail += len;
+		tail &= (channel->fifo_size - 1);
+		SET_RX_CHANNEL_INFO(channel, tail, tail);
+
+		channel->pkt_size = 0;
+	}
+
+	return ret;
+}
+
+static void qcom_smd_channel_intr(struct qcom_smd_channel *channel)
+{
+	int remote_state;
+	u32 pkt_header[5];
+	int avail;
+	int ret;
+
+	/* Handle state changes */
+	remote_state = GET_RX_CHANNEL_INFO(channel, state);
+	if (remote_state != channel->remote_state) {
+		schedule_work(&channel->edge->state_change_work);
+		channel->remote_state = remote_state;
+	}
+	/* Indicate that we have seen any state change */
+	SET_RX_CHANNEL_INFO(channel, fSTATE, 0);
+
+	/* Don't consume the data until we've opened the channel */
+	if (channel->state != SMD_CHANNEL_OPENED)
+		return;
+
+	/* Indicate that we've seen the new data */
+	SET_RX_CHANNEL_INFO(channel, fHEAD, 0);
+
+	/* Consume data */
+	for (;;) {
+		avail = qcom_smd_channel_get_rx_avail(channel);
+
+		if (channel->pkt_size == 0 && avail >= sizeof(pkt_header)) {
+			qcom_smd_channel_read(channel,
+					      pkt_header, sizeof(pkt_header));
+			channel->pkt_size = pkt_header[0];
+		} else if (channel->pkt_size && avail >= channel->pkt_size) {
+			ret = qcom_smd_channel_recv_single(channel);
+			if (ret)
+				break;
+		} else {
+			break;
+		}
+	}
+
+	/* Indicate that we have seen the updated tail */
+	SET_RX_CHANNEL_INFO(channel, fTAIL, 1);
+
+	if (!GET_RX_CHANNEL_INFO(channel, fBLOCKREADINTR)) {
+		/* Ensure ordering of channel info updates */
+		wmb();
+
+		qcom_smd_signal_channel(channel);
+	}
+}
+
+/*
+ * Calculate how much space is available in the tx fifo.
+ */
+static size_t qcom_smd_get_tx_avail(struct qcom_smd_channel *channel)
+{
+	unsigned head;
+	unsigned tail;
+	unsigned mask = channel->fifo_size - 1;
+
+	head = GET_TX_CHANNEL_INFO(channel, head);
+	tail = GET_TX_CHANNEL_INFO(channel, tail);
+
+	return mask - ((head - tail) & mask);
+}
+
+/*
+ * Write count bytes of data into channel, possibly wrapping in the ring buffer
+ */
+static int qcom_smd_write_fifo(struct qcom_smd_channel *channel,
+			       void *data,
+			       size_t count)
+{
+	unsigned head;
+	size_t len;
+
+	head = GET_TX_CHANNEL_INFO(channel, head);
+
+	len = min(count, channel->fifo_size - head);
+	if (len)
+		memcpy(channel->tx_fifo + head, data, len);
+
+	if (len != count)
+		memcpy(channel->tx_fifo, data + len, count - len);
+
+	head += count;
+	head &= (channel->fifo_size - 1);
+	SET_TX_CHANNEL_INFO(channel, head, head);
+
+	return count;
+}
+
+/**
+ * qcom_smd_send - write data to smd channel
+ * @channel:	channel handle
+ * @data:	buffer of data to write
+ * @len:	number of bytes to write
+ */
+int qcom_smd_send(struct qcom_smd_channel *channel, void *data, int len)
+{
+	u32 hdr[5] = {len,};
+
+	mutex_lock(&channel->tx_lock);
+
+	/* Wait for enough space in tx fifo */
+	while (qcom_smd_get_tx_avail(channel) < sizeof(hdr) + len)
+		usleep_range(1000, 5000);
+
+	SET_TX_CHANNEL_INFO(channel, fTAIL, 0);
+
+	qcom_smd_write_fifo(channel, hdr, sizeof(hdr));
+	qcom_smd_write_fifo(channel, data, len);
+
+	SET_TX_CHANNEL_INFO(channel, fHEAD, 1);
+
+	/* Ensure ordering of channel info updates */
+	wmb();
+
+	qcom_smd_signal_channel(channel);
+
+	mutex_unlock(&channel->tx_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(qcom_smd_send);
+
+static struct qcom_smd_device *to_smd_device(struct device *dev)
+{
+	return container_of(dev, struct qcom_smd_device, dev);
+}
+
+static struct qcom_smd_driver *to_smd_driver(struct device *dev)
+{
+	struct qcom_smd_device *qsdev = to_smd_device(dev);
+
+	return container_of(qsdev->dev.driver, struct qcom_smd_driver, driver);
+}
+
+static int qcom_smd_dev_match(struct device *dev, struct device_driver *drv)
+{
+	return of_driver_match_device(dev, drv);
+}
+
+static int qcom_smd_dev_probe(struct device *dev)
+{
+	struct qcom_smd_device *qsdev = to_smd_device(dev);
+	struct qcom_smd_driver *qsdrv = to_smd_driver(dev);
+	struct qcom_smd_channel *channel = qsdev->channel;
+	size_t bb_size;
+	int ret;
+
+	/*
+	 * Packets are maximum 4k, but reduce if the fifo is smaller
+	 */
+	bb_size = min(channel->fifo_size, 4096);
+	channel->bounce_buffer = kmalloc(bb_size, GFP_KERNEL);
+	if (!channel->bounce_buffer)
+		return -ENOMEM;
+
+	channel->cb = qsdrv->callback;
+
+	qcom_smd_channel_set_state(channel, SMD_CHANNEL_OPENING);
+
+	qcom_smd_channel_set_state(channel, SMD_CHANNEL_OPENED);
+
+	ret = qsdrv->probe(qsdev);
+	if (ret) {
+		dev_err(&qsdev->dev, "probe failed\n");
+
+		channel->cb = NULL;
+		kfree(channel->bounce_buffer);
+		channel->bounce_buffer = NULL;
+
+		qcom_smd_channel_set_state(channel, SMD_CHANNEL_CLOSED);
+	}
+
+	return ret;
+}
+
+static int qcom_smd_dev_remove(struct device *dev)
+{
+	struct qcom_smd_device *qsdev = to_smd_device(dev);
+	struct qcom_smd_driver *qsdrv = to_smd_driver(dev);
+	struct qcom_smd_channel *channel = qsdev->channel;
+	unsigned long flags;
+
+	qcom_smd_channel_set_state(channel, SMD_CHANNEL_CLOSING);
+
+	spin_lock_irqsave(&channel->cb_lock, flags);
+	channel->cb = NULL;
+	spin_unlock_irqrestore(&channel->cb_lock, flags);
+
+	if (qsdrv->remove)
+		qsdrv->remove(qsdev);
+
+	channel->qsdev = NULL;
+	kfree(channel->bounce_buffer);
+	channel->bounce_buffer = NULL;
+
+	qcom_smd_channel_set_state(channel, SMD_CHANNEL_CLOSED);
+
+	qcom_smd_channel_reset(channel);
+
+	return 0;
+}
+
+static struct bus_type qcom_smd_bus = {
+	.name = "qcom_smd",
+	.match = qcom_smd_dev_match,
+	.probe = qcom_smd_dev_probe,
+	.remove = qcom_smd_dev_remove,
+};
+
+/**
+ * qcom_smd_driver_register - register a smd driver
+ * @qsdrv:	qcom_smd_driver struct
+ */
+int qcom_smd_driver_register(struct qcom_smd_driver *qsdrv)
+{
+	qsdrv->driver.bus = &qcom_smd_bus;
+	return driver_register(&qsdrv->driver);
+}
+EXPORT_SYMBOL(qcom_smd_driver_register);
+
+/**
+ * qcom_smd_driver_unregister - unregister a smd driver
+ * @qsdrv:	qcom_smd_driver struct
+ */
+void qcom_smd_driver_unregister(struct qcom_smd_driver *qsdrv)
+{
+	driver_unregister(&qsdrv->driver);
+}
+EXPORT_SYMBOL(qcom_smd_driver_unregister);
+
+static struct qcom_smd_channel *qcom_smd_create_channel(struct qcom_smd *smd,
+							struct qcom_smd_edge *edge,
+							int channel_idx,
+							char *name)
+{
+	struct qcom_smd_channel *channel;
+	size_t fifo_size;
+	size_t info_size;
+	void *fifo_base;
+	void *info;
+	int ret;
+
+	channel = devm_kzalloc(smd->dev, sizeof(*channel), GFP_KERNEL);
+	if (!channel)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&channel->tx_lock);
+	spin_lock_init(&channel->cb_lock);
+
+	channel->name = kstrdup(name, GFP_KERNEL);
+	channel->smd = smd;
+	channel->edge = edge;
+
+	ret = qcom_smem_get(smd->smem, SMEM_SMD_INFO_BASE_ID + channel_idx,
+			    (void **)&info, &info_size);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/*
+	 * Use the size of the item to figure out which channel info struct to
+	 * use.
+	 */
+	if (info_size == 2 * sizeof(struct smd_channel_info_word)) {
+		channel->tx_info_word = info;
+		channel->rx_info_word = info + sizeof(struct smd_channel_info_word);
+	} else if (info_size == 2 * sizeof(struct smd_channel_info)) {
+		channel->tx_info = info;
+		channel->rx_info = info + sizeof(struct smd_channel_info);
+	} else {
+		dev_err(smd->dev,
+			"channel info of size %d not supported\n", info_size);
+		return ERR_PTR(-EINVAL);
+	}
+
+	ret = qcom_smem_get(smd->smem, SMEM_SMD_FIFO_BASE_ID + channel_idx,
+			    &fifo_base, &fifo_size);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* The channel consist of a rx and tx fifo of equal size */
+	fifo_size /= 2;
+
+	dev_dbg(smd->dev, "channel '%s' info-size: %d fifo-size: %d\n",
+			  name, info_size, fifo_size);
+
+	channel->tx_fifo = fifo_base;
+	channel->rx_fifo = fifo_base + fifo_size;
+	channel->fifo_size = fifo_size;
+
+	qcom_smd_channel_reset(channel);
+
+	return channel;
+}
+
+static struct device_node *qcom_smd_match_channel(struct device_node *edge_node,
+						  const char *channel)
+{
+	struct device_node *child;
+	const char *name;
+	const char *key;
+	int ret;
+
+	for_each_available_child_of_node(edge_node, child) {
+		key = "qcom,smd-channels";
+		ret = of_property_read_string(child, key, &name);
+		if (ret)
+			continue;
+
+		if (strcmp(name, channel) == 0)
+			return child;
+	}
+
+	return NULL;
+}
+
+static void qcom_smd_release_device(struct device *dev)
+{
+	struct qcom_smd_device *qsdev = to_smd_device(dev);
+
+	kfree(qsdev);
+}
+
+static int qcom_smd_create_device(struct qcom_smd_channel *channel)
+{
+	struct qcom_smd_device *qsdev;
+	struct qcom_smd_edge *edge = channel->edge;
+	struct device_node *node;
+	struct qcom_smd *smd = channel->smd;
+	int ret;
+
+	if (channel->qsdev)
+		return -EEXIST;
+
+	node = qcom_smd_match_channel(edge->of_node, channel->name);
+	if (!node) {
+		dev_dbg(smd->dev, "no match for '%s'\n", channel->name);
+		return -ENXIO;
+	}
+
+	dev_dbg(smd->dev, "registering '%s'\n", channel->name);
+
+	qsdev = kzalloc(sizeof(*qsdev), GFP_KERNEL);
+	if (!qsdev)
+		return -ENOMEM;
+
+	dev_set_name(&qsdev->dev, "%s.%s", edge->of_node->name, node->name);
+	qsdev->dev.parent = smd->dev;
+	qsdev->dev.bus = &qcom_smd_bus;
+	qsdev->dev.release = qcom_smd_release_device;
+	qsdev->dev.of_node = node;
+
+	qsdev->channel = channel;
+
+	channel->qsdev = qsdev;
+
+	ret = device_register(&qsdev->dev);
+	if (ret) {
+		dev_err(smd->dev, "device_register failed: %d\n", ret);
+		put_device(&qsdev->dev);
+	}
+
+	return ret;
+}
+
+static void qcom_smd_destroy_device(struct qcom_smd_channel *channel)
+{
+	struct device *dev;
+
+	BUG_ON(!channel->qsdev);
+
+	dev = &channel->qsdev->dev;
+
+	device_unregister(dev);
+	put_device(dev);
+}
+
+static void qcom_channel_scan_worker(struct work_struct *work)
+{
+	struct qcom_smd_edge *edge = container_of(work,
+						  struct qcom_smd_edge,
+						  channel_scan_work);
+	struct qcom_smd_channel *channel;
+	struct qcom_smd_alloc_entry *entry;
+	struct qcom_smd *smd = edge->smd;
+	int ret;
+	int i;
+
+	ret = qcom_smem_get(smd->smem, SMEM_CHANNEL_ALLOC_TBL,
+			    (void **)&entry, NULL);
+	if (ret < 0) {
+		dev_err(smd->dev,
+			"smem item %d not allocated\n", SMEM_CHANNEL_ALLOC_TBL);
+		return;
+	};
+
+	for (i = 0; i < SMD_NUM_CHANNELS; i++) {
+		if (test_bit(i, smd->allocated))
+			continue;
+
+		if (entry[i].ref_count == 0)
+			continue;
+
+		if (!entry[i].name[0])
+			continue;
+
+		if (!(entry[i].flags & SMD_CHANNEL_FLAGS_PACKET))
+			continue;
+
+		if ((entry[i].flags & SMD_CHANNEL_FLAGS_EDGE) != edge->edge_id)
+			continue;
+
+		channel = qcom_smd_create_channel(smd, edge,
+						  entry[i].cid,
+						  entry[i].name);
+		if (IS_ERR(channel))
+			continue;
+
+		list_add(&channel->list, &edge->channels);
+
+		dev_dbg(smd->dev, "new channel found: '%s'\n", channel->name);
+		set_bit(i, smd->allocated);
+	}
+
+	schedule_work(&edge->state_change_work);
+}
+
+static void qcom_channel_state_worker(struct work_struct *work)
+{
+	struct qcom_smd_channel *channel;
+	struct qcom_smd_edge *edge = container_of(work,
+						  struct qcom_smd_edge,
+						  state_change_work);
+	unsigned remote_state;
+
+	/*
+	 * Register a device for any closed channel where the remote processor
+	 * is showing interest in opening the channel.
+	 */
+	list_for_each_entry(channel, &edge->channels, list) {
+		if (channel->state != SMD_CHANNEL_CLOSED)
+			continue;
+
+		remote_state = GET_RX_CHANNEL_INFO(channel, state);
+		if (remote_state != SMD_CHANNEL_OPENING &&
+		    remote_state != SMD_CHANNEL_OPENED)
+			continue;
+
+		qcom_smd_create_device(channel);
+	}
+
+	/*
+	 * Unregister the device for any channel that is opened where the
+	 * remote processor is closing the channel.
+	 */
+	list_for_each_entry(channel, &edge->channels, list) {
+		if (channel->state != SMD_CHANNEL_OPENING &&
+		    channel->state != SMD_CHANNEL_OPENED)
+			continue;
+
+		remote_state = GET_RX_CHANNEL_INFO(channel, state);
+		if (remote_state == SMD_CHANNEL_OPENING ||
+		    remote_state == SMD_CHANNEL_OPENED)
+			continue;
+
+		qcom_smd_destroy_device(channel);
+	}
+}
+
+/*
+ * The edge interrupts are triggered by the remote processor on state changes,
+ * channel info updates or when new channels are created.
+ */
+static irqreturn_t qcom_smd_edge_intr(int irq, void *data)
+{
+	struct qcom_smd_edge *edge = data;
+	struct qcom_smd_channel *channel;
+	unsigned available;
+
+	/*
+	 * Handle state changes or data on each of the channels on this edge
+	 */
+	list_for_each_entry(channel, &edge->channels, list)
+		qcom_smd_channel_intr(channel);
+
+	/*
+	 * Creating a new channel requires allocating an smem entry, so we only
+	 * have to scan if the amount of available space in smem have changed
+	 * since last scan.
+	 */
+	available = qcom_smem_get_free_space(edge->smd->smem);
+	if (available != edge->smem_available) {
+		edge->smem_available = available;
+		schedule_work(&edge->channel_scan_work);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int qcom_smd_parse_edge(struct device *dev,
+			       struct device_node *node,
+			       struct qcom_smd_edge *edge)
+{
+	struct device_node *syscon_np;
+	const char *key;
+	int irq;
+	int ret;
+
+	INIT_LIST_HEAD(&edge->channels);
+
+	INIT_WORK(&edge->channel_scan_work, qcom_channel_scan_worker);
+	INIT_WORK(&edge->state_change_work, qcom_channel_state_worker);
+
+	edge->of_node = of_node_get(node);
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq < 0) {
+		dev_err(dev, "required smd interrupt missing\n");
+		return -EINVAL;
+	}
+
+	ret = devm_request_irq(dev, irq,
+			       qcom_smd_edge_intr, IRQF_TRIGGER_RISING,
+			       node->name, edge);
+	if (ret) {
+		dev_err(dev, "failed to request smd irq\n");
+		return ret;
+	}
+
+	key = "qcom,smd-edge";
+	ret = of_property_read_u32(node, key, &edge->edge_id);
+	if (ret) {
+		dev_err(dev, "edge missing %s property\n", key);
+		return -EINVAL;
+	}
+
+	syscon_np = of_parse_phandle(node, "qcom,ipc", 0);
+	if (!syscon_np) {
+		dev_err(dev, "no qcom,ipc node\n");
+		return -ENODEV;
+	}
+
+	edge->ipc_regmap = syscon_node_to_regmap(syscon_np);
+	if (IS_ERR(edge->ipc_regmap))
+		return PTR_ERR(edge->ipc_regmap);
+
+	key = "qcom,ipc";
+	ret = of_property_read_u32_index(node, key, 1, &edge->ipc_offset);
+	if (ret < 0) {
+		dev_err(dev, "no offset in %s\n", key);
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32_index(node, key, 2, &edge->ipc_bit);
+	if (ret < 0) {
+		dev_err(dev, "no bit in %s\n", key);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int qcom_smd_probe(struct platform_device *pdev)
+{
+	struct qcom_smd_edge *edge;
+	struct device_node *node;
+	struct qcom_smd *smd;
+	size_t array_size;
+	int count;
+	int ret;
+	int i = 0;
+
+	count = of_get_child_count(pdev->dev.of_node);
+	array_size = sizeof(*smd) + count * sizeof(struct qcom_smd_edge);
+	smd = devm_kzalloc(&pdev->dev, array_size, GFP_KERNEL);
+	if (!smd)
+		return -ENOMEM;
+	smd->dev = &pdev->dev;
+
+	smd->smem = of_get_qcom_smem(pdev->dev.of_node);
+	if (IS_ERR(smd->smem)) {
+		if (PTR_ERR(smd->smem) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "failed to acquire smem handle\n");
+		return PTR_ERR(smd->smem);
+	}
+
+	dev_set_drvdata(&pdev->dev, smd);
+
+	smd->num_edges = count;
+	for_each_child_of_node(pdev->dev.of_node, node) {
+		edge = &smd->edges[i++];
+		edge->smd = smd;
+
+		ret = qcom_smd_parse_edge(&pdev->dev, node, edge);
+		if (ret)
+			continue;
+
+		schedule_work(&edge->channel_scan_work);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id qcom_smd_of_match[] = {
+	{ .compatible = "qcom,smd" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, qcom_smd_of_match);
+
+static struct platform_driver qcom_smd_driver = {
+	.probe = qcom_smd_probe,
+	.driver = {
+		.name = "qcom_smd",
+		.owner = THIS_MODULE,
+		.of_match_table = qcom_smd_of_match,
+	},
+};
+
+static int __init qcom_smd_init(void)
+{
+	int ret;
+
+	ret = bus_register(&qcom_smd_bus);
+	if (ret) {
+		pr_err("failed to register smd bus: %d\n", ret);
+		return ret;
+	}
+
+	return platform_driver_register(&qcom_smd_driver);
+}
+arch_initcall(qcom_smd_init);
+
+static void __exit qcom_smd_exit(void)
+{
+	platform_driver_unregister(&qcom_smd_driver);
+	bus_unregister(&qcom_smd_bus);
+}
+module_exit(qcom_smd_exit);
+
+MODULE_DESCRIPTION("Qualcomm Shared Memory Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/soc/qcom/qcom_smd.h b/include/linux/soc/qcom/qcom_smd.h
new file mode 100644
index 0000000..dad2c86
--- /dev/null
+++ b/include/linux/soc/qcom/qcom_smd.h
@@ -0,0 +1,47 @@
+#ifndef __LINUX_MSM_SMEM_H__
+#define __LINUX_MSM_SMEM_H__
+
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+
+struct qcom_smd;
+struct qcom_smd_channel;
+struct qcom_smd_lookup;
+
+/**
+ * struct qcom_smd_device - smd device struct
+ * @dev:	the device struct
+ * @channel:	handle to the smd channel for this device
+ */
+struct qcom_smd_device {
+	struct device dev;
+	struct qcom_smd_channel *channel;
+};
+
+/**
+ * struct qcom_smd_driver - smd driver struct
+ * @driver:	underlying device driver
+ * @probe:	invoked when the smd channel is found
+ * @remove:	invoked when the smd channel is closed
+ * @callback:	invoked when an inbound message is received on the channel,
+ * 		should return 0 on success or -EBUSY if the data cannot be
+ *		consumed at this time
+ */
+struct qcom_smd_driver {
+	struct device_driver driver;
+	int (*probe)(struct qcom_smd_device *dev);
+	void (*remove)(struct qcom_smd_device *dev);
+	int (*callback)(struct qcom_smd_device *, void *, size_t);
+};
+
+int qcom_smd_driver_register(struct qcom_smd_driver *drv);
+void qcom_smd_driver_unregister(struct qcom_smd_driver *drv);
+
+#define module_qcom_smd_driver(__smd_driver) \
+	module_driver(__smd_driver, qcom_smd_driver_register, \
+		      qcom_smd_driver_unregister)
+
+int qcom_smd_send(struct qcom_smd_channel *channel, void *data, int len);
+
+#endif
+
-- 
1.7.9.5

