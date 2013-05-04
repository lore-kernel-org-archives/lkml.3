Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656Ab3EDC0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 22:26:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40942 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759028Ab3EDC0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 22:26:04 -0400
Message-ID: <51847070.8040400@ti.com>
Date: Fri, 3 May 2013 21:20:32 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: <jassisinghbrar@gmail.com>
CC: <loic.pallardy@st.com>, <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [RFC 2/3] mailbox: Introduce a new common API
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com> <1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org>
In-Reply-To: <1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

On 04/27/2013 01:14 PM, jassisinghbrar@gmail.com wrote:
> From: Jassi Brar <jaswinder.singh@linaro.org>
> 
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
> 
> Client driver developers should have a look at
>  include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h

This implementation looks decent based on your design points. These
are the open/contention points that needs to be sorted out.

I think understanding the OMAP mailbox architecture also helps you,
since this series currently addressed PL320, but we will run into
some issues when adopting for OMAP as is. OMAP has a single mailbox IP,
each with multiple h/w FIFOs (fifo of length 4, and message size of a
u32). Each IP can cause one or more irq (usually 1) into the linux host.
It has status registers for number of messages in a FIFO (Rx), FIFO full
(Tx non-readiness/busy state), and interrupts for both Rx and Tx. There
are registers indicating the source of the interrupt, and these are per
FIFO. The Tx interrupt source is really for indicating Tx readiness or
that a fifo has open room for sending messages. This will keep on firing
as long as the FIFO is not-full, so we usually configure this only when
the FIFO is full and disable it the moment it is fired. It is re-enabled
when the h/w FIFO is full again, and we use s/w buffering in between.
The Rx interrupt is fired as long as there is a message in any FIFO
which has been configured to interrupt the host, so we have to empty all
the messages for that interrupt source.

Anyway, here is a summary of the open points that we have:
1. Atomic Callbacks:
The current code provides some sort of buffering on Tx, but imposes the
restriction that the clients do the buffering on Rx. This is main
concern for OMAP. We have multiple links on a single interrupt and
multiple messages per link on a interrupt source. Pushing this logic
into a client (remoteproc for us) is not right, that code does not
belong to the remoteproc driver, and neither is adding another layer in
between. It also kills the shared clients idea. The current
ipc_link_received_data seems open enough for me to use by calling it
from a work-queue, and have the OMAP controller driver take care of Rx
buffering (will test this next week). Restricting ipc_link_received_data
to atomic callbacks might have been enough for single transport
payloads, but we do have a FIFO. I could possibly make it work using
this API, but it brings me to my next point which is shared clients.

2. Support for Shared Clients AND Time-shared Clients:
As I said before, we need the framework to be flexible enough to support
shared clients. The shared clients may not be applicable for all h/w
controllers, where a client has to send a series of operations that
needs to be sent to the remote before anyone else can use it. This is a
functional integration aspect, and is dictated by the nature of the
remote. For the time-shared clients, the remote must have some implicit
message protocol where in the remote is able to identify the macro
usecase through a specific message. The framework should allow the case
of shared clients, with the clients doing their own message demuxing.

You can take a look at my patches on top of the existing mailbox code
that allows both shared clients and atomic callbacks, and multi-instance
support. It is not that hard to incorporate similar concepts into this
code as well. It is based on properties published by the
controller/link. [I haven't added the tx callbacks and poll method, that
would actually mean I will be doing a very similar state machine to what
you have, no point in me spending time on that, unless we are gonna
absorb the current mailbox series.]

https://github.com/sumananna/mailbox/commits/mailbox-multi-atomic-dt-doc

3. Buffering/Size: I think we need to take a re-look at the whole tx
buffering mechanism. You are using an array that stores just the
pointers, which means that there are underlying assumptions that the
clients are keeping their buffer ptrs intact until the duration of the
transfer is done. This means that one cannot use local payload
variables for messages in the calling functions. I feel this is
unnecessary burden on the clients.

Secondly, we may not need the logic around client knows_txdone and
tx_buffering together. I understand the need for buffering when you have
TX_POLL or TX_IRQ, but as far as TX_ACK is concerned, it is a client
protocol-level knowledge, and so the tx buffering logic can remain with
the client itself. This should simplify the code a little bit and get
rid of the ipc_client_txdone API.

Looking at the current use-cases, I think OMAP might be the only one
which needs the buffering. The API that Loic added suggests that he
either sends a message and expects a response, or just sends a message
if the transport is free (I am not sure if he is using the API that uses
buffering currently). PL320 is the same as the first scenario that Loic has.

The other point is regarding the size field, I am not convinced that we
can take this out, and leave it between the client and the controller
implementation. I think the mailbox core should at least perform a check
based on the max size published by a controller driver. Like in the
PL320 patch conversion, the for loop for writing the data - how does it
know that the provided pointer is atleast 7 ints, and not smaller than
that?

Rest of the comments are in the code...

> 
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> new file mode 100644
> index 0000000..c5ec93e
> --- /dev/null
> +++ b/drivers/mailbox/mailbox.c
> +
> +/*
> + * Called by a client to "put data on the h/w channel" so that if
> + * everything else is fine we don't need to do anything more locally
> + * for the remote to receive the data intact.
> + * In reality, the remote may receive it intact, corrupted or not at all.
> + * This could be called from atomic context as it simply
> + * queues the data and returns a token (request_token_t)
> + * against the request.
> + * The client is later notified of successful transmission of
> + * data over the channel via the 'txcb'. The client could in
> + * turn queue more messages from txcb.
> + */
> +request_token_t ipc_send_message(void *channel, void *data)
> +{
> +	struct ipc_chan *chan = (struct ipc_chan *)channel;
> +	request_token_t t;
> +
> +	if (!chan)
> +		return 0;
> +
> +	t = _add_to_rbuf(chan, data);
> +	if (!t)
> +		printk("Try increasing MBOX_TX_QUEUE_LEN\n");
> +
> +	_msg_submit(chan);
> +
> +	if (chan->txdone_method	== TXDONE_BY_POLL)
> +		poll_txdone((unsigned long)chan->timer);
> +
> +	if (chan->tx_block && chan->active_token) {

Assigning the tx_block at channel request time might not be flexible
enough. We should not impose that the client will request and release
channels with different modes if both scenarios are needed.

> +		int ret;
> +		init_completion(&chan->tx_complete);
> +		ret = wait_for_completion_timeout(&chan->tx_complete,
> +			chan->tx_tout);
> +		if (ret == 0) {
> +			t = 0;
> +			tx_tick(chan, XFER_ERR);
> +		}
> +	}
> +
> +	return t;
> +}
> +EXPORT_SYMBOL(ipc_send_message);

Do we need to add an API similar to mailbox_msg_send_receive_no_irq, or
are you leaving it to be client's responsibility?

> +
> +/*
> + * A client driver asks for exclusive use of a channel/mailbox.
> + * If assigned, the channel has to be 'freed' before it could
> + * be assigned to some other client.
> + * After assignment, any packet received on this channel will be
> + * handed over to the client via the 'rxcb' callback.
> + * The 'txcb' callback is used to notify client upon sending the
> + * packet over the channel, which may or may not have been yet
> + * read by the remote processor.
> + */
> +void *ipc_request_channel(struct ipc_client *cl)
> +{
> +	struct ipc_chan *chan;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	mutex_lock(&chpool_mutex);
> +
> +	list_for_each_entry(chan, &ipc_channels, node)
I had a different design in mind here, maintain the list of controllers
globally instead of the channels, that way your search can be a bit
quicker.

> +		if(!chan->assigned
> +				&& !strcmp(cl->chan_name, chan->chan_name)) {
> +			spin_lock_irqsave(&chan->lock, flags);
> +			chan->msg_free = 0;
> +			chan->msg_count = 0;
> +			chan->active_token = 0;
> +			chan->rxcb = cl->rxcb;
> +			chan->txcb = cl->txcb;
> +			chan->assigned = true;
> +			chan->tx_block = cl->tx_block;
> +			if (!cl->tx_tout)
> +				chan->tx_tout = ~0;
> +			else
> +				chan->tx_tout = msecs_to_jiffies(cl->tx_tout);
> +			if (chan->txdone_method	== TXDONE_BY_POLL
> +					&& cl->knows_txdone)
> +				chan->txdone_method |= TXDONE_BY_ACK;
> +			spin_unlock_irqrestore(&chan->lock, flags);
> +			ret = 1;
> +			break;
> +		}
> +
> +	mutex_unlock(&chpool_mutex);
> +
> +	if (!ret) {
> +		printk("Unable to assign mailbox(%s)\n", cl->chan_name);
> +		return NULL;
> +	}
> +
> +	ret = chan->link_ops->startup(chan->link, cl->cntlr_data);
> +	if (ret) {
> +		printk("Unable to startup the link\n");
> +		ipc_free_channel((void *)chan);
> +		return NULL;
> +	}
> +
> +	return (void *)chan;
> +}
> +EXPORT_SYMBOL(ipc_request_channel);
> +
> +/*
> + * Call for IPC controller drivers to register a controller, adding
> + * its channels/mailboxes to the global pool.
> + */
> +int ipc_links_register(struct ipc_controller *ipc_con)
> +{
> +	struct tx_poll_timer *timer = NULL;
> +	struct ipc_chan *channel;
> +	int i, num_links, txdone;
> +
> +	/* Are you f***ing with us, sir? */
> +	if (!ipc_con || !ipc_con->ops)
> +		return -EINVAL;
> +
> +	for (i = 0; ipc_con->links[i]; i++)
> +		;
> +	if (!i)
> +		return -EINVAL;
> +	num_links = i;
> +
> +	if (ipc_con->txdone_irq)
> +		txdone = TXDONE_BY_IRQ;
> +	else if (ipc_con->txdone_poll)
> +		txdone = TXDONE_BY_POLL;
> +	else /* It has to be at least ACK */
> +		txdone = TXDONE_BY_ACK;
> +
> +	if (txdone == TXDONE_BY_POLL) {
> +		timer = kzalloc(sizeof(struct tx_poll_timer), GFP_KERNEL);
> +		timer->period = ipc_con->txpoll_period;
> +		timer->poll.function = &poll_txdone;
> +		timer->poll.data = (unsigned long)timer;
> +		init_timer(&timer->poll);
> +	}
> +
> +	channel = kzalloc(sizeof(struct ipc_chan) * num_links, GFP_KERNEL);

minor, but you might be aware of this already, failure check needed

> +
> +	for (i = 0; i < num_links; i++) {
> +		channel[i].timer = timer;
> +		channel[i].assigned = false;
> +		channel[i].txdone_method = txdone;
> +		channel[i].link_ops = ipc_con->ops;
> +		channel[i].link = ipc_con->links[i];
> +		channel[i].link->api_priv = &channel[i];
> +		snprintf(channel[i].chan_name, 32, "%s:%s",
> +			ipc_con->controller_name,
> +			ipc_con->links[i]->link_name);
> +		spin_lock_init(&channel[i].lock);
> +		BLOCKING_INIT_NOTIFIER_HEAD(&channel[i].avail);
> +		mutex_lock(&chpool_mutex);
> +		list_add_tail(&channel[i].node, &ipc_channels);
> +		mutex_unlock(&chpool_mutex);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ipc_links_register);
> +
> +static int __init ipc_mbox_init(void)
> +{
> +	INIT_LIST_HEAD(&ipc_channels);
> +	return 0;
> +}
> +subsys_initcall(ipc_mbox_init);

The ipc_mbox_init can be replaced by static list init of ipc_channels,
nothing much to be gained by defining this function. We expect the
mailbox.c to be built anyways whenever the mailbox framework is selected.

> diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
> new file mode 100644
> index 0000000..33545f6
> --- /dev/null
> +++ b/include/linux/mailbox_client.h
> +/**
> + * struct ipc_client - User of a mailbox
> + * @chan_name: the "controller:channel" this client wants
> + * @rxcb: atomic callback to provide client the data received
> + * @txcb: atomic callback to tell client of data transmission
> + * @tx_block: if the ipc_send_message should block until data is transmitted
> + * @tx_tout: Max block period in ms before TX is assumed failure
> + * @knows_txdone: if the client could run the TX state machine. Usually if
> + *    the client receives some ACK packet for transmission. Unused if the
> + *    controller already has TX_Done/RTR IRQ.
> + * @cntlr_data: Optional controller specific parameters during channel request
> + */
> +struct ipc_client {
> +	char *chan_name;
> +	void (*rxcb)(void *data);
> +	void (*txcb)(request_token_t t, enum xfer_result r);
> +	bool tx_block;
> +	unsigned long tx_tout;
> +	bool knows_txdone;
> +	void *cntlr_data;

What is the current use-case for exposing cntrl_data through ipc_client?
I think this should be avoided and leave the controller configuration to
the controller driver implementation. This will be a problem for
multiple link scenarios.

> diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
> new file mode 100644
> index 0000000..defcfb3
> --- /dev/null
> +++ b/include/linux/mailbox_controller.h
> +
> +/**
> + * struct ipc_link - s/w representation of a communication link
> + * @link_name: Literal name assigned to the link. Physically
> + *    identical channels may have the same name.
> + * @api_priv: hook for the API to map its private data on the link
> + *    Controller driver must not touch it.
> + */
> +struct ipc_link {
> +	char link_name[16];
> +	void *api_priv;
> +};

this definitely needs a link-private void *ptr. PL320 doesn't have
multiple links in the controller, but this is a problem for OMAP & DBX500.

> +struct ipc_link_ops {
> +	int (*send_data)(struct ipc_link *link, void *data);
> +	int (*startup)(struct ipc_link *link, void *params);
> +	void (*shutdown)(struct ipc_link *link);
> +	bool (*last_tx_done)(struct ipc_link *link);
minor comment, maybe rename this to something that indicates link
busyness or readiness

> +};
> +
> +/**
> + * struct ipc_controller - Controller of a class of communication links
> + * @controller_name: Literal name of the controller.
> + * @ops: Operators that work on each communication link
> + * @links: Null terminated array of links.
> + * @txdone_irq: Indicates if the controller can report to API when the
> + *    last transmitted data was read by the remote. Eg, if it has some
> + *    TX ACK irq.
> + * @txdone_poll: If the controller can read but not report the TX done.
> + *    Eg, is some register shows the TX status but no interrupt rises.
> + *    Ignored if 'txdone_irq' is set.
> + * @txpoll_period: If 'txdone_poll' is in effect, the API polls for
> + *    last TX's status after these many millisecs
> + */
> +struct ipc_controller {
> +	char controller_name[16];
i think this can be avoided and use the underlying dev-name directly
based on the controller device. Adding a struct device pointer would
automatically allow you to use the name from the probe.

> +	struct ipc_link_ops *ops;
I think this should be a property of the individual link for
flexibility. Right now, it probably doesn't make a difference (as seen
from the current mailbox code), but the moment we have one link behaving
differently this will make the ops implementation a bit messy.

I think we also need a controller-specific ops, to put common stuff
between multiple links within the controller.

> +	struct ipc_link **links;
> +	bool txdone_irq;
> +	bool txdone_poll;
> +	unsigned txpoll_period;
> +};
> +


