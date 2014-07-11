Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaGKLrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:47:01 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60351 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaGKLq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:46:59 -0400
MIME-Version: 1.0
In-Reply-To: <1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org>
	<1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org>
Date: Fri, 11 Jul 2014 12:46:53 +0100
Message-ID: <CAJ5Y-eYPffYQ57ERODyBYYKjL2FVhGapKmP0YxzcT9rswfaJaA@mail.gmail.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, ijc+devicetree@hellion.org.uk,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>, "Anna, Suman" <s-anna@ti.com>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        Mollie.Wu@tw.fujitsu.com, t.takinishi@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

Other than a few nits, this looks good to me.

On 11 July 2014 10:35, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
>
> Client driver developers should have a look at
>  include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h

I think its a better idea to refer to the Documentation/mailbox.txt
instead of these headers. You already have references to the headers
in the Doc.

>
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
>  .../devicetree/bindings/mailbox/mailbox.txt        |  33 ++
>  Documentation/mailbox.txt                          | 107 +++++
>  MAINTAINERS                                        |   8 +
>  drivers/mailbox/Makefile                           |   4 +
>  drivers/mailbox/mailbox.c                          | 490 +++++++++++++++++++++
>  include/linux/mailbox_client.h                     |  48 ++
>  include/linux/mailbox_controller.h                 | 128 ++++++
>  7 files changed, 818 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt
>  create mode 100644 Documentation/mailbox.txt
>  create mode 100644 drivers/mailbox/mailbox.c
>  create mode 100644 include/linux/mailbox_client.h
>  create mode 100644 include/linux/mailbox_controller.h
>
> diff --git a/Documentation/devicetree/bindings/mailbox/mailbox.txt b/Documentation/devicetree/bindings/mailbox/mailbox.txt
> new file mode 100644
> index 0000000..3f00955
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mailbox/mailbox.txt
> @@ -0,0 +1,33 @@
> +* Generic Mailbox Controller and client driver bindings
> +
> +Generic binding to provide a way for Mailbox controller drivers to
> +assign appropriate mailbox channel to client drivers.
> +
> +* Mailbox Controller
> +
> +Required property:
> +- #mbox-cells: Must be at least 1. Number of cells in a mailbox
> +               specifier.
> +
> +Example:
> +       mailbox: mailbox {
> +               ...
> +               #mbox-cells = <1>;
> +       };
> +
> +
> +* Mailbox Client
> +
> +Required property:
> + mbox: List of phandle and mailbox channel specifier.
> +
> +- mbox-names: List of identifier strings for each mailbox channel
> +               required by the client.
> +
> +Example:
> +       pwr_cntrl: power {
> +               ...
> +               mbox-names = "pwr-ctrl", "rpc";
> +               mbox = <&mailbox 0
> +                       &mailbox 1>;
> +       };
> diff --git a/Documentation/mailbox.txt b/Documentation/mailbox.txt
> new file mode 100644
> index 0000000..0a11183
> --- /dev/null
> +++ b/Documentation/mailbox.txt
> @@ -0,0 +1,107 @@
> +               The Common Mailbox Framework
> +               Jassi Brar <jaswinder.singh@linaro.org>
> +
> + This document aims to help developers write client and controller
> +drivers for the API. But before we start, let us note that the
> +client (especially) and controller drivers are likely going to be
> +very platform specific because the remote firmware is likely to be
> +proprietary and implement non-standard protocol. So even if two
> +platforms employ, say, PL320 controller, the client drivers can't
> +be shared across them. Even the PL320 driver might need to accomodate

s/accomodate/accommodate/

> +some platform specific quirks. So the API is meant mainly to avoid
> +similar copies of code written for each platform.
> + Some of the choices made during implementation are the result of this
> +peculiarity of this "common" framework.

I'd just skip the last sentence.

> +
> +
> +
> +       Part 1 - Controller Driver (See include/linux/mailbox_controller.h)

[..]

> +
> + Allocate mbox_controller and the array of mbox_chan.
> +Populate mbox_chan_ops, except peek_data() all are mandatory.
> +The controller driver might know a message has been consumed
> +by the remote by getting an IRQ or polling some hardware flag
> +or it can never know (the client knows by way of the protocol).
> +The method in order of preference is IRQ -> Poll -> None, which
> +the controller driver should set via 'txdone_irq' or 'txdone_poll'
> +or neither.

Including the header definition above the text would help to keep it in context.
Same thing for the Client side.

> +
> +
> +       Part 2 - Client Driver (See include/linux/mailbox_client.h)
> +
> + The client might want to operate in blocking mode (synchronously
> +send a message through before returning) or non-blocking/async mode (submit
> +a message and a callback function to the API and return immediately).
> +
> +
> +static struct mbox_chan *ch_async, *ch_blk;
> +static struct mbox_client cl_async, cl_blk;
> +static struct completion c_aysnc;
> +
> +/*
> + * This is the handler for data received from remote. The behaviour is purely
> + * dependent upon the protocol. This is just an example.
> + */
> +static void message_from_remote(struct mbox_client *cl, void *mssg)
> +{
> +       if (cl == &cl_async) {
> +               if (is_an_ack(mssg)) {
> +                       /* An ACK to our last sample sent */
> +                       return; /* Or do something else here */
> +               } else { /* A new message from remote */
> +                       queue_req(mssg);
> +               }
> +       } else {
> +               /* Remote f/w sends only ACK packets on this channel */
> +               return;
> +       }
> +}
> +
> +static void sample_sent(struct mbox_client *cl, void *mssg, int r)
> +{
> +       complete(&c_aysnc);
> +}
> +
> +static int client_demo(struct platform_device *pdev)
> +{
> +       /* The controller already knows async_pkt and sync_pkt */
> +       struct async_pkt ap;
> +       struct sync_pkt sp;
> +
> +       /* Populate non-blocking mode client */
> +       cl_async.dev = &pdev->dev;
> +       cl_async.chan_name = "send_sample"; /* Mainly to send random samples */
> +       cl_async.rx_callback = message_from_remote;
> +       cl_async.tx_done = sample_sent;
> +       cl_async.tx_block = false;
> +       cl_async.tx_tout = 0; /* doesn't matter here */
> +       cl_async.knows_txdone = false; /* depending upon protocol */
> +       init_completion(&c_aysnc);
> +
> +       /* Populate blocking mode client */
> +       cl_blk.dev = &pdev->dev;
> +       cl_blk.chan_name = "send_request"; /* Ask remote to do stuff */
> +       cl_blk.rx_callback = message_from_remote;
> +       cl_blk.tx_done = NULL; /* operate in blocking mode */
> +       cl_blk.tx_block = true;
> +       cl_blk.tx_tout = 500; /* by half a second */
> +       cl_blk.knows_txdone = false; /* depending upon protocol */
> +
> +       /* Request channel for async comm. */
> +       ch_async = mbox_request_channel(&cl_async);
> +       /* Populate data packet */
> +       /* ap.xxx = 123; etc */
> +       /* Send async message to remote */
> +       mbox_send_message(ch_async, &ap);
> +
> +       /* Continue to request channel for sync comm. */
> +       ch_blk = mbox_request_channel(&cl_blk);
> +       /* Populate data packet */
> +       /* sp.abc = 123; etc */
> +       /* Send message to remote in blocking mode */
> +       mbox_send_message(ch_blk, &sp);
> +       /* At this point 'sp' has been sent */
> +
> +       /* Now wait for async chan to be done */
> +       wait_for_completion(&c_aysnc);
> +}
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c411c40..bc8f0a1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5660,6 +5660,14 @@ S:       Maintained
>  F:     drivers/net/macvlan.c
>  F:     include/linux/if_macvlan.h
>
> +MAILBOX API
> +M:     Jassi Brar <jassisinghbrar@gmail.com>
> +L:     linux-kernel@vger.kernel.org
> +S:     Maintained
> +F:     drivers/mailbox/
> +F:     include/linux/mailbox_client.h
> +F:     include/linux/mailbox_controller.h
> +
>  MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
>  M:     Michael Kerrisk <mtk.manpages@gmail.com>
>  W:     http://www.kernel.org/doc/man-pages
> diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
> index e0facb3..2fa343a 100644
> --- a/drivers/mailbox/Makefile
> +++ b/drivers/mailbox/Makefile
> @@ -1,3 +1,7 @@
> +# Generic MAILBOX API
> +
> +obj-$(CONFIG_MAILBOX)          += mailbox.o
> +
>  obj-$(CONFIG_PL320_MBOX)       += pl320-ipc.o
>
>  obj-$(CONFIG_OMAP_MBOX)                += omap-mailbox.o
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> new file mode 100644
> index 0000000..2ca39c1
> --- /dev/null
> +++ b/drivers/mailbox/mailbox.c
> @@ -0,0 +1,490 @@
> +/*
> + * Mailbox: Common code for Mailbox controllers and users
> + *
> + * Copyright (C) 2014-2013 Linaro Ltd.
> + * Author: Jassi Brar <jassisinghbrar@gmail.com>
> + *
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
> +#define TXDONE_BY_IRQ  (1 << 0) /* controller has remote RTR irq */
> +#define TXDONE_BY_POLL (1 << 1) /* controller can read status of last TX */
> +#define TXDONE_BY_ACK  (1 << 2) /* S/W ACK recevied by Client ticks the TX */
> +
> +static LIST_HEAD(mbox_cons);
> +static DEFINE_MUTEX(con_mutex);
> +
> +static int _add_to_rbuf(struct mbox_chan *chan, void *mssg)
> +{
> +       int idx;

unsigned int idx;

> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +
> +       /* See if there is any space left */
> +       if (chan->msg_count == MBOX_TX_QUEUE_LEN) {
> +               spin_unlock_irqrestore(&chan->lock, flags);
> +               return -ENOMEM;
> +       }
> +
> +       idx = chan->msg_free;
> +       chan->msg_data[idx] = mssg;
> +       chan->msg_count++;
> +
> +       if (idx == MBOX_TX_QUEUE_LEN - 1)
> +               chan->msg_free = 0;
> +       else
> +               chan->msg_free++;
> +
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +
> +       return idx;
> +}
> +
> +static void _msg_submit(struct mbox_chan *chan)
> +{
> +       unsigned count, idx;
> +       unsigned long flags;
> +       void *data;
> +       int err;
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +
> +       if (!chan->msg_count || chan->active_req) {
> +               spin_unlock_irqrestore(&chan->lock, flags);
> +               return;
> +       }
> +
> +       count = chan->msg_count;
> +       idx = chan->msg_free;
> +       if (idx >= count)
> +               idx -= count;
> +       else
> +               idx += MBOX_TX_QUEUE_LEN - count;
> +
> +       data = chan->msg_data[idx];
> +
> +       /* Try to submit a message to the MBOX controller */
> +       err = chan->mbox->ops->send_data(chan, data);
> +       if (!err) {
> +               chan->active_req = data;
> +               chan->msg_count--;
> +       }
> +
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +
> +static void tx_tick(struct mbox_chan *chan, int r)
> +{
> +       unsigned long flags;
> +       void *mssg;
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +       mssg = chan->active_req;
> +       chan->active_req = NULL;
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +
> +       /* Submit next message */
> +       _msg_submit(chan);
> +
> +       /* Notify the client */
> +       if (mssg && chan->cl->tx_done)
> +               chan->cl->tx_done(chan->cl, mssg, r);
> +
> +       if (chan->cl->tx_block)
> +               complete(&chan->tx_complete);
> +}
> +
> +static void poll_txdone(unsigned long data)
> +{
> +       struct mbox_controller *mbox = (struct mbox_controller *)data;
> +       bool txdone, resched = false;
> +       int i;
> +
> +       for (i = 0; i < mbox->num_chans; i++) {
> +               struct mbox_chan *chan = &mbox->chans[i];
> +
> +               if (chan->active_req && chan->cl) {
> +                       resched = true;
> +                       txdone = chan->mbox->ops->last_tx_done(chan);
> +                       if (txdone)
> +                               tx_tick(chan, 0);
> +               }
> +       }
> +
> +       if (resched)
> +               mod_timer(&mbox->poll, jiffies +
> +                               msecs_to_jiffies(mbox->period));
> +}
> +
> +/**
> + * mbox_chan_received_data - A way for controller driver to push data
> + *                             received from remote to the upper layer.
> + * @chan: Pointer to the mailbox channel on which RX happened.
> + * @mssg: Client specific message typecasted as void *
> + *
> + * After startup and before shutdown any data received on the chan
> + * is passed on to the API via atomic mbox_chan_received_data().
> + * The controller should ACK the RX only after this call returns.
> + */
> +void mbox_chan_received_data(struct mbox_chan *chan, void *mssg)
> +{
> +       /* No buffering the received data */
> +       if (chan->cl->rx_callback)
> +               chan->cl->rx_callback(chan->cl, mssg);
> +}
> +EXPORT_SYMBOL_GPL(mbox_chan_received_data);
> +
> +/**
> + * mbox_chan_txdone - A way for controller driver to notify the
> + *                     framework that the last TX has completed.
> + * @chan: Pointer to the mailbox chan on which TX happened.
> + * @r: Status of last TX - OK or ERROR
> + *
> + * The controller that has IRQ for TX ACK calls this atomic API
> + * to tick the TX state machine. It works only if txdone_irq
> + * is set by the controller.
> + */
> +void mbox_chan_txdone(struct mbox_chan *chan, int r)
> +{
> +       if (unlikely(!(chan->txdone_method & TXDONE_BY_IRQ))) {
> +               pr_err("Controller can't run the TX ticker\n");
> +               return;
> +       }
> +
> +       tx_tick(chan, r);
> +}
> +EXPORT_SYMBOL_GPL(mbox_chan_txdone);
> +
> +/**
> + * mbox_client_txdone - The way for a client to run the TX state machine.
> + * @chan: Mailbox channel assigned to this client.
> + * @r: Success status of last transmission.

"r" is a bit terse. Why not stat/status?

> + *
> + * The client/protocol had received some 'ACK' packet and it notifies
> + * the API that the last packet was sent successfully. This only works
> + * if the controller can't sense TX-Done.
> + */
> +void mbox_client_txdone(struct mbox_chan *chan, int r)
> +{
> +       if (unlikely(!(chan->txdone_method & TXDONE_BY_ACK))) {
> +               pr_err("Client can't run the TX ticker\n");
> +               return;
> +       }
> +
> +       tx_tick(chan, r);
> +}
> +EXPORT_SYMBOL_GPL(mbox_client_txdone);
> +
> +/**
> + * mbox_client_peek_data - A way for client driver to pull data
> + *                     received from remote by the controller.
> + * @chan: Mailbox channel assigned to this client.
> + *
> + * A poke to controller driver for any received data.
> + * The data is actually passed onto client via the
> + * mbox_chan_received_data()
> + * The call can be made from atomic context, so the controller's
> + * implementation of peek_data() must not sleep.
> + *
> + * Return: True, if controller has, and is going to push after this,
> + *          some data.
> + *         False, if controller doesn't have any data to be read.
> + */
> +bool mbox_client_peek_data(struct mbox_chan *chan)
> +{
> +       if (chan->mbox->ops->peek_data)
> +               return chan->mbox->ops->peek_data(chan);
> +
> +       return false;
> +}
> +EXPORT_SYMBOL_GPL(mbox_client_peek_data);
> +
> +/**
> + * mbox_send_message - For client to submit a message to be
> + *                             sent to the remote.
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
> + *  In blocking mode, 'tx_done' is not called, effectively making the
> + * queue length 1.
> + * The pointer to message should be preserved until it is sent
> + * over the chan, i.e, tx_done() is made.
> + * This function could be called from atomic context as it simply
> + * queues the data and returns a token against the request.
> + *
> + * Return: Non-negative integer for successful submission (non-blocking mode)
> + *     or transmission over chan (blocking mode).
> + *     Negative value denotes failure.
> + */
> +int mbox_send_message(struct mbox_chan *chan, void *mssg)
> +{
> +       int t;

int ret;

> +
> +       if (!chan || !chan->cl)
> +               return -EINVAL;
> +
> +       t = _add_to_rbuf(chan, mssg);

Why do you have these "_" prefixes? Seems inconsistent with some of
the other functions in this file which aren't exported. I'd skip the
prefix.

> +       if (t < 0) {
> +               pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
> +               return t;
> +       }
> +
> +       _msg_submit(chan);

Same here.

> +
> +       reinit_completion(&chan->tx_complete);
> +
> +       if (chan->txdone_method == TXDONE_BY_POLL)
> +               poll_txdone((unsigned long)chan->mbox);
> +
> +       if (chan->cl->tx_block && chan->active_req) {
> +               unsigned long wait;
> +               int ret;
> +
> +               if (!chan->cl->tx_tout) /* wait for ever */
> +                       wait = msecs_to_jiffies(3600000);
> +               else
> +                       wait = msecs_to_jiffies(chan->cl->tx_tout);
> +
> +               ret = wait_for_completion_timeout(&chan->tx_complete, wait);
> +               if (ret == 0) {
> +                       t = -EIO;
> +                       tx_tick(chan, -EIO);
> +               }
> +       }
> +
> +       return t;
> +}
> +EXPORT_SYMBOL_GPL(mbox_send_message);
> +
> +/**
> + * mbox_request_channel - Request a mailbox channel.
> + * @cl: Identity of the client requesting the channel.
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
> + *             ERR_PTR for request failure.
> + */
> +struct mbox_chan *mbox_request_channel(struct mbox_client *cl)
> +{
> +       struct device *dev = cl->dev;
> +       struct mbox_controller *mbox;
> +       struct of_phandle_args spec;
> +       struct mbox_chan *chan;
> +       unsigned long flags;
> +       int count, i, ret;
> +
> +       if (!dev || !dev->of_node) {
> +               pr_debug("%s: No owner device node\n", __func__);
> +               return ERR_PTR(-ENODEV);
> +       }
> +
> +       count = of_property_count_strings(dev->of_node, "mbox-names");
> +       if (count < 0) {
> +               pr_err("%s: mbox-names property of node '%s' missing\n",
> +                      __func__, dev->of_node->full_name);
> +               return ERR_PTR(-ENODEV);
> +       }
> +
> +       mutex_lock(&con_mutex);
> +
> +       ret = -ENODEV;
> +       for (i = 0; i < count; i++) {
> +               const char *s;
> +
> +               if (of_property_read_string_index(dev->of_node,
> +                                                 "mbox-names", i, &s))
> +                       continue;
> +
> +               if (strcmp(cl->chan_name, s))
> +                       continue;
> +
> +               if (of_parse_phandle_with_args(dev->of_node, "mbox",
> +                                              "#mbox-cells", i, &spec))
> +                       continue;
> +
> +               chan = NULL;
> +               list_for_each_entry(mbox, &mbox_cons, node)
> +                       if (mbox->dev->of_node == spec.np) {
> +                               chan = mbox->of_xlate(mbox, &spec);
> +                               break;
> +                       }
> +
> +               of_node_put(spec.np);
> +
> +               if (!chan)
> +                       continue;
> +
> +               ret = -EBUSY;
> +               if (!chan->cl && try_module_get(mbox->dev->driver->owner))
> +                       break;
> +       }
> +
> +       if (i == count) {
> +               mutex_unlock(&con_mutex);
> +               return ERR_PTR(ret);
> +       }
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +       chan->msg_free = 0;
> +       chan->msg_count = 0;
> +       chan->active_req = NULL;
> +       chan->cl = cl;
> +       init_completion(&chan->tx_complete);
> +
> +       if (chan->txdone_method == TXDONE_BY_POLL && cl->knows_txdone)
> +               chan->txdone_method |= TXDONE_BY_ACK;
> +
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +
> +       ret = chan->mbox->ops->startup(chan);
> +       if (ret) {
> +               pr_err("Unable to startup the chan (%d)\n", ret);
> +               mbox_free_channel(chan);
> +               chan = ERR_PTR(ret);
> +       }
> +
> +       mutex_unlock(&con_mutex);
> +       return chan;
> +}
> +EXPORT_SYMBOL_GPL(mbox_request_channel);
> +
> +/**
> + * mbox_free_channel - The client relinquishes control of a mailbox
> + *                     channel by this call.
> + * @chan: The mailbox channel to be freed.
> + */
> +void mbox_free_channel(struct mbox_chan *chan)
> +{
> +       unsigned long flags;
> +
> +       if (!chan || !chan->cl)
> +               return;
> +
> +       chan->mbox->ops->shutdown(chan);
> +
> +       /* The queued TX requests are simply aborted, no callbacks are made */
> +       spin_lock_irqsave(&chan->lock, flags);
> +       chan->cl = NULL;
> +       chan->active_req = NULL;
> +       if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
> +               chan->txdone_method = TXDONE_BY_POLL;
> +
> +       module_put(chan->mbox->dev->driver->owner);
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(mbox_free_channel);
> +
> +static struct mbox_chan *
> +of_mbox_index_xlate(struct mbox_controller *mbox,
> +                   const struct of_phandle_args *sp)
> +{
> +       int ind = sp->args[0];
> +
> +       if (ind >= mbox->num_chans)
> +               return NULL;
> +
> +       return &mbox->chans[ind];
> +}
> +
> +/**
> + * mbox_controller_register - Register the mailbox controller
> + * @mbox:      Pointer to the mailbox controller.
> + *
> + * The controller driver registers its communication chans

s/chans/channels.

> + */
> +int mbox_controller_register(struct mbox_controller *mbox)
> +{
> +       int i, txdone;
> +
> +       /* Sanity check */
> +       if (!mbox || !mbox->dev || !mbox->ops || !mbox->num_chans)
> +               return -EINVAL;
> +
> +       if (mbox->txdone_irq)
> +               txdone = TXDONE_BY_IRQ;
> +       else if (mbox->txdone_poll)
> +               txdone = TXDONE_BY_POLL;
> +       else /* It has to be ACK then */
> +               txdone = TXDONE_BY_ACK;
> +
> +       if (txdone == TXDONE_BY_POLL) {
> +               mbox->poll.function = &poll_txdone;
> +               mbox->poll.data = (unsigned long)mbox;
> +               init_timer(&mbox->poll);
> +       }
> +
> +       for (i = 0; i < mbox->num_chans; i++) {
> +               struct mbox_chan *chan = &mbox->chans[i];
> +
> +               chan->cl = NULL;
> +               chan->mbox = mbox;
> +               chan->txdone_method = txdone;
> +               spin_lock_init(&chan->lock);
> +       }
> +
> +       if (!mbox->of_xlate)
> +               mbox->of_xlate = of_mbox_index_xlate;
> +
> +       mutex_lock(&con_mutex);
> +       list_add_tail(&mbox->node, &mbox_cons);
> +       mutex_unlock(&con_mutex);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mbox_controller_register);
> +
> +/**
> + * mbox_controller_unregister - UnRegister the mailbox controller

s/UnRegister/Unregister

> + * @mbox:      Pointer to the mailbox controller.
> + */
> +void mbox_controller_unregister(struct mbox_controller *mbox)
> +{
> +       int i;
> +
> +       if (!mbox)
> +               return;
> +
> +       mutex_lock(&con_mutex);
> +
> +       list_del(&mbox->node);
> +
> +       for (i = 0; i < mbox->num_chans; i++)
> +               mbox_free_channel(&mbox->chans[i]);
> +
> +       if (mbox->txdone_poll)
> +               del_timer_sync(&mbox->poll);
> +
> +       mutex_unlock(&con_mutex);
> +}
> +EXPORT_SYMBOL_GPL(mbox_controller_unregister);
> diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
> new file mode 100644
> index 0000000..77a023f
> --- /dev/null
> +++ b/include/linux/mailbox_client.h
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (C) 2014 Linaro Ltd.

You have 2013 listed as well in the .c file.

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
> +
> +struct mbox_chan;
> +
> +/**
> + * struct mbox_client - User of a mailbox
> + * @dev:               The client device
> + * @chan_name:         The string token to identify a channel out of more
> + *                     than one specified for the client via DT
> + * @tx_block:          If the mbox_send_message should block until data is
> + *                     transmitted.
> + * @tx_tout:           Max block period in ms before TX is assumed failure
> + * @knows_txdone:      if the client could run the TX state machine. Usually

s/if/If

> + *                     if the client receives some ACK packet for transmission.
> + *                     Unused if the controller already has TX_Done/RTR IRQ.
> + * @rx_callback:       Atomic callback to provide client the data received

s/the/with

> + * @tx_done:           Atomic callback to tell client of data transmission
> + */
> +struct mbox_client {
> +       struct device *dev;
> +       const char *chan_name;
> +       bool tx_block;
> +       unsigned long tx_tout;
> +       bool knows_txdone;
> +
> +       void (*rx_callback)(struct mbox_client *cl, void *mssg);
> +       void (*tx_done)(struct mbox_client *cl, void *mssg, int r);
> +};
> +
> +struct mbox_chan *mbox_request_channel(struct mbox_client *cl);
> +int mbox_send_message(struct mbox_chan *chan, void *mssg);
> +void mbox_client_txdone(struct mbox_chan *chan, int r);
> +bool mbox_client_peek_data(struct mbox_chan *chan);
> +void mbox_free_channel(struct mbox_chan *chan);
> +
> +#endif /* __MAILBOX_CLIENT_H */
> diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
> new file mode 100644
> index 0000000..f65ff05
> --- /dev/null
> +++ b/include/linux/mailbox_controller.h
> @@ -0,0 +1,128 @@
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
> +
> +struct mbox_chan;
> +
> +/**
> + * struct mbox_chan_ops - methods to control mailbox channels
> + * @send_data: The API asks the MBOX controller driver, in atomic
> + *             context try to transmit a message on the bus. Returns 0 if
> + *             data is accepted for transmission, -EBUSY while rejecting
> + *             if the remote hasn't yet read the last data sent. Actual
> + *             transmission of data is reported by the controller via
> + *             mbox_chan_txdone (if it has some TX ACK irq). It must not
> + *             block.
> + * @startup:   Called when a client requests the chan. The controller
> + *             could ask clients for additional parameters of communication
> + *             to be provided via client's chan_data. This call may
> + *             block. After this call the Controller must forward any
> + *             data received on the chan by calling mbox_chan_received_data.
> + * @shutdown:  Called when a client relinquishes control of a chan.
> + *             This call may block too. The controller must not forwared

s/forwared/forward

> + *             any received data anymore.
> + * @last_tx_done: If the controller sets 'txdone_poll', the API calls
> + *               this to poll status of last TX. The controller must
> + *               give priority to IRQ method over polling and never
> + *               set both txdone_poll and txdone_irq. Only in polling
> + *               mode 'send_data' is expected to return -EBUSY.
> + *               Used only if txdone_poll:=true && txdone_irq:=false
> + * @peek_data: Atomic check for any received data. Return true if controller
> + *               has some data to push to the client. False otherwise.
> + */
> +struct mbox_chan_ops {
> +       int (*send_data)(struct mbox_chan *chan, void *data);
> +       int (*startup)(struct mbox_chan *chan);
> +       void (*shutdown)(struct mbox_chan *chan);
> +       bool (*last_tx_done)(struct mbox_chan *chan);
> +       bool (*peek_data)(struct mbox_chan *chan);
> +};
> +
> +/**
> + * struct mbox_controller - Controller of a class of communication chans

s/chans/channels

> + * @dev:               Device backing this controller
> + * @ops:               Operators that work on each communication chan
> + * @chans:             Array of channels
> + * @num_chans:         Number of channels in the 'chans' array.
> + * @txdone_irq:                Indicates if the controller can report to API when
> + *                     the last transmitted data was read by the remote.
> + *                     Eg, if it has some TX ACK irq.
> + * @txdone_poll:       If the controller can read but not report the TX
> + *                     done. Ex, some register shows the TX status but
> + *                     no interrupt rises. Ignored if 'txdone_irq' is set.
> + * @txpoll_period:     If 'txdone_poll' is in effect, the API polls for
> + *                     last TX's status after these many millisecs
> + * @of_xlate:          Controller driver specific mapping of channel via DT
> + * @poll:              API private. Used to poll for TXDONE on all channels.
> + * @period:            API private. Polling period.
> + * @node:              API private. To hook into list of controllers.
> + */
> +struct mbox_controller {
> +       struct device *dev;
> +       struct mbox_chan_ops *ops;
> +       struct mbox_chan *chans;
> +       int num_chans;
> +       bool txdone_irq;
> +       bool txdone_poll;
> +       unsigned txpoll_period;
> +       struct mbox_chan *(*of_xlate)(struct mbox_controller *mbox,
> +                                     const struct of_phandle_args *sp);
> +       /* Internal to API */
> +       struct timer_list poll;
> +       unsigned period;
> +       struct list_head node;
> +};
> +
> +/*
> + * The length of circular buffer for queuing messages from a client.
> + * 'msg_count' tracks the number of buffered messages while 'msg_free'
> + * is the index where the next message would be buffered.
> + * We shouldn't need it too big because every transferr is interrupt

s/transferr/transfer

> + * triggered and if we have lots of data to transfer, the interrupt
> + * latencies are going to be the bottleneck, not the buffer length.

This is misleading and confusing. Transfers can be polled to completion as well.

> + * Besides, mbox_send_message could be called from atomic context and
> + * the client could also queue another message from the notifier 'tx_done'
> + * of the last transfer done.

Not quite sure what you're trying to say here.


> + * REVIST: If too many platforms see the "Try increasing MBOX_TX_QUEUE_LEN"

s/REVIST/REVISIT/

> + * print, it needs to be taken from config option or somesuch.

perhaps kconfig?

> + */
> +#define MBOX_TX_QUEUE_LEN      20
> +
> +/**
> + * struct mbox_chan - s/w representation of a communication chan

s/chan/channel

> + * @mbox:              Pointer to the parent/provider of this channel
> + * @txdone_method:     Way to detect TXDone chosen by the API
> + * @cl:                        Pointer to the current owner of this channel
> + * @tx_complete:       Transmission completion
> + * @active_req:                Currently active request hook
> + * @msg_count:         No. of mssg currently queued
> + * @msg_free:          Index of next available mssg slot
> + * @msg_data:          Hook for data packet
> + * @lock:              Serialise access to the channel
> + * @con_priv:          Hook for controller driver to attach private data
> + */
> +struct mbox_chan {
> +       struct mbox_controller *mbox;
> +       unsigned txdone_method;
> +       struct mbox_client *cl;
> +       struct completion tx_complete;
> +       void *active_req;
> +       unsigned msg_count, msg_free;
> +       void *msg_data[MBOX_TX_QUEUE_LEN];
> +       spinlock_t lock; /* Serialise access to the channel */
> +       void *con_priv;
> +};
> +
> +int mbox_controller_register(struct mbox_controller *mbox);
> +void mbox_controller_unregister(struct mbox_controller *mbox);
> +void mbox_chan_received_data(struct mbox_chan *chan, void *data);
> +void mbox_chan_txdone(struct mbox_chan *chan, int r);
> +
> +#endif /* __MAILBOX_CONTROLLER_H */
> --
> 1.8.1.2
>

Hopefully you've run this through checkpatch as well? Also, were you
able to sort out the process of getting this stuff hosted on Linaro's
git servers? or elsewhere? It would really help maintainers to pick
this up and for others to rebase on top of your changes.

Cheers,
Ashwin
