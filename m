Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3D0SPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 14:15:14 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42966 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3D0SPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 14:15:11 -0400
From: jassisinghbrar@gmail.com
To: s-anna@ti.com, loic.pallardy@st.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, andy.green@linaro.org,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [RFC 2/3] mailbox: Introduce a new common API
Date: Sat, 27 Apr 2013 23:44:34 +0530
Message-Id: <1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jassi Brar <jaswinder.singh@linaro.org>

Introduce common framework for client/protocol drivers and
controller drivers of Inter-Processor-Communication (IPC).

Client driver developers should have a look at
 include/linux/mailbox_client.h to understand the part of
the API exposed to client drivers.
Similarly controller driver developers should have a look
at include/linux/mailbox_controller.h

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/mailbox/Makefile           |    4 +
 drivers/mailbox/mailbox.c          |  470 ++++++++++++++++++++++++++++++++++++
 include/linux/mailbox.h            |   20 ++
 include/linux/mailbox_client.h     |   88 +++++++
 include/linux/mailbox_controller.h |  105 ++++++++
 5 files changed, 687 insertions(+)
 create mode 100644 drivers/mailbox/mailbox.c
 create mode 100644 include/linux/mailbox.h
 create mode 100644 include/linux/mailbox_client.h
 create mode 100644 include/linux/mailbox_controller.h

diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index 543ad6a..fefef7e 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -1 +1,5 @@
+# Generic MAILBOX API
+
+obj-$(CONFIG_MAILBOX)		+= mailbox.o
+
 obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
new file mode 100644
index 0000000..c5ec93e
--- /dev/null
+++ b/drivers/mailbox/mailbox.c
@@ -0,0 +1,470 @@
+/*
+ * Copyright (C) 2013 Linaro Ltd
+ * Author: Jaswinder Singh <jassisinghbrar@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/mailbox_client.h>
+#include <linux/mailbox_controller.h>
+
+/*
+ * The length of circular buffer for queuing messages from a client.
+ * 'msg_count' tracks the number of buffered messages while 'msg_free'
+ * is the index where the next message would be buffered.
+ * We shouldn't need it too big because every transferr is interrupt
+ * triggered and if we have lots of data to transfer, the interrupt
+ * latencies are going to be the bottleneck, not the buffer length.
+ * Besides, ipc_send_message could be called from atomic context and
+ * the client could also queue another message from the notifier 'txcb'
+ * of the last transfer done.
+ */
+#define MBOX_TX_QUEUE_LEN	10
+
+#define TXDONE_BY_IRQ	(1 << 0) /* controller has remote RTR irq */
+#define TXDONE_BY_POLL 	(1 << 1) /* controller can read status of last TX */
+#define TXDONE_BY_ACK	(1 << 2) /* S/W ACK recevied by Client ticks the TX */
+
+struct ipc_chan {
+	char chan_name[32]; /* controller_name:link_name */
+	unsigned txdone_method;
+
+	/* Cached values from controller */
+	struct ipc_link *link;
+	struct ipc_link_ops *link_ops;
+
+	/* Cached values from client */
+	void (*rxcb)(void *data);
+	void (*txcb)(request_token_t t, enum xfer_result r);
+	bool tx_block;
+	unsigned long tx_tout;
+	struct completion tx_complete;
+
+	request_token_t active_token;
+	unsigned msg_count, msg_free;
+	void *msg_data[MBOX_TX_QUEUE_LEN];
+	/* Timer shared by all links of a controller */
+	struct tx_poll_timer *timer;
+	bool assigned;
+	/* Serialize access to the channel */
+	spinlock_t lock;
+	/* Hook to add to the global list of channels */
+	struct list_head node;
+	/* Notifier to all clients waiting on aquiring this channel */
+	struct blocking_notifier_head avail;
+};
+
+/*
+ * If the controller supports only TXDONE_BY_POLL, this
+ * timer polls all the links for txdone.
+ */
+struct tx_poll_timer {
+	struct timer_list poll;
+	unsigned period;
+};
+
+static struct list_head ipc_channels;
+static DEFINE_MUTEX(chpool_mutex);
+
+static request_token_t _add_to_rbuf(struct ipc_chan *chan, void *data)
+{
+	request_token_t idx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	/* See if there is any space left */
+	if (chan->msg_count == MBOX_TX_QUEUE_LEN) {
+		spin_unlock_irqrestore(&chan->lock, flags);
+		return 0;
+	}
+
+	idx = chan->msg_free;
+	chan->msg_data[idx] = data;
+	chan->msg_count++;
+
+	if (idx == MBOX_TX_QUEUE_LEN - 1)
+		chan->msg_free = 0;
+	else
+		chan->msg_free++;
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	return idx + 1;
+}
+
+static void _msg_submit(struct ipc_chan *chan)
+{
+	struct ipc_link *link = chan->link;
+	unsigned count, idx;
+	unsigned long flags;
+	void *data;
+	int err;
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	if (!chan->msg_count || chan->active_token) {
+		spin_unlock_irqrestore(&chan->lock, flags);
+		return;
+	}
+
+	count = chan->msg_count;
+	idx = chan->msg_free;
+	if (idx >= count)
+		idx -= count;
+	else
+		idx += MBOX_TX_QUEUE_LEN - count;
+
+	data = chan->msg_data[idx];
+
+	/* Try to submit a message to the IPC controller */
+	err = chan->link_ops->send_data(link, data);
+	if (!err) {
+		chan->active_token = idx + 1;
+		chan->msg_count--;
+	}
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+}
+
+static void tx_tick(struct ipc_chan *chan, enum xfer_result r)
+{
+	unsigned long flags;
+	request_token_t t;
+
+	spin_lock_irqsave(&chan->lock, flags);
+	t = chan->active_token;
+	chan->active_token = 0;
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	/* Submit next message */
+	_msg_submit(chan);
+
+	/* Notify the client */
+	if (chan->tx_block)
+		complete(&chan->tx_complete);
+	else if (t && chan->txcb)
+		chan->txcb(t, r);
+}
+
+static void poll_txdone(unsigned long data)
+{
+	struct tx_poll_timer *timer = (struct tx_poll_timer *)data;
+	bool txdone, resched = false;
+	struct ipc_chan *chan;
+
+	list_for_each_entry(chan, &ipc_channels, node) {
+		if (chan->timer == timer && chan->active_token) {
+			resched = true;
+			txdone = chan->link_ops->last_tx_done(chan->link);
+			if (txdone)
+				tx_tick(chan, XFER_OK);
+		}
+	}
+
+	if (resched)
+		mod_timer(&timer->poll,
+			jiffies + msecs_to_jiffies(timer->period));
+}
+
+/*
+ * After 'startup' and before 'shutdown', the IPC controller driver
+ * notifies the API of data received over the link.
+ * The controller driver should make sure the 'RTR' is de-asserted since
+ * reception of the packet and until after this call returns.
+ * This call could be made from atomic context.
+ */
+void ipc_link_received_data(struct ipc_link *link, void *data)
+{
+	struct ipc_chan *chan = (struct ipc_chan *)link->api_priv;
+
+	/* No buffering the received data */
+	if (chan->rxcb)
+		chan->rxcb(data);
+}
+EXPORT_SYMBOL(ipc_link_received_data);
+
+/*
+ * The IPC controller driver notifies the API that the remote has
+ * asserted RTR and it could now send another message on the link.
+ */
+void ipc_link_txdone(struct ipc_link *link, enum xfer_result r)
+{
+	struct ipc_chan *chan = (struct ipc_chan *)link->api_priv;
+
+	if (unlikely(!(chan->txdone_method & TXDONE_BY_IRQ))) {
+		printk("Controller can't run the TX ticker\n");
+		return;
+	}
+
+	tx_tick(chan, r);
+}
+EXPORT_SYMBOL(ipc_link_txdone);
+
+/*
+ * The client/protocol had received some 'ACK' packet and it notifies
+ * the API that the last packet was sent successfully. This only works
+ * if the controller doesn't get IRQ for TX done.
+ */
+void ipc_client_txdone(void *channel, enum xfer_result r)
+{
+	struct ipc_chan *chan = (struct ipc_chan *)channel;
+	bool txdone = true;
+
+	if (unlikely(!(chan->txdone_method & TXDONE_BY_ACK))) {
+		printk("Client can't run the TX ticker\n");
+		return;
+	}
+
+	if (chan->txdone_method & TXDONE_BY_POLL)
+		txdone = chan->link_ops->last_tx_done(chan->link);
+
+	if (txdone)
+		tx_tick(chan, r);
+}
+EXPORT_SYMBOL(ipc_client_txdone);
+
+/*
+ * Called by a client to "put data on the h/w channel" so that if
+ * everything else is fine we don't need to do anything more locally
+ * for the remote to receive the data intact.
+ * In reality, the remote may receive it intact, corrupted or not at all.
+ * This could be called from atomic context as it simply
+ * queues the data and returns a token (request_token_t)
+ * against the request.
+ * The client is later notified of successful transmission of
+ * data over the channel via the 'txcb'. The client could in
+ * turn queue more messages from txcb.
+ */
+request_token_t ipc_send_message(void *channel, void *data)
+{
+	struct ipc_chan *chan = (struct ipc_chan *)channel;
+	request_token_t t;
+
+	if (!chan)
+		return 0;
+
+	t = _add_to_rbuf(chan, data);
+	if (!t)
+		printk("Try increasing MBOX_TX_QUEUE_LEN\n");
+
+	_msg_submit(chan);
+
+	if (chan->txdone_method	== TXDONE_BY_POLL)
+		poll_txdone((unsigned long)chan->timer);
+
+	if (chan->tx_block && chan->active_token) {
+		int ret;
+		init_completion(&chan->tx_complete);
+		ret = wait_for_completion_timeout(&chan->tx_complete,
+			chan->tx_tout);
+		if (ret == 0) {
+			t = 0;
+			tx_tick(chan, XFER_ERR);
+		}
+	}
+
+	return t;
+}
+EXPORT_SYMBOL(ipc_send_message);
+
+/*
+ * A client driver asks for exclusive use of a channel/mailbox.
+ * If assigned, the channel has to be 'freed' before it could
+ * be assigned to some other client.
+ * After assignment, any packet received on this channel will be
+ * handed over to the client via the 'rxcb' callback.
+ * The 'txcb' callback is used to notify client upon sending the
+ * packet over the channel, which may or may not have been yet
+ * read by the remote processor.
+ */
+void *ipc_request_channel(struct ipc_client *cl)
+{
+	struct ipc_chan *chan;
+	unsigned long flags;
+	int ret = 0;
+
+	mutex_lock(&chpool_mutex);
+
+	list_for_each_entry(chan, &ipc_channels, node)
+		if(!chan->assigned
+				&& !strcmp(cl->chan_name, chan->chan_name)) {
+			spin_lock_irqsave(&chan->lock, flags);
+			chan->msg_free = 0;
+			chan->msg_count = 0;
+			chan->active_token = 0;
+			chan->rxcb = cl->rxcb;
+			chan->txcb = cl->txcb;
+			chan->assigned = true;
+			chan->tx_block = cl->tx_block;
+			if (!cl->tx_tout)
+				chan->tx_tout = ~0;
+			else
+				chan->tx_tout = msecs_to_jiffies(cl->tx_tout);
+			if (chan->txdone_method	== TXDONE_BY_POLL
+					&& cl->knows_txdone)
+				chan->txdone_method |= TXDONE_BY_ACK;
+			spin_unlock_irqrestore(&chan->lock, flags);
+			ret = 1;
+			break;
+		}
+
+	mutex_unlock(&chpool_mutex);
+
+	if (!ret) {
+		printk("Unable to assign mailbox(%s)\n", cl->chan_name);
+		return NULL;
+	}
+
+	ret = chan->link_ops->startup(chan->link, cl->cntlr_data);
+	if (ret) {
+		printk("Unable to startup the link\n");
+		ipc_free_channel((void *)chan);
+		return NULL;
+	}
+
+	return (void *)chan;
+}
+EXPORT_SYMBOL(ipc_request_channel);
+
+/* Drop any messages queued and release the channel */
+void ipc_free_channel(void *ch)
+{
+	struct ipc_chan *chan = (struct ipc_chan *)ch;
+	unsigned long flags;
+
+	if (!chan || !chan->assigned)
+		return;
+
+	chan->link_ops->shutdown(chan->link);
+
+	/* The queued TX requests are simply aborted, no callbacks are made */
+	spin_lock_irqsave(&chan->lock, flags);
+	chan->assigned = false;
+	if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
+		chan->txdone_method = TXDONE_BY_POLL;
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	blocking_notifier_call_chain(&chan->avail, 0, NULL);
+}
+EXPORT_SYMBOL(ipc_free_channel);
+
+static struct ipc_chan *name_to_chan(const char *name)
+{
+	struct ipc_chan *chan;
+	int ret = 0;
+
+	mutex_lock(&chpool_mutex);
+	list_for_each_entry(chan, &ipc_channels, node)
+		if (!strcmp(name, chan->chan_name)) {
+			ret = 1;
+			break;
+		}
+	mutex_unlock(&chpool_mutex);
+
+	if (!ret)
+		return NULL;
+
+	return chan;
+}
+
+int ipc_notify_chan_register(const char *name, struct notifier_block *nb)
+{
+	struct ipc_chan *chan = name_to_chan(name);
+
+	if (chan && nb)
+		return blocking_notifier_chain_register(&chan->avail, nb);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ipc_notify_chan_register);
+
+void ipc_notify_chan_unregister(const char *name, struct notifier_block *nb)
+{
+	struct ipc_chan *chan = name_to_chan(name);
+
+	if (chan && nb)
+		blocking_notifier_chain_unregister(&chan->avail, nb);
+}
+EXPORT_SYMBOL(ipc_notify_chan_unregister);
+
+/*
+ * Call for IPC controller drivers to register a controller, adding
+ * its channels/mailboxes to the global pool.
+ */
+int ipc_links_register(struct ipc_controller *ipc_con)
+{
+	struct tx_poll_timer *timer = NULL;
+	struct ipc_chan *channel;
+	int i, num_links, txdone;
+
+	/* Are you f***ing with us, sir? */
+	if (!ipc_con || !ipc_con->ops)
+		return -EINVAL;
+
+	for (i = 0; ipc_con->links[i]; i++)
+		;
+	if (!i)
+		return -EINVAL;
+	num_links = i;
+
+	if (ipc_con->txdone_irq)
+		txdone = TXDONE_BY_IRQ;
+	else if (ipc_con->txdone_poll)
+		txdone = TXDONE_BY_POLL;
+	else /* It has to be at least ACK */
+		txdone = TXDONE_BY_ACK;
+
+	if (txdone == TXDONE_BY_POLL) {
+		timer = kzalloc(sizeof(struct tx_poll_timer), GFP_KERNEL);
+		timer->period = ipc_con->txpoll_period;
+		timer->poll.function = &poll_txdone;
+		timer->poll.data = (unsigned long)timer;
+		init_timer(&timer->poll);
+	}
+
+	channel = kzalloc(sizeof(struct ipc_chan) * num_links, GFP_KERNEL);
+
+	for (i = 0; i < num_links; i++) {
+		channel[i].timer = timer;
+		channel[i].assigned = false;
+		channel[i].txdone_method = txdone;
+		channel[i].link_ops = ipc_con->ops;
+		channel[i].link = ipc_con->links[i];
+		channel[i].link->api_priv = &channel[i];
+		snprintf(channel[i].chan_name, 32, "%s:%s",
+			ipc_con->controller_name,
+			ipc_con->links[i]->link_name);
+		spin_lock_init(&channel[i].lock);
+		BLOCKING_INIT_NOTIFIER_HEAD(&channel[i].avail);
+		mutex_lock(&chpool_mutex);
+		list_add_tail(&channel[i].node, &ipc_channels);
+		mutex_unlock(&chpool_mutex);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ipc_links_register);
+
+/* Free any occupied channels */
+void ipc_links_unregister(struct ipc_controller *ipc_con)
+{
+	/* TBD */
+}
+EXPORT_SYMBOL(ipc_links_unregister);
+
+static int __init ipc_mbox_init(void)
+{
+	INIT_LIST_HEAD(&ipc_channels);
+	return 0;
+}
+subsys_initcall(ipc_mbox_init);
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
new file mode 100644
index 0000000..aa82be8
--- /dev/null
+++ b/include/linux/mailbox.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2013 Linaro Ltd
+ * Author: Jaswinder Singh <jassisinghbrar@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MAILBOX_H
+#define __MAILBOX_H
+
+enum xfer_result {
+	XFER_OK = 0,
+	XFER_ERR,
+};
+
+typedef unsigned request_token_t;
+
+#endif /* __MAILBOX_H */
diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
new file mode 100644
index 0000000..33545f6
--- /dev/null
+++ b/include/linux/mailbox_client.h
@@ -0,0 +1,88 @@
+/*
+ * Copyright (C) 2013 Linaro Ltd
+ * Author: Jaswinder Singh <jassisinghbrar@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MAILBOX_CLIENT_H
+#define __MAILBOX_CLIENT_H
+
+#include <linux/mailbox.h>
+
+/**
+ * struct ipc_client - User of a mailbox
+ * @chan_name: the "controller:channel" this client wants
+ * @rxcb: atomic callback to provide client the data received
+ * @txcb: atomic callback to tell client of data transmission
+ * @tx_block: if the ipc_send_message should block until data is transmitted
+ * @tx_tout: Max block period in ms before TX is assumed failure
+ * @knows_txdone: if the client could run the TX state machine. Usually if
+ *    the client receives some ACK packet for transmission. Unused if the
+ *    controller already has TX_Done/RTR IRQ.
+ * @cntlr_data: Optional controller specific parameters during channel request
+ */
+struct ipc_client {
+	char *chan_name;
+	void (*rxcb)(void *data);
+	void (*txcb)(request_token_t t, enum xfer_result r);
+	bool tx_block;
+	unsigned long tx_tout;
+	bool knows_txdone;
+	void *cntlr_data;
+};
+
+/**
+ * The Client specifies it requirements and capabilities while asking for
+ * a channel/mailbox by name. It can't be called from atomic context.
+ * The channel is exclusively allocated and can't be used by another
+ * client before the owner calls ipc_free_channel.
+ */
+void *ipc_request_channel(struct ipc_client *cl);
+
+/**
+ * For client to submit data to the controller destined for a remote
+ * processor. If the client had set 'tx_block', the call will return
+ * either when the remote receives the data or when 'tx_tout' millisecs
+ * run out.
+ *  In non-blocking mode, the requests are buffered by the API and a
+ * non-zero token is returned for each queued request. If the queue
+ * was full the returned token will be 0. Upon failure or successful
+ * TX, the API calls 'txcb' from atomic context, from which the client
+ * could submit yet another request.
+ *  In blocking mode, 'txcb' is not called, effectively making the
+ * queue length 1. The returned value is 0 if TX timed out, some
+ * non-zero value upon success.
+ */
+request_token_t ipc_send_message(void *channel, void *data);
+
+/**
+ * The way for a client to run the TX state machine. This works
+ * only if the client sets 'knows_txdone' and the IPC controller
+ * don't get an IRQ for TX_Done.
+ */
+void ipc_client_txdone(void *channel, enum xfer_result r);
+
+/**
+ * The client relinquishes control of a mailbox by this call,
+ * make it available to other clients.
+ * The ipc_request/free_channel are light weight calls, so the
+ * client should avoid holding it when it doesn't need to
+ * transfer data.
+ */
+void ipc_free_channel(void *ch);
+
+/**
+ * The client make ask the API to be notified when a particular channel
+ * becomes available to be acquired again.
+ */
+int ipc_notify_chan_register(const char *name, struct notifier_block *nb);
+
+/**
+ * The client is no more interested in acquiring the channel.
+ */
+void ipc_notify_chan_unregister(const char *name, struct notifier_block *nb);
+
+#endif /* __MAILBOX_CLIENT_H */
diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
new file mode 100644
index 0000000..defcfb3
--- /dev/null
+++ b/include/linux/mailbox_controller.h
@@ -0,0 +1,105 @@
+/*
+ * Copyright (C) 2013 Linaro Ltd
+ * Author: Jaswinder Singh <jassisinghbrar@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MAILBOX_CONTROLLER_H
+#define __MAILBOX_CONTROLLER_H
+
+#include <linux/mailbox.h>
+
+/**
+ * struct ipc_link - s/w representation of a communication link
+ * @link_name: Literal name assigned to the link. Physically
+ *    identical channels may have the same name.
+ * @api_priv: hook for the API to map its private data on the link
+ *    Controller driver must not touch it.
+ */
+struct ipc_link {
+	char link_name[16];
+	void *api_priv;
+};
+
+/**
+ * struct ipc_link - s/w representation of a communication link
+ * @send_data: The API asks the IPC controller driver, in atomic
+ *    context try to transmit a message on the bus. Returns 0 if
+ *    data is accepted for transmission, -EBUSY while rejecting
+ *    if the remote hasn't yet read the last data sent. Actual
+ *    transmission of data is reported by the controller via
+ *    ipc_link_txdone (if it has some TX ACK irq). It must not
+ *    block.
+ * @startup: Called when a client requests the link. The controller
+ *    could ask clients for additional parameters of communication
+ *    to be provided via client's cntlr_data. This call may block.
+ *    After this call the Controller must forward any data received
+ *    on the link by calling ipc_link_received_data (which won't block)
+ * @shutdown: Called when a client relinquishes control of a link.
+ *    This call may block too. The controller must not forwared
+ *    any received data anymore.
+ * @last_tx_done: If the controller sets 'txdone_poll', the API calls
+ *    this to poll status of last TX. The controller must give priority
+ *    to IRQ method over polling and never set both txdone_poll and
+ *    txdone_irq. Only in polling mode 'send_data' is expected to
+ *    return -EBUSY. Used only if txdone_poll:=true && txdone_irq:=false
+ */
+struct ipc_link_ops {
+	int (*send_data)(struct ipc_link *link, void *data);
+	int (*startup)(struct ipc_link *link, void *params);
+	void (*shutdown)(struct ipc_link *link);
+	bool (*last_tx_done)(struct ipc_link *link);
+};
+
+/**
+ * struct ipc_controller - Controller of a class of communication links
+ * @controller_name: Literal name of the controller.
+ * @ops: Operators that work on each communication link
+ * @links: Null terminated array of links.
+ * @txdone_irq: Indicates if the controller can report to API when the
+ *    last transmitted data was read by the remote. Eg, if it has some
+ *    TX ACK irq.
+ * @txdone_poll: If the controller can read but not report the TX done.
+ *    Eg, is some register shows the TX status but no interrupt rises.
+ *    Ignored if 'txdone_irq' is set.
+ * @txpoll_period: If 'txdone_poll' is in effect, the API polls for
+ *    last TX's status after these many millisecs
+ */
+struct ipc_controller {
+	char controller_name[16];
+	struct ipc_link_ops *ops;
+	struct ipc_link **links;
+	bool txdone_irq;
+	bool txdone_poll;
+	unsigned txpoll_period;
+};
+
+/**
+ * The controller driver registers its communication links to the
+ * global pool managed by the API.
+ */
+int ipc_links_register(struct ipc_controller *ipc_con);
+
+/**
+ * After startup and before shutdown any data received on the link
+ * is pused to the API via atomic ipc_link_received_data() API.
+ * The controller should ACK the RX only after this call returns.
+ */
+void ipc_link_received_data(struct ipc_link *link, void *data);
+
+/**
+ * The controller the has IRQ for TX ACK calls this atomic API
+ * to tick the TX state machine. It works only if txdone_irq
+ * is set by the controller.
+ */
+void ipc_link_txdone(struct ipc_link *link, enum xfer_result r);
+
+/**
+ * Purge the links from the global pool maintained by the API.
+ */
+void ipc_links_unregister(struct ipc_controller *ipc_con);
+
+#endif /* __MAILBOX_CONTROLLER_H */
-- 
1.7.10.4

