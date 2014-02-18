Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaBRTpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:45:43 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:7105 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbaBRTpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:45:42 -0500
Date: Tue, 18 Feb 2014 11:47:27 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
CC: Jassi Brar <jassisinghbrar@gmail.com>,
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
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
Message-ID: <20140218194726.GK1706@sonymobile.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
 <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
 <20140218005217.GJ1706@sonymobile.com>
 <CAJe_ZhdAVK2Yar9kVmbVQLD_JBm9KFzvfv5S0Ba-AXsPEO9HsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJe_ZhdAVK2Yar9kVmbVQLD_JBm9KFzvfv5S0Ba-AXsPEO9HsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 08:06:55AM +0100, Jassi Brar wrote:
> On 18 February 2014 06:22, Courtney Cavin <courtney.cavin@sonymobile.com> wrote:
> > On Sat, Feb 15, 2014 at 07:25:27PM +0100, Jassi Brar wrote:
> 
> >> +request_token_t ipc_send_message(void *channel, void *mssg)
> >> +{
> >> +       struct ipc_chan *chan = (struct ipc_chan *)channel;
> >> +       request_token_t t;
> >> +
> >> +       if (!chan || !chan->assigned)
> >> +               return 0;
> >
> > 0 is not an error in my book.  Please make this more obvious, or define
> > something which categorizes this as an error.
> >
> The returned value is index+1 of the slot assigned for message. Yeah
> we could mention that in kerneldoc for the api or make it something <0

Please do.

> >> +void *ipc_request_channel(struct ipc_client *cl)
> >> +{
[...]
> >> +                       spin_lock_irqsave(&chan->lock, flags);
> >> +                       chan->msg_free = 0;
> >> +                       chan->msg_count = 0;
> >> +                       chan->active_req = NULL;
> >> +                       chan->rxcb = cl->rxcb;
> >> +                       chan->txcb = cl->txcb;
> >> +                       chan->cl_id = cl->cl_id;
> >> +                       chan->assigned = true;
> >> +                       chan->tx_block = cl->tx_block;
> >
> > Copying all of this data is unnecessary, and prone to error.  Just point
> > to 'cl' in the client struct.
> >
> That did occur to me. But I chose to have controller specify its
> attributes from lower layer and the client from upper layer. The api
> basically works on channels... which get their
> functionality/limitations from controllers+clients and save them in
> their own structure. That also helps 'submit message and moveon' type
> clients.

I understand how this currently works, but I see no reason why one
couldn't simply point to the client struct here, instead of duplicating
the client definition, and copying the data.

I don't see an argument for fire-and-forget clients here.  The lifetime
of the callback and private data must persist, so why not the containing
struct?

> >> +                       if (!cl->tx_tout)
> >> +                               chan->tx_tout = msecs_to_jiffies(3600000);
> >
> > An hour!?  Arbitrary, and extremely long.  Either this should be
> > indefinite, or there should be a reasonably small value here.
> >
> Ideally the client _should_ specify the timeout. Here the default 1hr
> is infinity, roughly speaking.
> What value do you suggest?

An hour is by definition uncountably far from infinity.  The fact that
this may seem like it is infinite in a test setup indicates that this
will cause problems in the future, when/if the timeout occurs.  I
suggest using wait_for_completion() if this is 0, or alternatively a
timeout short enough to trigger easily via testing (e.g. 1 second).

> >> +int ipc_links_register(struct ipc_controller *ipc)
> >> +{
> >> +       int i, num_links, txdone;
> >> +       struct ipc_chan *chan;
> >> +       struct ipc_con *con;
> >> +
> >> +       /* Sanity check */
> >> +       if (!ipc || !ipc->ops)
> >
> > You probably want to check for !ipc->links here too, as you immediately
> > dereference it.
> >
> Yeah, right. Thanks.
> 
> >> +               return -EINVAL;
> >> +
> >> +       for (i = 0; ipc->links[i]; i++)
> >
> > So you require a NULL node at the end?  Why not have a nlinks/num_links
> > in the controller struct?  It would save having to count here.
> >
> Rather I find that noisy. Why add variables that we can do without?
> Especially when the variable would be used just once.

Just like the marker link you need at the end of your array?  It's more
flexible, and easier to understand from an API perspective.

> >> +
> >> +       chan = (void *)con + sizeof(*con);
> >> +       for (i = 0; i < num_links; i++) {
> >> +               chan[i].con = con;
> >> +               chan[i].assigned = false;
> >> +               chan[i].link_ops = ipc->ops;
> >> +               chan[i].link = ipc->links[i];
> >> +               chan[i].txdone_method = txdone;
> >> +               chan[i].link->api_priv = &chan[i];
> >> +               spin_lock_init(&chan[i].lock);
> >> +               BLOCKING_INIT_NOTIFIER_HEAD(&chan[i].avail);
> >> +               list_add_tail(&chan[i].node, &con->channels);
> >
> > Why not have all of this data exposed in the link definition, so you
> > don't need this list, and can represent it as a pre-populated array?
> >
> Because the api choose to work only in terms of ipc channels. Infact
> in previous revision there was just one global pool of channels that
> the api managed. Suman Anna insisted we manage channels in controllers
> so it makes searching easier.

"Legacy reasons" is not a good argument here.  Clearly this code knows
about the relationship between a client and a controller.  Additionally,
it has all the data it needs provided by the controller in an array. Why
not continue using that array?

> >> +               snprintf(chan[i].name, 16, "%s", ipc->links[i]->link_name);
> >> +       }
> >> +
> >> +       mutex_lock(&con_mutex);
> >> +       list_add_tail(&con->node, &ipc_cons);
> >> +       mutex_unlock(&con_mutex);
> >> +
> >> +       return 0;
> >
> > You should have a try_module_get() somewhere in this function, and
> > module_put() somewhere in unregister.
> >
> Thanks. Yes we need to keep reference held.

Sorry, I'm not sure what I was thinking here.  The try_module_get()
should be in request_channel(), and module_put() should be in
free_channel().  Additionally, unregister should return failure if a
channel is currently requested.

> >> +/**
> >> + * struct ipc_client - User of a mailbox
> >> + * @chan_name: the "controller:channel" this client wants
> >
> > Uh, not a consumer name?  See comment on ipc_request_channel().
> >
> Yeah no consumer name. The controller driver gets to name its
> channels, a client simply uses them.

Yes.  I simply don't think this conforms to "typical" kernel frameworks.

> >> +struct ipc_client {
> >
> > I'm not so sure about the naming scheme here.  This header is
> > mailbox_client.h, and drivers are expected to go in drivers/mailbox, yet the
> > structs and functions have an ipc_ prefix.  Please standardize this,
> > preferably to mbox_ or mailbox_.
> >
> Yeah Loic already pointed that out.
> The term 'mailbox' is specific to what ARM calls the IPC links in
> their manuals. Perhaps we should rename the directory to drivers/ipc/.
>  'Mailbox' is too symbolic. Though I am OK either way.

The name 'mailbox' is commonly used to refer to message-queues and is by
no means associated with ARM.  Additionally, this is very clearly not a
generic IPC framework, regardless of your definition of IPC.

> >> +       void *cl_id;
> >
> > Like Greg already mentioned, this is ugly.  My recommendation would be
> > to not have a "client_data" pointer here at all, and instead store a
> > pointer to this struct in the ipc_chan struct.  Then you could just use
> > a pointer to this struct in the callback function.
> >
> I realize I replied to Greg the role of link_data. Sorry Greg.
> 'cl_id' is what the client would like to associate the TX/RX callbacks
> with. Thanks to Suman for bringing up the use-case where he needed
> common callback functions for different clients.
> 'void *' is because the generic api could never know the type of
> structure the client would embed its private data in.

I understand the purpose of the pointer here, I'm just saying it's
unnecessary. Here's my recommendation:

struct ipc_client {
	void (*rxcb)(struct ipc_client *, void *mssg);
	...
};

struct ipc_chan {
	struct ipc_client *client;
	...
};

void call_rx_callback(struct ipc_chan *chan, void *mssg)
{
	chan->client->rxcb(chan->client, mssg);
}

Where a client can implement something like:

struct my_struct {
	struct ipc_client ipc;
	...
};

void my_callback(struct ipc_client *client, void *mssg)
{
	struct my_struct *my = container_of(client, struct my_struct, ipc);
	...
}

> >> +       void (*rxcb)(void *cl_id, void *mssg);
> >> +       void (*txcb)(void *cl_id, void *mssg, enum xfer_result r);
> >
> > I don't believe we've run out of vowels....  Please make these names
> > more verbose.
> >
> Reading rxcb/txcb in this code, did you think of anything other than
> 'receive_callback/transmit_callback'? What was it?

I thought "What the hell is 'rxcb' supposed to represent?"  Shortly
thereafter, I thought "Why the hell is the client receiving TX calls?"
Just because a name may be clear to you, doesn't mean that other people
interpret it the same way.  Even an underscore between 'rx' and 'cb'
would have helped here.  Still, in the efforts of making this code easily
understood, I would recommend something like 'rx_callback' and
'tx_done'.

> > Additionally, is there an actual use-case for having an async tx-done
> > callback?
> >
> Yes, some client might need to submit a 'beacon' type message.

Wouldn't this categorize as condition 'b' below?

> >         a) calling the blocking API, since you would have to manage that
> >            in your own context, just like tx-done
> >         b) not caring about tx-done?  It seems your code supports this.
[...]
> >> +       bool knows_txdone;
> >
> > If the client is running the state-machine, this is neither a mailbox,
> > nor much of a useful framework for whatever it is the client has
> > implemented.  Could you please explain the motivation here?
> >
> You could have read the code and previous threads that had lots of
> use-cases and rationale explained.
> 
> Anyways... consider my _real_ use-case that has come to use it.
>  My IPC controller can not generate interrupt for TX-Done (when the
> message/reply was read by the remote), but it does interrupt when the
> remote has sent a message/reply. The client does not run the
> state-machine, but it sure can save us from polling for TX-Done when
> it know the received packet is reply to its last TX... so it tells the
> API the last TX was done and the callback is done much sooner than the
> next poll. This feature is solely responsible for keeping the IPC
> latency within acceptable limits for my platform.

It sounds to me that at least part of the wire protocol over which your
client communicates is the actual mailbox here, and thus should be
represented in the controller driver itself.  What's underneath seems
more like some generic fifo without any useful mailbox bits.

> >> +       void *link_data;
> >
> > Random opaque data to pass straight through the framework?  This seems like
> > a hack.  If this is needed, clearly the framework has not implemented
> > something generic enough.
> >
> Nopes! I strongly suggest you read previous threads.
> 
> Here's the rant... in IPC a client doesn't behave only according to
> the underlying controller. But to the combination of controller plus
> the remote f/w(or the protocol).  For example, one protocol may
> specify the remote will 'clear' the packet-location after reading it
> while another protocol will not clear it but sends a particular
> reply-packet. Since we can not have two drivers for the same
> controller, someone has to tell the controller driver how to behave
> for the current protocol... and that 'someone' can only be the client.
> There can be no generic code that could enumerate all possible
> behaviors.

Please stop describing this as generic IPC, because it is far from that.
What you are describing is the difference between a driver for a
chip/block, and a wire protocol to use across with/it.  In many cases,
these are completely separate implementations, but they can come in many
different structures:
	- Single driver for generic mailbox controller
	- Driver for bus communication + driver for controller (e.g over i2c)
	- Driver for bus communication +
	  driver for packeted data + driver for controller

The "controller" in the case of this driver should be exposing whatever
combination makes it clearly defined as a "mailbox provider". This is
why it is so very important that this API represents mailboxes.

> >> +/**
> >> + * The Client specifies its requirements and capabilities while asking for
> >> + * a channel/mailbox by name. It can't be called from atomic context.
> >> + * The channel is exclusively allocated and can't be used by another
> >> + * client before the owner calls ipc_free_channel.
> >> + */
> >> +void *ipc_request_channel(struct ipc_client *cl);
> >
> > Greg has already commented on the return type here, but there are a few
> > further things I don't quite understand.
> >
> > The lookup key here is the name, which is embedded in the struct.
> > While most of the struct seems to define the client, the name defines
> > something which seems to be an attribute of the controller.
> >
> I am not sure you understand. The client specifies which channel of
> which controller does it want. The api keeps channels hooked up in
> controller bunch. And can figure out which channel to return.

I do understand.  My point is that naming the channels/links from the
controller isn't the normal method for doing this exact thing.  There's
no reason to expect that a controller can name its channels better than
a consumer can.  Neither should we expect that a client should know the
name of a channel without a binding of some sort.

What I'm recommending here is simply to use the same procedure here many
of the existing frameworks do:
	- controller maintains indexed list of channels
	- client device maintains name -> index mappings (from bindings)
	- client device maintains reference to controller (bindings)

And for platforms without DT support, a global lookup-list similar to
that in regulators and PWM frameworks, based on client device name (and
consumer id).

> >
> > This would also map very cleanly into devicetree bindings, which are
> > really needed for this framework.  I would also like to see a
> > devm_ variant of this.
> >
> Yeah we need to move onto device tree mappings if things gets fancy.
> Right now we all had simple clients and unique controllers.

Please don't underestimate the importance of devicetree support here.
Without it, most new platform/arch support will not be able to use this
framework.

> >> +request_token_t ipc_send_message(void *channel, void *mssg);
> >
> > In the case of the blocking use-case, the function's return type is odd.
> > Perhaps, instead of my recommendation above, this could be turned into
> > two separate functions: ipc_send_message() and ipc_send_message_async()?
> >
> In blocking use case, the call will return success (a valid token).
> The client sees a valid token and understands that the request was
> accepted. And because the client asked it to be a blocking call, it
> also understands the TX is successfully completed.  What's odd here?

The odd part is that one would expect a error/success state, not an id
which can be discarded, or a "nope."

> >> +/**
> >> + * The client relinquishes control of a mailbox by this call,
> >> + * make it available to other clients.
> >> + * The ipc_request/free_channel are light weight calls, so the
> >> + * client should avoid holding it when it doesn't need to
> >> + * transfer data.
> >> + */
> >> +void ipc_free_channel(void *channel);
> >
> > I would tend to disagree with the comment that request/free are
> > light-weight, as a mutex lock is (well, should be) held around two
> > list lookups for request.  Additionally, it would appear to me that
> > since it calls the controllers startup/shutdown callbacks, there's no
> > guarantee that bringing-up/down the 'links' is a simple or quick
> > procedure.
> >
> The 'light-weight' comment is not to mean it's atomic. It was to
> suggest the call doesn't wait for submitted xfers to complete and any
> other api related waits.

Then mention that instead, please.

> If you problem is with the 'light-weight' part, I'll remove it. But
> still the clients will behave just as their use-cases are!
> 
> > With this in mind, I also don't believe that it would be a good idea to
> > avoid holding a channel, as having drivers "trade" channels can very
> > easily result in nasty race conditions.
> >
> There are use-cases that require holding onto a channel (server model)
> and there are use-cases that require a client to relieve a channel
> immediately after it's done. Seems you are not aware of use-case out
> there in the wild (pls read old threads).

Or perhaps I just disagree that these are valid use-cases....

> >> +
> >> +/**
> >> + * The client is no more interested in acquiring the channel.
> >> + */
> >> +void ipc_notify_chan_unregister(const char *name, struct notifier_block *nb);
> >> +
> >
> > I don't understand the purpose of this functionality.  It would seem to
> > me that it would either be an error to need a channel that is already
> > being used
> >
> Again ... you are not aware of enough use-cases.

Thanks.

> > or the API needs to support having multiple clients per-channel.
> >
> For platforms with 2 or more clients and each client having to do it's
> own transfer... a channel may be busy when a client needs it. So
> instead of implementing its own poll mechanism for availability of the
> channel, the client could (un)register to be notified when a channel
> become available.
> BTW, precisely on such platforms a client would like to relieve a
> channel as soon as its done... which is anyway a good practice of not
> hogging resources.
> 
> There are use-cases where a client needs exclusive access to the
> channel... no other client should be able to send a message in the
> middle of some 'atomic-sequence' that is already in progress. Which is
> not possible if the API worked promiscuously. Whereas if the platform
> wants it could still emulate the 'server' model(multiple clients per
> channel) by having a global client submitting messages on behalf of
> other drivers. Again, pls read old threads.

If this server model suits multiple consumers, why would it not suit ...
multiple consumers with cooperative channel sharing?  It's not common
practice in the kernel to continually request/release exclusive access
to a resource.  Exposing a model that encourages this is not a good
idea either as it is very racy, depending on what drivers you have
compiled in.

> >> +
> >> +/**
> >> + * struct ipc_link - s/w representation of a communication link
> >> + * @link_name: Literal name assigned to the link. Physically
> >> + *    identical channels may have the same name.
> >
> > I do not think "physically identical" is enough here.  One would need to
> > know that the endpoint does not care about which channel you use.
> > Unfortunately, I think that this would be known more by the client, who
> > is attempting to communicate with the other side, then the controller,
> >
> That part is what 'link_data' is for (provided by the client and
> passed onto the controller).
> 
> 'physically identical' is for controller driver and implies if the
> links are equally capable. For example the PL320 has identical links.
> A properly written PL320 driver will manage links as floating
> resources and assign whichever is free. If the platform makes some
> assumptions that need to be communicated via link_data.

Here's the key. If the platform is making assumptions, then those
assumptions should be passed directly to the controller driver via
platform data, not through the channel request.

> >> + * @api_priv: hook for the API to map its private data on the link
> >> + *    Controller driver must not touch it.
> >> + */
> >> +struct ipc_link {
> >> +       char link_name[16];
> >> +       void *api_priv;
> >
> > There's no reason here to hide things from the controller; it is not
> > normal that we assume driver developers are malicious.  Documentation
> > describing that the data is for internal use only is sufficient.
> >
> It is common practice for an api to provide hooks for private data of
> lower layer.

Not in the kernel.

> >> +/**
> >> + * The controller driver registers its communication links to the
> >> + * global pool managed by the API.
> >> + */
> >> +int ipc_links_register(struct ipc_controller *ipc_con);
> >
> > I'm not sure about 'links' here, doesn't this function actually register
> > a controller, including its links?  Perhaps ipc_controller_register() ?
> >
> OK, I'll rename it to ipc_controller_register()

I should also mention that this should be attached to a device, as well.
Whether you put a pointer in the ipc_controller struct or in the function
parameters is irrelevant.

> >> +/**
> >> + * The controller the has IRQ for TX ACK calls this atomic API
> >> + * to tick the TX state machine. It works only if txdone_irq
> >> + * is set by the controller.
> >> + */
> >> +void ipc_link_txdone(struct ipc_link *link, enum xfer_result r);
> >
> > Representing this all as a state machine seems odd, as it removes
> > considerable usefulness of the API if the controllers (and in the
> > polling case, the clients) need to know about the state machine.
> >
> This is an _important_ part of API. The controller driver(usually from
> irq) need to notify the API that the last tx is done. Please read the
> code and make yourself aware of the limitations/functionality of
> controllers and protocols out there.

I understand the usefulness of this function call in your design, I was
more commenting on how it is exposed, and especially how it is described
in comment.  It would be nicer if the internal implementation details weren't
necessary to understand to interpret how the API should be used.

> >> +/**
> >> + * Purge the links from the global pool maintained by the API.
> >> + */
> >> +void ipc_links_unregister(struct ipc_controller *ipc_con);
> >> +
> >> +#endif /* __MAILBOX_CONTROLLER_H */
> >
> >
> > I have added relevant parties from other series related to this.
> >
> > Although I will admit that I didn't go looking at random code on the
> > internet before submitting my series, I did take a look at the previous
> > iterations of this submitted for upstream.
> >
> But you objections (except cosmetic ones) sound like you are not aware
> of all use-cases that have been taken care of.

Considering most of my comments are actually cosmetic?

Granted, I do have some concerns about use-cases which I am not convinced are
valid, and I do think that these should be challenged before upstreaming
code to support them.  Even if the use-cases are valid, it might still
be worth discarding them, if we find that they are unique and could
theoretically be implemented better elsewhere.

> >  I tried to take the comments
> > and considerations in mind when designing my version of this framework.
> >
> > I have tried to be fair with this code review, but as you can see, most
> > of the issues I have are resolved in my series.  It is possible that I
> > have missed something, as I was not privy to the off-list conversations
> > about this particular code, but other than tx-done callbacks and
> > polling--which I'm not convinced are necessary--it would appear that my
> > series (with the async work) covers all of the intended use-cases here.
> > Obviously I am somewhat biased, so I welcome arguments otherwise.
> >
> Thanks for reviewing the code so critically, but it would have been
> much greater help if you had explained if/how your controller/protocol
> doesn't work with this api.

DT support...

My main complaint is not that this driver won't work, but rather that
the architecture/design for it doesn't fit with similar APIs.

-Courtney
