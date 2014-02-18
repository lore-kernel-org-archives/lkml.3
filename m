Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaBRAuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:50:35 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12116 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbaBRAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:50:34 -0500
Date: Mon, 17 Feb 2014 16:52:18 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
Message-ID: <20140218005217.GJ1706@sonymobile.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
 <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 07:25:27PM +0100, Jassi Brar wrote:
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
>  drivers/mailbox/Makefile           |   4 +
>  drivers/mailbox/mailbox.c          | 534 +++++++++++++++++++++++++++++++++++++
>  include/linux/mailbox.h            |  17 ++
>  include/linux/mailbox_client.h     |  87 ++++++
>  include/linux/mailbox_controller.h | 102 +++++++
>  5 files changed, 744 insertions(+)
>  create mode 100644 drivers/mailbox/mailbox.c
>  create mode 100644 include/linux/mailbox.h
>  create mode 100644 include/linux/mailbox_client.h
>  create mode 100644 include/linux/mailbox_controller.h
> 
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> new file mode 100644
> index 0000000..3082f08
> --- /dev/null
> +++ b/drivers/mailbox/mailbox.c
> @@ -0,0 +1,534 @@
> +/*

No copyright?

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
[...]
> +request_token_t ipc_send_message(void *channel, void *mssg)
> +{
> +       struct ipc_chan *chan = (struct ipc_chan *)channel;
> +       request_token_t t;
> +
> +       if (!chan || !chan->assigned)
> +               return 0;

0 is not an error in my book.  Please make this more obvious, or define
something which categorizes this as an error.

> +
> +       t = _add_to_rbuf(chan, mssg);
> +       if (!t)
> +               pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
> +
> +       _msg_submit(chan);
> +
> +       if (chan->txdone_method == TXDONE_BY_POLL)
> +               poll_txdone((unsigned long)chan->con);
> +
> +       if (chan->tx_block && chan->active_req) {
> +               int ret;
> +               init_completion(&chan->tx_complete);
> +               ret = wait_for_completion_timeout(&chan->tx_complete,
> +                       chan->tx_tout);
> +               if (ret == 0) {
> +                       t = 0;
> +                       tx_tick(chan, XFER_ERR);
> +               }
> +       }
> +
> +       return t;
> +}
[...]
> +void *ipc_request_channel(struct ipc_client *cl)
> +{
> +       struct ipc_chan *chan;
> +       struct ipc_con *con;
> +       unsigned long flags;
> +       char *con_name;
> +       int len, ret;
> +
> +       con_name = cl->chan_name;
> +       len = strcspn(cl->chan_name, ":");
> +
> +       ret = 0;
> +       mutex_lock(&con_mutex);
> +       list_for_each_entry(con, &ipc_cons, node)
> +               if (!strncmp(con->name, con_name, len)) {
> +                       ret = 1;
> +                       break;
> +               }
> +       mutex_unlock(&con_mutex);
> +
> +       if (!ret) {
> +               pr_info("Channel(%s) not found!\n", cl->chan_name);
> +               return NULL;

ERR_PTR(-ENODEV) would be better.

> +       }
> +
> +       ret = 0;
> +       list_for_each_entry(chan, &con->channels, node) {
> +               if (!strcmp(con_name + len + 1, chan->name)
> +                               && !chan->assigned) {

Move the !chan->assigned check first, so we can skip the strcmp if not
needed.

> +                       spin_lock_irqsave(&chan->lock, flags);
> +                       chan->msg_free = 0;
> +                       chan->msg_count = 0;
> +                       chan->active_req = NULL;
> +                       chan->rxcb = cl->rxcb;
> +                       chan->txcb = cl->txcb;
> +                       chan->cl_id = cl->cl_id;
> +                       chan->assigned = true;
> +                       chan->tx_block = cl->tx_block;

Copying all of this data is unnecessary, and prone to error.  Just point
to 'cl' in the client struct.

> +                       if (!cl->tx_tout)
> +                               chan->tx_tout = msecs_to_jiffies(3600000);

An hour!?  Arbitrary, and extremely long.  Either this should be
indefinite, or there should be a reasonably small value here.

> +                       else
> +                               chan->tx_tout = msecs_to_jiffies(cl->tx_tout);
> +                       if (chan->txdone_method == TXDONE_BY_POLL
> +                                       && cl->knows_txdone)
> +                               chan->txdone_method |= TXDONE_BY_ACK;
> +                       spin_unlock_irqrestore(&chan->lock, flags);
> +                       ret = 1;
> +                       break;
> +               }
> +       }
> +
> +       if (!ret) {
> +               pr_err("Unable to assign mailbox(%s)\n", cl->chan_name);
> +               return NULL;

ERR_PTR(-EBUSY) if busy, ERR_PTR(-ENODEV) if unavailable.

> +       }
> +
> +       ret = chan->link_ops->startup(chan->link, cl->link_data);
> +       if (ret) {
> +               pr_err("Unable to startup the link\n");
> +               ipc_free_channel((void *)chan);
> +               return NULL;

ERR_PTR(ret);

> +       }
> +
> +       return (void *)chan;
> +}
[...]
> +int ipc_links_register(struct ipc_controller *ipc)
> +{
> +       int i, num_links, txdone;
> +       struct ipc_chan *chan;
> +       struct ipc_con *con;
> +
> +       /* Sanity check */
> +       if (!ipc || !ipc->ops)

You probably want to check for !ipc->links here too, as you immediately
dereference it.

> +               return -EINVAL;
> +
> +       for (i = 0; ipc->links[i]; i++)

So you require a NULL node at the end?  Why not have a nlinks/num_links
in the controller struct?  It would save having to count here.

> +               ;
> +       if (!i)
> +               return -EINVAL;
> +       num_links = i;
> +
> +       mutex_lock(&con_mutex);
> +       /* Check if already populated */
> +       list_for_each_entry(con, &ipc_cons, node)
> +               if (!strcmp(ipc->controller_name, con->name)) {
> +                       mutex_unlock(&con_mutex);
> +                       return -EINVAL;
> +               }
> +       mutex_unlock(&con_mutex);
> +
> +       con = kzalloc(sizeof(*con) + sizeof(*chan) * num_links, GFP_KERNEL);
> +       if (!con)
> +               return -ENOMEM;
> +
> +       INIT_LIST_HEAD(&con->channels);
> +       snprintf(con->name, 16, "%s", ipc->controller_name);
> +
> +       if (ipc->txdone_irq)
> +               txdone = TXDONE_BY_IRQ;
> +       else if (ipc->txdone_poll)
> +               txdone = TXDONE_BY_POLL;
> +       else /* It has to be ACK then */
> +               txdone = TXDONE_BY_ACK;
> +
> +       if (txdone == TXDONE_BY_POLL) {
> +               con->period = ipc->txpoll_period;
> +               con->poll.function = &poll_txdone;
> +               con->poll.data = (unsigned long)con;
> +               init_timer(&con->poll);
> +       }
> +
> +       chan = (void *)con + sizeof(*con);
> +       for (i = 0; i < num_links; i++) {
> +               chan[i].con = con;
> +               chan[i].assigned = false;
> +               chan[i].link_ops = ipc->ops;
> +               chan[i].link = ipc->links[i];
> +               chan[i].txdone_method = txdone;
> +               chan[i].link->api_priv = &chan[i];
> +               spin_lock_init(&chan[i].lock);
> +               BLOCKING_INIT_NOTIFIER_HEAD(&chan[i].avail);
> +               list_add_tail(&chan[i].node, &con->channels);

Why not have all of this data exposed in the link definition, so you
don't need this list, and can represent it as a pre-populated array?

> +               snprintf(chan[i].name, 16, "%s", ipc->links[i]->link_name);
> +       }
> +
> +       mutex_lock(&con_mutex);
> +       list_add_tail(&con->node, &ipc_cons);
> +       mutex_unlock(&con_mutex);
> +
> +       return 0;

You should have a try_module_get() somewhere in this function, and
module_put() somewhere in unregister.

> +}
[...]
> diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
> new file mode 100644
> index 0000000..232e2c4
> --- /dev/null
> +++ b/include/linux/mailbox.h
> @@ -0,0 +1,17 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MAILBOX_H
> +#define __MAILBOX_H
> +
> +enum xfer_result {
> +       XFER_OK = 0,
> +       XFER_ERR,
> +};

This is not the only framework which does 'xfer's, please add a prefix
to this enum and values.

> +
> +typedef unsigned request_token_t;
> +

Likewise, if needed.

> +#endif /* __MAILBOX_H */
> diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
> new file mode 100644
> index 0000000..c43f2c7
> --- /dev/null
> +++ b/include/linux/mailbox_client.h
> @@ -0,0 +1,87 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MAILBOX_CLIENT_H
> +#define __MAILBOX_CLIENT_H
> +
> +#include <linux/mailbox.h>
> +
> +/**
> + * struct ipc_client - User of a mailbox
> + * @chan_name: the "controller:channel" this client wants

Uh, not a consumer name?  See comment on ipc_request_channel().

> + * @cl_id: The identity to associate any tx/rx data with
> + * @rxcb: atomic callback to provide client the data received
> + * @txcb: atomic callback to tell client of data transmission
> + * @tx_block: if the ipc_send_message should block until data is transmitted
> + * @tx_tout: Max block period in ms before TX is assumed failure
> + * @knows_txdone: if the client could run the TX state machine. Usually if
> + *    the client receives some ACK packet for transmission. Unused if the
> + *    controller already has TX_Done/RTR IRQ.
> + * @link_data: Optional controller specific parameters during channel request
> + */
> +struct ipc_client {

I'm not so sure about the naming scheme here.  This header is
mailbox_client.h, and drivers are expected to go in drivers/mailbox, yet the
structs and functions have an ipc_ prefix.  Please standardize this,
preferably to mbox_ or mailbox_.

> +       char *chan_name;

const?

> +       void *cl_id;

Like Greg already mentioned, this is ugly.  My recommendation would be
to not have a "client_data" pointer here at all, and instead store a
pointer to this struct in the ipc_chan struct.  Then you could just use
a pointer to this struct in the callback function.

> +       void (*rxcb)(void *cl_id, void *mssg);
> +       void (*txcb)(void *cl_id, void *mssg, enum xfer_result r);

I don't believe we've run out of vowels....  Please make these names
more verbose.

Additionally, is there an actual use-case for having an async tx-done
callback?  Couldn't this be entirely solved by either:
	a) calling the blocking API, since you would have to manage that
	   in your own context, just like tx-done
	b) not caring about tx-done?  It seems your code supports this.

> +       bool tx_block;

This should be a parameter to ipc_send_message()... see comment below.

> +       unsigned long tx_tout;

'tx_timeout' I think would be a more descriptive name.  Although, I
don't quite understand why the client/consumer would specify this.

> +       bool knows_txdone;

If the client is running the state-machine, this is neither a mailbox,
nor much of a useful framework for whatever it is the client has
implemented.  Could you please explain the motivation here?

> +       void *link_data;

Random opaque data to pass straight through the framework?  This seems like
a hack.  If this is needed, clearly the framework has not implemented
something generic enough.

> +};
> +
> +/**
> + * The Client specifies its requirements and capabilities while asking for
> + * a channel/mailbox by name. It can't be called from atomic context.
> + * The channel is exclusively allocated and can't be used by another
> + * client before the owner calls ipc_free_channel.
> + */
> +void *ipc_request_channel(struct ipc_client *cl);

Greg has already commented on the return type here, but there are a few
further things I don't quite understand.

The lookup key here is the name, which is embedded in the struct.
While most of the struct seems to define the client, the name defines
something which seems to be an attribute of the controller.

The organization of this request/free seems all wrong.  If you look at
other frameworks (e.g clk, regulators, pwm), you'll see that this
doesn't quite fit in.  The accepted behavior seems to be to have a
'consumer name' which *is* an attribute of the client's device, and
simply maps to an index, which then may be used to look up a
mbox/channel in the controller.  The controller then has no need to name
its own channels, as these are usually better named by the communication
for which they are used (i.e. whatever the client driver expects it to
do).

Essentially, this is what I would expect to see here:

struct ipc_chan *ipc_request_channel(struct device *dev,
		const char *con_id, struct ipc_client *client);

Typically, the device and connection id are even optional and can be
NULL under certain conditions.

This would also map very cleanly into devicetree bindings, which are
really needed for this framework.  I would also like to see a
devm_ variant of this.

> +
> +/**
> + * For client to submit data to the controller destined for a remote
> + * processor. If the client had set 'tx_block', the call will return
> + * either when the remote receives the data or when 'tx_tout' millisecs
> + * run out.
> + *  In non-blocking mode, the requests are buffered by the API and a
> + * non-zero token is returned for each queued request. If the queue
> + * was full the returned token will be 0. Upon failure or successful
> + * TX, the API calls 'txcb' from atomic context, from which the client
> + * could submit yet another request.

The doc for this function should probably also mention that it is
expected that 'mssg' be available for consumption up until the point in
which tx-done is triggered.  

> + *  In blocking mode, 'txcb' is not called, effectively making the
> + * queue length 1. The returned value is 0 if TX timed out, some
> + * non-zero value upon success.
> + */
> +request_token_t ipc_send_message(void *channel, void *mssg);

In the case of the blocking use-case, the function's return type is odd.
Perhaps, instead of my recommendation above, this could be turned into
two separate functions: ipc_send_message() and ipc_send_message_async()?

> +
> +/**
> + * The way for a client to run the TX state machine. This works
> + * only if the client sets 'knows_txdone' and the IPC controller
> + * doesn't get an IRQ for TX_Done/Remote_RTR.
> + */
> +void ipc_client_txdone(void *channel, enum xfer_result r);
> +
> +/**
> + * The client relinquishes control of a mailbox by this call,
> + * make it available to other clients.
> + * The ipc_request/free_channel are light weight calls, so the
> + * client should avoid holding it when it doesn't need to
> + * transfer data.
> + */
> +void ipc_free_channel(void *channel);

I would tend to disagree with the comment that request/free are
light-weight, as a mutex lock is (well, should be) held around two
list lookups for request.  Additionally, it would appear to me that
since it calls the controllers startup/shutdown callbacks, there's no
guarantee that bringing-up/down the 'links' is a simple or quick
procedure.

With this in mind, I also don't believe that it would be a good idea to
avoid holding a channel, as having drivers "trade" channels can very
easily result in nasty race conditions.

> +
> +/**
> + * The client make ask the API to be notified when a particular channel
> + * becomes available to be acquired again.
> + */
> +int ipc_notify_chan_register(const char *name, struct notifier_block *nb);
> +
> +/**
> + * The client is no more interested in acquiring the channel.
> + */
> +void ipc_notify_chan_unregister(const char *name, struct notifier_block *nb);
> +

I don't understand the purpose of this functionality.  It would seem to
me that it would either be an error to need a channel that is already
being used, or the API needs to support having multiple clients per-channel.

> +#endif /* __MAILBOX_CLIENT_H */
> diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
> new file mode 100644
> index 0000000..a907467
> --- /dev/null
> +++ b/include/linux/mailbox_controller.h
> @@ -0,0 +1,102 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MAILBOX_CONTROLLER_H
> +#define __MAILBOX_CONTROLLER_H
> +
> +#include <linux/mailbox.h>
> +
> +/**
> + * struct ipc_link - s/w representation of a communication link
> + * @link_name: Literal name assigned to the link. Physically
> + *    identical channels may have the same name.

I do not think "physically identical" is enough here.  One would need to
know that the endpoint does not care about which channel you use.
Unfortunately, I think that this would be known more by the client, who
is attempting to communicate with the other side, then the controller,
which should just opaquely represent a mailbox chip.  I additionally
think that it would be more appropriate to just represent these channels
by index, rather than name, for the same reasons.

> + * @api_priv: hook for the API to map its private data on the link
> + *    Controller driver must not touch it.
> + */
> +struct ipc_link {
> +       char link_name[16];
> +       void *api_priv;

There's no reason here to hide things from the controller; it is not
normal that we assume driver developers are malicious.  Documentation
describing that the data is for internal use only is sufficient.

> +};
[...]
> +struct ipc_controller {
> +       char controller_name[16];

const char *name; should be sufficient here, this shouldn't change.

> +       struct ipc_link_ops *ops;

const

> +       struct ipc_link **links;

const?

> +       bool txdone_irq;
> +       bool txdone_poll;
> +       unsigned txpoll_period;
> +};
> +
> +/**
> + * The controller driver registers its communication links to the
> + * global pool managed by the API.
> + */
> +int ipc_links_register(struct ipc_controller *ipc_con);

I'm not sure about 'links' here, doesn't this function actually register
a controller, including its links?  Perhaps ipc_controller_register() ?

> +/**
> + * After startup and before shutdown any data received on the link
> + * is pused to the API via atomic ipc_link_received_data() API.
> + * The controller should ACK the RX only after this call returns.
> + */
> +void ipc_link_received_data(struct ipc_link *link, void *data);
> +
> +/**
> + * The controller the has IRQ for TX ACK calls this atomic API
> + * to tick the TX state machine. It works only if txdone_irq
> + * is set by the controller.
> + */
> +void ipc_link_txdone(struct ipc_link *link, enum xfer_result r);

Representing this all as a state machine seems odd, as it removes
considerable usefulness of the API if the controllers (and in the
polling case, the clients) need to know about the state machine.

> +/**
> + * Purge the links from the global pool maintained by the API.
> + */
> +void ipc_links_unregister(struct ipc_controller *ipc_con);
> +
> +#endif /* __MAILBOX_CONTROLLER_H */


I have added relevant parties from other series related to this.

Although I will admit that I didn't go looking at random code on the
internet before submitting my series, I did take a look at the previous
iterations of this submitted for upstream.  I tried to take the comments
and considerations in mind when designing my version of this framework.

I have tried to be fair with this code review, but as you can see, most
of the issues I have are resolved in my series.  It is possible that I
have missed something, as I was not privy to the off-list conversations
about this particular code, but other than tx-done callbacks and
polling--which I'm not convinced are necessary--it would appear that my
series (with the async work) covers all of the intended use-cases here.
Obviously I am somewhat biased, so I welcome arguments otherwise.

-Courtney
