Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab3EDTIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 15:08:54 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44967 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3EDTIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 15:08:52 -0400
MIME-Version: 1.0
In-Reply-To: <51847070.8040400@ti.com>
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
	<1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org>
	<51847070.8040400@ti.com>
Date: Sun, 5 May 2013 00:38:51 +0530
Message-ID: <CAJe_Zhdbnpu9n46s6L5KNFuTb2K87j+V4htKkmHYtBJ6w+etxQ@mail.gmail.com>
Subject: Re: [RFC 2/3] mailbox: Introduce a new common API
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andy Green <andy.green@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On 4 May 2013 07:50, Suman Anna <s-anna@ti.com> wrote:
> Hi Jassi,
>
> On 04/27/2013 01:14 PM, jassisinghbrar@gmail.com wrote:
>> From: Jassi Brar <jaswinder.singh@linaro.org>
>>
>> Introduce common framework for client/protocol drivers and
>> controller drivers of Inter-Processor-Communication (IPC).
>>
>> Client driver developers should have a look at
>>  include/linux/mailbox_client.h to understand the part of
>> the API exposed to client drivers.
>> Similarly controller driver developers should have a look
>> at include/linux/mailbox_controller.h
>
> This implementation looks decent based on your design points. These
> are the open/contention points that needs to be sorted out.
>
> I think understanding the OMAP mailbox architecture also helps you,
> since this series currently addressed PL320, but we will run into
> some issues when adopting for OMAP as is. OMAP has a single mailbox IP,
> each with multiple h/w FIFOs (fifo of length 4, and message size of a
> u32). Each IP can cause one or more irq (usually 1) into the linux host.
> It has status registers for number of messages in a FIFO (Rx), FIFO full
> (Tx non-readiness/busy state), and interrupts for both Rx and Tx. There
> are registers indicating the source of the interrupt, and these are per
> FIFO. The Tx interrupt source is really for indicating Tx readiness or
> that a fifo has open room for sending messages. This will keep on firing
> as long as the FIFO is not-full, so we usually configure this only when
> the FIFO is full and disable it the moment it is fired. It is re-enabled
> when the h/w FIFO is full again, and we use s/w buffering in between.
> The Rx interrupt is fired as long as there is a message in any FIFO
> which has been configured to interrupt the host, so we have to empty all
> the messages for that interrupt source.
>
Yeah, thanks for explanation. I've worked on OMAP for almost 2 yrs
now, though not mailbox. I did have a look at the OMAP4430 trm.
 I understand OMAP's MBox doesn't really have TX-Done/RTR interrupt,
it only has "Tx Buffer Not Full" interrupt which serves the purpose
only for the window when there are at least 4 TX messages pending. Now
the driver could switch between Polling and IRQ at runtime depending
upon the buffer filled extent, OR simply work in polling mode all the
time. IMHO the controller driver should opt for the latter.  Though it
might be interesting to profile out of total transfers during a
period, how many are actually queued till depth of 4.


> Anyway, here is a summary of the open points that we have:
> 1. Atomic Callbacks:
> The current code provides some sort of buffering on Tx, but imposes the
> restriction that the clients do the buffering on Rx. This is main
> concern for OMAP.

I am afraid a common API can't do without buffering TX and it can't do
by buffering RX.

 The client(s) can always generate TX requests at a rate greater than
the API could transmit on the physical link. So as much as we dislike
it, we have to buffer TX requests, otherwise N clients would.
 OTOH Buffering received packets in the API doesn't help anybody, it
only incurs unavoidable latencies on clients. Only clients, that need
to take non-atomic actions upon RX, would need to buffer RX. Other
clients should not suffer.

IMHO if clients on OMAP need to buffer RX, let us keep it OMAP
specific. If number of such platforms rise in future we could move
that as an _optional_ helper API on top, that does RX buffering on
behalf of clients ?


> 2. Support for Shared Clients AND Time-shared Clients:
> As I said before, we need the framework to be flexible enough to support
> shared clients. The shared clients may not be applicable for all h/w
> controllers, where a client has to send a series of operations that
> needs to be sent to the remote before anyone else can use it. This is a
> functional integration aspect, and is dictated by the nature of the
> remote. For the time-shared clients, the remote must have some implicit
> message protocol where in the remote is able to identify the macro
> usecase through a specific message. The framework should allow the case
> of shared clients, with the clients doing their own message demuxing.
>
 If the API provides shared ownership of a mailbox, it won't work for
clients that need exclusive ownership (like 'server' side
implementation of a protocol).
 OTOH if the API provides exclusive ownership, it is still possible to
emulate shared ownership by simply publishing the mailbox handle (void
*chan) globally. It works for all.

>
> 3. Buffering/Size: I think we need to take a re-look at the whole tx
> buffering mechanism. You are using an array that stores just the
> pointers, which means that there are underlying assumptions that the
> clients are keeping their buffer ptrs intact until the duration of the
> transfer is done. This means that one cannot use local payload
> variables for messages in the calling functions. I feel this is
> unnecessary burden on the clients.
>
Most of the clients won't queue more than 1 request at a time. And
then, isn't it only natural that clients don't mess with requests
after submitting them ?  I see mailbox clients working quite like I2C
clients.

> Secondly, we may not need the logic around client knows_txdone and
> tx_buffering together. I understand the need for buffering when you have
> TX_POLL or TX_IRQ, but as far as TX_ACK is concerned, it is a client
> protocol-level knowledge, and so the tx buffering logic can remain with
> the client itself. This should simplify the code a little bit and get
> rid of the ipc_client_txdone API.
>
Yeah I had it that way originally. But then I realized we could be
running an 'ACK Packet' protocol over a controller that supports only
POLL. In that case the controller's poll doesn't override client's
knows_txdone because we want the client to cut-short the next poll
delay as soon as it gets an ACK packet.

> Looking at the current use-cases, I think OMAP might be the only one
> which needs the buffering. The API that Loic added suggests that he
> either sends a message and expects a response, or just sends a message
> if the transport is free (I am not sure if he is using the API that uses
> buffering currently). PL320 is the same as the first scenario that Loic has.
>
Yeah I too expect TX buffering to be very rare.

> The other point is regarding the size field, I am not convinced that we
> can take this out, and leave it between the client and the controller
> implementation. I think the mailbox core should at least perform a check
> based on the max size published by a controller driver. Like in the
> PL320 patch conversion, the for loop for writing the data - how does it
> know that the provided pointer is atleast 7 ints, and not smaller than
> that?
>
First of all, PL320 is a highly configurable and programmable IP.
pl320.c is very specific to Highbank's usage, it is not usable as such
on other platforms. There are many things hardcoded and tacitly
assumed in the driver. I just changed the API, didn't add anything
new.

Secondly, I believe we acknowledged the fact that a client can't do
without controller specific knowledge. So in proper implementation the
controller's header would look like

struct foobar_con_mssg {
   int datalen; /* size of received packet in bytes */
   u8 *buf;  /* buffer that holds the packet data */
    .....
};

So instead of telling the API the 'datalen' and the remaining
structure of each message, we simply pass "struct foobar_con_mssg *"
as a void* to the API.


>> +
>> +/*
>> + * Called by a client to "put data on the h/w channel" so that if
>> + * everything else is fine we don't need to do anything more locally
>> + * for the remote to receive the data intact.
>> + * In reality, the remote may receive it intact, corrupted or not at all.
>> + * This could be called from atomic context as it simply
>> + * queues the data and returns a token (request_token_t)
>> + * against the request.
>> + * The client is later notified of successful transmission of
>> + * data over the channel via the 'txcb'. The client could in
>> + * turn queue more messages from txcb.
>> + */
>> +request_token_t ipc_send_message(void *channel, void *data)
>> +{
>> +     struct ipc_chan *chan = (struct ipc_chan *)channel;
>> +     request_token_t t;
>> +
>> +     if (!chan)
>> +             return 0;
>> +
>> +     t = _add_to_rbuf(chan, data);
>> +     if (!t)
>> +             printk("Try increasing MBOX_TX_QUEUE_LEN\n");
>> +
>> +     _msg_submit(chan);
>> +
>> +     if (chan->txdone_method == TXDONE_BY_POLL)
>> +             poll_txdone((unsigned long)chan->timer);
>> +
>> +     if (chan->tx_block && chan->active_token) {
>
> Assigning the tx_block at channel request time might not be flexible
> enough. We should not impose that the client will request and release
> channels with different modes if both scenarios are needed.
>
If there is one blocking request, no more could arrive (blocking or
non-blocking). The increased code complexity doesn't justify the
rarely used feature. I don't see many use-cases when the client can't
release-request the channel. It's made like opening a file - blocking
vs non-blocking is the mode you open the resource.

>> +             int ret;
>> +             init_completion(&chan->tx_complete);
>> +             ret = wait_for_completion_timeout(&chan->tx_complete,
>> +                     chan->tx_tout);
>> +             if (ret == 0) {
>> +                     t = 0;
>> +                     tx_tick(chan, XFER_ERR);
>> +             }
>> +     }
>> +
>> +     return t;
>> +}
>> +EXPORT_SYMBOL(ipc_send_message);
>
> Do we need to add an API similar to mailbox_msg_send_receive_no_irq, or
> are you leaving it to be client's responsibility?
>
Yes the API provides enough ways for a client to do that.

>> +
>> +/*
>> + * A client driver asks for exclusive use of a channel/mailbox.
>> + * If assigned, the channel has to be 'freed' before it could
>> + * be assigned to some other client.
>> + * After assignment, any packet received on this channel will be
>> + * handed over to the client via the 'rxcb' callback.
>> + * The 'txcb' callback is used to notify client upon sending the
>> + * packet over the channel, which may or may not have been yet
>> + * read by the remote processor.
>> + */
>> +void *ipc_request_channel(struct ipc_client *cl)
>> +{
>> +     struct ipc_chan *chan;
>> +     unsigned long flags;
>> +     int ret = 0;
>> +
>> +     mutex_lock(&chpool_mutex);
>> +
>> +     list_for_each_entry(chan, &ipc_channels, node)
> I had a different design in mind here, maintain the list of controllers
> globally instead of the channels, that way your search can be a bit
> quicker.
>
Yeah, I changed that to it last minute :)
The API has no real use of controller nodes, it works solely on a
global pool of mailboxes. I tried to reflect that in code.


>> +
>> +     if (txdone == TXDONE_BY_POLL) {
>> +             timer = kzalloc(sizeof(struct tx_poll_timer), GFP_KERNEL);
>> +             timer->period = ipc_con->txpoll_period;
>> +             timer->poll.function = &poll_txdone;
>> +             timer->poll.data = (unsigned long)timer;
>> +             init_timer(&timer->poll);
>> +     }
>> +
>> +     channel = kzalloc(sizeof(struct ipc_chan) * num_links, GFP_KERNEL);
>
> minor, but you might be aware of this already, failure check needed
>
No, I overlooked. Thanks.


>> +
>> +static int __init ipc_mbox_init(void)
>> +{
>> +     INIT_LIST_HEAD(&ipc_channels);
>> +     return 0;
>> +}
>> +subsys_initcall(ipc_mbox_init);
>
> The ipc_mbox_init can be replaced by static list init of ipc_channels,
> nothing much to be gained by defining this function. We expect the
> mailbox.c to be built anyways whenever the mailbox framework is selected.
>
Yes, you are right. Thanks.

>> + * @cntlr_data: Optional controller specific parameters during channel request
>> + */
>> +struct ipc_client {
>> +     char *chan_name;
>> +     void (*rxcb)(void *data);
>> +     void (*txcb)(request_token_t t, enum xfer_result r);
>> +     bool tx_block;
>> +     unsigned long tx_tout;
>> +     bool knows_txdone;
>> +     void *cntlr_data;
>
> What is the current use-case for exposing cntrl_data through ipc_client?
> I think this should be avoided and leave the controller configuration to
> the controller driver implementation. This will be a problem for
> multiple link scenarios.
>
There are some highly programmable controllers that, if the driver is
proper, could change behavior runtime. For ex, if the controller
supports, a client might want to broadcast messages to multiple
remotes or listen for messages from more than one remote source or
both. The client could, say, specify bitmasks for such source/sink
remotes via cntlr_data while requesting the mailbox.  PL320 could work
in such mode if rest all fits.


>> +struct ipc_link {
>> +     char link_name[16];
>> +     void *api_priv;
>> +};
>
> this definitely needs a link-private void *ptr. PL320 doesn't have
> multiple links in the controller, but this is a problem for OMAP & DBX500.
>
The API keeps the ipc_link provided by the controller driver, which
could have it embedded in its private representation of the h/w links.
 For ex, my controller has 6 links, and its structure contains 6
element array of 'struct myhw_link' which embeds an ipc_link. And I
use container_of().


>> +struct ipc_link_ops {
>> +     int (*send_data)(struct ipc_link *link, void *data);
>> +     int (*startup)(struct ipc_link *link, void *params);
>> +     void (*shutdown)(struct ipc_link *link);
>> +     bool (*last_tx_done)(struct ipc_link *link);
> minor comment, maybe rename this to something that indicates link
> busyness or readiness
>
The API gives the controller only one TX at a time, so I chose the
name. What do you suggest?


>> +};
>> +
>> +/**
>> + * struct ipc_controller - Controller of a class of communication links
>> + * @controller_name: Literal name of the controller.
>> + * @ops: Operators that work on each communication link
>> + * @links: Null terminated array of links.
>> + * @txdone_irq: Indicates if the controller can report to API when the
>> + *    last transmitted data was read by the remote. Eg, if it has some
>> + *    TX ACK irq.
>> + * @txdone_poll: If the controller can read but not report the TX done.
>> + *    Eg, is some register shows the TX status but no interrupt rises.
>> + *    Ignored if 'txdone_irq' is set.
>> + * @txpoll_period: If 'txdone_poll' is in effect, the API polls for
>> + *    last TX's status after these many millisecs
>> + */
>> +struct ipc_controller {
>> +     char controller_name[16];
> i think this can be avoided and use the underlying dev-name directly
> based on the controller device. Adding a struct device pointer would
> automatically allow you to use the name from the probe.
>
Ah ha... yes. Thanks.

>> +     struct ipc_link_ops *ops;
> I think this should be a property of the individual link for
> flexibility. Right now, it probably doesn't make a difference (as seen
> from the current mailbox code), but the moment we have one link behaving
> differently this will make the ops implementation a bit messy.
>
> I think we also need a controller-specific ops, to put common stuff
> between multiple links within the controller.
>
A controller is assumed to be a bunch of identical links/mailboxes.
However the cntlr_data could still help the client specify mode in
which it wants a mailbox behave.

Thanks and Regards.
-Jassi
