Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaGWIy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:54:26 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:54962 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbaGWIyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:54:20 -0400
Date: Wed, 23 Jul 2014 09:54:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ks.giri@samsung.com, arnd@arndb.de, ijc@hellion.org.uk,
        mark.rutland@arm.com, robh@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, t.takinishi@jp.fujitsu.com, broonie@linaro.org,
        khilman@linaro.org, mollie.wu@linaro.org, andy.green@linaro.org
Subject: Re: [PATCHv9 2/4] mailbox: Introduce framework for mailbox
Message-ID: <20140723085411.GG23210@lee--X1>
References: <1406055250-29159-1-git-send-email-jaswinder.singh@linaro.org>
 <1406055374-29275-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406055374-29275-1-git-send-email-jaswinder.singh@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Jassi Brar wrote:
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
> 
> Client driver developers should have a look at
>  include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h
> 
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
>  MAINTAINERS                        |   8 +
>  drivers/mailbox/Makefile           |   4 +
>  drivers/mailbox/mailbox.c          | 467 +++++++++++++++++++++++++++++++++++++
>  include/linux/mailbox_client.h     |  45 ++++
>  include/linux/mailbox_controller.h | 131 +++++++++++
>  5 files changed, 655 insertions(+)
>  create mode 100644 drivers/mailbox/mailbox.c
>  create mode 100644 include/linux/mailbox_client.h
>  create mode 100644 include/linux/mailbox_controller.h

After a _quick_ look through:

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61a8f48..9f225d2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5672,6 +5672,14 @@ S:	Maintained
>  F:	drivers/net/macvlan.c
>  F:	include/linux/if_macvlan.h
>  
> +MAILBOX API
> +M:	Jassi Brar <jassisinghbrar@gmail.com>

Gmail?

> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	drivers/mailbox/
> +F:	include/linux/mailbox_client.h
> +F:	include/linux/mailbox_controller.h
> +

[...]

> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> new file mode 100644
> index 0000000..99c0d23
> --- /dev/null
> +++ b/drivers/mailbox/mailbox.c
> @@ -0,0 +1,467 @@
> +/*
> + * Mailbox: Common code for Mailbox controllers and users
> + *
> + * Copyright (C) 2013-2014 Linaro Ltd.
> + * Author: Jassi Brar <jassisinghbrar@gmail.com>

(C) Linaro, but you've supplied your Gmail?

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/mailbox_client.h>
> +#include <linux/mailbox_controller.h>
> +
> +#define TXDONE_BY_IRQ	(1 << 0) /* controller has remote RTR irq */
> +#define TXDONE_BY_POLL	(1 << 1) /* controller can read status of last TX */
> +#define TXDONE_BY_ACK	(1 << 2) /* S/W ACK recevied by Client ticks the TX */

BIT(0), BIT(1), BIT(2).

> +static LIST_HEAD(mbox_cons);
> +static DEFINE_MUTEX(con_mutex);
> +
> +static int add_to_rbuf(struct mbox_chan *chan, void *mssg)
> +{
> +	int idx;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	/* See if there is any space left */
> +	if (chan->msg_count == MBOX_TX_QUEUE_LEN) {
> +		spin_unlock_irqrestore(&chan->lock, flags);
> +		return -ENOMEM;

Doesn't -ENOMEM signify out-of-system-memory, rather than a buffer has
been filled?  I'm thinking ENOBUFS would be more appropriate.

> +	}
> +
> +	idx = chan->msg_free;
> +	chan->msg_data[idx] = mssg;
> +	chan->msg_count++;
> +
> +	if (idx == MBOX_TX_QUEUE_LEN - 1)
> +		chan->msg_free = 0;
> +	else
> +		chan->msg_free++;
> +
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +
> +	return idx;
> +}
> +
> +static void msg_submit(struct mbox_chan *chan)
> +{
> +	unsigned count, idx;
> +	unsigned long flags;
> +	void *data;
> +	int err;
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	if (!chan->msg_count || chan->active_req) {
> +		spin_unlock_irqrestore(&chan->lock, flags);
> +		return;
> +	}

You could reduce by a line here if you use a goto, to jump down to the
other spin_unlock*().

> +	count = chan->msg_count;
> +	idx = chan->msg_free;
> +	if (idx >= count)
> +		idx -= count;
> +	else
> +		idx += MBOX_TX_QUEUE_LEN - count;
> +
> +	data = chan->msg_data[idx];
> +
> +	/* Try to submit a message to the MBOX controller */
> +	err = chan->mbox->ops->send_data(chan, data);
> +	if (!err) {
> +		chan->active_req = data;
> +		chan->msg_count--;
> +	}

How do we let the caller know if an error occured?

> +	spin_unlock_irqrestore(&chan->lock, flags);
> +}

[...]

> +static void poll_txdone(unsigned long data)
> +{
> +	struct mbox_controller *mbox = (struct mbox_controller *)data;
> +	bool txdone, resched = false;
> +	int i;
> +
> +	for (i = 0; i < mbox->num_chans; i++) {
> +		struct mbox_chan *chan = &mbox->chans[i];
> +
> +		if (chan->active_req && chan->cl) {
> +			resched = true;
> +			txdone = chan->mbox->ops->last_tx_done(chan);

You should probably add a comment somewhere that this operation is
compulsory.  Same for all of the other mandatory call-backs.

> +			if (txdone)
> +				tx_tick(chan, 0);
> +		}
> +	}
> +
> +	if (resched)
> +		mod_timer(&mbox->poll, jiffies +
> +				msecs_to_jiffies(mbox->period));
> +}

[...]

> +/**
> + * mbox_send_message -	For client to submit a message to be
> + *				sent to the remote.
> + * @chan: Mailbox channel assigned to this client.
> + * @mssg: Client specific message typecasted.
> + *
> + * For client to submit data to the controller destined for a remote
> + * processor. If the client had set 'tx_block', the call will return
> + * either when the remote receives the data or when 'tx_tout' millisecs
> + * run out.
> + *  In non-blocking mode, the requests are buffered by the API and a
> + * non-negative token is returned for each queued request. If the request
> + * is not queued, a negative token is returned. Upon failure or successful
> + * TX, the API calls 'tx_done' from atomic context, from which the client
> + * could submit yet another request.
> + * The pointer to message should be preserved until it is sent
> + * over the chan, i.e, tx_done() is made.
> + * This function could be called from atomic context as it simply
> + * queues the data and returns a token against the request.
> + *
> + * Return: Non-negative integer for successful submission (non-blocking mode)
> + *	or transmission over chan (blocking mode).
> + *	Negative value denotes failure.
> + */
> +int mbox_send_message(struct mbox_chan *chan, void *mssg)
> +{
> +	int t;
> +
> +	if (!chan || !chan->cl)
> +		return -EINVAL;
> +
> +	t = add_to_rbuf(chan, mssg);
> +	if (t < 0) {
> +		pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");

Really?

> +		return t;
> +	}
> +
> +	msg_submit(chan);
> +
> +	reinit_completion(&chan->tx_complete);
> +
> +	if (chan->txdone_method	== TXDONE_BY_POLL)
> +		poll_txdone((unsigned long)chan->mbox);
> +
> +	if (chan->cl->tx_block && chan->active_req) {
> +		unsigned long wait;
> +		int ret;
> +
> +		if (!chan->cl->tx_tout) /* wait for ever */

s/for ever/forever

> +			wait = msecs_to_jiffies(3600000);

What will this do?  Will it block the system forever?

> +		else
> +			wait = msecs_to_jiffies(chan->cl->tx_tout);
> +
> +		ret = wait_for_completion_timeout(&chan->tx_complete, wait);
> +		if (ret == 0) {
> +			t = -EIO;
> +			tx_tick(chan, -EIO);
> +		}
> +	}
> +
> +	return t;
> +}
> +EXPORT_SYMBOL_GPL(mbox_send_message);
> +
> +/**
> + * mbox_request_channel - Request a mailbox channel.
> + * @cl: Identity of the client requesting the channel.
> + * @index: Index of mailbox specifier in 'mboxes' property.
> + *
> + * The Client specifies its requirements and capabilities while asking for
> + * a mailbox channel. It can't be called from atomic context.
> + * The channel is exclusively allocated and can't be used by another
> + * client before the owner calls mbox_free_channel.
> + * After assignment, any packet received on this channel will be
> + * handed over to the client via the 'rx_callback'.
> + * The framework holds reference to the client, so the mbox_client
> + * structure shouldn't be modified until the mbox_free_channel returns.
> + *
> + * Return: Pointer to the channel assigned to the client if successful.
> + *		ERR_PTR for request failure.
> + */
> +struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
> +{
> +	struct device *dev = cl->dev;
> +	struct mbox_controller *mbox;
> +	struct of_phandle_args spec;
> +	struct mbox_chan *chan;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (!dev || !dev->of_node) {
> +		pr_debug("%s: No owner device node\n", __func__);

Are you sure you want all of this debug prints in the final version?

> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	mutex_lock(&con_mutex);
> +
> +	if (of_parse_phandle_with_args(dev->of_node, "mboxes",
> +				       "#mbox-cells", index, &spec)) {
> +		pr_debug("%s: can't parse \"mboxes\" property\n", __func__);

How you have a 'struct device' to play with, can't you use dev_dbg()
and friends?

> +		mutex_unlock(&con_mutex);
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	chan = NULL;

Do this during declaration.

> +	list_for_each_entry(mbox, &mbox_cons, node)
> +		if (mbox->dev->of_node == spec.np) {
> +			chan = mbox->of_xlate(mbox, &spec);
> +			break;
> +		}
> +
> +	of_node_put(spec.np);
> +
> +	if (!chan || chan->cl || !try_module_get(mbox->dev->driver->owner)) {
> +		pr_debug("%s: mailbox not free\n", __func__);
> +		mutex_unlock(&con_mutex);
> +		return ERR_PTR(-EBUSY);
> +	}
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +	chan->msg_free = 0;
> +	chan->msg_count = 0;
> +	chan->active_req = NULL;
> +	chan->cl = cl;
> +	init_completion(&chan->tx_complete);
> +
> +	if (chan->txdone_method	== TXDONE_BY_POLL && cl->knows_txdone)
> +		chan->txdone_method |= TXDONE_BY_ACK;
> +
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +
> +	ret = chan->mbox->ops->startup(chan);
> +	if (ret) {
> +		pr_err("Unable to startup the chan (%d)\n", ret);
> +		mbox_free_channel(chan);
> +		chan = ERR_PTR(ret);
> +	}
> +
> +	mutex_unlock(&con_mutex);
> +	return chan;
> +}
> +EXPORT_SYMBOL_GPL(mbox_request_channel);
> +
> +/**
> + * mbox_free_channel - The client relinquishes control of a mailbox
> + *			channel by this call.
> + * @chan: The mailbox channel to be freed.
> + */
> +void mbox_free_channel(struct mbox_chan *chan)
> +{
> +	unsigned long flags;
> +
> +	if (!chan || !chan->cl)
> +		return;
> +
> +	chan->mbox->ops->shutdown(chan);
> +
> +	/* The queued TX requests are simply aborted, no callbacks are made */
> +	spin_lock_irqsave(&chan->lock, flags);
> +	chan->cl = NULL;
> +	chan->active_req = NULL;
> +	if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
> +		chan->txdone_method = TXDONE_BY_POLL;

Unless you're leaving it there for clarity, you can drop the
"TXDONE_BY_POLL |" from if().

> +	module_put(chan->mbox->dev->driver->owner);
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(mbox_free_channel);
> +
> +static struct mbox_chan *
> +of_mbox_index_xlate(struct mbox_controller *mbox,
> +		    const struct of_phandle_args *sp)
> +{
> +	int ind = sp->args[0];
> +
> +	if (ind >= mbox->num_chans)
> +		return NULL;
> +
> +	return &mbox->chans[ind];
> +}
> +
> +/**
> + * mbox_controller_register - Register the mailbox controller
> + * @mbox:	Pointer to the mailbox controller.
> + *
> + * The controller driver registers its communication channels
> + */
> +int mbox_controller_register(struct mbox_controller *mbox)
> +{
> +	int i, txdone;
> +
> +	/* Sanity check */
> +	if (!mbox || !mbox->dev || !mbox->ops || !mbox->num_chans)
> +		return -EINVAL;
> +
> +	if (mbox->txdone_irq)
> +		txdone = TXDONE_BY_IRQ;
> +	else if (mbox->txdone_poll)
> +		txdone = TXDONE_BY_POLL;
> +	else /* It has to be ACK then */
> +		txdone = TXDONE_BY_ACK;
> +
> +	if (txdone == TXDONE_BY_POLL) {
> +		mbox->poll.function = &poll_txdone;
> +		mbox->poll.data = (unsigned long)mbox;
> +		init_timer(&mbox->poll);
> +	}

Can't you put this in the statement above?

> +	for (i = 0; i < mbox->num_chans; i++) {
> +		struct mbox_chan *chan = &mbox->chans[i];
> +
> +		chan->cl = NULL;
> +		chan->mbox = mbox;
> +		chan->txdone_method = txdone;
> +		spin_lock_init(&chan->lock);
> +	}
> +
> +	if (!mbox->of_xlate)
> +		mbox->of_xlate = of_mbox_index_xlate;
> +
> +	mutex_lock(&con_mutex);
> +	list_add_tail(&mbox->node, &mbox_cons);
> +	mutex_unlock(&con_mutex);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(mbox_controller_register);
> +
> +/**
> + * mbox_controller_unregister - Unregister the mailbox controller
> + * @mbox:	Pointer to the mailbox controller.
> + */
> +void mbox_controller_unregister(struct mbox_controller *mbox)
> +{
> +	int i;
> +
> +	if (!mbox)
> +		return;
> +
> +	mutex_lock(&con_mutex);
> +
> +	list_del(&mbox->node);
> +
> +	for (i = 0; i < mbox->num_chans; i++)
> +		mbox_free_channel(&mbox->chans[i]);
> +
> +	if (mbox->txdone_poll)
> +		del_timer_sync(&mbox->poll);
> +
> +	mutex_unlock(&con_mutex);
> +}
> +EXPORT_SYMBOL_GPL(mbox_controller_unregister);
> diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
> new file mode 100644
> index 0000000..0f8cba6
> --- /dev/null
> +++ b/include/linux/mailbox_client.h
> @@ -0,0 +1,45 @@
> +/*
> + * Copyright (C) 2013-2014 Linaro Ltd.
> + * Author: Jassi Brar <jassisinghbrar@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MAILBOX_CLIENT_H
> +#define __MAILBOX_CLIENT_H
> +
> +#include <linux/of.h>

device.h

> +struct mbox_chan;
> +
> +/**
> + * struct mbox_client - User of a mailbox
> + * @dev:		The client device
> + * @tx_block:		If the mbox_send_message should block until data is
> + *			transmitted.
> + * @tx_tout:		Max block period in ms before TX is assumed failure
> + * @knows_txdone:	If the client could run the TX state machine. Usually
> + *			if the client receives some ACK packet for transmission.
> + *			Unused if the controller already has TX_Done/RTR IRQ.
> + * @rx_callback:	Atomic callback to provide client the data received
> + * @tx_done:		Atomic callback to tell client of data transmission
> + */
> +struct mbox_client {
> +	struct device *dev;
> +	bool tx_block;
> +	unsigned long tx_tout;
> +	bool knows_txdone;
> +
> +	void (*rx_callback)(struct mbox_client *cl, void *mssg);
> +	void (*tx_done)(struct mbox_client *cl, void *mssg, int r);
> +};
> +
> +struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index);
> +int mbox_send_message(struct mbox_chan *chan, void *mssg);
> +void mbox_client_txdone(struct mbox_chan *chan, int r); /* atomic */
> +bool mbox_client_peek_data(struct mbox_chan *chan); /* atomic */
> +void mbox_free_channel(struct mbox_chan *chan); /* may sleep */
> +
> +#endif /* __MAILBOX_CLIENT_H */
> diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
> new file mode 100644
> index 0000000..976c4ed
> --- /dev/null
> +++ b/include/linux/mailbox_controller.h
> @@ -0,0 +1,131 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MAILBOX_CONTROLLER_H
> +#define __MAILBOX_CONTROLLER_H
> +
> +#include <linux/of.h>

completion.h
device.h
timer.h

Etc.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
