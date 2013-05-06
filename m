Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab3EFXvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:51:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55030 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab3EFXvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:51:16 -0400
Message-ID: <518840A2.5000205@ti.com>
Date: Mon, 6 May 2013 18:45:38 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>
CC: Jassi Brar <jassisinghbrar@gmail.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andy Green <andy.green@linaro.org>
Subject: Re: [RFC 2/3] mailbox: Introduce a new common API
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com> <1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org> <51847070.8040400@ti.com> <CAJe_Zhdbnpu9n46s6L5KNFuTb2K87j+V4htKkmHYtBJ6w+etxQ@mail.gmail.com>
In-Reply-To: <CAJe_Zhdbnpu9n46s6L5KNFuTb2K87j+V4htKkmHYtBJ6w+etxQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

On 05/04/2013 02:08 PM, Jassi Brar wrote:
> Hi Suman,
> 
>> Anyway, here is a summary of the open points that we have:
>> 1. Atomic Callbacks:
>> The current code provides some sort of buffering on Tx, but imposes the
>> restriction that the clients do the buffering on Rx. This is main
>> concern for OMAP.
> 
> I am afraid a common API can't do without buffering TX and it can't do
> by buffering RX.

Maybe both these are properties of the controller then.

> 
>  The client(s) can always generate TX requests at a rate greater than
> the API could transmit on the physical link. So as much as we dislike
> it, we have to buffer TX requests, otherwise N clients would.

The current code doesn't support N clients today anyway, and if they are
blocking mode on top of it, it would never need Tx buffering.

>
> OTOH Buffering received packets in the API doesn't help anybody, it
> only incurs unavoidable latencies on clients. Only clients, that need
> to take non-atomic actions upon RX, would need to buffer RX. Other
> clients should not suffer.

As I have explained for OMAP, it is about performing the bottom-half of
the Rx interrupt in the OMAP mailbox controller driver. The clients just
process the message (independent of inherent knowledge that they all
have to behave in a certain way to perform the bottom-half). A single
transport payload used for both Rx and Tx would make the state machine
very simple.

> 
> IMHO if clients on OMAP need to buffer RX, let us keep it OMAP
> specific. If number of such platforms rise in future we could move
> that as an _optional_ helper API on top, that does RX buffering on
> behalf of clients ?

Yeah, that's my idea as well to put this in the OMAP mailbox controller
driver implementation. The IPC stacks on OMAP are quite established
(both in remoteproc and DSP/Bridge - different generations), so I cannot
afford to break the functionality of either of those. This already means
I have to export some API from my controller driver and there is no
other way or now.

> 
>> 2. Support for Shared Clients AND Time-shared Clients:
>> As I said before, we need the framework to be flexible enough to support
>> shared clients. The shared clients may not be applicable for all h/w
>> controllers, where a client has to send a series of operations that
>> needs to be sent to the remote before anyone else can use it. This is a
>> functional integration aspect, and is dictated by the nature of the
>> remote. For the time-shared clients, the remote must have some implicit
>> message protocol where in the remote is able to identify the macro
>> usecase through a specific message. The framework should allow the case
>> of shared clients, with the clients doing their own message demuxing.
>>
>  If the API provides shared ownership of a mailbox, it won't work for
> clients that need exclusive ownership (like 'server' side
> implementation of a protocol).
>  OTOH if the API provides exclusive ownership, it is still possible to
> emulate shared ownership by simply publishing the mailbox handle (void
> *chan) globally. It works for all.

I am not saying provide this always. Have this dictated by the
controller or mailbox (look at my branch). The global publication works
well functionality-wise for Tx, but not so much for Rx. In anycase,
global publication will have its own set of problems - mostly you are
implying another layer of implementation that provides this sharing
capability (since they have to be outside of any single client).

> 
>>
>> 3. Buffering/Size: I think we need to take a re-look at the whole tx
>> buffering mechanism. You are using an array that stores just the
>> pointers, which means that there are underlying assumptions that the
>> clients are keeping their buffer ptrs intact until the duration of the
>> transfer is done. This means that one cannot use local payload
>> variables for messages in the calling functions. I feel this is
>> unnecessary burden on the clients.
>>
> Most of the clients won't queue more than 1 request at a time. And
> then, isn't it only natural that clients don't mess with requests
> after submitting them ?  I see mailbox clients working quite like I2C
> clients.

The OMAP use-cases do this today, so not a good assumption to make. The
OMAP IPC is built upon simple transmitting and processing received
messages separately, we will not be using blocking mode or tx callbacks.
I really don't need the complexity of having to introduce tx callbacks
just because I need to know if my pointer can be freed, as I said - it
eliminates the simplicity of using local variables unless the send API
is blocking. void * works for OMAP since my payloads are only 4 bytes by
themselves (this is a discussion that came up during the earlier series
as well), but this is not flexible enough on the clients-side generally.

> 
>> Secondly, we may not need the logic around client knows_txdone and
>> tx_buffering together. I understand the need for buffering when you have
>> TX_POLL or TX_IRQ, but as far as TX_ACK is concerned, it is a client
>> protocol-level knowledge, and so the tx buffering logic can remain with
>> the client itself. This should simplify the code a little bit and get
>> rid of the ipc_client_txdone API.
>>
> Yeah I had it that way originally. But then I realized we could be
> running an 'ACK Packet' protocol over a controller that supports only
> POLL. In that case the controller's poll doesn't override client's
> knows_txdone because we want the client to cut-short the next poll
> delay as soon as it gets an ACK packet.

I think the same can be achieved from the Rx path upon an interrupt in
the specific controller, without having to introduce the knows_txdone.
It is knowledge intrinsic to a controller/mailbox. I really hope that
there are no controllers where you have to poll for Rx too :)

> 
>> Looking at the current use-cases, I think OMAP might be the only one
>> which needs the buffering. The API that Loic added suggests that he
>> either sends a message and expects a response, or just sends a message
>> if the transport is free (I am not sure if he is using the API that uses
>> buffering currently). PL320 is the same as the first scenario that Loic has.
>>
> Yeah I too expect TX buffering to be very rare.

If so, can we eliminate this for the first pass, and leave it to the
controllers for now or dictate this based on a tx_buffering property? As
I see it, we do not yet have an agreement on the Tx buffering semantics.

> 
>> The other point is regarding the size field, I am not convinced that we
>> can take this out, and leave it between the client and the controller
>> implementation. I think the mailbox core should at least perform a check
>> based on the max size published by a controller driver. Like in the
>> PL320 patch conversion, the for loop for writing the data - how does it
>> know that the provided pointer is atleast 7 ints, and not smaller than
>> that?
>>
> First of all, PL320 is a highly configurable and programmable IP.
> pl320.c is very specific to Highbank's usage, it is not usable as such
> on other platforms. There are many things hardcoded and tacitly
> assumed in the driver. I just changed the API, didn't add anything
> new.

OK, should we be renaming this file accordingly then until another
common user comes along? Also, an appropriate 'depends on' in the Kconfig.

> 
> Secondly, I believe we acknowledged the fact that a client can't do
> without controller specific knowledge. So in proper implementation the
> controller's header would look like
> 
> struct foobar_con_mssg {
>    int datalen; /* size of received packet in bytes */
>    u8 *buf;  /* buffer that holds the packet data */
>     .....
> };
> 
> So instead of telling the API the 'datalen' and the remaining
> structure of each message, we simply pass "struct foobar_con_mssg *"
> as a void* to the API.

This has to be documented very well. And yes, I did acknowledge the
inter-dependencies portion for understanding the packet structure (there
is no way if you have a packet of 6 ints and you expect specific ints
for specific fields). The size and void * are generic enough that can be
present in the core to perform some error checking. The API would be
akin to memcpy then. The other motivation is based on the buffering
scheme (same comment as above on Tx buffering), which we haven't agreed
upon completely.

> 
> 
>>> +
>>> +/*
>>> + * Called by a client to "put data on the h/w channel" so that if
>>> + * everything else is fine we don't need to do anything more locally
>>> + * for the remote to receive the data intact.
>>> + * In reality, the remote may receive it intact, corrupted or not at all.
>>> + * This could be called from atomic context as it simply
>>> + * queues the data and returns a token (request_token_t)
>>> + * against the request.
>>> + * The client is later notified of successful transmission of
>>> + * data over the channel via the 'txcb'. The client could in
>>> + * turn queue more messages from txcb.
>>> + */
>>> +request_token_t ipc_send_message(void *channel, void *data)
>>> +{
>>> +     struct ipc_chan *chan = (struct ipc_chan *)channel;
>>> +     request_token_t t;
>>> +
>>> +     if (!chan)
>>> +             return 0;
>>> +
>>> +     t = _add_to_rbuf(chan, data);
>>> +     if (!t)
>>> +             printk("Try increasing MBOX_TX_QUEUE_LEN\n");
>>> +
>>> +     _msg_submit(chan);
>>> +
>>> +     if (chan->txdone_method == TXDONE_BY_POLL)
>>> +             poll_txdone((unsigned long)chan->timer);
>>> +
>>> +     if (chan->tx_block && chan->active_token) {
>>
>> Assigning the tx_block at channel request time might not be flexible
>> enough. We should not impose that the client will request and release
>> channels with different modes if both scenarios are needed.
>>
> If there is one blocking request, no more could arrive (blocking or
> non-blocking).

Well, you are assuming that there is only one thread from within the
client driver who is gonna use the send API. There is nothing in the
code that stops from say two threads/contexts queueing in the message
from the same client driver. I am ok from my side for this to be sorted
out later, since I won't be using the blocking mode, but I do have two
threads (in DSPBridge driver) that will do a send.

 The increased code complexity doesn't justify the
> rarely used feature. I don't see many use-cases when the client can't
> release-request the channel. It's made like opening a file - blocking
> vs non-blocking is the mode you open the resource.
> 
>>> +             int ret;
>>> +             init_completion(&chan->tx_complete);
>>> +             ret = wait_for_completion_timeout(&chan->tx_complete,
>>> +                     chan->tx_tout);
>>> +             if (ret == 0) {
>>> +                     t = 0;
>>> +                     tx_tick(chan, XFER_ERR);
>>> +             }
>>> +     }
>>> +
>>> +     return t;
>>> +}
>>> +EXPORT_SYMBOL(ipc_send_message);
>>
>> Do we need to add an API similar to mailbox_msg_send_receive_no_irq, or
>> are you leaving it to be client's responsibility?
>>
> Yes the API provides enough ways for a client to do that.

I will let Loic comment on this, based on his usage/complexity in the
client. I think you got lucky with PL320 implementation since it fills
in the buffer on a Tx done, so you have folded that functionality in
send_data itself.

> 
>>> +void *ipc_request_channel(struct ipc_client *cl)
>>> +{
>>> +     struct ipc_chan *chan;
>>> +     unsigned long flags;
>>> +     int ret = 0;
>>> +
>>> +     mutex_lock(&chpool_mutex);
>>> +
>>> +     list_for_each_entry(chan, &ipc_channels, node)
>> I had a different design in mind here, maintain the list of controllers
>> globally instead of the channels, that way your search can be a bit
>> quicker.
>>
> Yeah, I changed that to it last minute :)
> The API has no real use of controller nodes, it works solely on a
> global pool of mailboxes. I tried to reflect that in code.

Can we go back to using controller nodes? I understand that the API
doesn't use much, but the list of controller nodes is gonna be static
anyway in the file. It just improves the search algorithm when looking
for a mailbox. We have a new device coming up (u-boot patches already
submitted) wherein we have 13 controller instances, each with about 4 to
6 links, a linear search would be really painful.

> 
> 
>>> + * @cntlr_data: Optional controller specific parameters during channel request
>>> + */
>>> +struct ipc_client {
>>> +     char *chan_name;
>>> +     void (*rxcb)(void *data);
>>> +     void (*txcb)(request_token_t t, enum xfer_result r);
>>> +     bool tx_block;
>>> +     unsigned long tx_tout;
>>> +     bool knows_txdone;
>>> +     void *cntlr_data;
>>
>> What is the current use-case for exposing cntrl_data through ipc_client?
>> I think this should be avoided and leave the controller configuration to
>> the controller driver implementation. This will be a problem for
>> multiple link scenarios.
>>
> There are some highly programmable controllers that, if the driver is
> proper, could change behavior runtime. For ex, if the controller
> supports, a client might want to broadcast messages to multiple
> remotes or listen for messages from more than one remote source or
> both. The client could, say, specify bitmasks for such source/sink
> remotes via cntlr_data while requesting the mailbox.  PL320 could work
> in such mode if rest all fits.

Are you configuring the specific mailbox or configuring the controller
on a whole in this particular example?

> 
> 
>>> +struct ipc_link {
>>> +     char link_name[16];
>>> +     void *api_priv;
>>> +};
>>
>> this definitely needs a link-private void *ptr. PL320 doesn't have
>> multiple links in the controller, but this is a problem for OMAP & DBX500.
>>
> The API keeps the ipc_link provided by the controller driver, which
> could have it embedded in its private representation of the h/w links.
>  For ex, my controller has 6 links, and its structure contains 6
> element array of 'struct myhw_link' which embeds an ipc_link. And I
> use container_of().

Ofcourse, that works. But I was trying to avoid it, since it streamlines
the controller implementation better - it can avoid managing another
variable to pass the links just for registration (especially if I have
to dynamically create them), and also manage the creation/static
declaration of the actual links. The mailbox/ipc core is anyway
constructing a ipc_chan above this link, and doesn't use it directly for
anything.

> 
>>> +struct ipc_link_ops {
>>> +     int (*send_data)(struct ipc_link *link, void *data);
>>> +     int (*startup)(struct ipc_link *link, void *params);
>>> +     void (*shutdown)(struct ipc_link *link);
>>> +     bool (*last_tx_done)(struct ipc_link *link);
>> minor comment, maybe rename this to something that indicates link
>> busyness or readiness
>>
> The API gives the controller only one TX at a time, so I chose the
> name. What do you suggest?

how about 'is_ready', i think it is a bit more generic name and
automatically implies there are no pending tx.

>>> +};
>>> +
>>> +/**
>>> + * struct ipc_controller - Controller of a class of communication links
>>> + * @controller_name: Literal name of the controller.
>>> + * @ops: Operators that work on each communication link
>>> + * @links: Null terminated array of links.
>>> + * @txdone_irq: Indicates if the controller can report to API when the
>>> + *    last transmitted data was read by the remote. Eg, if it has some
>>> + *    TX ACK irq.
>>> + * @txdone_poll: If the controller can read but not report the TX done.
>>> + *    Eg, is some register shows the TX status but no interrupt rises.
>>> + *    Ignored if 'txdone_irq' is set.
>>> + * @txpoll_period: If 'txdone_poll' is in effect, the API polls for
>>> + *    last TX's status after these many millisecs
>>> + */
>>> +struct ipc_controller {
>>> +     char controller_name[16];
>> i think this can be avoided and use the underlying dev-name directly
>> based on the controller device. Adding a struct device pointer would
>> automatically allow you to use the name from the probe.
>>
> Ah ha... yes. Thanks.

Is your intention to leave the dev out to the controller driver specific
structure (atleast from the OMAP example code). I was asking for this to
be part of the ipc_controller structure, use a struct device *dev
instead of controller_name, and construct the controller name from the
dev_name.

> 
>>> +     struct ipc_link_ops *ops;
>> I think this should be a property of the individual link for
>> flexibility. Right now, it probably doesn't make a difference (as seen
>> from the current mailbox code), but the moment we have one link behaving
>> differently this will make the ops implementation a bit messy.
>>
>> I think we also need a controller-specific ops, to put common stuff
>> between multiple links within the controller.
>>
> A controller is assumed to be a bunch of identical links/mailboxes.
> However the cntlr_data could still help the client specify mode in
> which it wants a mailbox behave.

Yeah, assumptions hold true until an unfortunate SoC comes up with it
:). The TI AM3352 has one link that doesn't behave quite like the other
(I am hoping to avoid using it), so I am ok with it for now. Guess we
can always change it when a concrete need arises.

I prefer to see the controller_ops for startup/shutdown atleast. This
will allow the controller code state machine to be much better
maintained and make the code look good. As I said, with our new device,
where we have 13 controllers this will be very helpful. Also from what
Andy explained, you seem to have two controllers that are quite
different from each other.

regards
Suman
