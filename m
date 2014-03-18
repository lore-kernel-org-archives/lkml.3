Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbaCRSpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:45:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36999 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbaCRSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:45:52 -0400
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com, robherring2@gmail.com, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv4 2/5] mailbox: Introduce framework for mailbox
Date: Wed, 19 Mar 2014 00:15:34 +0530
Message-Id: <1395168335-29119-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
References: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce common framework for client/protocol drivers and
controller drivers of Inter-Processor-Communication (IPC).

Client driver developers should have a look at
 include/linux/mailbox_client.h to understand the part of
the API exposed to client drivers.
Similarly controller driver developers should have a look
at include/linux/mailbox_controller.h

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/mailbox/Makefile           |   4 +
 drivers/mailbox/mailbox.c          | 589 +++++++++++++++++++++++++++++++++++++
 include/linux/mailbox.h            |  18 ++
 include/linux/mailbox_client.h     |  48 +++
 include/linux/mailbox_controller.h |  85 ++++++
 5 files changed, 744 insertions(+)
 create mode 100644 drivers/mailbox/mailbox.c
 create mode 100644 include/linux/mailbox.h
 create mode 100644 include/linux/mailbox_client.h
 create mode 100644 include/linux/mailbox_controller.h

diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index e0facb3..2fa343a 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -1,3 +1,7 @@
+# Generic MAILBOX API
+
+obj-$(CONFIG_MAILBOX)		+= mailbox.o
+
 obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
 
 obj-$(CONFIG_OMAP_MBOX)		+= omap-mailbox.o
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
new file mode 100644
index 0000000..79d576e
--- /dev/null
+++ b/drivers/mailbox/mailbox.c
@@ -0,0 +1,589 @@
+/*
+ * Mailbox: Common code for Mailbox controllers and users
+ *
+ * Copyright (C) 2014 Linaro Ltd.
+ * Author: Jassi Brar <jassisinghbrar@gmail.com>
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
+#include <linux/device.h>
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
+ * Besides, mbox_send_message could be called from atomic context and
+ * the client could also queue another message from the notifier 'tx_done'
+ * of the last transfer done.
+ * REVIST: If too many platforms see the "Try increasing MBOX_TX_QUEUE_LEN"
+ * print, it needs to be taken from config option or somesuch.
+ */
+#define MBOX_TX_QUEUE_LEN	20
+
+#define TXDONE_BY_IRQ	(1 << 0) /* controller has remote RTR irq */
+#define TXDONE_BY_POLL	(1 << 1) /* controller can read status of last TX */
+#define TXDONE_BY_ACK	(1 << 2) /* S/W ACK recevied by Client ticks the TX */
+
+struct mbox_chan {
+	char name[16]; /* Physical link's name */
+	struct mbox_con *con; /* Parent Controller */
+	unsigned txdone_method;
+
+	/* Physical links */
+	struct mbox_link *link;
+	struct mbox_link_ops *link_ops;
+
+	/* client */
+	struct mbox_client *cl;
+	struct completion tx_complete;
+
+	void *active_req;
+	unsigned msg_count, msg_free;
+	void *msg_data[MBOX_TX_QUEUE_LEN];
+	/* Access to the channel */
+	spinlock_t lock;
+	/* Hook to add to the controller's list of channels */
+	struct list_head node;
+	/* Notifier to all clients waiting on aquiring this channel */
+	struct blocking_notifier_head avail;
+} __aligned(32);
+
+/* Internal representation of a controller */
+struct mbox_con {
+	struct device *dev;
+	char name[16]; /* controller_name */
+	struct list_head channels;
+	/*
+	 * If the controller supports only TXDONE_BY_POLL,
+	 * this timer polls all the links for txdone.
+	 */
+	struct timer_list poll;
+	unsigned period;
+	/* Hook to add to the global controller list */
+	struct list_head node;
+} __aligned(32);
+
+static LIST_HEAD(mbox_cons);
+static DEFINE_MUTEX(con_mutex);
+
+static int _add_to_rbuf(struct mbox_chan *chan, void *mssg)
+{
+	int idx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	/* See if there is any space left */
+	if (chan->msg_count == MBOX_TX_QUEUE_LEN) {
+		spin_unlock_irqrestore(&chan->lock, flags);
+		return -ENOMEM;
+	}
+
+	idx = chan->msg_free;
+	chan->msg_data[idx] = mssg;
+	chan->msg_count++;
+
+	if (idx == MBOX_TX_QUEUE_LEN - 1)
+		chan->msg_free = 0;
+	else
+		chan->msg_free++;
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	return idx;
+}
+
+static void _msg_submit(struct mbox_chan *chan)
+{
+	struct mbox_link *link = chan->link;
+	unsigned count, idx;
+	unsigned long flags;
+	void *data;
+	int err;
+
+	spin_lock_irqsave(&chan->lock, flags);
+
+	if (!chan->msg_count || chan->active_req) {
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
+	/* Try to submit a message to the MBOX controller */
+	err = chan->link_ops->send_data(link, data);
+	if (!err) {
+		chan->active_req = data;
+		chan->msg_count--;
+	}
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+}
+
+static void tx_tick(struct mbox_chan *chan, enum mbox_result r)
+{
+	unsigned long flags;
+	void *mssg;
+
+	spin_lock_irqsave(&chan->lock, flags);
+	mssg = chan->active_req;
+	chan->active_req = NULL;
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	/* Submit next message */
+	_msg_submit(chan);
+
+	/* Notify the client */
+	if (chan->cl->tx_block)
+		complete(&chan->tx_complete);
+	else if (mssg && chan->cl->tx_done)
+		chan->cl->tx_done(chan->cl, mssg, r);
+}
+
+static void poll_txdone(unsigned long data)
+{
+	struct mbox_con *con = (struct mbox_con *)data;
+	bool txdone, resched = false;
+	struct mbox_chan *chan;
+
+	list_for_each_entry(chan, &con->channels, node) {
+		if (chan->active_req && chan->cl) {
+			resched = true;
+			txdone = chan->link_ops->last_tx_done(chan->link);
+			if (txdone)
+				tx_tick(chan, MBOX_OK);
+		}
+	}
+
+	if (resched)
+		mod_timer(&con->poll,
+			jiffies + msecs_to_jiffies(con->period));
+}
+
+/**
+ * mbox_link_received_data - A way for controller driver to push data
+ *				received from remote to the upper layer.
+ * @link: Pointer to the mailbox link on which RX happened.
+ * @data: Client specific message typecasted as void *
+ *
+ * After startup and before shutdown any data received on the link
+ * is passed on to the API via atomic mbox_link_received_data().
+ * The controller should ACK the RX only after this call returns.
+ */
+void mbox_link_received_data(struct mbox_link *link, void *mssg)
+{
+	struct mbox_chan *chan = (struct mbox_chan *)link->api_priv;
+
+	/* No buffering the received data */
+	if (chan->cl->rx_callback)
+		chan->cl->rx_callback(chan->cl, mssg);
+}
+EXPORT_SYMBOL_GPL(mbox_link_received_data);
+
+/**
+ * mbox_link_txdone - A way for controller driver to notify the
+ *			framework that the last TX has completed.
+ * @link: Pointer to the mailbox link on which TX happened.
+ * @r: Status of last TX - OK or ERROR
+ *
+ * The controller that has IRQ for TX ACK calls this atomic API
+ * to tick the TX state machine. It works only if txdone_irq
+ * is set by the controller.
+ */
+void mbox_link_txdone(struct mbox_link *link, enum mbox_result r)
+{
+	struct mbox_chan *chan = (struct mbox_chan *)link->api_priv;
+
+	if (unlikely(!(chan->txdone_method & TXDONE_BY_IRQ))) {
+		pr_err("Controller can't run the TX ticker\n");
+		return;
+	}
+
+	tx_tick(chan, r);
+}
+EXPORT_SYMBOL_GPL(mbox_link_txdone);
+
+/**
+ * mbox_client_txdone - The way for a client to run the TX state machine.
+ * @chan: Mailbox channel assigned to this client.
+ * @r: Success status of last transmission.
+ *
+ * The client/protocol had received some 'ACK' packet and it notifies
+ * the API that the last packet was sent successfully. This only works
+ * if the controller can't sense TX-Done.
+ */
+void mbox_client_txdone(struct mbox_chan *chan, enum mbox_result r)
+{
+	if (unlikely(!(chan->txdone_method & TXDONE_BY_ACK))) {
+		pr_err("Client can't run the TX ticker\n");
+		return;
+	}
+
+	tx_tick(chan, r);
+}
+EXPORT_SYMBOL_GPL(mbox_client_txdone);
+
+/**
+ * mbox_send_message -	For client to submit a message to be
+ *				sent to the remote.
+ * @chan: Mailbox channel assigned to this client.
+ * @mssg: Client specific message typecasted.
+ *
+ * For client to submit data to the controller destined for a remote
+ * processor. If the client had set 'tx_block', the call will return
+ * either when the remote receives the data or when 'tx_tout' millisecs
+ * run out.
+ *  In non-blocking mode, the requests are buffered by the API and a
+ * non-negative token is returned for each queued request. If the request
+ * is not queued, a negative token is returned. Upon failure or successful
+ * TX, the API calls 'tx_done' from atomic context, from which the client
+ * could submit yet another request.
+ *  In blocking mode, 'tx_done' is not called, effectively making the
+ * queue length 1.
+ * The pointer to message should be preserved until it is sent
+ * over the link, i.e, tx_done() is made.
+ * This function could be called from atomic context as it simply
+ * queues the data and returns a token against the request.
+ *
+ * Return: Non-negative integer for successful submission (non-blocking mode)
+ *	or transmission over link (blocking mode).
+ *	Negative value denotes failure.
+ */
+int mbox_send_message(struct mbox_chan *chan, void *mssg)
+{
+	int t;
+
+	if (!chan || !chan->cl)
+		return -EINVAL;
+
+	t = _add_to_rbuf(chan, mssg);
+	if (t < 0) {
+		pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
+		return t;
+	}
+
+	_msg_submit(chan);
+
+	if (chan->txdone_method	== TXDONE_BY_POLL)
+		poll_txdone((unsigned long)chan->con);
+
+	if (chan->cl->tx_block && chan->active_req) {
+		int ret;
+		init_completion(&chan->tx_complete);
+		ret = wait_for_completion_timeout(&chan->tx_complete,
+			chan->cl->tx_tout);
+		if (ret == 0) {
+			t = -EIO;
+			tx_tick(chan, MBOX_ERR);
+		}
+	}
+
+	return t;
+}
+EXPORT_SYMBOL_GPL(mbox_send_message);
+
+/**
+ * mbox_request_channel - Request a mailbox channel.
+ * @cl: Identity of the client requesting the channel.
+ *
+ * The Client specifies its requirements and capabilities while asking for
+ * a mailbox channel by name. It can't be called from atomic context.
+ * The channel is exclusively allocated and can't be used by another
+ * client before the owner calls mbox_free_channel.
+ * After assignment, any packet received on this channel will be
+ * handed over to the client via the 'rx_callback'.
+ *
+ * Return: Pointer to the channel assigned to the client if successful.
+ *		ERR_PTR for request failure.
+ */
+struct mbox_chan *mbox_request_channel(struct mbox_client *cl)
+{
+	struct mbox_chan *chan;
+	struct mbox_con *con;
+	unsigned long flags;
+	char *con_name;
+	int len, ret;
+
+	con_name = cl->chan_name;
+	len = strcspn(cl->chan_name, ":");
+
+	ret = 0;
+	mutex_lock(&con_mutex);
+	list_for_each_entry(con, &mbox_cons, node)
+		if (!strncmp(con->name, con_name, len)) {
+			ret = 1;
+			break;
+		}
+	mutex_unlock(&con_mutex);
+
+	if (!ret) {
+		pr_info("Channel(%s) not found!\n", cl->chan_name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	ret = 0;
+	list_for_each_entry(chan, &con->channels, node) {
+		if (!chan->cl &&
+				!strcmp(con_name + len + 1, chan->name) &&
+				try_module_get(con->dev->driver->owner)) {
+			spin_lock_irqsave(&chan->lock, flags);
+			chan->msg_free = 0;
+			chan->msg_count = 0;
+			chan->active_req = NULL;
+			chan->cl = cl;
+			if (!cl->tx_tout) /* wait for ever */
+				cl->tx_tout = msecs_to_jiffies(3600000);
+			else
+				cl->tx_tout = msecs_to_jiffies(cl->tx_tout);
+			if (chan->txdone_method	== TXDONE_BY_POLL
+					&& cl->knows_txdone)
+				chan->txdone_method |= TXDONE_BY_ACK;
+			spin_unlock_irqrestore(&chan->lock, flags);
+			ret = 1;
+			break;
+		}
+	}
+
+	if (!ret) {
+		pr_err("Unable to assign mailbox(%s)\n", cl->chan_name);
+		return ERR_PTR(-EBUSY);
+	}
+
+	ret = chan->link_ops->startup(chan->link, cl->link_data);
+	if (ret) {
+		pr_err("Unable to startup the link\n");
+		mbox_free_channel(chan);
+		return ERR_PTR(ret);
+	}
+
+	return chan;
+}
+EXPORT_SYMBOL_GPL(mbox_request_channel);
+
+/**
+ * mbox_free_channel - The client relinquishes control of a mailbox
+ *			channel by this call.
+ * @chan: The mailbox channel to be freed.
+ */
+void mbox_free_channel(struct mbox_chan *chan)
+{
+	unsigned long flags;
+
+	if (!chan || !chan->cl)
+		return;
+
+	chan->link_ops->shutdown(chan->link);
+
+	/* The queued TX requests are simply aborted, no callbacks are made */
+	spin_lock_irqsave(&chan->lock, flags);
+	chan->cl = NULL;
+	chan->active_req = NULL;
+	if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
+		chan->txdone_method = TXDONE_BY_POLL;
+
+	module_put(chan->con->dev->driver->owner);
+
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	blocking_notifier_call_chain(&chan->avail, 0, NULL);
+}
+EXPORT_SYMBOL_GPL(mbox_free_channel);
+
+static struct mbox_chan *name_to_chan(const char *name)
+{
+	struct mbox_chan *chan = NULL;
+	struct mbox_con *con;
+	int len, found = 0;
+
+	len = strcspn(name, ":");
+
+	mutex_lock(&con_mutex);
+
+	list_for_each_entry(con, &mbox_cons, node) {
+		if (!strncmp(con->name, name, len)) {
+			list_for_each_entry(chan, &con->channels, node) {
+				if (!strcmp(name + len + 1, chan->name)) {
+					found = 1;
+					goto done;
+				}
+			}
+		}
+	}
+done:
+	mutex_unlock(&con_mutex);
+
+	if (!found)
+		return NULL;
+
+	return chan;
+}
+
+/**
+ * mbox_notify_chan_register - The client may ask the framework to be
+ *		 notified when a particular channel becomes available
+ *		 to be acquired again.
+ * @name: Name of the mailbox channel the client is interested in.
+ * @nb:	Pointer to the notifier.
+ */
+int mbox_notify_chan_register(const char *name, struct notifier_block *nb)
+{
+	struct mbox_chan *chan = name_to_chan(name);
+
+	if (chan && nb)
+		return blocking_notifier_chain_register(&chan->avail, nb);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(mbox_notify_chan_register);
+
+/**
+ * mbox_notify_chan_unregister - The client is no more interested in channel.
+ *
+ * @name: Name of the mailbox channel the client was interested in.
+ * @nb: Pointer to the notifier.
+ */
+void mbox_notify_chan_unregister(const char *name, struct notifier_block *nb)
+{
+	struct mbox_chan *chan = name_to_chan(name);
+
+	if (chan && nb)
+		blocking_notifier_chain_unregister(&chan->avail, nb);
+}
+EXPORT_SYMBOL_GPL(mbox_notify_chan_unregister);
+
+/**
+ * mbox_controller_register - Register the mailbox controller
+ * @mbox_con:	Pointer to the mailbox controller.
+ *
+ * The controller driver registers its communication links to the
+ * global pool managed by the common framework.
+ */
+int mbox_controller_register(struct mbox_controller *mbox)
+{
+	int i, num_links, txdone;
+	struct mbox_chan *chan;
+	struct mbox_con *con;
+
+	/* Sanity check */
+	if (!mbox || !mbox->ops)
+		return -EINVAL;
+
+	for (i = 0; mbox->links[i]; i++)
+		;
+	if (!i)
+		return -EINVAL;
+	num_links = i;
+
+	mutex_lock(&con_mutex);
+	/* Check if already populated */
+	list_for_each_entry(con, &mbox_cons, node)
+		if (!strcmp(mbox->controller_name, con->name)) {
+			mutex_unlock(&con_mutex);
+			return -EINVAL;
+		}
+
+	con = kzalloc(sizeof(struct mbox_con), GFP_KERNEL);
+	if (!con)
+		return -ENOMEM;
+
+	chan = kzalloc(sizeof(struct mbox_chan) * num_links, GFP_KERNEL);
+	if (!chan) {
+		kfree(con);
+		return -ENOMEM;
+	}
+
+	con->dev = mbox->dev;
+	INIT_LIST_HEAD(&con->channels);
+	snprintf(con->name, 16, "%s", mbox->controller_name);
+
+	if (mbox->txdone_irq)
+		txdone = TXDONE_BY_IRQ;
+	else if (mbox->txdone_poll)
+		txdone = TXDONE_BY_POLL;
+	else /* It has to be ACK then */
+		txdone = TXDONE_BY_ACK;
+
+	if (txdone == TXDONE_BY_POLL) {
+		con->period = mbox->txpoll_period;
+		con->poll.function = &poll_txdone;
+		con->poll.data = (unsigned long)con;
+		init_timer(&con->poll);
+	}
+
+	for (i = 0; i < num_links; i++) {
+		chan[i].con = con;
+		chan[i].cl = NULL;
+		chan[i].link_ops = mbox->ops;
+		chan[i].link = mbox->links[i];
+		chan[i].txdone_method = txdone;
+		chan[i].link->api_priv = &chan[i];
+		spin_lock_init(&chan[i].lock);
+		BLOCKING_INIT_NOTIFIER_HEAD(&chan[i].avail);
+		list_add_tail(&chan[i].node, &con->channels);
+		snprintf(chan[i].name, 16, "%s", mbox->links[i]->link_name);
+	}
+
+	list_add_tail(&con->node, &mbox_cons);
+	mutex_unlock(&con_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mbox_controller_register);
+
+/**
+ * mbox_controller_unregister - UnRegister the mailbox controller
+ * @mbox_con:	Pointer to the mailbox controller.
+ *
+ * Purge the mailbox links from the global pool maintained by the framework.
+ */
+void mbox_controller_unregister(struct mbox_controller *mbox)
+{
+	struct mbox_con *t, *con = NULL;
+	struct mbox_chan *chan;
+
+	mutex_lock(&con_mutex);
+
+	list_for_each_entry(t, &mbox_cons, node)
+		if (!strcmp(mbox->controller_name, t->name)) {
+			con = t;
+			break;
+		}
+
+	if (con)
+		list_del(&con->node);
+
+	mutex_unlock(&con_mutex);
+
+	if (!con)
+		return;
+
+	list_for_each_entry(chan, &con->channels, node)
+		mbox_free_channel(chan);
+
+	del_timer_sync(&con->poll);
+
+	kfree(con);
+}
+EXPORT_SYMBOL_GPL(mbox_controller_unregister);
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
new file mode 100644
index 0000000..44bcb2b
--- /dev/null
+++ b/include/linux/mailbox.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2014 Linaro Ltd.
+ * Author: Jassi Brar <jassisinghbrar@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MAILBOX_H
+#define __MAILBOX_H
+
+enum mbox_result {
+	MBOX_OK = 0,
+	MBOX_ERR,
+};
+
+#endif /* __MAILBOX_H */
diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
new file mode 100644
index 0000000..4954378
--- /dev/null
+++ b/include/linux/mailbox_client.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) 2014 Linaro Ltd.
+ * Author: Jassi Brar <jassisinghbrar@gmail.com>
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
+struct mbox_chan;
+
+/**
+ * struct mbox_client - User of a mailbox
+ * @chan_name:		The "controller:channel" this client wants
+ * @rx_callback:	Atomic callback to provide client the data received
+ * @tx_done:		Atomic callback to tell client of data transmission
+ * @tx_block:		If the mbox_send_message should block until data is
+ *			transmitted.
+ * @tx_tout:		Max block period in ms before TX is assumed failure
+ * @knows_txdone:	if the client could run the TX state machine. Usually
+ *			if the client receives some ACK packet for transmission.
+ *			Unused if the controller already has TX_Done/RTR IRQ.
+ * @link_data:		Optional controller specific parameters during channel
+ *			request.
+ */
+struct mbox_client {
+	char *chan_name;
+	void (*rx_callback)(struct mbox_client *cl, void *mssg);
+	void (*tx_done)(struct mbox_client *cl, void *mssg, enum mbox_result r);
+	bool tx_block;
+	unsigned long tx_tout;
+	bool knows_txdone;
+	void *link_data;
+};
+
+struct mbox_chan *mbox_request_channel(struct mbox_client *cl);
+int mbox_send_message(struct mbox_chan *chan, void *mssg);
+void mbox_client_txdone(struct mbox_chan *chan, enum mbox_result r);
+void mbox_free_channel(struct mbox_chan *chan);
+int mbox_notify_chan_register(const char *name, struct notifier_block *nb);
+void mbox_notify_chan_unregister(const char *name, struct notifier_block *nb);
+
+#endif /* __MAILBOX_CLIENT_H */
diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
new file mode 100644
index 0000000..5ff22c6
--- /dev/null
+++ b/include/linux/mailbox_controller.h
@@ -0,0 +1,85 @@
+/*
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
+ * struct mbox_link - s/w representation of a communication link
+ * @link_name:	Literal name assigned to the link. Physically
+ *		identical channels may have the same name.
+ * @api_priv:	Hook for the API to map its private data on the link
+ *		Controller driver must not touch it.
+ */
+struct mbox_link {
+	char link_name[16];
+	void *api_priv;
+};
+
+/**
+ * struct mbox_link - s/w representation of a communication link
+ * @send_data:	The API asks the MBOX controller driver, in atomic
+ *		context try to transmit a message on the bus. Returns 0 if
+ *		data is accepted for transmission, -EBUSY while rejecting
+ *		if the remote hasn't yet read the last data sent. Actual
+ *		transmission of data is reported by the controller via
+ *		mbox_link_txdone (if it has some TX ACK irq). It must not
+ *		block.
+ * @startup:	Called when a client requests the link. The controller
+ *		could ask clients for additional parameters of communication
+ *		to be provided via client's link_data. This call may
+ *		block. After this call the Controller must forward any
+ *		data received on the link by calling mbox_link_received_data.
+ * @shutdown:	Called when a client relinquishes control of a link.
+ *		This call may block too. The controller must not forwared
+ *		any received data anymore.
+ * @last_tx_done: If the controller sets 'txdone_poll', the API calls
+ *		  this to poll status of last TX. The controller must
+ *		  give priority to IRQ method over polling and never
+ *		  set both txdone_poll and txdone_irq. Only in polling
+ *		  mode 'send_data' is expected to return -EBUSY.
+ *		  Used only if txdone_poll:=true && txdone_irq:=false
+ */
+struct mbox_link_ops {
+	int (*send_data)(struct mbox_link *link, void *data);
+	int (*startup)(struct mbox_link *link, void *params);
+	void (*shutdown)(struct mbox_link *link);
+	bool (*last_tx_done)(struct mbox_link *link);
+};
+
+/**
+ * struct mbox_controller - Controller of a class of communication links
+ * @dev:		Device backing this controller
+ * @controller_name:	Literal name of the controller.
+ * @ops:		Operators that work on each communication link
+ * @links:		Null terminated array of links.
+ * @txdone_irq:		Indicates if the controller can report to API when
+ *			the last transmitted data was read by the remote.
+ *			Eg, if it has some TX ACK irq.
+ * @txdone_poll:	If the controller can read but not report the TX
+ *			done. Ex, some register shows the TX status but
+ *			no interrupt rises. Ignored if 'txdone_irq' is set.
+ * @txpoll_period:	If 'txdone_poll' is in effect, the API polls for
+ *			last TX's status after these many millisecs
+ */
+struct mbox_controller {
+	struct device *dev;
+	char controller_name[16];
+	struct mbox_link_ops *ops;
+	struct mbox_link **links;
+	bool txdone_irq;
+	bool txdone_poll;
+	unsigned txpoll_period;
+};
+
+int mbox_controller_register(struct mbox_controller *mbox);
+void mbox_link_received_data(struct mbox_link *link, void *data);
+void mbox_link_txdone(struct mbox_link *link, enum mbox_result r);
+void mbox_controller_unregister(struct mbox_controller *mbox);
+
+#endif /* __MAILBOX_CONTROLLER_H */
-- 
1.8.1.2

