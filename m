Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaBRHNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 02:13:09 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:44068 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaBRHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 02:13:06 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2014 02:13:06 EST
MIME-Version: 1.0
In-Reply-To: <20140218005217.GJ1706@sonymobile.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
	<1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
	<20140218005217.GJ1706@sonymobile.com>
Date: Tue, 18 Feb 2014 12:36:55 +0530
Message-ID: <CAJe_ZhdAVK2Yar9kVmbVQLD_JBm9KFzvfv5S0Ba-AXsPEO9HsA@mail.gmail.com>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Courtney,

On 18 February 2014 06:22, Courtney Cavin <courtney.cavin@sonymobile.com> wrote:
> On Sat, Feb 15, 2014 at 07:25:27PM +0100, Jassi Brar wrote:

>> +request_token_t ipc_send_message(void *channel, void *mssg)
>> +{
>> +       struct ipc_chan *chan = (struct ipc_chan *)channel;
>> +       request_token_t t;
>> +
>> +       if (!chan || !chan->assigned)
>> +               return 0;
>
> 0 is not an error in my book.  Please make this more obvious, or define
> something which categorizes this as an error.
>
The returned value is index+1 of the slot assigned for message. Yeah
we could mention that in kerneldoc for the api or make it something <0

>> +void *ipc_request_channel(struct ipc_client *cl)
>> +{
>> +       struct ipc_chan *chan;
>> +       struct ipc_con *con;
>> +       unsigned long flags;
>> +       char *con_name;
>> +       int len, ret;
>> +
>> +       con_name = cl->chan_name;
>> +       len = strcspn(cl->chan_name, ":");
>> +
>> +       ret = 0;
>> +       mutex_lock(&con_mutex);
>> +       list_for_each_entry(con, &ipc_cons, node)
>> +               if (!strncmp(con->name, con_name, len)) {
>> +                       ret = 1;
>> +                       break;
>> +               }
>> +       mutex_unlock(&con_mutex);
>> +
>> +       if (!ret) {
>> +               pr_info("Channel(%s) not found!\n", cl->chan_name);
>> +               return NULL;
>
> ERR_PTR(-ENODEV) would be better.
>
Thanks, good point.

>> +       }
>> +
>> +       ret = 0;
>> +       list_for_each_entry(chan, &con->channels, node) {
>> +               if (!strcmp(con_name + len + 1, chan->name)
>> +                               && !chan->assigned) {
>
> Move the !chan->assigned check first, so we can skip the strcmp if not
> needed.
>
It was indeed that way in previous revision, somehow overlooked that
in haste to resubmit by that day. Thanks.

>> +                       spin_lock_irqsave(&chan->lock, flags);
>> +                       chan->msg_free = 0;
>> +                       chan->msg_count = 0;
>> +                       chan->active_req = NULL;
>> +                       chan->rxcb = cl->rxcb;
>> +                       chan->txcb = cl->txcb;
>> +                       chan->cl_id = cl->cl_id;
>> +                       chan->assigned = true;
>> +                       chan->tx_block = cl->tx_block;
>
> Copying all of this data is unnecessary, and prone to error.  Just point
> to 'cl' in the client struct.
>
That did occur to me. But I chose to have controller specify its
attributes from lower layer and the client from upper layer. The api
basically works on channels... which get their
functionality/limitations from controllers+clients and save them in
their own structure. That also helps 'submit message and moveon' type
clients.

>> +                       if (!cl->tx_tout)
>> +                               chan->tx_tout = msecs_to_jiffies(3600000);
>
> An hour!?  Arbitrary, and extremely long.  Either this should be
> indefinite, or there should be a reasonably small value here.
>
Ideally the client _should_ specify the timeout. Here the default 1hr
is infinity, roughly speaking.
What value do you suggest?

>> +                       else
>> +                               chan->tx_tout = msecs_to_jiffies(cl->tx_tout);
>> +                       if (chan->txdone_method == TXDONE_BY_POLL
>> +                                       && cl->knows_txdone)
>> +                               chan->txdone_method |= TXDONE_BY_ACK;
>> +                       spin_unlock_irqrestore(&chan->lock, flags);
>> +                       ret = 1;
>> +                       break;
>> +               }
>> +       }
>> +
>> +       if (!ret) {
>> +               pr_err("Unable to assign mailbox(%s)\n", cl->chan_name);
>> +               return NULL;
>
> ERR_PTR(-EBUSY) if busy, ERR_PTR(-ENODEV) if unavailable.
>
Yeah that'll be better.

>> +       }
>> +
>> +       ret = chan->link_ops->startup(chan->link, cl->link_data);
>> +       if (ret) {
>> +               pr_err("Unable to startup the link\n");
>> +               ipc_free_channel((void *)chan);
>> +               return NULL;
>
> ERR_PTR(ret);
>
Yup

>> +int ipc_links_register(struct ipc_controller *ipc)
>> +{
>> +       int i, num_links, txdone;
>> +       struct ipc_chan *chan;
>> +       struct ipc_con *con;
>> +
>> +       /* Sanity check */
>> +       if (!ipc || !ipc->ops)
>
> You probably want to check for !ipc->links here too, as you immediately
> dereference it.
>
Yeah, right. Thanks.

>> +               return -EINVAL;
>> +
>> +       for (i = 0; ipc->links[i]; i++)
>
> So you require a NULL node at the end?  Why not have a nlinks/num_links
> in the controller struct?  It would save having to count here.
>
Rather I find that noisy. Why add variables that we can do without?
Especially when the variable would be used just once.

>> +
>> +       chan = (void *)con + sizeof(*con);
>> +       for (i = 0; i < num_links; i++) {
>> +               chan[i].con = con;
>> +               chan[i].assigned = false;
>> +               chan[i].link_ops = ipc->ops;
>> +               chan[i].link = ipc->links[i];
>> +               chan[i].txdone_method = txdone;
>> +               chan[i].link->api_priv = &chan[i];
>> +               spin_lock_init(&chan[i].lock);
>> +               BLOCKING_INIT_NOTIFIER_HEAD(&chan[i].avail);
>> +               list_add_tail(&chan[i].node, &con->channels);
>
> Why not have all of this data exposed in the link definition, so you
> don't need this list, and can represent it as a pre-populated array?
>
Because the api choose to work only in terms of ipc channels. Infact
in previous revision there was just one global pool of channels that
the api managed. Suman Anna insisted we manage channels in controllers
so it makes searching easier.

>> +               snprintf(chan[i].name, 16, "%s", ipc->links[i]->link_name);
>> +       }
>> +
>> +       mutex_lock(&con_mutex);
>> +       list_add_tail(&con->node, &ipc_cons);
>> +       mutex_unlock(&con_mutex);
>> +
>> +       return 0;
>
> You should have a try_module_get() somewhere in this function, and
> module_put() somewhere in unregister.
>
Thanks. Yes we need to keep reference held.

>> +
>> +#ifndef __MAILBOX_H
>> +#define __MAILBOX_H
>> +
>> +enum xfer_result {
>> +       XFER_OK = 0,
>> +       XFER_ERR,
>> +};
>
> This is not the only framework which does 'xfer's, please add a prefix
> to this enum and values.
>
OK, will do.

>> +
>> +typedef unsigned request_token_t;
>> +
>
> Likewise, if needed.
>
OK, will do.

>> +/**
>> + * struct ipc_client - User of a mailbox
>> + * @chan_name: the "controller:channel" this client wants
>
> Uh, not a consumer name?  See comment on ipc_request_channel().
>
Yeah no consumer name. The controller driver gets to name its
channels, a client simply uses them.

>> + * @cl_id: The identity to associate any tx/rx data with
>> + * @rxcb: atomic callback to provide client the data received
>> + * @txcb: atomic callback to tell client of data transmission
>> + * @tx_block: if the ipc_send_message should block until data is transmitted
>> + * @tx_tout: Max block period in ms before TX is assumed failure
>> + * @knows_txdone: if the client could run the TX state machine. Usually if
>> + *    the client receives some ACK packet for transmission. Unused if the
>> + *    controller already has TX_Done/RTR IRQ.
>> + * @link_data: Optional controller specific parameters during channel request
>> + */
>> +struct ipc_client {
>
> I'm not so sure about the naming scheme here.  This header is
> mailbox_client.h, and drivers are expected to go in drivers/mailbox, yet the
> structs and functions have an ipc_ prefix.  Please standardize this,
> preferably to mbox_ or mailbox_.
>
Yeah Loic already pointed that out.
The term 'mailbox' is specific to what ARM calls the IPC links in
their manuals. Perhaps we should rename the directory to drivers/ipc/.
 'Mailbox' is too symbolic. Though I am OK either way.

>> +       char *chan_name;
>
> const?
>
OK.

>> +       void *cl_id;
>
> Like Greg already mentioned, this is ugly.  My recommendation would be
> to not have a "client_data" pointer here at all, and instead store a
> pointer to this struct in the ipc_chan struct.  Then you could just use
> a pointer to this struct in the callback function.
>
I realize I replied to Greg the role of link_data. Sorry Greg.
'cl_id' is what the client would like to associate the TX/RX callbacks
with. Thanks to Suman for bringing up the use-case where he needed
common callback functions for different clients.
'void *' is because the generic api could never know the type of
structure the client would embed its private data in.

>> +       void (*rxcb)(void *cl_id, void *mssg);
>> +       void (*txcb)(void *cl_id, void *mssg, enum xfer_result r);
>
> I don't believe we've run out of vowels....  Please make these names
> more verbose.
>
Reading rxcb/txcb in this code, did you think of anything other than
'receive_callback/transmit_callback'? What was it?

> Additionally, is there an actual use-case for having an async tx-done
> callback?
>
Yes, some client might need to submit a 'beacon' type message.

>         a) calling the blocking API, since you would have to manage that
>            in your own context, just like tx-done
>         b) not caring about tx-done?  It seems your code supports this.
>
>> +       bool tx_block;
>
> This should be a parameter to ipc_send_message()... see comment below.
>
>> +       unsigned long tx_tout;
>
> 'tx_timeout' I think would be a more descriptive name.  Although, I
> don't quite understand why the client/consumer would specify this.
>
Perhaps you haven't read the threads of previous revisions.

>> +       bool knows_txdone;
>
> If the client is running the state-machine, this is neither a mailbox,
> nor much of a useful framework for whatever it is the client has
> implemented.  Could you please explain the motivation here?
>
You could have read the code and previous threads that had lots of
use-cases and rationale explained.

Anyways... consider my _real_ use-case that has come to use it.
 My IPC controller can not generate interrupt for TX-Done (when the
message/reply was read by the remote), but it does interrupt when the
remote has sent a message/reply. The client does not run the
state-machine, but it sure can save us from polling for TX-Done when
it know the received packet is reply to its last TX... so it tells the
API the last TX was done and the callback is done much sooner than the
next poll. This feature is solely responsible for keeping the IPC
latency within acceptable limits for my platform.

>> +       void *link_data;
>
> Random opaque data to pass straight through the framework?  This seems like
> a hack.  If this is needed, clearly the framework has not implemented
> something generic enough.
>
Nopes! I strongly suggest you read previous threads.

Here's the rant... in IPC a client doesn't behave only according to
the underlying controller. But to the combination of controller plus
the remote f/w(or the protocol).  For example, one protocol may
specify the remote will 'clear' the packet-location after reading it
while another protocol will not clear it but sends a particular
reply-packet. Since we can not have two drivers for the same
controller, someone has to tell the controller driver how to behave
for the current protocol... and that 'someone' can only be the client.
There can be no generic code that could enumerate all possible
behaviors.

>> +/**
>> + * The Client specifies its requirements and capabilities while asking for
>> + * a channel/mailbox by name. It can't be called from atomic context.
>> + * The channel is exclusively allocated and can't be used by another
>> + * client before the owner calls ipc_free_channel.
>> + */
>> +void *ipc_request_channel(struct ipc_client *cl);
>
> Greg has already commented on the return type here, but there are a few
> further things I don't quite understand.
>
> The lookup key here is the name, which is embedded in the struct.
> While most of the struct seems to define the client, the name defines
> something which seems to be an attribute of the controller.
>
I am not sure you understand. The client specifies which channel of
which controller does it want. The api keeps channels hooked up in
controller bunch. And can figure out which channel to return.

>
> This would also map very cleanly into devicetree bindings, which are
> really needed for this framework.  I would also like to see a
> devm_ variant of this.
>
Yeah we need to move onto device tree mappings if things gets fancy.
Right now we all had simple clients and unique controllers.

>> +
>> +/**
>> + * For client to submit data to the controller destined for a remote
>> + * processor. If the client had set 'tx_block', the call will return
>> + * either when the remote receives the data or when 'tx_tout' millisecs
>> + * run out.
>> + *  In non-blocking mode, the requests are buffered by the API and a
>> + * non-zero token is returned for each queued request. If the queue
>> + * was full the returned token will be 0. Upon failure or successful
>> + * TX, the API calls 'txcb' from atomic context, from which the client
>> + * could submit yet another request.
>
> The doc for this function should probably also mention that it is
> expected that 'mssg' be available for consumption up until the point in
> which tx-done is triggered.
>
OK, I will update the comment.

>> + *  In blocking mode, 'txcb' is not called, effectively making the
>> + * queue length 1. The returned value is 0 if TX timed out, some
>> + * non-zero value upon success.
>> + */
>> +request_token_t ipc_send_message(void *channel, void *mssg);
>
> In the case of the blocking use-case, the function's return type is odd.
> Perhaps, instead of my recommendation above, this could be turned into
> two separate functions: ipc_send_message() and ipc_send_message_async()?
>
In blocking use case, the call will return success (a valid token).
The client sees a valid token and understands that the request was
accepted. And because the client asked it to be a blocking call, it
also understands the TX is successfully completed.  What's odd here?

>> +
>> +/**
>> + * The way for a client to run the TX state machine. This works
>> + * only if the client sets 'knows_txdone' and the IPC controller
>> + * doesn't get an IRQ for TX_Done/Remote_RTR.
>> + */
>> +void ipc_client_txdone(void *channel, enum xfer_result r);
>> +
>> +/**
>> + * The client relinquishes control of a mailbox by this call,
>> + * make it available to other clients.
>> + * The ipc_request/free_channel are light weight calls, so the
>> + * client should avoid holding it when it doesn't need to
>> + * transfer data.
>> + */
>> +void ipc_free_channel(void *channel);
>
> I would tend to disagree with the comment that request/free are
> light-weight, as a mutex lock is (well, should be) held around two
> list lookups for request.  Additionally, it would appear to me that
> since it calls the controllers startup/shutdown callbacks, there's no
> guarantee that bringing-up/down the 'links' is a simple or quick
> procedure.
>
The 'light-weight' comment is not to mean it's atomic. It was to
suggest the call doesn't wait for submitted xfers to complete and any
other api related waits.

If you problem is with the 'light-weight' part, I'll remove it. But
still the clients will behave just as their use-cases are!

> With this in mind, I also don't believe that it would be a good idea to
> avoid holding a channel, as having drivers "trade" channels can very
> easily result in nasty race conditions.
>
There are use-cases that require holding onto a channel (server model)
and there are use-cases that require a client to relieve a channel
immediately after it's done. Seems you are not aware of use-case out
there in the wild (pls read old threads).

>> +
>> +/**
>> + * The client is no more interested in acquiring the channel.
>> + */
>> +void ipc_notify_chan_unregister(const char *name, struct notifier_block *nb);
>> +
>
> I don't understand the purpose of this functionality.  It would seem to
> me that it would either be an error to need a channel that is already
> being used
>
Again ... you are not aware of enough use-cases.

> or the API needs to support having multiple clients per-channel.
>
For platforms with 2 or more clients and each client having to do it's
own transfer... a channel may be busy when a client needs it. So
instead of implementing its own poll mechanism for availability of the
channel, the client could (un)register to be notified when a channel
become available.
BTW, precisely on such platforms a client would like to relieve a
channel as soon as its done... which is anyway a good practice of not
hogging resources.

There are use-cases where a client needs exclusive access to the
channel... no other client should be able to send a message in the
middle of some 'atomic-sequence' that is already in progress. Which is
not possible if the API worked promiscuously. Whereas if the platform
wants it could still emulate the 'server' model(multiple clients per
channel) by having a global client submitting messages on behalf of
other drivers. Again, pls read old threads.

>> +
>> +/**
>> + * struct ipc_link - s/w representation of a communication link
>> + * @link_name: Literal name assigned to the link. Physically
>> + *    identical channels may have the same name.
>
> I do not think "physically identical" is enough here.  One would need to
> know that the endpoint does not care about which channel you use.
> Unfortunately, I think that this would be known more by the client, who
> is attempting to communicate with the other side, then the controller,
>
That part is what 'link_data' is for (provided by the client and
passed onto the controller).

'physically identical' is for controller driver and implies if the
links are equally capable. For example the PL320 has identical links.
A properly written PL320 driver will manage links as floating
resources and assign whichever is free. If the platform makes some
assumptions that need to be communicated via link_data.

>> + * @api_priv: hook for the API to map its private data on the link
>> + *    Controller driver must not touch it.
>> + */
>> +struct ipc_link {
>> +       char link_name[16];
>> +       void *api_priv;
>
> There's no reason here to hide things from the controller; it is not
> normal that we assume driver developers are malicious.  Documentation
> describing that the data is for internal use only is sufficient.
>
It is common practice for an api to provide hooks for private data of
lower layer.

>> +/**
>> + * The controller driver registers its communication links to the
>> + * global pool managed by the API.
>> + */
>> +int ipc_links_register(struct ipc_controller *ipc_con);
>
> I'm not sure about 'links' here, doesn't this function actually register
> a controller, including its links?  Perhaps ipc_controller_register() ?
>
OK, I'll rename it to ipc_controller_register()

>> +/**
>> + * The controller the has IRQ for TX ACK calls this atomic API
>> + * to tick the TX state machine. It works only if txdone_irq
>> + * is set by the controller.
>> + */
>> +void ipc_link_txdone(struct ipc_link *link, enum xfer_result r);
>
> Representing this all as a state machine seems odd, as it removes
> considerable usefulness of the API if the controllers (and in the
> polling case, the clients) need to know about the state machine.
>
This is an _important_ part of API. The controller driver(usually from
irq) need to notify the API that the last tx is done. Please read the
code and make yourself aware of the limitations/functionality of
controllers and protocols out there.

>> +/**
>> + * Purge the links from the global pool maintained by the API.
>> + */
>> +void ipc_links_unregister(struct ipc_controller *ipc_con);
>> +
>> +#endif /* __MAILBOX_CONTROLLER_H */
>
>
> I have added relevant parties from other series related to this.
>
> Although I will admit that I didn't go looking at random code on the
> internet before submitting my series, I did take a look at the previous
> iterations of this submitted for upstream.
>
But you objections (except cosmetic ones) sound like you are not aware
of all use-cases that have been taken care of.

>  I tried to take the comments
> and considerations in mind when designing my version of this framework.
>
> I have tried to be fair with this code review, but as you can see, most
> of the issues I have are resolved in my series.  It is possible that I
> have missed something, as I was not privy to the off-list conversations
> about this particular code, but other than tx-done callbacks and
> polling--which I'm not convinced are necessary--it would appear that my
> series (with the async work) covers all of the intended use-cases here.
> Obviously I am somewhat biased, so I welcome arguments otherwise.
>
Thanks for reviewing the code so critically, but it would have been
much greater help if you had explained if/how your controller/protocol
doesn't work with this api.

Thanks
Jassi
